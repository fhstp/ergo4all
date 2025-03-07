import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class ImageFile {
  const ImageFile._(
    this.file, {
    required this.width,
    required this.height,
    required this.bytes,
  });

  final int width;
  final int height;
  final Uint8List bytes;
  final File file;

  static Future<ImageFile> loadFrom(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);
    final result = ImageFile._(file,
        width: image.width, height: image.height, bytes: bytes);
    image.dispose();
    return result;
  }
}
