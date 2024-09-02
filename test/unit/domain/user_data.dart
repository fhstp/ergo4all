import 'package:ergo4all/domain/user.dart';
import 'package:glados/glados.dart';

extension AnyUser on Any {
  /// Generates a user with a random name
  Generator<User> get user => combine2(
      letters,
      choose(TutorialViewStatus.values),
      (name, tutorialViewStatus) =>
          User(name: name, tutorialViewStatus: tutorialViewStatus));
}
