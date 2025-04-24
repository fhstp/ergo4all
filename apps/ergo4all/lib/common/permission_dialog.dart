import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Shows a dialog to ask users to grant the given [permission]. The returned
/// [Future] completes with `true` if the permission was granted or `false`
/// otherwise.
///
/// If the permission is already granted no dialog opens and `true` is
/// returned right away.
Future<bool> showPermissionDialog(
  BuildContext context,
  Permission permission, {
  required String header,
}) async {
  final originalPermission = await permission.status;

  if (originalPermission.isGranted) return true;

  if (!context.mounted) return false;
  final isGranted = await showDialog<bool>(
    context: context,
    builder: (context) {
      final localizations = AppLocalizations.of(context)!;

      return AlertDialog(
        title: Text(header),
        actions: [
          if (originalPermission.isDenied)
            TextButton(
              onPressed: () async {
                final newPermission = await permission.request();
                if (!context.mounted) return;
                if (newPermission.isGranted) Navigator.pop(context, true);
              },
              child: Text(
                localizations.permission_label_allow,
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
                localizations.permission_label_denied,
                textAlign: TextAlign.end,
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              localizations.permission_label_cancel,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    },
  );
  return isGranted ?? false;
}
