import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/subjects/common.dart';
import 'package:flutter/material.dart';

/// Dropdown to select from a list of [Subject]s.
class SubjectSelector extends StatelessWidget {
  ///
  const SubjectSelector({
    required this.subjects,
    super.key,
    this.selectedSubject,
    this.onSubjectSelected,
  });

  /// The subjects from which the user can select.
  final List<Subject> subjects;

  /// The currently selected subject.
  final Subject? selectedSubject;

  /// Callback for when a subject is selected.
  final void Function(Subject?)? onSubjectSelected;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DropdownMenu(
      // Having this unique key here fixes
      // https://github.com/flutter/flutter/issues/120567
      // where the dropdown would not resize after the subjects
      // were loaded and be too small.
      key: UniqueKey(),
      label: Text(localizations.subject_selection_label),
      initialSelection: selectedSubject,
      dropdownMenuEntries: subjects
          .map(
            (subject) => DropdownMenuEntry(
              value: subject,
              label: subject.nickname,
            ),
          )
          .toList(),
      onSelected: (subject) {
        onSubjectSelected?.call(subject);
      },
    );
  }
}
