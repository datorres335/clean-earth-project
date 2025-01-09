import 'package:flutter/material.dart';
import 'draggable_sheet.dart';
import 'package:clean_earth_project2/dummy_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableSheet(
          child: Column(
            children: [
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
              BottomSheetDummyUI(),
            ],
          )
      ),
    );
  }
}

