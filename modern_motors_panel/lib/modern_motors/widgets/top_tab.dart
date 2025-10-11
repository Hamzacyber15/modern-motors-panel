import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';

Widget topTab({
  required VoidCallback onTap,
  required IconData icon,
  required String title,
  Color? color,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: color != null ? 6 : 2,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: color != null ? Colors.transparent : AppTheme.borderColor,
        ),
        color: color ?? Colors.white,
      ),
      child: Row(children: [Icon(icon, size: 16), 2.w, Text(title)]),
    ),
  );
}
