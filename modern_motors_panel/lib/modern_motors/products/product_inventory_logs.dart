import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/inventory_models/modern_motors.dart/mminventory_logs.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/products/inventory_logs_timeline.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ProductInventoryLogs extends StatefulWidget {
  final ProductModel product;

  const ProductInventoryLogs({super.key, required this.product});

  @override
  State<ProductInventoryLogs> createState() => _ProductInventoryLogsState();
}

class _ProductInventoryLogsState extends State<ProductInventoryLogs> {
  bool isLoading = true;
  List<MmInventoryLog> inventoryLogs = [];
  int currentPage = 0;
  int itemsPerPage = 10;

  final headers = [
    'Date'.tr(),
    'Type'.tr(),
    'Document'.tr(),
    'Change'.tr(),
    'Previous Stock'.tr(),
    'New Stock'.tr(),
    'Previous Avg Cost'.tr(),
    'New Avg Cost'.tr(),
    'Price/Unit'.tr(),
    'Value Impact'.tr(),
    'Note'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInventoryLogs();
  }

  Future<void> _loadInventoryLogs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mmInventoryLogs')
          .where('productId', isEqualTo: widget.product.id)
          .orderBy('timestamp', descending: true)
          .get();

      final logs = snapshot.docs.map((doc) {
        return MmInventoryLog.fromJson(doc.data(), doc.id);
      }).toList();

      setState(() {
        inventoryLogs = logs;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Error loading inventory logs: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = inventoryLogs
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Inventory Logs - ${widget.product.productName}'),
    //     leading: IconButton(
    //       icon: const Icon(Icons.arrow_back),
    //       onPressed: () => Navigator.of(context).pop(),
    //     ),
    //   ),
    //   body:
    isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              PageHeaderWidget(
                title: 'Inventory Logs'.tr(),
                subTitle:
                    'Transaction history for ${widget.product.productName}',
                buttonText: 'Refresh'.tr(),
                onCreate: _loadInventoryLogs,
                selectedItems: [],
              ),
              inventoryLogs.isEmpty
                  ? EmptyWidget(
                      text: "No inventory logs found for this product".tr(),
                    )
                  : Expanded(
                      child: InventoryLogsTimeline(
                        inventoryLogs: inventoryLogs,
                        isLoading: false,
                        onRefresh: _loadInventoryLogs,
                      ),
                    ),
              //     : DynamicDataTable<MmInventoryLog>(
              //         data: pagedItems,
              //         columns: headers,
              //         valueGetters: [
              //           (log) => log.timestamp
              //               .toDate()
              //               .formattedWithDayMonthYear,
              //           (log) => log.type.capitalizeFirst,
              //           (log) =>
              //               '${log.documentType.toUpperCase()}-${log.documentId.substring(0, 8)}',
              //           (log) => log.change > 0
              //               ? '+${log.change}'
              //               : log.change.toString(),
              //           (log) => log.previousStock.toString(),
              //           (log) => log.newStock.toString(),
              //           (log) =>
              //               '${"OMR"} ${log.previousAverageCost.toStringAsFixed(2)}',
              //           (log) =>
              //               '${"OMR"} ${log.newAverageCost.toStringAsFixed(2)}',
              //           (log) =>
              //               '${"OMR"} ${log.valueImpact / log.change}',
              //           (log) =>
              //               '${"OMR"} ${log.valueImpact.toStringAsFixed(2)}',
              //           (log) => log.note,
              //         ],
              //         getId: (log) => log.id,
              //         selectedIds: {},
              //         onSelectChanged: null,
              //         onEdit: null,
              //         onStatus: null,
              //         onView: null,
              //         onSelectAll: null,
              //         onSearch: (query) {
              //           // Optional: Implement search functionality if needed
              //         },
              //         showRowNumbers: true,
              //       ),
              // inventoryLogs.length > itemsPerPage
              //     ? PaginationWidget(
              //         currentPage: currentPage,
              //         totalItems: inventoryLogs.length,
              //         itemsPerPage: itemsPerPage,
              //         onPageChanged: (newPage) {
              //           setState(() {
              //             currentPage = newPage;
              //           });
              //         },
              //         onItemsPerPageChanged: (newLimit) {
              //           setState(() {
              //             itemsPerPage = newLimit;
              //             currentPage = 0;
              //           });
              //         },
              //       )
              //     : const SizedBox.shrink(),
            ],
          );
  }
}

// Add this to your existing MmInventoryLog class or create it if it doesn't exist
extension MmInventoryLogExtension on MmInventoryLog {
  String get formattedDate => timestamp.toDate().formattedWithDayMonthYear;

  String get formattedChange => change > 0 ? '+$change' : change.toString();

  String get formattedPreviousAverageCost =>
      '\$${previousAverageCost.toStringAsFixed(2)}';

  String get formattedNewAverageCost =>
      '\$${newAverageCost.toStringAsFixed(2)}';

  String get formattedValueImpact => '\$${valueImpact.toStringAsFixed(2)}';

  String get shortDocumentId =>
      documentId.length > 8 ? '${documentId.substring(0, 8)}...' : documentId;
}
