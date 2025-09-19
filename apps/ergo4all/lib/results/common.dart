import 'package:common/iterable_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:ergo4all/common/activity.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rula/rula.dart';

/// Aggregates a [RulaTimeline] into a single [RulaScores] sheet. It does this
/// by doing a mode over each score. Currently, time, ie. how long the
/// duration of an entry in the timeline is, is not considered in the
/// calculation.
RulaScores? aggregateTimeline(RulaTimeline timeline) {
  if (timeline.isEmpty) return null;

  int aggregateScoreOf(int Function(RulaScores) selector) {
    return timeline.map((entry) => selector(entry.scores)).mode()!;
  }

  return RulaScores(
    upperArmPositionScores: (
      aggregateScoreOf((scores) => Pair.left(scores.upperArmPositionScores)),
      aggregateScoreOf((scores) => Pair.right(scores.upperArmPositionScores)),
    ),
    upperArmAbductedAdjustments: (
      aggregateScoreOf(
        (scores) => Pair.left(scores.upperArmAbductedAdjustments),
      ),
      aggregateScoreOf(
        (scores) => Pair.right(scores.upperArmAbductedAdjustments),
      ),
    ),
    upperArmScores: (
      aggregateScoreOf((scores) => Pair.left(scores.upperArmScores)),
      aggregateScoreOf((scores) => Pair.right(scores.upperArmScores)),
    ),
    lowerArmPositionScores: (
      aggregateScoreOf((scores) => Pair.left(scores.lowerArmPositionScores)),
      aggregateScoreOf((scores) => Pair.right(scores.lowerArmPositionScores)),
    ),
    lowerArmScores: (
      aggregateScoreOf((scores) => Pair.left(scores.lowerArmScores)),
      aggregateScoreOf((scores) => Pair.right(scores.lowerArmScores)),
    ),
    wristScores: (
      aggregateScoreOf((scores) => Pair.left(scores.wristScores)),
      aggregateScoreOf((scores) => Pair.right(scores.wristScores)),
    ),
    neckPositionScore: aggregateScoreOf((scores) => scores.neckPositionScore),
    neckTwistAdjustment:
        aggregateScoreOf((scores) => scores.neckTwistAdjustment),
    neckSideBendAdjustment:
        aggregateScoreOf((scores) => scores.neckSideBendAdjustment),
    neckScore: aggregateScoreOf((scores) => scores.neckScore),
    trunkPositionScore: aggregateScoreOf((scores) => scores.trunkPositionScore),
    trunkTwistAdjustment:
        aggregateScoreOf((scores) => scores.trunkTwistAdjustment),
    trunkSideBendAdjustment:
        aggregateScoreOf((scores) => scores.trunkSideBendAdjustment),
    trunkScore: aggregateScoreOf((scores) => scores.trunkScore),
    legScores: (
      aggregateScoreOf((scores) => Pair.left(scores.legScores)),
      aggregateScoreOf((scores) => Pair.right(scores.legScores)),
    ),
    fullScore: aggregateScoreOf((scores) => scores.fullScore),
  );
}

/// The different body parts for which we collect and display scores.
enum BodyPart {
  ///
  head,

  ///
  leftHand,

  ///
  leftLeg,

  ///
  leftLowerArm,

  ///
  leftUpperArm,

  ///
  rightHand,

  ///
  rightLeg,

  ///
  rightLowerArm,

  ///
  rightUpperArm,

  ///
  upperBody
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
