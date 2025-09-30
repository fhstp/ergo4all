import 'package:ergo4all/profile/common.dart';
import 'package:flutter/material.dart';

/// Data associated with a list-entry on the profile management screen.
@immutable
class ProfileListEntry {
  ///
  const ProfileListEntry({
    required this.profile,
    required this.lastRecordedDate,
  });

  /// The profile.
  final Profile profile;

  /// The last time when this profile was used to record a session. `Null` if
  /// no session was recorded with the profile.
  final DateTime? lastRecordedDate;
}
