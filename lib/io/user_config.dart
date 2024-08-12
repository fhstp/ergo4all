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

/// Function for getting the current [UserConfig].
typedef GetUserConfig = Future<UserConfig?> Function();

/// Makes a [GetUserConfig] function which loads the content of the
/// user config json file.
GetUserConfig makeGetUserConfigFromStorage(
    ReadLocalTextFile readLocalTextFile) {
  return () async {
    final text = await readLocalTextFile("users.json");
    if (text == null) return null;

    final json = jsonDecode(text);

    return UserConfig.fromJson(json);
  };
}
