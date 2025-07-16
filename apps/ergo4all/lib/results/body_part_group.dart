import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rula/rula.dart';

enum _Side { left, right, both }

/// A group of [BodyPart] which are treated as one.
sealed class BodyPartGroup {
  /// Gets the [BodyPartGroup] for a [BodyPart].
  factory BodyPartGroup.fromBodyPart(BodyPart part) => switch (part) {
        BodyPart.head => _SingularGroup.neck,
        BodyPart.leftHand || BodyPart.leftLowerArm => const _PairedGroup(
            name: _PairedGroupName.arm,
            side: _Side.left,
          ),
        BodyPart.rightHand || BodyPart.rightLowerArm => const _PairedGroup(
            name: _PairedGroupName.arm,
            side: _Side.right,
          ),
        BodyPart.leftLeg => const _PairedGroup(
            name: _PairedGroupName.legs,
            side: _Side.left,
          ),
        BodyPart.rightLeg => const _PairedGroup(
            name: _PairedGroupName.legs,
            side: _Side.right,
          ),
        BodyPart.leftUpperArm => const _PairedGroup(
            name: _PairedGroupName.shoulder,
            side: _Side.left,
          ),
        BodyPart.rightUpperArm => const _PairedGroup(
            name: _PairedGroupName.shoulder,
            side: _Side.right,
          ),
        BodyPart.upperBody => _SingularGroup.trunk,
      };

  /// List of all [BodyPartGroup]s with paired groups, such as arms,
  /// being separate items. Ie. `[left_arm, right_arm]`
  static const IList<BodyPartGroup> valuesSplit = IListConst([
    _SingularGroup.neck,
    _SingularGroup.trunk,
    _PairedGroup(
      name: _PairedGroupName.shoulder,
      side: _Side.left,
    ),
    _PairedGroup(
      name: _PairedGroupName.shoulder,
      side: _Side.right,
    ),
    _PairedGroup(
      name: _PairedGroupName.arm,
      side: _Side.left,
    ),
    _PairedGroup(
      name: _PairedGroupName.arm,
      side: _Side.right,
    ),
    _PairedGroup(
      name: _PairedGroupName.legs,
      side: _Side.left,
    ),
    _PairedGroup(
      name: _PairedGroupName.legs,
      side: _Side.right,
    ),
  ]);

  /// List of all [BodyPartGroup]s with paired groups, such as arms,
  /// being represented as a single merged item. Ie. `[both_arms]`
  static const IList<BodyPartGroup> valuesMerged = IListConst([
    _SingularGroup.neck,
    _SingularGroup.trunk,
    _PairedGroup(
      name: _PairedGroupName.shoulder,
      side: _Side.both,
    ),
    _PairedGroup(
      name: _PairedGroupName.arm,
      side: _Side.both,
    ),
    _PairedGroup(
      name: _PairedGroupName.legs,
      side: _Side.both,
    ),
  ]);

  /// Gets the name of this group.
  static String nameOf(BodyPartGroup it) => switch (it) {
        final _SingularGroup singular => singular.name,
        _PairedGroup(name: final name) => name.name
      };

  /// The maximum score expected for a [BodyPartGroup].
  static int maxScoreOf(BodyPartGroup group) => switch (group) {
        _SingularGroup.neck => 6,
        _SingularGroup.trunk => 6,
        _PairedGroup(name: _PairedGroupName.shoulder) => 6,
        _PairedGroup(name: _PairedGroupName.arm) => 3,
        _PairedGroup(name: _PairedGroupName.legs) => 3,
      };

  /// Normalizes the given [score] into the range [0, 1] based on the maximum
  /// score for [group].
  static double normalizeFor(BodyPartGroup group, int score) {
    final maxScore = BodyPartGroup.maxScoreOf(group);
    return normalizeScore(score, maxScore);
  }
}

enum _SingularGroup implements BodyPartGroup {
  neck,
  trunk;
}

enum _PairedGroupName {
  shoulder,
  arm,
  legs,
}

final class _PairedGroup implements BodyPartGroup {
  const _PairedGroup({required this.name, required this.side});

  final _PairedGroupName name;
  final _Side side;
}

/// Contains extensions for reading scores for [BodyPartGroup]s from
/// [RulaScores].
extension BodyPartGroupAccess on RulaScores {
  /// Get scores for a [BodyPartGroup].
  /// If [group] is a merged body part, such as "both arms", then
  /// the function [mergeScores] will be used to merge the left and right
  /// scores.
  int scoreOfGroup(
    BodyPartGroup group, {
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
      _SingularGroup.neck => neckScore,
      _SingularGroup.trunk => trunkScore,
      _PairedGroup(side: final side, name: _PairedGroupName.shoulder) =>
        pickSide(upperArmScores, side),
      _PairedGroup(side: final side, name: _PairedGroupName.arm) =>
        pickSide(lowerArmScores, side),
      _PairedGroup(side: final side, name: _PairedGroupName.legs) =>
        pickSide(legScores, side)
    };
  }
}

/// Get the localized label for the given [group].
String bodyPartGroupLabelFor(
  AppLocalizations localizations,
  BodyPartGroup group,
) =>
    switch (group) {
      _PairedGroup(name: _PairedGroupName.shoulder) =>
        localizations.results_body_shoulder,
      _PairedGroup(name: _PairedGroupName.arm) =>
        localizations.results_body_arm,
      _SingularGroup.trunk => localizations.results_body_trunk,
      _SingularGroup.neck => localizations.results_body_neck,
      _PairedGroup(name: _PairedGroupName.legs) =>
        localizations.results_body_legs,
    };
