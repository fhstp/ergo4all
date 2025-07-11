import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/overview/transparent_image_stack.dart';
import 'package:ergo4all/results/rula_colors.dart';
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

const _bodyPartsInDisplayOrder = [
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
    double getNormalizedScoreForPart(BodyPart part) {
      return switch (part) {
        BodyPart.head => normalizeScore(scores.neckScore, 6),
        BodyPart.leftHand ||
        BodyPart.leftLowerArm =>
          normalizeScore(scores.lowerArmScores.$1, 3),
        BodyPart.rightHand ||
        BodyPart.rightLowerArm =>
          normalizeScore(scores.lowerArmScores.$2, 3),
        BodyPart.leftLeg ||
        BodyPart.rightLeg =>
          normalizeScore(scores.legScore, 2),
        BodyPart.leftUpperArm => normalizeScore(scores.upperArmScores.$1, 6),
        BodyPart.rightUpperArm => normalizeScore(scores.upperArmScores.$2, 6),
        BodyPart.upperBody => normalizeScore(scores.trunkScore, 6),
      };
    }

    final bodyPartsImagePaths =
        _bodyPartsInDisplayOrder.map(_getAssetPathForPart).toList();

    final colors = _bodyPartsInDisplayOrder.map((part) {
      final score = getNormalizedScoreForPart(part);
      return rulaColorFor(score);
    }).toList();

    return TransparentImageStack(
      imagePaths: bodyPartsImagePaths,
      colors: colors,
      onTap: (i) => onBodyPartTapped?.call(_bodyPartsInDisplayOrder[i]),
    );
  }
}
