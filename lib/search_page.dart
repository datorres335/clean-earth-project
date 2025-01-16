/* *********************
* uses the Column widget
* **********************/
// import 'package:clean_earth_project2/Google_Maps/map_page.dart';
// import 'package:flutter/material.dart';
// import 'search_results_sheet.dart';
// import 'package:clean_earth_project2/dummy_data.dart';
//
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   String searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: MapPage(),
//             ),
//           ),
//
//           // Draggable Sheet
//           Expanded(
//             child: DraggableSheet(
//               child: Column(
//                 children: List.generate(
//                   10,
//                   (index) => BottomSheetDummyUI(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


/*
* Uses the Stack widget
* */
// import 'package:flutter/material.dart';
// import 'search_results_sheet.dart';
// import 'package:clean_earth_project2/dummy_data.dart';
//
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   String searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 // Search bar
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     onChanged: (value) {
//                       setState(() {
//                         searchQuery = value; // Update search query on input
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search Location...',
//                       prefixIcon: Icon(Icons.search),
//                       contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Draggable Sheet
//                 Expanded(
//                   child: DraggableSheet(
//                     child: Column(
//                       children: List.generate(
//                         10,
//                             (index) => BottomSheetDummyUI(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Google Maps placeholder with independent padding
//             Positioned(
//               top: 100, // Adjust as needed to position the text
//               left: 16,
//               right: 16,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 child: Text(
//                   "Google Maps goes here",
//                   style: TextStyle(fontSize: 16), // Optional: Style the text
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'search_results_sheet.dart';


/* *******************************
* Uses the Stack widget. Version 2
******************************* */
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
  String searchQuery = '';

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
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "TODO:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        children: List.generate(
                          10,
                          (index) => DummyData(),
                        ),
                      ),
                    ],
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
