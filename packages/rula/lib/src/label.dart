import 'package:rula/src/score.dart';

/// The different rula scoring labels which can be derived from the final score.
///
/// See https://www.dguv.de/medien/ifa/de/pub/rep/pdf/rep07/biar0207/rula.pdf
enum RulaLabel {
  /// The pose is acceptable. Corresponds to values [1, 2].
  acceptable,

  /// The pose should be changed in the near future. Corresponds to values
  /// [3, 4].
  changeInFuture,

  /// The pose should be changed shortly. Corresponds to values [5, 6].
  changeSoon,

  /// The pose should be changed immediately. Corresponds to values >= 7
  changeImmediately
}

/// Gets the corresponding [RulaLabel] for a [RulaScore].
RulaLabel rulaLabelFor(RulaScore score) {
  return switch (score.value) {
    1 || 2 => RulaLabel.acceptable,
    3 || 4 => RulaLabel.changeInFuture,
    5 || 6 => RulaLabel.changeSoon,
    >= 7 => RulaLabel.changeImmediately,
    _ =>
      throw AssertionError('Score is out of range for valid RulaScore values')
  };
}
