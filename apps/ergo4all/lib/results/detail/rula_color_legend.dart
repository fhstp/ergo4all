import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/rula_colors.dart';
import 'package:flutter/material.dart';

/// Displays a horizontal legend of the Rula colors so users can learn
/// what they mean.
class RulaColorLegend extends StatelessWidget {
  ///
  const RulaColorLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [
                RulaColors.low,
                RulaColors.lowMid,
                RulaColors.mid,
                RulaColors.midHigh,
                RulaColors.high,
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.results_score_low,
              style: infoText,
            ),
            Text(
              localizations.results_score_high,
              style: infoText,
            ),
          ],
        ),
      ],
    );
  }
}
