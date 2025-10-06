import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_order_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/purchase/procurement_add_edit_purchaseorder.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/provider/resource_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:provider/provider.dart';

class PurchaseOrders extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const PurchaseOrders({super.key, this.onNavigate});

  @override
  State<PurchaseOrders> createState() => _PurchaseOrdersState();
}

class _PurchaseOrdersState extends State<PurchaseOrders> {
  bool showInventoryList = true;
  bool isLoading = true;

  PurchaseOrderModel? purchaseOrderBeingEdited;
  List<PurchaseOrderModel> allPurchaseOrders = [];
  List<PurchaseOrderModel> displayedPurchaseOrders = [];
  List<ProductModel> allProducts = [];
  List<ProductCategoryModel> productsCategories = [];
  List<ProductSubCatorymodel> subCategories = [];
  List<VendorModel> vendors = [];

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedPurchaseId = {};

  @override
  void initState() {
    super.initState();
    _loadPurchaseOrders();
  }

  final List<String> procurementHeaders = [
    "PO #",
    "REQ #",
    "Product",
    'Product Cat'.tr(),
    'Sub Category'.tr(),
    'Vendor Name'.tr(),
    'Quantity'.tr(),
    'Cost per Price'.tr(),
    'Tax Amount'.tr(),
    'Sub Total'.tr(),
    // 'Vendor'.tr(),
    // 'Create On'.tr(),
  ];

  List<List<dynamic>> getProcurementRowsForExcel(
    List<PurchaseOrderModel> purchaseOrders,
  ) {
    return purchaseOrders.map((v) {
      final product = productsCategories.firstWhere(
        (p) => p.id == v.productId,
        orElse: () => ProductCategoryModel(productName: ''),
      );
      final subCat = subCategories.firstWhere(
        (s) => s.id == v.subCatId,
        orElse: () => ProductSubCatorymodel(name: ''),
      );
      final vendor = vendors.firstWhere(
        (ven) => ven.id == v.vendorId,
        orElse: () => VendorModel(vendorName: ''),
      );

      return [
        product.productName,
        subCat.name,
        vendor.vendorName,
        v.quantity,
        v.perItem,
        v.totalCost,
        v.subTotal,

        //   v.timestamp?.toDate().formattedWithDayMonthYear ?? '',
      ];
    }).toList();
  }

  Future<void> _deleteSelectedOrder() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedPurchaseId.length,
    );
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (confirm != true) return;
    if (!mounted) {
      return;
    }
    final profile = context.read<ResourceProvider>().getProfileByID(uid!);
    final branchId = profile.id;

    if (branchId.isNotEmpty) {
      if (!mounted) return;
      Constants.showMessage(context, "Branch ID not found");
      return;
    }

    for (String productId in selectedPurchaseId) {
      await FirebaseFirestore.instance
          .collection('purchase')
          .doc(branchId)
          .collection('purchaseOrder')
          .doc(productId)
          .delete();
    }

    setState(() {
      selectedPurchaseId.clear();
    });

    await _loadPurchaseOrders();
  }

  Future<void> _loadPurchaseOrders() async {
    setState(() {
      isLoading = true;
    });
    Future.wait([
      DataFetchService.fetchPurchaseOrder(), // ⬅️ This is calling your function
      DataFetchService.fetchProduct(),
      DataFetchService.fetchSubCategories(),
      DataFetchService.fetchVendor(),
      DataFetchService.fetchProducts(),
    ]).then((results) {
      setState(() {
        allPurchaseOrders = results[0] as List<PurchaseOrderModel>;
        displayedPurchaseOrders = results[0] as List<PurchaseOrderModel>;
        productsCategories = results[1] as List<ProductCategoryModel>;
        subCategories = results[2] as List<ProductSubCatorymodel>;
        vendors = results[3] as List<VendorModel>;
        allProducts = results[4] as List<ProductModel>;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = displayedPurchaseOrders
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return showInventoryList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: 'Purchase Order'.tr(),
                  buttonText: "Create Order".tr(),
                  subTitle: "Manage your Purchases".tr(),
                  importButtonText: 'Import Orders'.tr(),
                  selectedItems: selectedPurchaseId.toList(),
                  onCreate: () async {
                    setState(() {
                      showInventoryList = false;
                    });
                  },
                  buttonWidth: 0.28,
                  onDelete: _deleteSelectedOrder,
                  onExelImport: () async {
                    final rowsToExport = getProcurementRowsForExcel(pagedItems);
                    await ExcelExporter.exportToExcel(
                      headers: procurementHeaders,
                      rows: rowsToExport,
                      fileNamePrefix: 'Procurement_Purchase_Order_Report',
                    );
                  },
                  onImport: () {},
                  onPdfImport: () async {
                    final rowsToExport = getProcurementRowsForExcel(pagedItems);
                    await PdfExporter.exportToPdf(
                      headers: procurementHeaders,
                      rows: rowsToExport,
                      fileNamePrefix: 'Procurement_Purchase_Order_Report',
                    );
                  },
                ),
                allPurchaseOrders.isEmpty
                    ? EmptyWidget(
                        text: "There's no Purchase Orders available".tr(),
                      )
                    : DynamicDataTable<PurchaseOrderModel>(
                        data: pagedItems,
                        isWithImage: true,
                        columns: procurementHeaders,
                        combineImageWithTextIndex: 2,
                        valueGetters: [
                          (v) => '${"PO"} - ${v.poNumber}',
                          (v) => '${"REQ"} - ${v.requisitionNumber}',
                          (v) {
                            final product = allProducts.firstWhere(
                              (p) => p.id == v.productId!,
                              orElse: () => ProductModel(
                                productName: "Unknown",
                                image: "",
                              ),
                            );
                            return '${product.productName}, ${product.image ?? ""}';
                          },
                          (v) => productsCategories
                              .firstWhere(
                                (cat) => cat.id == v.productCategoryId,
                                orElse: () =>
                                    ProductCategoryModel(productName: 'N/A'),
                              )
                              .productName,
                          (v) => subCategories
                              .firstWhere(
                                (cat) => cat.id == v.subCatId,
                                orElse: () =>
                                    ProductSubCatorymodel(name: 'N/A'),
                              )
                              .name,
                          (v) => vendors
                              .firstWhere(
                                (cat) => cat.id == v.vendorId,
                                orElse: () => VendorModel(vendorName: 'N/A'),
                              )
                              .vendorName,
                          (v) => v.quantity.toString(),
                          (v) => v.perItem.toString(),
                          (v) => v.totalCost.toString(),

                          (v) => v.subTotal.toString(),

                          //  (v) => v.timestamp!.toDate().formattedWithDayMonthYear,
                        ],
                        getId: (v) => v.id,
                        selectedIds: selectedPurchaseId,
                        onSelectChanged: (value, inventory) {
                          setState(() {
                            if (value == true) {
                              selectedPurchaseId.add(inventory.id!);
                            } else {
                              selectedPurchaseId.remove(inventory.id);
                            }
                          });
                        },
                        onEdit: (inventory) {
                          setState(() {
                            purchaseOrderBeingEdited = inventory;
                            showInventoryList = false;
                          });
                        },
                        onStatus: (product) {},
                        statusTextGetter: (item) =>
                            item.status!.capitalizeFirst,
                        onView: (product) {},
                        onSelectAll: (value) {
                          setState(() {
                            final currentPageIds = pagedItems
                                .map((e) => e.id!)
                                .toList();
                            if (value == true) {
                              selectedPurchaseId.addAll(currentPageIds);
                            } else {
                              selectedPurchaseId.removeAll(currentPageIds);
                            }
                          });
                        },
                        onSearch: (query) {
                          setState(() {
                            displayedPurchaseOrders = allPurchaseOrders
                                .where(
                                  (item) => item.productId!
                                      .toLowerCase()
                                      .contains(query.toLowerCase()),
                                )
                                .toList();
                          });
                        },
                      ),
                displayedPurchaseOrders.length > itemsPerPage
                    ? Align(
                        alignment: Alignment.center,
                        child: PaginationWidget(
                          currentPage: currentPage,
                          totalItems: displayedPurchaseOrders.length,
                          itemsPerPage: itemsPerPage,
                          onPageChanged: (newPage) {
                            setState(() {
                              currentPage = newPage;
                            });
                          },
                          onItemsPerPageChanged: (newLimit) {
                            setState(() {
                              itemsPerPage = newLimit;
                            });
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          )
        : ProcurementAddEditPurchaseOrder(
            isEdit: purchaseOrderBeingEdited != null,
            purchaseOrderModel: purchaseOrderBeingEdited,
            onBack: () async {
              await _loadPurchaseOrders();
              setState(() {
                showInventoryList = true;
                purchaseOrderBeingEdited = null;
              });
            },
          );
  }
}
