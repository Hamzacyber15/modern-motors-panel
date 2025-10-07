import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';

class SubCategoryFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final ProductSubCategoryModel? subCategoryModel;
  final bool isEdit;

  const SubCategoryFormWidget({
    super.key,
    this.onBack,
    this.subCategoryModel,
    required this.isEdit,
  });

  @override
  State<SubCategoryFormWidget> createState() => _SubCategoryFormWidgetState();
}

class _SubCategoryFormWidgetState extends State<SubCategoryFormWidget> {
  final TextEditingController _subCategoryNameController =
      TextEditingController();
  GlobalKey<FormState> addCategoryKey = GlobalKey<FormState>();
  List<ProductCategoryModel> _categories = [];
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  String? _selectedCategoryId;
  bool status = true;
  List<MapEntry<String, String>> _selectedCategoryList = [];
  final List<MapEntry<String, String>> _removedCategoryList = [];

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
    final productCategories = await DataFetchService.fetchProduct();
    setState(() {
      _categories = productCategories;

      if (widget.isEdit && widget.subCategoryModel != null) {
        final category = widget.subCategoryModel!;
        _subCategoryNameController.text = category.name;
        status = category.status == 'active';

        _selectedCategoryList = [];

        if (category.catId != null && category.catId!.isNotEmpty) {
          for (final id in category.catId!) {
            final matched = _categories.firstWhere(
              (c) => c.id == id,
              orElse: () => ProductCategoryModel(productName: ''),
            );
            if (matched.id != null && matched.productName.isNotEmpty) {
              _selectedCategoryList.add(
                MapEntry(matched.id!, matched.productName),
              );
            }
          }
        }
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
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final selectedCategoryIds = _selectedCategoryList
          .map((e) => e.key)
          .toList();
      final catData = ProductSubCategoryModel(
        name: _subCategoryNameController.text,
        catId: selectedCategoryIds,
        status: status ? 'active' : 'inactive',
      );

      if (widget.isEdit && widget.subCategoryModel?.id != null) {
        batch.update(
          FirebaseFirestore.instance
              .collection('subCategory')
              .doc(widget.subCategoryModel!.id),
          catData.toMapForUpdate(),
        );

        for (var categoryEntry in _selectedCategoryList) {
          final categoryDocId = categoryEntry.key;

          batch.update(
            FirebaseFirestore.instance
                .collection('productsCategory')
                .doc(categoryDocId),
            {
              'subCategories': FieldValue.arrayUnion([
                widget.subCategoryModel!.id,
              ]),
            },
          );
        }

        if (_removedCategoryList.isNotEmpty) {
          for (var removedEntry in _removedCategoryList) {
            final removedCategoryDocId = removedEntry.key;

            batch.update(
              FirebaseFirestore.instance
                  .collection('productsCategory')
                  .doc(removedCategoryDocId),
              {
                'subCategories': FieldValue.arrayRemove([
                  widget.subCategoryModel!.id,
                ]),
              },
            );
          }
        }

        await batch.commit().then((_) {
          if (!mounted) return;
          Constants.showMessage(
            context,
            'Sub Category updated successfully'.tr(),
          );
          widget.onBack?.call();
          Navigator.of(context).pop();
        });
      } else {
        String subCatDocId = FirebaseFirestore.instance
            .collection('subCategory')
            .doc()
            .id;
        batch.set(
          FirebaseFirestore.instance.collection('subCategory').doc(subCatDocId),
          catData.toMapForAdd(),
        );

        for (var categoryEntry in _selectedCategoryList) {
          final categoryDocId = categoryEntry.key;

          batch.update(
            FirebaseFirestore.instance
                .collection('productsCategory')
                .doc(categoryDocId),
            {
              'subCategories': FieldValue.arrayUnion([subCatDocId]),
            },
          );
        }

        await batch.commit().then((value) {
          if (!mounted) return;
          Constants.showMessage(
            context,
            'Sub Category added successfully'.tr(),
          );
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
                    ? 'Update Sub Category'.tr()
                    : 'New Sub Category'.tr(),
              ),
              22.h,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: addCategoryKey,
                  child: Column(
                    children: [
                      if (_selectedCategoryList.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedCategoryList
                              .map(
                                (entry) => Chip(
                                  label: Text(entry.value),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedCategoryList.remove(entry);
                                      _removedCategoryList.add(entry);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      8.h,
                      CustomSearchableDropdown(
                        isMultiSelect: true,
                        selectedValues: _selectedCategoryList
                            .map((e) => e.key)
                            .toList(),
                        key: const ValueKey('category_dropdown'),
                        hintText: 'Choose Category'.tr(),
                        value: _selectedCategoryId,
                        items: {
                          for (var c in _categories) c.id!: c.productName,
                        },
                        onMultiChanged: (selectedItems) {
                          setState(() {
                            _selectedCategoryList = selectedItems;
                          });
                        },
                        onChanged: (_) {},
                      ),
                      10.h,
                      CustomMmTextField(
                        labelText: 'Enter Sub Category Name'.tr(),
                        hintText: 'Enter Sub Category Name'.tr(),
                        controller: _subCategoryNameController,
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
                    ? 'Update Sub-Category'.tr()
                    : 'New Sub-Category'.tr(),
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
