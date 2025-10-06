import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class SetDefaultValueButtonWidget extends StatefulWidget {
  final String? permissionAccess;
  final VoidCallback onPress;
  final ValueNotifier<bool>? loadingNotifier;
  final String status;
  const SetDefaultValueButtonWidget({
    super.key,
    required this.onPress,
    this.permissionAccess,
    this.loadingNotifier,
    required this.status,
  });

  @override
  State<SetDefaultValueButtonWidget> createState() =>
      _SetDefaultValueButtonWidgetState();
}

class _SetDefaultValueButtonWidgetState
    extends State<SetDefaultValueButtonWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MmResourceProvider>(context, listen: false);
    provider.listenToEmployee(user!.uid);
    // provider.listenToEmployee("O4cq5T5khYsyePxfA9Bd");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, value, child) {
        final hasPermission =
            widget.permissionAccess == null ||
            (value.employeeModel?.profileAccessKey?.contains(
                  widget.permissionAccess,
                ) ??
                false) ||
            user!.uid == Constants.adminId;
        return CustomButton(
          width: 100,
          loadingNotifier: widget.loadingNotifier,
          buttonType: ButtonType.Bordered,
          borderRadius: 20,
          borderColor: widget.status == "active"
              ? AppTheme.grey
              : AppTheme.primaryColor,
          textColor: widget.status == "active"
              ? AppTheme.grey
              : AppTheme.primaryColor,
          onPressed: hasPermission
              ? widget.onPress
              : () {
                  Constants.showMessage(
                    context,
                    'You do not have permission to perform this action.',
                  );
                },
          text: widget.status == "active" ? 'Set Default' : 'Default',
        );
      },
    );
  }
}
