import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final Pose _pose;

  PosePainter({super.repaint, required Pose pose}) : _pose = pose;

  @override
  void paint(Canvas canvas, Size size) {
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate._pose != _pose;
  }
}
