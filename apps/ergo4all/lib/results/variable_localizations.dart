import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_group.dart';

/// Extensions for getting variable localized texts.
extension VariableLocalizations on AppLocalizations {
  /// Get the localized label for the given [group].
  String bodyPartGroupLabel(BodyPartGroup group) => switch (group) {
        BodyPartGroup.shoulder => results_body_shoulder,
        BodyPartGroup.arm => results_body_arm,
        BodyPartGroup.trunk => results_body_trunk,
        BodyPartGroup.neck => results_body_neck,
        BodyPartGroup.legs => results_body_legs,
      };
}
