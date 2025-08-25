import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
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
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Screen for displaying detailed information about a [RulaSession].
class ResultsDetailScreen extends StatefulWidget {
  ///
  const ResultsDetailScreen({required this.session, super.key});

  /// The route name for this screen.
  static const String routeName = 'result-detail';

  /// Creates a [MaterialPageRoute] to navigate to this screen and view
  /// the given [session].
  static MaterialPageRoute<void> makeRoute(RulaSession session) {
    return MaterialPageRoute(
      builder: (_) => ResultsDetailScreen(session: session),
      settings: const RouteSettings(name: routeName),
    );
  }

  /// The session for which to view details.
  final RulaSession session;

  @override
  State<ResultsDetailScreen> createState() => _ResultsDetailScreenState();
}

class _ResultsDetailScreenState extends State<ResultsDetailScreen> {

  late KeyFrame currentKeyFrame;

  @override
  void initState() {
    super.initState();
    currentKeyFrame = widget.session.keyFrames.first;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final tips = localizations.scenarioTip(widget.session.scenario);
    final improvements = localizations.scenarioImprovement(widget.session.scenario);

    if (widget.session.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final recordingDuration = Duration(
      milliseconds:
          widget.session.timeline.last.timestamp - widget.session.timeline.first.timestamp,
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

    void navigateToBodyPartPage(BodyPartGroup bodyPart) {
      Navigator.push(
        context,
        BodyPartResultsScreen.makeRoute(
          bodyPartGroup: bodyPart,
          timelines: normalizedScoresByGroup[bodyPart]!,
          recordingDuration: recordingDuration.inSeconds,
        ),
      );
    }

    final heatmapHeight = MediaQuery.of(context).size.width * 0.65;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(),
        title: Text(localizations.results_title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCarousel(
              images: widget.session.keyFrames.map((keyFrame)=>keyFrame.screenshot).toList(),
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
                  onGroupTapped: navigateToBodyPartPage,
                  highlightTime: Duration(
                    milliseconds:
                    currentKeyFrame.timestamp - widget.session.timeline.first.timestamp,
                  ),
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
      ),
    );
  }
}
