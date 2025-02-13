import 'package:flutter/material.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_tester/src/map_display.dart';

class AngleDisplay extends StatelessWidget {
  final PoseAngles angles;

  const AngleDisplay({super.key, required this.angles});

  @override
  Widget build(BuildContext context) {
    return MapDisplay(
        map: angles,
        formatKey: (keyAngle) => keyAngle.name,
        formatValue: (degrees) => "${degrees.toInt()}°");
  }
}
