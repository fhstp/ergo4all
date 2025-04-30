import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/routes.dart';
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
  void goToLanguage() {
    Navigator.of(context).pushReplacementNamed(Routes.language.path);
  }

  return showDialog<void>(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: spindle,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      children: [
        _makeOptionButton('button-lang', 'Change language', goToLanguage),
      ],
    ),
  );
}
