import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<File> _images = []; // List to store images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Post",
          style: TextStyle(
            color: Colors.lightGreen[900], // Set text color to teal
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Scrolling grid of images
          Expanded(
            //flex: 3,
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
                crossAxisCount: 3, // Number of columns
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
          // Buttons for Gallery and Camera
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Comment:",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  //const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      maxLength: 2200, // Limit the input to 2200 characters
                      maxLines: 3, // Allow multi-line input
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), // Lighter color using theme
                        ),
                      ),
                      onChanged: (value) {
                        // You can handle the input value if needed
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.image),
                        label: const Text('Gallery'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: (){
                          // TODO!!! Need to make the description as the first comment of the post
                        },
                        icon: const Icon(Icons.post_add_outlined),
                        label: const Text('Post'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300], // Darker background color// Text and icon color
                          //foregroundColor: Colors.black, // Text and icon color
                          elevation: 5, // Drop shadow elevation
                          shadowColor: Colors.grey[600], // Shadow color
                          side: BorderSide(
                            color: Colors.grey[700]!, // Darker outline color
                            width: 2, // Thickness of the outline
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),

        ],
      ),
    );
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null && _images.length < 15) {
      setState(() {
        _images.insert(0, File(pickedImage.path)); // Add image to the top of the list
      });
    }
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null && _images.length < 15) {
      setState(() {
        _images.insert(0, File(pickedImage.path)); // Add image to the top of the list
      });
    }
  }
}



/*
* Gallery Button in this code isn't working. Using the File Picker dependency
* */
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker_REFERENCE_ONLY.dart';
//
// class PickImage extends StatefulWidget {
//   const PickImage({super.key});
//
//   @override
//   State<PickImage> createState() => _PickImageState();
// }
//
// class _PickImageState extends State<PickImage> {
//   final List<File> _images = []; // List to store images
//   final ImagePicker _imagePicker = ImagePicker(); // ImagePicker instance
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Scrolling grid of images
//           Expanded(
//             child: _images.isEmpty
//                 ? const Center(
//               child: Text(
//                 'No images added yet',
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             )
//                 : GridView.builder(
//               padding: const EdgeInsets.all(8.0),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3, // Number of columns
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//               ),
//               itemCount: _images.length,
//               itemBuilder: (context, index) {
//                 return Image.file(
//                   _images[index],
//                   fit: BoxFit.cover,
//                 );
//               },
//             ),
//           ),
//           // Buttons for Gallery and Camera
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: const Text(
//                       "Description:",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 TextField(
//                   maxLength: 2200, // Limit the input to 2200 characters
//                   maxLines: 3, // Allow multi-line input
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Write a description...',
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _pickImagesFromGallery,
//                       icon: const Icon(Icons.image),
//                       label: const Text('Gallery'),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _pickImageFromCamera,
//                       icon: const Icon(Icons.camera_alt),
//                       label: const Text('Camera'),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // TODO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                       },
//                       icon: const Icon(Icons.post_add_outlined),
//                       label: const Text('Post'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[300],
//                         elevation: 5,
//                         shadowColor: Colors.grey[600],
//                         side: BorderSide(
//                           color: Colors.grey[700]!,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Pick multiple images from gallery
//   Future<void> _pickImagesFromGallery() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: true,
//       );
//
//       if (result != null) {
//         print("Files selected: ${result.files.map((f) => f.path).toList()}");
//
//         if (result.files.isNotEmpty) {
//           setState(() {
//             for (var file in result.files) {
//               if (file.path != null && _images.length < 15) {
//                 _images.insert(0, File(file.path!)); // Add file to the list
//               }
//             }
//           });
//         }
//       } else {
//         print("No files selected.");
//       }
//     } catch (e) {
//       print("Error during file picking: $e");
//     }
//   }
//
//   // Pick image from camera
//   Future<void> _pickImageFromCamera() async {
//     final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null && _images.length < 15) {
//       setState(() {
//         _images.insert(0, File(pickedFile.path)); // Add image to the top of the list
//       });
//     }
//   }
// }

