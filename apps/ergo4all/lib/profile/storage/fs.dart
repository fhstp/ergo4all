import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:common/func_ext.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Implementation of [ProfileRepo] which stores its data in the file-system.
/// Every profile gets it's own file which stores it's data in json format.
class FileBasedProfileRepo implements ProfileRepo {
  Future<Directory> _getProfilesDir() async {
    final docDir = await getApplicationDocumentsDirectory();
    final sessionsDirPath = path.join(docDir.path, 'profiles');
    return Directory(sessionsDirPath).create(recursive: true);
  }

  Future<Stream<File>> _getProfileFiles() async {
    final dir = await _getProfilesDir();
    return dir.list().cast<File>();
  }

  Future<Profile> _loadProfileFrom(File file) async {
    final id = path
        .basenameWithoutExtension(file.path)
        .toIntOption
        .expect('Should parse profile it');

    final text = await file.readAsString();
    final json = jsonDecode(text) as Map<String, dynamic>;

    final nickname = json['nickname'] as String;

    return Profile(id: id, nickname: nickname);
  }

  Future<void> _writeProfileTo(File file, Profile profile) async {
    final json = {'nickname': profile.nickname};
    final text = jsonEncode(json);
    await file.writeAsString(text);
  }

  File _fileForProfileIn(Directory dir, int id) =>
      File(path.join(dir.path, '$id.json'));

  bool _hasProfileWithIdIn(Directory dir, int id) =>
      _fileForProfileIn(dir, id).existsSync();

  int _findFreeIdFor(Directory dir) {
    var attempts = 100;
    final rng = Random();

    while (attempts > 0) {
      // [2, 1000]
      final id = rng.nextInt(999) + 2;
      final isTaken = _hasProfileWithIdIn(dir, id);

      if (!isTaken) return id;

      attempts--;
    }

    throw AssertionError('Could not find free id');
  }

  @override
  Future<List<Profile>> getAll() async {
    final customProfiles =
        await (await _getProfileFiles()).asyncMap(_loadProfileFrom).toList();

    return [ProfileRepo.defaultProfile, ...customProfiles];
  }

  @override
  Future<Profile?> getById(int id) async {
    if (id == 1) return ProfileRepo.defaultProfile;

    final profilesDir = await _getProfilesDir();
    final file = _fileForProfileIn(profilesDir, id);

    if (!file.existsSync()) return null;

    return _loadProfileFrom(file);
  }

  @override
  Future<void> createNew(String nickname) async {
    final profilesDir = await _getProfilesDir();
    final id = _findFreeIdFor(profilesDir);

    final file = _fileForProfileIn(profilesDir, id);
    final profile = Profile(id: id, nickname: nickname);

    await _writeProfileTo(file, profile);
  }

  @override
  Future<void> deleteById(int id) async {
    // There is no actual entry for the default profile.
    if (id == ProfileRepo.defaultProfile.id) return;

    final profilesDir = await _getProfilesDir();
    final file = _fileForProfileIn(profilesDir, id);
    await file.delete();
  }
}
