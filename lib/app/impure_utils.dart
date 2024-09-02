import 'dart:convert';

import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/domain/user_config.dart';
import 'package:ergo4all/io/local_text_storage.dart';

/// Reads the current [UserConfig].
Future<UserConfig?> getUserConfig(LocalTextStorage storage) async {
  final text = await storage.read(userConfigFilePath);
  if (text == null) return null;

  final json = jsonDecode(text);

  return UserConfig.fromJson(json);
}

/// Function for updating the user config.
///
/// Use the [update] function to modify the user config. It receives the
/// current config as a parameter. If there is no config it will receive `null`.
/// The value returned by the [update] function will override the user config.
Future<Null> updateUserConfig(
    LocalTextStorage storage, UserConfig Function(UserConfig?) update) async {
  final initial = await getUserConfig(storage);
  final updated = update(initial);
  final json = updated.toJson();
  final text = jsonEncode(json);
  await storage.write(userConfigFilePath, text);
}

/// Function for getting the current user. May return `null` if no user was
/// created yet.
Future<User?> getCurrentUser(LocalTextStorage storage) async {
  final config = await getUserConfig(storage);
  if (config == null) return null;
  return tryGetCurrentUserFromConfig(config);
}

/// Function for adding new users.
///
/// Adds a new user with the data specified in [user] to the app.
/// Also marks this user as the current user.
Future<Null> addUser(LocalTextStorage storage, User user) async {
  await updateUserConfig(storage, (initial) {
    if (initial == null) {
      return makeNewConfigForUser(user);
    }

    return appendUserToConfig(initial, user);
  });
}
