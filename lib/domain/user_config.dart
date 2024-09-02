import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'user_config.g.dart';

const userConfigFilePath = "users.json";

@JsonSerializable()
@immutable
class UserConfigEntry extends Equatable {
  final String name;
  final TutorialViewStatus tutorialViewStatus;

  const UserConfigEntry({required this.name, required this.tutorialViewStatus});

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

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

  @override
  List<Object?> get props => [currentUserIndex, userEntries];
}

UserConfigEntry _userToEntry(User user) {
  return UserConfigEntry(
      name: user.name, tutorialViewStatus: user.tutorialViewStatus);
}

User _entryToUser(UserConfigEntry userEntry){
  return User(
      name: userEntry.name, tutorialViewStatus: userEntry.tutorialViewStatus);
}

/// Makes a new [UserConfig] with one user inside. The user will be the
/// current user.
UserConfig makeNewConfigForUser(User user) {
  return UserConfig(currentUserIndex: 0, userEntries: [_userToEntry(user)]);
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
  return _entryToUser(userEntry)
}
