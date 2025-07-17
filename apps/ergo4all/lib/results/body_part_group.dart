import 'package:common/immutable_collection_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:ergo4all/results/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rula/rula.dart';

/// Groups of body parts which are displayed / scored together.
enum BodyPartGroup {
  /// The shoulder.
  shoulder,

  /// The arm. This includes elbow and hand.
  arm,

  /// The trunk.
  trunk,

  /// The neck.
  neck,

  /// The legs.
  legs,
}

/// Extension for accessing scores for [BodyPartGroup]s from [RulaScores].
extension ScoreAccess on RulaScores {
  /// Get scores for a [BodyPartGroup].
  IList<int> bodyPartGroupScoreOf(BodyPartGroup group) {
    return switch (group) {
      BodyPartGroup.shoulder => Pair.toList(upperArmScores),
      BodyPartGroup.arm => Pair.toList(lowerArmScores),
      BodyPartGroup.trunk => IList([trunkScore]),
      BodyPartGroup.neck => IList([neckScore]),
      BodyPartGroup.legs => Pair.toList(legScores)
    };
  }
}

/// Gets the maximum value score in a [BodyPartGroup] is expected to reach.
int maxScoreOf(BodyPartGroup group) => switch (group) {
      BodyPartGroup.shoulder => 6,
      BodyPartGroup.arm => 3,
      BodyPartGroup.trunk => 6,
      BodyPartGroup.neck => 6,
      BodyPartGroup.legs => 3
    };

/// Gets the [BodyPartGroup] for a [BodyPart].
BodyPartGroup groupOf(BodyPart part) => switch (part) {
      BodyPart.head => BodyPartGroup.neck,
      BodyPart.leftHand ||
      BodyPart.leftLowerArm ||
      BodyPart.rightHand ||
      BodyPart.rightLowerArm =>
        BodyPartGroup.arm,
      BodyPart.leftLeg || BodyPart.rightLeg => BodyPartGroup.legs,
      BodyPart.leftUpperArm || BodyPart.rightUpperArm => BodyPartGroup.shoulder,
      BodyPart.upperBody => BodyPartGroup.trunk,
    };

/// Groups scores in a [RulaTimeline] by [BodyPartGroup].
///
/// For singular body-parts, like the neck, there will be one list,
/// while for paired ones, like the arms, there will be two, for left and right.
///
/// `neck => [[1, 2, 3]]`
///
/// `arms => [[1, 2, 3], [3, 4, 5]]`
IMap<BodyPartGroup, IList<IList<int>>> groupTimelineScores(
  RulaTimeline timeline,
) =>
    IMap.fromKeys(
      keys: BodyPartGroup.values,
      valueMapper: (bodyPartGroup) => timeline
          .map((entry) => entry.scores.bodyPartGroupScoreOf(bodyPartGroup))
          .toIList()
          .columns()
          .toIList(),
    );
