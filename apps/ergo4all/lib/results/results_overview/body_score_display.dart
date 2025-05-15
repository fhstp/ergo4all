import 'package:ergo4all/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

/// The different body parts for which we collect and display scores.
enum _BodyPart {
  ///
  head,

  ///
  leftHand,

  ///
  leftLeg,

  ///
  leftLowerArm,

  ///
  leftUpperArm,

  ///
  rightHand,

  ///
  rightLeg,

  ///
  rightLowerArm,

  ///
  rightUpperArm,

  ///
  upperBody
}

String _fileNameForPart(_BodyPart part) {
  return switch (part) {
    _BodyPart.head => 'head',
    _BodyPart.leftHand => 'left_hand',
    _BodyPart.leftLeg => 'left_leg',
    _BodyPart.leftLowerArm => 'left_lower_arm',
    _BodyPart.leftUpperArm => 'left_upper_arm',
    _BodyPart.rightHand => 'right_hand',
    _BodyPart.rightLeg => 'right_leg',
    _BodyPart.rightLowerArm => 'right_lower_arm',
    _BodyPart.rightUpperArm => 'right_upper_arm',
    _BodyPart.upperBody => 'upper_body'
  };
}

enum _PartColor {
  blue,
  red,
  yellow;
}

Widget _getBodyPartImage(_BodyPart bodyPart, _PartColor color) {
  final fileName = _fileNameForPart(bodyPart);
  return Image.asset(
    'assets/images/puppet/${fileName}_${color.name}.png',
  );
}

const _bodyPartsInDisplayOrder = [
  _BodyPart.head,
  _BodyPart.leftLeg,
  _BodyPart.leftUpperArm,
  _BodyPart.leftLowerArm,
  _BodyPart.leftHand,
  _BodyPart.upperBody,
  _BodyPart.rightLeg,
  _BodyPart.rightUpperArm,
  _BodyPart.rightLowerArm,
  _BodyPart.rightHand,
];

/// Displays the aggregate score of a user using a puppet.
class BodyScoreDisplay extends StatelessWidget {
  ///
  const BodyScoreDisplay(this.scores, {super.key});

  /// The scores to display.
  final RulaScores scores;

  @override
  Widget build(BuildContext context) {
    double getNormalizedScoreForPart(_BodyPart part) {
      // This is really unoptimized. We recalculate a whole bunch of
      // scores multiple times. Oh well.
      return switch (part) {
        _BodyPart.head => normalizeScore(scores.neckScore, 6),
        _BodyPart.leftHand => normalizeScore(scores.wristScores.$1, 4),
        _BodyPart.rightHand => normalizeScore(scores.wristScores.$2, 4),
        _BodyPart.leftLeg ||
        _BodyPart.rightLeg =>
          normalizeScore(scores.legScore, 2),
        _BodyPart.leftUpperArm => normalizeScore(scores.upperArmScores.$1, 6),
        _BodyPart.rightUpperArm => normalizeScore(scores.upperArmScores.$2, 6),
        _BodyPart.leftLowerArm => normalizeScore(scores.lowerArmScores.$1, 3),
        _BodyPart.rightLowerArm => normalizeScore(scores.lowerArmScores.$2, 3),
        _BodyPart.upperBody => normalizeScore(scores.trunkScore, 6),
      };
    }

    _PartColor getColorForPart(_BodyPart part) {
      final score = getNormalizedScoreForPart(part);
      return switch (score) {
        < 0.3 => _PartColor.blue,
        < 0.6 => _PartColor.yellow,
        _ => _PartColor.red
      };
    }

    return Stack(
      children: _bodyPartsInDisplayOrder.map((part) {
        final color = getColorForPart(part);
        return _getBodyPartImage(part, color);
      }).toList(),
    );
  }
}
