import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/domain/action_recognition.dart';
import 'package:ergo4all/domain/scoring.dart';
import 'package:ergo4all/domain/video_score.dart';
import 'package:ergo4all/ui/header.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  VideoScore _score = VideoScore.empty;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
  }

  _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.results.path);
    }
  }

  // TODO: Get frames from live video
  // TODO: Get frames from recorded video
  _processFrame(int timestamp, InputImage frame) async {
    final allPoses = await _poseDetector.processImage(frame);
    final pose = allPoses.single;
    // TODO: Visualize pose
    final action = determineAction(pose);
    final bodyScore = scorePose(action, pose);
    _score = _score.addScore(timestamp, bodyScore);
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
