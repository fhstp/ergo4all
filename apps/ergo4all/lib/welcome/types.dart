import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

/// UI state for the welcome screen.
@immutable
class UIState {
  const UIState({
    required this.projectVersion,
  });

  /// The projects version, likely in the semantic version format. It is
  ///  optional, since it must be loaded asynchronously.
  final Option<String> projectVersion;

  UIState copyWith({
    Option<String>? projectVersion,
  }) {
    return UIState(
      projectVersion: projectVersion ?? this.projectVersion,
    );
  }
}
