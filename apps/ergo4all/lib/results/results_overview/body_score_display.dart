import 'package:ergo4all/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

enum _BodyPart {
  head('head'),
  leftHand('left_hand'),
  leftLeg('left_leg'),
  leftLowerArm('left_lower_arm'),
  leftUpperArm('left_upper_arm'),
  rightHand('right_hand'),
  rightLeg('right_leg'),
  rightLowerArm('right_lower_arm'),
  rightUpperArm('right_upper_arm'),
  upperBody('upper_body'),
  ;

  const _BodyPart(this.fileName);

  final String fileName;
}

enum _PartColor {
  blue,
  red,
  yellow;
}

Widget _getBodyPartImage(_BodyPart bodyPart, _PartColor color) {
  return Image.asset(
      'assets/images/puppet/${bodyPart.fileName}_${color.name}.png');
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
  const BodyScoreDisplay(this.sheet, {super.key});

  /// The sheet to display.
  final RulaSheet sheet;

  @override
  Widget build(BuildContext context) {
    double getNormalizedScoreForPart(_BodyPart part) {
      /* TODO: Currently we display the same score for left and right body part
       * We should probably calc the score for each body part separately
       * for presentation.
       */
      return switch (part) {
        _BodyPart.head => normalizeScore(calcNeckScore(sheet), 6),
        _BodyPart.leftHand ||
        _BodyPart.rightHand =>
          normalizeScore(calcWristScore(sheet), 4),
        _BodyPart.leftLeg ||
        _BodyPart.rightLeg =>
          normalizeScore(calcLegScore(sheet), 2),
        _BodyPart.rightUpperArm ||
        _BodyPart.leftUpperArm =>
          normalizeScore(calcUpperArmScore(sheet), 6),
        _BodyPart.leftLowerArm ||
        _BodyPart.rightLowerArm =>
          normalizeScore(calcLowerArmScore(sheet), 3),
        _BodyPart.upperBody => normalizeScore(calcTrukScore(sheet), 6),
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
