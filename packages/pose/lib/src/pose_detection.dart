import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose/src/types.dart';

PoseDetector? _detector;

/// Starts pose detection if not already active.
Future<void> startPoseDetection() async {
  if (_detector != null) return;
  _detector = PoseDetector(
      options: PoseDetectorOptions(
          model: PoseDetectionModel.accurate, mode: PoseDetectionMode.stream));
}

/// Stops pose detection if running.
Future<void> stopPoseDetection() async {
  if (_detector == null) return;
  await _detector!.close();
  _detector = null;
}

final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

InputImageRotation? _tryGetCameraRotation(
    DeviceOrientation deviceOrientation, CameraDescription camera) {
  // get image rotation
  // it is used in android to convert the InputImage from Dart to Java
  // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
  // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
  final sensorOrientation = camera.sensorOrientation;
  if (Platform.isIOS) {
    return InputImageRotationValue.fromRawValue(sensorOrientation);
  } else if (Platform.isAndroid) {
    var rotationCompensation = _orientations[deviceOrientation];
    if (rotationCompensation == null) return null;
    if (camera.lensDirection == CameraLensDirection.front) {
      // front-facing
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      // back-facing
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }
    return InputImageRotationValue.fromRawValue(rotationCompensation);
  }

  throw UnsupportedError("Only Android and iOS are supported!");
}

InputImage _makeMLkitInput(CameraDescription camera,
    DeviceOrientation deviceOrientation, CameraImage image) {
  final rotation = _tryGetCameraRotation(deviceOrientation, camera);
  assert(rotation != null);

  // get image format
  final format = InputImageFormatValue.fromRawValue(image.format.raw);
  // validate format depending on platform
  // only supported formats:
  // * nv21 for Android
  // * bgra8888 for iOS
  if (format == null ||
      (Platform.isAndroid && format != InputImageFormat.nv21) ||
      (Platform.isIOS && format != InputImageFormat.bgra8888)) {
    throw ArgumentError(
        "Image has invalid format. Must be nv21 for Android or bgra8888 for ios, but was $format.",
        "image");
  }

  // since format is constraint to nv21 or bgra8888, both only have one plane
  assert(image.planes.length == 1);
  final plane = image.planes.first;

  // compose InputImage using bytes
  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation!, // used only in Android
      format: format, // used only in iOS
      bytesPerRow: plane.bytesPerRow, // used only in iOS
    ),
  );
}

/// Gets the size of a [CameraImage] but rotates it so width and height match  the device orientation.
Size _getRotatedImageSize(CameraImage image) {
  // For some reason, the width and height in the image are flipped in
  // portrait mode.
  // So in order for the math in following code to be correct, we need
  // to flip it back.
  // This might be an issue if we ever allow landscape mode. Then we
  // would need to use some dynamic logic to determine the image orientation.
  return Size(image.height.toDouble(), image.width.toDouble());
}

/// Class which contains output data for the [PoseDetector.detect] method. Specifically this contains pose data.
@immutable
class DetectResult {
  /// 2D Pose data.
  final Pose2D pose2d;

  const DetectResult({required this.pose2d});
}

/// Detects the pose in an input image. Might return `null` if no pose could be detected. Only call this when the detector [isReady]. The inputs are the [camera] which took the image, the [deviceOrientation] when the image was taken and the [image] itself.
Future<DetectResult?> detectPose(CameraDescription camera,
    DeviceOrientation deviceOrientation, CameraImage image) async {
  if (_detector == null) throw StateError("Pose detection was not started.");

  final mlkitInput = _makeMLkitInput(camera, deviceOrientation, image);
  final poses = await _detector!.processImage(mlkitInput);

  final pose = poses.singleOrNull;
  if (pose == null) return null;

  PoseLandmark mlkitLandmarkFor(LandmarkTypes type) {
    final mlkitType = switch (type) {
      LandmarkTypes.leftHand => PoseLandmarkType.leftWrist,
      LandmarkTypes.leftElbow => PoseLandmarkType.leftElbow,
      LandmarkTypes.leftShoulder => PoseLandmarkType.leftShoulder,
      LandmarkTypes.leftHip => PoseLandmarkType.leftHip,
      LandmarkTypes.leftKnee => PoseLandmarkType.leftKnee,
      LandmarkTypes.leftFoot => PoseLandmarkType.leftAnkle,
      LandmarkTypes.rightHand => PoseLandmarkType.rightWrist,
      LandmarkTypes.rightElbow => PoseLandmarkType.rightElbow,
      LandmarkTypes.rightShoulder => PoseLandmarkType.rightShoulder,
      LandmarkTypes.rightHip => PoseLandmarkType.rightHip,
      LandmarkTypes.rightKnee => PoseLandmarkType.rightKnee,
      LandmarkTypes.rightFoot => PoseLandmarkType.rightAnkle,
    };
    return pose.landmarks[mlkitType]!;
  }

  final imageSize = _getRotatedImageSize(image);

  Landmark2D landmarkFor(LandmarkTypes type) {
    final mlkitLandmark = mlkitLandmarkFor(type);
    return Landmark2D(
        confidence: mlkitLandmark.likelihood,
        x: mlkitLandmark.x / imageSize.width,
        y: mlkitLandmark.y / imageSize.height);
  }

  return DetectResult(
      pose2d: IMap.fromKeys(
    keys: LandmarkTypes.values,
    valueMapper: landmarkFor,
  ));
}
