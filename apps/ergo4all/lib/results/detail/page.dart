import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:common/iterable_ext.dart';
import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/analysis/har/activity.dart';
import 'package:ergo4all/analysis/har/variable_localizations.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/detail/image_carousel.dart';
import 'package:ergo4all/results/detail/rula_color_legend.dart';
import 'package:ergo4all/results/detail/score_heatmap_graph.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;

List<Activity> _popularActivitiesFor(List<Activity> activities) {
  final counts = activities.countOccurrences();

  // These are the unique activities in the timeline sorted by how often
  // they appear.
  final sortedByPopularity = counts.entries
      .sortBy(Order.by((entry) => entry.value, Order.orderInt))
      .map((entry) => entry.key);

  // We pick the top 3 most frequent activities
  final top3 = sortedByPopularity.take(3);

  // There are also some activities which we don't care about
  final relevant = top3.delete(Activity.background).delete(Activity.walking);

  // So finally we have 0 - 3 popular activities
  return relevant.toList();
}

/// Page for displaying detailed information about a [RulaSession].
class DetailPage extends StatefulWidget {
  ///
  const DetailPage({required this.session, super.key});

  /// The route name for this screen.
  static const String routeName = 'result-detail';

  /// The session for which to view details.
  final RulaSession session;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with AutomaticKeepAliveClientMixin {
  late KeyFrame currentKeyFrame;

  Activity? selectedActivity;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    currentKeyFrame = widget.session.keyFrames.first;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final localizations = AppLocalizations.of(context)!;

    final activities =
        widget.session.timeline.map((it) => it.activity).nonNulls.toList();
    final popularActivities = _popularActivitiesFor(activities);
    final mostPopularActivity = popularActivities.firstOrNull;

    // In freestyle mode, determine tips and improvements based on selected
    // activity
    final currentActivity = selectedActivity ?? mostPopularActivity;
    final textScenario = widget.session.scenario == Scenario.freestyle
        ? (currentActivity != null
            ? Activity.getScenario(currentActivity) ?? Scenario.freestyle
            : Scenario.freestyle)
        : widget.session.scenario;

    final tips = localizations.scenarioTip(textScenario);
    final improvements = localizations.scenarioImprovement(textScenario);

    if (widget.session.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final recordingDuration = Duration(
      milliseconds: widget.session.timeline.last.timestamp -
          widget.session.timeline.first.timestamp,
    );

    final normalizedScoresByGroup =
        BodyPartGroup.groupScoresFrom(widget.session.timeline)
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

    final worstAveragesByGroup = normalizedScoresByGroup
        .mapValues(
          (_, splitScores) => splitScores
              .map((scores) => calculateRunningAverage(scores, 20))
              .toIList(),
        )
        .mapValues((_, splitScores) => splitScores.reduce2d(max));

    IList<bool>? activityFilter;
    if (selectedActivity != null) {
      activityFilter =
          activities.map((activity) => activity == selectedActivity).toIList();
    }

    void navigateToBodyPartPage(BodyPartGroup bodyPart) {
      Navigator.push(
        context,
        BodyPartResultsScreen.makeRoute(
          bodyPartGroup: bodyPart,
          timelines: normalizedScoresByGroup[bodyPart]!,
          recordingDuration: recordingDuration.inSeconds,
          activities: activities.lock,
        ),
      );
    }

    final heatmapHeight = MediaQuery.of(context).size.width * 0.65;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageCarousel(
            images: widget.session.keyFrames
                .map((keyFrame) => keyFrame.screenshot)
                .toList(),
            onPageChanged: (index) {
              setState(() {
                currentKeyFrame = widget.session.keyFrames[index];
              });
            },
          ),
          const SizedBox(height: largeSpace),

          // Heatmap vis of the body parts
          Center(
            child: SizedBox(
              key: const Key('heatmap'),
              width: heatmapWidth,
              height: heatmapHeight,
              child: ScoreHeatmapGraph(
                timelinesByGroup: worstAveragesByGroup,
                recordingDuration: recordingDuration,
                highlightTime: Duration(
                  milliseconds: currentKeyFrame.timestamp -
                      widget.session.timeline.first.timestamp,
                ),
                activityFilter: activityFilter,
                onGroupTapped: navigateToBodyPartPage,
              ),
            ),
          ),

          const SizedBox(height: largeSpace),

          // Color legend
          Center(
            child: SizedBox(
              height: 50,
              width: heatmapWidth,
              child: const RulaColorLegend(),
            ),
          ),

          // Human action recognition activity selector
          const SizedBox(height: 16),

          Center(
            child: DropdownMenu<Activity?>(
              width: heatmapWidth,
              key: UniqueKey(),
              label: Text(
                localizations.har_activity_selection,
                style: dynamicBodyStyle,
              ),
              initialSelection: selectedActivity,
              dropdownMenuEntries: popularActivities
                  .map(
                    (activity) => DropdownMenuEntry<Activity?>(
                      value: activity,
                      label: localizations.activityDisplayName(activity),
                      style: ButtonStyle(
                        textStyle: WidgetStateProperty.all(dynamicBodyStyle),
                      ),
                    ),
                  )
                  .prepend(
                    DropdownMenuEntry(
                      value: null,
                      label: localizations.har_class_no_selection,
                      style: ButtonStyle(
                        textStyle: WidgetStateProperty.all(dynamicBodyStyle),
                      ),
                    ),
                  )
                  .toList(),
              onSelected: (newActivity) {
                setState(() {
                  selectedActivity = newActivity;
                });
              },
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: woodSmoke, width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: dynamicBodyStyle,
                hintStyle: dynamicBodyStyle,
              ),
              textStyle: dynamicBodyStyle,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: largeSpace),
              Text(
                localizations.ergonomics_tipps,
                style: paragraphHeaderStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                tips,
                style: dynamicBodyStyle,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: mediumSpace),
              Text(
                localizations.improvements,
                style: paragraphHeaderStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                improvements,
                style: dynamicBodyStyle,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
