// import 'package:app/app_theme.dart';
// import 'package:app/constants.dart';
// import 'package:app/loading_widget.dart';
// import 'package:app/models/attachment_model.dart';
// import 'package:app/modern_motors/models/product/product_sub_catorymodel.dart';
// import 'package:app/modern_motors/models/product_category_model.dart';
// import 'package:app/modern_motors/models/purchases/purchase_order_model.dart';
// import 'package:app/modern_motors/models/vendor/vendors_model.dart';
// import 'package:app/modern_motors/services/data_upload_service.dart';
// import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:app/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
// import 'package:app/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/page_header_widget.dart';
// import 'package:app/provider/connectivity_provider.dart';
// import 'package:app/provider/resource_provider.dart';
// import 'package:app/widgets/overlayloader.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProcurementAddEditPurchaseOrder extends StatefulWidget {
//   final VoidCallback? onBack;
//   final PurchaseOrderModel? purchaseOrderModel;
//   final bool isEdit;

//   const ProcurementAddEditPurchaseOrder({
//     super.key,
//     this.onBack,
//     this.purchaseOrderModel,
//     required this.isEdit,
//   });

//   @override
//   State<ProcurementAddEditPurchaseOrder> createState() =>
//       _ProcurementAddEditPurchaseOrderState();
// }

// class _ProcurementAddEditPurchaseOrderState
//     extends State<ProcurementAddEditPurchaseOrder> {
//   final TextEditingController salePriceController = TextEditingController();
//   final TextEditingController searchController = TextEditingController();
//   final TextEditingController referenceController = TextEditingController();
//   final TextEditingController taxController = TextEditingController();
//   final TextEditingController discountController = TextEditingController();
//   final TextEditingController shippingController = TextEditingController();
//   List<AttachmentModel> attachments = [];
//   GlobalKey<FormState> createInventoryKey = GlobalKey<FormState>();
//   List<ProductCategoryModel> productsCategories = [];
//   List<ProductSubCatorymodel> subCategories = [];
//   List<Map<String, dynamic>> quotationList = [];
//   List<ProductSubCatorymodel> associatedSubCategories = [];
//   List<VendorModel> vendors = [];
//   List<Map<String, dynamic>> requisitions = [];
//   List<Map<String, dynamic>> tempList = [];
//   List<Map<String, dynamic>> selectedItems = []; // Actual added items
//   List<ProductCategoryModel> productList = [];
//   List<ProductSubCatorymodel> subCategoryList = [];
//   List<Map<String, dynamic>> filteredRequisitions = [];
//   Set<String> productIdsSet = {};
//   Set<String> subCatIdsSet = {};
//   Set<String> addedRowIds = {}; // Track which rows are selected
//   ValueNotifier<bool> loading = ValueNotifier(false);
//   ValueNotifier<bool> catLoader = ValueNotifier(false);
//   bool status = true;
//   bool isLoading = false;
//   bool active = true;
//   String? selectedProductId;
//   String? selectedProduct;
//   String? selectedSubCategoryId;
//   String? selectedSubCategory;
//   String? selectedVendorId;
//   String? selectedVendor;
//   String? selectStatus;
//   double totalCostPrice = 0.0;

//   final Map<String, String> statusItems = {
//     'pending': 'Pending',
//     'delivered': 'Delivered',
//   };

//   @override
//   void initState() {
//     super.initState();
//     loadVendorsFromAllQuotations();
//     searchController.addListener(_filterRequisitions);
//   }

//   Future<List<VendorModel>> fetchApprovedVendorsFromQuotations() async {
//     final List<VendorModel> vendorList = [];
//     final Set<String> seenVendorIds = {};

//     try {
//       final snapshot =
//           await FirebaseFirestore.instance.collectionGroup('quotations').get();

//       for (final doc in snapshot.docs) {
//         final data = doc.data();
//         final quotationList = data['quotationList'] as List<dynamic>?;

//         if (quotationList != null) {
//           for (final item in quotationList) {
//             final vendorId = item['vendorId'];
//             final vendorName = item['vendorName'];
//             final status = item['status'];

//             if (status == "approved" &&
//                 vendorId != null &&
//                 !seenVendorIds.contains(vendorId)) {
//               seenVendorIds.add(vendorId);
//               vendorList.add(
//                 VendorModel(id: vendorId, vendorName: vendorName ?? ''),
//               );
//             }
//           }
//         }
//       }

//       debugPrint("Approved vendors found: ${vendorList.length}");
//       return vendorList;
//     } catch (e) {
//       debugPrint("Error fetching approved vendors: $e");
//       return [];
//     }
//   }

//   Future<void> fetchPurchaseRequisitionsByVendor(String vendorId) async {
//     tempList.clear();
//     productIdsSet.clear();
//     subCatIdsSet.clear();
//     productList.clear();
//     subCategoryList.clear();

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final requisitionSnapshot = await FirebaseFirestore.instance
//           .collectionGroup('purchaseRequisitions')
//           .where('status', isEqualTo: "Accepted")
//           .get();

//       for (var doc in requisitionSnapshot.docs) {
//         final data = doc.data();
//         final productId = data['productId'];
//         final subCatId = data['subCatId'];
//         final requisitionId = doc.id;

//         if (productId != null && productId.isNotEmpty) {
//           productIdsSet.add(productId);
//         }
//         if (subCatId != null && subCatId.isNotEmpty) {
//           subCatIdsSet.add(subCatId);
//         }

//         // Fetch product name
//         String productName = '';
//         if (productId != null && productId.isNotEmpty) {
//           final productSnap = await FirebaseFirestore.instance
//               .collection('productsCategory')
//               .doc(productId)
//               .get();
//           productName = productSnap.data()?['productName'] ?? '';
//         }

//         // Fetch subcategory name
//         String subCatName = '';
//         if (subCatId != null && subCatId.isNotEmpty) {
//           final subCatSnap = await FirebaseFirestore.instance
//               .collection('subCategory')
//               .doc(subCatId)
//               .get();
//           subCatName = subCatSnap.data()?['name'] ?? '';
//         }

//         // Fetch quotation document where requisitionIds == requisitionId
//         final quotationSnapshot = await FirebaseFirestore.instance
//             .collectionGroup('quotations')
//             .where('requisitionIds', isEqualTo: requisitionId)
//             .get();

//         List<Map<String, dynamic>> vendorQuotations = [];

//         if (quotationSnapshot.docs.isNotEmpty) {
//           final quotationDoc = quotationSnapshot.docs.first;
//           final quotationData = quotationDoc.data();

//           if (quotationData.containsKey('quotationList')) {
//             final List quotationList = quotationData['quotationList'];

//             for (var quote in quotationList) {
//               if (quote['vendorId'] == vendorId) {
//                 vendorQuotations.add(Map<String, dynamic>.from(quote));
//               }
//             }
//           }
//         }

//         for (var quote in vendorQuotations) {
//           tempList.add({
//             "source": "Quotation",
//             "productId": productName,
//             "subCatId": subCatName,
//             "quantity": quote['quantity'] ?? 0,
//             "status": quote['status'] ?? '',
//             "createdBy": data['createdBy'] ?? '',
//             "totalPrice": quote['totalPrice'] ?? 0,
//             "vendorName": quote['vendorName'] ?? '',
//             "perItem": quote['perItem'] ?? 0,
//             "imageURL": quote['imageURL'] ?? '',
//           });
//         }

//         // Fetch product details
//         for (String pid in productIdsSet) {
//           final productSnap = await FirebaseFirestore.instance
//               .collection('productsCategory')
//               .doc(pid)
//               .get();

//           if (productSnap.exists) {
//             productList.add(ProductCategoryModel.fromDoc(productSnap));
//           }
//         }

//         // Fetch subcategory details
//         for (String sid in subCatIdsSet) {
//           final subCatSnap = await FirebaseFirestore.instance
//               .collection('subCategory')
//               .doc(sid)
//               .get();

//           if (subCatSnap.exists) {
//             subCategoryList.add(ProductSubCatorymodel.fromDoc(subCatSnap));
//           }
//         }

//         setState(() {
//           requisitions = tempList;
//           filteredRequisitions = tempList;
//           productsCategories = productList;
//           subCategories = subCategoryList;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error fetching requisitions by vendor: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _filterRequisitions() {
//     final query = searchController.text.toLowerCase();
//     setState(() {
//       filteredRequisitions = requisitions.where((item) {
//         final productName = (item['productId'] ?? '').toString().toLowerCase();
//         final subCatName = (item['subCatId'] ?? '').toString().toLowerCase();

//         final matchesQuery =
//             productName.contains(query) || subCatName.contains(query);

//         final matchesProduct = selectedProductId == null ||
//             productsCategories
//                     .firstWhere((p) => p.id == selectedProductId)
//                     .productName
//                     .toLowerCase() ==
//                 productName;

//         final matchesSubCat = selectedSubCategoryId == null ||
//             subCategories
//                     .firstWhere((s) => s.id == selectedSubCategoryId)
//                     .name
//                     .toLowerCase() ==
//                 subCatName;

//         return matchesQuery && matchesProduct && matchesSubCat;
//       }).toList();
//     });
//   }

//   void submitPurchaseOrder() async {
//     if (loading.value) {
//       return;
//     }
//     if (selectedItems.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Please select a row first")));
//       return;
//     }
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (!mounted) {
//       return;
//     }
//     final profile = context.read<ResourceProvider>().getProfileByID(uid!);
//     if (profile.id.isEmpty) {
//       if (!mounted) return;
//       Constants.showMessage(
//         context,
//         'This Profile is not allowed this Task'.tr(),
//       );
//       loading.value = false;
//       return;
//     }

//     final branchId = profile.id;
//     final selectedData = selectedItems.first;
//     debugPrint("check Data ===== $selectedData");
//     final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//     final quantity = (selectedData["quantity"] ?? 0) as int;
//     final perItem = (selectedData["perItem"] ?? 0) as int;
//     final subTotal = quantity * perItem;
//     final tax = 0.5;
//     final totalCost = (subTotal * tax);

//     final model = PurchaseOrderModel(
//       vendorId: selectedVendorId,
//       vendorName: selectedData["vendorName"],
//       productId: selectedProductId,
//       productName: selectedData["productId"],
//       subCatId: selectedSubCategoryId,
//       subCatName: selectedData["subCatId"],
//       quantity: quantity,
//       perItem: perItem,
//       subTotal: subTotal,
//       totalCost: totalCost,
//       shipping: shippingController.text.trim(),
//       discount: discountController.text.trim(),
//       createdBy: userId,
//       referenceNo: referenceController.text.trim(),
//       branchId: branchId,
//       status: selectStatus ?? 'pending',
//     );

//     loading.value = true;

//     try {
//       await DataUploadService.addPurchaseOrderFunction(model, branchId);
//       if (mounted) {
//         Constants.showMessage(context, 'Purchase Order placed successfully');
//         widget.onBack?.call();
//         if (Navigator.of(context).canPop()) {
//           Navigator.of(context).pop();
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         Constants.showMessage(context, 'Something went wrong'.tr());
//         debugPrint('something went wrong: $e');
//       }
//     } finally {
//       loading.value = false;
//     }
//   }

//   void loadVendorsFromAllQuotations() async {
//     final result = await fetchApprovedVendorsFromQuotations();
//     setState(() {
//       vendors = result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ConnectivityResult connectionStatus =
//         context.watch<ConnectivityProvider>().connectionStatus;
//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: PageHeaderWidget(
//             title: 'Add Purchase'.tr(),
//             buttonText: 'Back to Purchases'.tr(),
//             subTitle: 'Create New Purchase'.tr(),
//             onCreateIcon: 'assets/icons/back.png',
//             selectedItems: [],
//             buttonWidth: 0.4,
//             onCreate: widget.onBack!.call,
//             onDelete: () async {},
//           ),
//         ),
//         isLoading
//             ? LoadingWidget()
//             : SliverToBoxAdapter(
//                 child: OverlayLoader(
//                   loader: catLoader.value,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: AppTheme.whiteColor,
//                         borderRadius: BorderRadius.circular(8),
//                         border:
//                             Border.all(color: AppTheme.borderColor, width: 0.6),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 16, top: 10),
//                             child: Text(
//                               'Purchase Information'.tr(),
//                               style: AppTheme.getCurrentTheme(
//                                       false, connectionStatus)
//                                   .textTheme
//                                   .bodyMedium!
//                                   .copyWith(fontSize: 16),
//                             ),
//                           ),
//                           Divider(),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 10,
//                             ),
//                             child: Form(
//                               key: createInventoryKey,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: CustomSearchableDropdown(
//                                           key: UniqueKey(),
//                                           hintText: 'Choose Vendor'.tr(),
//                                           value: selectedVendorId,
//                                           items: {
//                                             for (var u in vendors)
//                                               u.id!: u.vendorName,
//                                           },
//                                           onChanged: (val) {
//                                             setState(() {
//                                               selectedVendorId = val;
//                                               selectedVendor = vendors
//                                                   .firstWhere(
//                                                       (v) => v.id == val)
//                                                   .vendorName;
//                                             });

//                                             if (selectedVendorId != null) {
//                                               fetchPurchaseRequisitionsByVendor(
//                                                 selectedVendorId!,
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                       10.w,
//                                       Expanded(
//                                         child: CustomSearchableDropdown(
//                                           hintText:
//                                               'Choose Product Category'.tr(),
//                                           value: selectedProductId,
//                                           items: {
//                                             for (var u in productsCategories)
//                                               u.id!: u.productName,
//                                           },
//                                           onChanged: (val) => setState(() {
//                                             selectedProductId = val;
//                                             associatedSubCategories =
//                                                 subCategories
//                                                     .where(
//                                                       (sub) =>
//                                                           sub.catId?.contains(
//                                                             val,
//                                                           ) ??
//                                                           false,
//                                                     )
//                                                     .toList();
//                                             _filterRequisitions();
//                                           }),
//                                         ),
//                                       ),
//                                       10.w,
//                                       Expanded(
//                                         child: CustomSearchableDropdown(
//                                           hintText: 'Choose Sub Category'.tr(),
//                                           value: selectedSubCategoryId,
//                                           items: {
//                                             for (var u
//                                                 in associatedSubCategories)
//                                               u.id!: u.name,
//                                           },
//                                           onChanged: (val) => setState(() {
//                                             selectedSubCategoryId = val;
//                                             debugPrint(
//                                               'Selected Sub Category >>>>>>>> $selectedSubCategoryId',
//                                             );
//                                             _filterRequisitions();
//                                           }),
//                                         ),
//                                       ),
//                                       10.w,
//                                       Expanded(
//                                         child: CustomMmTextField(
//                                           labelText: 'Reference No'.tr(),
//                                           hintText: 'Reference No'.tr(),
//                                           controller: referenceController,
//                                           autovalidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   16.h,
//                                   Row(
//                                     children: [
//                                       SizedBox(
//                                         width: 250,
//                                         child: CustomMmTextField(
//                                           isHeadingAvailable: true,
//                                           heading: 'Product Name'.tr(),
//                                           labelText:
//                                               'Pleace Type Product Code'.tr(),
//                                           hintText: '',
//                                           controller: searchController,
//                                           autovalidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   16.h,
//                                   SizedBox(
//                                     width: 1200,
//                                     child: Container(
//                                       margin: const EdgeInsets.all(12),
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(6),
//                                         color: Colors.grey.shade100,
//                                       ),
//                                       child: SingleChildScrollView(
//                                         scrollDirection: Axis.horizontal,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             if (selectedItems.isNotEmpty)
//                                               Container(
//                                                 width: 300,
//                                                 padding:
//                                                     const EdgeInsets.all(12),
//                                                 margin: const EdgeInsets.only(
//                                                   bottom: 10,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.grey.shade100,
//                                                   border: Border.all(
//                                                     color: Colors.grey.shade300,
//                                                   ),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     8,
//                                                   ),
//                                                 ),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       'Selected Row Data:',
//                                                       style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 6),
//                                                     Text(
//                                                       "Product: ${selectedItems.first["productId"] ?? ''}",
//                                                     ),
//                                                     Text(
//                                                       "Sub Category: ${selectedItems.first["subCatId"] ?? ''}",
//                                                     ),
//                                                     Text(
//                                                       "Vendor: ${selectedItems.first["vendorName"] ?? ''}",
//                                                     ),
//                                                     Text(
//                                                       "Quantity: ${selectedItems.first["quantity"] ?? ''}",
//                                                     ),
//                                                     Text(
//                                                       "Price per Item: ${selectedItems.first["perItem"] ?? ''}",
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             SizedBox(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               child: Table(
//                                                 columnWidths: const {
//                                                   0: FlexColumnWidth(2),
//                                                   1: FlexColumnWidth(2),
//                                                   2: FlexColumnWidth(1),
//                                                   3: FlexColumnWidth(2),
//                                                   4: FlexColumnWidth(2),
//                                                   5: FlexColumnWidth(2),
//                                                   6: FlexColumnWidth(2),
//                                                   7: FlexColumnWidth(2),
//                                                   8: FlexColumnWidth(2),
//                                                   9: FlexColumnWidth(2),
//                                                   10: FlexColumnWidth(3),
//                                                 },
//                                                 border: TableBorder.all(
//                                                   color: Colors.grey.shade300,
//                                                 ),
//                                                 children: [
//                                                   TableRow(
//                                                     decoration: BoxDecoration(
//                                                       color:
//                                                           Colors.grey.shade200,
//                                                     ),
//                                                     children: [
//                                                       _TableHeaderCell(
//                                                         "Product".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                         "Sub Cat".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                           "Qty".tr()),
//                                                       _TableHeaderCell(
//                                                         "Purchase Price".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                         "Discount".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                           "Tax(%)".tr()),
//                                                       _TableHeaderCell(
//                                                         "Tax Amount".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                         "Unit Cost".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                         "Sub Total".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                         "Total Cost".tr(),
//                                                       ),
//                                                       _TableHeaderCell(
//                                                           "Action".tr()),
//                                                     ],
//                                                   ),
//                                                   ...filteredRequisitions
//                                                       .map((data) {
//                                                     debugPrint(
//                                                       'Print The Datat that Fetched>>>>>>>> $requisitions',
//                                                     );

//                                                     return TableRow(
//                                                       children: [
//                                                         _TableCell(
//                                                           data["productId"] ??
//                                                               "",
//                                                         ),
//                                                         _TableCell(
//                                                           data["subCatId"] ??
//                                                               "",
//                                                         ),
//                                                         _TableCell(
//                                                           (data["quantity"] ??
//                                                                   0)
//                                                               .toString(),
//                                                         ),
//                                                         _TableCell(
//                                                           (data["perItem"] ?? 0)
//                                                               .toString(),
//                                                         ),
//                                                         _TableCell("discount"),
//                                                         _TableCell("5%"),
//                                                         _TableCell(
//                                                           (((data["perItem"] ??
//                                                                           0) *
//                                                                       (data["quantity"] ??
//                                                                           0)) *
//                                                                   0.05)
//                                                               .toStringAsFixed(
//                                                                   2),
//                                                         ),
//                                                         _TableCell(
//                                                           (data["perItem"] ?? 0)
//                                                               .toString(),
//                                                         ),
//                                                         _TableCell(
//                                                           ((data["quantity"] ??
//                                                                       0) *
//                                                                   (data["perItem"] ??
//                                                                       0))
//                                                               .toString(),
//                                                         ),
//                                                         _TableCell(
//                                                           (((data["quantity"] ??
//                                                                           0) *
//                                                                       (data["perItem"] ??
//                                                                           0)) + // Base
//                                                                   (((data["perItem"] ??
//                                                                               0) *
//                                                                           (data["quantity"] ??
//                                                                               0)) *
//                                                                       0.05) // Tax
//                                                               )
//                                                               .toStringAsFixed(
//                                                                   2),
//                                                         ),
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             debugPrint(
//                                                               'Selected Data is %%%%%%%%%%% $addedRowIds',
//                                                             );
//                                                             final rowId =
//                                                                 "${data["productId"]}_${data["subCatId"]}_${data["vendorName"]}";

//                                                             if (addedRowIds
//                                                                 .contains(
//                                                               rowId,
//                                                             )) {
//                                                               // Removing current selected row
//                                                               setState(() {
//                                                                 addedRowIds
//                                                                     .clear();
//                                                                 selectedItems
//                                                                     .clear();
//                                                               });
//                                                             } else {
//                                                               if (addedRowIds
//                                                                   .isNotEmpty) {
//                                                                 // Already a row selected, show popup
//                                                                 showDialog(
//                                                                   context:
//                                                                       context,
//                                                                   builder: (
//                                                                     ctx,
//                                                                   ) =>
//                                                                       AlertDialog(
//                                                                     title: Text(
//                                                                       'Already Added',
//                                                                     ),
//                                                                     content:
//                                                                         Text(
//                                                                       'You’ve already added a row. Please remove it before adding another.',
//                                                                     ),
//                                                                     actions: [
//                                                                       TextButton(
//                                                                         onPressed:
//                                                                             () =>
//                                                                                 Navigator.pop(
//                                                                           ctx,
//                                                                         ),
//                                                                         child:
//                                                                             Text(
//                                                                           'OK',
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 );
//                                                               } else {
//                                                                 // No selection yet, add new
//                                                                 setState(() {
//                                                                   addedRowIds
//                                                                     ..clear()
//                                                                     ..add(
//                                                                         rowId);
//                                                                   selectedItems
//                                                                     ..clear()
//                                                                     ..add(data);
//                                                                 });
//                                                               }
//                                                             }
//                                                           },
//                                                           child: _TableCell(
//                                                             addedRowIds
//                                                                     .contains(
//                                                               "${data["productId"]}_${data["subCatId"]}_${data["vendorName"]}",
//                                                             )
//                                                                 ? "Remove"
//                                                                 : "Add",
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     );
//                                                   }),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   14.h,
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: CustomMmTextField(
//                                           isHeadingAvailable: true,
//                                           heading: 'Order Tax'.tr(),
//                                           labelText: '0',
//                                           hintText: '',
//                                           keyboardType: TextInputType.number,
//                                           controller: taxController,
//                                           autovalidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                           //  validator: ValidationUtils.taxOrder,
//                                         ),
//                                       ),
//                                       10.w,
//                                       Expanded(
//                                         child: CustomMmTextField(
//                                           isHeadingAvailable: true,
//                                           heading: 'Discount'.tr(),
//                                           labelText: '0',
//                                           hintText: '',
//                                           keyboardType: TextInputType.number,
//                                           controller: discountController,
//                                           autovalidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                           //   validator: ValidationUtils.inventoryName,
//                                         ),
//                                       ),
//                                       10.w,
//                                       Expanded(
//                                         child: CustomMmTextField(
//                                           isHeadingAvailable: true,
//                                           heading: 'Shipping'.tr(),
//                                           labelText: '0',
//                                           hintText: '',
//                                           keyboardType: TextInputType.number,
//                                           controller: shippingController,
//                                           autovalidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                           //   validator: ValidationUtils.shipping,
//                                         ),
//                                       ),
//                                       10.w,
//                                       Expanded(
//                                         child: Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 24.0),
//                                           child: CustomSearchableDropdown(
//                                             key: UniqueKey(),
//                                             hintText: 'Choose Status'.tr(),
//                                             value: selectStatus,
//                                             items: statusItems,
//                                             onChanged: (val) {
//                                               setState(() {
//                                                 selectStatus = val;
//                                               });
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   36.h,
//                                   AlertDialogBottomWidget(
//                                     title: widget.isEdit
//                                         ? 'Update Order'.tr()
//                                         : 'Purchase Order'.tr(),
//                                     onCreate: () {
//                                       if (createInventoryKey.currentState!
//                                           .validate()) {
//                                         submitPurchaseOrder();
//                                       }
//                                     },
//                                     onCancel: widget.onBack!.call,
//                                     loadingNotifier: loading,
//                                   ),
//                                   22.h,
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }
// }

// class _TableHeaderCell extends StatelessWidget {
//   final String title;

//   const _TableHeaderCell(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//       ),
//     );
//   }
// }

// class _TableCell extends StatelessWidget {
//   final String value;

//   const _TableCell(this.value);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Text(value, overflow: TextOverflow.ellipsis),
//     );
//   }
// }

// import 'package:app/app_theme.dart';
// import 'package:app/constants.dart';
// import 'package:app/loading_widget.dart';
// import 'package:app/modern_motors/models/product/product_sub_catorymodel.dart';
// import 'package:app/modern_motors/models/product_category_model.dart';
// import 'package:app/modern_motors/models/purchases/purchase_order_model.dart';
// import 'package:app/modern_motors/models/vendor/vendors_model.dart';
// import 'package:app/modern_motors/services/data_upload_service.dart';
// import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:app/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
// import 'package:app/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/page_header_widget.dart';
// import 'package:app/provider/connectivity_provider.dart';
// import 'package:app/provider/resource_provider.dart';
// import 'package:app/widgets/overlayloader.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProcurementAddEditPurchaseOrder extends StatefulWidget {
//   final VoidCallback? onBack;
//   final PurchaseOrderModel? purchaseOrderModel;
//   final bool isEdit;

//   const ProcurementAddEditPurchaseOrder({
//     super.key,
//     this.onBack,
//     this.purchaseOrderModel,
//     required this.isEdit,
//   });

//   @override
//   State<ProcurementAddEditPurchaseOrder> createState() =>
//       _ProcurementAddEditPurchaseOrderState();
// }

// class _ProcurementAddEditPurchaseOrderState
//     extends State<ProcurementAddEditPurchaseOrder> {
//   final TextEditingController referenceController = TextEditingController();
//   final TextEditingController discountController = TextEditingController();
//   final TextEditingController shippingController = TextEditingController();
//   final TextEditingController searchController = TextEditingController();

//   List<ProductCategoryModel> productsCategories = [];
//   List<ProductSubCatorymodel> subCategories = [];
//   List<VendorModel> vendors = [];
//   List<Map<String, dynamic>> approvedQuotations = [];
//   List<Map<String, dynamic>> filteredApprovedQuotations = [];
//   List<Map<String, dynamic>> selectedItems = [];

//   ValueNotifier<bool> loading = ValueNotifier(false);
//   ValueNotifier<bool> catLoader = ValueNotifier(false);
//   bool isLoading = false;

//   String? selectedVendorId;
//   String? selectedVendor;
//   String? selectStatus;
//   double totalCostPrice = 0.0;

//   final Map<String, String> statusItems = {
//     'pending': 'Pending',
//     'delivered': 'Delivered',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadApprovedQuotations();
//     searchController.addListener(_filterQuotations);
//   }

//   Future<void> _loadApprovedQuotations() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Fetch all approved quotations
//       final snapshot = await FirebaseFirestore.instance
//           .collectionGroup('quotations')
//           .where('status', isEqualTo: 'accepted')
//           .get();

//       List<Map<String, dynamic>> tempList = [];

//       for (final doc in snapshot.docs) {
//         final data = doc.data();
//         final quotationList = data['quotationList'] as List<dynamic>?;
//         final requisitionIds = data['requisitionIds'] as String?;
//         final productCategoryId = data['productCategoryId'] as String?;
//         final productSubcategoryId = data['productSubcategoryId'] as String?;

//         if (quotationList != null && requisitionIds != null) {
//           // Find approved vendor quotations
//           for (final item in quotationList) {
//             final status = item['status'];
//             if (status == 'approved') {
//               // Fetch product category name
//               String productName = '';
//               if (productCategoryId != null && productCategoryId.isNotEmpty) {
//                 final productSnap = await FirebaseFirestore.instance
//                     .collection('productsCategory')
//                     .doc(productCategoryId)
//                     .get();
//                 productName = productSnap.data()?['productName'] ?? 'Unknown';
//               }

//               // Fetch subcategory name
//               String subCatName = '';
//               if (productSubcategoryId != null &&
//                   productSubcategoryId.isNotEmpty) {
//                 final subCatSnap = await FirebaseFirestore.instance
//                     .collection('subCategory')
//                     .doc(productSubcategoryId)
//                     .get();
//                 subCatName = subCatSnap.data()?['name'] ?? 'Unknown';
//               }

//               // Fetch requisition serial number
//               String requisitionSerial = '';
//               try {
//                 final requisitionQuery = await FirebaseFirestore.instance
//                     .collectionGroup('purchaseRequisitions')
//                     .where(FieldPath.documentId, isEqualTo: requisitionIds)
//                     .limit(1)
//                     .get();

//                 if (requisitionQuery.docs.isNotEmpty) {
//                   final requisitionDoc = requisitionQuery.docs.first;
//                   requisitionSerial = requisitionDoc.data()?['serialNumber'] ??
//                       requisitionDoc.data()['requisitionNumber'] ??
//                       'REQ-${requisitionIds.substring(0, 8)}';
//                 } else {
//                   requisitionSerial = 'REQ-${requisitionIds.substring(0, 8)}';
//                 }
//               } catch (e) {
//                 debugPrint("Error fetching requisition details: $e");
//                 requisitionSerial = 'REQ-${requisitionIds.substring(0, 8)}';
//               }

//               tempList.add({
//                 "id": doc.id,
//                 "purchaseId": data['purchaseId'],
//                 "requisitionIds": requisitionIds,
//                 "requisitionSerial": requisitionSerial,
//                 "productId": productCategoryId,
//                 "productName": productName,
//                 "subCatId": productSubcategoryId,
//                 "subCatName": subCatName,
//                 "vendorId": item['vendorId'],
//                 "vendorName": item['vendorName'],
//                 "quantity": item['quantity'] ?? 0,
//                 "perItem": item['perItem'] ?? 0,
//                 "totalPrice": item['totalPrice'] ?? 0,
//                 "discount": item['discount'] ?? 0,
//                 "imageURL": item['imageURL'] ?? '',
//                 "createdAt": data['createdAt'],
//               });
//             }
//           }
//         }
//       }

//       setState(() {
//         approvedQuotations = tempList;
//         filteredApprovedQuotations = tempList;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error fetching approved quotations: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _filterQuotations() {
//     final query = searchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         filteredApprovedQuotations = approvedQuotations;
//       } else {
//         filteredApprovedQuotations = approvedQuotations.where((item) {
//           final productName =
//               (item['productName'] ?? '').toString().toLowerCase();
//           final vendorName =
//               (item['vendorName'] ?? '').toString().toLowerCase();
//           final subCatName =
//               (item['subCatName'] ?? '').toString().toLowerCase();
//           final requisitionSerial =
//               (item['requisitionSerial'] ?? '').toString().toLowerCase();

//           return productName.contains(query) ||
//               vendorName.contains(query) ||
//               subCatName.contains(query) ||
//               requisitionSerial.contains(query);
//         }).toList();
//       }
//     });
//   }

//   void submitPurchaseOrder() async {
//     if (loading.value) {
//       return;
//     }

//     if (selectedItems.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Please select a quotation first".tr())));
//       return;
//     }

//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (!mounted) {
//       return;
//     }

//     final profile = context.read<ResourceProvider>().getProfileByID(uid!);
//     if (profile.id.isEmpty) {
//       if (!mounted) return;
//       Constants.showMessage(
//         context,
//         'This Profile is not allowed this Task'.tr(),
//       );
//       loading.value = false;
//       return;
//     }

//     final branchId = profile.id;
//     final selectedData = selectedItems.first;
//     final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

//     final quantity = (selectedData["quantity"] ?? 0) as int;
//     final perItem = (selectedData["perItem"] ?? 0) as double;
//     final discount = double.tryParse(discountController.text.trim()) ?? 0;
//     final shipping = double.tryParse(shippingController.text.trim()) ?? 0;

//     final subTotal = quantity * perItem;
//     final discountAmount = subTotal * (discount / 100);
//     final amountAfterDiscount = subTotal - discountAmount;
//     final tax = 0.05; // 5% tax
//     final taxAmount = amountAfterDiscount * tax;
//     final totalCost = amountAfterDiscount + taxAmount + shipping;

//     final model = PurchaseOrderModel(
//       vendorId: selectedData["vendorId"],
//       vendorName: selectedData["vendorName"],
//       productId: selectedData["productId"],
//       productName: selectedData["productName"],
//       subCatId: selectedData["subCatId"],
//       subCatName: selectedData["subCatName"],
//       quantity: quantity,
//       perItem: perItem,
//       subTotal: subTotal,
//       totalCost: totalCost,
//       shipping: shipping,
//       discount: discount,
//       createdBy: userId,
//       referenceNo: referenceController.text.trim(),
//       branchId: branchId,
//       status: selectStatus ?? 'pending',
//       id: selectedData["id"],
//       requisitionId: selectedData["requisitionIds"],
//       //requisitionSerial: selectedData["requisitionSerial"],
//     );

//     loading.value = true;

//     try {
//       await DataUploadService.addPurchaseOrderFunction(model, branchId);
//       if (mounted) {
//         Constants.showMessage(
//             context, 'Purchase Order placed successfully'.tr());
//         widget.onBack?.call();
//         if (Navigator.of(context).canPop()) {
//           Navigator.of(context).pop();
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         Constants.showMessage(context, 'Something went wrong'.tr());
//         debugPrint('Error creating purchase order: $e');
//       }
//     } finally {
//       loading.value = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ConnectivityResult connectionStatus =
//         context.watch<ConnectivityProvider>().connectionStatus;

//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: PageHeaderWidget(
//             title: 'Create Purchase Order'.tr(),
//             buttonText: 'Back to Purchases'.tr(),
//             subTitle: 'Create purchase order from approved quotations'.tr(),
//             onCreateIcon: 'assets/icons/back.png',
//             selectedItems: [],
//             buttonWidth: 0.4,
//             onCreate: widget.onBack,
//             onDelete: () async {},
//           ),
//         ),
//         isLoading
//             ? SliverToBoxAdapter(child: LoadingWidget())
//             : SliverToBoxAdapter(
//                 child: OverlayLoader(
//                   loader: catLoader.value,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: AppTheme.whiteColor,
//                         borderRadius: BorderRadius.circular(8),
//                         border:
//                             Border.all(color: AppTheme.borderColor, width: 0.6),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 16, top: 10),
//                             child: Text(
//                               'Purchase Order Information'.tr(),
//                               style: AppTheme.getCurrentTheme(
//                                       false, connectionStatus)
//                                   .textTheme
//                                   .bodyMedium!
//                                   .copyWith(fontSize: 16),
//                             ),
//                           ),
//                           Divider(),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 10,
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         isHeadingAvailable: true,
//                                         heading: 'Search Quotations'.tr(),
//                                         labelText:
//                                             'Search by product, vendor, subcategory, or requisition number'
//                                                 .tr(),
//                                         hintText: 'Search...'.tr(),
//                                         controller: searchController,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         isHeadingAvailable: true,
//                                         heading: 'Reference No'.tr(),
//                                         hintText: 'Reference No'.tr(),
//                                         controller: referenceController,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 16.h,
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: Container(
//                                     margin: const EdgeInsets.all(12),
//                                     padding: const EdgeInsets.all(20),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(6),
//                                       color: Colors.grey.shade100,
//                                     ),
//                                     child: SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           if (selectedItems.isNotEmpty)
//                                             Container(
//                                               width: 350,
//                                               padding: const EdgeInsets.all(12),
//                                               margin: const EdgeInsets.only(
//                                                   bottom: 10),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.green.shade50,
//                                                 border: Border.all(
//                                                     color:
//                                                         Colors.green.shade300),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     'Selected Quotation:',
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color:
//                                                           Colors.green.shade800,
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 6),
//                                                   Text(
//                                                       "Requisition: ${selectedItems.first["requisitionSerial"] ?? ''}"),
//                                                   Text(
//                                                       "Product: ${selectedItems.first["productName"] ?? ''}"),
//                                                   Text(
//                                                       "Sub Category: ${selectedItems.first["subCatName"] ?? ''}"),
//                                                   Text(
//                                                       "Vendor: ${selectedItems.first["vendorName"] ?? ''}"),
//                                                   Text(
//                                                       "Quantity: ${selectedItems.first["quantity"] ?? ''}"),
//                                                   Text(
//                                                       "Price per Item: OMR ${(selectedItems.first["perItem"] ?? 0).toStringAsFixed(3)}"),
//                                                   Text(
//                                                       "Total: OMR ${(selectedItems.first["totalPrice"] ?? 0).toStringAsFixed(3)}"),
//                                                 ],
//                                               ),
//                                             ),
//                                           SizedBox(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             child: Table(
//                                               columnWidths: const {
//                                                 0: FlexColumnWidth(2), // Action
//                                                 1: FlexColumnWidth(2), // Req No
//                                                 2: FlexColumnWidth(
//                                                     2), // Product
//                                                 3: FlexColumnWidth(
//                                                     2), // Sub Cat
//                                                 4: FlexColumnWidth(1), // Qty
//                                                 5: FlexColumnWidth(2), // Vendor
//                                                 6: FlexColumnWidth(
//                                                     2), // Unit Price
//                                                 7: FlexColumnWidth(2), // Total
//                                               },
//                                               border: TableBorder.all(
//                                                   color: Colors.grey.shade300),
//                                               children: [
//                                                 TableRow(
//                                                   decoration: BoxDecoration(
//                                                       color:
//                                                           Colors.grey.shade200),
//                                                   children: [
//                                                     _TableHeaderCell(
//                                                         "Action".tr()),
//                                                     _TableHeaderCell(
//                                                         "Req No".tr()),
//                                                     _TableHeaderCell(
//                                                         "Product".tr()),
//                                                     _TableHeaderCell(
//                                                         "Sub Cat".tr()),
//                                                     _TableHeaderCell(
//                                                         "Qty".tr()),
//                                                     _TableHeaderCell(
//                                                         "Vendor".tr()),
//                                                     _TableHeaderCell(
//                                                         "Unit Price (OMR)"
//                                                             .tr()),
//                                                     _TableHeaderCell(
//                                                         "Total (OMR)".tr()),
//                                                   ],
//                                                 ),
//                                                 ...filteredApprovedQuotations
//                                                     .map((data) {
//                                                   final isSelected =
//                                                       selectedItems.any((item) =>
//                                                           item["id"] ==
//                                                               data["id"] &&
//                                                           item["vendorId"] ==
//                                                               data["vendorId"]);

//                                                   return TableRow(
//                                                     decoration: BoxDecoration(
//                                                       color: isSelected
//                                                           ? Colors.blue.shade50
//                                                           : Colors.transparent,
//                                                     ),
//                                                     children: [
//                                                       GestureDetector(
//                                                         onTap: () {
//                                                           setState(() {
//                                                             if (isSelected) {
//                                                               selectedItems.removeWhere((item) =>
//                                                                   item["id"] ==
//                                                                       data[
//                                                                           "id"] &&
//                                                                   item["vendorId"] ==
//                                                                       data[
//                                                                           "vendorId"]);
//                                                             } else {
//                                                               // Only allow one selection
//                                                               selectedItems
//                                                                   .clear();
//                                                               selectedItems
//                                                                   .add(data);
//                                                             }
//                                                           });
//                                                         },
//                                                         child: Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(12),
//                                                           child: Icon(
//                                                             isSelected
//                                                                 ? Icons
//                                                                     .remove_circle
//                                                                 : Icons
//                                                                     .add_circle,
//                                                             color: isSelected
//                                                                 ? Colors.red
//                                                                 : Colors.blue,
//                                                             size: 20,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       _TableCell(data[
//                                                               "requisitionSerial"] ??
//                                                           ""),
//                                                       _TableCell(
//                                                           data["productName"] ??
//                                                               ""),
//                                                       _TableCell(
//                                                           data["subCatName"] ??
//                                                               ""),
//                                                       _TableCell(
//                                                           (data["quantity"] ??
//                                                                   0)
//                                                               .toString()),
//                                                       _TableCell(
//                                                           data["vendorName"] ??
//                                                               ""),
//                                                       _TableCell(
//                                                           (data["perItem"] ?? 0)
//                                                               .toStringAsFixed(
//                                                                   3)),
//                                                       _TableCell(
//                                                           (data["totalPrice"] ??
//                                                                   0)
//                                                               .toStringAsFixed(
//                                                                   3)),
//                                                     ],
//                                                   );
//                                                 }),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 14.h,
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         isHeadingAvailable: true,
//                                         heading: 'Discount (%)'.tr(),
//                                         labelText: '0',
//                                         hintText: '',
//                                         keyboardType: TextInputType.number,
//                                         controller: discountController,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         isHeadingAvailable: true,
//                                         heading: 'Shipping (OMR)'.tr(),
//                                         labelText: '0',
//                                         hintText: '',
//                                         keyboardType: TextInputType.number,
//                                         controller: shippingController,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 24.0),
//                                         child: CustomSearchableDropdown(
//                                           hintText: 'Choose Status'.tr(),
//                                           value: selectStatus,
//                                           items: statusItems,
//                                           onChanged: (val) {
//                                             setState(() {
//                                               selectStatus = val;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 36.h,
//                                 AlertDialogBottomWidget(
//                                   title: 'Create Purchase Order'.tr(),
//                                   onCreate: submitPurchaseOrder,
//                                   onCancel: widget.onBack,
//                                   loadingNotifier: loading,
//                                 ),
//                                 22.h,
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }
// }

// class _TableHeaderCell extends StatelessWidget {
//   final String title;

//   const _TableHeaderCell(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//       ),
//     );
//   }
// }

// class _TableCell extends StatelessWidget {
//   final String value;
//   final Color? color;

//   const _TableCell(this.value, {this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Text(
//         value,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(color: color),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_order_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/loading_widget.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

class ProcurementAddEditPurchaseOrder extends StatefulWidget {
  final VoidCallback? onBack;
  final PurchaseOrderModel? purchaseOrderModel;
  final bool isEdit;

  const ProcurementAddEditPurchaseOrder({
    super.key,
    this.onBack,
    this.purchaseOrderModel,
    required this.isEdit,
  });

  @override
  State<ProcurementAddEditPurchaseOrder> createState() =>
      _ProcurementAddEditPurchaseOrderState();
}

class _ProcurementAddEditPurchaseOrderState
    extends State<ProcurementAddEditPurchaseOrder> {
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> approvedQuotations = [];
  List<Map<String, dynamic>> filteredApprovedQuotations = [];
  List<Map<String, dynamic>> selectedItems = [];

  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool isLoading = false;

  String? selectStatus;
  double totalCostPrice = 0.0;

  final Map<String, String> statusItems = {
    'pending': 'Pending',
    'delivered': 'Delivered',
  };

  @override
  void initState() {
    super.initState();
    _loadApprovedQuotations();
    searchController.addListener(_filterQuotations);
  }

  Future<void> _loadApprovedQuotations() async {
    setState(() {
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collectionGroup('quotations')
          .where('status', isEqualTo: 'accepted')
          .get();

      List<Map<String, dynamic>> tempList = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final quotationList = data['quotationList'] as List<dynamic>?;
        final requisitionIds = data['requisitionIds'] as String?;
        final productId = data['productId'] as String;
        final productCategoryId = data['productCategoryId'] as String?;
        final productSubcategoryId = data['productSubcategoryId'] as String?;
        final purchaseId = data['purchaseId'] as String?;

        if (quotationList != null && requisitionIds != null) {
          for (final item in quotationList) {
            final status = item['status'];
            if (status == 'approved') {
              String productName = '';
              String pName = '';
              if (productCategoryId != null && productCategoryId.isNotEmpty) {
                final productSnap = await FirebaseFirestore.instance
                    .collection('productsCategory')
                    .doc(productCategoryId)
                    .get();
                productName = productSnap.data()?['productName'] ?? 'Unknown';
              }
              if (productId.isNotEmpty) {
                final productSnap = await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId)
                    .get();
                pName = productSnap.data()?['productName'] ?? 'Unknown';
              }
              String subCatName = '';
              if (productSubcategoryId != null &&
                  productSubcategoryId.isNotEmpty) {
                final subCatSnap = await FirebaseFirestore.instance
                    .collection('subCategory')
                    .doc(productSubcategoryId)
                    .get();
                subCatName = subCatSnap.data()?['name'] ?? 'Unknown';
              }

              String requisitionSerial = '';
              int requisitionQuantity = 0;

              try {
                final requisitionQuery = await FirebaseFirestore.instance
                    .collection('purchase')
                    .doc(purchaseId)
                    .collection('purchaseRequisitions')
                    .doc(requisitionIds)
                    .get();

                if (requisitionQuery.exists) {
                  final requisitionDoc = requisitionQuery; //.docs.first;
                  requisitionSerial = requisitionDoc.data()!['serialNumber'];
                  // requisitionDoc.data()['serialNumber'] ??
                  //     'REQ-$requisitionSerial';
                  // Get quantity from purchase requisition, not quotation
                  requisitionQuantity =
                      (requisitionDoc.data()!['quantity'] ?? 0).toInt();
                } else {
                  requisitionQuantity = (item['quantity'] ?? 0)
                      .toInt(); // Fallback to quotation quantity
                }
              } catch (e) {
                if (mounted) {
                  Constants.showMessage(context, e.toString());
                }
              }

              final perItem = (item['perItem'] ?? 0).toDouble();
              final discount = (item['discount'] ?? 0).toDouble();
              final totalPrice =
                  (requisitionQuantity * perItem) * (1 - discount / 100);

              tempList.add({
                "id": doc.id,
                'productId': productId,
                "pName": pName,
                "purchaseId": data['purchaseId'],
                "requisitionIds": requisitionIds,
                "requisitionSerial": requisitionSerial,
                "productCategoryId": productCategoryId,
                "productName": productName,
                "subCatId": productSubcategoryId,
                "subCatName": subCatName,
                "vendorId": item['vendorId'],
                "vendorName": item['vendorName'],
                "quantity":
                    requisitionQuantity, // Use quantity from purchase requisition
                "originalQuantity":
                    requisitionQuantity, // Store original for reference
                "perItem": perItem,
                "discount": discount,
                "totalPrice": totalPrice,
                "imageURL": item['imageURL'] ?? '',
                "createdAt": data['createdAt'],

                ///'serial': requisitionSerial
              });
            }
          }
        }
      }

      setState(() {
        approvedQuotations = tempList;
        filteredApprovedQuotations = tempList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching approved quotations: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterQuotations() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredApprovedQuotations = approvedQuotations;
      } else {
        filteredApprovedQuotations = approvedQuotations.where((item) {
          final productName = (item['productName'] ?? '')
              .toString()
              .toLowerCase();
          final vendorName = (item['vendorName'] ?? '')
              .toString()
              .toLowerCase();
          final subCatName = (item['subCatName'] ?? '')
              .toString()
              .toLowerCase();
          final requisitionSerial = (item['requisitionSerial'] ?? '')
              .toString()
              .toLowerCase();

          return productName.contains(query) ||
              vendorName.contains(query) ||
              subCatName.contains(query) ||
              requisitionSerial.contains(query);
        }).toList();
      }
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        filteredApprovedQuotations[index]['quantity'] = newQuantity;
        // Recalculate total price
        final perItem = filteredApprovedQuotations[index]['perItem'];
        final discount = filteredApprovedQuotations[index]['discount'];
        filteredApprovedQuotations[index]['totalPrice'] =
            (newQuantity * perItem) * (1 - discount / 100);

        // Update selected item if it's the same one
        if (selectedItems.isNotEmpty &&
            selectedItems.first['id'] ==
                filteredApprovedQuotations[index]['id'] &&
            selectedItems.first['vendorId'] ==
                filteredApprovedQuotations[index]['vendorId']) {
          selectedItems[0] = {...filteredApprovedQuotations[index]};
        }
      }
    });
  }

  void _updateDiscount(int index, double newDiscount) {
    setState(() {
      if (newDiscount >= 0 && newDiscount <= 100) {
        filteredApprovedQuotations[index]['discount'] = newDiscount;
        // Recalculate total price
        final quantity = filteredApprovedQuotations[index]['quantity'];
        final perItem = filteredApprovedQuotations[index]['perItem'];
        filteredApprovedQuotations[index]['totalPrice'] =
            (quantity * perItem) * (1 - newDiscount / 100);

        // Update selected item if it's the same one
        if (selectedItems.isNotEmpty &&
            selectedItems.first['id'] ==
                filteredApprovedQuotations[index]['id'] &&
            selectedItems.first['vendorId'] ==
                filteredApprovedQuotations[index]['vendorId']) {
          selectedItems[0] = {...filteredApprovedQuotations[index]};
        }
      }
    });
  }

  double _calculateTotalBill() {
    if (selectedItems.isEmpty) return 0.0;

    final selectedData = selectedItems.first;
    final quantity = selectedData['quantity'];
    final perItem = selectedData['perItem'];
    final discount = selectedData['discount'];

    final subTotal = quantity * perItem;
    final discountAmount = subTotal * (discount / 100);
    final amountAfterDiscount = subTotal - discountAmount;
    final tax = 0.05; // 5% tax
    final taxAmount = amountAfterDiscount * tax;

    return amountAfterDiscount + taxAmount;
  }

  void submitPurchaseOrder() async {
    if (loading.value) return;

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a quotation first".tr())),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (!mounted || user == null) return;
    final selectedData = selectedItems.first;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final quantity = selectedData['quantity'];
    final perItem = selectedData['perItem'];
    final discount = selectedData['discount'];

    final subTotal = quantity * perItem;
    final discountAmount = subTotal * (discount / 100);
    final amountAfterDiscount = subTotal - discountAmount;
    final tax = 0.05;
    final taxAmount = amountAfterDiscount * tax;
    final totalCost = amountAfterDiscount + taxAmount;
    String po = await Constants.getUniqueNumber("PO");
    final model = PurchaseOrderModel(
      vendorId: selectedData["vendorId"],
      vendorName: selectedData["vendorName"],
      productId: selectedData["productId"],
      productName: selectedData["productName"],
      subCatId: selectedData["subCatId"],
      subCatName: selectedData["subCatName"],
      productCategoryId: selectedData['productCategoryId'],
      quantity: quantity,
      perItem: perItem,
      discount: discount,
      subTotal: subTotal,
      totalCost: totalCost,
      createdBy: userId,
      orderTax: taxAmount,
      referenceNo: referenceController.text.trim(),
      status: selectStatus ?? 'pending',
      id: selectedData["id"],
      requisitionId: selectedData["requisitionIds"],
      quotationId: selectedData['id'],
      purchaseId: selectedData['purchaseId'],
      requisitionNumber: selectedData['requisitionSerial'],
      poNumber: po,
      //requisitionSerial: selectedData["requisitionSerial"],
    );

    loading.value = true;

    try {
      await DataUploadService.addPurchaseOrderFunction(model);
      if (mounted) {
        Constants.showMessage(
          context,
          'Purchase Order placed successfully'.tr(),
        );
        widget.onBack?.call();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong'.tr());
        debugPrint('Error creating purchase order: $e');
      }
    } finally {
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;

    final totalBill = _calculateTotalBill();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeaderWidget(
            title: 'Create Purchase Order'.tr(),
            buttonText: 'Back to Purchases'.tr(),
            subTitle: 'Create purchase order from approved quotations'.tr(),
            onCreateIcon: 'assets/images/back.png',
            selectedItems: [],
            buttonWidth: 0.4,
            onCreate: widget.onBack,
            onDelete: () async {},
          ),
        ),
        isLoading
            ? SliverToBoxAdapter(child: MmloadingWidget())
            : SliverToBoxAdapter(
                child: OverlayLoader(
                  loader: catLoader.value,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.borderColor,
                          width: 0.6,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 10),
                            child: Text(
                              'Purchase Order Information'.tr(),
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
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomMmTextField(
                                        isHeadingAvailable: true,
                                        heading: 'Search Quotations'.tr(),
                                        labelText:
                                            'Search by product, vendor, subcategory, or requisition number'
                                                .tr(),
                                        hintText: 'Search...'.tr(),
                                        controller: searchController,
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomMmTextField(
                                        isHeadingAvailable: true,
                                        heading: 'Reference No'.tr(),
                                        hintText: 'Reference No'.tr(),
                                        controller: referenceController,
                                      ),
                                    ),
                                  ],
                                ),
                                16.h,
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    margin: const EdgeInsets.all(12),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (selectedItems.isNotEmpty)
                                            Container(
                                              width: 400,
                                              padding: const EdgeInsets.all(16),
                                              margin: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                border: Border.all(
                                                  color: Colors.green.shade300,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Selected Quotation Details:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          Colors.green.shade800,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  _buildDetailRow(
                                                    'Requisition',
                                                    "${"REQ"}-${selectedItems.first["requisitionSerial"]}",
                                                  ),
                                                  _buildDetailRow(
                                                    'Product',
                                                    selectedItems
                                                            .first["pName"] ??
                                                        '',
                                                  ),
                                                  _buildDetailRow(
                                                    'Product Category',
                                                    selectedItems
                                                            .first["productName"] ??
                                                        '',
                                                  ),
                                                  _buildDetailRow(
                                                    'Sub Category',
                                                    selectedItems
                                                            .first["subCatName"] ??
                                                        '',
                                                  ),
                                                  _buildDetailRow(
                                                    'Vendor',
                                                    selectedItems
                                                            .first["vendorName"] ??
                                                        '',
                                                  ),
                                                  _buildDetailRow(
                                                    'Unit Price',
                                                    'OMR ${(selectedItems.first["perItem"] ?? 0).toStringAsFixed(3)}',
                                                  ),
                                                  _buildDetailRow(
                                                    'Discount',
                                                    '${(selectedItems.first["discount"] ?? 0).toStringAsFixed(1)}%',
                                                  ),
                                                  _buildDetailRow(
                                                    'Quantity',
                                                    '${selectedItems.first["quantity"] ?? 0}',
                                                  ),
                                                  _buildDetailRow(
                                                    'Total',
                                                    'OMR ${(selectedItems.first["totalPrice"] ?? 0).toStringAsFixed(3)}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          SizedBox(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            child: Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(
                                                  0.7,
                                                ), // Action
                                                1: FlexColumnWidth(1), // Req No
                                                2: FlexColumnWidth(2),
                                                3: FlexColumnWidth(
                                                  2,
                                                ), // Product
                                                4: FlexColumnWidth(
                                                  2,
                                                ), // Sub Cat
                                                5: FlexColumnWidth(2), // Vendor
                                                6: FlexColumnWidth(1), // Qty
                                                7: FlexColumnWidth(
                                                  2,
                                                ), // Unit Price
                                                8: FlexColumnWidth(
                                                  2,
                                                ), // Discount
                                                9: FlexColumnWidth(2), // Total
                                              },
                                              border: TableBorder.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              children: [
                                                TableRow(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  children: [
                                                    //1
                                                    _TableHeaderCell(
                                                      "Action".tr(),
                                                    ),
                                                    //2
                                                    _TableHeaderCell(
                                                      "Req No".tr(),
                                                    ),
                                                    //3
                                                    _TableHeaderCell(
                                                      "Product".tr(),
                                                    ),
                                                    //4
                                                    _TableHeaderCell(
                                                      "Product Category".tr(),
                                                    ),
                                                    //5
                                                    _TableHeaderCell(
                                                      "Sub Cat".tr(),
                                                    ),
                                                    //6
                                                    _TableHeaderCell(
                                                      "Vendor".tr(),
                                                    ),
                                                    //7
                                                    _TableHeaderCell(
                                                      "Qty".tr(),
                                                    ),
                                                    //8
                                                    _TableHeaderCell(
                                                      "Unit Price".tr(),
                                                    ),
                                                    //9
                                                    _TableHeaderCell(
                                                      "Discount %".tr(),
                                                    ),
                                                    //10
                                                    _TableHeaderCell(
                                                      "Total".tr(),
                                                    ),
                                                  ],
                                                ),
                                                ...filteredApprovedQuotations.asMap().entries.map((
                                                  entry,
                                                ) {
                                                  final index = entry.key;
                                                  final data = entry.value;
                                                  final isSelected =
                                                      selectedItems.any(
                                                        (item) =>
                                                            item["id"] ==
                                                                data["id"] &&
                                                            item["vendorId"] ==
                                                                data["vendorId"],
                                                      );

                                                  return TableRow(
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? Colors.blue.shade50
                                                          : Colors.transparent,
                                                    ),
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (isSelected) {
                                                              selectedItems
                                                                  .clear();
                                                            } else {
                                                              selectedItems
                                                                  .clear();
                                                              selectedItems.add(
                                                                {...data},
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                12,
                                                              ),
                                                          child: Icon(
                                                            isSelected
                                                                ? Icons
                                                                      .check_circle
                                                                : Icons
                                                                      .radio_button_unchecked,
                                                            color: isSelected
                                                                ? Colors.green
                                                                : Colors.grey,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      _TableCell(
                                                        "REQ-${data["requisitionSerial"] ?? ""}",
                                                      ),
                                                      _TableCell(
                                                        data["pName"] ?? "",
                                                      ),
                                                      _TableCell(
                                                        data["productName"] ??
                                                            "",
                                                      ),
                                                      _TableCell(
                                                        data["subCatName"] ??
                                                            "",
                                                      ),
                                                      _TableCell(
                                                        data["vendorName"] ??
                                                            "",
                                                      ),
                                                      _EditableTableCell(
                                                        value: data["quantity"]
                                                            .toString(),
                                                        onChanged: (newValue) {
                                                          final newQuantity =
                                                              int.tryParse(
                                                                newValue,
                                                              ) ??
                                                              data["quantity"];
                                                          _updateQuantity(
                                                            index,
                                                            newQuantity,
                                                          );
                                                        },
                                                      ),
                                                      _TableCell(
                                                        "OMR ${(data["perItem"] ?? 0).toStringAsFixed(3)}",
                                                      ),
                                                      _EditableTableCell(
                                                        value: data["discount"]
                                                            .toString(),
                                                        onChanged: (newValue) {
                                                          final newDiscount =
                                                              double.tryParse(
                                                                newValue,
                                                              ) ??
                                                              data["discount"];
                                                          _updateDiscount(
                                                            index,
                                                            newDiscount,
                                                          );
                                                        },
                                                        isPercentage: true,
                                                      ),
                                                      _TableCell(
                                                        "OMR ${(data["totalPrice"] ?? 0).toStringAsFixed(3)}",
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                24.h,
                                // Bill Summary
                                if (selectedItems.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bill Summary:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildBillDetailRow(
                                                    'Sub Total:',
                                                    'OMR ${(selectedItems.first["quantity"] * selectedItems.first["perItem"]).toStringAsFixed(3)}',
                                                  ),
                                                  _buildBillDetailRow(
                                                    'Discount (${selectedItems.first["discount"]}%):',
                                                    '- OMR ${((selectedItems.first["quantity"] * selectedItems.first["perItem"]) * (selectedItems.first["discount"] / 100)).toStringAsFixed(3)}',
                                                  ),
                                                  _buildBillDetailRow(
                                                    'Tax (5%):',
                                                    'OMR ${((selectedItems.first["quantity"] * selectedItems.first["perItem"]) * (1 - selectedItems.first["discount"] / 100) * 0.05).toStringAsFixed(3)}',
                                                  ),
                                                  const Divider(),
                                                  _buildBillDetailRow(
                                                    'Total Amount:',
                                                    'OMR ${totalBill.toStringAsFixed(3)}',
                                                    isBold: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                24.h,
                                AlertDialogBottomWidget(
                                  title: 'Create Purchase Order'.tr(),
                                  onCreate: submitPurchaseOrder,
                                  onCancel: widget.onBack,
                                  loadingNotifier: loading,
                                ),
                                22.h,
                              ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildBillDetailRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String title;

  const _TableHeaderCell(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String value;
  final Color? color;

  const _TableCell(this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color),
      ),
    );
  }
}

class _EditableTableCell extends StatefulWidget {
  final String value;
  final Function(String) onChanged;
  final bool isPercentage;

  const _EditableTableCell({
    required this.value,
    required this.onChanged,
    this.isPercentage = false,
  });

  @override
  State<_EditableTableCell> createState() => _EditableTableCellState();
}

class _EditableTableCellState extends State<_EditableTableCell> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          suffixText: widget.isPercentage ? '%' : null,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
