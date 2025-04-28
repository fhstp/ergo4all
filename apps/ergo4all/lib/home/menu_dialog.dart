import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/snack.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

Widget _makeOptionButton(String key, String text, void Function() onPressed) {
  return SimpleDialogOption(
    key: Key(key),
    onPressed: onPressed,
    child: Text(
      text,
      style: buttonLabelStyle,
      textAlign: TextAlign.center,
    ),
  );
}

/// Shows a dialog with common operations that users might want to do from
/// the home screen.
Future<void> showHomeMenuDialog(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  void goToLanguage() {
    Navigator.of(context).pushReplacementNamed(Routes.language.path);
  }

  void goToHome() {
    Navigator.of(context).pushReplacementNamed(Routes.home.path);
  }

  return showDialog<void>(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: spindle,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      children: [
        _makeOptionButton('button-home',localizations.menu_home_label, goToHome),
        _makeOptionButton('button-user',localizations.menu_user_label, () {
          Navigator.of(context).pop();
          showNotImplementedSnackbar(context);
        }),
        _makeOptionButton('button-lang',localizations.menu_language_label, goToLanguage),
        _makeOptionButton('button-imprint',localizations.menu_imprint_label, () {
          Navigator.of(context).pop();
          showNotImplementedSnackbar(context);
        }),
        _makeOptionButton('button-privacy',localizations.menu_privacy_label, () {
          Navigator.of(context).pop();
          showNotImplementedSnackbar(context);
        }),
        _makeOptionButton('button-delete',localizations.menu_delete_data_label, () {
          Navigator.of(context).pop();
          showNotImplementedSnackbar(context);
        }),
      ],
    ),
  );
}