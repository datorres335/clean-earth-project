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
              ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),))
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
            zoomControlsEnabled: false, // Disable default zoom controls
          ),

          // Search Bar
          Positioned(
            top: 45, // Adjust the position of the search bar
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface, // Use app's color scheme
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow, // Use shadow color from the theme
                    blurRadius: 0.5,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(3.0), // Adjust padding as needed
                    child: Image.asset(
                      'assets/clean_earth_icon_no_background.png', // Path to your custom image
                      width: 30, // Adjust the width
                      height: 30, // Adjust the height
                    ),
                  ),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), // Hint text color
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0), // Adjust padding
                ),
                onSubmitted: (value) {
                  _searchLocation(value);
                },
              ),
            ),
          ),

          // Floating Action Button and Zoom Controls
          Positioned(
            top: 110, // Place this right below the search bar
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true, // Makes the button smaller
                  onPressed: () {
                    if (_currentP != null) {
                      _cameraToPosition(_currentP!); // Trigger camera movement when pressed
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8), // Spacing between FAB and zoom controls
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface, // Use app's color scheme
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 0.5,
                        //spreadRadius: 0.1,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 40,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              final GoogleMapController controller =
                              await _mapController.future;
                              controller.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        SizedBox(
                          height: 40,
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () async {
                              final GoogleMapController controller =
                              await _mapController.future;
                              controller.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
