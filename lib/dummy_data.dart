import 'package:clean_earth_project2/Post_Page_Related/mark_clean_bottom_sheet.dart';
import 'package:clean_earth_project2/Profile_Page_Related/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:clean_earth_project2/Post_Page_Related/show_comments_bottom_sheet.dart';

// ************** DUMMY DATA FOR BOTTOM SHEET *********************
class DummyData extends StatelessWidget {
  const DummyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200, // Set a fixed height for the ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Horizontal scrolling
              itemCount: 10, // Number of items in the horizontal list
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 2.0), // Spacing between items
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      color: Colors.black12,
                      height: 200,
                      width: 200, // Fixed width for the image placeholder
                      child: Stack(
                        alignment: Alignment.center, // Center-aligns the text
                        children: [
                          Text(
                            'Picture',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54, // Text color
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: must navigate to user's ProfilePage() once clicked
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black12, // Background color
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 2.0, right: 2.0),  // Add padding inside the button
                      minimumSize: Size.zero, // Remove minimum size constraints
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap target
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "User:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
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
                ],
              ),
              const SizedBox(height: 5),
              Text("Date:"),
              const SizedBox(height: 5),
              Text("City, State:"),
              const SizedBox(height: 5),
              Text("Coordinates:"),
              const SizedBox(height: 5),
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
                      "Comments:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Text color
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: need to save post to user's Saved page
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[200], // Background color
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 2.0, right: 2.0),  // Add padding inside the button
                      minimumSize: Size.zero, // Remove minimum size constraints
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap target
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          Divider(color: Colors.black54, thickness: 1),
        ],
      ),
    );
  }
}
