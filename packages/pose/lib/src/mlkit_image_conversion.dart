import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
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

mlkit.InputImage makeMLkitInput(CameraDescription camera,
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
