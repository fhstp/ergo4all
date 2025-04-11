import 'package:common_ui/theme/colors.dart';
import 'package:flutter/material.dart';

/// A styled [LinearProgressIndicator] specifically to indicate how much
/// recording time is still left.
class RecordingProgressIndicator extends StatelessWidget {
  /// Creates a [RecordingProgressIndicator].
  const RecordingProgressIndicator({
    required this.remainingTime,
    required this.criticalTime,
    required this.initialTime,
    super.key,
  });

  /// How much time recording is remaining.
  final double remainingTime;

  /// When [remainingTime] is less than this time, the bar will get a
  /// critical color.
  final double criticalTime;

  /// How much recording time there was initially.
  final double initialTime;

  @override
  Widget build(BuildContext context) {
    final remainingFraction = remainingTime / initialTime;
    final color = remainingTime < criticalTime ? persimmon : blueChill;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: balticSea,
        border: Border.all(color: balticSea),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: LinearProgressIndicator(
        value: remainingFraction,
        backgroundColor: spindle,
        color: color,
        minHeight: 30,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
