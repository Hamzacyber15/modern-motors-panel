import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

class AddInventoryPage extends StatefulWidget {
  final VoidCallback? onBack;
  final InventoryModel? inventoryModel;
  final bool isEdit;

  const AddInventoryPage({
    super.key,
    this.onBack,
    this.inventoryModel,
    required this.isEdit,
  });

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final TextEditingController totalItemController = TextEditingController();
  final TextEditingController costPriceController = TextEditingController();
  final TextEditingController totalCostPriceController =
      TextEditingController();
  final TextEditingController salePriceController = TextEditingController();

  // final TextEditingController totalSalePriceController =
  //     TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  List<AttachmentModel> attachments = [];
  GlobalKey<FormState> createInventoryKey = GlobalKey<FormState>();

  List<ProductModel> products = [];
  List<BranchModel> branches = [];
  List<VendorModel> vendors = [];
  String? selectedProductId;
  String? selectedProduct;
  String? selectedBranchId;
  String? selectedBranch;
  String? selectedVendorId;
  String? selectedVendor;

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
      DataFetchService.fetchProducts(),
      DataFetchService.fetchBranches(),
      DataFetchService.fetchVendor(),
    ]).then((results) {
      final productList = results[0] as List<ProductModel>;
      final branchesList = results[1] as List<BranchModel>;
      final vendorsList = results[2] as List<VendorModel>;

      setState(() {
        products = productList;
        branches = branchesList;
        vendors = vendorsList;

        bool missingData = false;
        debugPrint(
          'widget.isEdit && widget.inventoryModel != null: ${widget.isEdit && widget.inventoryModel != null}',
        );
        debugPrint('isEdit: ${widget.isEdit}');
        debugPrint(
          'widget.inventoryModel != null: ${widget.inventoryModel != null}',
        );
        if (widget.isEdit && widget.inventoryModel != null) {
          final inventory = widget.inventoryModel!;

          totalItemController.text = inventory.totalItem.toString();
          costPriceController.text = inventory.costPrice.toString();
          salePriceController.text = inventory.salePrice.toString();
          totalCostPriceController.text = inventory.totalCostPrice.toString();

          if (branches.any((s) => s.id == inventory.branchId)) {
            selectedBranchId = inventory.branchId;
          } else {
            selectedBranchId = null;
            missingData = true;
          }

          if (vendors.any((s) => s.id == inventory.vendorId)) {
            selectedVendorId = inventory.vendorId;
          } else {
            selectedVendorId = null;
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

  void submitInventory() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final totalItem = int.tryParse(totalItemController.text.trim()) ?? 0;
      final costPrice = double.tryParse(costPriceController.text.trim()) ?? 0.0;
      final salePrice = double.tryParse(salePriceController.text.trim()) ?? 0.0;
      // final totalSaleP =
      //     double.tryParse(totalSalePriceController.text.trim()) ?? 0.0;
      final totalCostP =
          double.tryParse(totalCostPriceController.text.trim()) ?? 0.0;

      final addInventory = InventoryModel(
        productId: selectedProductId,
        status: 'pending',
        vendorId: selectedVendorId,
        branchId: selectedBranchId,
        salePrice: salePrice,
        costPrice: costPrice,
        totalItem: totalItem,
        totalCostPrice: totalCostP,
        name: '',
        image: '',
        // totalSalePrice: totalSaleP,
      );

      if (widget.isEdit && widget.inventoryModel?.id != null) {
        await DataUploadService.updateInventory(
              widget.inventoryModel!.id!,
              addInventory,
            )
            .then((_) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Inventory updated successfully'.tr(),
              );
              widget.onBack?.call();
            })
            .catchError((error) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Failed to update inventory: $error',
              );
            });
      } else {
        await DataUploadService.addInventory(addInventory)
            .then((_) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Inventory added successfully'.tr(),
              );
              widget.onBack?.call();
            })
            .catchError((error) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Failed to add inventory: $error',
              );
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeaderWidget(
            title: 'Create Inventory'.tr(),
            buttonText: 'Back to Inventory'.tr(),
            subTitle: 'Create New Inventory'.tr(),
            importButtonText: 'Import Inventory'.tr(),
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
                      padding: const EdgeInsets.only(left: 16, top: 10),
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
                            CustomSearchableDropdown(
                              key: const ValueKey('product_dropdown'),
                              hintText: 'Choose Product'.tr(),
                              value: selectedProductId,
                              items: {
                                for (var u in products) u.id!: u.productName!,
                              },
                              onChanged: (val) => setState(() {
                                selectedProductId = val;
                                selectedProduct = products
                                    .firstWhere((u) => u.id == val)
                                    .productName;
                              }),
                            ),
                            14.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomSearchableDropdown(
                                    key: const ValueKey('branch_dropdown'),
                                    hintText: 'Choose Branch'.tr(),
                                    value: selectedBranchId,
                                    items: {
                                      for (var u in branches)
                                        u.id!: u.branchName,
                                    },
                                    onChanged: (val) => setState(() {
                                      selectedBranchId = val;
                                      selectedBranch = branches
                                          .firstWhere((u) => u.id == val)
                                          .branchName;
                                    }),
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomSearchableDropdown(
                                    key: const ValueKey('vendors_dropdown'),
                                    hintText: 'Choose Vendor'.tr(),
                                    value: selectedVendorId,
                                    items: {
                                      for (var u in vendors)
                                        u.id!: u.vendorName,
                                    },
                                    onChanged: (val) => setState(() {
                                      selectedVendorId = val;
                                      selectedVendor = vendors
                                          .firstWhere((u) => u.id == val)
                                          .vendorName;
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
                                    labelText: 'Total Item'.tr(),
                                    hintText: 'Total Item'.tr(),
                                    controller: totalItemController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (p0) {
                                      setState(() {
                                        final totalItem =
                                            int.tryParse(
                                              totalItemController.text,
                                            ) ??
                                            0;
                                        final costPrice =
                                            double.tryParse(
                                              costPriceController.text,
                                            ) ??
                                            0.0;
                                        // final salePrice =
                                        //     double.tryParse(
                                        //       salePriceController.text,
                                        //     ) ??
                                        //     0.0;
                                        // totalSalePrice = 0.0;
                                        // totalSalePrice = salePrice * totalItem;

                                        totalCostPrice = 0.0;
                                        totalCostPrice = costPrice * totalItem;

                                        totalCostPriceController.text =
                                            (totalCostPrice).toString();
                                        // totalSalePriceController.text =
                                        //     (totalSalePrice).toString();
                                      });
                                    },
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.totalItems,
                                  ),
                                ),
                              ],
                            ),
                            14.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Cost Price'.tr(),
                                    hintText: 'Cost Price'.tr(),
                                    controller: costPriceController,
                                    onChanged: (p0) {
                                      final totalItem =
                                          int.tryParse(
                                            totalItemController.text,
                                          ) ??
                                          0;
                                      final costPrice =
                                          double.tryParse(
                                            costPriceController.text,
                                          ) ??
                                          0.0;
                                      totalCostPrice = 0.0;
                                      totalCostPrice = costPrice * totalItem;
                                      totalCostPriceController.text =
                                          (totalCostPrice).toString();
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.price,
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Sale Price Per Item'.tr(),
                                    hintText: 'Sale Price Per Item'.tr(),
                                    controller: salePriceController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (p0) {
                                      setState(() {
                                        // final totalItem =
                                        //     int.tryParse(
                                        //       totalItemController.text,
                                        //     ) ??
                                        //     0;
                                        // final salePrice =
                                        //     double.tryParse(
                                        //       salePriceController.text,
                                        //     ) ??
                                        //     0.0;
                                        // totalSalePrice = 0.0;
                                        // totalSalePrice = salePrice * totalItem;
                                        // totalSalePriceController.text =
                                        //     (totalSalePrice).toString();
                                      });
                                    },
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.price,
                                  ),
                                ),
                              ],
                            ),
                            14.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    readOnly: true,
                                    labelText: 'Total Cost Price'.tr(),
                                    hintText: 'Total Cost Price'.tr(),
                                    controller: totalCostPriceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.price,
                                  ),
                                ),
                                // 10.w,
                                // Expanded(
                                //   child: CustomTextField(
                                //     readOnly: true,
                                //     labelText: 'Total Sale Price',
                                //     hintText: 'Total Sale Price',
                                //     controller: totalSalePriceController,
                                //     keyboardType: TextInputType.number,
                                //     inputFormatter: [
                                //       FilteringTextInputFormatter.allow(
                                //         RegExp(r'^\d*\.?\d{0,2}'),
                                //       ),
                                //     ],
                                //     autovalidateMode:
                                //         AutovalidateMode.onUserInteraction,
                                //     validator: ValidationUtils.price,
                                //   ),
                                // ),
                              ],
                            ),
                            14.h,
                            AlertDialogBottomWidget(
                              title: widget.isEdit
                                  ? 'Update Inventory'.tr()
                                  : 'Create Inventory'.tr(),
                              onCreate: () {
                                if (createInventoryKey.currentState!
                                    .validate()) {
                                  submitInventory();
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
