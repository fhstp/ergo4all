// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

/// UI state for the welcome screen.
@immutable
class UIState {
  /// The projects version, likely in the semantic version format. It is optional, since it must be loaded asynchronously.
  final Option<String> projectVersion;

  /// Whether to go to onboarding after the welcome screen completes. Optional
  /// since this information needs to be fetched first.
  final Option<bool> shouldDoOnboarding;

  const UIState({
    required this.projectVersion,
    required this.shouldDoOnboarding,
  });

  UIState copyWith({
    Option<String>? projectVersion,
    Option<bool>? shouldDoOnboarding,
  }) {
    return UIState(
      projectVersion: projectVersion ?? this.projectVersion,
      shouldDoOnboarding: shouldDoOnboarding ?? this.shouldDoOnboarding,
    );
  }
}
