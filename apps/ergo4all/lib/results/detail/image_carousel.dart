import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

/// Image carousel to display key frames
class ImageCarousel extends StatelessWidget {
  ///
  const ImageCarousel({
    required this.images,
    super.key,
    this.onPageChanged,
  });

  static const double _borderRadius = 8;

  /// The images to display in the carousel
  final List<Uint8List> images;

  /// Callback for when the carousel was swiped/turned.
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    void showImageDisplayDialogFor(Uint8List image) {
      showDialog<void>(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_borderRadius),
                child: Image.memory(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        viewportFraction: 0.6,
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          onPageChanged?.call(index);
        },
      ),
      items: images.map((Uint8List image) {
        return GestureDetector(
          onTap: () {
            showImageDisplayDialogFor(image);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Image.memory(
              image,
              fit: BoxFit.fill,
              height: 250,
            ),
          ),
        );
      }).toList(),
    );
  }
}
