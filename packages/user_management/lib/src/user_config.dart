import 'dart:convert';

import 'package:common/list_ext.dart';
import 'package:common/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_management/src/types.dart';

part 'user_config.g.dart';

/// An entry in the user config file
@JsonSerializable()
@immutable
class UserConfigEntry extends Equatable {
  /// Creates a user config entry.
  const UserConfigEntry({required this.name, required this.hasSeenTutorial});

  /// Creates a user config entry from a [User].
  UserConfigEntry.fromUser(User user)
      : this(name: user.name, hasSeenTutorial: user.hasSeenTutorial);

  /// Creates a user config entry from json.
  factory UserConfigEntry.fromJson(Map<String, dynamic> json) =>
      _$UserConfigEntryFromJson(json);

  /// Corresponds to [User.name]
  final String name;

  /// Corresponds to [User.hasSeenTutorial]
  final bool hasSeenTutorial;

  /// Makes a user from this entry.
  User toUser() {
    return User(name: name, hasSeenTutorial: hasSeenTutorial);
  }

  /// Serializes this entry to json.
  Map<String, dynamic> toJson() => _$UserConfigEntryToJson(this);

  @override
  List<Object?> get props => [name, hasSeenTutorial];
}

/// Representation of the content of a user config file.
@JsonSerializable()
@immutable
class UserConfig extends Equatable {
  /// Creates a [UserConfig] object.
  const UserConfig({required this.currentUserIndex, required this.userEntries});

  /// Makes a new [UserConfig] with one user inside. The user will be the
  /// current user.
  UserConfig.forUser(User user)
      : this(
          currentUserIndex: 0,
          userEntries: [UserConfigEntry.fromUser(user)],
        );

  /// Creates a [UserConfig] from json.
  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);

  /// The index of the currently active user.
  final int? currentUserIndex;

  /// Data about each user.
  final List<UserConfigEntry> userEntries;

  /// Convert this object to json.
  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

  @override
  List<Object?> get props => [currentUserIndex, userEntries];
}

/// Appends a user to a [UserConfig] and sets the current user index to the
/// appended users index.
UserConfig appendUserToConfig(UserConfig config, User user) {
  return UserConfig(
    currentUserIndex: config.userEntries.length,
    userEntries: [...config.userEntries, UserConfigEntry.fromUser(user)],
  );
}

/// Attempts to get the current user from a [UserConfig] object. This will
/// attempt to get the [UserConfigEntry] corresponding to
/// [UserConfig.currentUserIndex] and convert it to a [User].
User? tryGetCurrentUserFromConfig(UserConfig config) {
  final userIndex = config.currentUserIndex;
  if (userIndex == null) return null;

  final userEntry = config.userEntries[userIndex];
  return userEntry.toUser();
}

/// Applies a mapping function to a user in a [UserConfig]. You must know the
/// [userIndex] of the user. Returns the mapped [UserConfig].
UserConfig updateUserInConfig(
  UserConfig config,
  int userIndex,
  Update<User> update,
) {
  return UserConfig(
    currentUserIndex: config.currentUserIndex,
    userEntries: config.userEntries.mapAt(userIndex, (userEntry) {
      final user = userEntry.toUser();
      final updatedUser = update(user);
      return UserConfigEntry.fromUser(updatedUser);
    }),
  );
}

/// Parses the given [text] into a [UserConfig].
UserConfig parseUserConfig(String text) {
  final json = jsonDecode(text);
  // ignore: argument_type_not_assignable If this parse fails, it's fine to crash.
  return UserConfig.fromJson(json);
}

/// Serializes a [UserConfig] to [String].
String serializeUserConfig(UserConfig config) {
  final json = config.toJson();
  return jsonEncode(json);
}
