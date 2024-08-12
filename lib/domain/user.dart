import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Represents a user of the app
@immutable
class User extends Equatable {
  /// The users name.
  final String name;

  const User({required this.name});

  @override
  List<Object?> get props => [name];
}
