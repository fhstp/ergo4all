// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';
import 'package:ergo4all/analysis/live/camera_permission_dialog.dart';
import 'package:ergo4all/analysis/live/pose_painter.dart';
import 'package:ergo4all/analysis/live/record_button.dart';
import 'package:ergo4all/analysis/live/viewmodel.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rula/rula.dart';

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
      if (uiState.cameraController == null) askForPermission();
      return null;
    }, [uiState.cameraController]);

    if (uiState.cameraController == null) {
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
              if (uiState.cameraController != null)
                CameraPreview(uiState.cameraController!),
              if (uiState.latestCapture != null)
                Positioned.fill(
                  child: CustomPaint(
                      painter: PosePainter(
                    pose: uiState.latestCapture!.pose,
                    imageSize: uiState.latestCapture!.imageSize,
                  )),
                ),
              if (uiState.currentScore != null)
                Positioned(
                    top: largeSpace,
                    right: largeSpace,
                    // TODO: Add proper stringified version of rula label with localization
                    child: Text(
                        "${uiState.currentScore}: ${rulaLabelFor(uiState.currentScore!)}")),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: uiState.angles
                          .mapTo((keyAngle, degrees) =>
                              Text("${keyAngle.name}: ${degrees.toInt()}°"))
                          .toList(),
                    ),
                  ))
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
