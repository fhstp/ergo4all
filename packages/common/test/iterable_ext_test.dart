import 'package:common/iterable_ext.dart';
import 'package:test/test.dart';

void main() {
  group('median', () {
    test('should be the single item for single item lists', () {
      final x = [1].median();
      expect(x, equals(1));
    });

    test('should be null for empty list', () {
      final x = <int>[].median();
      expect(x, equals(null));
    });

    test('should be most common item', () {
      final x = [1, 1, 2, 2, 2, 2, 3].median();
      expect(x, equals(2));
    });
  });
}
