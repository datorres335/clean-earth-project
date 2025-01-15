import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For storing user details
import 'package:intl/intl.dart';

import 'main.dart'; // For date formatting

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  DateTime? dateOfBirth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary, // Use theme color for consistency
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer, // Match app's secondary container color
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary, // Icon color matches theme
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email Input
                _buildInputField(
                  label: "Email",
                  controller: emailController,
                  hintText: "Enter your email",
                  obscureText: false,
                ),

                // Password Input
                _buildInputField(
                  label: "Password",
                  controller: passwordController,
                  hintText: "Enter your password",
                  obscureText: true,
                ),

                // Username Input
                _buildInputField(
                  label: "Username",
                  controller: usernameController,
                  hintText: "Enter your username",
                  obscureText: false,
                ),

                // First Name Input
                _buildInputField(
                  label: "First Name",
                  controller: firstNameController,
                  hintText: "Enter your first name",
                  obscureText: false,
                ),

                // Last Name Input
                _buildInputField(
                  label: "Last Name",
                  controller: lastNameController,
                  hintText: "Enter your last name",
                  obscureText: false,
                ),

                // Date of Birth Input
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date of Birth",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDateOfBirth,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            dateOfBirth == null
                                ? "Select your date of birth"
                                : DateFormat('MMMM dd, yyyy').format(dateOfBirth!),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sign Up Button
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: OutlinedButton(
                          onPressed: _signUp,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary, // Border color
                              width: 2.0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateOfBirth = pickedDate;
      });
    }
  }

  Future<void> _signUp() async {
    try {
      // Create user with email and password
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // TODO: NEED TO LOOK INTO FIRESTORE
      // Save additional details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'username': usernameController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'dateOfBirth': dateOfBirth != null ? DateFormat('yyyy-MM-dd').format(dateOfBirth!) : null,
        'email': emailController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'bio' : "",
      }).then((value){
        print("Successfully added user to Firestore");
      }).catchError((error){
        print("Failed to save to Firestore");
        print(error);
      });

      print("Successfully signed up user");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      print("Failed to sign up user: $e");
    }
  }
}
