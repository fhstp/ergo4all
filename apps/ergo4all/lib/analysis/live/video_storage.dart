import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as p;

// TODO(comradevanti): Move this logic into it's own package

final _recordingsDir = Directory(
  '/storage/emulated/0/Android/media/at.ac.fhstp.ergo4all/Ergo4All Recordings',
);

/// Creates a copy of the given [file] in the recordings folder. The created
/// file will have the same name as the original.
Future<void> copyToRecordingFolder(XFile file) async {
  await _recordingsDir.create(recursive: true);
  final recordingPath = p.join(_recordingsDir.path, file.name);
  await file.saveTo(recordingPath);
}
