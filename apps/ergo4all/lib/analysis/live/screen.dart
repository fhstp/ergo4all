import 'package:camera/camera.dart';
import 'package:common_ui/widgets/paint_on_image.dart';
import 'package:ergo4all/analysis/live/camera_permission_dialog.dart';
import 'package:ergo4all/analysis/live/record_button.dart';
import 'package:ergo4all/analysis/live/viewmodel.dart';
import 'package:ergo4all/common/loading_indicator.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pose_vis/pose_vis.dart';

/// Screen with a camera-view for analyzing live-recorded footage.
class LiveAnalysisScreen extends HookWidget {
  /// Creates a [LiveAnalysisScreen].
  const LiveAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(LiveAnalysisViewModel.new);

    Future<void> askForPermission() async {
      final isCameraPermissionGranted =
          await showCameraPermissionDialog(context);
      if (!isCameraPermissionGranted) {
        if (context.mounted) Navigator.of(context).pop();
        return;
      }

      await viewModel.initializeCamera();
    }

    Future<void> goToResults() async {
      await Navigator.of(context).pushReplacementNamed(
        Routes.results.path,
        arguments: viewModel.timeline,
      );
    }

    final uiState = useValueListenable(viewModel.uiState);

    useEffect(
      () {
        if (uiState.isDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) => goToResults());
        }
        return null;
      },
      [uiState.isDone],
    );

    useEffect(
      () {
        if (uiState.cameraController.isNone()) askForPermission();
        return null;
      },
      [uiState.cameraController],
    );

    if (uiState.cameraController.isNone()) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          uiState.cameraController.match(
            LoadingIndicator.new,
            (controller) => PaintOnWidget(
              base: CameraPreview(controller),
              painter: uiState.latestCapture.match(
                () => null,
                (capture) => Pose3dPainter(
                  pose: capture.pose,
                  imageSize: capture.imageSize,
                ),
              ),
            ),
          ),
          const Spacer(),
          RecordButton(
            isRecording: uiState.isRecording,
            onTap: () {
              if (uiState.isRecording) {
                viewModel.stopRecording();
              } else {
                viewModel.startRecording();
              }
            },
          ),
        ],
      ),
    );
  }
}
