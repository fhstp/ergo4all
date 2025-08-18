import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/imprint_screen.dart';
import 'package:ergo4all/language_screen.dart';
import 'package:flutter/material.dart';

Widget _makeOptionButton(String text, void Function() onPressed, [Key? key]) {
  return SimpleDialogOption(
    key: key,
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
    Navigator.of(context).pushReplacement(PickLanguageScreen.makeRoute());
  }

  void goToPrivacy() {
    final navigator = Navigator.of(context)..pop();
    unawaited(navigator.pushNamed(Routes.privacy.path));
  }

  return showDialog<void>(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: spindle,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      children: [
        _makeOptionButton(
          localizations.menu_language_label,
          goToLanguage,
          const Key('button-lang'),
        ),
        _makeOptionButton(localizations.imprint, () {
          final navigator = Navigator.of(context)..pop();
          unawaited(navigator.push(ImprintScreen.makeRoute()));
        }),
        _makeOptionButton(localizations.menu_privacy_label, goToPrivacy),
      ],
    ),
  );
}
