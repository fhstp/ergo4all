import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/hook_ext.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TermsOfUseScreen extends HookWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final (hasAccepted, setHasAccepted) = useState(false).split();

    void navigateToPreUserCreation() {
      Navigator.of(context).pushReplacementNamed(Routes.preUserCreator.path);
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
                    onChanged: (value) => setHasAccepted(value!))
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
