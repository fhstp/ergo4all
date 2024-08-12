import 'package:ergo4all/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserCreationForm extends StatefulWidget {
  const UserCreationForm({super.key});

  @override
  State<UserCreationForm> createState() => _UserCreationFormState();
}

class _UserCreationFormState extends State<UserCreationForm> {
  final _formKey = GlobalKey<FormState>();
  static final _ageBrackets = ["20 - 30", "30 - 40", "50 - 50", "> 50"];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void navigateHome() {
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    }

    String? isNotEmpty(String? value, String label) {
      if (value == null || value.isEmpty) {
        return localizations.userCreator_error_empty(label);
      }
      return null;
    }

    String? isValidNickName(String? value) {
      return isNotEmpty(value, localizations.userCreator_nickname_header);
    }

    String? isValidSex(String? value) {
      return isNotEmpty(value, localizations.userCreator_sex_header);
    }

    void tryCreateUser() {
      var formIsValid = _formKey.currentState!.validate();
      if (!formIsValid) return;

      // TODO: Create user

      navigateHome();
    }

    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: const Key("nickNameInput"),
              decoration: InputDecoration(
                  label: Text(localizations.userCreator_nickname_header),
                  hintText: localizations.userCreator_nickname_placeholder),
              validator: isValidNickName,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              key: const Key("sexInput"),
              decoration: InputDecoration(
                  label: Text(localizations.userCreator_sex_header),
                  hintText: localizations.userCreator_sex_placeholder),
              validator: isValidSex,
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
                value: _ageBrackets.first,
                decoration: InputDecoration(
                    label: Text(localizations.userCreator_ageRange_header),
                    hintText: localizations.userCreator_ageRange_placeholder),
                items: _ageBrackets
                    .map((it) => DropdownMenuItem(value: it, child: Text(it)))
                    .toList(),
                onChanged: (_) {}),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                key: const Key("create"),
                onPressed: tryCreateUser,
                child: Text(localizations.userCreator_create))
          ],
        ));
  }
}
