import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:ergo4all/io/local_file.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_config.g.dart';

@JsonSerializable()
@immutable
class UserConfigEntry extends Equatable {
  final String name;

  const UserConfigEntry({required this.name});

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

const _userConfigFilePath = "users.json";

/// Function for getting the current [UserConfig].
typedef GetUserConfig = Future<UserConfig?> Function();

/// Makes a [GetUserConfig] function which loads the content of the
/// user config json file.
GetUserConfig makeGetUserConfigFromStorage(
    ReadLocalTextFile readLocalTextFile) {
  return () async {
    final text = await readLocalTextFile(_userConfigFilePath);
    if (text == null) return null;

    final json = jsonDecode(text);

    return UserConfig.fromJson(json);
  };
}

/// Function for updating the user config.
///
/// Use the [update] function to modify the user config. It receives the
/// current config as a parameter. If there is no config it will receive `null`.
/// The value returned by the [update] function will override the user config.
typedef UpdateUserConfig = Future<Null> Function(
    UserConfig Function(UserConfig?) update);

/// Makes a [UpdateUserConfig] function which updates the content of the
/// user config json file.
UpdateUserConfig makeUpdateStoredUserConfig(
    GetUserConfig getUserConfig, WriteLocalTextFile writeLocalTextFile) {
  return (update) async {
    final initial = await getUserConfig();
    final updated = update(initial);
    final json = updated.toJson();
    final text = jsonEncode(json);
    await writeLocalTextFile(_userConfigFilePath, text);
  };
}
