import 'package:ergo4all/common/rula_session.dart';

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
