import 'package:glados/glados.dart';

extension RulaScoreConfig on Any {
  /// Generates a [int] in the range [1, 9]
  Generator<int> get rulaScore => any.intInRange(1, 10);
}
