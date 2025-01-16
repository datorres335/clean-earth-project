import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfilePosts extends StatefulWidget {
  const UserProfilePosts({super.key});

  @override
  State<UserProfilePosts> createState() => _UserProfilePostsState();
}

class _UserProfilePostsState extends State<UserProfilePosts> {
  late Future<List<Map<String, dynamic>>> _userPostsFuture;

  @override
  void initState() {
    super.initState();
    _userPostsFuture = _fetchUserPosts();
  }

  Future<List<Map<String, dynamic>>> _fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    // Query Firestore for posts created by the current user
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    // Map Firestore documents to a list of post data
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userPostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No posts yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display image in a horizontal scrollable ListView
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (post['images'] as List<dynamic>).length,
                        itemBuilder: (context, imageIndex) {
                          final imageUrl = post['images'][imageIndex];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                imageUrl,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Date: ${post['date'] ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "City, State: ${post['cityState'] ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Coordinates: ${post['coordinates'] ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.black54, thickness: 1),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
