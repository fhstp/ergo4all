// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Represents a user of the app
@immutable
class User extends Equatable {
  /// The users name.
  final String name;

  /// Whether the user has seen the tutorial. This will also be true if the user has skipped the tutorial.
  final bool hasSeenTutorial;

  const User({required this.name, required this.hasSeenTutorial});

  @override
  List<Object?> get props => [name, hasSeenTutorial];

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
