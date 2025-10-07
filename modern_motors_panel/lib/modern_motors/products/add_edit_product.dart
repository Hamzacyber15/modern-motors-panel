import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class AddEditProduct extends StatefulWidget {
  final VoidCallback? onBack;
  final ProductModel? productModel;
  final bool isEdit;

  const AddEditProduct({
    super.key,
    this.onBack,
    this.productModel,
    required this.isEdit,
  });

  @override
  State<AddEditProduct> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddEditProduct> {
  final TextEditingController thresholdController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController minimumController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sellingPrice = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  List<AttachmentModel> attachments = [];
  GlobalKey<FormState> createInventoryKey = GlobalKey<FormState>();

  List<BrandModel> brands = [];
  List<ProductCategoryModel> productsCategories = [];
  List<UnitModel> units = [];
  List<ProductSubCategoryModel> subCategories = [];
  List<ProductSubCategoryModel> associatedSubCategories = [];
  String? selectedBrand;
  String? selectedBrandId;
  String? selectedUnitId;
  String? selectedProductCategoryId;
  String? selectedProductCategory;
  String? selectedSubCategoryId;
  String? selectedSubCategory;

  // double totalSalePrice = 0.0;
  double totalCostPrice = 0.0;

  bool active = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    if (catLoader.value) return;
    catLoader.value = true;
    Future.wait([
      DataFetchService.fetchUnits(),
      DataFetchService.fetchProduct(),
      DataFetchService.fetchSubCategories(),
      DataFetchService.fetchBrands(),
    ]).then((results) {
      final unitList = results[0] as List<UnitModel>;
      final productList = results[1] as List<ProductCategoryModel>;
      final subCategoriesList = results[2] as List<ProductSubCategoryModel>;
      final brandsList = results[3] as List<BrandModel>;

      setState(() {
        units = unitList;
        productsCategories = productList;
        subCategories = subCategoriesList;
        brands = brandsList;

        bool missingData = false;

        if (widget.isEdit && widget.productModel != null) {
          final product = widget.productModel!;

          thresholdController.text = product.threshold.toString();
          nameController.text = product.productName.toString();
          codeController.text = product.code.toString();
          if (product.minimumPrice != null) {
            minimumController.text = product.minimumPrice!.toStringAsFixed(2);
          }
          if (product.description != null) {
            descriptionController.text = product.description!;
          }
          if (product.sellingPrice != null) {
            sellingPrice.text = product.sellingPrice!.toStringAsFixed(3);
          }
          if (product.sku != null) {
            skuController.text = product.sku!;
          }
          if (productsCategories.any((p) => p.id == product.categoryId)) {
            selectedProductCategoryId = product.categoryId;
            associatedSubCategories = subCategories
                .where(
                  (sub) =>
                      sub.catId?.contains(selectedProductCategoryId) ?? false,
                )
                .toList();
          } else {
            selectedProductCategoryId = null;
            missingData = true;
          }

          if (associatedSubCategories.any(
            (s) => s.id == product.subCategoryId,
          )) {
            selectedSubCategoryId = product.subCategoryId;
          } else {
            selectedSubCategoryId = null;
            missingData = true;
          }

          if (brands.any((b) => b.id == product.brandId)) {
            selectedBrandId = product.brandId;
          } else {
            selectedBrandId = null;
            missingData = true;
          }
        }

        if (missingData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Constants.showMessage(
              context,
              'Some previously selected values are no longer available. Please update them.'
                  .tr(),
            );
          });
        }
      });
      catLoader.value = false;
    });
  }

  void submitProduct() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final threshold = double.tryParse(thresholdController.text.trim()) ?? 0;

      double m = double.tryParse(minimumController.text.toString()) ?? 0;
      double sp = double.tryParse(sellingPrice.text.toString()) ?? 0;
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      if (widget.isEdit && widget.productModel?.id != null) {
        List<String> urls = await Future.wait(
          attachments.map((attachment) async {
            return await Constants.uploadAttachment(attachment);
          }),
        );
        String image = "";
        if (urls.isEmpty) {
          image = widget.productModel!.image ?? "";
        } else {
          urls.first;
        }
        final addProduct = ProductModel(
          image: image,
          categoryId: selectedProductCategoryId,
          productName: nameController.text.trim(),
          status: 'active',
          brandId: selectedBrandId,
          threshold: threshold,
          code: widget.productModel!.code ?? "",
          subCategoryId: selectedSubCategoryId,
          description: descriptionController.text,
          minimumPrice: m,
          createAt: Timestamp.now(),
          createdBy: user.uid,
          sku: skuController.text,
          sellingPrice: sp,
        );
        await DataUploadService.updateProduct(
              widget.productModel!.id!,
              addProduct,
            )
            .then((_) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Product updated successfully'.tr(),
              );
              // if (widget.onBack != null) {
              //   widget.onBack!();
              // }
              widget.onBack?.call();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(
                context,
                'Failed to update inventory: $error',
              );
            });
      } else {
        List<String> urls = await Future.wait(
          attachments.map((attachment) async {
            return await Constants.uploadAttachment(attachment);
          }),
        );
        String image = "";
        if (urls.isEmpty) {
          image = "";
        } else {
          urls.first;
        }
        String businessCode = await Constants.getUniqueNumber("P");
        final addProduct = ProductModel(
          image: image,
          categoryId: selectedProductCategoryId,
          productName: nameController.text.trim(),
          status: 'active',
          brandId: selectedBrandId,
          threshold: threshold,
          code: businessCode,
          subCategoryId: selectedSubCategoryId,
          description: descriptionController.text,
          minimumPrice: m,
          createAt: Timestamp.now(),
          createdBy: user.uid,
          sku: skuController.text,
          sellingPrice: sp,
        );
        await DataUploadService.addProduct(addProduct)
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Product added successfully'.tr());
              //widget.onBack?.call();
              if (widget.onBack != null) {
                widget.onBack!();
              }
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add inventory: $error');
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong'.tr());
        debugPrint('something went wrong: $e');
      }
    } finally {
      loading.value = false;
    }
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PageHeaderWidget(
              title: 'Create Product'.tr(),
              buttonText: 'Back to Product'.tr(),
              subTitle: 'Create New Product'.tr(),
              onCreateIcon: 'assets/images/back.png',
              selectedItems: [],
              buttonWidth: 0.4,
              onCreate: widget.onBack!.call,
              onDelete: () async {},
            ),
          ),
          // catLoader.value
          //     ? LoadingWidget()
          //     :
          SliverToBoxAdapter(
            child: OverlayLoader(
              loader: catLoader.value,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderColor, width: 0.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16),
                        child: Text(
                          'Inventory Information'.tr(),
                          style: AppTheme.getCurrentTheme(
                            false,
                            connectionStatus,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Form(
                          key: createInventoryKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      key: const ValueKey(
                                        'product_category_dropdown',
                                      ),
                                      hintText: 'Choose Product Category'.tr(),
                                      value: selectedProductCategoryId,
                                      items: {
                                        for (var u in productsCategories)
                                          u.id!: u.productName,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedProductCategoryId = val;
                                        associatedSubCategories = subCategories
                                            .where(
                                              (sub) =>
                                                  sub.catId?.contains(
                                                    selectedProductCategoryId,
                                                  ) ??
                                                  false,
                                            )
                                            .toList();
                                        selectedProductCategory =
                                            productsCategories
                                                .firstWhere((u) => u.id == val)
                                                .productName;
                                        nameController.text =
                                            '$selectedProductCategory - $selectedSubCategory';
                                      }),
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      key: const ValueKey(
                                        'subcategory_dropdown',
                                      ),
                                      hintText: 'Choose Sub Category'.tr(),
                                      value: selectedSubCategoryId,
                                      items: {
                                        for (var u in associatedSubCategories)
                                          u.id!: u.name,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedSubCategoryId = val;
                                        selectedSubCategory =
                                            associatedSubCategories
                                                .firstWhere((u) => u.id == val)
                                                .name;
                                        nameController.text =
                                            '$selectedProductCategory - $selectedSubCategory';
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              14.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Product Name'.tr(),
                                      hintText: 'Name'.tr(),
                                      controller: nameController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidationUtils.productName,
                                    ),
                                  ),
                                  // 10.w,
                                  // Expanded(
                                  //   child: CustomMmTextField(
                                  //     labelText: 'Product Code'.tr(),
                                  //     hintText: 'Code'.tr(),
                                  //     controller: codeController,
                                  //     autovalidateMode:
                                  //         AutovalidateMode.onUserInteraction,
                                  //     validator: ValidationUtils.codeValidator,
                                  //   ),
                                  // ),
                                ],
                              ),
                              14.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Low Stock Threshold'.tr(),
                                      hintText: '50'.tr(),
                                      controller: thresholdController,
                                      keyboardType: TextInputType.number,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidationUtils.threshold,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Selling Price'.tr(),
                                      hintText: '10 OMR'.tr(),
                                      controller: sellingPrice,
                                      keyboardType: TextInputType.number,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      //validator: ValidationUtils.minimumPrice,
                                      validator: (value) =>
                                          ValidationUtils.sellingPriceWithMinValidation(
                                            value,
                                            minimumController,
                                          ),
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Minimum Price'.tr(),
                                      hintText: '10 OMR'.tr(),
                                      controller: minimumController,
                                      keyboardType: TextInputType.number,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          ValidationUtils.minimumPriceWithMaxValidation(
                                            value,
                                            sellingPrice,
                                          ),
                                      // autovalidateMode:
                                      //     AutovalidateMode.onUserInteraction,
                                      // validator: ValidationUtils.minimumPrice,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Iem SKU'.tr(),
                                      hintText: 'IPHONE13-BLK-128GB'.tr(),
                                      controller: skuController,
                                      keyboardType: TextInputType.multiline,
                                      inputFormatter: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter,
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidationUtils.minimumPrice,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      key: const ValueKey('brand_dropdown'),
                                      hintText: 'Choose Brand'.tr(),
                                      value: selectedBrandId,
                                      items: {
                                        for (var u in brands) u.id!: u.name,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedBrandId = val;
                                        selectedBrand = brands
                                            .firstWhere((u) => u.id == val)
                                            .name;
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              14.h,
                              CustomMmTextField(
                                labelText: 'Description'.tr(),
                                hintText: 'product description'.tr(),
                                controller: descriptionController,
                                keyboardType: TextInputType.multiline,
                                // inputFormatter: [
                                //   FilteringTextInputFormatter
                                //       .singleLineFormatter,
                                // ],
                              ),
                              14.h,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    PickerWidget(
                                      multipleAllowed: true,
                                      attachments: attachments,
                                      galleryAllowed: true,
                                      onFilesPicked: onFilesPicked,
                                      memoAllowed: false,
                                      //ft: FileType.image,
                                      filesAllowed: false,
                                      //captionAllowed: false,
                                      videoAllowed: false,
                                      cameraAllowed: true,
                                      child: Container(
                                        height: context.height * 0.2,
                                        width: context.width * 0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.borderColor,
                                          ),
                                        ),
                                        child: attachments.isNotEmpty
                                            ? kIsWeb
                                                  ? Image.memory(
                                                      attachments.last.bytes!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(
                                                        attachments.last.url,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .add_circle_outline_rounded,
                                                  ),
                                                  Text('Add Image'.tr()),
                                                ],
                                              ),
                                      ),
                                    ),
                                    12.w,
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: context.height * 0.06,
                                              width: context.height * 0.22,
                                              child: CustomButton(
                                                text: 'Upload Image'.tr(),
                                                onPressed: () {},
                                                fontSize: 14,
                                                buttonType: ButtonType.Filled,
                                                backgroundColor:
                                                    AppTheme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        8.h,
                                        Text(
                                          'JPEG, PNG up to 2 MB'.tr(),
                                          style:
                                              AppTheme.getCurrentTheme(
                                                false,
                                                connectionStatus,
                                              ).textTheme.bodyMedium!.copyWith(
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              AlertDialogBottomWidget(
                                title: widget.isEdit
                                    ? 'Update Product'.tr()
                                    : 'Create Product'.tr(),
                                onCreate: () {
                                  if (createInventoryKey.currentState!
                                      .validate()) {
                                    submitProduct();
                                  }
                                },
                                onCancel: () {
                                  if (widget.onBack != null) {
                                    widget.onBack!();
                                  }
                                },
                                loadingNotifier: loading,
                              ),
                              22.h,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
