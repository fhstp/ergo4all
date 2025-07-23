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

/// Store for [RulaSession] objects.
abstract class RulaSessionRepository {
  /// Stores a [RulaSession] object.
  Future<void> put(RulaSession session);

  /// Retrieves all stored [RulaSession]s
  Future<List<RulaSession>> getAll();

  /// Deletes a [RulaSession] based on it's [timestamp].
  Future<void> deleteByTimestamp(int timestamp);

  /// Clears this store.
  Future<void> clear();
}
