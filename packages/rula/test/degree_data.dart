import 'package:glados/glados.dart';
import 'package:rula/degree.dart';

extension AnyDegree on Any {
  /// Generates a [Degree] in a certain range.
  Generator<Degree> degreeInRange(double min, double max) {
    assert(min >= -180);
    assert(min < max);
    assert(max <= 180);
    return any.doubleInRange(min, max).map(Degree.makeFrom180);
  }

  /// Generates a [Degree] in the full possible range.
  Generator<Degree> get degree => degreeInRange(-180, 180);
}
