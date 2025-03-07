import 'package:flutter/material.dart' hide Page, ProgressIndicator;
import 'package:fpdart/fpdart.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_tester/src/map_display.dart';
import 'package:pose_tester/src/page.dart';
import 'package:pose_tester/src/progress_indicator.dart';

/// Page for displaying angles.
class AnglePage extends StatelessWidget {
  /// Creates an angle page.
  const AnglePage({
    required this.currentAngles,
    super.key,
  });

  /// The angles to display.
  final Option<PoseAngles> currentAngles;

  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'Angles',
      body: switch (currentAngles) {
        Some(value: final angles) => SingleChildScrollView(
            child: MapDisplay(
              map: angles,
              formatKey: (keyAngle) => keyAngle.name,
              formatValue: (degrees) => '${degrees.toInt()}°',
            ),
          ),
        _ => const ProgressIndicator()
      },
    );
  }
}
