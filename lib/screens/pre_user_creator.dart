import 'package:ergo4all/screens/home.dart';
import 'package:ergo4all/widgets/header.dart';
import 'package:ergo4all/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreUserCreatorScreen extends StatelessWidget {
  const PreUserCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void navigateToHome() {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
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
            Text(localizations.preUserCreator_explanation),
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
