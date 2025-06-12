import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/video_storage/src/common.dart';
import 'package:path/path.dart' as p;

final _recordingsDir = Directory(
  '/storage/emulated/0/Android/media/at.ac.fhstp.ergo4all/Ergo4All Recordings',
);

/// Implementation of [VideoStore] which saves the videos inside the
/// devices local `/storage/emulated/0/Android/media` directory.
class LocalVideoStore implements VideoStore {
  @override
  Future<String> putFromFile(XFile file) async {
    await _recordingsDir.create(recursive: true);
    final recordingPath = p.join(_recordingsDir.path, file.name);
    await file.saveTo(recordingPath);
    return file.name;
  }
}
