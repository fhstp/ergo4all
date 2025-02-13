import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

class RulaScoreDisplay extends StatelessWidget {
  final String label;
  final RulaScore score;
  final int maxScore;

  const RulaScoreDisplay(
      {super.key,
      required this.label,
      required this.score,
      required this.maxScore});

  @override
  Widget build(BuildContext context) {
    final scoreT = (score.value - 1) / (maxScore - 1);
    final color = switch (scoreT) {
      < 0.25 => const Color.fromARGB(255, 129, 224, 132),
      < 0.5 => const Color.fromARGB(255, 237, 224, 105),
      < 0.75 => const Color.fromARGB(255, 234, 188, 120),
      _ => const Color.fromARGB(255, 240, 120, 111)
    };

    return Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text("$label: ${score.value}"),
        ));
  }
}
