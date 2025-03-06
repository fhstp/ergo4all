import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class ImageFile {
  final int width;
  final int height;
  final Uint8List bytes;
  final File file;

  const ImageFile(this.file,
      {required this.width, required this.height, required this.bytes});

  static Future<ImageFile> loadFrom(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);
    final result =
        ImageFile(file, width: image.width, height: image.height, bytes: bytes);
    image.dispose();
    return result;
  }
}
