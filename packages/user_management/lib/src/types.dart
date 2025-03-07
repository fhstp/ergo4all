import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Represents a user of the app
@immutable
class User extends Equatable {
  /// Creates a user.
  const User({required this.name, required this.hasSeenTutorial});

  /// The users name.
  final String name;

  /// Whether the user has seen the tutorial. This will also be true if the
  /// user has skipped the tutorial.
  final bool hasSeenTutorial;

  @override
  List<Object?> get props => [name, hasSeenTutorial];

  /// Copies the user but changes some properties.
  User copyWith({
    String? name,
    bool? hasSeenTutorial,
  }) {
    return User(
      name: name ?? this.name,
      hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
    );
  }
}
