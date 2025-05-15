import 'package:flutter/material.dart';

/// Manages colors for the RULA score visualization
@immutable
class ColorMapper {
  /// #BFD7EA
  static const rulaLow = Color(0xFFBFD7EA);

  /// #F9F9C4
  // Use for better visibility in the heatmap plot
  static const rulaLowMid = Color(0xFFF9F9C4);

  /// #DEDEA2
  // Use for better visibility in the line plot
  static const rulaLowMidDark = Color(0xFFE7E7B2);

  /// #FFE553
  static const rulaMid = Color(0xFFFFE553);

  /// #FFA259
  static const rulaMidHigh = Color(0xFFFFA259);

  /// #FF5A5F
  static const rulaHigh = Color(0xFFFF5A5F);

  /// Maps normalized RULA score values to colors
  static Color getColorForValue(double value, {bool dark = false}) {
    if (value < 0.20) {
      return rulaLow;
    } else if (value <= 0.40) {
      return dark ? rulaLowMidDark : rulaLowMid;
    } else if (value <= 0.60) {
      return rulaMid;
    } else if (value <= 0.80) {
      return rulaMidHigh;
    }
    return rulaHigh;
  }
}
