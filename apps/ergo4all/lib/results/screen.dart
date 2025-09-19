import 'dart:async';

import 'package:common/func_ext.dart';
import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/analysis/screen.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/page.dart';
import 'package:ergo4all/results/overview/page.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// The screen for viewing a [RulaSession].
class ResultsScreen extends StatelessWidget {
  ///
  const ResultsScreen({
    required this.session,
    required this.profile,
    super.key,
  });

  /// The route name for this screen.
  static const String routeName = 'results';

  /// Creates a [MaterialPageRoute] to navigate to this screen to view
  /// the [session] for a [profile].
  static MaterialPageRoute<void> makeRoute(
    RulaSession session,
    Profile profile,
  ) {
    return MaterialPageRoute(
      builder: (_) => ResultsScreen(
        session: session,
        profile: profile,
      ),
      settings: const RouteSettings(name: routeName),
    );
  }

  /// The session to view.
  final RulaSession session;

  /// The profile that was used.
  final Profile profile;

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

    final activities = session.timeline.map((e) => e.activity).toIList();

    final recordingDuration = Duration(
      milliseconds:
          session.timeline.last.timestamp - session.timeline.first.timestamp,
    ).inSeconds;

    void recordAgain() {
      unawaited(
        Navigator.of(context).pushAndRemoveUntil(
          LiveAnalysisScreen.makeRoute(session.scenario, profile),
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
          activities: activities,
        ),
      );
    }

    final aggregate = aggregateTimeline(session.timeline)!;

    final totalRating = session.timeline
        .map((entry) => entry.scores.fullScore)
        .map((score) => normalizeScore(score, 7))
        .toIList()
        .pipe(Rating.calculate);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const IconBackButton(color: cardinal),
          title: Text(localizations.results_title),
          bottom: const TabBar(
            tabs: [
              // TODO: Localize
              Tab(text: 'Overview'),
              Tab(text: 'Details'),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    OverviewPage(
                      rating: totalRating,
                      scores: aggregate,
                      onBodyPartGroupTapped: goToBodyPartPage,
                    ),
                    DetailPage(session: session),
                  ],
                ),
              ),
              const SizedBox(height: largeSpace),
              ElevatedButton(
                onPressed: recordAgain,
                style: secondaryTextButtonStyle,
                child: Text(
                  localizations.record_again,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: largeSpace),
            ],
          ),
        ),
      ),
    );
  }
}
