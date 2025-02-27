import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_management/user_management.dart';

/// The different sources from which a video for ananylsis may come.
enum VideoSource {
  /// An existing video, picked from the users device.
  gallery,

  /// A new video, recorded live during the analysis.
  live
}

/// UI state for home screen.
@immutable
class UIState {
  /// The current user. Optional since it needs to be loaded first.
  final Option<User> user;

  const UIState({required this.user});

  UIState copyWith({
    Option<User>? user,
  }) {
    return UIState(
      user: user ?? this.user,
    );
  }
}
