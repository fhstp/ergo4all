import 'package:user_management/src/types.dart';

/// Marks [user] as having skipped the tutorial. Returns the updated [User].
User skipTutorial(User user) {
  return User(name: user.name, hasSeenTutorial: true);
}
