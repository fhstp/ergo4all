import 'package:ergo4all/storage/rula_session.dart';

/// abstract class to hide implementation details of the RulaSession repository
abstract class RulaSessionRepository {
  /// Persists a RulaSession into the database
  Future<void> save(RulaSession session);

  /// Retrieves all stored RulaSessions
  List<RulaSession> getAll();

  /// fins a session based on its timestamp and deletes it
  void deleteSession(int timestamp);

  /// deletes all database information
  void deleteAllSessions();
}
