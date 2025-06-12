import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/scenario/common.dart';

/// data class to use in order to store rula sessions on device database
class RulaSession {
  const RulaSession({required this.timestamp, required this.scenario, required this.timeline});
  /// session timestamp: corresponds to the date and time at which the session was recorded.
  final int timestamp;
  /// session scenario: corresponds to the sceneario which was recorded in this session
  final Scenario scenario;
  /// session RulaTimeline: corresponds to the RulaTimeline data recorded in this session
  final RulaTimeline timeline;
}
