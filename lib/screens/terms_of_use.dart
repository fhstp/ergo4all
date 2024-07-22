import 'package:ergo4all/screens/pre_user_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  bool hasAccepted = false;

  void toggleHasAccepted() {
    setState(() {
      hasAccepted = !hasAccepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void navigateToPreUserCreation() {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const PreUserCreatorScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.termsOfUse_title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localizations.termsOfUse_content),
            Row(
              children: [
                Text(localizations.termsOfUse_accept),
                Checkbox(
                    key: const Key("accept-check"),
                    value: hasAccepted,
                    onChanged: (isChecked) {
                      toggleHasAccepted();
                      if (isChecked!) navigateToPreUserCreation();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
