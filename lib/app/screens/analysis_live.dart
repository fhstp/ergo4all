import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/domain/image_conversion.dart';
import 'package:ergo4all/ui/pose_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

@immutable
class _Capture {
  final Pose pose;
  final Size imageSize;

  const _Capture({required this.pose, required this.imageSize});
}

class LiveAnalysisScreen extends StatefulWidget {
  const LiveAnalysisScreen({super.key});

  @override
  State<LiveAnalysisScreen> createState() => _LiveAnalysisScreenState();
}

class _LiveAnalysisScreenState extends State<LiveAnalysisScreen> {
  final _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
          model: PoseDetectionModel.accurate, mode: PoseDetectionMode.stream));
  CameraController? _activeCameraController;
  late final AppLifecycleListener _appLifecycleListener;
  late final CameraDescription _activeCamera;
  _Capture? _latestCapture;

  // TODO: Get frames from recorded video
  _processFrame(int timestamp, InputImage frame) async {
    final allPoses = await _poseDetector.processImage(frame);
    final pose = allPoses.singleOrNull;
    if (pose == null) return;

    setState(() {
      final imageSize = frame.metadata!.size;
      // For some reason, the width and height in the image are flipped.
      // So in order for the math in following code to be correct, we need
      // to flip it back. It seems like this only makes sense in portrait mode.
      // This might be an issue if we ever allow landscape mode. Then we
      // would need to use some dynamic logic to determine the image orientation.
      _latestCapture = _Capture(
          pose: pose, imageSize: Size(imageSize.height, imageSize.width));
    });

    // TODO: Update score
  }

  _onImageCaptured(CameraImage camerImage) {
    final deviceOrientation = _activeCameraController!.value.deviceOrientation;
    final cameraRotation =
        tryGetCameraRotation(deviceOrientation, _activeCamera);
    assert(cameraRotation != null);
    final inputImage = cameraImageToInputImage(camerImage, cameraRotation!);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _processFrame(timestamp, inputImage);
  }

  Future<Null> _initCamera() async {
    final cameras = await availableCameras();
    _activeCamera = cameras[0];
    final controller = CameraController(_activeCamera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21 // for Android
            : ImageFormatGroup.bgra8888, // for iOS
        fps: 15);
    await controller.initialize();
    await controller.startImageStream(_onImageCaptured);
    _activeCameraController = controller;
    setState(() {});
  }

  void _onScreenResumed() {
    if (_activeCameraController != null) return;
    _initCamera();
  }

  void _onScreenPaused() {
    _activeCameraController?.dispose();
    _activeCameraController = null;
  }

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
        onResume: _onScreenResumed, onPause: _onScreenPaused);
    _initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _appLifecycleListener.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeCameraController == null ||
        !_activeCameraController!.value.isInitialized) {
      return const Placeholder();
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_activeCameraController!),
          if (_latestCapture != null)
            Positioned.fill(
              child: CustomPaint(
                painter: PosePainter(
                    pose: _latestCapture!.pose,
                    inputImageSize: _latestCapture!.imageSize),
              ),
            ),
        ],
      ),
    );
  }
}
