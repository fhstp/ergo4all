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

  /// Gets the color for a normalized score.
  static Color forScore(double score, {bool dark = false}) => switch (score) {
        < 0.20 => _low,
        <= 0.40 => dark ? _lowMidDark : _lowMid,
        <= 0.60 => _mid,
        <= 0.80 => _midHigh,
        _ => _high
      };

  /// All Rula score colors from low -> high.
  static const IList<Color> all =
      IListConst([_low, _lowMid, _mid, _midHigh, _high]);
}
