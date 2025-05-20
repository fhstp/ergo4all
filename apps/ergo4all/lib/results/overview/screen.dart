import 'package:common/func_ext.dart';
import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/styles.dart';
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
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// The screen for viewing an overview over the analysis results.
class ResultsOverviewScreen extends StatelessWidget {
  ///
  const ResultsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final timeline =
        ModalRoute.of(context)!.settings.arguments as RulaTimeline?;

    if (timeline == null || timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final normalizedScoresByGroup = IMap.fromKeys(
      keys: BodyPartGroup.values,
      valueMapper: (bodyPartGroup) => timeline
          .map((entry) => entry.scores)
          .map(
            (scores) => normalizedBodyPartGroupScoreOf(scores, bodyPartGroup),
          )
          .toIList(),
    );

    final averageScoresByGroup = normalizedScoresByGroup
        .mapValues((scores) => calculateRunningAverage(scores, 20));

    void goToDetails() {
      Navigator.of(context)
          .pushNamed(Routes.resultsDetail.path, arguments: timeline);
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

    final aggregate = aggregateTimeline(timeline)!;

    final totalRating = timeline
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
