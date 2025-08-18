import 'package:flutter/foundation.dart';

/// A human subject which can be recorded.
@immutable
class Subject {
  ///
  const Subject({required this.id, required this.nickname});

  /// Numeric id which uniquely identifies this subject.
  final int id;

  /// A display name for this subject.
  final String nickname;
}
