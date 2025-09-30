import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/imprint_screen.dart';
import 'package:ergo4all/language_screen.dart';
import 'package:ergo4all/privacy_screen.dart';
import 'package:ergo4all/profile/management/screen.dart';
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
  final navigator = Navigator.of(context);

  void goToLanguage() {
    unawaited(
      navigator.pushReplacement(
        PickLanguageScreen.makeRoute(PostLanguagePickAction.goHome),
      ),
    );
  }

  void goToPrivacy() {
    unawaited(navigator.pushReplacement(PrivacyScreen.makeRoute()));
  }

  void goToProfileManagement() {
    unawaited(navigator.pushReplacement(ProfileManagementScreen.makeRoute()));
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
        _makeOptionButton(
          localizations.menu_profiles_label,
          goToProfileManagement,
        ),
      ],
    ),
  );
}
