// lib/widgets/custom_dropdown_ui_builder.dart

// ignore_for_file: deprecated_member_use

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/drop_down_controller_provider.dart';
import 'package:provider/provider.dart';

typedef ToggleDropdown = void Function(FormFieldState field);

Widget buildDropdownUI({
  required BuildContext context,
  required FormFieldState field,
  required String displayText,
  required LayerLink layerLink,
  required ToggleDropdown toggleDropdown,
  required bool showDropdown,
  required String hintText,
  required double verticalPadding,
}) {
  ConnectivityResult connectionStatus = context
      .watch<ConnectivityProvider>()
      .connectionStatus;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CompositedTransformTarget(
        link: layerLink,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final dropdownController = Provider.of<DropdownControllerProvider>(
              context,
              listen: false,
            );
            dropdownController.registerActiveDropdown(
              () {},
            ); // You can pass your own _removeOverlay
            toggleDropdown(field); // ← Call passed function
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: field.hasError
                    ? Colors.red
                    : showDropdown
                    ? AppTheme.primaryColor
                    : AppTheme.borderColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.getCurrentTheme(false, connectionStatus)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                          fontSize: displayText == hintText ? 12 : 14,
                          fontWeight: displayText == hintText
                              ? FontWeight.w400
                              : FontWeight.w600,
                          color: AppTheme.primaryColor.withOpacity(0.1),
                        ),
                  ),
                ),
                Icon(
                  showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
      ),
      if (field.hasError)
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 8),
          child: Text(
            field.errorText!,
            style: AppTheme.getCurrentTheme(
              false,
              connectionStatus,
            ).textTheme.bodySmall!.copyWith(color: Colors.red),
          ),
        ),
    ],
  );
}
