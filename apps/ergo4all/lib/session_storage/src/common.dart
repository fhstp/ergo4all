import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';

/// Represents a stored session.
class RulaSession {
  ///
  const RulaSession({
    required this.timestamp,
    required this.scenario,
    required this.timeline,
  });

  /// Unix timestamp at which the session was saved.
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
  void deleteByTimestamp(int timestamp);

  /// Clears this store.
  void clear();
}
