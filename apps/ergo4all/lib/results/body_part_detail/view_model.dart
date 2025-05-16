import 'package:ergo4all/results/rating.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class BodyPartResultsViewModel {
  BodyPartResultsViewModel({
    required this.timelineValues,
    required this.medianTimelineValues,
  });

  final IList<double> timelineValues;
  final IList<double> medianTimelineValues;

  Rating getRating() {
    return calculateRating(timelineValues);
  }
}
