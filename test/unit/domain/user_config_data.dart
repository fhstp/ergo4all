import 'package:ergo4all/domain/user_config.dart';
import 'package:glados/glados.dart';

import 'user_data.dart';

extension AnyUserConfig on Any {
  /// Generates a [UserConfigEntry]
  Generator<UserConfigEntry> get userConfigEntry =>
      any.user.map((user) => UserConfigEntry(name: user.name));

  /// Generates a non-empty [UserConfig]
  Generator<UserConfig> get userConfig =>
      any.nonEmptyList(userConfigEntry).bind((entries) {
        return any.intInRange(0, entries.length).map((currentIndex) =>
            UserConfig(currentUserIndex: currentIndex, userEntries: entries));
      });
}
