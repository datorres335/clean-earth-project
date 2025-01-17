import 'package:flutter/material.dart';

void markClean(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the modal sheet to expand fully
    builder: (builder) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9, // Ensure it stops before the status bar
            child: Column(
              children: [
                Text(
                    "\nTODO:\n\nMarked Clean Content\nGoes Here.",
                    style: TextStyle(
                      fontSize: 24, // Set font size
                      fontWeight: FontWeight.bold, // Optional: Make it bold
                    ),
                    textAlign: TextAlign.center, // Center-align the text
                  ),
                Text(
                    "Need to be able to remove post from feed and also increase user's Areas Cleaned counter by 1.",
                    style: TextStyle(
                      fontSize: 20, // Set font size
                    ),
                    textAlign: TextAlign.center, // Center-align the text

                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
