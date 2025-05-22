import 'package:common/func_ext.dart';
import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/analysis/common.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/overview/body_score_display.dart';
import 'package:ergo4all/results/overview/ergo_score_badge.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:ergo4all/scenario/domain.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// The screen for viewing an overview over the [AnalysisResult].
class ResultsOverviewScreen extends StatelessWidget {
  ///
  const ResultsOverviewScreen({
    required this.analysisResult,
    super.key,
  });

  /// The result to view.
  final AnalysisResult analysisResult;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Take out and move to results detail screen??
    final tips = switch (analysisResult.scenario) {
      Scenario.liftAndCarry => localizations.scenario_lift_and_carry_tips,
      Scenario.pull => localizations.scenario_pull_tips,
      Scenario.seated => localizations.scenario_seated_tips,
      Scenario.packaging => localizations.scenario_packaging_tips,
      Scenario.standingCNC => localizations.scenario_CNC_tips,
      Scenario.standingAssembly => localizations.scenario_assembly_tips,
      Scenario.ceiling => localizations.scenario_ceiling_tips,
      Scenario.lift25 => localizations.scenario_lift_tips,
      Scenario.conveyorBelt => localizations.scenario_conveyor_tips,
    };

    if (analysisResult.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final normalizedScoresByGroup = IMap.fromKeys(
      keys: BodyPartGroup.values,
      valueMapper: (bodyPartGroup) => analysisResult.timeline
          .map((entry) => entry.scores)
          .map(
            (scores) => normalizedBodyPartGroupScoreOf(scores, bodyPartGroup),
          )
          .toIList(),
    );

    final averageScoresByGroup = normalizedScoresByGroup
        .mapValues((scores) => calculateRunningAverage(scores, 20));

    void goToDetails() {
      Navigator.of(context).pushNamed(
        Routes.resultsDetail.path,
        arguments: analysisResult,
      );
      //arguments: timeline);
    }

    void goToBodyPartPage(BodyPartGroup bodyPart) {
      Navigator.push(
        context,
        BodyPartResultsScreen.makeRoute(
          bodyPartGroup: bodyPart,
          // We use the averaged scores on the detail screen
          normalizedScores: averageScoresByGroup[bodyPart]!,
          // We display the median values on the detail screen
          staticLoadScores:
              calculateRunningMedian(normalizedScoresByGroup[bodyPart]!, 20),
        ),
      );
    }

    final aggregate = aggregateTimeline(analysisResult.timeline)!;

    final totalRating = analysisResult.timeline
        .map((entry) => entry.scores.fullScore)
        .map((score) => normalizeScore(score, 7))
        .toIList()
        .pipe(calculateRating);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${localizations.results_ergo_score_header}:',
          style: h2Style,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 80, child: ErgoScoreBadge(rating: totalRating)),
          BodyScoreDisplay(
            aggregate,
            onBodyPartTapped: (part) {
              goToBodyPartPage(groupOf(part));
            },
          ),
          Text(
            localizations.results_press_body_part,
            style: staticBodyStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: mediumSpace),
          ElevatedButton(
            onPressed: goToDetails,
            style: secondaryTextButtonStyle,
            child: const Text('Details'),
          ),
        ],
      ),
    );
  }
}
