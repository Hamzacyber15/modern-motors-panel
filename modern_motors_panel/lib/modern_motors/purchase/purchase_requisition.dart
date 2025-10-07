import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_requisition_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/purchase/add_purchase_requisitionpage.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class PurchaseRequisitionPage extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const PurchaseRequisitionPage({super.key, this.onNavigate});

  @override
  State<PurchaseRequisitionPage> createState() =>
      _PurchaseRequisitionPageState();
}

class _PurchaseRequisitionPageState extends State<PurchaseRequisitionPage> {
  bool showRequesitionList = true;
  bool isLoading = true;
  List<PurchaseRequisitionModel> allRequesitions = [];
  List<PurchaseRequisitionModel> displayedRequesitions = [];
  List<BrandModel> brands = [];
  List<ProductModel> allProducts = [];
  List<ProductCategoryModel> productsCategories = [];
  List<ProductSubCategoryModel> subCategories = [];
  ProductModel? product;
  PurchaseRequisitionModel? productBeingEdited;
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedRequesitionIds = {};

  final headerColumns = [
    "Serial #",
    "Product",
    "Category".tr(),
    "Sub Category".tr(),
    "Brand".tr(),
    "Note".tr(),
    "Quantity".tr(),
    "Priority".tr(),
    "Created At".tr(),
    "Created By".tr(),
  ];

  @override
  void initState() {
    super.initState();
    _loadRequesitions();
  }

  Future<void> _deleteSelectedProducts() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedRequesitionIds.length,
    );

    if (confirm != true) return;

    // Loop through selected requisition IDs
    for (String id in selectedRequesitionIds) {
      final req = allRequesitions.firstWhere(
        (r) => r.requisitionId == id,
        orElse: () => PurchaseRequisitionModel(),
      );

      if (req.requisitionId != null && req.branchId != null) {
        await FirebaseFirestore.instance
            .collection('purchase')
            .doc(req.branchId)
            .collection('purchaseRequisitions')
            .doc(req.requisitionId)
            .delete();
      }
    }

    setState(() {
      selectedRequesitionIds.clear();
    });

    await _loadRequesitions();
  }

  Future<void> _loadRequesitions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await Future.wait([
        DataFetchService.fetchPurchaseRequesition(), // [0]
        DataFetchService.fetchProduct(), // [1]
        DataFetchService.fetchSubCategories(), // [2]
        DataFetchService.fetchBrands(), // [3]
        DataFetchService.fetchProducts(),
      ]);

      setState(() {
        allRequesitions = results[0] as List<PurchaseRequisitionModel>;
        displayedRequesitions = List.from(
          allRequesitions,
        ); // for searching/filtering
        productsCategories = results[1] as List<ProductCategoryModel>;
        subCategories = results[2] as List<ProductSubCategoryModel>;
        brands = results[3] as List<BrandModel>;
        allProducts = results[4] as List<ProductModel>;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching requisition data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<List<dynamic>> getPurchaseRowsForExcel(
    List<PurchaseRequisitionModel> requisitions,
  ) {
    return requisitions.map((r) {
      final product = allProducts.firstWhere(
        (p) => p.id == r.productId!,
        orElse: () => ProductModel(),
      );
      final categoryName = productsCategories
          .firstWhere(
            (cat) => cat.id == r.category,
            orElse: () => ProductCategoryModel(productName: 'Unknown'),
          )
          .productName;

      final subCategoryName = subCategories
          .firstWhere(
            (cat) => cat.id == r.subCatId,
            orElse: () => ProductSubCategoryModel(name: 'Unknown'),
          )
          .name;

      final brandName = brands
          .firstWhere(
            (brand) => brand.id == r.brandId,
            orElse: () => BrandModel(name: 'Unknown'),
          )
          .name;

      return [
        categoryName,
        subCategoryName,
        brandName,
        r.note ?? '',
        r.quantity ?? '',
        r.prioirty ?? '',
      ];
    }).toList();
  }

  Future<void> _updateStatus(
    PurchaseRequisitionModel model,
    String status,
  ) async {
    if (model.requisitionId == null || model.branchId == null) return;
    try {
      final docRef = FirebaseFirestore.instance
          .collection('purchase')
          .doc(model.purchaseId)
          .collection('purchaseRequisitions')
          .doc(model.requisitionId);
      await docRef.update({'status': status});
      if (mounted) {
        Constants.showMessage(context, "Status successfully updated");
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, e.toString());
      }
    } finally {
      await _loadRequesitions(); // Refresh the UI
    }
  }

  Future<void> _showApproveRejectDialog(PurchaseRequisitionModel model) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Update Status".tr(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          content: Text(
            "Do you want to approve or reject this requisition?".tr(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          actionsPadding: const EdgeInsets.only(
            left: 10,
            right: 20,
            bottom: 20,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr()),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateStatus(model, 'Rejected');
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text("Reject".tr(), style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateStatus(model, 'Accepted');
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text("Accept".tr(), style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pagedProducts = displayedRequesitions
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();
    return showRequesitionList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: "Requisition List".tr(),
                  buttonText: "Create".tr(),
                  subTitle: "Manage your purchase Requisition".tr(),
                  selectedItems: selectedRequesitionIds.toList(),
                  onCreate: () {
                    setState(() {
                      showRequesitionList = false;
                    });
                  },
                  onDelete: _deleteSelectedProducts,
                  onExelImport: () async {
                    final rowsToExport = getPurchaseRowsForExcel(pagedProducts);
                    await ExcelExporter.exportToExcel(
                      headers: headerColumns,
                      rows: rowsToExport,
                      fileNamePrefix: 'Purchase_Requisition_Report',
                    );
                  },
                  onImport: () {},
                  onPdfImport: () async {
                    final rowsToExport = getPurchaseRowsForExcel(pagedProducts);
                    await PdfExporter.exportToPdf(
                      headers: headerColumns,
                      rows: rowsToExport,
                      fileNamePrefix: 'Purchase_Requisition_Report',
                    );
                  },
                ),
                allRequesitions.isEmpty
                    ? EmptyWidget(
                        text: "There's no purchase requesition available".tr(),
                      )
                    : DynamicDataTable<PurchaseRequisitionModel>(
                        data: pagedProducts,
                        isWithImage: true,
                        columns: headerColumns,
                        combineImageWithTextIndex: 1,
                        valueGetters: [
                          (b) => "${"REQ"}-${b.serialNumber}" ?? '',
                          // (b) => product != null
                          //     ? '${product!.productName} , ${product!.image}'
                          //     : "N/A",
                          // (b) => allProducts.firstWhere((p) => p.id == b.productId!,
                          // orElse: () => ProductModel(productName: ""),).productName!,
                          (b) {
                            final product = allProducts.firstWhere(
                              (p) => p.id == b.productId!,
                              orElse: () => ProductModel(
                                productName: "Unknown",
                                image: "",
                              ),
                            );
                            return '${product.productName}, ${product.image ?? ""}';
                          },

                          (b) => productsCategories
                              .firstWhere(
                                (cat) => cat.id == b.category,
                                orElse: () => ProductCategoryModel(
                                  productName: 'Unknown',
                                ),
                              )
                              .productName,
                          (b) => subCategories
                              .firstWhere(
                                (cat) => cat.id == b.subCatId,
                                orElse: () =>
                                    ProductSubCategoryModel(name: 'Unknown'),
                              )
                              .name,
                          (b) => brands
                              .firstWhere(
                                (cat) => cat.id == b.brandId,
                                orElse: () => BrandModel(name: 'Unknown'),
                              )
                              .name,
                          (b) => b.note ?? '',
                          (b) => (b.quantity ?? 0).toString(),
                          (b) => b.prioirty ?? '',
                          (b) => (Constants.getFormattedDateTime(
                            b.timestamp!.toDate(),
                            "full",
                          )).toString(),
                          (b) => b.createdBy ?? '',
                        ],
                        getId: (v) => v.requisitionId,
                        selectedIds: selectedRequesitionIds,
                        onSelectChanged: (val, vendor) {
                          setState(() {
                            if (val == true) {
                              selectedRequesitionIds.add(vendor.requisitionId!);
                            } else {
                              selectedRequesitionIds.remove(
                                vendor.requisitionId,
                              );
                            }
                          });
                        },
                        onEdit: (product) {
                          setState(() {
                            showRequesitionList = false;
                            productBeingEdited = product;
                          });
                        },
                        onStatus: (product) {
                          _showApproveRejectDialog(product);
                        },
                        statusTextGetter: (item) =>
                            item.status!.capitalizeFirst,
                        onView: (product) {},
                        onSelectAll: (val) {
                          setState(() {
                            final currentPageIds = pagedProducts
                                .map((e) => e.requisitionId!)
                                .toList();
                            if (val == true) {
                              selectedRequesitionIds.addAll(currentPageIds);
                            } else {
                              selectedRequesitionIds.removeAll(currentPageIds);
                            }
                          });
                        },
                        onSearch: (query) {
                          setState(() {
                            displayedRequesitions = allRequesitions
                                .where(
                                  (product) => product.brand!
                                      .toLowerCase()
                                      .contains(query.toLowerCase()),
                                )
                                .toList();
                          });
                        },
                      ),
                Align(
                  alignment: Alignment.topRight,
                  child: PaginationWidget(
                    currentPage: currentPage,
                    totalItems: allRequesitions.length,
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
                ),
              ],
            ),
          )
        : AddPurchaseRequisitionPage(
            isEdit: productBeingEdited != null,
            purchseReuesition: productBeingEdited,
            onBack: () async {
              await _loadRequesitions();
              setState(() {
                showRequesitionList = true;
                productBeingEdited = null;
              });
            },
          );
  }
}
