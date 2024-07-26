import 'package:ergo4all/widgets/screen_content.dart';
import 'package:ergo4all/widgets/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserCreatorScreen extends StatefulWidget {
  const UserCreatorScreen({super.key});

  @override
  State<UserCreatorScreen> createState() => _UserCreatorScreenState();
}

class _UserCreatorScreenState extends State<UserCreatorScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.userCreator_title),
      ),
      body: ScreenContent(
        child: Column(
          children: [
            Text(
              localizations.userCreator_header,
              style: appTheme.textTheme.headlineLarge,
            ),
            Text(localizations.userCreator_intro),
            const SizedBox(
              height: 20,
            ),
            const Expanded(
                child: SingleChildScrollView(child: UserCreationForm())),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
