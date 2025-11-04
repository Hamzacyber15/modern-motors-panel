import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/purchase_models/expense_category_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../provider/resource_provider.dart';

class ExpenseCategoryFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final ExpenseCategoryModel? expenseCategoryModel;
  final bool isEdit;

  const ExpenseCategoryFormWidget({
    super.key,
    this.onBack,
    this.expenseCategoryModel,
    required this.isEdit,
  });

  @override
  State<ExpenseCategoryFormWidget> createState() =>
      _SubCategoryFormWidgetState();
}

class _SubCategoryFormWidgetState extends State<ExpenseCategoryFormWidget> {
  final TextEditingController categoryNameController = TextEditingController();
  GlobalKey<FormState> addCategoryKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    if (catLoader.value) {
      return;
    }

    catLoader.value = true;
    setState(() {
      if (widget.isEdit && widget.expenseCategoryModel != null) {
        final category = widget.expenseCategoryModel!;
        categoryNameController.text = category.name;
        status = category.status == 'active';
      }
    });
    catLoader.value = false;
  }

  void _submitCategory() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final provider = context.read<ResourceProvider>();
      String code;
      if (widget.isEdit && widget.expenseCategoryModel != null) {
        userId = widget.expenseCategoryModel?.createdBy ?? userId;
        code = widget.expenseCategoryModel!.code ?? '';
      } else {
        code = await Constants.getUniqueNumber("EC");
        if (code.isEmpty) {
          code = await Constants.getUniqueNumber("EC");
        }
      }

      WriteBatch batch = FirebaseFirestore.instance.batch();

      final catData = ExpenseCategoryModel(
        name: categoryNameController.text,
        status: status ? 'active' : 'inactive',
        createdBy: userId,
        code: code,
      );

      if (widget.isEdit && widget.expenseCategoryModel?.id != null) {
        batch.update(
          FirebaseFirestore.instance
              .collection('expenseCategory')
              .doc(widget.expenseCategoryModel!.id),
          catData.toMapForUpdate(),
        );

        await batch.commit().then((_) {
          if (!mounted) return;
          Constants.showMessage(
            context,
            'Sub Category updated successfully'.tr(),
          );
          provider.updateExpenseCategory(
            id: widget.expenseCategoryModel!.id,
            model: catData,
          );
          widget.onBack?.call();
          Navigator.of(context).pop();
        });
      } else {
        String subCatDocId = FirebaseFirestore.instance
            .collection('expenseCategory')
            .doc()
            .id;
        catData.id = subCatDocId;
        batch.set(
          FirebaseFirestore.instance
              .collection('expenseCategory')
              .doc(subCatDocId),
          catData.toMapForAdd(),
        );

        await batch.commit().then((value) {
          if (!mounted) return;
          Constants.showMessage(
            context,
            'Sub Category added successfully'.tr(),
          );
          provider.updateExpenseCategory(model: catData);
          widget.onBack?.call();
          Navigator.of(context).pop();
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
    return OverlayLoader(
      loader: catLoader.value,
      child: Container(
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
                title: widget.isEdit
                    ? 'Update Category'.tr()
                    : 'New Category'.tr(),
              ),
              22.h,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: addCategoryKey,
                  child: Column(
                    children: [
                      CustomMmTextField(
                        labelText: 'Enter Expense Category Name'.tr(),
                        hintText: 'Enter Expense Category Name'.tr(),
                        controller: categoryNameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: ValidationUtils.validateCategoryName,
                      ),
                    ],
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
                buttonWidget: 0.26,
                title: widget.isEdit
                    ? 'Update Category'.tr()
                    : 'New Category'.tr(),
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
      ),
    );
  }
}
