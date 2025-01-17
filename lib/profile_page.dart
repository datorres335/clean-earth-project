import 'package:clean_earth_project2/edit_profile_page.dart';
import 'package:clean_earth_project2/login_page.dart';
import 'package:clean_earth_project2/user_profile_posts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "<loading username>"; // Default placeholder for username
  String fullName = "<loading full name>"; // Placeholder for user's full name
  String bio = "Bio not available"; // Placeholder for bio
  String memberSince = "Loading..."; // Placeholder for member since date
  String? _profileImageUrl;
  int _postCount = 0; // Track the number of posts

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users') // Replace with your Firestore collection name
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            username = data?['username'] ?? "Unknown Username";
            final firstName = data?['firstName'] ?? "Unknown";
            final lastName = data?['lastName'] ?? "User";
            fullName = "$firstName $lastName"; // Combine first and last name
            bio = data?['bio'] ?? "No bio available";
            _profileImageUrl = data?['profilePicture'];

            // Format the createdAt timestamp
            final createdAt = data?['createdAt'];
            if (createdAt != null) {
              final createdDate = (createdAt as Timestamp).toDate();
              memberSince =
              "${_getMonthName(createdDate.month)} ${createdDate.day}, ${createdDate.year}";
            } else {
              memberSince = "Unknown date";
            }
          });
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
      setState(() {
        username = "Error loading username";
        fullName = "Error loading name";
        memberSince = "Error loading date";
      });
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(), // kept here strictly for the back button for when you navigate to it
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          username, // Display the fetched username
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Spacer(),
                        StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.hasData) {
                              return TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut().then((_) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Logged out successfully')),
                                    );
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Logout failed: $error')),
                                    );
                                  });
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              );
                            }

                            return TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile picture
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : const AssetImage('assets/Temporary-Profile-Picture.jpg') as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName, // Replace with user's full name
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Member since: ",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: memberSince,
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Bio: ",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: bio,
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () async {
                                    // Navigate to EditProfilePage and wait for result
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const EditProfilePage(),
                                      ),
                                    );

                                    // Refresh the profile if result is true
                                    if (result == true) {
                                      _fetchUserData();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text("Edit Profile"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // USER STATS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$_postCount",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Posts Made",
                              style: TextStyle(fontSize: 14, height: 1.2),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              // TODO: need to dynamically update this value to how many places a user has marked clean in total
                              "TODO:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Areas Cleaned",
                              style: TextStyle(fontSize: 14, height: 1.2),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // USER'S POSTS
              UserProfilePosts(
                onPostCountChanged: (count) {
                  setState(() {
                    _postCount = count; // Update the post count
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


