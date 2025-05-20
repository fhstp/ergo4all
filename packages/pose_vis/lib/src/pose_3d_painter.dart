import 'package:flutter/material.dart';
import 'package:pose/pose.dart';
import 'package:pose_vis/src/painting.dart';

/// [CustomPainter] for [Pose] objects. Intended to be overlayed over the image
/// which produced the pose.
class Pose3dPainter extends CustomPainter {
  /// Creates a pose painter.
  Pose3dPainter({
    required this.pose,
    required this.imageSize,
    this.color,
    super.repaint,
  });

  /// The pose to visualize.
  final Pose pose;

  /// The size of the original image from which the pose was estimated,
  final Size imageSize;

  /// Color to use for joints. If omitted uses the "rainbow" color scheme.
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    Offset tryGetPosOf(KeyPoints keyPoint) {
      final landmark = pose[keyPoint]!;
      final position = posOf(landmark).xy;
      return Offset(
        size.width * (position.x / imageSize.width),
        size.height * (position.y / imageSize.height),
      );
    }

    paintPose(
      canvas,
      tryGetPosOf,
      color != null ? (_) => color! : getJointColorFromIndex,
    );
  }

  @override
  bool shouldRepaint(covariant Pose3dPainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}
