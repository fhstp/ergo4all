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
      Tip.handAndArm => 'hand',
      Tip.liftAndCarry => 'lifting',
      Tip.workingOverhead => 'overhead_work',
      Tip.pushAndPull => 'pushing',
      Tip.sitting => 'sitting',
      Tip.bodyPosture => 'standing',
    };

    final graphicKey = 'assets/images/puppets_good_bad/good_bad_$imagePath.svg';

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
            minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
            child: Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: largeSpace),
                    Text(
                      description,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: SvgPicture.asset(
                        graphicKey,
                        height: 300,
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
