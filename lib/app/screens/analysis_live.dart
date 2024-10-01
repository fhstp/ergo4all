import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/domain/image_conversion.dart';
import 'package:ergo4all/domain/image_utils.dart';
import 'package:ergo4all/ui/pose_painter.dart';
import 'package:ergo4all/ui/record_button.dart';
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
  bool _isRecording = false;

  // TODO: Get frames from recorded video
  _processFrame(int timestamp, InputImage frame, Size imageSize) async {
    final allPoses = await _poseDetector.processImage(frame);
    final pose = allPoses.singleOrNull;

    setState(() {
      _latestCapture =
          pose != null ? _Capture(pose: pose, imageSize: imageSize) : null;
    });

    // We only update score when recording
    if (!_isRecording) return;
    // TODO: Update score
  }

  _onImageCaptured(CameraImage cameraImage) {
    final deviceOrientation = _activeCameraController!.value.deviceOrientation;
    final cameraRotation =
        tryGetCameraRotation(deviceOrientation, _activeCamera);
    assert(cameraRotation != null);
    final inputImage = cameraImageToInputImage(cameraImage, cameraRotation!);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _processFrame(timestamp, inputImage, getRotatedImageSize(cameraImage));
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

  void onStoppedRecording() {
    Navigator.of(context).pushReplacementNamed(Routes.results.path);
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (!_isRecording) onStoppedRecording();
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
      body: Column(
        children: [
          Stack(
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
          const Spacer(),
          RecordButton(
            isRecording: _isRecording,
            onTap: _toggleRecording,
          )
        ],
      ),
    );
  }
}
