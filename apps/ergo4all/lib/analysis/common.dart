import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:flutter/widgets.dart';

/// The result of analyzing a video.
@immutable
class AnalysisResult {
  ///
  const AnalysisResult({
    required this.scenario,
    required this.timeline,
  });

  /// The scenario which was analyzed.
  final Scenario scenario;

  /// The recorded score time-line.
  final RulaTimeline timeline;
}
