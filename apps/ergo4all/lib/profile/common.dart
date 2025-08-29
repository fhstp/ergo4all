import 'package:flutter/foundation.dart';

/// A reusable recording profile
@immutable
class Profile {
  ///
  const Profile({required this.id, required this.nickname});

  /// Numeric id which uniquely identifies this profile.
  final int id;

  /// A display name for this profile.
  final String nickname;
}
