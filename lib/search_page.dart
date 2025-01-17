import 'package:clean_earth_project2/Google_Maps/map_page.dart';
import 'package:flutter/material.dart';
import 'package:clean_earth_project2/dummy_data.dart';
import 'search_results_sheet.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 55.0),
              child: MapPage(),
            ),
          ),
          // Draggable Sheet positioned at the bottom
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SearchResultsSheet(
                  child: Column( //TODO: need to replace this DummyData with visible posts generated
                    children: List.generate(
                      10,
                      (index) => DummyData(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
