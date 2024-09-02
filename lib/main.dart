import 'package:ergo4all/io/local_file.dart';
import 'package:ergo4all/service/user_config.dart';
import 'package:ergo4all/service/add_user.dart';
import 'package:ergo4all/service/get_current_user.dart';
import 'package:ergo4all/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void _registerSingletons() {
  final getIt = GetIt.instance;

  getIt.registerSingleton<ReadLocalTextFile>(readLocalDocument);
  getIt.registerSingleton<WriteLocalTextFile>(writeLocalDocument);
  getIt.registerLazySingleton<GetUserConfig>(
      () => makeGetUserConfigFromStorage(getIt.get<ReadLocalTextFile>()));
  getIt.registerLazySingleton<GetCurrentUser>(
      () => makeGetCurrentUserFromConfig(getIt.get<GetUserConfig>()));
  getIt.registerLazySingleton<UpdateUserConfig>(() =>
      makeUpdateStoredUserConfig(
          getIt.get<GetUserConfig>(), getIt.get<WriteLocalTextFile>()));
  getIt.registerLazySingleton<AddUser>(
      () => makeAddUserToUserConfig(getIt.get<UpdateUserConfig>()));
}

void main() {
  _registerSingletons();
  runApp(const MyApp());
}
