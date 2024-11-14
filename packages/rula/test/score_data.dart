import 'package:glados/glados.dart';
import 'package:rula/src/score.dart';

extension RulaScoreConfig on Any {
  /// Generates a [RulaScore] in the range [1, 9]
  Generator<RulaScore> get rulaScore =>
      any.intInRange(1, 10).map((it) => RulaScore.tryMake(it)!);
}
