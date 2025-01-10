import 'package:flutter/material.dart';

void showComments(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the modal sheet to expand fully
    builder: (builder) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.85, // Ensure it stops before the status bar
            child: Center(
              child: Text(
                "User Comments Go Here.",
                style: TextStyle(
                  fontSize: 24, // Set font size
                  fontWeight: FontWeight.bold, // Optional: Make it bold
                ),
                textAlign: TextAlign.center, // Center-align the text
              ),
            ),
          ),
        ),
      );
    },
  );
}
