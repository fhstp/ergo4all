import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> showCameraPermissionDialog(BuildContext context) async {
  final originalPermission = await Permission.camera.status;
  if (originalPermission.isGranted) return true;

  if (!context.mounted) return false;
  final isGranted = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Camera permission not granted'),
        actions: [
          if (originalPermission.isDenied)
            TextButton(
              onPressed: () async {
                final newPermission = await Permission.camera.request();
                if (!context.mounted) return;
                if (newPermission.isGranted) Navigator.pop(context, true);
              },
              child: const Text(
                'Grant permission',
                textAlign: TextAlign.end,
              ),
            ),
          if (originalPermission.isPermanentlyDenied)
            TextButton(
              onPressed: () async {
                await openAppSettings();
                if (!context.mounted) return;
                Navigator.pop(context, false);
              },
              child: const Text(
                'Grant permission in settings',
                textAlign: TextAlign.end,
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              'Cancel',
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    },
  );
  return isGranted ?? false;
}
