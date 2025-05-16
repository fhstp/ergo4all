import 'package:flutter/material.dart';

/// Contains colors for the RULA score visualization
abstract final class RulaColors {
  /// #BFD7EA
  static const low = Color(0xFFBFD7EA);

  /// #F9F9C4
  /// Use for better visibility in the heatmap plot
  static const lowMid = Color(0xFFF9F9C4);

  /// #DEDEA2
  /// Use for better visibility in the line plot
  static const lowMidDark = Color(0xFFE7E7B2);

  /// #FFE553
  static const mid = Color(0xFFFFE553);

  /// #FFA259
  static const midHigh = Color(0xFFFFA259);

  /// #FF5A5F
  static const high = Color(0xFFFF5A5F);
}

/// Maps normalized RULA score values to colors. The score is
/// intended to be in the range [0; 1].
Color rulaColorFor(double normalizedScore, {bool dark = false}) {
  return switch (normalizedScore) {
    < 0.20 => RulaColors.low,
    <= 0.40 => dark ? RulaColors.lowMidDark : RulaColors.lowMid,
    <= 0.60 => RulaColors.mid,
    <= 0.80 => RulaColors.midHigh,
    _ => RulaColors.high
  };
}
