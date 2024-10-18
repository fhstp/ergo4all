import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ergo4all/app/io/local_text_storage.dart';
import 'package:ergo4all/domain/list_ext.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_storage.g.dart';

const userConfigFilePath = "users.json";

@JsonSerializable()
@immutable
class UserConfigEntry extends Equatable {
  final String name;
  final bool hasSeenTutorial;

  const UserConfigEntry({required this.name, required this.hasSeenTutorial});

  factory UserConfigEntry.fromJson(Map<String, dynamic> json) =>
      _$UserConfigEntryFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigEntryToJson(this);

  @override
  List<Object?> get props => [name];
}

@JsonSerializable()
@immutable
class UserConfig extends Equatable {
  final int? currentUserIndex;
  final List<UserConfigEntry> userEntries;

  const UserConfig({required this.currentUserIndex, required this.userEntries});

  /// Makes a new [UserConfig] with one user inside. The user will be the
  /// current user.
  UserConfig.forUser(User user)
      : this(currentUserIndex: 0, userEntries: [_userToEntry(user)]);

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

  @override
  List<Object?> get props => [currentUserIndex, userEntries];
}

UserConfigEntry _userToEntry(User user) {
  return UserConfigEntry(
      name: user.name, hasSeenTutorial: user.hasSeenTutorial);
}

User _entryToUser(UserConfigEntry userEntry) {
  return User(name: userEntry.name, hasSeenTutorial: userEntry.hasSeenTutorial);
}

/// Appends a user to a [UserConfig] and sets the current user index to the
/// appended users index.
UserConfig appendUserToConfig(UserConfig config, User user) {
  return UserConfig(
      currentUserIndex: config.userEntries.length,
      userEntries: [...config.userEntries, _userToEntry(user)]);
}

/// Attempts to get the current user from a [UserConfig] object.
/// This will attempt to get the [UserConfigEntry] corresponding to
/// [config.currentUserIndex] and convert it to a [User].
User? tryGetCurrentUserFromConfig(UserConfig config) {
  final userIndex = config.currentUserIndex;
  if (userIndex == null) return null;

  final userEntry = config.userEntries[userIndex];
  return _entryToUser(userEntry);
}

/// Applies a mapping function to a user in a [UserConfig]. You must know the
/// [userIndex] of the user. Returns the mapped [UserConfig].
UserConfig updateUserInConfig(
    UserConfig config, int userIndex, User Function(User user) update) {
  return UserConfig(
      currentUserIndex: config.currentUserIndex,
      userEntries: config.userEntries.mapAt(userIndex, (userEntry) {
        final user = _entryToUser(userEntry);
        final updatedUser = update(user);
        return _userToEntry(updatedUser);
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
