import 'package:ergo4all/pose.common/types.dart';
import 'package:flutter/material.dart';

class PosePainter extends CustomPainter {
  final Pose2D pose;

  PosePainter({super.repaint, required this.pose});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final jointPaint = Paint()..color = Colors.red;
    final bonePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    Offset? tryGetPosOf(LandmarkTypes landmarkType) {
      final landmark = pose[landmarkType];
      assert(landmark != null);
      if (landmark!.confidence < 0.9) return null;
      return Offset(size.width * landmark.x, size.height * landmark.y);
    }

    void drawJoint(LandmarkTypes landmarkType) {
      final pos = tryGetPosOf(landmarkType);
      if (pos != null) canvas.drawCircle(pos, 7, jointPaint);
    }

    void drawBone((LandmarkTypes, LandmarkTypes) bone) {
      final (from, to) = bone;

      final fromPos = tryGetPosOf(from);
      if (fromPos == null) return;

      final toPos = tryGetPosOf(to);
      if (toPos == null) return;

      canvas.drawLine(fromPos, toPos, bonePaint);
    }

    [
      (LandmarkTypes.rightHand, LandmarkTypes.rightElbow),
      (LandmarkTypes.leftHand, LandmarkTypes.leftElbow),
      (LandmarkTypes.rightElbow, LandmarkTypes.rightShoulder),
      (LandmarkTypes.leftElbow, LandmarkTypes.leftShoulder),
      (LandmarkTypes.rightShoulder, LandmarkTypes.leftShoulder),
      (LandmarkTypes.rightHip, LandmarkTypes.leftHip),
      (LandmarkTypes.rightHip, LandmarkTypes.rightKnee),
      (LandmarkTypes.leftHip, LandmarkTypes.leftKnee),
      (LandmarkTypes.rightKnee, LandmarkTypes.rightFoot),
      (LandmarkTypes.leftKnee, LandmarkTypes.leftFoot),
    ].forEach(drawBone);

    [
      LandmarkTypes.leftShoulder,
      LandmarkTypes.rightShoulder,
      LandmarkTypes.leftElbow,
      LandmarkTypes.rightElbow,
      LandmarkTypes.leftHand,
      LandmarkTypes.rightHand,
      LandmarkTypes.leftHip,
      LandmarkTypes.rightHip,
      LandmarkTypes.leftKnee,
      LandmarkTypes.rightKnee,
      LandmarkTypes.leftFoot,
      LandmarkTypes.rightFoot
    ].forEach(drawJoint);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}
