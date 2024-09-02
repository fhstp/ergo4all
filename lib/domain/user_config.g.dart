// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConfigEntry _$UserConfigEntryFromJson(Map<String, dynamic> json) =>
    UserConfigEntry(
      name: json['name'] as String,
      tutorialViewStatus:
          $enumDecode(_$TutorialViewStatusEnumMap, json['tutorialViewStatus']),
    );

Map<String, dynamic> _$UserConfigEntryToJson(UserConfigEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tutorialViewStatus':
          _$TutorialViewStatusEnumMap[instance.tutorialViewStatus]!,
    };

const _$TutorialViewStatusEnumMap = {
  TutorialViewStatus.notDecided: 'notDecided',
  TutorialViewStatus.seen: 'seen',
  TutorialViewStatus.skipped: 'skipped',
};

UserConfig _$UserConfigFromJson(Map<String, dynamic> json) => UserConfig(
      currentUserIndex: (json['currentUserIndex'] as num?)?.toInt(),
      userEntries: (json['userEntries'] as List<dynamic>)
          .map((e) => UserConfigEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserConfigToJson(UserConfig instance) =>
    <String, dynamic>{
      'currentUserIndex': instance.currentUserIndex,
      'userEntries': instance.userEntries,
    };
