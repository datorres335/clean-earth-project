import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  LatLng? _currentP;
  double _currentZoom = 13.0;
  final List<LatLng> _postCoordinates = [];
  final Set<Circle> _visibleCircles = {};
  final double _maxRadius = 100000; // Maximum radius in meters
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
    _fetchPostCoordinates();
    getLocationUpdates();
  }

  Future<void> _fetchPostCoordinates() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('posts').get();

    final coordinates = querySnapshot.docs.map((doc) {
      final data = doc.data();
      if (data['coordinates'] != null) {
        final parts = (data['coordinates'] as String).split(', ');
        if (parts.length == 2) {
          return LatLng(double.parse(parts[0]), double.parse(parts[1]));
        }
      }
      return null;
    }).whereType<LatLng>().toList();

    setState(() {
      _postCoordinates.addAll(coordinates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentP == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            onMapCreated: (GoogleMapController controller) =>
                _mapController.complete(controller),
            initialCameraPosition: CameraPosition(
              target: _currentP!,
              zoom: _currentZoom,
            ),
            onCameraMove: _onCameraMove,
            onCameraIdle: _updateVisibleCircles,
            circles: _visibleCircles,
            zoomControlsEnabled: false,
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

          // LOGO
          Positioned(
            bottom: -60, // Adjust to position above the bottom edge
            right: 15, // Adjust to position near the right edge
            child: LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = MediaQuery.of(context).size.width;
                double imageWidth = screenWidth * 0.4; // 30% of the screen width
                return Image.asset(
                  'assets/clean_earth_text3.png', // Path to your custom image
                  width: imageWidth, // Dynamically adjust the width
                  height: imageWidth, // Maintain a square aspect ratio
                  fit: BoxFit.contain, // Ensure the image scales proportionally
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentZoom = position.zoom;
    });
  }

  void _updateVisibleCircles() {
    setState(() {
      _visibleCircles
        ..clear()
        ..addAll(_postCoordinates.map((coord) {
          final dynamicRadius = _calculateRadius();
          return Circle(
            circleId: CircleId('${coord.latitude},${coord.longitude}'),
            center: coord,
            radius: dynamicRadius,
            fillColor: Colors.blue,
            strokeColor: Colors.blue[200] ?? Colors.blue,
            strokeWidth: 2,
          );
        }));
    });
  }

  double _calculateRadius() {
    const double baseRadius = 2; // Minimum radius in meters
    const double maxScaleFactor = 100; // Maximum scale factor for far zoom
    const double minScaleFactor = 5; // Minimum scale factor for close zoom

    // Dynamically calculate the scale factor based on the zoom level
    double scaleFactor = ((20 - _currentZoom) / 20) * (maxScaleFactor - minScaleFactor) + minScaleFactor;

    // Ensure scaleFactor stays within bounds
    scaleFactor = scaleFactor.clamp(minScaleFactor, maxScaleFactor);

    // Calculate radius with dynamic scale factor
    final double calculatedRadius = baseRadius + ((20 - _currentZoom) * scaleFactor);

    // Clamp the radius to stay within bounds
    return calculatedRadius.clamp(baseRadius, _maxRadius);
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
    bool _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    PermissionStatus _permissionGranted = await _locationController.hasPermission();
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
