
import 'dart:ui';

/// Manages colors for the RULA score visualization
class ColorManager {
  /// Color for RULA scores under 0.20
  static const good = Color.fromARGB(255, 191, 215, 234); // Blue
  /// Color for RULA scores between 0.20 and 0.40
  static const goodMid = Color.fromARGB(255, 247, 255, 155); // Blue-Yellow
  /// Color for RULA scores between 0.40 and 0.60
  static const mid = Color.fromARGB(255, 255, 229, 83); // Yellow
  /// Color for RULA scores between 0.60 and 0.80
  static const midBad = Color.fromARGB(255, 255, 166, 97); // Yellow-Red
  /// Color for RULA scores above 0.80
  static const bad = Color.fromARGB(255, 255, 90, 95); // Red

  /// Maps normalized RULA score values to colors
  Color getColorForValue(double value) {
    if (value < 0.20) {
      return good;
    } else if (value <= 0.40) {
      return goodMid;
    } else if (value <= 0.60) {
      return mid;
    } else if (value <= 0.80) {
      return midBad;
    }
    return bad;
  }

  /// Returns a list of colors for the RULA score visualization
  /// in the order of good, goodMid, mid, midBad, and bad
  List<Color> getColorsGoodToBad() {
    return [good, goodMid, mid, midBad, bad];
  }

  /// Returns a list of colors for the RULA score visualization
  /// in the order of bad, midBad, mid, goodMid, and good
  List<Color> getColorsBadToGood() {
    return [bad, midBad, mid, goodMid, good];
  }
}