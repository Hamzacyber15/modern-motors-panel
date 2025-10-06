// import 'package:app/constants.dart';
// import 'package:app/modern_motors/models/inventory/mminventory_batches_model.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/widgets/dynamic_data_table.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/page_header_widget.dart';
// import 'package:app/modern_motors/widgets/pagination_widget.dart';
// import 'package:app/widgets/empty_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class ProductInventoryBatches extends StatefulWidget {
//   final ProductModel product;

//   const ProductInventoryBatches({super.key, required this.product});

//   @override
//   State<ProductInventoryBatches> createState() =>
//       _ProductInventoryBatchesState();
// }

// class _ProductInventoryBatchesState extends State<ProductInventoryBatches> {
//   bool isLoading = true;
//   List<MmInventoryBatchesModel> inventoryBatches = [];
//   int currentPage = 0;
//   int itemsPerPage = 10;

//   final headers = [
//     'Batch Reference'.tr(),
//     'Received Date'.tr(),
//     'Quantity Received'.tr(),
//     'Quantity Remaining'.tr(),
//     'Unit Cost'.tr(),
//     'Total Value'.tr(),
//     'Remaining Value'.tr(),
//     'Status'.tr(),
//     'GRN ID'.tr(),
//     'PO ID'.tr(),
//     'Created At'.tr(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadInventoryBatches();
//   }

//   Future<void> _loadInventoryBatches() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('mmInventoryBatches')
//           .where('productId', isEqualTo: widget.product.id)
//           .orderBy('receivedDate', descending: true)
//           .get();

//       final batches = snapshot.docs.map((doc) {
//         return MmInventoryBatchesModel.fromJson(doc.data(), doc.id);
//       }).toList();

//       setState(() {
//         inventoryBatches = batches;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (mounted) {
//         Constants.showMessage(context, ('Error loading inventory batches: $e'));
//       }
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pagedItems = inventoryBatches
//         .skip(currentPage * itemsPerPage)
//         .take(itemsPerPage)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inventory Batches - ${widget.product.productName}'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 PageHeaderWidget(
//                   title: 'Inventory Batches'.tr(),
//                   subTitle: 'Batch history for ${widget.product.productName}',
//                   buttonText: 'Refresh'.tr(),
//                   onCreate: _loadInventoryBatches,
//                   selectedItems: [],
//                 ),
//                 inventoryBatches.isEmpty
//                     ? EmptyWidget(
//                         text:
//                             "No inventory batches found for this product".tr(),
//                       )
//                     : Expanded(
//                         child: DynamicDataTable<MmInventoryBatchesModel>(
//                           data: pagedItems,
//                           columns: headers,
//                           valueGetters: [
//                             (batch) => batch.batchReference,
//                             (batch) =>
//                                 batch.receivedDate.toDate().formattedWithYMDHMS,
//                             (batch) => batch.quantityReceived.toString(),
//                             (batch) => batch.quantityRemaining.toString(),
//                             (batch) =>
//                                 '${"OMR"}${batch.unitCost.toStringAsFixed(2)}',
//                             (batch) =>
//                                 '${"OMR"}${batch.totalValue.toStringAsFixed(2)}',
//                             (batch) =>
//                                 '${"OMR"}${batch.remainingValue.toStringAsFixed(2)}',
//                             (batch) => batch.status,
//                             (batch) => batch.grnId.substring(0, 8),
//                             (batch) => batch.poId.substring(0, 8),
//                             (batch) => batch.createdAt
//                                 .toDate()
//                                 .formattedWithDayMonthYear,
//                           ],
//                           getId: (batch) => batch.id,
//                           selectedIds: {},
//                           onSelectChanged: null,
//                           onEdit: null,
//                           onStatus: null,
//                           onView: null,
//                           onSelectAll: null,
//                           onSearch: (query) {
//                             // Optional: Implement search functionality if needed
//                           },
//                           showRowNumbers: true,
//                         ),
//                       ),
//                 inventoryBatches.length > itemsPerPage
//                     ? PaginationWidget(
//                         currentPage: currentPage,
//                         totalItems: inventoryBatches.length,
//                         itemsPerPage: itemsPerPage,
//                         onPageChanged: (newPage) {
//                           setState(() {
//                             currentPage = newPage;
//                           });
//                         },
//                         onItemsPerPageChanged: (newLimit) {
//                           setState(() {
//                             itemsPerPage = newLimit;
//                             currentPage = 0;
//                           });
//                         },
//                       )
//                     : const SizedBox.shrink(),
//               ],
//             ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/inventory_models/modern_motors.dart/mminventory_batches_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/products/inventory_batches_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ProductInventoryBatches extends StatefulWidget {
  final ProductModel product;

  const ProductInventoryBatches({super.key, required this.product});

  @override
  State<ProductInventoryBatches> createState() =>
      _ProductInventoryBatchesState();
}

class _ProductInventoryBatchesState extends State<ProductInventoryBatches> {
  bool isLoading = true;
  List<MmInventoryBatchesModel> inventoryBatches = [];
  int currentPage = 0;
  int itemsPerPage = 10;

  final headers = [
    'Batch Reference'.tr(),
    'Received Date'.tr(),
    'Quantity Received'.tr(),
    'Quantity Remaining'.tr(),
    'Unit Cost'.tr(),
    'Total Value'.tr(),
    'Remaining Value'.tr(),
    'Status'.tr(),
    'GRN ID'.tr(),
    'PO ID'.tr(),
    'Created At'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInventoryBatches();
  }

  Future<void> _loadInventoryBatches() async {
    setState(() {
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mmInventoryBatches')
          .where('productId', isEqualTo: widget.product.id)
          .orderBy('receivedDate', descending: true)
          .get();

      final batches = snapshot.docs.map((doc) {
        return MmInventoryBatchesModel.fromJson(doc.data(), doc.id);
      }).toList();

      setState(() {
        inventoryBatches = batches;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, ('Error loading inventory batches: $e'));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = inventoryBatches
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Inventory Batches - ${widget.product.productName}'),
    //     leading: IconButton(
    //       icon: const Icon(Icons.arrow_back),
    //       onPressed: () => Navigator.of(context).pop(),
    //     ),
    //   ),
    //   body: isLoading
    //       ? const Center(child: CircularProgressIndicator())
    //       :
    Column(
      children: [
        PageHeaderWidget(
          title: 'Inventory Batches'.tr(),
          subTitle: 'Batch history for ${widget.product.productName}',
          buttonText: 'Refresh'.tr(),
          onCreate: _loadInventoryBatches,
          selectedItems: [],
        ),
        inventoryBatches.isEmpty
            ? EmptyWidget(
                text: "No inventory batches found for this product".tr(),
              )
            : Expanded(
                child: InventoryBatchesWidget(
                  inventoryBatches: inventoryBatches,
                  isLoading: false,
                  onRefresh: _loadInventoryBatches,
                ),
              ),
        //     : DynamicDataTable<MmInventoryBatchesModel>(
        //         data: pagedItems,
        //         columns: headers
        //         valueGetters: [
        //           (batch) => batch.batchReference,
        //           (batch) => batch.receivedDate.toDate().formattedWithYMDHMS,
        //           (batch) => batch.quantityReceived.toString(),
        //           (batch) => batch.quantityRemaining.toString(),
        //           (batch) => '${"OMR"} ${batch.unitCost.toStringAsFixed(2)}',
        //           (batch) =>
        //               '${"OMR"} ${batch.totalValue.toStringAsFixed(2)}',
        //           (batch) =>
        //               '${"OMR"} ${batch.remainingValue.toStringAsFixed(2)}',
        //           (batch) => batch.status,
        //           (batch) => batch.grnId.isNotEmpty
        //               ? batch.grnId.substring(
        //                   0, batch.grnId.length > 8 ? 8 : batch.grnId.length)
        //               : 'N/A',
        //           (batch) => batch.poId.isNotEmpty
        //               ? batch.poId.substring(
        //                   0, batch.poId.length > 8 ? 8 : batch.poId.length)
        //               : 'N/A',
        //           (batch) =>
        //               batch.createdAt.toDate().formattedWithDayMonthYear,
        //         ],
        //         getId: (batch) => batch.id,
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
        // inventoryBatches.length > itemsPerPage
        //     ? PaginationWidget(
        //         currentPage: currentPage,
        //         totalItems: inventoryBatches.length,
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
        //:
        const SizedBox.shrink(),
      ],
      //    ),
    );
  }
}
