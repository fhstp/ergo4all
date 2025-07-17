import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/detail/heatmap_painter.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Displays the timelines of a set [BodyPartGroup]s as a column
/// of heatmap graphs.
///
/// (Is it a heatmap though? I think this might be a misnomer but whatever.)
class ScoreHeatmapGraph extends StatelessWidget {
  ///
  const ScoreHeatmapGraph({
    required this.timelinesByGroup,
    required this.recordingDuration,
    this.onGroupTapped,
    super.key,
  });

  static const double _labelWidth = 65;

  /// The timelines to display keyed by their respective [BodyPartGroup].
  final IMap<BodyPartGroup, IList<double>> timelinesByGroup;

  /// The duration of the recording.
  final Duration recordingDuration;

  /// Callback for when the graph of a [BodyPartGroup] is tapped.
  final void Function(BodyPartGroup)? onGroupTapped;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final labelStyle = infoText.copyWith(fontSize: 13);

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...BodyPartGroup.values.map(
          (part) => Expanded(
            child: GestureDetector(
              onTap: () {
                onGroupTapped?.call(part);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: _labelWidth,
                    child: Text(
                      localizations.bodyPartGroupLabel(part),
                      style: labelStyle,
                    ),
                  ),
                  Expanded(
                    child: CustomPaint(
                      painter: HeatmapPainter(
                        normalizedScores: timelinesByGroup[part]!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: _labelWidth),
          child: Column(
            children: [
              Container(
                height: 2,
                color: woodSmoke.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0s', style: labelStyle),
                  Text(
                    '${recordingDuration.inSeconds}s',
                    style: labelStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
