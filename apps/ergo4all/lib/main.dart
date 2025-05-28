import 'package:ergo4all/app.dart';
import 'package:ergo4all/storage/object_box.dart';
import 'package:ergo4all/storage/object_box_rula_session_repository.dart';
import 'package:ergo4all/storage/rula_session_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await ObjectBox.create();
  final rulaSessionRepository = ObjectBoxRulaSessionRepository(store.store);

  runApp(
    MultiProvider(
      providers: [
        Provider<RulaSessionRepository>.value(value: rulaSessionRepository),
      ],
      child: const Ergo4AllApp(),
    ),
  );
}
