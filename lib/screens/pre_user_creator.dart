import 'package:ergo4all/screens/home.dart';
import 'package:ergo4all/screens/user_creator.dart';
import 'package:ergo4all/spacing.dart';
import 'package:ergo4all/widgets/header.dart';
import 'package:ergo4all/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreUserCreatorScreen extends StatelessWidget {
  const PreUserCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void navigateToUserCreator() {
      navigator
          .push(MaterialPageRoute(builder: (_) => const UserCreatorScreen()));
    }

    void navigateToHome() {
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.preUserCreator_title),
        centerTitle: true,
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
              onPressed: navigateToHome,
              child: Text(localizations.preUserCreator_useDefaults),
            )
          ],
        ),
      ),
    );
  }
}
