import 'package:ergo4all/results/rating.dart';
import 'package:flutter/material.dart';

/// Displays an image from `assets/images/ergo_score_badge` based on the given
/// [Rating].
class ErgoScoreBadge extends StatelessWidget {
  ///
  const ErgoScoreBadge({required this.rating, super.key});

  /// The rating to display the badge for.
  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final key = 'assets/images/ergo_score_badge/${rating.name}.png';
    return Image.asset(key);
  }
}
