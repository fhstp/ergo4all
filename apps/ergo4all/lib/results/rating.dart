import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// A semantic rating for a score.
enum Rating {
  /// A good rating.
  good,

  /// A medium rating.
  medium,

  /// A low rating.
  low,
}

double _calculateMean(IList<double> numbers) {
  if (numbers.isEmpty) return 0;
  return numbers.reduce((a, b) => a + b) / numbers.length;
}

double _calculateStandardDeviation(IList<double> numbers) {
  if (numbers.isEmpty) return 0;
  final mean = _calculateMean(numbers);
  final sumOfSquaredDiffs = numbers
      .map((number) => (number - mean) * (number - mean))
      .reduce((a, b) => a + b);
  return sqrt(sumOfSquaredDiffs / numbers.length);
}

double _calculateCoefficientOfVariation(IList<double> numbers) {
  final mean = _calculateMean(numbers);
  if (mean == 0) return 0;
  final standardDeviation = _calculateStandardDeviation(numbers);

  return standardDeviation / mean;
}

/// Calculates a semantic [Rating] for a score-timeline. The given scores
/// should be in the range [0; 1].
Rating calculateRating(IList<double> normalizedScores) {
  final mean = _calculateMean(normalizedScores);
  final coefficientOfVariation =
      _calculateCoefficientOfVariation(normalizedScores);

  if (mean <= 0.35) {
    return (coefficientOfVariation <= 0.3) ? Rating.good : Rating.medium;
  } else if (mean <= 0.65) {
    return Rating.medium;
  } else {
    return (coefficientOfVariation <= 0.3) ? Rating.low : Rating.medium;
  }
}
