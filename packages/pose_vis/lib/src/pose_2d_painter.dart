import 'dart:math';
import 'dart:ui' as ui;

import 'package:common/immutable_collection_ext.dart';
import 'package:flutter/material.dart';
import 'package:pose/pose.dart';
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

class Pose2dPainter extends CustomPainter {
  final Pose2d pose;

  Pose2dPainter({super.repaint, required this.pose});

  @override
  void paint(Canvas canvas, Size size) {
    final centeredPos =
        pose.scaleToFit(size * 0.95).centerAt(size.center(Offset.zero));

    Offset tryGetPosOf(KeyPoints keyPoint) {
      final pos = centeredPos[keyPoint]!;
      return Offset(pos.x, pos.y);
    }

    Color jointColor(KeyPoints keyPoint) {
      final index = keyPoint.index;
      final count = KeyPoints.values.length;
      final t = index / (count - 1);
      final hue = t * 360;
      return HSVColor.fromAHSV(1, hue, 0.8, 0.8).toColor();
    }

    void drawBone((KeyPoints, KeyPoints) bone) {
      final (from, to) = bone;
      final fromPos = tryGetPosOf(from);
      final toPos = tryGetPosOf(to);

      final fromColor = jointColor(from);
      final toColor = jointColor(to);
      final paint = Paint()
        ..shader = ui.Gradient.linear(fromPos, toPos, [fromColor, toColor])
        ..strokeWidth = 5;

      canvas.drawLine(fromPos, toPos, paint);
    }

    [
      (KeyPoints.rightPalm, KeyPoints.rightElbow),
      (KeyPoints.leftPalm, KeyPoints.leftElbow),
      (KeyPoints.rightElbow, KeyPoints.rightShoulder),
      (KeyPoints.leftElbow, KeyPoints.leftShoulder),
      (KeyPoints.rightShoulder, KeyPoints.leftShoulder),
      (KeyPoints.rightShoulder, KeyPoints.rightHip),
      (KeyPoints.leftShoulder, KeyPoints.leftHip),
      (KeyPoints.rightHip, KeyPoints.leftHip),
      (KeyPoints.rightHip, KeyPoints.rightKnee),
      (KeyPoints.leftHip, KeyPoints.leftKnee),
      (KeyPoints.rightKnee, KeyPoints.rightAnkle),
      (KeyPoints.leftKnee, KeyPoints.leftAnkle),
      (KeyPoints.midNeck, KeyPoints.midPelvis),
      (KeyPoints.midNeck, KeyPoints.midHead),
    ].forEach(drawBone);
  }

  @override
  bool shouldRepaint(covariant Pose2dPainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}
