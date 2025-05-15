import 'dart:math';

import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/color_mapper.dart';
import 'package:ergo4all/results/common.dart';
import 'package:flutter/material.dart';

final Map<String, String Function(AppLocalizations)> _localizationMap = {
  'upperArmGood': (l) => l.upperArmGood,
  'upperArmMedium': (l) => l.upperArmMedium,
  'upperArmLow': (l) => l.upperArmLow,
  'lowerArmGood': (l) => l.lowerArmGood,
  'lowerArmMedium': (l) => l.lowerArmMedium,
  'lowerArmLow': (l) => l.lowerArmLow,
  'trunkGood': (l) => l.trunkGood,
  'trunkMedium': (l) => l.trunkMedium,
  'trunkLow': (l) => l.trunkLow,
  'neckGood': (l) => l.neckGood,
  'neckMedium': (l) => l.neckMedium,
  'neckLow': (l) => l.neckLow,
  'legsGood': (l) => l.legsGood,
  'legsMedium': (l) => l.legsMedium,
  'legsLow': (l) => l.legsLow,
};

enum Rating {
  good,
  medium,
  low,
}

extension StringExtensions on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

class BodyPartResultsViewModel {
  BodyPartResultsViewModel({
    required this.bodyPartName,
    required this.timelineValues,
    required this.medianTimelineValues,
    required this.bodyPartGroup,
  }) : timelineColors = _colorForValue(timelineValues);

  final String bodyPartName;

  /// The [BodyPartGroup] to display.
  final BodyPartGroup bodyPartGroup;
  final List<double> timelineValues;
  final List<Color> timelineColors;
  final List<double> medianTimelineValues;

  static List<Color> _colorForValue(List<double> values) {
    if (values.isEmpty) return [];
    return values.map((spot) {
      return ColorMapper.getColorForValue(spot, dark: true);
    }).toList();
  }

  static double calculateMean(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }

  static double calculateStandardDeviation(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    final mean = calculateMean(numbers);
    final sumOfSquaredDiffs = numbers
        .map((number) => (number - mean) * (number - mean))
        .reduce((a, b) => a + b);
    return sqrt(sumOfSquaredDiffs / numbers.length);
  }

  static double calculateCoefficientOfVariation(List<double> numbers) {
    final mean = calculateMean(numbers);
    if (mean == 0) return 0;
    final standardDeviation = calculateStandardDeviation(numbers);

    return standardDeviation / mean;
  }

  Rating _getRating() {
    final mean = calculateMean(timelineValues);
    final coefficientOfVariation =
        calculateCoefficientOfVariation(timelineValues);

    if (mean <= 0.35) {
      return (coefficientOfVariation <= 0.3) ? Rating.good : Rating.medium;
    } else if (mean <= 0.65) {
      return Rating.medium;
    } else {
      return (coefficientOfVariation <= 0.3) ? Rating.low : Rating.medium;
    }
  }

  String getLocalizedMessage(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final rating = _getRating();
    final key = '${bodyPartGroup.name}${rating.name.capitalize()}';

    return _localizationMap[key]?.call(loc) ?? 'Missing translation for $key';
  }
}
