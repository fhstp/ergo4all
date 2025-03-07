import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:flutter/material.dart';
import 'package:pose/pose.dart';
import 'package:pose_2d/pose_2d.dart';
import 'package:pose_vis/src/painting.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

extension _ScalingExt on Pose2d {
  Rect get boundingBox {
    final minX = values.map((it) => it.x).reduce(min);
    final minY = values.map((it) => it.y).reduce(min);
    final maxX = values.map((it) => it.x).reduce(max);
    final maxY = values.map((it) => it.y).reduce(max);

    final width = maxX - minX;
    final height = maxY - minY;

    return Rect.fromLTWH(minX, minY, width, height);
  }

  Pose2d scaleToFit(Size size) {
    final bounds = boundingBox;
    final scale = min(size.width / bounds.width, size.height / bounds.height);
    return mapValues((pos) => pos * scale);
  }

  Vector2 get center {
    final centerOffset = boundingBox.center;
    return Vector2(centerOffset.dx, centerOffset.dy);
  }

  Pose2d centerAt(Offset newCenter) {
    final translate = Vector2(newCenter.dx, newCenter.dy) - center;
    return mapValues((p) => p + translate);
  }
}

/// A [CustomPainter] for [Pose2d] objects.
class Pose2dPainter extends CustomPainter {
  /// Creates a painter for the given [pose].
  Pose2dPainter({required this.pose, super.repaint});

  /// The pose to paint.
  final Pose2d pose;

  @override
  void paint(Canvas canvas, Size size) {
    final centeredPos =
        pose.scaleToFit(size * 0.95).centerAt(size.center(Offset.zero));

    Offset getJointPos(KeyPoints keyPoint) {
      final pos = centeredPos[keyPoint]!;
      return Offset(pos.x, pos.y);
    }

    paintPose(canvas, getJointPos, getJointColorFromIndex);
  }

  @override
  bool shouldRepaint(covariant Pose2dPainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}
