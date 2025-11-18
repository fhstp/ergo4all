import 'dart:math';

import 'package:auto_rula/auto_rula.dart';
import 'package:common/immutable_collection_ext.dart';
import 'package:flutter/material.dart';
import 'package:pose_vis/src/painting.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

extension _ScalingExt on ProjectedPose {
  Rect get boundingBox {
    final minX = positions.map((it) => it.x).reduce(min);
    final minY = positions.map((it) => it.y).reduce(min);
    final maxX = positions.map((it) => it.x).reduce(max);
    final maxY = positions.map((it) => it.y).reduce(max);

    final width = maxX - minX;
    final height = maxY - minY;

    return Rect.fromLTWH(minX, minY, width, height);
  }

  ProjectedPose scaleToFit(Size size) {
    final bounds = boundingBox;
    final scale = min(size.width / bounds.width, size.height / bounds.height);
    return ProjectedPose(
      positionsByKeyPoint.mapValues((_, pos) => pos * scale),
    );
  }

  Vector2 get center {
    final centerOffset = boundingBox.center;
    return Vector2(centerOffset.dx, centerOffset.dy);
  }

  ProjectedPose centerAt(Offset newCenter) {
    final translate = Vector2(newCenter.dx, newCenter.dy) - center;
    return ProjectedPose(
      positionsByKeyPoint.mapValues((_, p) => p + translate),
    );
  }
}

/// A [CustomPainter] for [ProjectedPose] objects.
class Pose2dPainter extends CustomPainter {
  /// Creates a painter for the given [pose].
  Pose2dPainter({required this.pose, super.repaint});

  /// The pose to paint.
  final ProjectedPose pose;

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
