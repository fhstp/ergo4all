import 'package:glados/glados.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:rula/score.dart';

void main() {
  group("Rula score type", () {
    parameterizedTest("should be invalid for values < 1", [
      // Negative values are not valid
      -1,
      // 0 is not valid
      0
    ], (int input) {
      final isValid = RulaScore.isValid(input);
      expect(isValid, isFalse);
    });

    parameterizedTest("should be valid for value >= 1", [
      // 1 is the first valid value
      1,
      // 7 is the last common valid value
      7,
      // But even values above 7 are allowed
      9
    ], (int input) {
      final isValid = RulaScore.isValid(input);
      expect(isValid, isTrue);
    });

    Glados(any.int).test("should only create Rula scores for valid inputs",
        (input) {
      final canMakeScore = RulaScore.tryMake(input) != null;
      final shouldMakeScore = RulaScore.isValid(input);
      expect(canMakeScore, equals(shouldMakeScore));
    });
  });
}
