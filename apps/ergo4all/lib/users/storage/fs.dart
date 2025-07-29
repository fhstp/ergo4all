import 'dart:convert';
import 'dart:io';

import 'package:ergo4all/users/common.dart';
import 'package:ergo4all/users/storage/common.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/v4.dart';

User _parseUser(String id, dynamic json) {
  if (json is! Map<String, dynamic>) throw TypeError();

  final name = json['name'];
  if (name is! String) throw TypeError();

  return User(id: id, name: name);
}

Map<String, dynamic> _serializeUser(User user) {
  return Map.fromEntries([MapEntry('name', user.name)]);
}

Future<User?> _tryLoadUserFrom(File file) async {
  if (!file.existsSync()) {
    return null;
  }

  final id = path.basenameWithoutExtension(file.path);
  final text = await file.readAsString();
  final json = jsonDecode(text);
  return _parseUser(id, json);
}

Future<void> _saveUserTo(File file, User user) async {
  final json = _serializeUser(user);
  final text = jsonEncode(json);
  await file.writeAsString(text);
}

/// [UserStore] which persists users in the file-system. Each user is stored
/// in its own json file named with the users id.
class FileSystemUserStore implements UserStore {
  Future<Directory> _getUsersDir() async {
    final docDir = await getApplicationDocumentsDirectory();
    final sessionsDirPath = path.join(docDir.path, 'users');
    return Directory(sessionsDirPath).create(recursive: true);
  }

  Future<File> _getUserFile(String id) async {
    final usersDir = await _getUsersDir();
    return File(path.join(usersDir.path, '$id.json'));
  }

  @override
  Future<User> createUser({required String name}) async {
    final id = const UuidV4().generate();
    final user = User(id: id, name: name);

    final file = await _getUserFile(id);
    await file.create();

    await _saveUserTo(file, user);
    return user;
  }

  @override
  Future<bool> deleteUserById(String id) async {
    final file = await _getUserFile(id);
    if (file.existsSync()) return false;
    await file.delete();
    return true;
  }

  @override
  Future<User?> tryGetUserById(String id) async {
    final file = await _getUserFile(id);
    return _tryLoadUserFrom(file);
  }
}
