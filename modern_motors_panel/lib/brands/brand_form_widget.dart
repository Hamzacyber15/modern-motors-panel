import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';

class BrandFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final BrandModel? brandModel;
  final bool isEdit;

  const BrandFormWidget({
    super.key,
    this.onBack,
    this.brandModel,
    required this.isEdit,
  });

  @override
  State<BrandFormWidget> createState() => _BrandFormWidgetState();
}

class _BrandFormWidgetState extends State<BrandFormWidget> {
  final TextEditingController _brandNameControllerWidget =
      TextEditingController();
  GlobalKey<FormState> addBrandKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  bool status = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.brandModel != null) {
      final brand = widget.brandModel!;
      _brandNameControllerWidget.text = brand.name;
      status = brand.status == 'active' ? true : false;
    }
  }

  void _submitBrand() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final brand = BrandModel(
        name: _brandNameControllerWidget.text.trim(),
        status: status ? 'active' : 'inactive',
      );

      if (widget.isEdit && widget.brandModel?.id != null) {
        await FirebaseFirestore.instance
            .collection('brand')
            .doc(widget.brandModel!.id)
            .update(brand.toMapForUpdate())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Brand updated successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              debugPrint('Failed to update category: $error');
              Constants.showMessage(
                context,
                'Failed to update category: $error',
              );
            });
      } else {
        await FirebaseFirestore.instance
            .collection('brand')
            .add(brand.toMapForAdd())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Brand added successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add brand: $error');
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong');
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
              title: widget.isEdit ? 'Update Brand' : 'New Brand',
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: addBrandKey,
                child: CustomMmTextField(
                  labelText: 'Enter Brand Name',
                  hintText: 'Enter Brand Name',
                  controller: _brandNameControllerWidget,
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
              title: widget.isEdit ? 'Update Brand' : 'New Brand',
              onCreate: () {
                if (addBrandKey.currentState!.validate()) {
                  _submitBrand();
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
