import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/purchase_models/grn/grn_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_order_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

class AddEditGoodsReceiveNote extends StatefulWidget {
  final VoidCallback? onBack;

  const AddEditGoodsReceiveNote({super.key, this.onBack});

  @override
  State<AddEditGoodsReceiveNote> createState() =>
      _AddEditGoodsReceiveNoteState();
}

class _AddEditGoodsReceiveNoteState extends State<AddEditGoodsReceiveNote> {
  List<PurchaseOrderModel> allPurchaseOrders = [];
  List<PurchaseOrderModel> displayedPurchaseOrders = [];
  bool isLoading = true;
  bool showInventoryList = true;
  TextEditingController searchController = TextEditingController();
  PurchaseOrderModel? purchaseOrderBeingEdited;
  List<ProductCategoryModel> productsCategories = [];
  List<ProductSubCatorymodel> subCategories = [];
  List<ProductModel> allProducts = [];
  List<VendorModel> vendors = [];

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedPurchaseId = {};
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

  @override
  void initState() {
    super.initState();
    _loadPurchaseOrders();
    searchController.addListener(_filterPurchaseOrders);
  }

  // Future<void> _loadPurchaseOrders() async {
  //   setState(() => isLoading = true);
  //   try {
  //     final orders = await DataFetchService.fetchPurchaseOrder();
  //     setState(() {
  //       allPurchaseOrders =
  //           orders.where((po) => po.status == 'pending').toList();
  //       displayedPurchaseOrders = allPurchaseOrders;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //   }
  // }

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

  void _filterPurchaseOrders() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        displayedPurchaseOrders = allPurchaseOrders;
      } else {
        displayedPurchaseOrders = allPurchaseOrders.where((po) {
          return po.vendorName!.toLowerCase().contains(query) ||
              po.productName!.toLowerCase().contains(query) ||
              po.id!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _showCreateGrnDialog(PurchaseOrderModel purchaseOrder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateGrnDialog(
          purchaseOrder: purchaseOrder,
          onGrnCreated: () {
            Navigator.of(context).pop();
            _loadPurchaseOrders(); // Refresh the list
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = displayedPurchaseOrders
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();
    return Column(
      children: [
        PageHeaderWidget(
          title: 'Goods Received Notes'.tr(),
          buttonText: "Refresh".tr(),
          subTitle: "Manage received goods against purchase orders".tr(),
          onCreate: _loadPurchaseOrders,
          buttonWidth: 0.2,
          selectedItems: [],
        ),
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: CustomMmTextField(
        //     controller: searchController,
        //     labelText: 'Search Purchase Orders'.tr(),
        //     hintText: 'Search by vendor, product, or PO number'.tr(),
        //     //prefixIcon: Icon(Icons.search),
        //   ),
        // ),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : DynamicDataTable<PurchaseOrderModel>(
                data: pagedItems,
                isWithImage: true,
                combineImageWithTextIndex: 2,
                columns: procurementHeaders,
                valueGetters: [
                  (v) => '${"PO"} - ${v.poNumber}',
                  (v) => '${"REQ"} - ${v.requisitionNumber}',
                  (v) {
                    final product = allProducts.firstWhere(
                      (p) => p.id == v.productId!,
                      orElse: () =>
                          ProductModel(productName: "Unknown", image: ""),
                    );
                    return '${product.productName}, ${product.image ?? ""}';
                  },
                  (v) => productsCategories
                      .firstWhere(
                        (cat) => cat.id == v.productId,
                        orElse: () => ProductCategoryModel(productName: 'N/A'),
                      )
                      .productName,
                  (v) => subCategories
                      .firstWhere(
                        (cat) => cat.id == v.subCatId,
                        orElse: () => ProductSubCatorymodel(name: 'N/A'),
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
                ],
                getId: (v) => v.id,
                selectedIds: selectedPurchaseId,
                onSelectChanged: (value, inventory) {
                  _showCreateGrnDialog(inventory);
                },
                onEdit: (inventory) {
                  setState(() {
                    purchaseOrderBeingEdited = inventory;
                    showInventoryList = false;
                  });
                },
                onStatus: (product) {},
                statusTextGetter: (item) => item.status!.capitalizeFirst,
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
                          (item) => item.productId!.toLowerCase().contains(
                            query.toLowerCase(),
                          ),
                        )
                        .toList();
                  });
                },
              ),
        // Expanded(
        //   child: displayedPurchaseOrders.isEmpty
        //       ? EmptyWidget(text: "No approved purchase orders found".tr())
        //       : ListView.builder(
        //           itemCount: displayedPurchaseOrders.length,
        //           itemBuilder: (context, index) {
        //             final po = displayedPurchaseOrders[index];
        //             return _PurchaseOrderCard(
        //               purchaseOrder: po,
        //               onTap: () => _showCreateGrnDialog(po),
        //             );
        //           },
        //         ),
        // ),
      ],
    );
  }
}

// class _PurchaseOrderCard extends StatelessWidget {
//   final PurchaseOrderModel purchaseOrder;
//   final VoidCallback onTap;

//   const _PurchaseOrderCard({
//     required this.purchaseOrder,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         title: Text(purchaseOrder.productName ?? "",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Vendor: ${purchaseOrder.vendorName}'),
//             Text('PO #: ${purchaseOrder.id}'),
//             Text('Quantity: ${purchaseOrder.quantity}'),
//             Text('Status: ${purchaseOrder.status?.toUpperCase()}'),
//           ],
//         ),
//         trailing: IconButton(
//           icon: Icon(Icons.add_box, color: Colors.blue),
//           onPressed: onTap,
//           tooltip: 'Create GRN',
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
// }

class CreateGrnDialog extends StatefulWidget {
  final PurchaseOrderModel purchaseOrder;
  final VoidCallback onGrnCreated;

  const CreateGrnDialog({
    super.key,
    required this.purchaseOrder,
    required this.onGrnCreated,
  });

  @override
  State<CreateGrnDialog> createState() => _CreateGrnDialogState();
}

class _CreateGrnDialogState extends State<CreateGrnDialog> {
  final TextEditingController receivedByController = TextEditingController();
  final TextEditingController receivedQtyController = TextEditingController();
  final TextEditingController rejectedQtyController = TextEditingController(
    text: "0",
  );
  final TextEditingController notesController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    receivedQtyController.text = widget.purchaseOrder.quantity.toString();
  }

  Future<void> _submitGrn() async {
    if (receivedByController.text.isEmpty) {
      Constants.showMessage(context, "Please enter the receiver's name");
      return;
    }

    final double receivedQty = double.tryParse(receivedQtyController.text) ?? 0;
    final double rejectedQty = double.tryParse(rejectedQtyController.text) ?? 0;
    final double orderedQty = widget.purchaseOrder.quantity is int
        ? (widget.purchaseOrder.quantity as int).toDouble()
        : (widget.purchaseOrder.quantity as double);

    if (receivedQty <= 0) {
      Constants.showMessage(
        context,
        "Received quantity must be greater than 0",
      );
      return;
    }

    if (receivedQty + rejectedQty > orderedQty) {
      Constants.showMessage(
        context,
        "Received + rejected quantity cannot exceed ordered quantity",
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final grnId = FirebaseFirestore.instance.collection('grn').doc().id;
      String grnNumber = await Constants.getUniqueNumber("GRN");
      final grn = GrnModel(
        productCategoryId: widget.purchaseOrder.productCategoryId!,
        purchaseId: widget.purchaseOrder.purchaseId!,
        requisitionId: widget.purchaseOrder.requisitionId!,
        id: grnId,
        poId: widget.purchaseOrder.id!,
        productId: widget.purchaseOrder.productId!,
        productCode: "", //widget.purchaseOrder.productCode ?? '',
        orderedQuantity: orderedQty,
        receivedQuantity: receivedQty,
        rejectedQuantity: rejectedQty,
        timestamp: Timestamp.now(),
        receivedBy: receivedByController.text,
        createdBy: userId,
        status: _calculateGrnStatus(orderedQty, receivedQty),
        notes: notesController.text,
        grnNumber: grnNumber,
        poNumber: widget.purchaseOrder.poNumber!,
        requisitionNumber: widget.purchaseOrder.requisitionNumber!,
        vendorId: widget.purchaseOrder.vendorId!,
        productSubId: widget.purchaseOrder.subCatId!,
      );
      await DataUploadService.addGrn(grn);
      if (mounted) {
        Navigator.of(context).pop();
      }
      await _updateInventory(grn);
      //widget.onBack?.call();
      if (mounted) {
        Constants.showMessage(context, "GRN created successfully");
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, "Error creating GRN: $e");
      }
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  Future<void> _updateInventory(GrnModel grn) async {
    // Implement inventory update logic here
    print("Inventory updated: ${grn.productCode} + ${grn.receivedQuantity}");
  }

  String _calculateGrnStatus(double ordered, double received) {
    if (received <= 0) return 'pending';
    if (received >= ordered) return 'completed';
    return 'partial';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create GRN for ${"PO"}-${widget.purchaseOrder.poNumber}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('Purchase Order: ${widget.purchaseOrder.id}'),
              Text('Vendor: ${widget.purchaseOrder.vendorName}'),
              Text('Ordered Quantity: ${widget.purchaseOrder.quantity}'),
              Divider(height: 32),
              CustomMmTextField(
                controller: receivedByController,
                labelText: 'Received By'.tr(),
                hintText: 'Name of person who received goods'.tr(),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomMmTextField(
                      controller: receivedQtyController,
                      labelText: 'Received Quantity'.tr(),
                      hintText: 'Enter received quantity'.tr(),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationUtils.quantity,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomMmTextField(
                      controller: rejectedQtyController,
                      labelText: 'Rejected/Damaged'.tr(),
                      hintText: 'Enter rejected quantity'.tr(),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationUtils.quantity,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              CustomMmTextField(
                controller: notesController,
                labelText: 'Notes (Optional)'.tr(),
                hintText: 'Any additional notes'.tr(),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text('Cancel'.tr()),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submitGrn,
                    child: isSubmitting
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text('Create GRN'.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
