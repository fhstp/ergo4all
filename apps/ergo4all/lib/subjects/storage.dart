import 'package:ergo4all/subjects/common.dart';

/// A persistent storage for [Subject]s.
abstract class SubjectRepo {
  /// Gets all [Subject]s from this repo.
  Future<List<Subject>> getAll();

  /// Get a specific [Subject] by their id.
  Future<Subject?> getById(int id);
}

/// Implementation of [SubjectRepo] which stores its data in the file-system.
class FileBasedSubjectRepo implements SubjectRepo {
  @override
  Future<List<Subject>> getAll() async {
    return [const Subject(id: 1)];
  }

  @override
  Future<Subject?> getById(int id) async {
    if (id != 1) {
      return null;
    }

    return const Subject(id: 1);
  }
}
