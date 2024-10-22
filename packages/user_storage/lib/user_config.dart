import 'package:common/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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
      : this(
            currentUserIndex: 0, userEntries: [UserConfigEntry.fromUser(user)]);

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);
  Map<String, dynamic> toJson() => _$UserConfigToJson(this);

  @override
  List<Object?> get props => [currentUserIndex, userEntries];
}
