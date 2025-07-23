import 'dart:io';

import 'package:common/func_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:csv/csv.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rula/rula.dart';

@immutable
class _SessionMeta {
  const _SessionMeta(this.timestamp, this.scenarioIndex);

  final int timestamp;
  final int scenarioIndex;
}

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
  final scenarioIndex =
      map['scenarioIndex']!.toIntOption.expect('Should parse scenario-index');

  return _SessionMeta(timestamp, scenarioIndex);
}

Future<void> _writeMetaTo(_SessionMeta meta, File file) async {
  final map = IMap.fromEntries([
    MapEntry('timestamp', meta.timestamp.toString()),
    MapEntry('scenarioIndex', meta.scenarioIndex.toString()),
  ]);
  final text = _stringifyKV(map);
  await file.writeAsString(text);
}

List<int> _timelineEntryToRow(TimelineEntry entry) {
  return [
    entry.timestamp,
    entry.scores.fullScore,
    Pair.left(entry.scores.legScores),
    Pair.right(entry.scores.legScores),
    Pair.left(entry.scores.lowerArmPositionScores),
    Pair.right(entry.scores.lowerArmPositionScores),
    Pair.left(entry.scores.lowerArmScores),
    Pair.right(entry.scores.lowerArmScores),
    entry.scores.neckPositionScore,
    entry.scores.neckScore,
    entry.scores.neckSideBendAdjustment,
    entry.scores.neckTwistAdjustment,
    entry.scores.trunkPositionScore,
    entry.scores.trunkScore,
    entry.scores.trunkSideBendAdjustment,
    entry.scores.trunkTwistAdjustment,
    Pair.left(entry.scores.upperArmAbductedAdjustments),
    Pair.right(entry.scores.upperArmAbductedAdjustments),
    Pair.left(entry.scores.upperArmPositionScores),
    Pair.right(entry.scores.upperArmPositionScores),
    Pair.left(entry.scores.upperArmScores),
    Pair.right(entry.scores.upperArmScores),
    Pair.left(entry.scores.wristScores),
    Pair.right(entry.scores.wristScores),
  ];
}

TimelineEntry _timelineEntryFromRow(List<dynamic> row) {
  return TimelineEntry(
    timestamp: row[0] as int,
    scores: RulaScores(
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

Future<RulaTimeline> _loadTimelineFrom(File file) async {
  final text = await file.readAsString();
  final rows = const CsvToListConverter().convert(text);
  final entries = rows.map(_timelineEntryFromRow);
  return entries.toIList();
}

Future<void> _writeTimelineTo(RulaTimeline timeline, File file) async {
  final rows = timeline.map(_timelineEntryToRow).toList();
  final text = const ListToCsvConverter().convert(rows);
  await file.writeAsString(text);
}

Future<RulaSession> _loadSessionFrom(Directory dir) async {
  final metaFile = File(path.join(dir.path, 'meta'));
  final meta = await _loadMetaFrom(metaFile);

  final timelineFile = File(path.join(dir.path, 'timeline.csv'));
  final timeline = await _loadTimelineFrom(timelineFile);

  return RulaSession(
    timestamp: meta.timestamp,
    scenario: Scenario.values[meta.scenarioIndex],
    timeline: timeline,
  );
}

Future<void> _writeSessionTo(RulaSession session, Directory dir) async {
  final metaFile = File(path.join(dir.path, 'meta'));
  await metaFile.create();
  final meta = _SessionMeta(session.timestamp, session.scenario.index);
  await _writeMetaTo(meta, metaFile);

  final timelineFile = File(path.join(dir.path, 'timeline.csv'));
  await timelineFile.create();
  await _writeTimelineTo(session.timeline, timelineFile);
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
        .where((it) => it is Directory)
        .map((it) => it as Directory)
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
}
