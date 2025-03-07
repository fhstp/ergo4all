import 'package:glados/glados.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:rula/src/degree.dart';

void main() {
  group('Creation', () {
    Glados(any.double).test('should have output in ]-180; 180] range', (input) {
      final degrees = Degree.makeFrom360(input);
      expect(degrees.value, greaterThanOrEqualTo(-180));
      expect(degrees.value, lessThanOrEqualTo(180));
    });

    parameterizedTest('should convert input angle to correct range', [
      // Values in range [0, 180[ are left as is
      [0.0, 0.0],
      [179.0, 179.0],
      // Values in range [180, 360[ are mirrored around 0°
      [180.0, -180.0],
      [359.0, -1.0],
      // Large values are repeated into the [0, 360[ range before calculation
      [361.0, 1.0],
      [560.0, -160.0],
      // Negative values are repeated into the [0, 360[ range before calculation
      [-1.0, -1.0],
      [-100.0, -100.0],
      [-190.0, 170.0],
    ], (double input, double expected) {
      final actual = Degree.makeFrom360(input);
      expect(actual.value, equals(expected));
    });
  });
}
