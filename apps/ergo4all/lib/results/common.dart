import 'package:common/iterable_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

/// An entry in a [RulaTimeline]. Has a [timestamp] and associated [RulaScores].
@immutable
class TimelineEntry {
  ///
  const TimelineEntry({required this.timestamp, required this.scores});

  /// The timestamp of this entry. This is a global UNIX timestamp.
  final int timestamp;

  /// The scores for this time-stamp.
  final RulaScores scores;
}

/// A timeline of [RulaSheet]s. The list is expected to be sorted by timestamp
/// but this is not enforced.
typedef RulaTimeline = IList<TimelineEntry>;

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
          (scores) => Pair.left(scores.upperArmAbductedAdjustments)),
      aggregateScoreOf(
          (scores) => Pair.right(scores.upperArmAbductedAdjustments)),
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
