import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class ImageFile {
  final int width;
  final int height;
  final Uint8List bytes;

  const ImageFile(
      {required this.width, required this.height, required this.bytes});

  static Future<ImageFile> loadFromAsset(String assetName) async {
    final bytes = (await rootBundle.load(assetName)).buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    final result =
        ImageFile(width: image.width, height: image.height, bytes: bytes);
    image.dispose();
    return result;
  }
}
