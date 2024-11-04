import 'package:common/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Represents a user of the app
@immutable
class User extends Equatable {
  /// The users name.
  final String name;

  /// Whether the user has seen the tutorial. This will also be true if
  /// the user has skipped the tutorial.
  final bool hasSeenTutorial;

  const User({required this.name, required this.hasSeenTutorial});

  @override
  List<Object?> get props => [name, hasSeenTutorial];
}

/// Stores [User] data.
abstract class UserStorage {
  /// Adds the given [user] to the app and marks them as the current user.
  Future<Null> addUser(User user);

  /// Updates the user with the given [userIndex] by applying [update] to it. Will throw an exception if the user does not exist.
  Future<Null> updateUser(int userIndex, Update<User> update);

  /// Gets the current user or `null` if there is none.
  Future<User?> getCurrentUser();

  /// Gets the index of the current user. May be `null` if there is no user yet.
  Future<int?> getCurrentUserIndex();
}
