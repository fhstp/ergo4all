import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

enum Rating {
  good,
  medium,
  low,
}

class BodyPartResultsViewModel {
  BodyPartResultsViewModel({
    required this.timelineValues,
    required this.medianTimelineValues,
    required this.bodyPartGroup,
  });

  /// The [BodyPartGroup] to display.
  final BodyPartGroup bodyPartGroup;
  final IList<double> timelineValues;
  final IList<double> medianTimelineValues;

  Rating getRating() {
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
}
