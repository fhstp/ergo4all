import 'package:flutter/foundation.dart';

/// A human subject which can be recorded.
@immutable
class Subject {
  ///
  const Subject({required this.id});

  /// Numeric id which uniquely identifies this subject.
  final int id;
}
