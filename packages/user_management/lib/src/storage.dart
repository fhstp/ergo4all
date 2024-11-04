import 'dart:io';

import 'package:common/nullable_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_management/src/types.dart';
import 'package:user_management/src/user_config.dart';

const _userConfigFilePath = "users.json";

Future<String?> _readConfigFile() async {
  final documentDir = await getApplicationDocumentsDirectory();
  final file = File(join(documentDir.path, _userConfigFilePath));
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

/// Stores user data in a json file.
class PersistentUserStorage implements UserStorage {
  @override
  addUser(user) => _tryReadConfig()
      .then(doMaybe((config) => appendUserToConfig(config, user)))
      .then((config) => config ?? UserConfig.forUser(user))
      .then(_tryWriteConfig);

  @override
  updateUser(userIndex, update) => _tryReadConfig().then((config) {
        assert(config != null);
        return updateUserInConfig(config!, userIndex, update);
      }).then(_tryWriteConfig);

  @override
  getCurrentUser() =>
      _tryReadConfig().then(doMaybe(tryGetCurrentUserFromConfig));

  @override
  getCurrentUserIndex() =>
      _tryReadConfig().then((config) => config?.currentUserIndex);
}
