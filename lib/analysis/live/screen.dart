// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';
import 'package:ergo4all/analysis/live/camera_permission_dialog.dart';
import 'package:ergo4all/analysis/live/record_button.dart';
import 'package:ergo4all/analysis/live/viewmodel.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pose/src/pose_painter.dart';

class LiveAnalysisScreen extends HookWidget {
  const LiveAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(LiveAnalysisViewModel.new);

    void askForPermission() async {
      final isCameraPermissionGranted =
          await showCameraPermissionDialog(context);
      if (!isCameraPermissionGranted) {
        if (context.mounted) Navigator.of(context).pop();
        return;
      }

      viewModel.initializeCamera();
    }

    void goToResults() async {
      await Navigator.of(context).pushReplacementNamed(Routes.results.path);
    }

    final uiState = useValueListenable(viewModel.uiState);

    useEffect(() {
      if (uiState.isDone) {
        WidgetsBinding.instance.addPostFrameCallback((_) => goToResults());
      }
      return null;
    }, [uiState.isDone]);

    useEffect(() {
      if (uiState.cameraController.isNone()) askForPermission();
      return null;
    }, [uiState.cameraController]);

    if (uiState.cameraController.isNone()) {
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
              if (uiState.cameraController case Some(value: final controller))
                CameraPreview(controller),
              if (uiState.latestCapture case Some(value: final capture))
                Positioned.fill(
                  child: CustomPaint(
                      painter: PosePainter(
                    pose: capture.pose,
                    imageSize: capture.imageSize,
                  )),
                ),
            ],
          ),
          const Spacer(),
          RecordButton(
            isRecording: uiState.isRecording,
            onTap: viewModel.toggleRecording,
          )
        ],
      ),
    );
  }
}
