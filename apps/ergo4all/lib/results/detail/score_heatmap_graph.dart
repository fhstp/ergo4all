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
    required this.keyframeIndex,
    this.onGroupTapped,
    super.key,
  });

  static const double _labelWidth = 65;

  /// The timelines to display keyed by their respective [BodyPartGroup].
  final IMap<BodyPartGroup, IList<double>> timelinesByGroup;

  /// The duration of the recording.
  final Duration recordingDuration;

  /// Index of the keyframe line on the heatmap.
  final int keyframeIndex;

  /// Callback for when the graph of a [BodyPartGroup] is tapped.
  final void Function(BodyPartGroup)? onGroupTapped;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final labelStyle = infoText.copyWith(fontSize: 13);

    return LayoutBuilder(
      builder: (context, constraints) {
        final graphWidth = constraints.maxWidth - _labelWidth;
        // Compute X position for highlight using cell width to match HeatmapPainter logic
        final highlightX = (graphWidth / timelinesByGroup.entries.first.value.length) * keyframeIndex;

        return CustomPaint(
          foregroundPainter: _VerticalLinePainter(
            x: highlightX,
            offsetLeft: _labelWidth, // account for labels
          ),
          child: Column(
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
          ),
        );
      },
    );
  }
}

class _VerticalLinePainter extends CustomPainter {
  _VerticalLinePainter({
    required this.x,
    this.offsetLeft = 0,
  });

  final double x;
  final double offsetLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    final dx = offsetLeft + x; // shift to account for label column
    canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _VerticalLinePainter oldDelegate) {
    return oldDelegate.x != x || oldDelegate.offsetLeft != offsetLeft;
  }
}
