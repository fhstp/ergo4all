import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:flutter/material.dart';

/// Dropdown to select from a list of [Profile]s.
class ProfileSelector extends StatelessWidget {
  ///
  const ProfileSelector({
    required this.profiles,
    super.key,
    this.selected,
    this.onSelected,
  });

  /// The profile from which the user can select.
  final List<Profile> profiles;

  /// The currently selected profile.
  final Profile? selected;

  /// Callback for when a profile is selected.
  final void Function(Profile?)? onSelected;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DropdownMenu(
      // Having this unique key here fixes
      // https://github.com/flutter/flutter/issues/120567
      // where the dropdown would not resize after the profiles
      // were loaded and be too small.
      key: UniqueKey(),
      label: Text(localizations.profile_selection_label),
      initialSelection: selected,
      dropdownMenuEntries: profiles
          .map(
            (profile) => DropdownMenuEntry(
              value: profile,
              label: profile.nickname,
            ),
          )
          .toList(),
      onSelected: (it) {
        onSelected?.call(it);
      },
    );
  }
}
