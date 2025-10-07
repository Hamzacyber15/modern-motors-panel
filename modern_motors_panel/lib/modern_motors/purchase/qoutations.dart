// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/purchase_models/quotation_procurement_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/purchase/add_edit_procurement_qoutation.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/modern_motors/widgets/show_status_update_dialog.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:modern_motors_panel/widgets/image_gallery_widget.dart';
import 'package:provider/provider.dart';

class Qoutations extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const Qoutations({super.key, this.onNavigate});

  @override
  State<Qoutations> createState() => _QoutationsState();
}

class _QoutationsState extends State<Qoutations> {
  bool showProductList = true;
  bool isLoading = true;
  List<QuotationProcurementModel> allQuotations = [];
  List<QuotationProcurementModel> displayedQuotations = [];
  QuotationProcurementModel? quotationBeingEdited;
  List<BrandModel> brands = [];
  List<ProductModel> allProducts = [];
  List<ProductCategoryModel> productsCategories = [];
  List<ProductSubCategoryModel> subCategories = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedProductIds = {};
  bool _isUpdatingStatus = false;

  Future<void> _deleteSelectedProducts() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedProductIds.length,
    );
    if (confirm != true) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final profile = await context.read<MmResourceProvider>().getProfileByID(
      uid!,
    );
    final branchId = profile.branchId;
    if (branchId == null) {
      if (!mounted) return;
      Constants.showMessage(context, "Branch ID not found");
      return;
    }

    for (String productId in selectedProductIds) {
      await FirebaseFirestore.instance
          .collection('purchase')
          .doc(branchId)
          .collection('quotations')
          .doc(productId)
          .delete();
    }

    setState(() {
      selectedProductIds.clear();
    });

    await _loadProducts();
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    final products = await DataFetchService.fetchQuotation();
    final results = await Future.wait([
      DataFetchService.fetchProduct(), // [1]
      DataFetchService.fetchSubCategories(), // [2]
      DataFetchService.fetchProducts(),
      DataFetchService.fetchProducts(),
    ]);
    setState(() {
      productsCategories = results[0] as List<ProductCategoryModel>;
      subCategories = results[1] as List<ProductSubCategoryModel>;
      allQuotations = products;
      allProducts = results[2] as List<ProductModel>;
      //allQuotations = products;
      displayedQuotations = allQuotations;
      isLoading = false;
    });
  }

  // Future<void> _updateQuotationStatus(
  //   QuotationProcurementModel model,
  //   int targetIndex,
  //   String newStatus,
  // ) async {
  //   //final profile = await DataFetchService.fetchCurrentUserProfile();
  //   //  final uid = FirebaseAuth.instance.currentUser?.uid;
  //   // final profile = context.read<ResourceProvider>().getProfileByID(uid!);
  //   // final branchId = profile.id; //profile?.branchId;
  //   try {
  //     // if (branchId.isEmpty || model.id.isNotEmpty) return;
  //     final updatedList = model.quotationList.map((q) => q.toMap()).toList();
  //     for (int i = 0; i < updatedList.length; i++) {
  //       updatedList[i]['status'] = (i == targetIndex) ? 'approved' : 'rejected';
  //     }
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       return;
  //     }
  //     await FirebaseFirestore.instance
  //         .collection('purchase')
  //         .doc(model.purchaseId)
  //         .collection('quotations')
  //         .doc(model.id)
  //         .update({
  //       'quotationList': updatedList,
  //       'status': "accepted",
  //       "updatedBy": user.uid
  //     });

  //     // ✅ Save approved vendor ID to related purchaseRequisitions
  //     final approvedVendorId = updatedList[targetIndex]['vendorId'];
  //     if (approvedVendorId != null && model.requisitionIds.isNotEmpty) {
  //       await FirebaseFirestore.instance
  //           .collection('purchase')
  //           .doc(model.purchaseId)
  //           .collection('purchaseRequisitions')
  //           .doc(model.requisitionIds)
  //           .set({
  //         'approvedVendorId': approvedVendorId,
  //         'updatedAt': FieldValue.serverTimestamp(),
  //       }, SetOptions(merge: true));
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       Constants.showMessage(context, e.toString());
  //     }
  //   }
  //   if (mounted) {
  //     Navigator.of(context).pop();
  //   }
  //   await _loadProducts();
  //   // Refresh the UI
  // }

  Future<void> _updateQuotationStatus(
    QuotationProcurementModel model,
    int targetIndex,
    String newStatus,
  ) async {
    try {
      final updatedList = model.quotationList.map((q) => q.toMap()).toList();
      for (int i = 0; i < updatedList.length; i++) {
        updatedList[i]['status'] = (i == targetIndex) ? newStatus : 'rejected';
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await FirebaseFirestore.instance
          .collection('purchase')
          .doc(model.purchaseId)
          .collection('quotations')
          .doc(model.id)
          .update({
            'quotationList': updatedList,
            'status': newStatus == 'approved' ? "accepted" : "rejected",
            "updatedBy": user.uid,
            "updatedAt": FieldValue.serverTimestamp(),
          });

      // ✅ Save approved vendor ID to related purchaseRequisitions
      if (newStatus == 'approved' && model.requisitionIds.isNotEmpty) {
        final approvedVendorId = updatedList[targetIndex]['vendorId'];
        if (approvedVendorId != null) {
          await FirebaseFirestore.instance
              .collection('purchase')
              .doc(model.purchaseId)
              .collection('purchaseRequisitions')
              .doc(model.requisitionIds)
              .set({
                'approvedVendorId': approvedVendorId,
                'updatedAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the calling function
    }
  }

  // Update the ElevatedButton in your showViewDialog to show loading state

  final headers = [
    //"ID".tr(),
    "Requistion #",
    "Product",
    "Product Cat".tr(),
    "Product Sub Cat".tr(),
    "Vendors Info".tr(),
    "Quantity".tr(),
    "Per Item (OMR)".tr(),
    "Total Price".tr(),
    //"Status".tr(),
  ];

  List<List<String>> getQuotationRows(
    List<QuotationProcurementModel> allQuotations,
  ) {
    return allQuotations.map((q) {
      return [
        q.id ?? '',
        q.quotationList.map((v) => v.vendorName).join(', ') ??
            'No quotation'.tr(),
        q.quotationList.map((item) => item.quantity).join(", ") ?? "",
        q.quotationList.map((item) => item.perItem).join(", ") ?? "",
        q.quotationList.map((item) => item.totalPrice).join(", ") ?? "",
      ];
    }).toList();
  }

  Future<void> _showStatusUpdateDialog(
    QuotationProcurementModel quotation,
    int index,
  ) async {
    // Show loading dialog immediately when status update begins
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      ),
    );

    setState(() {
      _isUpdatingStatus = true;
    });

    final selectedStatus = await showStatusUpdateDialog(context);

    if (selectedStatus != null) {
      try {
        await _updateQuotationStatus(quotation, index, selectedStatus);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Status updated successfully'.tr()),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update status: ${e.toString()}'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          Navigator.of(context).pop();
        }
        setState(() {
          _isUpdatingStatus = false;
        });
        await _loadProducts();
      }
    } else {
      // User cancelled the operation
      if (mounted) {
        Navigator.of(context).pop();
      }

      setState(() {
        _isUpdatingStatus = false;
      });
    }
  }

  void showViewDialog(QuotationProcurementModel quotation) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "View Quotation".tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xFF718096),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 16),

              // Quotation ID
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  "Quotation #: ${quotation.requisitionSerial}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A5568),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quotations title
              Text(
                "quotations:".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              // Quotations List
              ...(quotation.quotationList ?? []).asMap().entries.map((entry) {
                final index = entry.key;
                final q = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Vendor Avatar
                      SizedBox(
                        width: 60,
                        child: ImageGalleryWidget(
                          imageUrls:
                              q.imageURL != null && q.imageURL!.isNotEmpty
                              ? [q.imageURL!]
                              : [],
                          thumbnailSize: 40.0,
                          spacing: 6.0,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Vendor Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.vendorName ?? "Unknown Vendor",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Quantity with clear label
                            Row(
                              children: [
                                const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 14,
                                  color: Color(0xFF718096),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Quantity: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  "${q.quantity ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // Status with interactive styling
                            GestureDetector(
                              onTap: _isUpdatingStatus
                                  ? null
                                  : () {
                                      _showStatusUpdateDialog(quotation, index);
                                    },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.update,
                                    size: 14,
                                    color: Color(0xFF718096),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Status: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(q.status),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      q.status ?? "Unknown",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Price Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Total Price in OMR
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatPrice(q.totalPrice),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "OMR",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Per Item Price
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatPrice(q.perItem ?? 0),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Text(
                                "/unit",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Per Item Price
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatDiscount(q.discount ?? 0),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Text(
                                " Discount (%)",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Accept Button
                          // ElevatedButton(
                          //   onPressed: () {
                          //     _showStatusUpdateDialog(quotation, index);
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: const Color(0xFF48BB78),
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 12, vertical: 6),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     elevation: 0,
                          //   ),
                          //   child: const Text(
                          //     "Update Status",
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w600,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          ElevatedButton(
                            onPressed: _isUpdatingStatus
                                ? null
                                : () {
                                    _showStatusUpdateDialog(quotation, index);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF48BB78),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: _isUpdatingStatus
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Update Status",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Close".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDiscount(num? discount) {
    if (discount == null) return "0.0";
    return discount.toStringAsFixed(1);
  }

  // Helper function to format price with OMR currency
  String _formatPrice(num? price) {
    if (price == null) return "0.000";
    return price.toStringAsFixed(3);
  }

  // Helper function to get status color
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return const Color(0xFF48BB78);
      case 'pending':
        return const Color(0xFFECC94B);
      case 'rejected':
        return const Color(0xFFF56565);
      default:
        return const Color(0xFF718096);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagedquotations = displayedQuotations
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return showProductList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: "Quotations List".tr(),
                  buttonText: "Add Quotation".tr(),
                  subTitle: "Manage your quotations".tr(),
                  selectedItems: selectedProductIds.toList(),
                  buttonWidth: 0.28,
                  onCreate: () {
                    setState(() {
                      showProductList = false;
                    });
                  },
                  onDelete: _deleteSelectedProducts,
                  onPdfImport: () async {
                    final rowsToExport = getQuotationRows(pagedquotations);
                    await PdfExporter.exportToPdf(
                      headers: headers,
                      rows: rowsToExport,
                      fileNamePrefix: 'Quotation_Report',
                    );
                  },
                  onExelImport: () async {
                    final rowsToExport = getQuotationRows(pagedquotations);
                    await ExcelExporter.exportToExcel(
                      headers: headers,
                      rows: rowsToExport,
                      fileNamePrefix: 'Quotation_Report',
                    );
                  },
                ),
                allQuotations.isEmpty
                    ? EmptyWidget(text: "There's no Quotations available".tr())
                    : DynamicDataTable<QuotationProcurementModel>(
                        data: pagedquotations,
                        columns: headers,
                        combineImageWithTextIndex: 1,
                        isWithImage: true,
                        valueGetters: [
                          (v) => "${"REQ"}-${v.requisitionSerial}",
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
                                orElse: () => ProductCategoryModel(
                                  productName: 'Unknown',
                                ),
                              )
                              .productName,
                          (v) => subCategories
                              .firstWhere(
                                (cat) => cat.id == v.productSubcategoryId,
                                orElse: () =>
                                    ProductSubCategoryModel(name: 'Unknown'),
                              )
                              .name,
                          (v) =>
                              v.quotationList
                                  ?.map((m) => m.vendorName)
                                  .join(', ') ??
                              'No quotation'.tr(),
                          (v) =>
                              v.quotationList
                                  ?.map((item) => item.quantity)
                                  .join(', ') ??
                              'Quantity'.tr(),
                          (v) =>
                              v.quotationList
                                  ?.map((item) => item.perItem)
                                  .join(', ') ??
                              'Per Item'.tr(),
                          (v) =>
                              v.quotationList
                                  ?.map((item) => item.totalPrice)
                                  .join(', ') ??
                              'total Price'.tr(),
                        ],
                        getId: (v) => v.id,
                        selectedIds: selectedProductIds,
                        onSelectChanged: (val, quotation) {
                          setState(() {
                            if (val == true) {
                              selectedProductIds.add(quotation.id!);
                            } else {
                              selectedProductIds.remove(quotation.id);
                            }
                          });
                        },
                        onView: (quotation) {
                          showViewDialog(quotation);
                          debugPrint(
                            'quotationBeingEdited: ${quotationBeingEdited!.toMap()}',
                          );
                        },
                        onEdit: (quotation) {
                          setState(() {
                            showProductList = false;
                            quotationBeingEdited = quotation;
                            debugPrint(
                              'quotationBeingEdited: ${quotationBeingEdited!.toMap()}',
                            );
                          });
                          // quotationBeingEdited = quotation;
                          // showAlert(
                          //   isEdit: true,
                          //   quotation: quotationBeingEdited,
                          //   onBack: () async {
                          //     await _loadProducts();
                          //   },
                          // );
                        },
                        onStatus: (quotation) {},
                        statusTextGetter: (item) => item.status,
                        onSelectAll: (val) {
                          setState(() {
                            final ids = pagedquotations
                                .map((e) => e.id!)
                                .toList();
                            if (val == true) {
                              selectedProductIds.addAll(ids);
                            } else {
                              selectedProductIds.removeAll(ids);
                            }
                          });
                        },
                        onSearch: (query) {
                          setState(() {
                            displayedQuotations = allQuotations.where((
                              quotationModel,
                            ) {
                              return quotationModel.quotationList?.any((
                                    quotation,
                                  ) {
                                    final vendorName =
                                        quotation.vendorName ?? '';
                                    return vendorName.toLowerCase().contains(
                                      query.toLowerCase(),
                                    );
                                  }) ??
                                  false;
                            }).toList();
                          });
                        },
                      ),
                Align(
                  alignment: Alignment.topRight,
                  child: PaginationWidget(
                    currentPage: currentPage,
                    totalItems: allQuotations.length,
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
        : AddEditProcurementQuotation(
            isEdit: quotationBeingEdited != null,
            quotaionModel: quotationBeingEdited,
            onBack: () async {
              await _loadProducts();
              setState(() {
                showProductList = true;
                quotationBeingEdited = null;
              });
            },
          );
  }
}
