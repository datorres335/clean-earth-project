// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // TextEditingControllers for the fields
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//
//       if (userDoc.exists) {
//         final data = userDoc.data();
//         setState(() {
//           _firstNameController.text = data?['firstName'] ?? '';
//           _lastNameController.text = data?['lastName'] ?? '';
//           _bioController.text = data?['bio'] ?? '';
//           _usernameController.text = data?['username'] ?? '';
//         });
//       }
//     }
//   }
//
//   Future<void> _updateUserProfile() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       final user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//           'firstName': _firstNameController.text,
//           'lastName': _lastNameController.text,
//           'bio': _bioController.text,
//           'username': _usernameController.text,
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully!')),
//         );
//
//         // Return true to indicate the update was successful
//         Navigator.pop(context, true);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User not logged in')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Edit Profile",
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.primary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView( // Enable scrolling when the keyboard is visible
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // Username Field
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Username',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your username';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // First Name Field
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'First Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your first name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Last Name Field
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Last Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your last name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Bio Field
//                 TextFormField(
//                   maxLength: 100,
//                   controller: _bioController,
//                   decoration: const InputDecoration(
//                     labelText: 'Bio',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your bio';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Save Button
//                 ElevatedButton(
//                   onPressed: _updateUserProfile,
//                   child: const Text('Save'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// TEST CODE ****************************************************************************************************

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _profileImageUrl; // To store the profile picture URL
  File? _selectedImage; // For the selected image file

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        setState(() {
          _firstNameController.text = data?['firstName'] ?? '';
          _lastNameController.text = data?['lastName'] ?? '';
          _bioController.text = data?['bio'] ?? '';
          _usernameController.text = data?['username'] ?? '';
          _profileImageUrl = data?['profilePicture'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return null;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user.uid}.jpg');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String? imageUrl = _profileImageUrl;

        // Upload new profile picture if selected
        if (_selectedImage != null) {
          imageUrl = await _uploadImage(_selectedImage!);
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'bio': _bioController.text,
          'username': _usernameController.text,
          if (imageUrl != null) 'profilePicture': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        Navigator.pop(context, true); // Indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      // CircleAvatar
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/Temporary-Profile-Picture.jpg'))
                        as ImageProvider,
                      ),

                      // Edit Icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.9),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
                const SizedBox(height: 16),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // First Name Field
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Last Name Field
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Bio Field
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your bio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _updateUserProfile,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
