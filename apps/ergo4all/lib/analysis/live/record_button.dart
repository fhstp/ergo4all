import 'package:common_ui/theme/colors.dart';
import 'package:flutter/material.dart';

/// A record button widget. It is a text-less button that switches between the
/// record and stop icon depending on the [RecordButton.isRecording] parameter.
class RecordButton extends StatelessWidget {
  /// Creates a [RecordButton].
  const RecordButton({
    required this.isRecording,
    required this.onTap,
    super.key,
    this.size = 61,
  }) : iconSize = size * 0.75;

  /// Whether we are currently recording.
  final bool isRecording;

  /// The size of the button. The button has a square size so this value is
  /// used for both dimensions.
  final double size;

  /// The size of the icon inside the button. Should be less than [size].
  /// The icon is square and will use this size for both dimensions.
  final double iconSize;

  ///The function to call when the button is tapped.
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final icon = isRecording
        ? Icon(
            Icons.stop,
            color: woodSmoke,
            size: iconSize,
          )
        : Icon(
            Icons.fiber_manual_record,
            color: persimmon,
            size: iconSize,
          );

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Material(
          color: heather,
          child: InkWell(
            onTap: onTap,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
