import 'dart:io';

import 'package:common/func_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:csv/csv.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rula/rula.dart';

@immutable
class _SessionMeta {
  const _SessionMeta(this.timestamp, this.profileId, this.scenarioIndex);

  final int timestamp;
  final int profileId;
  final int scenarioIndex;
}

typedef _ScoreRow = (int, RulaScores);

IMap<String, String> _parseKV(List<String> lines) => IMap.fromEntries(
      lines.map((part) {
        final [key, value] = part.split('=');
        return MapEntry(key, value);
      }),
    );

String _stringifyKV(IMap<String, String> kv) =>
    kv.toEntryList().map((entry) => '${entry.key}=${entry.value}').join('\n');

Future<_SessionMeta> _loadMetaFrom(File file) async {
  final lines = await file.readAsLines();
  final map = _parseKV(lines);

  final timestamp =
      map['timestamp']!.toIntOption.expect('Should parse timestamp');
  final profileId =
      map['profileId']?.toIntOption.expect('Should parse profile id') ??
          // If the file did not contain a profile-id, then it was likely
          // recorded with an old version of the app, without profiles.
          // In that case we just assign the session to the default profile.
          ProfileRepo.defaultProfile.id;
  final scenarioIndex =
      map['scenarioIndex']!.toIntOption.expect('Should parse scenario-index');

  return _SessionMeta(timestamp, profileId, scenarioIndex);
}

Future<void> _writeMetaTo(_SessionMeta meta, File file) async {
  final map = IMap.fromEntries([
    MapEntry('timestamp', meta.timestamp.toString()),
    MapEntry('profileId', meta.profileId.toString()),
    MapEntry('scenarioIndex', meta.scenarioIndex.toString()),
  ]);
  final text = _stringifyKV(map);
  await file.writeAsString(text);
}

List<int> _csvRowOf(_ScoreRow row) {
  final (timestamp, scores) = row;
  return [
    timestamp,
    scores.fullScore,
    Pair.left(scores.legScores),
    Pair.right(scores.legScores),
    Pair.left(scores.lowerArmPositionScores),
    Pair.right(scores.lowerArmPositionScores),
    Pair.left(scores.lowerArmScores),
    Pair.right(scores.lowerArmScores),
    scores.neckPositionScore,
    scores.neckScore,
    scores.neckSideBendAdjustment,
    scores.neckTwistAdjustment,
    scores.trunkPositionScore,
    scores.trunkScore,
    scores.trunkSideBendAdjustment,
    scores.trunkTwistAdjustment,
    Pair.left(scores.upperArmAbductedAdjustments),
    Pair.right(scores.upperArmAbductedAdjustments),
    Pair.left(scores.upperArmPositionScores),
    Pair.right(scores.upperArmPositionScores),
    Pair.left(scores.upperArmScores),
    Pair.right(scores.upperArmScores),
    Pair.left(scores.wristScores),
    Pair.right(scores.wristScores),
  ];
}

_ScoreRow _scoreRowOf(List<dynamic> row) {
  return (
    row[0] as int,
    RulaScores(
      fullScore: row[1] as int,
      legScores: (row[2], row[3]),
      lowerArmPositionScores: (row[4], row[5]),
      lowerArmScores: (row[6], row[7]),
      neckPositionScore: row[8] as int,
      neckScore: row[9] as int,
      neckSideBendAdjustment: row[10] as int,
      neckTwistAdjustment: row[11] as int,
      trunkPositionScore: row[12] as int,
      trunkScore: row[13] as int,
      trunkSideBendAdjustment: row[14] as int,
      trunkTwistAdjustment: row[15] as int,
      upperArmAbductedAdjustments: (row[16], row[17]),
      upperArmPositionScores: (row[18], row[19]),
      upperArmScores: (row[20], row[21]),
      wristScores: (row[22], row[23]),
    ),
  );
}

Future<Iterable<_ScoreRow>> _loadScoresFrom(File file) async {
  final text = await file.readAsString();
  final rows = const CsvToListConverter().convert(text);
  return rows.map(_scoreRowOf);
}

Future<void> _writeSoresTo(Iterable<_ScoreRow> scoreRows, File file) async {
  final rows = scoreRows.map(_csvRowOf).toList();
  final text = const ListToCsvConverter().convert(rows);
  await file.writeAsString(text);
}

Future<List<KeyFrame>> _loadKeyFrames(Directory dir) async {
  final imageFiles = dir
      .list()
      .where((entry) => entry is File && entry.path.endsWith('.jpg'))
      .map((file) => file as File);

  final entries = await imageFiles.asyncMap((file) async {
    final fileName = path.basenameWithoutExtension(file.path);
    final parts = fileName.split('-');

    final score =
        parts[0].toDoubleOption.expect('Should parse score from file name');
    final timestamp =
        parts[1].toIntOption.expect('Should parse timestamp from file name');

    final image = await file.readAsBytes();

    return KeyFrame(score, image, timestamp);
  }).toList();

  entries.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  return entries;
}

Future<void> _storeImage(
  Directory dir,
  double score,
  int timestamp,
  Uint8List image,
) async {
  final fileName = '$score-$timestamp.jpg';
  final filePath = path.join(dir.path, fileName);

  final file = File(filePath);
  await file.writeAsBytes(image, flush: true);
}

Future<List<String>> _loadActivities(File file) async {
  if (!await file.exists()) {
    return [];
  }
  
  final lines = await file.readAsLines();
  return lines;
}

Future<void> _writeActivities(List<String> activities, File file) async {
  final content = activities.join('\n');
  await file.writeAsString(content);
}

Future<RulaSession> _loadSessionFrom(Directory dir) async {
  final metaFile = File(path.join(dir.path, 'meta'));
  final meta = await _loadMetaFrom(metaFile);

  final keyFrames = await _loadKeyFrames(dir);

  final timelineFile = File(path.join(dir.path, 'scores.csv'));
  final scores = await _loadScoresFrom(timelineFile);
  final timeline = scores.map((row) {
    final timestamp = row.$1;
    return TimelineEntry(timestamp: timestamp, scores: row.$2);
  }).toIList();

  final activitiesFile = File(path.join(dir.path, 'activities.txt'));
  final activities = await _loadActivities(activitiesFile);

  return RulaSession(
    timestamp: meta.timestamp,
    profileId: meta.profileId,
    scenario: Scenario.values[meta.scenarioIndex],
    timeline: timeline,
    keyFrames: keyFrames,
    activities: activities,
  );
}

Future<void> _writeSessionTo(RulaSession session, Directory dir) async {
  final metaFile = File(path.join(dir.path, 'meta'));
  await metaFile.create();
  final meta = _SessionMeta(
    session.timestamp,
    session.profileId,
    session.scenario.index,
  );
  await _writeMetaTo(meta, metaFile);

  final timelineFile = File(path.join(dir.path, 'scores.csv'));
  await timelineFile.create();
  final scores =
      session.timeline.map((entry) => (entry.timestamp, entry.scores));
  await _writeSoresTo(scores, timelineFile);

  final activitiesFile = File(path.join(dir.path, 'activities.txt'));
  await activitiesFile.create();
  await _writeActivities(session.activities, activitiesFile);

  await Future.forEach(
    session.keyFrames,
    (row) => _storeImage(dir, row.score, row.timestamp, row.screenshot),
  );
}

/// Implementation of [RulaSessionRepository] which stores session as plain
/// files in the file-system.
class FileBasedRulaSessionRepository implements RulaSessionRepository {
  Future<Directory> _getSessionsDir() async {
    final docDir = await getApplicationDocumentsDirectory();
    final sessionsDirPath = path.join(docDir.path, 'sessions');
    return Directory(sessionsDirPath).create(recursive: true);
  }

  Future<Stream<Directory>> _getSessionDirs() async {
    final sessionsDir = await _getSessionsDir();
    return sessionsDir
        .list()
        .cast<Directory>()
        .where((it) => path.basename(it.path).toIntOption.isSome());
  }

  @override
  Future<void> clear() async {
    final sessionDirs = await (await _getSessionDirs()).toList();
    for (final dir in sessionDirs) {
      await dir.delete(recursive: true);
    }
  }

  @override
  Future<void> deleteByTimestamp(int timestamp) async {
    final sessionsDir = await _getSessionsDir();
    final sessionDir =
        Directory(path.join(sessionsDir.path, timestamp.toString()));
    await sessionDir.delete(recursive: true);
  }

  @override
  Future<List<RulaSession>> getAll() async {
    final sessionDirs = await _getSessionDirs();
    return sessionDirs.asyncMap(_loadSessionFrom).toList();
  }

  @override
  Future<void> put(RulaSession session) async {
    final sessionsDir = await _getSessionsDir();
    final sessionDir =
        Directory(path.join(sessionsDir.path, session.timestamp.toString()));

    await sessionDir.create();
    await _writeSessionTo(session, sessionDir);
  }

  @override
  Future<void> deleteAllBy(int profileId) async {
    final allSessions = await getAll();
    final sessionsWithProfile =
        allSessions.filter((session) => session.profileId == profileId);

    for (final session in sessionsWithProfile) {
      await deleteByTimestamp(session.timestamp);
    }
  }
}
