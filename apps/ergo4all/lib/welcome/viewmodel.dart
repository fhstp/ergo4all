import 'package:ergo4all/common/value_notifier_ext.dart';
import 'package:ergo4all/welcome/types.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:user_management/user_management.dart';

/// View-model for the welcome screen.
class WelcomeViewModel {
  final _uiState = ValueNotifier(UIState(
      projectVersion: Option.none(), shouldDoOnboarding: Option.none()));

  ValueListenable<UIState> get uiState => _uiState;

  Future<void> _loadProjectVersion() async {
    final info = await PackageInfo.fromPlatform();
    _uiState.update((it) => it.copyWith(projectVersion: Some(info.version)));
  }

  /// Starts the asynchronous check of whether the user should go to onboarding after completing the screen.
  Future<void> checkOnboarding() async {
    final user = await loadCurrentUser();
    final isFirstTime = user == null;
    _uiState.update((it) => it.copyWith(shouldDoOnboarding: Some(isFirstTime)));
  }

  WelcomeViewModel() {
    _loadProjectVersion();
  }
}
