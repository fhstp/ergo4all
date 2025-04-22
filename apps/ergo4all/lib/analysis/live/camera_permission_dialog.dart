import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Shows a dialog to ask users to grant camera permissions. The returned
/// [Future] completes with `true` if the permission was granted or `false`
/// otherwise.
///
/// If the permission is already granted no dialog opens and `true` is
/// returned right away.
Future<bool> showCameraPermissionDialog(BuildContext context) async {
  final originalPermission = await Permission.camera.status;
  final localizations = AppLocalizations.of(context)!;

  if (originalPermission.isGranted) return true;

  if (!context.mounted) return false;
  final isGranted = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(localizations.permission_camera_text),
        actions: [
          if (originalPermission.isDenied)
            TextButton(
              onPressed: () async {
                final newPermission = await Permission.camera.request();
                if (!context.mounted) return;
                if (newPermission.isGranted) Navigator.pop(context, true);
              },
              child: Text(
                localizations.permission_camera_label_allow,
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
              child: Text(
                localizations.permission_camera_label_denied,
                textAlign: TextAlign.end,
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              localizations.permission_camera_label_cancel,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    },
  );
  return isGranted ?? false;
}
