import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

IList<double> getPaddedData(IList<double> data, int windowSize) {
  final halfWindow = windowSize ~/ 2;
  return [
    ...List.filled(halfWindow, data.first),
    ...data,
    ...List.filled(halfWindow, data.last),
  ].toIList();
}

IList<double> calculateRunningAverage(IList<double> data, int windowSize) {
  if (data.length < windowSize) return data;

  final paddedData = getPaddedData(data, windowSize);
  final result = <double>[];

  for (var i = 0; i <= paddedData.length - windowSize; i++) {
    final window = paddedData.sublist(i, i + windowSize);
    final avgY = window.reduce((a, b) => a + b) / windowSize;
    result.add(avgY);
  }

  return result.toIList();
}

IList<double> calculateRunningMedian(IList<double> data, int windowSize) {
  if (data.length < windowSize) return data;

  final paddedData = getPaddedData(data, windowSize);
  final result = <double>[];

  for (var i = 0; i <= paddedData.length - windowSize; i++) {
    final window = paddedData.sublist(i, i + windowSize).sort();

    final median = windowSize.isOdd
        ? window[windowSize ~/ 2]
        : (window[(windowSize - 1) ~/ 2] + window[windowSize ~/ 2]) / 2;

    result.add(median);
  }

  return result.toIList();
}

double calculateMean(IList<double> numbers) {
  if (numbers.isEmpty) return 0;
  return numbers.reduce((a, b) => a + b) / numbers.length;
}

double calculateStandardDeviation(IList<double> numbers) {
  if (numbers.isEmpty) return 0;
  final mean = calculateMean(numbers);
  final sumOfSquaredDiffs = numbers
      .map((number) => (number - mean) * (number - mean))
      .reduce((a, b) => a + b);
  return sqrt(sumOfSquaredDiffs / numbers.length);
}

double calculateCoefficientOfVariation(IList<double> numbers) {
  final mean = calculateMean(numbers);
  if (mean == 0) return 0;
  final standardDeviation = calculateStandardDeviation(numbers);

  return standardDeviation / mean;
}
