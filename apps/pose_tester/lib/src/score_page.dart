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
  Option<RulaSheet> currentSheet = none();

  Future<void> refreshSheet() async {
    setState(() {
      currentSheet = none();
    });

    await Future.value(Null);

    widget.angles.match(() {}, (angles) {
      setState(() {
        currentSheet = Some(rulaSheetFromAngles(angles));
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
      body: currentSheet.match(
        ProgressIndicator.new,
        (sheet) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScoreDisplay(
                label: 'Full',
                score: calcFullScore(sheet),
                maxScore: 7,
                level: 0,
              ),
              ScoreDisplay(
                label: 'Upper arm',
                score: calcUpperArmScore(sheet).pipe(Pair.reduce(worse)),
                maxScore: 6,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Shoulder flexion',
                score: calcShoulderFlexionScore(sheet).pipe(Pair.reduce(worse)),
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Shoulder abduction',
                score:
                    calcShoulderAbductionBonus(sheet).pipe(Pair.reduce(worse)),
                maxScore: 1,
                minScore: 0,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Lower arm',
                score: calcLowerArmScore(sheet).pipe(Pair.reduce(worse)),
                maxScore: 3,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Elbow flexion',
                score: calcElbowFlexionScore(sheet).pipe(Pair.reduce(worse)),
                maxScore: 2,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Wrist flexion',
                score: calcWristScore(sheet).pipe(Pair.reduce(worse)),
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Neck',
                score: calcNeckScore(sheet),
                maxScore: 6,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Flexion',
                score: calcNeckFlexionScore(sheet),
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Lateral flexion',
                score: calcLateralNeckFlexionBonus(sheet),
                minScore: 0,
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Twist',
                score: calcNeckTwistBonus(sheet),
                minScore: 0,
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Trunk',
                score: calcTrukScore(sheet),
                maxScore: 6,
                level: 1,
              ),
              ScoreDisplay(
                label: 'Hip flexion',
                score: calcHipFlexionScore(sheet),
                maxScore: 4,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Twist',
                score: calcTrunkTwistBonus(sheet),
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Lateral flexion',
                score: calcTrunkLateralFlexionBonus(sheet),
                maxScore: 1,
                level: 2,
              ),
              ScoreDisplay(
                label: 'Leg',
                score: calcLegScore(sheet),
                maxScore: 2,
                level: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
