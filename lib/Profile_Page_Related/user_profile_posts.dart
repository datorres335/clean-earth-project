import 'package:clean_earth_project2/Post_Page_Related/show_comments_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Post_Page_Related/mark_clean_bottom_sheet.dart';

class UserProfilePosts extends StatefulWidget {
  final ValueChanged<int> onPostCountChanged; // Callback to pass post count

  const UserProfilePosts({super.key, required this.onPostCountChanged});

  @override
  State<UserProfilePosts> createState() => _UserProfilePostsState();
}

class _UserProfilePostsState extends State<UserProfilePosts> {
  late Future<List<Map<String, dynamic>>> _userPostsFuture;
  double fontSize = 14;

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

    /*
    * TODO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    *  Need to update the "users" firestore database so that each user have arrays
    * for "postsMade", "savedPosts", "followingProfiles", "followersProfiles"
    * */
    // Query Firestore for posts created by the current user
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    final posts = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Notify the parent widget of the post count
    widget.onPostCountChanged(posts.length);

    // Map Firestore documents to a list of post data
    return posts;
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Date: ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                          ),
                          TextSpan(
                            text: "${post['date'] ?? 'Unknown'}",
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "City, State: ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                          ),
                          TextSpan(
                            text: "${post['cityState'] ?? 'Unknown'}",
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Coordinates: ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                          ),
                          TextSpan(
                            text: "${post['coordinates'] ?? 'Unknown'}",
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: must open showModalBottomSheet once clicked to show post's comments
                            showComments(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black12, // Background color
                            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 2.0, right: 2.0), // Add padding inside the button
                            minimumSize: Size.zero, // Remove minimum size constraints
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap target
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Rounded corners
                            ),
                          ),
                          child: Text(
                            "Comments",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Text color
                              color: Colors.black,
                              fontSize: fontSize,
                            ),
                          ),
                        ),

                        Spacer(),

                        TextButton(
                          onPressed: () {
                            // TODO:
                            markClean(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer, // Background color
                            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 2.0, right: 2.0),  // Add padding inside the button
                            minimumSize: Size.zero, // Remove minimum size constraints
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap target
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Rounded corners
                            ),
                          ),
                          child: Text(
                            "Mark Clean",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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
