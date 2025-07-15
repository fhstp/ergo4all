import 'package:common/math_utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Utility module for getting colors associated with the Rula scoring system.
abstract final class RulaColor {
  static const _low = Color(0xFFBFD7EA);

  static const _lowMid = Color(0xFFF9F9C4);

  static const _lowMidDark = Color(0xFFE7E7B2);

  static const _mid = Color(0xFFFFE553);

  static const _midHigh = Color(0xFFFFA259);

  static const _high = Color(0xFFFF5A5F);

  /// Gets the discrete color for a normalized score.
  static Color discreteForScore(double score, {bool dark = false}) =>
      switch (score) {
        < 0.20 => _low,
        <= 0.40 => dark ? _lowMidDark : _lowMid,
        <= 0.60 => _mid,
        <= 0.80 => _midHigh,
        _ => _high
      };

  /// Gets the continuous color for a normalized score.
  /// The score is intended to be in the range [0; 1].
  static Color continuousForScore(double normalizedScore, {bool dark = false}) {
    final lowMid = dark ? _lowMidDark : _lowMid;
    return switch (normalizedScore) {
      < 0.25 => Color.lerp(_low, lowMid, invLerp(0, 0.25, normalizedScore))!,
      <= 0.50 => Color.lerp(
          _lowMid,
          _mid,
          invLerp(0.25, 0.5, normalizedScore),
        )!,
      <= 0.75 => Color.lerp(
          _mid,
          _midHigh,
          invLerp(0.5, 0.75, normalizedScore),
        )!,
      _ => Color.lerp(
          _midHigh,
          _high,
          invLerp(0.75, 1, normalizedScore),
        )!
    };
  }

  /// All Rula score colors from low -> high.
  static const IList<Color> all =
      IListConst([_low, _lowMid, _mid, _midHigh, _high]);
}
