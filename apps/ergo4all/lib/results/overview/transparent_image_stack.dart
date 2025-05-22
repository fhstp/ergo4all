import 'package:common/func_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

@immutable
class _StackImage {
  const _StackImage({required this.bytes, required this.image});

  final Uint8List bytes;
  final img.Image image;
}

class _TransparentImageStackState extends State<TransparentImageStack> {
  IList<_StackImage> images = const IList.empty();
  final List<GlobalKey> _imageKeys = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadImages();
    _imageKeys
        .addAll(List.generate(widget.imagePaths.length, (_) => GlobalKey()));
  }

  Future<void> _loadImages() async {
    final images = await widget.imagePaths.map((path) async {
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();
      final image = await compute(_decodeImage, bytes);
      return _StackImage(bytes: bytes, image: image!);
    }).pipe(Future.wait);

    setState(() {
      this.images = images.toIList();
    });
  }

  static img.Image? _decodeImage(Uint8List data) {
    return img.decodePng(data);
  }

  void _handleTap(TapDownDetails details) {
    for (var i = _imageKeys.length - 1; i >= 0; i--) {
      final key = _imageKeys[i];
      final decoded = images[i].image;

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
        children: List.generate(images.length, (index) {
          return Image.memory(
            images[index].bytes,
            key: _imageKeys[index],
            fit: BoxFit.contain,
          );
        }),
      ),
    );
  }
}
