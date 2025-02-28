import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pose/pose.dart';

/// Calculates a [Color] for the given [keyPoint] based on its enum index.
Color getJointColorFromIndex(KeyPoints keyPoint) {
  final index = keyPoint.index;
  final count = KeyPoints.values.length;
  final t = index / (count - 1);
  final hue = t * 360;
  return HSVColor.fromAHSV(1, hue, 0.8, 0.8).toColor();
}

/// Function for painting a skeleton pose onto the given [canvas]. Uses
/// [getJointPos] to get the poses relevant position as well as [getJointColor]
/// for the joint and bone colors.
void paintPose(
  Canvas canvas,
  Offset Function(KeyPoints keyPoint) getJointPos,
  Color Function(KeyPoints keyPoint) getJointColor,
) {
  void drawBone((KeyPoints, KeyPoints) bone) {
    final (from, to) = bone;
    final fromPos = getJointPos(from);
    final toPos = getJointPos(to);

    final fromColor = getJointColor(from);
    final toColor = getJointColor(to);
    final paint = Paint()
      ..shader = ui.Gradient.linear(fromPos, toPos, [fromColor, toColor])
      ..strokeWidth = 3;

    canvas.drawLine(fromPos, toPos, paint);
  }

  [
    (KeyPoints.rightWrist, KeyPoints.rightElbow),
    (KeyPoints.leftWrist, KeyPoints.leftElbow),
    (KeyPoints.rightElbow, KeyPoints.rightShoulder),
    (KeyPoints.rightWrist, KeyPoints.rightPalm),
    (KeyPoints.leftElbow, KeyPoints.leftShoulder),
    (KeyPoints.leftWrist, KeyPoints.leftPalm),
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
    (KeyPoints.midHead, KeyPoints.nose),
  ].forEach(drawBone);
}
