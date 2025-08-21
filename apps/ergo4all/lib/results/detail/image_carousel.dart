import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

/// Image carousel to display key frames
class ImageCarousel extends StatelessWidget {

  const ImageCarousel({
    Key? key,
    required this.images,
    this.borderRadius = 8,
    this.onPageChanged,
  }) : super(key: key);

  final List<Uint8List> images;
  final double borderRadius;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
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
            showDialog(
              context: context,
              builder: (_) => Dialog(
                backgroundColor: Colors.transparent,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: InteractiveViewer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Image.memory(
                        image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
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
