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
class OverviewPage extends StatefulWidget {
  ///
  const OverviewPage({
    required this.rating,
    required this.scores,
    this.onBodyPartGroupTapped,
    super.key,
  });

  /// The overall rating to display.
  final Rating rating;

  /// Rula scores to display using the puppet.
  final RulaScores scores;

  /// Callback for when a [BodyPartGroup] was tapped on the puppet.
  final void Function(BodyPartGroup group)? onBodyPartGroupTapped;

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(height: 80, child: ErgoScoreBadge(rating: widget.rating)),
        BodyScoreDisplay(
          widget.scores,
          onBodyPartTapped: (part) {
            widget.onBodyPartGroupTapped?.call(BodyPartGroup.forPart(part));
          },
        ),
        Text(
          localizations.results_press_body_part,
          style: staticBodyStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
