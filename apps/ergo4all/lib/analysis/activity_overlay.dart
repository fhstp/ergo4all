import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/analysis/har/activity.dart';
import 'package:ergo4all/analysis/har/variable_localizations.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Displays information about an [Activity] in the top-left of it's parent.
class ActivityOverlay extends StatelessWidget {
  ///
  const ActivityOverlay(
    this.activity, {
    super.key,
  });

  /// The activity to display.
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final activityName = localizations.activityDisplayName(activity);
    final message = '${localizations.har_activity}: $activityName';

    return Positioned(
      top: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: blackPearl.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message,
            style: infoText.copyWith(color: white),
          ),
        ),
      ),
    );
  }
}
