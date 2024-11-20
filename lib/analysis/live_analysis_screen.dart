import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:ergo4all/analysis/camera_permission_dialog.dart';
import 'package:ergo4all/analysis/pose_painter.dart';
import 'package:ergo4all/analysis/record_button.dart';
import 'package:ergo4all/common/hook_ext.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pose/pose.dart';
import 'package:rula/rula.dart';

@immutable
class _Capture {
  final int timestamp;
  final Pose2D pose2d;

  const _Capture({
    required this.timestamp,
    required this.pose2d,
  });
}

class LiveAnalysisScreen extends HookWidget {
  const LiveAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final random = useMemoized(() => Random());
    final (currentScore, setCurrentScore) = useState<RulaScore?>(null).split();
    final (cameraController, setCameraController) =
        useState<CameraController?>(null).split();
    final (activeCamera, setActiveCamera) =
        useState<CameraDescription?>(null).split();
    final (latestCapture, setLatestCapture) = useState<_Capture?>(null).split();
    final (isRecording, setRecording) = useState(false).split();

    Degree randomAngle(double min, double max) {
      return Degree.makeFrom180(min + random.nextDouble() * (max - min));
    }

    processCapture(_Capture capture) async {
      // TODO: Calculate real rula sheet
      final sheet = RulaSheet(
          shoulderFlexion: randomAngle(-180, 180),
          shoulderAbduction: randomAngle(0, 180),
          elbowFlexion: randomAngle(0, 180),
          wristFlexion: randomAngle(-180, 180),
          neckFlexion: randomAngle(-90, 90),
          neckRotation: randomAngle(-180, 180),
          neckLateralFlexion: randomAngle(-90, 90),
          hipFlexion: randomAngle(0, 180),
          trunkRotation: randomAngle(-180, 180),
          trunkLateralFlexion: randomAngle(-90, 90),
          isStandingOnBothLegs: random.nextDouble() > 0.5);
      final finalScore = calcFullRulaScore(sheet);

      setCurrentScore(finalScore);
    }

    onImageCaptured(CameraImage cameraImage) async {
      final result = await detectPose(activeCamera!,
          cameraController!.value.deviceOrientation, cameraImage);

      if (result == null) {
        setLatestCapture(null);
        return;
      }

      final capture = _Capture(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        pose2d: result.pose2d,
      );

      setLatestCapture(capture);

      if (isRecording) processCapture(capture);
    }

    useEffect(() {
      if (cameraController == null) return null;

      cameraController
          .startImageStream(onImageCaptured)
          .then((_) => startPoseDetection());

      return cameraController.stopImageStream;
    }, [cameraController]);

    useEffect(() {
      if (activeCamera == null) return null;
      final controller = CameraController(activeCamera, ResolutionPreset.medium,
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid
              ? ImageFormatGroup.nv21 // for Android
              : ImageFormatGroup.bgra8888, // for iOS
          fps: 15);

      controller.initialize().then((_) => setCameraController(controller));

      return controller.dispose;
    }, [activeCamera]);

    Future<Null> tryInitCamera() async {
      final isCameraPermissionGranted =
          await showCameraPermissionDialog(context);
      if (!isCameraPermissionGranted) {
        if (context.mounted) Navigator.of(context).pop();
        return;
      }

      final cameras = await availableCameras();
      setActiveCamera(cameras[0]);
    }

    void goToResults() {
      Navigator.of(context).pushReplacementNamed(Routes.results.path);
    }

    Future<Null> stopCapture() async {
      cameraController?.dispose();
      await stopPoseDetection();
      setCameraController(null);
    }

    void onStoppedRecording() async {
      await stopCapture();
      goToResults();
    }

    void toggleRecording() {
      setRecording(!isRecording);

      // We don't ! here because, we still have the "old" value
      if (isRecording) onStoppedRecording();
    }

    useEffect(() {
      tryInitCamera();
      return null;
    }, [null]);

    if (cameraController == null || !cameraController.value.isInitialized) {
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
              CameraPreview(cameraController),
              if (latestCapture != null)
                Positioned.fill(
                  child: CustomPaint(
                      painter: PosePainter(
                    pose: latestCapture.pose2d,
                  )),
                ),
              if (currentScore != null)
                Positioned(
                    top: largeSpace,
                    right: largeSpace,
                    // TODO: Add proper stringified version of rula label with localization
                    child:
                        Text("$currentScore: ${rulaLabelFor(currentScore)}")),
            ],
          ),
          const Spacer(),
          RecordButton(
            isRecording: isRecording,
            onTap: toggleRecording,
          )
        ],
      ),
    );
  }
}
