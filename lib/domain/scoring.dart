import 'package:ergo4all/domain/action_recognition.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Contains scoring data for the whole body of a person for one frame.
@immutable
class BodyScore {
  final int lowerArm;
  final int upperArm;
  final int wrist;
  final int trunk;
  final int neck;
  final int legs;

  const BodyScore(this.lowerArm, this.upperArm, this.wrist, this.trunk,
      this.neck, this.legs);
}

/// Calculate the total score for one frame based on the [bodyScore].
int calculateTotalScore(BodyScore bodyScore) {
  throw Exception("Not implemented");
}

/// Calculates the [BodyScore] for one frame based on the [action] the person
/// is doing and their [pose].
BodyScore scorePose(ErgoAction action, Pose pose) {
  // TODO: Put translated python code here
  throw Exception("Not implemented");
}
