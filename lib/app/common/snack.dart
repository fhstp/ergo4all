import 'package:ergo4all/app/common/spacing.dart';
import 'package:flutter/material.dart';

/// Shows a [SnackBar] with a specific error message. The snackbar will be
/// styled using error colors.
void showErrorSnackbar(BuildContext context, String errorMessage) {
  final theme = Theme.of(context);
  final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.sentiment_dissatisfied_outlined,
            color: theme.colorScheme.onError,
          ),
          const SizedBox(
            width: smallSpace,
          ),
          Text(
            errorMessage,
            style: theme.snackBarTheme.contentTextStyle
                ?.copyWith(color: theme.colorScheme.onError),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.error);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// Show a [SnackBar] informing the user that a feature that they attempted
/// to use is not implemented.
void showNotImplementedSnackbar(BuildContext context) {
  showErrorSnackbar(context, "Sorry. This feature is not implemented yet!");
}
