import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:common_ui/widgets/red_circle_bottom_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/tips/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TipDetailScreen extends StatelessWidget {
  const TipDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final tip = ModalRoute.of(context)!.settings.arguments! as Tip;

    final summary = switch (tip) {
      Tip.bodyPosture => localizations.tip_body_posture_label,
      Tip.sitting => localizations.tip_sitting_label,
      Tip.liftAndCarry => localizations.tip_lift_and_carry_label,
      Tip.pushAndPull => localizations.tip_pushAndPull_label,
      Tip.workingOverhead => localizations.tip_workingOverhead_label,
      Tip.handAndArm => localizations.tip_handAndArm_label,
    };

    final description = switch (tip) {
      Tip.liftAndCarry => localizations.tip_lift_and_carry_summary,
      Tip.bodyPosture => localizations.tip_body_posture_summary,
      Tip.sitting => localizations.tip_sitting_summary,
      Tip.pushAndPull => localizations.tip_pushAndPull_summary,
      Tip.workingOverhead => localizations.tip_workingOverhead_summary,
      Tip.handAndArm => localizations.tip_handAndArm_summary,
    };

    final imagePath = switch (tip) {
      Tip.handAndArm => 'assets/images/puppets_good_bad/good_bad_hand.svg',
      Tip.liftAndCarry => 'assets/images/puppets_good_bad/good_bad_lifting.svg',
      Tip.workingOverhead =>
        'assets/images/puppets_good_bad/good_bad_overhead_work.svg',
      Tip.pushAndPull => 'assets/images/puppets_good_bad/good_bad_pushing.svg',
      Tip.sitting => 'assets/images/puppets_good_bad/good_bad_sitting.svg',
      Tip.bodyPosture => 'assets/images/puppets_good_bad/good_bad_standing.svg',
    };

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          summary,
          style: h4Style.copyWith(color: cardinal),
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: RedCircleBottomBar(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: largeSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    description,
                    style: dynamicBodyStyle,
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: SvgPicture.asset(
                      imagePath,
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
