import 'package:flutter/material.dart' hide Page, ProgressIndicator;
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_tester/src/page.dart';
import 'package:pose_tester/src/progress_indicator.dart';
import 'package:pose_tester/src/rula_score_display.dart';
import 'package:rula/rula.dart';

class ScorePage extends StatefulWidget {
  final Option<PoseAngles> angles;

  const ScorePage({super.key, required this.angles});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Option<RulaSheet> currentSheet = none();

  void refreshSheet() async {
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
        title: "Score",
        body: currentSheet.match(
            () => ProgressIndicator(),
            (sheet) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RulaScoreDisplay(
                          label: "Full",
                          score: calcFullRulaScore(sheet).value,
                          maxScore: 7,
                          level: 0),
                      RulaScoreDisplay(
                          label: "Upper arm",
                          score: calcUpperArmScore(sheet).value,
                          maxScore: 6,
                          level: 1),
                      RulaScoreDisplay(
                          label: "Shoulder flexion",
                          score: calcShoulderFlexionScore(sheet).value,
                          maxScore: 4,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Shoulder abduction",
                          score: calcShoulderAbductionBonus(sheet),
                          maxScore: 1,
                          minScore: 0,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Lower arm",
                          score: calcLowerArmScore(sheet).value,
                          maxScore: 3,
                          level: 1),
                      RulaScoreDisplay(
                          label: "Elbow flexion",
                          score: calcElbowFlexionScore(sheet).value,
                          maxScore: 2,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Neck",
                          score: calcNeckScore(sheet).value,
                          maxScore: 6,
                          level: 1),
                      RulaScoreDisplay(
                          label: "Flexion",
                          score: calcNeckFlexionScore(sheet).value,
                          maxScore: 4,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Lateral flexion",
                          score: calcLateralNeckFlexionBonus(sheet),
                          minScore: 0,
                          maxScore: 1,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Twist",
                          score: calcNeckTwistBonus(sheet),
                          minScore: 0,
                          maxScore: 1,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Trunk",
                          score: calcTrukScore(sheet).value,
                          maxScore: 6,
                          level: 1),
                      RulaScoreDisplay(
                          label: "Hip flexion",
                          score: calcHipFlexionScore(sheet).value,
                          maxScore: 4,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Twist",
                          score: calcTrunkTwistBonus(sheet),
                          maxScore: 1,
                          minScore: 1,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Lateral flexion",
                          score: calcTrunkLateralFlexionBonus(sheet),
                          maxScore: 1,
                          minScore: 1,
                          level: 2),
                      RulaScoreDisplay(
                          label: "Leg",
                          score: calcLegScore(sheet).value,
                          maxScore: 2,
                          level: 1),
                    ],
                  ),
                )));
  }
}
