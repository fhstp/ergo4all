import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:flutter/material.dart';

/// Contains data that was entered in a [NewProfileForm] and can be used
/// to create a new [Profile].
@immutable
class NewProfile {
  ///
  const NewProfile({required this.nickName});

  /// The nickname for the new profile.
  final String nickName;
}

/// A form for entering the information needed for new [Profile]s.
class NewProfileForm extends StatefulWidget {
  ///
  const NewProfileForm({super.key, this.onSubmit});

  /// Callback for when a [NewProfile] is submitted from this form.
  final void Function(NewProfile)? onSubmit;

  @override
  State<NewProfileForm> createState() => _NewProfileFormState();
}

class _NewProfileFormState extends State<NewProfileForm> {
  final formKey = GlobalKey<FormState>();
  final nickName = TextEditingController();

  FormState get formState => formKey.currentState!;

  void submit() {
    if (!formState.validate()) return;
    widget.onSubmit?.call(NewProfile(nickName: nickName.text));
  }

  @override
  void dispose() {
    super.dispose();
    nickName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nickName,
            validator: (value) {
              if (value == null) {
                return localizations.profile_creation_error_nickname_required;
              }

              if (value.length < 3) {
                return localizations.profile_creation_error_nickname_length;
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: localizations.profile_creation_nickname_hint,
              filled: true,
              fillColor: spindle,
              errorMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(largeSpace),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: smallSpace,
                horizontal: mediumSpace,
              ),
            ),
          ),
          const SizedBox(height: largeSpace),
          ElevatedButton(
            onPressed: submit,
            style: primaryTextButtonStyle,
            child: Text(localizations.profile_creation_submit_label),
          ),
        ],
      ),
    );
  }
}
