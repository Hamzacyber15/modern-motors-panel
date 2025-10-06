import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final String? iconPath;
  final Color? color;

  const PrimaryButton({
    super.key,
    this.label,
    this.onPressed,
    this.iconPath,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hasIcon = iconPath != null && iconPath!.isNotEmpty;
    final hasLabel = label != null && label!.trim().isNotEmpty;

    Widget? leadingIcon;
    if (hasIcon) {
      leadingIcon = Image.asset(
        iconPath!,
        width: 16,
        height: 16,
        color: AppTheme.whiteColor,
      );
    }

    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppTheme.primaryColor,
          disabledBackgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: hasIcon && hasLabel
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  leadingIcon!,
                  const SizedBox(width: 8),
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.whiteColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : hasIcon
            ? leadingIcon!
            : Text(
                label ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.whiteColor,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }
}
