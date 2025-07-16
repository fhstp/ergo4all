import 'dart:async';

import 'package:common/func_ext.dart';
import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/analysis/common.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/score_group_detail/screen.dart';
import 'package:ergo4all/results/score_group.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/overview/body_score_display.dart';
import 'package:ergo4all/results/overview/ergo_score_badge.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

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

    if (analysisResult.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final normalizedScoresByGroup = IMap.fromKeys(
      keys: ScoreGroup.valuesSplit,
      valueMapper: (group) => analysisResult.timeline.map((entry) {
        final scores = entry.scores;
        final score = scores.scoreOfGroup(group, mergeScores: worse);
        return ScoreGroup.normalizeFor(group, score);
      }).toIList(),
    );

    final averageScoresByGroup = normalizedScoresByGroup
        .mapValues((scores) => calculateRunningAverage(scores, 20));

    final recordingDuration = Duration(
      milliseconds: analysisResult.timeline.last.timestamp -
          analysisResult.timeline.first.timestamp,
    ).inSeconds;

    void goToDetails() {
      Navigator.of(context).pushNamed(
        Routes.resultsDetail.path,
        arguments: analysisResult,
      );
    }

    void recordAgain() {
      unawaited(
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.liveAnalysis.path,
          ModalRoute.withName(Routes.home.path),
          arguments: analysisResult.scenario,
        ),
      );
    }

    void goToScoreGroupPage(ScoreGroup group) {
      Navigator.push(
        context,
        ScoreGroupResultsScreen.makeRoute(
          scoreGroup: group,
          // We use the averaged scores on the detail screen
          normalizedScores: averageScoresByGroup[group]!,
          // We display the median values on the detail screen
          staticLoadScores:
              calculateRunningMedian(normalizedScoresByGroup[group]!, 20),
          recordingDuration: recordingDuration,
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
        leading: const IconBackButton(),
        title: Text(localizations.results_ergo_score_header),
      ),
      body: Column(
        children: [
          SizedBox(height: 80, child: ErgoScoreBadge(rating: totalRating)),
          BodyScoreDisplay(
            aggregate,
            onBodyPartTapped: (part) {
              goToScoreGroupPage(ScoreGroup.forPart(part));
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
            style: primaryTextButtonStyle,
            child: const Text('Details'),
          ),
          const SizedBox(height: smallSpace),
          ElevatedButton(
            onPressed: recordAgain,
            style: secondaryTextButtonStyle,
            child:
                Text(localizations.record_again, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
