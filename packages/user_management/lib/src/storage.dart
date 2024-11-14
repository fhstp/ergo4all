import 'dart:io';

import 'package:common/nullable_utils.dart';
import 'package:common/types.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_management/src/user_config.dart';

import '../user_management.dart';

const _userConfigFilePath = "users.json";

Future<File> getConfigFile() async {
  final documentDir = await getApplicationDocumentsDirectory();
  final file = File(join(documentDir.path, _userConfigFilePath));
  return file;
}

Future<String?> _readConfigFile() async {
  File file = await getConfigFile();
  final fileExists = await file.exists();

  if (!fileExists) return null;

  return await file.readAsString();
}

Future<Null> _writeConfigFile(String content) async {
  final documentDir = await getApplicationDocumentsDirectory();
  final file = File(join(documentDir.path, _userConfigFilePath));

  await file.writeAsString(content);
}

Future<UserConfig?> _tryReadConfig() =>
    _readConfigFile().then(doMaybe(parseUserConfig));

Future<Null> _tryWriteConfig(UserConfig config) =>
    _writeConfigFile(serializeUserConfig(config));

/// Adds the given [user] to the app and marks them as the current user.
Future<Null> addUser(User user) => _tryReadConfig()
    .then(doMaybe((config) => appendUserToConfig(config, user)))
    .then((config) => config ?? UserConfig.forUser(user))
    .then(_tryWriteConfig);

/// Updates the user with the given [userIndex] by applying [update] to it. Will throw an exception if the user does not exist.
Future<Null> updateUser(int userIndex, Update<User> update) =>
    _tryReadConfig().then((config) {
      assert(config != null);
      return updateUserInConfig(config!, userIndex, update);
    }).then(_tryWriteConfig);

/// Gets the current user or `null` if there is none.
Future<User?> loadCurrentUser() =>
    _tryReadConfig().then(doMaybe(tryGetCurrentUserFromConfig));

/// Gets the index of the current user. May be `null` if there is no user yet.
Future<int?> loadCurrentUserIndex() =>
    _tryReadConfig().then((config) => config?.currentUserIndex);

/// Clears all user data.
Future<void> clearAllUserData() async {
  final file = await getConfigFile();
  if (!(await file.exists())) return;
  await file.delete();
}
