import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:flutter/foundation.dart';

/// Represents a stored session.
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
