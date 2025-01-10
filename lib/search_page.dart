import 'package:flutter/material.dart';
import 'draggable_sheet.dart';
import 'package:clean_earth_project2/dummy_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField( // TODO: need to correctly implement the search field
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Update search query on input
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Location...',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            // Draggable Sheet
            Expanded(
              child: DraggableSheet(
                child: Column(
                  children: List.generate(
                    10,
                    (index) => BottomSheetDummyUI(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
