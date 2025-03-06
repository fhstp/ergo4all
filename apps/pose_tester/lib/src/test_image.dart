import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class TestImage {
  final int width;
  final int height;
  final Uint8List bytes;

  const TestImage(
      {required this.width, required this.height, required this.bytes});

  static Future<TestImage> loadFromAsset(String assetName) async {
    final bytes = (await rootBundle.load(assetName)).buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    final result =
        TestImage(width: image.width, height: image.height, bytes: bytes);
    image.dispose();
    return result;
  }
}
