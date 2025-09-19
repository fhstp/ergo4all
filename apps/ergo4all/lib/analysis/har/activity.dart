import 'package:common/iterable_ext.dart';
import 'package:fpdart/fpdart.dart';

/// An generic movement activity.
enum Activity {
  background,
  carrying,
  kneeling,
  lifting,
  overhead,
  sitting,
  standing,
  walking;
}

/// Determines the top 3 most popular activities in the given collection.
/// "Popular" here means the activities which occur most often.
///
/// There may be less than 3 elements in the output for two reasons:
///
///  - There were less than 3 unique activities in the input
///  - We filter out "boring" activities such as [Activity.background]
Iterable<Activity> mostPopularActivitiesOf(Iterable<Activity> activities) {
  final counts = activities.countOccurrences();

  // These are the unique activities in the timeline sorted by how often
  // they appear.
  final sortedByPopularity = counts.entries
      .sortBy(Order.by((entry) => entry.value, Order.orderInt))
      .map((entry) => entry.key);

  // We pick the top 3 most frequent activities
  final top3 = sortedByPopularity.take(3);

  // There are also some activities which we don't care about
  final relevant = top3.delete(Activity.background).delete(Activity.walking);

  // So finally we have 0 - 3 popular activities
  return relevant;
}
