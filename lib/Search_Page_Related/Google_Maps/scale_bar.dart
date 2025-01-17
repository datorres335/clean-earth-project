/*
* NOT IMPLEMENTED ONTO MAP YET, NOT WORKING PROPERLY
* */

import 'dart:math';
import 'package:flutter/material.dart';

class ScaleBar extends StatelessWidget {
  final double zoomLevel;

  const ScaleBar({Key? key, required this.zoomLevel}) : super(key: key);

  String getScaleText(double zoomLevel) {
    // Convert zoom level to approximate scale distance (in meters)
    double scaleDistanceMeters = pow(2, 21 - zoomLevel) * 156543.03392 / 2;

    // Convert meters to miles
    double scaleDistanceMiles = scaleDistanceMeters / 1609.34;

    if (scaleDistanceMiles >= 1) {
      return '${scaleDistanceMiles.toStringAsFixed(1)} mi'; // Display in miles
    } else {
      return '${(scaleDistanceMiles * 5280).toStringAsFixed(0)} ft'; // Display in feet if less than 1 mile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50, // Scale bar width
          height: 5, // Scale bar height
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        Text(
          getScaleText(zoomLevel),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
