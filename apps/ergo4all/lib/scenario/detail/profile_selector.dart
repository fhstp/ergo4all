import 'package:common_ui/theme/colors.dart';
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
    this.width,
  });

  /// The profile from which the user can select.
  final List<Profile> profiles;

  /// The currently selected profile.
  final Profile? selected;

  /// The width of the selector. When `null`, the width will be based on
  /// the widget content.
  final double? width;

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
      width: width,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: blueChill, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(color: blackPearl),
      ),
      label: Text(localizations.profile_selection_label),
      trailingIcon: const Icon(Icons.keyboard_arrow_down, color: blueChill),
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
