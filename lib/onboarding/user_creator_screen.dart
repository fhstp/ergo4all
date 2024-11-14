import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/onboarding/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_management/user_management.dart';

class UserCreatorScreen extends HookWidget {
  final UserStorage userStorage;

  const UserCreatorScreen({super.key, required this.userStorage});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void onUserSubmitted(User user) async {
      // Add user and navigate home afterwards
      await userStorage.addUser(user);
      navigator.pushNamedAndRemoveUntil(Routes.home.path, (_) => false);
    }

    return Scaffold(
      appBar: makeCustomAppBar(
        title: localizations.userCreator_title,
      ),
      body: ScreenContent(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                localizations.userCreator_header,
              ),
              Text(localizations.userCreator_intro),
              const SizedBox(
                height: 20,
              ),
              UserCreationForm(onUserSubmitted: onUserSubmitted),
            ],
          ),
        ),
      ),
    );
  }
}
