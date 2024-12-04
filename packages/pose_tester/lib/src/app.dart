import 'package:flutter/material.dart';

class PoseTesterApp extends StatefulWidget {
  const PoseTesterApp({super.key});

  @override
  State<PoseTesterApp> createState() => _PoseTesterAppState();
}

class _PoseTesterAppState extends State<PoseTesterApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pose tester",
      home: Placeholder(),
    );
  }
}
