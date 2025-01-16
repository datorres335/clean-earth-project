import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'package:google_geocoding_api/google_geocoding_api.dart'; // For reverse geocoding
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<File> _images = []; // List to store images
  String? _currentDate;
  String? _currentCityState;
  String? _currentCoordinates;
  final TextEditingController _commentController = TextEditingController();

  final Location _location = Location();
  late final GoogleGeocodingApi _geocodingApi;

  @override
  void initState() {
    super.initState();
    _geocodingApi = GoogleGeocodingApi(dotenv.env['GOOGLE_MAPS_API_KEY']!);
    _fetchLocationAndDetails();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocationAndDetails() async {
    try {
      bool _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) return;
      }

      PermissionStatus _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) return;
      }

      LocationData locationData = await _location.getLocation();

      final double latitude = locationData.latitude!;
      final double longitude = locationData.longitude!;
      setState(() {
        _currentCoordinates =
        "${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}";
        _currentDate = DateFormat.yMMMMd().format(DateTime.now());
      });

      final response = await _geocodingApi.reverse(
        '${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}',
      );

      if (response.results.isNotEmpty) {
        final result = response.results.first;

        String? city = result.addressComponents.firstWhere(
              (component) => component.types.contains('locality'),
          orElse: () => GoogleGeocodingAddressComponent(
            longName: '',
            shortName: '',
            types: [],
          ),
        ).longName;

        String? state = result.addressComponents.firstWhere(
              (component) => component.types.contains('administrative_area_level_1'),
          orElse: () => GoogleGeocodingAddressComponent(
            longName: '',
            shortName: '',
            types: [],
          ),
        ).shortName;

        setState(() {
          _currentCityState = "$city, $state";
        });
      }
    } catch (e) {
      print("Error fetching location or details: $e");
    }
  }

  Future<void> _uploadPost() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final postId = FirebaseFirestore.instance.collection('posts').doc().id;
      List<String> imageUrls = [];

      for (int i = 0; i < _images.length; i++) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('post_images/${user.uid}/$postId/image_$i.jpg');
        await storageRef.putFile(_images[i]);
        final imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        'userId': user.uid,
        'date': _currentDate ?? 'Unknown',
        'cityState': _currentCityState ?? 'Unknown',
        'coordinates': _currentCoordinates ?? 'Unknown',
        'comment': _commentController.text ?? '',
        'images': imageUrls,
        'timestamp': FieldValue.serverTimestamp(), // For sorting posts
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post uploaded successfully!')),
      );

      // Reset the page state
      setState(() {
        _images.clear();
        _fetchLocationAndDetails();
        _commentController.clear(); // Clear the comment TextField
      });
    } catch (e) {
      print("Error uploading post: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Post",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _images.isEmpty
                ? const Center(
              child: Text(
                'No images added yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.file(
                  _images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: _currentDate ?? 'Loading...',
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "City, State: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: _currentCityState ?? 'Loading...',
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "Coordinates: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: _currentCoordinates ?? 'Loading...',
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Comment:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _commentController,
                  maxLength: 2200,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImagesFromGallery,
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: _uploadPost,
                  icon: const Icon(Icons.post_add_outlined),
                  label: const Text('Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Darker background color
                    elevation: 5, // Drop shadow elevation
                    shadowColor: Colors.grey[600], // Shadow color
                    side: BorderSide(
                      color: Colors.grey[700]!, // Darker outline color
                      width: 1, // Thickness of the outline
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

  Future<void> _pickImagesFromGallery() async {
    final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty && _images.length < 15) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null && _images.length < 15) {
      setState(() {
        _images.insert(0, File(pickedImage.path));
      });
    }
  }
}
