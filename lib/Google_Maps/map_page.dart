import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  LatLng? _currentP;
  final TextEditingController _searchController = TextEditingController();

  // Load the API key from dotenv
  late final GoogleGeocodingApi _geocodingApi;

  @override
  void initState() {
    super.initState();
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? ''; // Load API key
    if (apiKey.isEmpty) {
      throw Exception('Google Maps API key not found in .env file');
    }
    _geocodingApi = GoogleGeocodingApi(apiKey); // Initialize API
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          _currentP == null
              ? const Center(child: Text("Loading..."))
              : GoogleMap(
            onMapCreated: (GoogleMapController controller) =>
                _mapController.complete(controller),
            initialCameraPosition: CameraPosition(
              target: _currentP!,
              zoom: 13, // Adjust zoom level
            ),
            markers: {
              Marker(
                markerId: MarkerId("_currentLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: _currentP!,
              ),
            },
          ),
          // Search Bar
          Positioned(
            top: 40, // Adjust the position of the search bar
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  _searchLocation(value);
                },
              ),
            ),
          ),
          // Floating Action Button positioned above the map controls
          Positioned(
            bottom: 100, // Adjust to position above the zoom controls
            right: 8, // Adjust to align with the right side
            child: FloatingActionButton(
              mini: true, // Makes the button smaller
              onPressed: () {
                if (_currentP != null) {
                  _cameraToPosition(_currentP!); // Trigger camera movement when pressed
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> _searchLocation(String query) async {
    try {
      final response = await _geocodingApi.search(query);
      if (response.results.isNotEmpty) {
        final location = response.results.first.geometry?.location;
        LatLng newLatLng = LatLng(location!.lat, location.lng);

        // Move camera to the searched location
        _cameraToPosition(newLatLng);

        // Optionally, update the marker to the searched location
        setState(() {
          _currentP = newLatLng;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No results found for \"$query\"")),
        );
      }
    } catch (e) {
      print("Error during geocoding: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to search location")),
      );
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }
}
