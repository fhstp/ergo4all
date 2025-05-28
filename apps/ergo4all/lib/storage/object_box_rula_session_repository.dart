import 'package:ergo4all/objectbox.g.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/storage/object_box_entities.dart';
import 'package:ergo4all/storage/rula_session.dart';
import 'package:ergo4all/storage/rula_session_repository.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rula/rula.dart';

/// Implementation of the RulaSessionRepository using the Object box database
class ObjectBoxRulaSessionRepository extends RulaSessionRepository {

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
      final upperArmAdj = IntPairEntity.fromTuple(score.upperArmAbductedAdjustments);
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

      final timelineEntryEntity = TimelineEntryEntity(timestamp: entry.timestamp);
      timelineEntryEntity.scores.target = scoresEntity;
      sessionEntity.timeline.add(timelineEntryEntity);
    }

    store.box<RulaSessionEntity>().put(sessionEntity);
  }

  @override
  List<RulaSession> getAll() {
    final sessionBox = store.box<RulaSessionEntity>();
    final sessions = sessionBox.query()
        .order(RulaSessionEntity_.timestamp, flags: Order.descending)
        .build()
        .find();

    return sessions.map((sessionEntity) {
      final timeline = sessionEntity.timeline.map((entryEntity) {
        final scoresEntity = entryEntity.scores.target!;
        return TimelineEntry(
          timestamp: entryEntity.timestamp,
          scores: RulaScores(
            upperArmPositionScores: scoresEntity.upperArmPositionScores.target!.toTuple(),
            upperArmAbductedAdjustments: scoresEntity.upperArmAbductedAdjustments.target!.toTuple(),
            upperArmScores: scoresEntity.upperArmScores.target!.toTuple(),
            lowerArmPositionScores: scoresEntity.lowerArmPositionScores.target!.toTuple(),
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
}
