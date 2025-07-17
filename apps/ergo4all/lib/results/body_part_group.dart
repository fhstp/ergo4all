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

/// Get scores for a [BodyPartGroup] from a [RulaScores] object.
IList<int> bodyPartGroupScoreOf(RulaScores scores, BodyPartGroup group) {
  return switch (group) {
    BodyPartGroup.shoulder => Pair.toList(scores.upperArmScores),
    BodyPartGroup.arm => Pair.toList(scores.lowerArmScores),
    BodyPartGroup.trunk => IList([scores.trunkScore]),
    BodyPartGroup.neck => IList([scores.neckScore]),
    BodyPartGroup.legs => Pair.toList(scores.legScores)
  };
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
