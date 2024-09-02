import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum TutorialViewStatus { notDecided, seen, skipped }

/// Represents a user of the app
@immutable
class User extends Equatable {
  /// The users name.
  final String name;

  /// Status of whether the user has seen the tutorial.
  final TutorialViewStatus tutorialViewStatus;

  const User({required this.name, required this.tutorialViewStatus});

  @override
  List<Object?> get props => [name];
}
