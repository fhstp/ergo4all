import 'package:ergo4all/app.dart';
import 'package:ergo4all/objectbox.g.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final docsDir = await getApplicationDocumentsDirectory();
  final store =
      await openStore(directory: p.join(docsDir.path, 'rulaSessions-db'));
  final rulaSessionRepository = ObjectBoxRulaSessionRepository(store);

  runApp(
    MultiProvider(
      providers: [
        Provider<RulaSessionRepository>.value(value: rulaSessionRepository),
      ],
      child: const Ergo4AllApp(),
    ),
  );
}
