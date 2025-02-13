import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

class RulaScoreDisplay extends StatelessWidget {
  final String label;
  final RulaScore score;
  final int minScore;
  final int maxScore;

  const RulaScoreDisplay(
      {super.key,
      required this.label,
      required this.score,
      required this.minScore,
      required this.maxScore});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8),
      child: Text("$label: ${score.value}"),
    ));
  }
}
