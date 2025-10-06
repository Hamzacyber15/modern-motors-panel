import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class AlertDialogHeader extends StatelessWidget {
  final String title;

  const AlertDialogHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.getCurrentTheme(
              false,
              connectionStatus,
            ).textTheme.displayMedium,
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconAsset: 'assets/images/cross.png',
              buttonType: ButtonType.IconOnly,
              borderColor: AppTheme.borderColor,
              backgroundColor: AppTheme.redColor,
              iconColor: AppTheme.whiteColor,
              iconSize: 10,
              borderRadius: 100,
            ),
          ),
        ],
      ),
    );
  }
}
