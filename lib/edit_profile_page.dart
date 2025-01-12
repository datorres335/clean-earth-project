import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editing Profile",
          style: TextStyle(
            color: Colors.lightGreen[900], // Set text color to teal
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea( // SafeArea is moved inside the body
        child: const Center(
          child: Text("Edit Profile"),
        ),
      ),
    );
  }
}
