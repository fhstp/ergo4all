import 'package:user_management/src/types.dart';

/// Makes a new [User] with the given [name]. The user has the properties of a
/// new user of the app. For example, they have not seen the tutorial.
User makeUserFromName(String name) {
  return User(name: name, hasSeenTutorial: false);
}
