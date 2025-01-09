/*
* ORIGINAL CODE BELOW, DON'T DELETE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* */

// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// /*
// * TODO:
// *   Need to make it so that the Gallery and Camera buttons are placed permanently on the screen.
// *   Also every picture that you add gets added to the top to the screen, as a scrolling grid. Up to a max of 15 pictures.
// *   Need to also add a "comment" section that will serve as the first comment of the post.
// *
// * tutorial followed: https://www.youtube.com/watch?v=UEJK3mEBvOg
// * */
//
// class PickImage extends StatefulWidget {
//   const PickImage({super.key});
//
//   @override
//   State<PickImage> createState() => _PickImageState();
// }
//
// class _PickImageState extends State<PickImage> {
//   Uint8List? _image;
//   File? selectedImage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Colors.deepPurple[100],
//       body: Center(
//         child: Stack(
//           children: [
//             _image != null
//               ? CircleAvatar(
//               radius: 100,
//               backgroundImage: MemoryImage(_image!),
//               )
//               : const CircleAvatar(
//                 radius: 100,
//                 backgroundImage: AssetImage('assets/Temporary-Profile-Picture.jpg'),
//               ),
//             Positioned(
//               bottom: -0,
//               left: 140,
//               child: IconButton(
//                 onPressed: (){
//                   showImagePickerOption(context);
//                 },
//                 icon: const Icon(Icons.add_a_photo)
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showImagePickerOption(BuildContext context){
//     showModalBottomSheet(
//       backgroundColor: Colors.blue[100],
//         context: context,
//         builder: (builder){
//           return Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height /4.5,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: (){
//                         _pickImageFromGallery();
//                       },
//                       child: const SizedBox(
//                         child: Column(
//                           children: [
//                             Icon(Icons.image, size: 50,),
//                             Text("Gallery")
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: InkWell(
//                       onTap: (){
//                         _pickImageFromCamera();
//                       },
//                       child: const SizedBox(
//                         child: Column(
//                           children: [
//                             Icon(Icons.camera_alt, size: 50,),
//                             Text("Camera")
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }
//     );
//   }
//
//   // Gallery
//   Future _pickImageFromGallery() async {
//     final returnImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (returnImage == null) return;
//     setState(() {
//       selectedImage = File(returnImage.path);
//       _image = File(returnImage.path).readAsBytesSync();
//     });
//     Navigator.of(context).pop(); //close the model sheet
//   }
//
//   // Camera
//   Future _pickImageFromCamera() async {
//     final returnImage =
//       await ImagePicker().pickImage(source: ImageSource.camera);
//     if (returnImage == null) return;
//     setState(() {
//       selectedImage = File(returnImage.path);
//       _image = File(returnImage.path).readAsBytesSync();
//     });
//     Navigator.of(context).pop(); //close the model sheet
//   }
// }
/*
* ORIGINAL CODE ABOVE, DON'T DELETE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* */


/*
* CHATGPT CODE BELOW
* */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  final List<File> _images = []; // List to store images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Description:",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  //const SizedBox(height: 8),
                  TextField(
                    maxLength: 2200, // Limit the input to 2200 characters
                    maxLines: 3, // Allow multi-line input
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write a description...',
                    ),
                    onChanged: (value) {
                      // You can handle the input value if needed
                    },
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
