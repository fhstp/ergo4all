import 'dart:math';

import 'package:rula/score.dart';

/// This matches table C on the Rula sheet.
const _tableC = [
  [1, 2, 3, 3, 4, 5, 5],
  [2, 2, 3, 4, 4, 5, 5],
  [3, 3, 3, 4, 4, 5, 6],
  [3, 3, 3, 4, 5, 6, 6],
  [4, 4, 4, 5, 6, 7, 7],
  [4, 4, 5, 6, 6, 7, 7],
  [5, 5, 6, 6, 7, 7, 7],
  [5, 5, 6, 7, 7, 7, 7]
];

/// Calculates the score for table C as specified on the Rula scoring sheet.
/// Input parameters are the [armHandScore] (Score A) and
/// [neckTorsoLegScore] (Score B) which should be calculated first.
///
/// The resulting [RulaScore] is guaranteed to be in the range [1, 7].
///
/// Note: We could also add logic to handle weight and repetition modifiers here
/// as is done on the sheet for table C.
RulaScore calcFinalRulaScore(
    RulaScore armHandScore, RulaScore neckTorsoLegScore) {
  // We clamp large scores down and subtract 1 to convert to a list index.
  final aScore = min(armHandScore.value, 8) - 1;
  final bScore = min(neckTorsoLegScore.value, 7) - 1;
  return RulaScore.make(_tableC[aScore][bScore]);
}
