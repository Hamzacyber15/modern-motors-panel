import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/product_models/category_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';

class AddEditUnitWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final UnitModel? unitModel;
  final bool isEdit;

  const AddEditUnitWidget({
    super.key,
    this.onBack,
    this.unitModel,
    required this.isEdit,
  });

  @override
  State<AddEditUnitWidget> createState() => _AddEditUnitWidgetState();
}

class _AddEditUnitWidgetState extends State<AddEditUnitWidget> {
  final TextEditingController _unitNameController = TextEditingController();
  GlobalKey<FormState> addCategoryKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  bool status = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.unitModel != null) {
      final units = widget.unitModel!;
      _unitNameController.text = units.name;
      status = units.status == 'active' ? true : false;
    }
  }

  void _submitCategory() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final catData = CategoryModel(
        name: _unitNameController.text,
        status: status ? 'active' : 'inactive',
      );

      if (widget.isEdit && widget.unitModel?.id != null) {
        await FirebaseFirestore.instance
            .collection('unit')
            .doc(widget.unitModel!.id)
            .update(catData.toMapForUpdate())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Unit updated successfully'.tr());
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
            .collection('unit')
            .add(catData.toMapForAdd())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Unit added successfully'.tr());
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add Unit: $error');
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
              title: widget.isEdit ? 'Update Unit'.tr() : 'New Unit'.tr(),
            ),
            22.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: addCategoryKey,
                child: CustomMmTextField(
                  isHeadingAvailable: true,
                  heading: 'Unit'.tr(),
                  labelText: 'Enter Unit'.tr(),
                  hintText: 'Enter Unit'.tr(),
                  controller: _unitNameController,
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
                  ? 'Update Unit'.tr()
                  : 'Create New Unit'.tr(),
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
