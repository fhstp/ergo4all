import 'dart:async';
import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/common/activity.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/activity_explanation_popup.dart';
import 'package:ergo4all/results/detail/activity_selection_dropdown.dart';
import 'package:ergo4all/results/detail/image_carousel.dart';
import 'package:ergo4all/results/detail/rula_color_legend.dart';
import 'package:ergo4all/results/detail/score_heatmap_graph.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Page for displaying detailed information about a [RulaSession].
class DetailPage extends StatefulWidget {
  ///
  const DetailPage({required this.session, super.key});

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

    final activities =
        widget.session.timeline.map((it) => it.activity).nonNulls.toList();
    final highestRulaActivities =
        highestRulaActivitiesOf(widget.session.timeline).toList();

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

    void showActivityExplanationPopup() {
      unawaited(
        showDialog(
          context: context,
          builder: (_) => const ActivityExplanationPopup(),
        ),
      );
    }

    final heatmapHeight = MediaQuery.of(context).size.width * 0.65;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

    return SingleChildScrollView(
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

          const SizedBox(height: largeSpace),
          Row(
            spacing: mediumSpace,
            children: [
              Expanded(
                child: ActivitySelectionDropdown(
                  selected: selectedActivity,
                  options: highestRulaActivities,
                  onSelected: (activity) {
                    setState(() {
                      selectedActivity = activity;
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: showActivityExplanationPopup,
                icon: const Icon(Icons.info),
              ),
            ],
          ),
          const SizedBox(height: largeSpace * 2),
        ],
      ),
    );
  }
}
