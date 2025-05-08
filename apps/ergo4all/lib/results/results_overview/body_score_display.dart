import 'package:flutter/material.dart';

/// Displays the aggregate score of a user using a puppet.
class BodyScoreDisplay extends StatelessWidget {
  ///
  const BodyScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/puppet/head_blue.png'),
        Image.asset('assets/images/puppet/left_leg_blue.png'),
        Image.asset('assets/images/puppet/left_upper_arm_blue.png'),
        Image.asset('assets/images/puppet/left_lower_arm_blue.png'),
        Image.asset('assets/images/puppet/left_hand_blue.png'),
        Image.asset('assets/images/puppet/upper_body_blue.png'),
        Image.asset('assets/images/puppet/right_leg_blue.png'),
        Image.asset('assets/images/puppet/right_upper_arm_blue.png'),
        Image.asset('assets/images/puppet/right_lower_arm_blue.png'),
        Image.asset('assets/images/puppet/right_hand_blue.png'),
      ],
    );
  }
}
