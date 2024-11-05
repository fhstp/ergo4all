import 'dart:convert';

import 'package:common/list_ext.dart';
import 'package:common/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_management/src/types.dart';

part 'user_config.g.dart';

@JsonSerializable()
@immutable
class UserConfigEntry extends Equatable {
  final String name;
  final bool hasSeenTutorial;

  const UserConfigEntry({required this.name, required this.hasSeenTutorial});

  UserConfigEntry.fromUser(User user)
      : this(name: user.name, hasSeenTutorial: user.hasSeenTutorial);

  User toUser() {
    return User(name: name, hasSeenTutorial: hasSeenTutorial);
  }

  factory UserConfigEntry.fromJson(Map<String, dynamic> json) =>
      _$UserConfigEntryFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigEntryToJson(this);

  @override
  List<Object?> get props => [name, hasSeenTutorial];
}

@JsonSerializable()
@immutable
class UserConfig extends Equatable {
  final int? currentUserIndex;
  final List<UserConfigEntry> userEntries;

  const UserConfig({required this.currentUserIndex, required this.userEntries});

  /// Makes a new [UserConfig] with one user inside. The user will be the current user.
  UserConfig.forUser(User user)
      : this(
            currentUserIndex: 0, userEntries: [UserConfigEntry.fromUser(user)]);

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

  @override
  List<Object?> get props => [currentUserIndex, userEntries];
}

/// Appends a user to a [UserConfig] and sets the current user index to the appended users index.
UserConfig appendUserToConfig(UserConfig config, User user) {
  return UserConfig(
      currentUserIndex: config.userEntries.length,
      userEntries: [...config.userEntries, UserConfigEntry.fromUser(user)]);
}

/// Attempts to get the current user from a [UserConfig] object. This will attempt to get the [UserConfigEntry] corresponding to [config.currentUserIndex] and convert it to a [User].
User? tryGetCurrentUserFromConfig(UserConfig config) {
  final userIndex = config.currentUserIndex;
  if (userIndex == null) return null;

  final userEntry = config.userEntries[userIndex];
  return userEntry.toUser();
}

/// Applies a mapping function to a user in a [UserConfig]. You must know the [userIndex] of the user. Returns the mapped [UserConfig].
UserConfig updateUserInConfig(
    UserConfig config, int userIndex, Update<User> update) {
  return UserConfig(
      currentUserIndex: config.currentUserIndex,
      userEntries: config.userEntries.mapAt(userIndex, (userEntry) {
        final user = userEntry.toUser();
        final updatedUser = update(user);
        return UserConfigEntry.fromUser(updatedUser);
      }));
}

UserConfig parseUserConfig(String text) {
  final json = jsonDecode(text);
  return UserConfig.fromJson(json);
}

String serializeUserConfig(UserConfig config) {
  final json = config.toJson();
  return jsonEncode(json);
}
