import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/domain/image_conversion.dart';
import 'package:ergo4all/domain/image_utils.dart';
import 'package:ergo4all/domain/types.dart';
import 'package:ergo4all/app/ui/pose_painter.dart';
import 'package:ergo4all/app/ui/record_button.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

@immutable
class _Capture {
  final Pose pose;
  final Size imageSize;

  const _Capture({required this.pose, required this.imageSize});
}

class LiveAnalysisScreen extends StatefulWidget {
  final RequestCameraPermissions requestCameraPermissions;

  const LiveAnalysisScreen({super.key, required this.requestCameraPermissions});

  @override
  State<LiveAnalysisScreen> createState() => _LiveAnalysisScreenState();
}

class _LiveAnalysisScreenState extends State<LiveAnalysisScreen> {
  final _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
          model: PoseDetectionModel.accurate, mode: PoseDetectionMode.stream));
  CameraController? _activeCameraController;
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
    setState(() {});
  }

  Future<Null> _tryInitCamera() async {
    final isCameraPermissionGranted = await widget.requestCameraPermissions();
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
