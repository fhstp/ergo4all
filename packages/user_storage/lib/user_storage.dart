import 'dart:convert';

import 'package:common/list_ext.dart';
import 'package:common/user.dart';
import 'user_config.dart';
import 'package:text_storage/types.dart';

const userConfigFilePath = "users.json";

/// Appends a user to a [UserConfig] and sets the current user index to the
/// appended users index.
UserConfig appendUserToConfig(UserConfig config, User user) {
  return UserConfig(
      currentUserIndex: config.userEntries.length,
      userEntries: [...config.userEntries, UserConfigEntry.fromUser(user)]);
}

/// Attempts to get the current user from a [UserConfig] object.
/// This will attempt to get the [UserConfigEntry] corresponding to
/// [config.currentUserIndex] and convert it to a [User].
User? tryGetCurrentUserFromConfig(UserConfig config) {
  final userIndex = config.currentUserIndex;
  if (userIndex == null) return null;

  final userEntry = config.userEntries[userIndex];
  return userEntry.toUser();
}

/// Applies a mapping function to a user in a [UserConfig]. You must know the
/// [userIndex] of the user. Returns the mapped [UserConfig].
UserConfig updateUserInConfig(
    UserConfig config, int userIndex, User Function(User user) update) {
  return UserConfig(
      currentUserIndex: config.currentUserIndex,
      userEntries: config.userEntries.mapAt(userIndex, (userEntry) {
        final user = userEntry.toUser();
        final updatedUser = update(user);
        return UserConfigEntry.fromUser(updatedUser);
      }));
}

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

/// Gets the index of the current user from the local [UserConfig]. May be [null]
/// if there is no [UserConfig] or no current user.
Future<int?> getCurrentUserIndex(LocalTextStorage storage) async {
  final config = await getUserConfig(storage);
  if (config == null) return null;
  return config.currentUserIndex;
}

/// Function for getting the current user. May return `null` if no user was
/// created yet.
Future<User?> getCurrentUser(LocalTextStorage storage) async {
  final config = await getUserConfig(storage);
  if (config == null) return null;
  return tryGetCurrentUserFromConfig(config);
}

/// Updates a user in the local [UserConfig]. Finds the user using the given
/// [userIndex] and applies [updateF] to it.
Future<Null> updateUser(LocalTextStorage storage, int userIndex,
    User Function(User user) updateF) async {
  await updateUserConfig(storage, (config) {
    if (config == null) throw StateError("No user config found!");
    return updateUserInConfig(config, userIndex, updateF);
  });
}

/// Function for adding new users.
///
/// Adds a new user with the data specified in [user] to the app.
/// Also marks this user as the current user.
Future<Null> addUser(LocalTextStorage storage, User user) async {
  await updateUserConfig(storage, (initial) {
    if (initial == null) {
      return UserConfig.forUser(user);
    }

    return appendUserToConfig(initial, user);
  });
}
