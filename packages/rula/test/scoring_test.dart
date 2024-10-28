import 'package:glados/glados.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:rula/score.dart';
import 'package:rula/scoring.dart';

import 'score_data.dart';

void main() {
  group("Final score", () {
    Glados2(any.rulaScore, any.rulaScore)
        .test("should have output in range [1, 7]",
            (armHandScore, neckTorsoLegScore) {
      final finalScore = calcFinalRulaScore(armHandScore, neckTorsoLegScore);
      expect(finalScore.value, greaterThanOrEqualTo(1));
      expect(finalScore.value, lessThanOrEqualTo(7));
    });

    parameterizedTest("should calculate correct score", [
      // A few examples of rula score calculations, where the first two values
      // are the A and B score and the last is the expected result.
      [1, 1, 1],
      [4, 3, 3],
      [3, 5, 4],
      [7, 3, 6],
      [9, 6, 7],
    ], (int armHandScore, int neckTorsoLegScore, int expected) {
      final actual = calcFinalRulaScore(
          RulaScore.make(armHandScore), RulaScore.make(neckTorsoLegScore));
      expect(actual.value, equals(expected));
    });
  });
}
