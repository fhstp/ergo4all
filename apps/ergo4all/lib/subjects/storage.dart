import 'package:ergo4all/subjects/common.dart';

/// A persistent storage for [Subject]s.
abstract class SubjectRepo {
  /// The default subject which will always exist and cannot be deleted.
  /// It has the reserved id **1**.
  static const Subject defaultSubject = Subject(id: 1, nickname: 'Ergo-fan');

  /// Gets all [Subject]s from this repo.
  Future<List<Subject>> getAll();

  /// Get a specific [Subject] by their id.
  Future<Subject?> getById(int id);
}

/// Implementation of [SubjectRepo] which stores its data in the file-system.
class FileBasedSubjectRepo implements SubjectRepo {
  @override
  Future<List<Subject>> getAll() async {
    return [SubjectRepo.defaultSubject];
  }

  @override
  Future<Subject?> getById(int id) async {
    if (id != 1) {
      return null;
    }

    return SubjectRepo.defaultSubject;
  }
}
