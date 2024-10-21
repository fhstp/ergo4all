import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/app/io/pose_processing.dart';
import 'package:ergo4all/domain/pose.dart';
import 'package:flutter/services.dart';
import "package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart"
    as mlkit;

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

mlkit.InputImage makeMLkitInput(DetectInput input) {
  final rotation = _tryGetCameraRotation(input.deviceOrientation, input.camera);
  assert(rotation != null);

  // get image format
  final format =
      mlkit.InputImageFormatValue.fromRawValue(input.image.format.raw);
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
  assert(input.image.planes.length == 1);
  final plane = input.image.planes.first;

  // compose InputImage using bytes
  return mlkit.InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: mlkit.InputImageMetadata(
      size: Size(input.image.width.toDouble(), input.image.height.toDouble()),
      rotation: rotation!, // used only in Android
      format: format, // used only in iOS
      bytesPerRow: plane.bytesPerRow, // used only in iOS
    ),
  );
}

/// Gets the size of a [CameraImage] but rotates it so width and height match
/// the device orientation.
Size _getRotatedImageSize(CameraImage image) {
  // For some reason, the width and height in the image are flipped in
  // portrait mode.
  // So in order for the math in following code to be correct, we need
  // to flip it back.
  // This might be an issue if we ever allow landscape mode. Then we
  // would need to use some dynamic logic to determine the image orientation.
  return Size(image.height.toDouble(), image.width.toDouble());
}

/// [PoseDetector] implementation which uses the [mlkit.PoseDetector].
class MLkitPoseDetectorAdapter extends PoseDetector {
  mlkit.PoseDetector? _detector;

  @override
  Future<bool> isReady() async {
    return _detector != null;
  }

  @override
  Future<DetectResult?> detect(DetectInput input) async {
    if (_detector == null) {
      throw StateError(
          "Detect was called on PoseDetector before it was ready.");
    }

    final mlkitInput = makeMLkitInput(input);
    final poses = await _detector!.processImage(mlkitInput);

    final pose = poses.singleOrNull;
    if (pose == null) return null;

    mlkit.PoseLandmark mlkitLandmarkFor(LandmarkTypes type) {
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
      return pose.landmarks[mlkitType]!;
    }

    final imageSize = _getRotatedImageSize(input.image);

    Landmark2D landmarkFor(LandmarkTypes type) {
      final mlkitLandmark = mlkitLandmarkFor(type);
      return Landmark2D(
          confidence: mlkitLandmark.likelihood,
          x: mlkitLandmark.x / imageSize.width,
          y: mlkitLandmark.y / imageSize.height);
    }

    return DetectResult(pose2d: {
      for (var landmarkType in LandmarkTypes.values)
        landmarkType: landmarkFor(landmarkType)
    });
  }

  @override
  Future<Null> start() async {
    if (_detector != null) return;

    _detector = mlkit.PoseDetector(
        options: mlkit.PoseDetectorOptions(
            model: mlkit.PoseDetectionModel.accurate,
            mode: mlkit.PoseDetectionMode.stream));
  }

  @override
  Future<Null> stop() async {
    if (_detector == null) return;

    await _detector!.close();
    _detector = null;
  }
}
