import 'package:common_ui/theme/spacing.dart';
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
    Future<void> submitProfile(NewProfile profile) async {
      final profileRepo = Provider.of<ProfileRepo>(context, listen: false);

      await profileRepo.createNew(profile.nickName);

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    return SimpleDialog(
      // TODO: Localize
      title: const Text('New profile'),
      contentPadding: const EdgeInsets.all(largeSpace),
      children: [
        NewProfileForm(onSubmit: submitProfile),
      ],
    );
  }
}
