import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/tips/domain.dart';
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

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            summary,
            style: h1Style.copyWith(color: cardinal),
            textAlign: TextAlign.center,
          ),
          Text(
            description,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
