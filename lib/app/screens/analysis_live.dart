import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/domain/image_conversion.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

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
  Pose? _currentPose;

  // TODO: Get frames from recorded video
  _processFrame(int timestamp, InputImage frame) async {
    final allPoses = await _poseDetector.processImage(frame);
    final pose = allPoses.singleOrNull;
    if (pose == null) return;

    // TODO: Visualize pose
    setState(() {
      _currentPose = pose;
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
    return Scaffold(
      body: _activeCameraController != null
          ? CameraPreview(_activeCameraController!)
          : const Placeholder(),
    );
  }
}
