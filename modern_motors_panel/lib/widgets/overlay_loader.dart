// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

class OverlayLoader extends StatelessWidget {
  final Widget child;
  final bool loader;

  const OverlayLoader({super.key, required this.child, required this.loader});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loader)
          Positioned.fill(
            child: AbsorbPointer(
              // prevent user interactions
              absorbing: true,
              child: Container(
                color: Colors.black.withOpacity(
                  0.05,
                ), // semi-transparent background
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
