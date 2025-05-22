import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// A stack of images with transparent parts. The difference to a regular
/// [Stack] of [Image] is that this widget does transparency-respecting
/// hit testing, ie. only opaque parts of the image are tappable.
class TransparentImageStack extends StatefulWidget {
  ///
  const TransparentImageStack({
    required this.imagePaths,
    required this.onTaps,
    super.key,
  });

  /// List of paths of the images to display.
  final List<String> imagePaths;

  /// List of callbacks for when images are tapped. These are analogous
  /// to the [imagePaths] list.
  final List<VoidCallback> onTaps;

  @override
  State<TransparentImageStack> createState() => _TransparentImageStackState();
}

class _TransparentImageStackState extends State<TransparentImageStack> {
  final List<img.Image?> _decodedImages = [];
  final List<GlobalKey> _imageKeys = [];

  @override
  void initState() {
    super.initState();
    _loadAllImages();
    _imageKeys
        .addAll(List.generate(widget.imagePaths.length, (_) => GlobalKey()));
  }

  Future<void> _loadAllImages() async {
    for (final path in widget.imagePaths) {
      final bytes = await rootBundle.load(path);
      final list = bytes.buffer.asUint8List();
      final decoded = await compute(_decodeImage, list);
      _decodedImages.add(decoded);
    }
    setState(() {}); // Ensure images are shown
  }

  static img.Image? _decodeImage(Uint8List data) {
    return img.decodePng(data);
  }

  void _handleTap(TapDownDetails details) {
    for (var i = _imageKeys.length - 1; i >= 0; i--) {
      final key = _imageKeys[i];
      final decoded = _decodedImages[i];
      if (decoded == null) continue;

      final ctx = key.currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject()! as RenderBox;
      final localPos = box.globalToLocal(details.globalPosition);
      final size = box.size;

      final dx = (localPos.dx * decoded.width / size.width).toInt();
      final dy = (localPos.dy * decoded.height / size.height).toInt();

      if (dx >= 0 && dx < decoded.width && dy >= 0 && dy < decoded.height) {
        final pixel = decoded.getPixelSafe(dx, dy);
        final alpha = pixel.a;
        if (alpha > 10) {
          widget.onTaps[i](); // Found opaque pixel
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _handleTap,
      child: Stack(
        children: List.generate(widget.imagePaths.length, (index) {
          return Image.asset(
            widget.imagePaths[index],
            key: _imageKeys[index],
            fit: BoxFit.contain,
          );
        }),
      ),
    );
  }
}
