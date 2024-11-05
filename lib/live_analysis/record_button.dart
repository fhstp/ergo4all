import 'package:flutter/material.dart';

/// A record button widget. It is a text-less button that switches between the record and stop icon depending on the [RecordButton.isRecording] parameter.
class RecordButton extends StatelessWidget {
  /// Whether we are currently recording.
  final bool isRecording;

  /// The size of the button. The button has a square size so this value is used for both dimensions.
  final double size;
  final double iconSize;

  ///The function to call when the button is tapped.
  final void Function() onTap;

  const RecordButton(
      {super.key,
      required this.isRecording,
      required this.onTap,
      this.size = 80.0})
      : iconSize = size * 0.75;

  @override
  Widget build(BuildContext context) {
    final icon = isRecording
        ? Icon(
            Icons.stop,
            color: Colors.black,
            size: iconSize,
          )
        : Icon(
            Icons.fiber_manual_record,
            color: Colors.red,
            size: iconSize,
          );

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Material(
          color: Colors.grey,
          child: InkWell(
            onTap: onTap,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
