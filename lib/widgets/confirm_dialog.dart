import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../sagax_theme.dart';

/// Yes/no dialog styled for the platform (Cupertino on Apple platforms).
/// Resolves to true only when the player confirms.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final platform = Theme.of(context).platform;
  final cupertino =
      platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

  Widget action(BuildContext ctx, String label, bool result) {
    final isConfirm = result;
    if (cupertino) {
      return CupertinoDialogAction(
        onPressed: () => Navigator.pop(ctx, result),
        isDestructiveAction: isConfirm && destructive,
        isDefaultAction: !isConfirm,
        child: Text(label),
      );
    }
    return TextButton(
      onPressed: () => Navigator.pop(ctx, result),
      style: TextButton.styleFrom(
        foregroundColor: isConfirm && destructive
            ? AppColors.errorRed
            : AppColors.electricCyan,
      ),
      child: Text(label),
    );
  }

  final result = await showAdaptiveDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog.adaptive(
      backgroundColor: cupertino ? null : AppColors.cardDark,
      title: Text(title),
      content: Text(message),
      actions: [
        action(ctx, cancelLabel, false),
        action(ctx, confirmLabel, true),
      ],
    ),
  );
  return result == true;
}
