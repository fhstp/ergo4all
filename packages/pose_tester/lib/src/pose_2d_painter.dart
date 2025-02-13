import 'package:flutter/material.dart';
import 'package:pose/pose.dart';
import 'package:pose_tester/src/pose_2d.dart';

class Pose2dPainter extends CustomPainter {
  final Pose2d pose;

  Pose2dPainter({super.repaint, required this.pose});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final jointPaint = Paint()..color = Colors.red;
    final bonePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    Offset tryGetPosOf(KeyPoints keyPoint) {
      final pos = pose[keyPoint]!;
      return Offset(
          10 + (size.width - 20) * pos.x, 10 + (size.height - 20) * pos.y);
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
