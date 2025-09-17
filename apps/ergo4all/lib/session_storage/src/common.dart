import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/session_storage/src/fs.dart';

/// Store for [RulaSession] objects.
abstract class RulaSessionRepository {
  /// Stores a [RulaSession] object.
  Future<void> put(RulaSession session);

  /// Attempts to load the [RulaSession] associated with the given
  /// timestamp. If no such session is found `null` is returned.
  Future<RulaSession?> getByTimestamp(int timestamp);

  /// Retrieves meta data for all stored [RulaSession]s. If you want to
  /// actually load the full session data use [getByTimestamp] with
  /// [RulaSessionMeta.timestamp].
  Future<List<RulaSessionMeta>> getAll();

  /// Deletes a [RulaSession] based on it's [timestamp].
  Future<void> deleteByTimestamp(int timestamp);

  /// Clears this store.
  Future<void> clear();

  /// Deletes all sessions which were recorded with the given profile.
  Future<void> deleteAllBy(int profileId);
}
