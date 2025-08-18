import 'dart:async';

import 'package:common/func_ext.dart';
import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/analysis/screen.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/overview/body_score_display.dart';
import 'package:ergo4all/results/overview/ergo_score_badge.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// The screen for viewing an overview over the [RulaSession].
class ResultsOverviewScreen extends StatelessWidget {
  ///
  const ResultsOverviewScreen({
    required this.session,
    super.key,
  });

  /// The route name for this screen.
  static const String routeName = 'results-overview';

  /// Creates a [MaterialPageRoute] to navigate to this screen to view
  /// the given [session].
  static MaterialPageRoute<void> makeRoute(RulaSession session) {
    return MaterialPageRoute(
      builder: (_) => ResultsOverviewScreen(session: session),
      settings: const RouteSettings(name: routeName),
    );
  }

  /// The session to view.
  final RulaSession session;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (session.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final normalizedScoresByGroup =
        BodyPartGroup.groupScoresFrom(session.timeline)
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
      milliseconds:
          session.timeline.last.timestamp - session.timeline.first.timestamp,
    ).inSeconds;

    void goToDetails() {
      Navigator.of(context).pushNamed(
        Routes.resultsDetail.path,
        arguments: session,
      );
    }

    void recordAgain() {
      unawaited(
        Navigator.of(context).pushAndRemoveUntil(
          LiveAnalysisScreen.makeRoute(session.scenario),
          ModalRoute.withName(HomeScreen.routeName),
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

    final aggregate = aggregateTimeline(session.timeline)!;

    final totalRating = session.timeline
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
