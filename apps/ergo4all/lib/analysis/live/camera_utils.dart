import 'dart:io';

import 'package:camera/camera.dart';

Future<CameraController> openPoseDetectionCamera() async {
  final cameras = await availableCameras();
  final frontCamera =
      cameras.firstWhere((it) => it.lensDirection == CameraLensDirection.back);

  final controller = CameraController(
    frontCamera, ResolutionPreset.high,
    enableAudio: false,
    imageFormatGroup: Platform.isAndroid
        ? ImageFormatGroup.nv21 // for Android
        : ImageFormatGroup.bgra8888, // for iOS
    fps: 15,
  );

  await controller.initialize();

  return controller;
}
