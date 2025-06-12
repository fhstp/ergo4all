import 'package:ergo4all/objectbox.g.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/session_storage/src/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rula/rula.dart';

@Entity()
class IntPairEntity {
  IntPairEntity({required this.first, required this.second});
  int id = 0;
  int first;
  int second;

  static IntPairEntity fromTuple((int, int) t) =>
      IntPairEntity(first: t.$1, second: t.$2);
  (int, int) toTuple() => (first, second);
}

@Entity()
class RulaScoresEntity {
  RulaScoresEntity({
    required this.neckPositionScore,
    required this.neckTwistAdjustment,
    required this.neckSideBendAdjustment,
    required this.neckScore,
    required this.trunkPositionScore,
    required this.trunkTwistAdjustment,
    required this.trunkSideBendAdjustment,
    required this.trunkScore,
    required this.legScore,
    required this.fullScore,
  });
  int id = 0;

  final upperArmPositionScores = ToOne<IntPairEntity>();
  final upperArmAbductedAdjustments = ToOne<IntPairEntity>();
  final upperArmScores = ToOne<IntPairEntity>();
  final lowerArmPositionScores = ToOne<IntPairEntity>();
  final lowerArmScores = ToOne<IntPairEntity>();
  final wristScores = ToOne<IntPairEntity>();

  int neckPositionScore;
  int neckTwistAdjustment;
  int neckSideBendAdjustment;
  int neckScore;
  int trunkPositionScore;
  int trunkTwistAdjustment;
  int trunkSideBendAdjustment;
  int trunkScore;
  int legScore;
  int fullScore;
}

@Entity()
class TimelineEntryEntity {
  TimelineEntryEntity({required this.timestamp});
  int id = 0;
  int timestamp;
  final scores = ToOne<RulaScoresEntity>();

  final session = ToOne<RulaSessionEntity>();
}

/// Object box entity required in order to store the RulaSession in the database
@Entity()
class RulaSessionEntity {
  RulaSessionEntity({
    required this.timestamp,
    required this.scenarioIndex,
  });
  int id = 0;
  int timestamp;

  int scenarioIndex;

  @Backlink('session')
  final timeline = ToMany<TimelineEntryEntity>();
}

/// Implementation of the [RulaSessionRepository] which is backed by
/// an object-box [Store].
class ObjectBoxRulaSessionRepository extends RulaSessionRepository {
  ///
  ObjectBoxRulaSessionRepository(this.store);

  final Store store;

  @override
  Future<void> save(RulaSession session) async {
    final sessionEntity = RulaSessionEntity(
      timestamp: session.timestamp,
      scenarioIndex: session.scenario.index,
    );
    final pairBox = store.box<IntPairEntity>();
    final scoresBox = store.box<RulaScoresEntity>();

    for (var entry in session.timeline) {
      final score = entry.scores;
      final scoresEntity = RulaScoresEntity(
        neckPositionScore: score.neckPositionScore,
        neckTwistAdjustment: score.neckTwistAdjustment,
        neckSideBendAdjustment: score.neckSideBendAdjustment,
        neckScore: score.neckScore,
        trunkPositionScore: score.trunkPositionScore,
        trunkTwistAdjustment: score.trunkTwistAdjustment,
        trunkSideBendAdjustment: score.trunkSideBendAdjustment,
        trunkScore: score.trunkScore,
        legScore: score.legScore,
        fullScore: score.fullScore,
      );

      final upperArmPos = IntPairEntity.fromTuple(score.upperArmPositionScores);
      final upperArmAdj =
          IntPairEntity.fromTuple(score.upperArmAbductedAdjustments);
      final upperArmScores = IntPairEntity.fromTuple(score.upperArmScores);
      final lowerArmPos = IntPairEntity.fromTuple(score.lowerArmPositionScores);
      final lowerArmScores = IntPairEntity.fromTuple(score.lowerArmScores);
      final wristScores = IntPairEntity.fromTuple(score.wristScores);

      pairBox.putMany([
        upperArmPos,
        upperArmAdj,
        upperArmScores,
        lowerArmPos,
        lowerArmScores,
        wristScores,
      ]);

      scoresEntity.upperArmPositionScores.target = upperArmPos;
      scoresEntity.upperArmAbductedAdjustments.target = upperArmAdj;
      scoresEntity.upperArmScores.target = upperArmScores;
      scoresEntity.lowerArmPositionScores.target = lowerArmPos;
      scoresEntity.lowerArmScores.target = lowerArmScores;
      scoresEntity.wristScores.target = wristScores;

      scoresBox.put(scoresEntity);

      final timelineEntryEntity =
          TimelineEntryEntity(timestamp: entry.timestamp);
      timelineEntryEntity.scores.target = scoresEntity;
      sessionEntity.timeline.add(timelineEntryEntity);
    }

    store.box<RulaSessionEntity>().put(sessionEntity);
  }

  @override
  List<RulaSession> getAll() {
    final sessionBox = store.box<RulaSessionEntity>();
    final sessions = sessionBox
        .query()
        .order(RulaSessionEntity_.timestamp, flags: Order.descending)
        .build()
        .find();

    return sessions.map((sessionEntity) {
      final timeline = sessionEntity.timeline.map((entryEntity) {
        final scoresEntity = entryEntity.scores.target!;
        return TimelineEntry(
          timestamp: entryEntity.timestamp,
          scores: RulaScores(
            upperArmPositionScores:
                scoresEntity.upperArmPositionScores.target!.toTuple(),
            upperArmAbductedAdjustments:
                scoresEntity.upperArmAbductedAdjustments.target!.toTuple(),
            upperArmScores: scoresEntity.upperArmScores.target!.toTuple(),
            lowerArmPositionScores:
                scoresEntity.lowerArmPositionScores.target!.toTuple(),
            lowerArmScores: scoresEntity.lowerArmScores.target!.toTuple(),
            wristScores: scoresEntity.wristScores.target!.toTuple(),
            neckPositionScore: scoresEntity.neckPositionScore,
            neckTwistAdjustment: scoresEntity.neckTwistAdjustment,
            neckSideBendAdjustment: scoresEntity.neckSideBendAdjustment,
            neckScore: scoresEntity.neckScore,
            trunkPositionScore: scoresEntity.trunkPositionScore,
            trunkTwistAdjustment: scoresEntity.trunkTwistAdjustment,
            trunkSideBendAdjustment: scoresEntity.trunkSideBendAdjustment,
            trunkScore: scoresEntity.trunkScore,
            legScore: scoresEntity.legScore,
            fullScore: scoresEntity.fullScore,
          ),
        );
      }).toList();

      return RulaSession(
        timestamp: sessionEntity.timestamp,
        scenario: Scenario.values[sessionEntity.scenarioIndex],
        timeline: timeline.toIList(),
      );
    }).toList();
  }

  @override
  void deleteSession(int timestamp) {
    final sessionBox = store.box<RulaSessionEntity>();
    final timelineBox = store.box<TimelineEntryEntity>();
    final scoresBox = store.box<RulaScoresEntity>();
    final pairBox = store.box<IntPairEntity>();

    final query = sessionBox
        .query(RulaSessionEntity_.timestamp.equals(timestamp))
        .build();
    final session = query.findFirst();
    query.close();

    if (session == null) return;

    for (final entry in session.timeline) {
      final scores = entry.scores.target;
      if (scores != null) {
        final pairs = [
          scores.upperArmPositionScores.target,
          scores.upperArmAbductedAdjustments.target,
          scores.upperArmScores.target,
          scores.lowerArmPositionScores.target,
          scores.lowerArmScores.target,
          scores.wristScores.target,
        ];
        // Delete IntPairEntity instances
        for (final pair in pairs) {
          if (pair != null) {
            pairBox.remove(pair.id);
          }
        }
        scoresBox.remove(scores.id);
      }
      timelineBox.remove(entry.id);
    }

    sessionBox.remove(session.id);
  }

  @override
  void deleteAllSessions() {
    final sessionBox = store.box<RulaSessionEntity>();
    final timelineBox = store.box<TimelineEntryEntity>();
    final scoresBox = store.box<RulaScoresEntity>();
    final pairBox = store.box<IntPairEntity>();

    // Order matters: delete from children to parents
    pairBox.removeAll();
    scoresBox.removeAll();
    timelineBox.removeAll();
    sessionBox.removeAll();
  }
}
