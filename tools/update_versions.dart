import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

final pubGlob = Glob('{apps,packages}/**/pubspec.yaml');

final versionRegex = RegExp(r'^version: (.*)$', multiLine: true);

Future<String> getWorkspaceVersion() async {
  final file = File('./pubspec.yaml');
  final content = await file.readAsString();
  return versionRegex.firstMatch(content)!.group(1).toString();
}

Future<List<File>> getPubFiles() {
  return pubGlob.list().map((e) => File(e.path)).toList();
}

Future<void> writeVersionToPub(File pubFile, String version) async {
  var content = await pubFile.readAsString();
  content = content.replaceFirst(versionRegex, 'version: ' + version);
  await pubFile.writeAsString(content);
}

void main() async {
  final workspaceVersion = await getWorkspaceVersion();
  final pubFiles = await getPubFiles();
  for (final pub in pubFiles) {
    await writeVersionToPub(pub, workspaceVersion);
  }
}
