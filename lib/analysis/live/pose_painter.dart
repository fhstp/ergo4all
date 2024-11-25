import 'package:flutter/material.dart';
import 'package:pose/pose.dart';

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;

  PosePainter({super.repaint, required this.pose, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final jointPaint = Paint()..color = Colors.red;
    final bonePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    Offset? tryGetPosOf(KeyPoints keyPoint) {
      final landmark = pose[keyPoint];
      if (visibilityOf(landmark!) < 0.9) return null;
      final position = worldPosOf(landmark).xy;
      return Offset(
        size.width * (position.x / imageSize.width),
        size.height * (position.y / imageSize.height),
      );
    }

    void drawJoint(KeyPoints keyPoint) {
      final pos = tryGetPosOf(keyPoint);
      if (pos != null) canvas.drawCircle(pos, 7, jointPaint);
    }

    void drawBone((KeyPoints, KeyPoints) bone) {
      final (from, to) = bone;

      final fromPos = tryGetPosOf(from);
      if (fromPos == null) return;

      final toPos = tryGetPosOf(to);
      if (toPos == null) return;

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
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}
