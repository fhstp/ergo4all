import 'package:ergo4all/app/impure_utils.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/local_text_storage.dart';
import 'package:ergo4all/ui/app_bar.dart';
import 'package:ergo4all/ui/header.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    void proceedeWithDefaultUser() async {
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
              onPressed: proceedeWithDefaultUser,
              child: Text(localizations.preUserCreator_useDefaults),
            )
          ],
        ),
      ),
    );
  }
}
