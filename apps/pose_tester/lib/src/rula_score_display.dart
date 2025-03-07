import 'package:flutter/material.dart';

class RulaScoreDisplay extends StatelessWidget {
  const RulaScoreDisplay({
    required this.label,
    required this.score,
    required this.maxScore,
    required this.level,
    super.key,
    this.minScore = 1,
  });

  final String label;
  final int score;
  final int minScore;
  final int maxScore;
  final int level;

  @override
  Widget build(BuildContext context) {
    final scoreT = (score - minScore) / (maxScore - minScore);
    final color = switch (scoreT) {
      < 0.25 => const Color.fromARGB(255, 129, 224, 132),
      < 0.5 => const Color.fromARGB(255, 237, 224, 105),
      < 0.75 => const Color.fromARGB(255, 234, 188, 120),
      _ => const Color.fromARGB(255, 240, 120, 111)
    };

    return Container(
      margin: EdgeInsets.only(left: level * 20),
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text('$label: $score / $maxScore'),
        ),
      ),
    );
  }
}
