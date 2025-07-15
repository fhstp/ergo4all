import 'package:common/func_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:flutter/material.dart' hide Page, ProgressIndicator;
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_tester/src/page.dart';
import 'package:pose_tester/src/progress_indicator.dart';
import 'package:pose_tester/src/rula_score_display.dart';
import 'package:rula/rula.dart';

/// Page for displaying score.
class ScorePage extends StatefulWidget {
  /// Creates a widget instance.
  const ScorePage({required this.angles, super.key});

  /// The angles to display.
  final Option<PoseAngles> angles;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Option<RulaScores> currentScores = none();

  Future<void> refreshSheet() async {
    setState(() {
      currentScores = none();
    });

    await Future.value(Null);

    widget.angles.match(() {}, (angles) {
      setState(() {
        currentScores = Some(rulaSheetFromAngles(angles)).map(scoresOf);
      });
    });
  }

  @override
  void didUpdateWidget(covariant ScorePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    refreshSheet();
  }

  @override
  void initState() {
    super.initState();
    refreshSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'Score',
      body: currentScores.match(
        ProgressIndicator.new,
        (scores) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScoreDisplay(
                label: 'Full',
                score: scores.fullScore,
                maxScore: 7,
                level: 0,
              ),
              ScoreDisplay(
                label: 'Upper arm',
                score: scores.upperArmScores.pipe(Pair.reduce(worse)),
                maxScore: 6,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Shoulder flexion',
                score: scores.upperArmPositionScores.pipe(Pair.reduce(worse)),
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Shoulder abduction',
                score:
                    scores.upperArmAbductedAdjustments.pipe(Pair.reduce(worse)),
                maxScore: 1,
                minScore: 0,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Lower arm',
                score: scores.lowerArmScores.pipe(Pair.reduce(worse)),
                maxScore: 3,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Elbow flexion',
                score: scores.lowerArmPositionScores.pipe(Pair.reduce(worse)),
                maxScore: 2,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Wrist flexion',
                score: scores.wristScores.pipe(Pair.reduce(worse)),
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Neck',
                score: scores.neckScore,
                maxScore: 6,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Flexion',
                score: scores.neckPositionScore,
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Lateral flexion',
                score: scores.neckSideBendAdjustment,
                minScore: 0,
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Twist',
                score: scores.neckTwistAdjustment,
                minScore: 0,
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Trunk',
                score: scores.trunkScore,
                maxScore: 6,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Hip flexion',
                score: scores.trunkPositionScore,
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Twist',
                score: scores.trunkTwistAdjustment,
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Lateral flexion',
                score: scores.trunkSideBendAdjustment,
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Leg',
                score: scores.legScores.pipe(Pair.reduce(worse)),
                maxScore: 3,
                level: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
