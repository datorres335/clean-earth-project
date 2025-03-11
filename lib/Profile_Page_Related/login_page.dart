import 'package:clean_earth_project2/Profile_Page_Related/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _signInWithEmail(String email, String password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print("Successfully logged in!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }).catchError((error) {
      print("Failed to login: $error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      // Handle login error (e.g., show a message to the user)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login / Sign Up",
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
        child: SingleChildScrollView( // Make the content scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Uniform padding for better alignment
            child: Column(
              children: [
                // Username Input
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email or Username",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface, // Text color from theme
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: "Enter your email or username",
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6), // Lighter hint text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Password Input
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16), // Space between Password input and Login

                // Login and Sign Up Buttons
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center-aligns the buttons vertically
                  children: [
                    // Login Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64.0),
                      child: SizedBox(
                        width: double.infinity, // Makes the button as wide as its parent container
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .where('username', isEqualTo: usernameController.text)
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              // Check if a user with the given username exists
                              if (querySnapshot.docs.isNotEmpty) {
                                // Get the email from the user document
                                final email = querySnapshot.docs.first['email'];
                                _signInWithEmail(email, passwordController.text);
                              } else {
                                // If not found, try to sign in directly using the email
                                _signInWithEmail(usernameController.text, passwordController.text);
                              }
                            }).catchError((error) {
                              print("Error checking username in Firestore: $error");
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary, // Border color
                              width: 2.0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16), // Space between Login and "Or"

                    Text(
                      "Or",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ), // Centered text between the buttons

                    const SizedBox(height: 16), // Space between "Or" and Sign Up

                    // Sign Up Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64.0),
                      child: SizedBox(
                        width: double.infinity, // Makes the button as wide as its parent container
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
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
}

