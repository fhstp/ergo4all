import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

/// An entry in a [RulaTimeline]. Has a [timestamp] and associated [RulaSheet].
@immutable
class TimelineEntry {
  ///
  const TimelineEntry({required this.timestamp, required this.sheet});

  /// The timestamp of this entry. This is a global UNIX timestamp.
  final int timestamp;

  /// The sheet for this entry.
  final RulaSheet sheet;
}

/// A timeline of [RulaSheet]s. The list is expected to be sorted by timestamp
/// but this is not enforced.
typedef RulaTimeline = IList<TimelineEntry>;
