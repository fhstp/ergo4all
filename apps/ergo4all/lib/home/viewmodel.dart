import 'package:ergo4all/common/value_notifier_ext.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_management/user_management.dart';

/// View-model for home screen
class HomeViewModel {
  final _uiState = ValueNotifier(UIState(user: none()));

  ValueListenable<UIState> get uiState => _uiState;

  Future<void> initialize() async {
    final user = await loadCurrentUser();
    assert(user != null, 'Must have user on home-screen');
    _uiState.update((it) => it.copyWith(user: Some(user!)));
  }
}
