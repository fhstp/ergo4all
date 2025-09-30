import 'package:common/pair_utils.dart';
import 'package:ergo4all/common/rula_color.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/overview/transparent_image_stack.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

String _fileNameForPart(BodyPart part) {
  return switch (part) {
    BodyPart.head => 'head',
    BodyPart.leftHand => 'left_hand',
    BodyPart.leftLeg => 'left_leg',
    BodyPart.leftLowerArm => 'left_lower_arm',
    BodyPart.leftUpperArm => 'left_upper_arm',
    BodyPart.rightHand => 'right_hand',
    BodyPart.rightLeg => 'right_leg',
    BodyPart.rightLowerArm => 'right_lower_arm',
    BodyPart.rightUpperArm => 'right_upper_arm',
    BodyPart.upperBody => 'upper_body'
  };
}

String _getAssetPathForPart(BodyPart bodyPart) {
  final fileName = _fileNameForPart(bodyPart);
  return 'assets/images/puppet/$fileName.png';
}

const bodyPartsInDisplayOrder = [
  BodyPart.head,
  BodyPart.leftLeg,
  BodyPart.leftUpperArm,
  BodyPart.leftLowerArm,
  BodyPart.leftHand,
  BodyPart.upperBody,
  BodyPart.rightLeg,
  BodyPart.rightUpperArm,
  BodyPart.rightLowerArm,
  BodyPart.rightHand,
];

double getNormalizedScoreForPart(BodyPart part, RulaScores scores) {
  return switch (part) {
    BodyPart.head => normalizeScore(scores.neckScore, 6),
    BodyPart.leftHand ||
    BodyPart.leftLowerArm =>
      normalizeScore(Pair.left(scores.lowerArmScores), 3),
    BodyPart.rightHand ||
    BodyPart.rightLowerArm =>
      normalizeScore(Pair.right(scores.lowerArmScores), 3),
    BodyPart.leftLeg => normalizeScore(Pair.left(scores.legScores), 2),
    BodyPart.rightLeg => normalizeScore(Pair.right(scores.legScores), 2),
    BodyPart.leftUpperArm =>
      normalizeScore(Pair.left(scores.upperArmScores), 6),
    BodyPart.rightUpperArm =>
      normalizeScore(Pair.right(scores.upperArmScores), 6),
    BodyPart.upperBody => normalizeScore(scores.trunkScore, 6),
  };
}

/// Displays the aggregate score of a user using a puppet.
class BodyScoreDisplay extends StatelessWidget {
  ///
  const BodyScoreDisplay(this.scores, {super.key, this.onBodyPartTapped});

  /// The scores to display.
  final RulaScores scores;

  /// Callback for when a [BodyPart] was tapped on the display.
  final void Function(BodyPart)? onBodyPartTapped;

  @override
  Widget build(BuildContext context) {
    final bodyPartsImagePaths =
        bodyPartsInDisplayOrder.map(_getAssetPathForPart).toList();

    final colors = bodyPartsInDisplayOrder.map((part) {
      final score = getNormalizedScoreForPart(part, scores);
      return RulaColor.forScore(score);
    }).toList();

    return Center(
      child: TransparentImageStack(
        imagePaths: bodyPartsImagePaths,
        colors: colors,
        onTap: (i) => onBodyPartTapped?.call(bodyPartsInDisplayOrder[i]),
      ),
    );
  }
}
