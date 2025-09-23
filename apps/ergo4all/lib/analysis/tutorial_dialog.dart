import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Dialog which explains how to record sessions to users.
class TutorialDialog extends StatelessWidget {
  ///
  const TutorialDialog({required this.maxRecordDuration, super.key});

  /// How long the user can record for.
  final Duration maxRecordDuration;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void close() {
      Navigator.of(context).pop();
    }

    return Dialog(
      backgroundColor: tarawera.withAlpha(230),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(mediumSpace),
          child: Column(
            children: [
              Text(
                localizations.record_tutorial(maxRecordDuration.inSeconds),
                textAlign: TextAlign.center,
                style: staticBodyStyle.copyWith(color: white),
              ),
              const SizedBox(height: largeSpace),
              ElevatedButton(
                onPressed: close,
                style: primaryTextButtonStyle,
                child: Text(localizations.common_next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
