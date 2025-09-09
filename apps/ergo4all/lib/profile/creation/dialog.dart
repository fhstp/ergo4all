import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/creation/form.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// [Dialog] where users can add new [Profile]s.
class ProfileCreationDialog extends StatelessWidget {
  ///
  const ProfileCreationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    Future<void> submitProfile(NewProfile profile) async {
      final profileRepo = Provider.of<ProfileRepo>(context, listen: false);

      await profileRepo.createNew(profile.nickName);

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    return SimpleDialog(
      title: Text(
        localizations.profile_creation_title,
        textAlign: TextAlign.center,
      ),
      titleTextStyle: h3Style.copyWith(color: white),
      backgroundColor: tarawera,
      contentPadding: const EdgeInsets.all(largeSpace),
      children: [
        Text(
          localizations.profile_creation_nickname_label,
          style: staticBodyStyle.copyWith(color: white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: mediumSpace),
        NewProfileForm(onSubmit: submitProfile),
      ],
    );
  }
}
