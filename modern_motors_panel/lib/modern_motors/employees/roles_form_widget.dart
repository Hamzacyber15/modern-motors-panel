import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/role_model.dart';
import 'package:modern_motors_panel/model/product_models/category_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';

class RoleFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final RoleModel? roleModel;
  final bool isEdit;

  const RoleFormWidget({
    super.key,
    this.onBack,
    this.roleModel,
    required this.isEdit,
  });

  @override
  State<RoleFormWidget> createState() => _RoleFormWidgetState();
}

class _RoleFormWidgetState extends State<RoleFormWidget> {
  final TextEditingController _roleNameController = TextEditingController();
  GlobalKey<FormState> addCategoryKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  bool status = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.roleModel != null) {
      final roles = widget.roleModel!;
      _roleNameController.text = roles.name;
      status = roles.status == 'active' ? true : false;
    }
  }

  void _submitCategory() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final catData = CategoryModel(
        name: _roleNameController.text,
        status: status ? 'active' : 'inactive',
      );

      if (widget.isEdit && widget.roleModel?.id != null) {
        await FirebaseFirestore.instance
            .collection('roles')
            .doc(widget.roleModel!.id)
            .update(catData.toMapForUpdate())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Role updated successfully'.tr());
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Failed to update role: $error',
              );
            });
      } else {
        await FirebaseFirestore.instance
            .collection('roles')
            .add(catData.toMapForAdd())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Role added successfully'.tr());
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add category: $error');
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong'.tr());
      }
    } finally {
      loading.value = false;
    }
  }

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, minWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.h,
            AlertDialogHeader(
              title: widget.isEdit ? 'Update Role'.tr() : 'New Role'.tr(),
            ),
            22.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: addCategoryKey,
                child: CustomMmTextField(
                  isHeadingAvailable: true,
                  heading: 'Role'.tr(),
                  labelText: 'Enter Role'.tr(),
                  hintText: 'Enter Role'.tr(),
                  controller: _roleNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ValidationUtils.validateCategoryName,
                ),
              ),
            ),
            16.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StatusSwitchWidget(
                isSwitched: status,
                onChanged: toggleSwitch,
              ),
            ),
            22.h,
            AlertDialogBottomWidget(
              title: widget.isEdit
                  ? 'Update Role'.tr()
                  : 'Create New Role'.tr(),
              onCreate: () {
                if (addCategoryKey.currentState!.validate()) {
                  _submitCategory();
                }
              },
              loadingNotifier: loading,
            ),
            22.h,
          ],
        ),
      ),
    );
  }
}
