import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;
import 'package:pose/src/types.dart';
import 'package:vector_math/vector_math.dart';

mlkit.PoseDetector? _detector;

/// Starts pose detection if not already active.
Future<void> startPoseDetection() async {
  if (_detector != null) return;
  _detector = mlkit.PoseDetector(
      options: mlkit.PoseDetectorOptions(
          model: mlkit.PoseDetectionModel.accurate,
          mode: mlkit.PoseDetectionMode.stream));
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

mlkit.InputImageRotation? _tryGetCameraRotation(
    DeviceOrientation deviceOrientation, CameraDescription camera) {
  // get image rotation
  // it is used in android to convert the InputImage from Dart to Java
  // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
  // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
  final sensorOrientation = camera.sensorOrientation;
  if (Platform.isIOS) {
    return mlkit.InputImageRotationValue.fromRawValue(sensorOrientation);
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
    return mlkit.InputImageRotationValue.fromRawValue(rotationCompensation);
  }

  throw UnsupportedError("Only Android and iOS are supported!");
}

mlkit.InputImage _makeMLkitInput(CameraDescription camera,
    DeviceOrientation deviceOrientation, CameraImage image) {
  final rotation = _tryGetCameraRotation(deviceOrientation, camera);
  assert(rotation != null);

  // get image format
  final format = mlkit.InputImageFormatValue.fromRawValue(image.format.raw);
  // validate format depending on platform
  // only supported formats:
  // * nv21 for Android
  // * bgra8888 for iOS
  if (format == null ||
      (Platform.isAndroid && format != mlkit.InputImageFormat.nv21) ||
      (Platform.isIOS && format != mlkit.InputImageFormat.bgra8888)) {
    throw ArgumentError(
        "Image has invalid format. Must be nv21 for Android or bgra8888 for ios, but was $format.",
        "image");
  }

  // since format is constraint to nv21 or bgra8888, both only have one plane
  assert(image.planes.length == 1);
  final plane = image.planes.first;

  // compose InputImage using bytes
  return mlkit.InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: mlkit.InputImageMetadata(
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

mlkit.PoseLandmarkType _convertToMlkitLandmarkType(LandmarkTypes type) {
  final mlkitType = switch (type) {
    LandmarkTypes.leftHand => mlkit.PoseLandmarkType.leftWrist,
    LandmarkTypes.leftElbow => mlkit.PoseLandmarkType.leftElbow,
    LandmarkTypes.leftShoulder => mlkit.PoseLandmarkType.leftShoulder,
    LandmarkTypes.leftHip => mlkit.PoseLandmarkType.leftHip,
    LandmarkTypes.leftKnee => mlkit.PoseLandmarkType.leftKnee,
    LandmarkTypes.leftFoot => mlkit.PoseLandmarkType.leftAnkle,
    LandmarkTypes.rightHand => mlkit.PoseLandmarkType.rightWrist,
    LandmarkTypes.rightElbow => mlkit.PoseLandmarkType.rightElbow,
    LandmarkTypes.rightShoulder => mlkit.PoseLandmarkType.rightShoulder,
    LandmarkTypes.rightHip => mlkit.PoseLandmarkType.rightHip,
    LandmarkTypes.rightKnee => mlkit.PoseLandmarkType.rightKnee,
    LandmarkTypes.rightFoot => mlkit.PoseLandmarkType.rightAnkle,
  };
  return mlkitType;
}

Landmark _convertFromMlkitLandmark(mlkit.PoseLandmark mlkitLandmark,
    Size imageSize, double minZ, double zRange) {
  final position = Vector3(mlkitLandmark.x / imageSize.width,
      mlkitLandmark.y / imageSize.height, (mlkitLandmark.z - minZ) / zRange);

  return Landmark(confidence: mlkitLandmark.likelihood, position: position);
}

Pose _convertFromMlkitPose(mlkit.Pose mlkitPose, Size imageSize) {
  final zs = mlkitPose.landmarks.values.map((it) => it.z).asList();
  final minZ = zs.reduce(min);
  final maxZ = zs.reduce(max);
  final zRange = maxZ - minZ;

  return IMap.fromKeys(
      keys: LandmarkTypes.values,
      valueMapper: (type) {
        final mlkitType = _convertToMlkitLandmarkType(type);
        final mlkitLandmark = mlkitPose.landmarks[mlkitType]!;
        return _convertFromMlkitLandmark(
            mlkitLandmark, imageSize, minZ, zRange);
      });
}

/// Detects the pose in an input image. Might return `null` if no pose could be detected. Only call this when the detector [isReady]. The inputs are the [camera] which took the image, the [deviceOrientation] when the image was taken and the [image] itself.
Future<Pose?> detectPose(CameraDescription camera,
    DeviceOrientation deviceOrientation, CameraImage image) async {
  if (_detector == null) throw StateError("Pose detection was not started.");

  final mlkitInput = _makeMLkitInput(camera, deviceOrientation, image);
  final poses = await _detector!.processImage(mlkitInput);

  final mlkitPose = poses.singleOrNull;
  if (mlkitPose == null) return null;
  final imageSize = _getRotatedImageSize(image);

  return _convertFromMlkitPose(mlkitPose, imageSize);
}
