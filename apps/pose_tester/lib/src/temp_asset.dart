import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> makeTempFileForAsset(String key) async {
  final byteData = await rootBundle.load(key);
  final buffer = byteData.buffer;
  final tempDir = await getTemporaryDirectory();
  final tempPath = tempDir.path;

  final fileName = key.split('/').last;
  final filePath = '$tempPath/$fileName.tmp';
  return File(filePath).writeAsBytes(
    buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    flush: true,
  );
}
