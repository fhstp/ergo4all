import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Represents an action that a person is doing in one frame.
enum ErgoAction { unknown }

/// Determines what action a person is doing based on their pose.
ErgoAction determineAction(Pose pose) {
  // TODO: Determine action based on pose
  return ErgoAction.unknown;
}
