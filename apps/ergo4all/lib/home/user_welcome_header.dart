import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:user_management/user_management.dart';

/// Displays a welcome header for a given [User].
class UserWelcomeHeader extends StatelessWidget {
  /// Creates a welcome header for the given [user].
  const UserWelcomeHeader(this.user, {super.key});

  /// The user to display a message for.
  final User user;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final welcomeText = localizations.home_welcome(user.name).length < 15
        ? localizations.home_welcome(user.name)
        : localizations.home_welcome_break(user.name);
    return Text(
      welcomeText.trim(),
      style: h3Style,
      textAlign: TextAlign.center,
    );
  }
}
