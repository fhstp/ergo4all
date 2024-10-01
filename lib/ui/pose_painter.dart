import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final Pose _pose;
  final Size _inputImageSize;

  PosePainter({super.repaint, required Pose pose, required Size inputImageSize})
      : _pose = pose,
        _inputImageSize = inputImageSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final jointPaint = Paint()..color = Colors.red;

    Offset imageToCanvas(Offset offset) {
      final normalized = Offset(offset.dx / _inputImageSize.width,
          offset.dy / _inputImageSize.height);
      return Offset(normalized.dx * size.width, normalized.dy * size.height);
    }

    Offset? tryGetPosOf(PoseLandmarkType landmarkType) {
      final landmark = _pose.landmarks[landmarkType];
      if (landmark == null || landmark.likelihood < 0.9) return null;
      var imageOffset = Offset(landmark.x, landmark.y);
      var canvasOffset = imageToCanvas(imageOffset);
      return canvasOffset;
    }

    void drawJoint(PoseLandmarkType landmarkType) {
      final pos = tryGetPosOf(landmarkType);
      if (pos != null) canvas.drawCircle(pos, 10, jointPaint);
    }

    [
      PoseLandmarkType.nose,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.leftElbow,
      PoseLandmarkType.rightElbow,
      PoseLandmarkType.leftWrist,
      PoseLandmarkType.rightWrist,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.rightHip,
      PoseLandmarkType.leftKnee,
      PoseLandmarkType.rightKnee,
      PoseLandmarkType.leftAnkle,
      PoseLandmarkType.rightAnkle
    ].forEach(drawJoint);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate._pose != _pose;
  }
}
