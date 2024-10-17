import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionDisplay extends StatefulWidget {
  const VersionDisplay({super.key});

  @override
  State<VersionDisplay> createState() => _VersionDisplayState();
}

class _VersionDisplayState extends State<VersionDisplay> {
  final Future<String> _packageLoad =
      PackageInfo.fromPlatform().then((it) => it.version);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _packageLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Text("...");
          }
          return Text("v${snapshot.data}");
        });
  }
}
