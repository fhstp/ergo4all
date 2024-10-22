import 'package:glados/glados.dart';
import 'package:user_storage/user_config.dart';

import '../../common/test/user_data.dart';

extension AnyUserConfig on Any {
  /// Generates a [UserConfigEntry]
  Generator<UserConfigEntry> get userConfigEntry => any.user.map((user) =>
      UserConfigEntry(name: user.name, hasSeenTutorial: user.hasSeenTutorial));

  /// Generates a non-empty [UserConfig]
  Generator<UserConfig> get userConfig =>
      any.nonEmptyList(userConfigEntry).bind((entries) {
        return any.intInRange(0, entries.length).map((currentIndex) =>
            UserConfig(currentUserIndex: currentIndex, userEntries: entries));
      });
}
