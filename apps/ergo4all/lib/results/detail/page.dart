import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
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
import 'package:ergo4all/results/detail/scenario_good_bad_graphic.dart';
import 'package:ergo4all/results/detail/score_heatmap_graph.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

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

  String? selectedActivity;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    currentKeyFrame = widget.session.keyFrames.first;
  }

  int findClosestIndex(RulaTimeline list, int targetTimestamp) {
    if (list.isEmpty) return -1;

    var closestIndex = 0;
    var smallestDiff = (list[0].timestamp - targetTimestamp).abs();

    for (var i = 1; i < list.length; i++) {
      final diff = (list[i].timestamp - targetTimestamp).abs();
      if (diff < smallestDiff) {
        smallestDiff = diff;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final localizations = AppLocalizations.of(context)!;

    List<String> getUniqueActivities(List<String> activities) {
      final activityCounts = <String, int>{};

      // Count occurrences of each activity
      for (final activity in activities) {
        activityCounts[activity] = (activityCounts[activity] ?? 0) + 1;
      }

      final sortedActivities = activityCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      var uniqueActivities =
          sortedActivities.map((entry) => entry.key).toList();

      // limit to top 3 most frequent activities
      if (uniqueActivities.length > 3) {
        uniqueActivities = uniqueActivities.sublist(0, 3);
      }

      return [localizations.har_class_no_selection, ...uniqueActivities]
        ..remove(localizations.har_class_background)
        ..remove(localizations.har_class_walking);
    }

    final activities = widget.session.timeline
        .map(
          (e) => e.activity != null
              ? localizations.activityDisplayName(e.activity!)
              : localizations.activityDisplayName(Activity.background),
        )
        .toList();
    final uniqueActivities = getUniqueActivities(activities);
    final mostPopularActivity = uniqueActivities.length > 1
        ? uniqueActivities[1]
        : localizations.har_class_no_selection;

    // In freestyle mode, determine tips and improvements based on selected
    // activity
    final currentActivity = selectedActivity ?? mostPopularActivity;
    final textScenario = widget.session.scenario == Scenario.freestyle
        ? (Activity.getScenario(
              localizations.activityFromName(currentActivity),
            ) ??
            Scenario.freestyle)
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
    if (selectedActivity != null &&
        selectedActivity != localizations.har_class_no_selection) {
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
            child: DropdownMenu<String>(
              width: heatmapWidth,
              key: UniqueKey(),
              label: Text(
                localizations.har_activity_selection,
                style: dynamicBodyStyle,
              ),
              initialSelection: selectedActivity,
              dropdownMenuEntries: uniqueActivities
                  .map(
                    (entry) => DropdownMenuEntry(
                      value: entry,
                      label: entry,
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
              Center(
                child: ScenarioGoodBadGraphic(
                  widget.session.scenario,
                  height: 330,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
