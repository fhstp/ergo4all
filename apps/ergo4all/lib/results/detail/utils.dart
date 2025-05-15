List<double> getPaddedData(List<double> data, int windowSize) {
  final halfWindow = windowSize ~/ 2;
  return [
    ...List.filled(halfWindow, data.first),
    ...data,
    ...List.filled(halfWindow, data.last),
  ];
}

List<double> calculateRunningAverage(List<double> data, int windowSize) {
  if (data.length < windowSize) return data;

  final paddedData = getPaddedData(data, windowSize);
  final result = <double>[];

  for (var i = 0; i <= paddedData.length - windowSize; i++) {
    final window = paddedData.sublist(i, i + windowSize);
    final avgY = window.reduce((a, b) => a + b) / windowSize;
    result.add(avgY);
  }

  return result;
}

List<double> calculateRunningMedian(List<double> data, int windowSize) {
  if (data.length < windowSize) return data;

  final paddedData = getPaddedData(data, windowSize);
  final result = <double>[];

  for (var i = 0; i <= paddedData.length - windowSize; i++) {
    final window = paddedData.sublist(i, i + windowSize)..sort();

    final median = windowSize.isOdd
        ? window[windowSize ~/ 2]
        : (window[(windowSize - 1) ~/ 2] + window[windowSize ~/ 2]) / 2;

    result.add(median);
  }

  return result;
}
