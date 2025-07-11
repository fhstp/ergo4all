import 'package:common/func_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/common.dart';
import 'package:rula/rula.dart';

/// Groups of body parts which are displayed / scored together.
enum BodyPartGroup {
  /// The upper arm, ie. the shoulder.
  upperArm,

  /// The lower arm. This includes elbow and hand.
  lowerArm,

  /// The trunk.
  trunk,

  /// The neck.
  neck,

  /// The legs.
  legs,
}

/// Get normalized scores for a [BodyPartGroup] from a [RulaScores] object.
double normalizedBodyPartGroupScoreOf(RulaScores scores, BodyPartGroup group) {
  return switch (group) {
    BodyPartGroup.upperArm => scores.upperArmScores
        .pipe(Pair.reduce(worse))
        .pipe((score) => normalizeScore(score, 6)),
    BodyPartGroup.lowerArm => scores.lowerArmScores
        .pipe(Pair.reduce(worse))
        .pipe((score) => normalizeScore(score, 3)),
    BodyPartGroup.trunk => normalizeScore(scores.trunkScore, 6),
    BodyPartGroup.neck => normalizeScore(scores.neckScore, 6),
    BodyPartGroup.legs => normalizeScore(scores.legScore, 2),
  };
}

/// Get the localized label for the given [group].
String bodyPartGroupLabelFor(
  AppLocalizations localizations,
  BodyPartGroup group,
) {
  return switch (group) {
    BodyPartGroup.upperArm => localizations.results_body_upper_arms,
    BodyPartGroup.lowerArm => localizations.results_body_lower_arms,
    BodyPartGroup.trunk => localizations.results_body_trunk,
    BodyPartGroup.neck => localizations.results_body_neck,
    BodyPartGroup.legs => localizations.results_body_legs,
  };
}

/// Gets the [BodyPartGroup] for a [BodyPart].
BodyPartGroup groupOf(BodyPart part) => switch (part) {
      BodyPart.head => BodyPartGroup.neck,
      BodyPart.leftHand ||
      BodyPart.leftLowerArm ||
      BodyPart.rightHand ||
      BodyPart.rightLowerArm =>
        BodyPartGroup.lowerArm,
      BodyPart.leftLeg || BodyPart.rightLeg => BodyPartGroup.legs,
      BodyPart.leftUpperArm || BodyPart.rightUpperArm => BodyPartGroup.upperArm,
      BodyPart.upperBody => BodyPartGroup.trunk,
    };
