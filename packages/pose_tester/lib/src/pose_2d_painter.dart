import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:flutter/material.dart';
import 'package:pose/pose.dart';
import 'package:pose_tester/src/pose_2d.dart';
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

  final jointPaint = Paint()..color = Colors.red;
  final bonePaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 5;

  Pose2dPainter({super.repaint, required this.pose});

  @override
  void paint(Canvas canvas, Size size) {
    final centeredPos =
        pose.scaleToFit(size * 0.95).centerAt(size.center(Offset.zero));

    Offset tryGetPosOf(KeyPoints keyPoint) {
      final pos = centeredPos[keyPoint]!;
      return Offset(pos.x, pos.y);
    }

    void drawJoint(KeyPoints keyPoint) {
      final pos = tryGetPosOf(keyPoint);
      canvas.drawCircle(pos, 7, jointPaint);
    }

    void drawBone((KeyPoints, KeyPoints) bone) {
      final (from, to) = bone;
      final fromPos = tryGetPosOf(from);
      final toPos = tryGetPosOf(to);

      canvas.drawLine(fromPos, toPos, bonePaint);
    }

    [
      (KeyPoints.rightPalm, KeyPoints.rightElbow),
      (KeyPoints.leftPalm, KeyPoints.leftElbow),
      (KeyPoints.rightElbow, KeyPoints.rightShoulder),
      (KeyPoints.leftElbow, KeyPoints.leftShoulder),
      (KeyPoints.rightShoulder, KeyPoints.leftShoulder),
      (KeyPoints.rightHip, KeyPoints.leftHip),
      (KeyPoints.rightHip, KeyPoints.rightKnee),
      (KeyPoints.leftHip, KeyPoints.leftKnee),
      (KeyPoints.rightKnee, KeyPoints.rightAnkle),
      (KeyPoints.leftKnee, KeyPoints.leftAnkle),
      (KeyPoints.midNeck, KeyPoints.midPelvis),
      (KeyPoints.midNeck, KeyPoints.midHead),
    ].forEach(drawBone);

    [
      KeyPoints.leftShoulder,
      KeyPoints.rightShoulder,
      KeyPoints.leftElbow,
      KeyPoints.rightElbow,
      KeyPoints.leftPalm,
      KeyPoints.rightPalm,
      KeyPoints.leftHip,
      KeyPoints.rightHip,
      KeyPoints.leftKnee,
      KeyPoints.rightKnee,
      KeyPoints.leftAnkle,
      KeyPoints.rightAnkle
    ].forEach(drawJoint);
  }

  @override
  bool shouldRepaint(covariant Pose2dPainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}
