import 'package:ergo4all/scenario/common.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';

/// A 'good/bad' graphic for a specific [Scenario].
class ScenarioGoodBadGraphic extends StatelessWidget {
  ///
  const ScenarioGoodBadGraphic(
    this.scenario, {
    required this.height,
    super.key,
  });

  /// The scenario for which to display.
  final Scenario scenario;

  /// The height of the graphic. Width is calculated automatically from
  /// aspect ratio.
  final double height;

  @override
  Widget build(BuildContext context) {
    final graphicFileName = switch (scenario) {
      Scenario.liftAndCarry || Scenario.lift25 => 'lifting',
      Scenario.pull => 'pushing',
      Scenario.seated => 'sitting',
      Scenario.packaging ||
      Scenario.standingCNC ||
      Scenario.standingAssembly ||
      Scenario.conveyorBelt =>
        'standing',
      Scenario.ceiling => 'overhead_work',
    };

    final graphicKey =
        'assets/images/puppets_good_bad/good_bad_$graphicFileName.svg';

    return SvgPicture.asset(graphicKey, height: height);
  }
}
