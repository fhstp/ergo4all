import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:common/func_ext.dart';
import 'package:ergo4all/subjects/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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

/// Implementation of [SubjectRepo] which stores its data in the file-system.
/// Every subject gets it's own file which stores it's data in json format.
class FileBasedSubjectRepo implements SubjectRepo {
  Future<Directory> _getSubjectsDir() async {
    final docDir = await getApplicationDocumentsDirectory();
    final sessionsDirPath = path.join(docDir.path, 'subjects');
    return Directory(sessionsDirPath).create(recursive: true);
  }

  Future<Stream<File>> _getSubjectFiles() async {
    final dir = await _getSubjectsDir();
    return dir.list().cast<File>();
  }

  Future<Subject> _loadSubjectFrom(File file) async {
    final id = path
        .basenameWithoutExtension(file.path)
        .toIntOption
        .expect('Should parse subject it');

    final text = await file.readAsString();
    final json = jsonDecode(text) as Map<String, dynamic>;

    final nickname = json['nickname'] as String;

    return Subject(id: id, nickname: nickname);
  }

  Future<void> _writeSubjectTo(File file, Subject subject) async {
    final json = {'nickname': subject.nickname};
    final text = jsonEncode(json);
    await file.writeAsString(text);
  }

  File _fileForSubjectIn(Directory dir, int id) =>
      File(path.join(dir.path, '$id.json'));

  bool _hasSubjectWithIdIn(Directory dir, int id) =>
      _fileForSubjectIn(dir, id).existsSync();

  int _findFreeIdFor(Directory dir) {
    var attempts = 100;
    final rng = Random();

    while (attempts > 0) {
      // [2, 1000]
      final id = rng.nextInt(999) + 2;
      final isTaken = _hasSubjectWithIdIn(dir, id);

      if (!isTaken) return id;

      attempts--;
    }

    throw AssertionError('Could not find free id');
  }

  @override
  Future<List<Subject>> getAll() async {
    final customSubjects =
        await (await _getSubjectFiles()).asyncMap(_loadSubjectFrom).toList();

    return [SubjectRepo.defaultSubject, ...customSubjects];
  }

  @override
  Future<Subject?> getById(int id) async {
    if (id == 1) return SubjectRepo.defaultSubject;

    final subjectsDir = await _getSubjectsDir();
    final file = _fileForSubjectIn(subjectsDir, id);

    if (!file.existsSync()) return null;

    return _loadSubjectFrom(file);
  }

  @override
  Future<void> createNew(String nickname) async {
    final subjectsDir = await _getSubjectsDir();
    final id = _findFreeIdFor(subjectsDir);

    final file = _fileForSubjectIn(subjectsDir, id);
    final subject = Subject(id: id, nickname: nickname);

    await _writeSubjectTo(file, subject);
  }
}
