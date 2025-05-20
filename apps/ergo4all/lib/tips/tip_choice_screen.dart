import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/tips/domain.dart';
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
      body: Column(
        children: [
          RedCircleTopBar(
            titleText: localizations.choice_title,
            withBackButton: true,
          ),
          const SizedBox(
            height: largeSpace,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: Tip.values.length,
              itemBuilder: (ctx, i) {
                final tip = Tip.values[i];
                return FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    key: Key('tip_button_${tip.name}'),
                    style: paleTextButtonStyle,
                    onPressed: () {
                      goToDetailScreen(tip);
                    },
                    child: Text(titleFor(tip)),
                  ),
                );
              },
              separatorBuilder: (ctx, i) => const SizedBox(
                height: largeSpace,
              ),
            ),
          ),
          const SizedBox(
            height: largeSpace,
          ),
        ],
      ),
    );
  }
}
