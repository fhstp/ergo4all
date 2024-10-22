import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/app/common/routes.dart';
import 'package:ergo4all/app/live_analysis/camera_permission_dialog.dart';
import 'package:ergo4all/app/live_analysis/pose_painter.dart';
import 'package:ergo4all/app/live_analysis/record_button.dart';
import 'package:ergo4all/pose.common/types.dart';
import 'package:ergo4all/pose.detection/types.dart';
import 'package:flutter/material.dart';

@immutable
class _Capture {
  final int timestamp;
  final Pose2D pose2d;

  const _Capture({
    required this.timestamp,
    required this.pose2d,
  });
}

class LiveAnalysisScreen extends StatefulWidget {
  final PoseDetector poseDetector;

  const LiveAnalysisScreen({super.key, required this.poseDetector});

  @override
  State<LiveAnalysisScreen> createState() => _LiveAnalysisScreenState();
}

class _LiveAnalysisScreenState extends State<LiveAnalysisScreen> {
  CameraController? _activeCameraController;
  late final CameraDescription _activeCamera;
  _Capture? _latestCapture;
  bool _isRecording = false;

  _processCapture(_Capture capture) async {
    // We only update score when recording
    if (!_isRecording) return;
    // TODO: Update score
  }

  _onImageCaptured(CameraImage cameraImage) async {
    final input = DetectInput(
        camera: _activeCamera,
        deviceOrientation: _activeCameraController!.value.deviceOrientation,
        image: cameraImage);
    final result = await widget.poseDetector.detect(input);

    if (result == null) {
      setState(() {
        _latestCapture = null;
      });
      return;
    }

    final capture = _Capture(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      pose2d: result.pose2d,
    );

    setState(() {
      _latestCapture = capture;
    });
    _processCapture(capture);
  }

  Future<Null> _startCaptureUsing(CameraDescription camera) async {
    _activeCamera = camera;
    final controller = CameraController(_activeCamera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21 // for Android
            : ImageFormatGroup.bgra8888, // for iOS
        fps: 15);
    await controller.initialize();
    await controller.startImageStream(_onImageCaptured);
    _activeCameraController = controller;
    await widget.poseDetector.start();
    setState(() {});
  }

  Future<Null> _tryInitCamera() async {
    final isCameraPermissionGranted = await showCameraPermissionDialog(context);
    if (!isCameraPermissionGranted) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final cameras = await availableCameras();
    await _startCaptureUsing(cameras[0]);
  }

  void _goToResults() {
    Navigator.of(context).pushReplacementNamed(Routes.results.path);
  }

  Future<Null> _stopCapture() async {
    _activeCameraController?.dispose();
    _activeCameraController = null;
    setState(() {});
  }

  void _onStoppedRecording() async {
    await _stopCapture();
    _goToResults();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (!_isRecording) _onStoppedRecording();
  }

  @override
  void initState() {
    super.initState();

    _tryInitCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeCameraController == null ||
        !_activeCameraController!.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: SizedBox(
              width: 200,
              height: 200,
              child: const CircularProgressIndicator()),
        ),
      );
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
                    pose: _latestCapture!.pose2d,
                  )),
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
