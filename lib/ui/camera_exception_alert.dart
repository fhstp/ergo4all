import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum CameraExceptionHandleActions { tryAgain, closeApp }

const _denied = "CameraAccessDenied";
const _deniedNoPrompt = "CameraAccessDeniedWithoutPrompt";
const _restricted = "CameraAccessRestricted";

Future<CameraExceptionHandleActions?> showCameraExceptionAlert(
    BuildContext context, CameraException ex) async {
  // TODO: Localize

  final String solution = switch (ex.code) {
    _denied =>
      "You can't use the app without granting camera permissions! Please allow the use of the camera.",
    _deniedNoPrompt =>
      "You can't use the app without granting camera permissions! Please allow the use of the camera under 'Settings > Privacy > Camera'.",
    _restricted =>
      "Seems like the camera is disabled on this device, for example by parental control.",
    _ => throw ArgumentError.value(ex, "ex", "Unhandled error code")
  };

  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Camera access denied!'),
        content: Text(solution),
        actions: [
          if (ex.code == _denied)
            TextButton(
              child: const Text('Try again'),
              onPressed: () {
                Navigator.of(context)
                    .pop(CameraExceptionHandleActions.tryAgain);
              },
            ),
          TextButton(
            child: const Text('Close app'),
            onPressed: () {
              Navigator.of(context).pop(CameraExceptionHandleActions.closeApp);
            },
          ),
        ],
      );
    },
  );
}
