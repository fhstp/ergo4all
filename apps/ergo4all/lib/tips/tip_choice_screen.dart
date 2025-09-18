import 'dart:async';

import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/tips/common.dart';
import 'package:ergo4all/tips/tip_detail_screen.dart';
import 'package:flutter/material.dart';

/// Screen which lists all the tips and allows further navigation to their
/// detail pages.
class TipChoiceScreen extends StatelessWidget {
  /// Creates a [TipChoiceScreen].
  const TipChoiceScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'tip-choice';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const TipChoiceScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

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

    void goToDetailScreen(Tip tip) {
      unawaited(
        Navigator.of(context).push(TipDetailScreen.makeRoute(tip)),
      );
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
              const SizedBox(height: largeSpace),
            ],
          ),
        ),
      ),
    );
  }
}
