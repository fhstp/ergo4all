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
  red;
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
      return switch (part) {
        _BodyPart.head => calcNeckScore(sheet).normalize(6),
        _BodyPart.leftHand ||
        _BodyPart.rightHand =>
          calcWristScore(sheet).normalize(4),
        _BodyPart.leftLeg ||
        _BodyPart.rightLeg =>
          calcLegScore(sheet).normalize(2),
        _BodyPart.rightUpperArm ||
        _BodyPart.leftUpperArm =>
          calcUpperArmScore(sheet).normalize(6),
        _BodyPart.leftLowerArm ||
        _BodyPart.rightLowerArm =>
          calcLowerArmScore(sheet).normalize(3),
        _BodyPart.upperBody => calcTrukScore(sheet).normalize(6),
      };
    }

    _PartColor getColorForPart(_BodyPart part) {
      final score = getNormalizedScoreForPart(part);
      return switch (score) { < 0.3 => _PartColor.blue, _ => _PartColor.red };
    }

    return Stack(
      children: _bodyPartsInDisplayOrder.map((part) {
        final color = getColorForPart(part);
        return _getBodyPartImage(part, color);
      }).toList(),
    );
  }
}
