import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An already loaded file containing image data.
@immutable
class ImageFile {
  const ImageFile._(
    this.file, {
    required this.width,
    required this.height,
    required this.bytes,
  });

  /// The image width.
  final int width;

  /// The image height.
  final int height;

  /// The image data as a list of bytes.
  final Uint8List bytes;

  /// The file from which the image was loaded.
  final File file;

  /// Loads an image file from the given [path].
  static Future<ImageFile> loadFrom(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);
    final result = ImageFile._(
      file,
      width: image.width,
      height: image.height,
      bytes: bytes,
    );
    image.dispose();
    return result;
  }
}
