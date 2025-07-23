import 'package:ergo4all/scenario/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:rula/rula.dart';

/// An entry/frame in a [RulaTimeline].
@immutable
class TimelineEntry {
  ///
  const TimelineEntry({
    required this.timestamp,
    required this.scores,
    this.image,
  });

  /// The timestamp of this entry. This is a global UNIX timestamp.
  final int timestamp;

  /// The scores for this entry.
  final RulaScores scores;

  /// Image/screen-shot associated with this entry.
  final img.Image? image;
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
    required this.scenario,
    required this.timeline,
  });

  /// Unix timestamp at which the session was completed.
  final int timestamp;

  /// [Scenario] which was recorded in this session.
  final Scenario scenario;

  /// The recorded timeline.
  final RulaTimeline timeline;
}
