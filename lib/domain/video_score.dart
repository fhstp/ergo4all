import 'package:ergo4all/domain/scoring.dart';
import 'package:flutter/material.dart';

/// Contains scoring data for one video ie. a series of frames.
@immutable
class VideoScore {
  /// Score for each frame keyed by relative timestamp.
  final Map<int, BodyScore> scoreByTimestamp;

  const VideoScore(this.scoreByTimestamp);

  static VideoScore empty = const VideoScore({});

  VideoScore addScore(int timestamp, BodyScore score) {
    throw Exception("Not implemented");
  }
}
