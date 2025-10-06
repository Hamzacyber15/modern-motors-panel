import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatelessWidget {
  final Function(String) onChanged;
  final String? hintText;
  const SearchBox({super.key, required this.onChanged, this.hintText});

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 40),
      child: TextField(
        onChanged: onChanged,
        style: AppTheme.getCurrentTheme(
          false,
          connectionStatus,
        ).textTheme.bodyMedium!.copyWith(color: AppTheme.blackColor),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText ?? 'Search',
          hintStyle: AppTheme.getCurrentTheme(
            false,
            connectionStatus,
          ).textTheme.bodyMedium!.copyWith(color: AppTheme.greyColor),
          prefixIcon: Transform.scale(
            scale: 0.4,
            child: Image.asset(
              'assets/images/search.png',
              color: AppTheme.greyColor,
            ),
          ),
          fillColor: AppTheme.whiteColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0.8, color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0.8, color: AppTheme.primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0.8, color: AppTheme.borderColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 4,
          ),
        ),
      ),
    );
  }
}
