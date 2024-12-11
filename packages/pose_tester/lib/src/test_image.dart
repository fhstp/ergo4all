import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class TestImage {
  final int width;
  final int height;
  final AssetImage asset;

  const TestImage(
      {required this.width, required this.height, required this.asset});

  static Future<TestImage> loadFromAsset(String assetName) async {
    final asset = AssetImage(assetName);
    final bytes = await rootBundle.load(assetName);
    final image = await decodeImageFromList(bytes.buffer.asUint8List());
    final result =
        TestImage(width: image.width, height: image.height, asset: asset);
    image.dispose();
    return result;
  }
}
