import 'package:flutter/material.dart';

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
  blue;
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
  const BodyScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    _PartColor getColorForPart(_BodyPart part) {
      return _PartColor.blue;
    }

    return Stack(
      children: _bodyPartsInDisplayOrder.map((part) {
        final color = getColorForPart(part);
        return _getBodyPartImage(part, color);
      }).toList(),
    );
  }
}
