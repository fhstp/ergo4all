import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/tips/common.dart';
import 'package:flutter/material.dart';

/// Screen which lists all the tips and allows further navigation to their
/// detail pages.
class TipChoiceScreen extends StatelessWidget {
  /// Creates a [TipChoiceScreen].
  const TipChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    String titleFor(Tip tip) => switch (tip) {
          Tip.bodyPosture => localizations.tip_body_posture_label,
          Tip.sitting => localizations.tip_sitting_label,
          Tip.liftAndCarry => localizations.tip_lift_and_carry_label,
          Tip.pushAndPull => localizations.tip_pushAndPull_label,
          Tip.workingOverhead => localizations.tip_workingOverhead_label,
          Tip.handAndArm => localizations.tip_handAndArm_label,
        };

    Future<void> goToDetailScreen(Tip tip) async {
      await Navigator.of(context)
          .pushNamed(Routes.tipDetail.path, arguments: tip);
    }

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.choice_title,
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Column(
            children: [
              const SizedBox(height: largeSpace),
              Expanded(
                child: SizedBox(
                  width: 275,
                  child: ListView.separated(
                    itemCount: Tip.values.length,
                    itemBuilder: (ctx, i) {
                      final tip = Tip.values[i];
                      return ElevatedButton(
                        key: Key('tip_button_${tip.name}'),
                        style: paleTextButtonStyle,
                        onPressed: () {
                          goToDetailScreen(tip);
                        },
                        child: Text(
                          titleFor(tip),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    separatorBuilder: (ctx, i) =>
                        const SizedBox(height: largeSpace),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
