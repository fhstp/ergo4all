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

enum _PartColor {
  blue,
  red,
  yellow;
}

String _getAssetPathForPart(BodyPart bodyPart, _PartColor color) {
  final fileName = _fileNameForPart(bodyPart);
  return 'assets/images/puppet/${fileName}_${color.name}.png';
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
        BodyPart.leftHand => normalizeScore(scores.wristScores.$1, 4),
        BodyPart.rightHand => normalizeScore(scores.wristScores.$2, 4),
        BodyPart.leftLeg ||
        BodyPart.rightLeg =>
          normalizeScore(scores.legScore, 2),
        BodyPart.leftUpperArm => normalizeScore(scores.upperArmScores.$1, 6),
        BodyPart.rightUpperArm => normalizeScore(scores.upperArmScores.$2, 6),
        BodyPart.leftLowerArm => normalizeScore(scores.lowerArmScores.$1, 3),
        BodyPart.rightLowerArm => normalizeScore(scores.lowerArmScores.$2, 3),
        BodyPart.upperBody => normalizeScore(scores.trunkScore, 6),
      };
    }

    _PartColor getColorForPart(BodyPart part) {
      final score = getNormalizedScoreForPart(part);
      return switch (score) {
        < 0.3 => _PartColor.blue,
        < 0.6 => _PartColor.yellow,
        _ => _PartColor.red
      };
    }

    final bodyPartsCallbacks = _bodyPartsInDisplayOrder.map((part) {
      return () => onBodyPartTapped?.call(part);
    }).toList();

    final bodyPartsImagePaths = _bodyPartsInDisplayOrder.map((part) {
      final color = getColorForPart(part);
      return _getAssetPathForPart(part, color);
    }).toList();

    return TransparentImageStack(
      imagePaths: bodyPartsImagePaths,
      onTaps: bodyPartsCallbacks,
    );
  }
}
