import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;
import 'package:pose/src/mlkit_pose_conversion.dart';
import 'package:pose/src/types.dart';

typedef PoseDetectInput = mlkit.InputImage;

mlkit.PoseDetector? _detector;

/// Starts pose detection if not already active.
Future<void> startPoseDetection() async {
  if (_detector != null) return;
  _detector = mlkit.PoseDetector(
      options: mlkit.PoseDetectorOptions(
          model: mlkit.PoseDetectionModel.base,
          mode: mlkit.PoseDetectionMode.stream));
}

/// Stops pose detection if running.
Future<void> stopPoseDetection() async {
  if (_detector == null) return;
  await _detector!.close();
  _detector = null;
}

/// Detects the pose in an input image. Might return `null` if no pose could be detected. Only call this when the detection was started using [startPoseDetection].
Future<Pose?> detectPose(PoseDetectInput input) async {
  if (_detector == null) throw StateError("Pose detection was not started.");

  final poses = await _detector!.processImage(input);

  final mlkitPose = poses.singleOrNull;
  if (mlkitPose == null) return null;

  return convertMlkitPose(mlkitPose);
}
