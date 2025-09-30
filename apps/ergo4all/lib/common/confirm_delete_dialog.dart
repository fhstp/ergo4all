import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Dialog for confirming whether to delete some generic item.
/// The dialog returns a [bool] result to indicate whether to delete.
/// ```dart
/// final shouldDelete = await showDialog<bool>(
///   context: context,
///   builder: (context) => ConfirmDeleteDialog(),
/// );
/// ```
class ConfirmDeleteDialog extends StatelessWidget {
  ///
  const ConfirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    return SimpleDialog(
      title: Text(
        localizations.ask_delete,
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.all(mediumSpace),
      children: [
        ElevatedButton(
          onPressed: () {
            navigator.pop(true);
          },
          style: primaryTextButtonStyle,
          child: Text(localizations.yes),
        ),
        const SizedBox(height: mediumSpace),
        ElevatedButton(
          onPressed: () {
            navigator.pop(false);
          },
          style: secondaryTextButtonStyle,
          child: Text(localizations.no),
        ),
      ],
    );
  }
}
