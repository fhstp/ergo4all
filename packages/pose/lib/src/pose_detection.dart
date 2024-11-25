import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;
import 'package:pose/src/mlkit_image_conversion.dart';
import 'package:pose/src/mlkit_pose_conversion.dart';
import 'package:pose/src/types.dart';

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

/// Detects the pose in an input image. Might return `null` if no pose could be detected. Only call this when the detection was started using [startPoseDetection]. The inputs are the [camera] which took the image, the [deviceOrientation] when the image was taken and the [image] itself.
Future<Pose?> detectPose(CameraDescription camera,
    DeviceOrientation deviceOrientation, CameraImage image) async {
  if (_detector == null) throw StateError("Pose detection was not started.");

  final mlkitInput = makeMLkitInput(camera, deviceOrientation, image);
  final poses = await _detector!.processImage(mlkitInput);

  final mlkitPose = poses.singleOrNull;
  if (mlkitPose == null) return null;

  return convertMlkitPose(mlkitPose);
}
