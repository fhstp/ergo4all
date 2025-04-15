import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/onboarding/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_management/user_management.dart';

class UserCreatorScreen extends HookWidget {
  const UserCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    Future<void> onUserSubmitted(User user) async {
      // Add user and navigate home afterwards
      await addUser(user);
      await navigator.pushNamedAndRemoveUntil(Routes.home.path, (_) => false);
    }

    return Scaffold(
      appBar: makeCustomAppBar(
        title: localizations.userCreator_title,
      ),
      body: ScreenContent(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                localizations.userCreator_header,
                style: h3Style,
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
