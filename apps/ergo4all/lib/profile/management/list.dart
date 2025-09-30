import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/management/common.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat.yMd();

class _ProfileEntry extends StatelessWidget {
  const _ProfileEntry(this.data, {this.onDismissed});

  final ProfileListEntry data;
  final void Function()? onDismissed;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Dismissible(
      key: Key(data.profile.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        onDismissed?.call();
      },
      confirmDismiss: (_) async {
        final isDefaultUser = data.profile.id == ProfileRepo.defaultProfile.id;

        if (isDefaultUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.profile_choice_cannot_delete_default),
            ),
          );
        }

        return !isDefaultUser;
      },
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [persimmon, spindle]),
        ),
      ),
      child: ColoredBox(
        color: spindle,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.profile.nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data.lastRecordedDate != null
                              ? _dateFormat.format(data.lastRecordedDate!)
                              : localizations.profile_no_sessions_yet,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.delete_outline, color: blueChill),
                  const SizedBox(width: 20),
                  const Icon(Icons.chevron_right, color: blueChill),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: mediumSpace),
              child: Divider(color: blueChill),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a list of [ProfileListEntry] and allows the user to dismiss
/// entries.
class ProfileList extends StatelessWidget {
  ///
  const ProfileList({
    required this.entries,
    super.key,
    this.onProfileDismissed,
  });

  /// The entries to display.
  final List<ProfileListEntry> entries;

  /// Called when an entry is dismissed.
  final void Function(Profile profile)? onProfileDismissed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: ListView.builder(
        itemCount: entries.length,
        shrinkWrap: true,
        itemExtent: 76,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _ProfileEntry(
            entry,
            onDismissed: () {
              onProfileDismissed?.call(entry.profile);
            },
          );
        },
      ),
    );
  }
}
