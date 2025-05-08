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

Widget _getBodyPartImage(_BodyPart bodyPart) {
  return Image.asset('assets/images/puppet/${bodyPart.fileName}_blue.png');
}

/// Displays the aggregate score of a user using a puppet.
class BodyScoreDisplay extends StatelessWidget {
  ///
  const BodyScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getBodyPartImage(_BodyPart.head),
        _getBodyPartImage(_BodyPart.leftLeg),
        _getBodyPartImage(_BodyPart.leftUpperArm),
        _getBodyPartImage(_BodyPart.leftLowerArm),
        _getBodyPartImage(_BodyPart.leftHand),
        _getBodyPartImage(_BodyPart.upperBody),
        _getBodyPartImage(_BodyPart.rightLeg),
        _getBodyPartImage(_BodyPart.rightUpperArm),
        _getBodyPartImage(_BodyPart.rightLowerArm),
        _getBodyPartImage(_BodyPart.rightHand),
      ],
    );
  }
}
