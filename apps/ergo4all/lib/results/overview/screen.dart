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
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/overview/body_score_display.dart';
import 'package:ergo4all/results/overview/ergo_score_badge.dart';
import 'package:ergo4all/results/rating.dart';
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

    if (analysisResult.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final normalizedScoresByGroup =
        BodyPartGroup.groupScoresFrom(analysisResult.timeline)
            .mapValues((group, splitScores) {
      final maxScore = BodyPartGroup.maxScoreOf(group);
      return splitScores
          .map(
            (timeline) => timeline
                .map((score) => normalizeScore(score, maxScore))
                .toIList(),
          )
          .toIList();
    });

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

    void goToBodyPartPage(BodyPartGroup bodyPart) {
      Navigator.push(
        context,
        BodyPartResultsScreen.makeRoute(
          bodyPartGroup: bodyPart,
          timelines: normalizedScoresByGroup[bodyPart]!,
          recordingDuration: recordingDuration,
        ),
      );
    }

    final aggregate = aggregateTimeline(analysisResult.timeline)!;

    final totalRating = analysisResult.timeline
        .map((entry) => entry.scores.fullScore)
        .map((score) => normalizeScore(score, 7))
        .toIList()
        .pipe(Rating.calculate);

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
              goToBodyPartPage(BodyPartGroup.forPart(part));
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
