import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shows a tutorial in a [Dialog] which explains to the user how to
/// record videos. The returned [Future] completes when the dialog is closed.
Future<void> showTutorialDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final localizations = AppLocalizations.of(context)!;

      void closeDialog() {
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
                  localizations.tutorial_dialog_page_1,
                  textAlign: TextAlign.center,
                  style: staticBodyStyle.copyWith(color: white),
                ),
                const SizedBox(height: largeSpace),
                ElevatedButton(
                  onPressed: closeDialog,
                  style: primaryTextButtonStyle,
                  child: Text(localizations.common_next),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
