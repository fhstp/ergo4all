import 'package:ergo4all/subjects/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// A persistent storage for [Subject]s.
abstract class SubjectRepo {
  /// The default subject which will always exist and cannot be deleted.
  /// It has the reserved id **1**.
  static const Subject defaultSubject = Subject(id: 1, nickname: 'Ergo-fan');

  /// Gets all [Subject]s from this repo.
  Future<List<Subject>> getAll();

  /// Get a specific [Subject] by their id.
  Future<Subject?> getById(int id);

  /// Creates a new subject with the given data.
  Future<void> createNew(String nickname);

  /// Deletes the subject with the given [id]
  Future<void> deleteById(int id);
}

/// Utility extensions for [SubjectRepo].
extension Utils on SubjectRepo {
  /// Gets all subjects from this store and organizes them in a map, keyed
  /// by their id.
  Future<IMap<int, Subject>> getAllAsMap() async {
    final subjects = await getAll();
    return IMap.fromValues(
      values: subjects,
      keyMapper: (subject) => subject.id,
    );
  }
}
