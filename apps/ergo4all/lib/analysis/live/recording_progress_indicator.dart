import 'package:common_ui/theme/colors.dart';
import 'package:flutter/material.dart';

/// A styled [LinearProgressIndicator] specifically to indicate how much
/// recording time is still left.
class RecordingProgressIndicator extends StatelessWidget {
  /// Creates a [RecordingProgressIndicator].
  const RecordingProgressIndicator({
    required this.remainingTime,
    required this.initialTime,
    super.key,
  });

  /// How much time recording is remaining.
  final double remainingTime;

  /// How much recording time there was initially.
  final double initialTime;

  @override
  Widget build(BuildContext context) {
    final remainingFraction = remainingTime / initialTime;

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
        color: blueChill,
        minHeight: 30,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
