import 'package:ergo4all/analysis/har/activity.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';

/// Extensions for getting variable localized texts for Activity.
extension ActivityLocalizations on AppLocalizations {
  /// Gets the localized display name of an [Activity].
  String activityDisplayName(Activity activity) => switch (activity) {
        Activity.background => har_class_background,
        Activity.carrying => har_class_carrying,
        Activity.kneeling => har_class_kneeling,
        Activity.lifting => har_class_lifting,
        Activity.overhead => har_class_overhead,
        Activity.sitting => har_class_sitting,
        Activity.standing => har_class_standing,
        Activity.walking => har_class_walking,
        Activity.noSelection => har_class_no_selection,
      };

  Activity activityFromName(String name) {
    if (name == har_class_background) return Activity.background;
    if (name == har_class_carrying) return Activity.carrying;
    if (name == har_class_kneeling) return Activity.kneeling;
    if (name == har_class_lifting) return Activity.lifting;
    if (name == har_class_overhead) return Activity.overhead;
    if (name == har_class_sitting) return Activity.sitting;
    if (name == har_class_standing) return Activity.standing;
    if (name == har_class_walking) return Activity.walking;
    if (name == har_class_no_selection) return Activity.noSelection;
    throw ArgumentError('Unknown activity name: $name');
  }
}
