import 'package:ergo4all/app/common/app_bar.dart';
import 'package:ergo4all/app/common/routes.dart';
import 'package:ergo4all/app/common/screen_content.dart';
import 'package:ergo4all/app/common/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  bool hasAccepted = false;

  void setHasAccepted(bool? value) {
    setState(() {
      hasAccepted = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void navigateToPreUserCreation() {
      navigator.pushReplacementNamed(Routes.preUserCreator.path);
    }

    return Scaffold(
      appBar: makeCustomAppBar(
        title: localizations.termsOfUse_title,
      ),
      body: ScreenContent(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localizations.termsOfUse_content),
            const SizedBox(
              height: largeSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(localizations.termsOfUse_accept),
                Checkbox(
                    key: const Key("accept-check"),
                    value: hasAccepted,
                    onChanged: setHasAccepted)
              ],
            ),
            const SizedBox(
              height: mediumSpace,
            ),
            ElevatedButton(
                key: const Key("next"),
                onPressed: hasAccepted ? navigateToPreUserCreation : null,
                child: Text(localizations.common_next))
          ],
        ),
      ),
    );
  }
}
