import 'dart:ui';

import 'package:camera/camera.dart';

/// Gets the size of a [CameraImage] but rotates it so width and height match
/// the device orientation.
Size getRotatedImageSize(CameraImage image) {
  // For some reason, the width and height in the image are flipped in
  // portrait mode.
  // So in order for the math in following code to be correct, we need
  // to flip it back.
  // This might be an issue if we ever allow landscape mode. Then we
  // would need to use some dynamic logic to determine the image orientation.
  return Size(image.height.toDouble(), image.width.toDouble());
}
