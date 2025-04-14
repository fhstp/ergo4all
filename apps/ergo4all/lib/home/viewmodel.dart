import 'package:ergo4all/common/value_notifier_ext.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_management/user_management.dart';

/// View-model for home screen
class HomeViewModel {
  final _uiState = ValueNotifier(UIState(user: none()));

  /// Current [UIState].
  ValueListenable<UIState> get uiState => _uiState;

  /// Initializes this view-model. Should be called once when the corresponding
  /// screen is opened.
  Future<void> initialize() async {
    var user = await loadCurrentUser();

    if (user == null) {
      user = makeUserFromName('Ergo-fan');
      await addUser(user);
    }

    _uiState.update((it) => it.copyWith(user: Some(user!)));
  }
}
