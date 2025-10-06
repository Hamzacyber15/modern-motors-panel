import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';

class AlertDialogBottomWidget extends StatelessWidget {
  final VoidCallback onCreate;
  final String title;
  final ValueNotifier<bool>? loadingNotifier;
  final double buttonWidget;
  final VoidCallback? onCancel;

  const AlertDialogBottomWidget({
    super.key,
    required this.title,
    required this.onCreate,
    required this.loadingNotifier,
    this.buttonWidget = 0.22,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: context.height * 0.06,
            width: context.height * 0.22,
            child: CustomButton(
              text: 'Cancel'.tr(),
              onPressed:
                  onCancel ??
                  () {
                    Navigator.of(context).pop();
                  },
              fontSize: 14,
              buttonType: ButtonType.Bordered,
              borderColor: AppTheme.redColor,
              textColor: AppTheme.redColor,
            ),
          ),
          10.w,
          SizedBox(
            height: context.height * 0.06,
            width: context.height * buttonWidget,
            child: CustomButton(
              loadingNotifier: loadingNotifier,
              text: title,
              onPressed: onCreate,
              fontSize: 14,
              buttonType: ButtonType.Filled,
              backgroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
