import 'package:flutter/material.dart';
import 'package:clean_earth_project2/dummy_data.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Posts",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary, // Set text color to teal
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: 10, // Number of items in the list
          itemBuilder: (context, index) {
            return DummyData();
          },
        ),
      ),
    );
  }
}
