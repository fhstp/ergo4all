import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/rating.dart';

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

  /// Gets a localized message to display to users which explains
  /// why the given [group] received the [rating] and what they should
  /// do about it.
  String ratedBodyPartMessage(BodyPartGroup group, Rating rating) =>
      switch ((group, rating)) {
        (BodyPartGroup.shoulder, Rating.good) => shoulderGood,
        (BodyPartGroup.shoulder, Rating.medium) => shoulderMedium,
        (BodyPartGroup.shoulder, Rating.low) => shoulderLow,
        (BodyPartGroup.arm, Rating.good) => armGood,
        (BodyPartGroup.arm, Rating.medium) => armMedium,
        (BodyPartGroup.arm, Rating.low) => armLow,
        (BodyPartGroup.trunk, Rating.good) => trunkGood,
        (BodyPartGroup.trunk, Rating.medium) => trunkMedium,
        (BodyPartGroup.trunk, Rating.low) => trunkLow,
        (BodyPartGroup.neck, Rating.good) => neckGood,
        (BodyPartGroup.neck, Rating.medium) => neckMedium,
        (BodyPartGroup.neck, Rating.low) => neckLow,
        (BodyPartGroup.legs, Rating.good) => legsGood,
        (BodyPartGroup.legs, Rating.medium) => legsMedium,
        (BodyPartGroup.legs, Rating.low) => legsLow,
      };
}
