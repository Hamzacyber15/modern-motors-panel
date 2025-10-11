import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

Widget requiredText() {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Text(
      'Required*',
      style: TextStyle(
        color: AppTheme.redColor,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        fontSize: 10,
      ),
    ),
  );
}
