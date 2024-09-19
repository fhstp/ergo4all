import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/domain/action_recognition.dart';
import 'package:ergo4all/domain/image_conversion.dart';
import 'package:ergo4all/domain/scoring.dart';
import 'package:ergo4all/domain/video_score.dart';
import 'package:ergo4all/ui/header.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../ui/loading_indicator.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
          model: PoseDetectionModel.accurate, mode: PoseDetectionMode.stream));
  CameraController? _activeCameraController;
  VideoScore _score = VideoScore.empty;
  late final AppLifecycleListener _appLifecycleListener;
  late final CameraDescription _activeCamera;

  // TODO: Get frames from recorded video
  _processFrame(int timestamp, InputImage frame) async {
    final allPoses = await _poseDetector.processImage(frame);
    final pose = allPoses.singleOrNull;
    if (pose == null) return;

    // TODO: Visualize pose
    final action = determineAction(pose);
    final bodyScore = scorePose(action, pose);
    _score = _score.addScore(timestamp, bodyScore);
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
    final controller = CameraController(
      _activeCamera, ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );
    await controller.initialize();
    await controller.startImageStream(_onImageCaptured);
    _activeCameraController = controller;
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: ScreenContent(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(localizations.analysis_header),
            const FractionallySizedBox(
              widthFactor: 0.5,
              child: LoadingIndicator(),
            ),
            const SizedBox(
              height: largeSpace,
            ),
            Text(localizations.analysis_wait)
          ],
        ),
      ),
    );
  }
}
