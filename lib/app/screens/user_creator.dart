import 'package:ergo4all/app/impure_utils.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/local_text_storage.dart';
import 'package:ergo4all/ui/widgets/header.dart';
import 'package:ergo4all/ui/widgets/screen_content.dart';
import 'package:ergo4all/ui/widgets/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(
        title: Text(localizations.userCreator_title),
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
