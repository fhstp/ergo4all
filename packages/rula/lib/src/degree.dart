import 'package:flutter/foundation.dart';

/// An angle in degrees in the range [-180; 180[.
@immutable
class Degree {
  /// Makes a degree from a angle which is already in the valid [-180, 180[
  /// range.
  const Degree.makeFrom180(this.value)
      : assert(value >= -180, 'Angle must be at least -180°'),
        assert(value < 180, 'Angle must be less than 180°');

  /// Makes a new [Degree] object by normalizing an arbitrary [0, 360[ degree
  /// [angle]. If the angle is outside the given range it is first repeated
  /// into it.
  factory Degree.makeFrom360(double angle) {
    angle %= 360;
    if (angle >= 0 && angle < 180) return Degree.makeFrom180(angle);
    return Degree.makeFrom180(angle - 360);
  }

  /// The wrapped value. Guaranteed to be in the correct value range.
  final double value;

  /// 0°
  static const Degree zero = Degree.makeFrom180(0);

  /// Creates a new [Degree] which is clamped between [min] and [max]. [min]
  /// must be larger than or equal to -180 and smaller than [max]. [max] must
  /// be smaller than 180.
  Degree clamp(double min, double max) {
    assert(min < max, 'Max must be larger than min');

    final angle = clampDouble(value, min, max);
    return Degree.makeFrom180(angle);
  }

  @override
  String toString() {
    return '$value°';
  }
}
