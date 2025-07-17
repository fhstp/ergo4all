import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class _TutorialDialog extends StatefulWidget {
  const _TutorialDialog();

  @override
  State<_TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<_TutorialDialog> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void onNextPressed() {
      if (pageIndex < 2) {
        setState(() {
          pageIndex++;
        });
      } else {
        Navigator.of(context).pop();
      }
    }

    final text = switch (pageIndex) {
      0 => localizations.tutorial_dialog_page_1,
      1 => localizations.tutorial_dialog_page_2,
      _ => localizations.tutorial_dialog_page_3
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

/// Shows a tutorial in a [Dialog] which explains to the user how to
/// record videos. The returned [Future] completes when the dialog is closed.
Future<void> showTutorialDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const _TutorialDialog(),
  );
}
