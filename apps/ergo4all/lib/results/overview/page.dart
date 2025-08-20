import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/overview/body_score_display.dart';
import 'package:ergo4all/results/overview/ergo_score_badge.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

/// Page on for viewing an overview of results. Displays the colored puppet
/// and overall rating.
class OverviewPage extends StatelessWidget {
  ///
  const OverviewPage({
    required this.rating,
    required this.scores,
    this.onBodyPartGroupTapped,
    this.onDetailsTapped,
    this.onRecordAgainTapped,
    super.key,
  });

  /// The overall rating to display.
  final Rating rating;

  /// Rula scores to display using the puppet.
  final RulaScores scores;

  /// Callback for when a [BodyPartGroup] was tapped on the puppet.
  final void Function(BodyPartGroup group)? onBodyPartGroupTapped;

  /// Callback for when the details button was tapped.
  final void Function()? onDetailsTapped;

  /// Callback for when the record-again button was tapped.
  final void Function()? onRecordAgainTapped;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(height: 80, child: ErgoScoreBadge(rating: rating)),
        BodyScoreDisplay(
          scores,
          onBodyPartTapped: (part) {
            onBodyPartGroupTapped?.call(BodyPartGroup.forPart(part));
          },
        ),
        Text(
          localizations.results_press_body_part,
          style: staticBodyStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: mediumSpace),
        ElevatedButton(
          onPressed: onDetailsTapped,
          style: primaryTextButtonStyle,
          // TODO: Localize
          child: const Text('Details'),
        ),
        const SizedBox(height: smallSpace),
        ElevatedButton(
          onPressed: onRecordAgainTapped,
          style: secondaryTextButtonStyle,
          child: Text(localizations.record_again, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
