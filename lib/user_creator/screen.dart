import 'package:common/user.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/user_creator/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:text_storage/types.dart';
import 'package:user_storage/user_storage.dart';

class UserCreatorScreen extends StatefulWidget {
  final LocalTextStorage textStorage;

  const UserCreatorScreen(this.textStorage, {super.key});

  @override
  State<UserCreatorScreen> createState() => _UserCreatorScreenState();
}

class _UserCreatorScreenState extends State<UserCreatorScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void onUserSubmitted(User user) async {
      // Add user and navigate home afterwards
      await addUser(widget.textStorage, user);
      navigator.pushNamedAndRemoveUntil(Routes.home.path, (_) => false);
    }

    return Scaffold(
      appBar: makeCustomAppBar(
        title: localizations.userCreator_title,
      ),
      body: ScreenContent(
        child: Column(
          children: [
            Header(
              localizations.userCreator_header,
            ),
            Text(localizations.userCreator_intro),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: UserCreationForm(onUserSubmitted: onUserSubmitted))),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
