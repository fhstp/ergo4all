import 'package:flutter/foundation.dart';

/// A user of the app
@immutable
class User {
  ///
  const User({
    required this.id,
    required this.name,
  });

  /// The users unique id.
  final String id;

  /// The users name.
  final String name;
}
