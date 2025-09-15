import 'package:ergo4all/analysis/har/activity.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:rula/rula.dart';

/// An entry/frame in a [RulaTimeline].
@immutable
class TimelineEntry {
  ///
  const TimelineEntry({
    required this.timestamp,
    required this.scores,
    this.activity,
  });

  /// The timestamp of this entry. This is a global UNIX timestamp.
  final int timestamp;

  /// The scores for this entry.
  final RulaScores scores;

  /// The activity recognized at this timestamp.
  final Activity? activity;
}

/// A timeline of [RulaSheet]s. The list is expected to be sorted by timestamp
/// but this is not enforced.
typedef RulaTimeline = IList<TimelineEntry>;

/// A completed recording session.
@immutable
class RulaSession {
  ///
  const RulaSession({
    required this.timestamp,
    required this.profileId,
    required this.scenario,
    required this.timeline,
    required this.keyFrames,
  });

  /// Unix timestamp at which the session was completed.
  final int timestamp;

  /// Id of the user who was recorded in this session.
  final int profileId;

  /// [Scenario] which was recorded in this session.
  final Scenario scenario;

  /// The recorded timeline.
  final RulaTimeline timeline;

  /// keyframes screenshot data
  final List<KeyFrame> keyFrames;
}

/// KeyFrame data structure so store relevant keyframe information
@immutable
class KeyFrame {
  /// KeyFrame init
  const KeyFrame(this.score, this.screenshot, this.timestamp);

  /// KeyFrame full score
  final double score;

  /// keyFrame screenshot
  final Uint8List screenshot;

  /// KeyFrame timestamp (when it was recorded)
  final int timestamp;
}
