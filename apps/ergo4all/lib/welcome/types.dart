// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

/// UI state for the welcome screen.
@immutable
class UIState {
  /// The projects version, likely in the semantic version format. It is optional, since it must be loaded asynchronously.
  final Option<String> projectVersion;

  const UIState({
    required this.projectVersion,
  });

  UIState copyWith({
    Option<String>? projectVersion,
  }) {
    return UIState(
      projectVersion: projectVersion ?? this.projectVersion,
    );
  }
}
