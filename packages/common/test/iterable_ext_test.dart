import 'package:common/iterable_ext.dart';
import 'package:test/test.dart';

void main() {
  group('mode', () {
    test('should be the single item for single item lists', () {
      final x = [1].mode();
      expect(x, equals(1));
    });

    test('should be null for empty list', () {
      final x = <int>[].mode();
      expect(x, equals(null));
    });

    test('should be most common item', () {
      final x = [1, 1, 2, 2, 2, 2, 3].mode();
      expect(x, equals(2));
    });
  });
}
