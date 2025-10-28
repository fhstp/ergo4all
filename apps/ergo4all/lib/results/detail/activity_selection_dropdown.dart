import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/activity.dart';
import 'package:ergo4all/common/variable_localizations.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

/// Widget for the user to pick one (or none) of a set of [Activity] choices.
class ActivitySelectionDropdown extends StatelessWidget {
  ///
  const ActivitySelectionDropdown({
    required this.options,
    required this.selected,
    super.key,
    this.onSelected,
  });

  /// The currently selected activity.
  final Activity? selected;

  /// The activities the user may pick from.
  final Iterable<Activity> options;

  /// Called when the user makes a choice. May be called with `null` to
  /// indicate no selection.
  final void Function(Activity?)? onSelected;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DropdownMenu<Activity?>(
      key: UniqueKey(),
      expandedInsets: EdgeInsets.zero,
      label: Text(
        localizations.har_activity_selection,
        style: dynamicBodyStyle,
      ),
      initialSelection: selected,
      dropdownMenuEntries: options
          .map(
            (activity) => DropdownMenuEntry<Activity?>(
              value: activity,
              label: localizations.activityDisplayName(activity),
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(dynamicBodyStyle),
              ),
            ),
          )
          .prepend(
            DropdownMenuEntry(
              value: null,
              label: localizations.all_activities,
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(dynamicBodyStyle),
              ),
            ),
          )
          .toList(),
      onSelected: onSelected,
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
      textStyle: dynamicBodyStyle,
    );
  }
}
