import 'package:common/user.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:text_storage/types.dart';
import 'package:user_storage/user_storage.dart';

class PreUserCreatorScreen extends StatelessWidget {
  final LocalTextStorage textStorage;

  const PreUserCreatorScreen(this.textStorage, {super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void navigateToUserCreator() {
      navigator.pushNamed(Routes.userCreator.path);
    }

    void proceedWithDefaultUser() async {
      // This is the default user.
      await addUser(textStorage, const User.newFromName("Ergo-fan"));

      navigator.pushNamedAndRemoveUntil(Routes.home.path, (_) => false);
    }

    return Scaffold(
      appBar: makeCustomAppBar(
        title: localizations.preUserCreator_title,
      ),
      body: ScreenContent(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(localizations.preUserCreator_header),
            Text(
              localizations.preUserCreator_text1,
            ),
            const SizedBox(
              height: smallSpace,
            ),
            Text(
              localizations.preUserCreator_text2,
              style: appTheme.textTheme.bodySmall,
            ),
            const SizedBox(
              height: mediumSpace,
            ),
            ElevatedButton(
                key: const Key("create"),
                onPressed: navigateToUserCreator,
                child: Text(localizations.preUserCreator_create)),
            const SizedBox(
              height: mediumSpace,
            ),
            TextButton(
              key: const Key("default-values"),
              onPressed: proceedWithDefaultUser,
              child: Text(localizations.preUserCreator_useDefaults),
            ),
            Text(localizations.preUserCreator_defaultsExplanation)
          ],
        ),
      ),
    );
  }
}
