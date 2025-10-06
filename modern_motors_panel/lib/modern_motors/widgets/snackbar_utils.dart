import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

class SnackbarUtils {
  static void showSnackbar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppTheme.primaryColor,
      ),
    );
  }
}
