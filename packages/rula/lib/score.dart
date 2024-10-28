import 'package:flutter/foundation.dart';

/// Represents a rula score value. This value is always >= 1 and usually also
/// <= 7, but may sometimes be larger.
///
/// See https://www.dguv.de/medien/ifa/de/pub/rep/pdf/rep07/biar0207/rula.pdf
@immutable
class RulaScore {
  /// The wrapped value. Guaranteed to be in the valid range.
  final int value;

  const RulaScore._(this.value);

  /// Checks whether an [int] [value] would be a valid input for a [RulaScore]
  /// object.
  static bool isValid(int value) {
    return value >= 1;
  }

  /// Attempts to create a [RulaScore] object from an [int] [value]. Returns
  /// `null` if the value is not valid.
  static RulaScore? tryMake(int value) {
    if (!isValid(value)) return null;
    return RulaScore._(value);
  }

  /// Attempts to create a [RulaScore] object from an [int] [value]. Throws an
  /// [ArgumentError] if the value is not valid
  static RulaScore make(int value) {
    final score = tryMake(value);
    if (score == null) {
      throw ArgumentError.value(
          value, "value", "Rula-score value is not valid");
    }
    return score;
  }

  @override
  String toString() {
    return value.toString();
  }
}
