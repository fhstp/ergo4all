import 'package:ergo4all/objectbox.g.dart';

/// Object box entity required in order to store the positions scores in the database
@Entity()
class IntPairEntity {

  IntPairEntity({required this.first, required this.second});
  int id = 0;
  int first;
  int second;

  static IntPairEntity fromTuple((int, int) t) => IntPairEntity(first: t.$1, second: t.$2);
  (int, int) toTuple() => (first, second);
}

/// Object box entity required in order to store the RulaScores in the database
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

/// Object box entity required in order to store the TimelineEntry in the database
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
