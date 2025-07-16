import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rula/rula.dart';

enum _Side { left, right, both }

/// A group of [BodyPart] which are scored as one.
sealed class ScoreGroup {
  /// Gets the [ScoreGroup] for a [BodyPart].
  factory ScoreGroup.forPart(BodyPart part) => switch (part) {
        BodyPart.head => _Singular.neck,
        BodyPart.leftHand || BodyPart.leftLowerArm => const _Paired(
            name: _PairedName.arm,
            side: _Side.left,
          ),
        BodyPart.rightHand || BodyPart.rightLowerArm => const _Paired(
            name: _PairedName.arm,
            side: _Side.right,
          ),
        BodyPart.leftLeg => const _Paired(
            name: _PairedName.legs,
            side: _Side.left,
          ),
        BodyPart.rightLeg => const _Paired(
            name: _PairedName.legs,
            side: _Side.right,
          ),
        BodyPart.leftUpperArm => const _Paired(
            name: _PairedName.shoulder,
            side: _Side.left,
          ),
        BodyPart.rightUpperArm => const _Paired(
            name: _PairedName.shoulder,
            side: _Side.right,
          ),
        BodyPart.upperBody => _Singular.trunk,
      };

  /// List of all [ScoreGroup]s with paired body-parts, such as arms,
  /// being separate items. Ie. `[left_arm, right_arm]`
  static const IList<ScoreGroup> valuesSplit = IListConst([
    _Singular.neck,
    _Singular.trunk,
    _Paired(
      name: _PairedName.shoulder,
      side: _Side.left,
    ),
    _Paired(
      name: _PairedName.shoulder,
      side: _Side.right,
    ),
    _Paired(
      name: _PairedName.arm,
      side: _Side.left,
    ),
    _Paired(
      name: _PairedName.arm,
      side: _Side.right,
    ),
    _Paired(
      name: _PairedName.legs,
      side: _Side.left,
    ),
    _Paired(
      name: _PairedName.legs,
      side: _Side.right,
    ),
  ]);

  /// List of all [ScoreGroup]s with paired body-parts, such as arms,
  /// being represented as a single merged item. Ie. `[both_arms]`
  static const IList<ScoreGroup> valuesMerged = IListConst([
    _Singular.neck,
    _Singular.trunk,
    _Paired(
      name: _PairedName.shoulder,
      side: _Side.both,
    ),
    _Paired(
      name: _PairedName.arm,
      side: _Side.both,
    ),
    _Paired(
      name: _PairedName.legs,
      side: _Side.both,
    ),
  ]);

  /// Gets the name of this group.
  static String nameOf(ScoreGroup it) => switch (it) {
        final _Singular singular => singular.name,
        _Paired(name: final name) => name.name
      };

  /// The maximum score expected for a [ScoreGroup].
  static int maxScoreOf(ScoreGroup group) => switch (group) {
        _Singular.neck => 6,
        _Singular.trunk => 6,
        _Paired(name: _PairedName.shoulder) => 6,
        _Paired(name: _PairedName.arm) => 3,
        _Paired(name: _PairedName.legs) => 3,
      };

  /// Normalizes the given [score] into the range [0, 1] based on the maximum
  /// score for [group].
  static double normalizeFor(ScoreGroup group, int score) {
    final maxScore = ScoreGroup.maxScoreOf(group);
    return normalizeScore(score, maxScore);
  }
}

enum _Singular implements ScoreGroup {
  neck,
  trunk;
}

enum _PairedName {
  shoulder,
  arm,
  legs,
}

final class _Paired implements ScoreGroup {
  const _Paired({required this.name, required this.side});

  final _PairedName name;
  final _Side side;
}

/// Contains extensions for reading scores for [ScoreGroup]s from
/// [RulaScores].
extension ScoreGroupAccess on RulaScores {
  /// Get scores for a [ScoreGroup].
  /// If [group] represents a merged body-part, such as "both arms", then
  /// the function [mergeScores] will be used to merge the left and right
  /// scores.
  int scoreOfGroup(
    ScoreGroup group, {
    required int Function(int left, int right) mergeScores,
  }) {
    int pickSide((int, int) scores, _Side side) {
      return switch (side) {
        _Side.left => scores.$1,
        _Side.right => scores.$2,
        _Side.both => mergeScores(scores.$1, scores.$2),
      };
    }

    return switch (group) {
      _Singular.neck => neckScore,
      _Singular.trunk => trunkScore,
      _Paired(side: final side, name: _PairedName.shoulder) =>
        pickSide(upperArmScores, side),
      _Paired(side: final side, name: _PairedName.arm) =>
        pickSide(lowerArmScores, side),
      _Paired(side: final side, name: _PairedName.legs) =>
        pickSide(legScores, side)
    };
  }
}

/// Get the localized label for the given [group].
String scoreGroupLabelFor(
  AppLocalizations localizations,
  ScoreGroup group,
) =>
    switch (group) {
      _Paired(name: _PairedName.shoulder) =>
        localizations.results_body_shoulder,
      _Paired(name: _PairedName.arm) => localizations.results_body_arm,
      _Singular.trunk => localizations.results_body_trunk,
      _Singular.neck => localizations.results_body_neck,
      _Paired(name: _PairedName.legs) => localizations.results_body_legs,
    };
