import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Dialog which explains how to record sessions to users.
class TutorialDialog extends StatefulWidget {
  ///
  const TutorialDialog({super.key});

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void onNextPressed() {
      if (pageIndex < 1) {
        setState(() {
          pageIndex++;
        });
      } else {
        Navigator.of(context).pop();
      }
    }

    final text = switch (pageIndex) {
      0 => localizations.tutorial_dialog_page_1,
      _ => localizations.tutorial_dialog_page_2,
    };

    return Dialog(
      backgroundColor: tarawera.withAlpha(230),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(mediumSpace),
          child: Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: staticBodyStyle.copyWith(color: white),
              ),
              const SizedBox(height: largeSpace),
              ElevatedButton(
                onPressed: onNextPressed,
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
