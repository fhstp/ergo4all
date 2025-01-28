import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_management/user_management.dart';

class UserCreationForm extends HookWidget {
  static final _ageBrackets = ["20 - 30", "30 - 40", "50 - 50", "> 50"];

  final void Function(User user) onUserSubmitted;

  const UserCreationForm({super.key, required this.onUserSubmitted});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nickNameController = useTextEditingController();

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

    void tryCreateUser() async {
      var formIsValid = formKey.currentState!.validate();
      if (!formIsValid) return;

      var user = makeUserFromName(nickNameController.text);
      onUserSubmitted(user);
    }

    return Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              key: const Key("nickNameInput"),
              controller: nickNameController,
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
                ),
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
