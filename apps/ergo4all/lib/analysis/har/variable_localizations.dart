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
      };
}
