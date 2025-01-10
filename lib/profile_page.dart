import 'package:flutter/material.dart';
import 'package:clean_earth_project2/dummy_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "<Username goes here>",
          style: TextStyle(
            color: Colors.lightGreen[900], // Set text color to teal
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                // TODO: Handle edit screen button action
              },
            child: Text("Edit")
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0), // Add some padding around the row
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/Temporary-Profile-Picture.jpg'),
                  ),
                  SizedBox(width: 16), // Add spacing between the avatar and the column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User's Full Name", // Replace with dynamic data
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle text overflow gracefully
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Bio: This is a short bio (max 150 characters).",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis, // Handle text overflow gracefully
                          maxLines: 2, // Limit the bio to 2 lines
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
// USER STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute the boxes evenly
              children: [
                // Expanded box for the number of posts a user has
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Padding around the expanded container
                    child: Container(
                      padding: const EdgeInsets.all(4.0), // Padding inside the box
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "12", // Replace with dynamic data
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Posts\nMade",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              height: 1.2, // Adjust line height (default is 1.0)
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Expanded box for the number of posts they have cleaned
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Padding around the expanded container
                    child: Container(
                      padding: const EdgeInsets.all(4.0), // Padding inside the box
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "8", // Replace with dynamic data
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Areas\nCleaned",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              height: 1.2, // Adjust line height (default is 1.0)
                            ),
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: 10, // Number of items in the list
                itemBuilder: (context, index) {
                  return BottomSheetDummyUI();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
