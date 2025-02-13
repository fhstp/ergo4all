import 'package:flutter/material.dart';
import 'package:pose_analysis/pose_analysis.dart';

class AngleDisplay extends StatelessWidget {
  final PoseAngles angles;

  const AngleDisplay({super.key, required this.angles});

  @override
  Widget build(BuildContext context) {
    Widget displayFor(KeyAngles keyAngle, double degrees) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${keyAngle.name}: ${degrees.toInt()}°"),
        ),
      );
    }

    return SingleChildScrollView(
        child: Wrap(
      children: angles.mapTo(displayFor).toList(),
    ));
  }
}
