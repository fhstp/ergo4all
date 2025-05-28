import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';

/// data class to use in order to store rula sessions on device database
class RulaSession {
  const RulaSession({required this.timestamp, required this.scenario, required this.timeline});
  /// session timestamp
  final int timestamp;
  /// session timestamp
  final Scenario scenario;
  /// session RulaTimeline
  final RulaTimeline timeline;
}
