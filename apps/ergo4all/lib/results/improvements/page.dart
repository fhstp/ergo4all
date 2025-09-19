import 'package:ergo4all/results/improvements/scenario_good_bad_graphic.dart';
import 'package:ergo4all/results/screen.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:flutter/material.dart';

/// Page on the [ResultsScreen] for displaying feedback and improvements.
class ImprovementsPage extends StatelessWidget {
  ///
  const ImprovementsPage({required this.scenario, super.key});

  /// The recorded scenario.
  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ScenarioGoodBadGraphic(
            scenario,
            height: 330,
          ),
        ),
      ],
    );
  }
}
