import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_requisition_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

class AddPurchaseRequisitionPage extends StatefulWidget {
  final VoidCallback? onBack;
  final PurchaseRequisitionModel? purchseReuesition;
  final bool isEdit;

  const AddPurchaseRequisitionPage({
    super.key,
    this.onBack,
    this.purchseReuesition,
    required this.isEdit,
  });

  @override
  State<AddPurchaseRequisitionPage> createState() =>
      _AddPurchaseRequisitionPageState();
}

class _AddPurchaseRequisitionPageState
    extends State<AddPurchaseRequisitionPage> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  GlobalKey<FormState> createRequesitionKey = GlobalKey<FormState>();
  List<BrandModel> brands = [];
  List<ProductModel> productList = [];
  List<ProductCategoryModel> productsCategories = [];
  List<ProductSubCatorymodel> subCategories = [];
  List<ProductSubCatorymodel> associatedSubCategories = [];
  ProductModel? selectedProduct;
  String? selectedBrandId;
  String? selectedProductId;
  String? selectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    if (catLoader.value) return;
    catLoader.value = true;

    Future.wait([
      // DataFetchService.fetchProduct(),
      // DataFetchService.fetchSubCategories(),
      DataFetchService.fetchBrands(),
      DataFetchService.fetchProducts(),
    ]).then((results) {
      // final productList = results[0] as List<ProductCategoryModel>;
      // final subCategoriesList = results[1] as List<ProductSubCatorymodel>;
      final brandsList = results[0] as List<BrandModel>;
      final pList = results[1] as List<ProductModel>;

      setState(() {
        // productsCategories = productList;
        // subCategories = subCategoriesList;
        brands = brandsList;
        productList = pList;
        if (widget.isEdit && widget.purchseReuesition != null) {
          final requesition = widget.purchseReuesition!;
          quantityController.text = requesition.quantity?.toString() ?? '';
          noteController.text = requesition.note ?? '';
          priorityController.text = requesition.prioirty ?? '';
          selectedProductId = requesition.productId;
          selectedSubCategoryId = requesition.subCatId;
          selectedBrandId = requesition.brandId;
          associatedSubCategories = subCategories
              .where((sub) => sub.catId?.contains(selectedProductId) ?? false)
              .toList();
        }
      });

      catLoader.value = false;
    });
  }

  void submitPurchaseRequesition() async {
    if (loading.value) return;
    if (selectedProductId == null || selectedBrandId == null) {
      Constants.showMessage(context, 'Please select all dropdown values'.tr());
      return;
    }
    loading.value = true;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final profile = context.read<MmResourceProvider>().getProfileByID(
        uid!,
      ); // await DataFetchService.fetchCurrentUserProfile();
      if ( //profile.id.isNotEmpty
      !mounted) {
        if (!mounted) return;
        Constants.showMessage(context, 'User profile not found'.tr());
        loading.value = false;
        return;
      }
      String serial = await Constants.getUniqueNumber("REQ");
      selectedProduct = productList.firstWhere(
        (item) => item.id == selectedProductId,
      );
      final request = PurchaseRequisitionModel(
        serialNumber: serial,
        productId: selectedProductId,
        subCatId: selectedProduct!.subCategoryId,
        category: selectedProduct!.categoryId,
        brandId: selectedBrandId,
        quantity: int.tryParse(quantityController.text.trim()) ?? 0,
        prioirty: priorityController.text.trim(),
        note: noteController.text.trim(),
        createdBy: profile.id,
        status: 'pending',
        branchId: profile.id,
      );
      debugPrint('request.toMap() ${request.toMap()}');

      if (widget.isEdit && widget.purchseReuesition?.requisitionId != null) {
        await FirebaseFirestore.instance
            .collection('purchase')
            .doc(widget.purchseReuesition!.purchaseId)
            .collection('purchaseRequisitions')
            .doc(widget.purchseReuesition!.requisitionId!)
            .update(request.toMap());
        if (!mounted) return;
        Constants.showMessage(context, 'Requisition updated successfully'.tr());
      } else {
        await DataUploadService.addPurchaseRequisition(request);

        if (!mounted) return;
        Constants.showMessage(context, 'Requisition added successfully'.tr());
      }

      widget.onBack?.call();
    } catch (e) {
      if (!mounted) return;
      Constants.showMessage(context, 'Something went wrong'.tr());
      debugPrint('Error: \$e');
    } finally {
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeaderWidget(
            title: 'Create Requisition'.tr(),
            buttonText: 'Back to Requisition'.tr(),
            subTitle: 'Create New Requisition'.tr(),
            importButtonText: 'Import Requisition'.tr(),
            onCreateIcon: 'assets/images/back.png',
            selectedItems: [],
            buttonWidth: 0.4,
            onCreate: widget.onBack!.call,
            onDelete: () async {},
          ),
        ),
        SliverToBoxAdapter(
          child: OverlayLoader(
            loader: catLoader.value,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor, width: 0.6),
                ),
                child: Form(
                  key: createRequesitionKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purchase Requisition Information'.tr(),
                          style: AppTheme.getCurrentTheme(
                            false,
                            connectionStatus,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: CustomSearchableDropdown(
                                hintText: 'Choose Product'.tr(),
                                value: selectedProductId,
                                items: {
                                  for (var u in productList)
                                    u.id!: u.productName!,
                                },
                                onChanged: (val) => setState(() {
                                  selectedProductId = val;

                                  // associatedSubCategories = subCategories
                                  //     .where(
                                  //       (sub) =>
                                  //           sub.catId?.contains(val) ?? false,
                                  //     )
                                  //     .toList();
                                }),
                              ),
                            ),
                            10.w,
                            Expanded(
                              child: CustomSearchableDropdown(
                                hintText: 'Choose Brand'.tr(),
                                value: selectedBrandId,
                                items: {for (var u in brands) u.id!: u.name},
                                onChanged: (val) => setState(() {
                                  selectedBrandId = val;
                                }),
                              ),
                            ),
                            10.w,
                            Expanded(
                              child: CustomMmTextField(
                                labelText: 'Enter Quantity'.tr(),
                                hintText: 'Quantity'.tr(),
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.quantity,
                              ),
                            ),
                            // Expanded(
                            //   child: CustomSearchableDropdown(
                            //     hintText: 'Choose Sub Category'.tr(),
                            //     value: selectedSubCategoryId,
                            //     items: {
                            //       for (var u in associatedSubCategories)
                            //         u.id!: u.name,
                            //     },
                            //     onChanged: (val) => setState(() {
                            //       selectedSubCategoryId = val;
                            //       debugPrint(
                            //         'Selected Sub Category >>>>>>>> $selectedSubCategoryId',
                            //       );
                            //     }),
                            //   ),
                            // ),
                          ],
                        ),
                        //14.h,
                        // Row(
                        //   children: [

                        //   ],
                        // ),
                        14.h,
                        CustomMmTextField(
                          labelText: 'Enter Priority'.tr(),
                          hintText: 'Priority'.tr(),
                          controller: priorityController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: ValidationUtils.priority,
                        ),
                        14.h,
                        CustomMmTextField(
                          labelText: 'Enter Note'.tr(),
                          hintText: 'Note'.tr(),
                          controller: noteController,
                          keyboardType: TextInputType.text,
                        ),
                        14.h,
                        AlertDialogBottomWidget(
                          title: widget.isEdit
                              ? 'Update Requisition'.tr()
                              : 'Create Requisition'.tr(),
                          onCreate: () {
                            if (createRequesitionKey.currentState!.validate()) {
                              submitPurchaseRequesition();
                            }
                          },
                          onCancel: widget.onBack!.call,
                          loadingNotifier: loading,
                        ),
                        22.h,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
