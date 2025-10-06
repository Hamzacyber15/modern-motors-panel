// // ignore_for_file: deprecated_member_use

// import 'dart:io';

// import 'package:app/app_theme.dart';
// import 'package:app/constants.dart';
// import 'package:app/models/attachment_model.dart';
// import 'package:app/modern_motors/models/purchases/purchase_requisition_model.dart';
// import 'package:app/modern_motors/models/purchases/qoutation_procurement_model.dart';
// import 'package:app/modern_motors/models/vendor/vendors_model.dart';
// import 'package:app/modern_motors/services/data_fetch_service.dart';
// import 'package:app/modern_motors/widgets/buttons/custom_button.dart';
// import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:app/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
// import 'package:app/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/form_validation.dart';
// import 'package:app/modern_motors/widgets/page_header_widget.dart';
// import 'package:app/provider/connectivity_provider.dart';
// import 'package:app/provider/resource_provider.dart';
// import 'package:app/widgets/overlayloader.dart';
// import 'package:app/widgets/picker/picker_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class AddEditProcurementQuotation extends StatefulWidget {
//   final QuotationProcurementModel? quotaionModel;
//   final VoidCallback? onBack;
//   final bool isEdit;

//   const AddEditProcurementQuotation({
//     super.key,
//     this.onBack,
//     this.quotaionModel,
//     required this.isEdit,
//   });

//   @override
//   State<AddEditProcurementQuotation> createState() =>
//       _AddEditProcurementQuotationState();
// }

// class _AddEditProcurementQuotationState
//     extends State<AddEditProcurementQuotation> {
//   List<AttachmentModel> attachments = [];
//   List<PurchaseRequisitionModel> allRequesitions = [];
//   List<PurchaseRequisitionModel> displayedRequesitions = [];
//   List<Map<String, dynamic>> quotationsList = [];
//   ValueNotifier<bool> loading = ValueNotifier(false);
//   GlobalKey<FormState> addQuotationKey = GlobalKey<FormState>();
//   final TextEditingController pricePerItemController = TextEditingController();
//   final TextEditingController totalPriceController = TextEditingController();
//   TextEditingController discountController = TextEditingController(text: '0');
//   String? selectedVendorId;
//   String? selectQuantity;
//   String? selectedVendor;
//   List<VendorModel> vendors = [];
//   List<Map<String, dynamic>> requisitions = [];
//   bool isLoading = true;
//   int? selectedRequisitionIndex;
//   Map<String, String> productNames = {};
//   Map<String, String> subCatNames = {};
//   Map<String, String> branchName = {};

//   @override
//   void initState() {
//     super.initState();
//     dataInits();
//   }

//   void dataInits() async {
//     await fetchVendors();
//     await _loadRequesitions();
//     await _loadProductAndSubCatNames();

//     if (widget.isEdit && widget.quotaionModel != null) {
//       _loadExistingQuotationData(widget.quotaionModel!);
//     }
//   }

//   void _calculateTotalPrice() {
//     double price = double.tryParse(pricePerItemController.text) ?? 0;
//     int quantity =
//         selectQuantity != 'Any' ? int.tryParse(selectQuantity!) ?? 0 : 0;
//     double discount = double.tryParse(discountController.text) ?? 0;

//     double total = price * quantity;
//     if (discount > 0) {
//       total = total - (total * discount / 100);
//     }

//     totalPriceController.text = total.toStringAsFixed(2);
//     setState(() {}); // Update the UI
//   }

//   void _loadExistingQuotationData(QuotationProcurementModel model) {
//     final selectedReqId = model.requisitionIds;

//     final index =
//         allRequesitions.indexWhere((r) => r.requisitionId == selectedReqId);

//     if (index != -1) {
//       selectedRequisitionIndex = index;
//     }
//     debugPrint('selectedRequisitionIndex: $selectedRequisitionIndex');

//     quotationsList = model.quotationList.map((quotation) {
//       return {
//         'images': quotation.imageURL,
//         'vendorId': quotation.vendorId,
//         'vendorName': quotation.vendorName,
//         'quantity': quotation.quantity.toString(),
//         'perItem': quotation.perItem.toString(),
//         'totalPrice': quotation.totalPrice.toString(),
//       };
//     }).toList();
//     debugPrint('quotationsList: $quotationsList');
//     setState(() {});
//   }

//   Future<void> _loadProductAndSubCatNames() async {
//     final productSnapshot =
//         await FirebaseFirestore.instance.collection('productsCategory').get();
//     final subCatSnapshot =
//         await FirebaseFirestore.instance.collection('subCategory').get();
//     final branchNameSnashot =
//         await FirebaseFirestore.instance.collection('branches').get();

//     setState(() {
//       productNames = {
//         for (var doc in productSnapshot.docs)
//           doc.id: doc.data()['productName'] ?? 'Unnamed Product',
//       };
//       subCatNames = {
//         for (var doc in subCatSnapshot.docs)
//           doc.id: doc.data()['name'] ?? 'Unnamed Subcategory',
//       };
//       branchName = {
//         for (var doc in branchNameSnashot.docs)
//           doc.id: doc.data()['branchName'] ?? 'Unnamed Subcategory',
//       };
//     });
//   }

//   Future<void> fetchVendors() async {
//     final result = await DataFetchService.fetchVendor();
//     setState(() {
//       vendors = result;
//     });
//   }

//   Future<void> _loadRequesitions() async {
//     setState(() => isLoading = true);
//     try {
//       final results = await DataFetchService.fetchPurchseRequistionOnApproval();
//       setState(() {
//         allRequesitions = results;
//         displayedRequesitions = List.from(allRequesitions);
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint('Error fetching requisition data: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   void _addImageVendorPair() {
//     if (selectedVendor == null ||
//         attachments.isEmpty ||
//         selectQuantity == null ||
//         pricePerItemController.text.isEmpty ||
//         totalPriceController.text.isEmpty) {
//       Constants.showMessage(
//         context,
//         'Please select a vendor, quantity, upload image and enter prices.'.tr(),
//       );
//       return;
//     }

//     quotationsList.add({
//       'images': List<AttachmentModel>.from(attachments),
//       'vendorId': selectedVendorId,
//       'vendorName': selectedVendor,
//       'quantity': selectQuantity,
//       'perItem': pricePerItemController.text,
//       'totalPrice': totalPriceController.text,
//     });

//     setState(() {
//       attachments = [];
//       selectedVendor = null;
//       selectedVendorId = null;
//       selectQuantity = null;
//       pricePerItemController.clear();
//       totalPriceController.clear();
//     });
//   }

//   void _submitVendor() async {
//     if (quotationsList.isEmpty) {
//       Constants.showMessage(context, 'Please Press add button.'.tr());
//       return;
//     }
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     final profile = context.read<ResourceProvider>().getProfileByID(uid!);
//     if (loading.value) return;
//     loading.value = true;

//     try {
//       if (profile.id.isEmpty) {
//         if (!mounted) return;
//         Constants.showMessage(context, 'User profile not found'.tr());
//         loading.value = false;
//         return;
//       }

//       final quotationList = <Quotation>[];

//       for (var item in quotationsList) {
//         final List<AttachmentModel> images = List<AttachmentModel>.from(
//           item['images'] ?? [],
//         );
//         for (var img in images) {
//           quotationList.add(
//             Quotation(
//               imageURL: img.url,
//               vendorId: item['vendorId'],
//               vendorName: item['vendorName'],
//               quantity: int.tryParse(item['quantity'].toString()) ?? 0,
//               perItem: int.tryParse(item['perItem'].toString()) ?? 0,
//               totalPrice: int.tryParse(item['totalPrice'].toString()) ?? 0,
//               status: 'pending',
//             ),
//           );
//         }
//       }

//       final selectedRequisitionId = selectedRequisitionIndex != null
//           ? displayedRequesitions[selectedRequisitionIndex!].requisitionId
//           : null;
//       final purchaseId = selectedRequisitionIndex != null
//           ? displayedRequesitions[selectedRequisitionIndex!].purchaseId
//           : null;
//       final newModel = QuotationProcurementModel(
//         purchaseId: purchaseId!,
//         id: "",
//         userId: profile.id,
//         quotationList: quotationList,
//         timestamp: Timestamp.now(),
//         requisitionIds: selectedRequisitionId!,
//       );

//       await FirebaseFirestore.instance
//           .collection('purchase')
//           .doc(purchaseId)
//           .collection('quotations')
//           .add(newModel.toMap());
//       if (!mounted) return;
//       Constants.showMessage(context, 'Quotations added successfully'.tr());
//       widget.onBack?.call();
//       if (mounted) Navigator.of(context).pop();
//     } catch (e, stackTrace) {
//       if (!mounted) return;
//       Constants.showMessage(context, 'Something went wrong'.tr());
//       debugPrint('Error saving quotation: $e');
//       debugPrint('Stack trace: $stackTrace');
//     } finally {
//       loading.value = false;
//     }
//   }

//   final Map<String, String> quantityItems = {
//     'any': 'Any',
//     for (int i = 1; i <= 500; i += 1) '$i': '$i',
//   };

//   void onFilesPicked(List<AttachmentModel> files) {
//     setState(() {
//       attachments = files;
//     });
//   }

//   @override
//   void dispose() {
//     pricePerItemController.dispose();
//     totalPriceController.dispose();
//     super.dispose();
//   }

//   // Enterprise-Level Requisition Selection Dialog

//   void _showRequisitionDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.black54,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return Dialog(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               insetPadding: const EdgeInsets.all(16),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 constraints: const BoxConstraints(
//                   maxWidth: 700,
//                   maxHeight: 650,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppTheme.whiteColor,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 24,
//                       offset: const Offset(0, 8),
//                       spreadRadius: 0,
//                     ),
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 6,
//                       offset: const Offset(0, 2),
//                       spreadRadius: 0,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header Section
//                     _buildDialogHeader(context),

//                     // Search Section
//                     _buildSearchSection(setDialogState),

//                     // Content Section
//                     Flexible(
//                       child: _buildRequisitionsList(setDialogState),
//                     ),

//                     // Footer Section
//                     _buildDialogFooter(context, setDialogState),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

// // Dialog Header with Enterprise Design
//   Widget _buildDialogHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 24, 20, 16),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: AppTheme.borderColor.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Icon
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppTheme.primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               Icons.receipt_long_outlined,
//               color: AppTheme.primaryColor,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 16),

//           // Title and Subtitle
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Select Requisition'.tr(),
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.w600,
//                         color: AppTheme.blackColor,
//                         fontSize: 20,
//                       ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Choose a requisition to create quotation for'.tr(),
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: AppTheme.blackColor.withOpacity(0.6),
//                         fontSize: 14,
//                       ),
//                 ),
//               ],
//             ),
//           ),

//           // Close Button
//           IconButton(
//             onPressed: () => Navigator.of(context).pop(),
//             icon: Icon(
//               Icons.close_rounded,
//               color: AppTheme.grey.withOpacity(0.6),
//               size: 24,
//             ),
//             style: IconButton.styleFrom(
//               backgroundColor: AppTheme.borderColor.withOpacity(0.1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.all(8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// // Search Section
//   Widget _buildSearchSection(StateSetter setDialogState) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppTheme.borderColor.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: AppTheme.borderColor.withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: TextField(
//                 onChanged: (value) {
//                   setDialogState(() {
//                     // Implement search logic here
//                   });
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search requisitions...'.tr(),
//                   hintStyle: TextStyle(
//                     color: AppTheme.grey.withOpacity(0.5),
//                     fontSize: 14,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.search_rounded,
//                     color: AppTheme.grey.withOpacity(0.5),
//                     size: 20,
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Filter Button
//           Container(
//             decoration: BoxDecoration(
//               color: AppTheme.primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: AppTheme.primaryColor.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: IconButton(
//               onPressed: () {
//                 // Implement filter logic
//               },
//               icon: Icon(
//                 Icons.tune_rounded,
//                 color: AppTheme.primaryColor,
//                 size: 20,
//               ),
//               tooltip: 'Filter'.tr(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// // Requisitions List Section
//   Widget _buildRequisitionsList(StateSetter setDialogState) {
//     if (displayedRequesitions.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppTheme.borderColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Icon(
//                 Icons.inbox_outlined,
//                 size: 48,
//                 color: AppTheme.grey.withOpacity(0.4),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No Requisitions Available'.tr(),
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: AppTheme.grey.withOpacity(0.7),
//                     fontWeight: FontWeight.w500,
//                   ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'There are no requisitions to display at the moment'.tr(),
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppTheme.grey.withOpacity(0.5),
//                   ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       );
//     }

//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Results Header
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Row(
//               children: [
//                 Text(
//                   'Available Requisitions'.tr(),
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.w600,
//                         color: AppTheme.blackColor.withOpacity(0.8),
//                       ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: AppTheme.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${displayedRequesitions.length}',
//                     style: TextStyle(
//                       color: AppTheme.primaryColor,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // List
//           Expanded(
//             child: ListView.builder(
//               itemCount: displayedRequesitions.length,
//               itemBuilder: (context, index) {
//                 final req = displayedRequesitions[index];
//                 final isSelected = selectedRequisitionIndex == index;

//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: () {
//                         setDialogState(() {
//                           selectedRequisitionIndex = index;
//                         });
//                       },
//                       borderRadius: BorderRadius.circular(12),
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? AppTheme.primaryColor.withOpacity(0.08)
//                               : AppTheme.whiteColor,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? AppTheme.primaryColor.withOpacity(0.3)
//                                 : AppTheme.borderColor.withOpacity(0.2),
//                             width: isSelected ? 2 : 1,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             // Radio Button
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: isSelected
//                                       ? AppTheme.primaryColor
//                                       : AppTheme.borderColor,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: Container(
//                                 width: 12,
//                                 height: 12,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: isSelected
//                                       ? AppTheme.primaryColor
//                                       : Colors.transparent,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),

//                             // Content
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Product Name
//                                   Text(
//                                     productNames[req.productId] ?? 'Product',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium
//                                         ?.copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: AppTheme.blackColor,
//                                           fontSize: 16,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 6),

//                                   // Subcategory
//                                   Text(
//                                     subCatNames[req.subCatId] ?? 'SubCategory',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium
//                                         ?.copyWith(
//                                           color: AppTheme.blackColor
//                                               .withOpacity(0.7),
//                                           fontSize: 14,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 8),

//                                   // Tags Row
//                                   Row(
//                                     children: [
//                                       // Quantity Tag
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.primaryColor
//                                               .withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(6),
//                                         ),
//                                         child: Text(
//                                           'Qty: ${req.quantity}',
//                                           style: TextStyle(
//                                             color: AppTheme.primaryColor,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),

//                                       // Branch Tag
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.borderColor
//                                               .withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(6),
//                                         ),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(
//                                               Icons.location_on_outlined,
//                                               size: 12,
//                                               color: AppTheme.blackColor
//                                                   .withOpacity(0.6),
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               branchName[req.branchId] ??
//                                                   'Branch',
//                                               style: TextStyle(
//                                                 color: AppTheme.blackColor
//                                                     .withOpacity(0.7),
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // Selection Indicator
//                             if (isSelected)
//                               Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: AppTheme.primaryColor,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Icon(
//                                   Icons.check_rounded,
//                                   color: AppTheme.whiteColor,
//                                   size: 16,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// // Dialog Footer
//   Widget _buildDialogFooter(BuildContext context, StateSetter setDialogState) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: AppTheme.borderColor.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Selection Info
//           if (selectedRequisitionIndex != null)
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryColor.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: AppTheme.primaryColor.withOpacity(0.1),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline_rounded,
//                       color: AppTheme.primaryColor,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Selected: ${productNames[displayedRequesitions[selectedRequisitionIndex!].productId] ?? 'Product'}',
//                         style: TextStyle(
//                           color: AppTheme.primaryColor,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           else
//             const Spacer(),

//           const SizedBox(width: 16),

//           // Action Buttons
//           Row(
//             children: [
//               // Cancel Button
//               SizedBox(
//                 height: 48,
//                 child: OutlinedButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppTheme.borderColor),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                   ),
//                   child: Text(
//                     'Cancel'.tr(),
//                     style: TextStyle(
//                       color: AppTheme.blackColor.withOpacity(0.7),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),

//               // Select Button
//               SizedBox(
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: selectedRequisitionIndex != null
//                       ? () {
//                           setState(() {
//                             // Update the main widget state
//                           });
//                           Navigator.of(context).pop();
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     disabledBackgroundColor:
//                         AppTheme.borderColor.withOpacity(0.3),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 32),
//                     elevation: selectedRequisitionIndex != null ? 2 : 0,
//                   ),
//                   child: Text(
//                     'Select Requisition'.tr(),
//                     style: TextStyle(
//                       color: selectedRequisitionIndex != null
//                           ? AppTheme.whiteColor
//                           : AppTheme.blackColor.withOpacity(0.4),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

// // 3. Alternative: Bottom Sheet approach (might be better for mobile)
//   void _showRequisitionBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return DraggableScrollableSheet(
//               initialChildSize: 0.7,
//               maxChildSize: 0.9,
//               minChildSize: 0.5,
//               expand: false,
//               builder: (context, scrollController) {
//                 return Column(
//                   children: [
//                     // Handle bar
//                     Container(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                     // Title
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         'Select Requisition'.tr(),
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                     ),
//                     // List
//                     Expanded(
//                       child: ListView.builder(
//                         controller: scrollController,
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: displayedRequesitions.length,
//                         itemBuilder: (context, index) {
//                           final req = displayedRequesitions[index];
//                           final isSelected = selectedRequisitionIndex == index;

//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             child: ListTile(
//                               selected: isSelected,
//                               onTap: () {
//                                 setState(() {
//                                   selectedRequisitionIndex = index;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                               leading: Radio<int>(
//                                 value: index,
//                                 groupValue: selectedRequisitionIndex,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedRequisitionIndex = value;
//                                   });
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               title: Text(
//                                 productNames[req.productId] ?? 'Product',
//                                 style: TextStyle(
//                                   fontWeight: isSelected
//                                       ? FontWeight.bold
//                                       : FontWeight.normal,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 '${subCatNames[req.subCatId] ?? 'SubCategory'} • Qty: ${req.quantity}\n${branchName[req.branchId] ?? 'Branch'}',
//                               ),
//                               isThreeLine: true,
//                               trailing: isSelected
//                                   ? Icon(Icons.check_circle,
//                                       color: AppTheme.primaryColor)
//                                   : null,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     // Bottom padding
//                     const SizedBox(height: 16),
//                   ],
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ConnectivityResult connectionStatus =
//         context.watch<ConnectivityProvider>().connectionStatus;
//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: PageHeaderWidget(
//             title: 'Add Quotations'.tr(),
//             buttonText: 'Back to Quotation'.tr(),
//             subTitle: 'Create New Quotations'.tr(),
//             onCreateIcon: 'assets/icons/back.png',
//             selectedItems: [],
//             buttonWidth: 0.4,
//             onCreate: () {
//               if (widget.onBack != null) {
//                 widget.onBack!();
//               } else {
//                 Navigator.of(context).pop();
//               }
//             },
//             onDelete: () async {},
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: OverlayLoader(
//             loader: loading.value,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: AppTheme.whiteColor,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: AppTheme.borderColor, width: 0.6),
//                 ),
//                 child: Form(
//                   key: addQuotationKey,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Text(
//                         //   'Select Requisitions'.tr(),
//                         //   style: Theme.of(context).textTheme.titleMedium,
//                         // ),

//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: AppTheme.borderColor),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: selectedRequisitionIndex != null
//                               ? Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             productNames[displayedRequesitions[
//                                                         selectedRequisitionIndex!]
//                                                     .productId] ??
//                                                 'Product',
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleMedium,
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             '${subCatNames[displayedRequesitions[selectedRequisitionIndex!].subCatId] ?? 'SubCategory'} • Qty: ${displayedRequesitions[selectedRequisitionIndex!].quantity} • ${branchName[displayedRequesitions[selectedRequisitionIndex!].branchId] ?? 'Branch'}',
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyMedium,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: _showRequisitionDialog,
//                                       child: Text('Change'.tr()),
//                                     ),
//                                   ],
//                                 )
//                               : ListTile(
//                                   leading: Icon(Icons.add_circle_outline),
//                                   title: Text('Select Requisition'.tr()),
//                                   subtitle: Text(
//                                       'Choose a requisition to create quotation for'
//                                           .tr()),
//                                   onTap: _showRequisitionDialog,
//                                 ),
//                         ),
//                         const SizedBox(height: 20),
//                         // Quotation section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Quotation'.tr(),
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                             SizedBox(
//                               height: context.height * 0.064,
//                               width: context.height * 0.067,
//                               child: CustomButton(
//                                 onPressed: _addImageVendorPair,
//                                 iconAsset: 'assets/add_icon.png',
//                                 buttonType: ButtonType.IconOnly,
//                                 iconColor: AppTheme.whiteColor,
//                                 backgroundColor: AppTheme.primaryColor,
//                                 iconSize: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                         12.h,
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomSearchableDropdown(
//                                 hintText: 'Choose Vendor'.tr(),
//                                 value: selectedVendorId,
//                                 items: {
//                                   for (var v in vendors) v.id!: v.vendorName,
//                                 },
//                                 onChanged: (val) {
//                                   setState(() {
//                                     selectedVendorId = val;
//                                     selectedVendor = vendors
//                                         .firstWhere((v) => v.id == val)
//                                         .vendorName;
//                                   });
//                                 },
//                               ),
//                             ),
//                             10.w,
//                             Expanded(
//                               child: CustomSearchableDropdown(
//                                 hintText: 'Choose Quantity'.tr(),
//                                 value: selectQuantity,
//                                 items: quantityItems,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     selectQuantity = val == 'any' ? 'Any' : val;
//                                     _calculateTotalPrice(); // Recalculate total when quantity changes
//                                   });
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         6.h,
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomMmTextField(
//                                 labelText: 'Offered price per item'.tr(),
//                                 controller: pricePerItemController,
//                                 keyboardType: TextInputType.number,
//                                 inputFormatter: [
//                                   FilteringTextInputFormatter.allow(
//                                     RegExp(r'^\d*\.?\d{0,2}'),
//                                   ),
//                                 ],
//                                 validator: ValidationUtils.price,
//                                 hintText: '',
//                                 onChanged: (value) {
//                                   _calculateTotalPrice(); // Recalculate total when price changes
//                                 },
//                               ),
//                             ),
//                             10.w,
//                             Expanded(
//                               child: CustomMmTextField(
//                                 labelText: 'Discount (%)'.tr(),
//                                 controller: discountController,
//                                 keyboardType: TextInputType.number,
//                                 inputFormatter: [
//                                   FilteringTextInputFormatter.allow(
//                                     RegExp(r'^\d*\.?\d{0,2}'),
//                                   ),
//                                 ],
//                                 hintText: '0',
//                                 onChanged: (value) {
//                                   _calculateTotalPrice(); // Recalculate total when discount changes
//                                 },
//                               ),
//                             ),
//                             10.w,
//                             Expanded(
//                               child: CustomMmTextField(
//                                 hintText: '',
//                                 labelText: 'Total offered sale price'.tr(),
//                                 controller: totalPriceController,
//                                 keyboardType: TextInputType.number,
//                                 inputFormatter: [
//                                   FilteringTextInputFormatter.allow(
//                                     RegExp(r'^\d*\.?\d{0,2}'),
//                                   ),
//                                 ],
//                                 validator: ValidationUtils.price,
//                               ),
//                             ),
//                           ],
//                         ),
//                         10.h,
//                         Row(
//                           children: [
//                             PickerWidget(
//                               multipleAllowed: true,
//                               attachments: attachments,
//                               galleryAllowed: true,
//                               onFilesPicked: onFilesPicked,
//                               memoAllowed: false,
//                               filesAllowed: true,
//                               videoAllowed: false,
//                               cameraAllowed: true,
//                               child: Container(
//                                 height: context.height * 0.2,
//                                 width: context.width * 0.1,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: AppTheme.borderColor,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: attachments.isNotEmpty
//                                     ? kIsWeb
//                                         ? Image.memory(
//                                             attachments.last.bytes!,
//                                             fit: BoxFit.cover,
//                                           )
//                                         : Image.file(
//                                             File(attachments.last.url),
//                                             fit: BoxFit.cover,
//                                           )
//                                     : Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.add_circle_outline_rounded,
//                                           ),
//                                           Text('Add Image'.tr()),
//                                         ],
//                                       ),
//                               ),
//                             ),
//                             12.w,
//                             Column(
//                               children: [
//                                 SizedBox(
//                                   height: context.height * 0.06,
//                                   width: context.height * 0.22,
//                                   child: CustomButton(
//                                     text: 'Upload Image'.tr(),
//                                     onPressed: () {},
//                                     fontSize: 14,
//                                     buttonType: ButtonType.Filled,
//                                     backgroundColor: AppTheme.primaryColor,
//                                   ),
//                                 ),
//                                 8.h,
//                                 Text(
//                                   'JPEG, PNG up to 2 MB'.tr(),
//                                   style: AppTheme.getCurrentTheme(
//                                           false, connectionStatus)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         if (quotationsList.isNotEmpty)
//                           ...quotationsList.asMap().entries.map((entry) {
//                             final index = entry.key;
//                             final data = entry.value;
//                             // final imageAttachments = List<AttachmentModel>.from(
//                             //   data['images'] ?? [],
//                             // );
//                             // final image =
//                             //     imageAttachments.isNotEmpty
//                             //         ? imageAttachments.last
//                             //         : null;
//                             final vendorName = data['vendorName'] ?? '';

//                             return Column(
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     // if (image != null &&
//                                     //     image.attachmentType.isNotEmpty)
//                                     //   kIsWeb
//                                     //       ? Image.memory(
//                                     //         image.bytes!,
//                                     //         height: 28,
//                                     //         width: 28,
//                                     //         fit: BoxFit.cover,
//                                     //       )
//                                     //       : Image.file(
//                                     //         File(image.url),
//                                     //         height: 28,
//                                     //         width: 28,
//                                     //         fit: BoxFit.cover,
//                                     //       ),
//                                     12.w,
//                                     Expanded(
//                                       child: Text(
//                                         vendorName,
//                                         style: Theme.of(
//                                           context,
//                                         ).textTheme.titleMedium,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.delete_outline,
//                                         color: AppTheme.redColor,
//                                         size: 16,
//                                       ),
//                                       onPressed: () => setState(
//                                         () => quotationsList.removeAt(index),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(height: 20, thickness: 0.8),
//                               ],
//                             );
//                           }),

//                         10.h,
//                         AlertDialogBottomWidget(
//                           title: widget.isEdit
//                               ? 'Update Quotation'.tr()
//                               : 'Add Quotation'.tr(),
//                           onCreate: () {
//                             if (addQuotationKey.currentState!.validate()) {
//                               _submitVendor();
//                             }
//                           },
//                           onCancel:
//                               widget.onBack ?? () => Navigator.pop(context),
//                           loadingNotifier: loading,
//                         ),
//                         16.h,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_requisition_model.dart';
import 'package:modern_motors_panel/model/purchase_models/quotation_procurement_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/provider/resource_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class AddEditProcurementQuotation extends StatefulWidget {
  final QuotationProcurementModel? quotaionModel;
  final VoidCallback? onBack;
  final bool isEdit;

  const AddEditProcurementQuotation({
    super.key,
    this.onBack,
    this.quotaionModel,
    required this.isEdit,
  });

  @override
  State<AddEditProcurementQuotation> createState() =>
      _AddEditProcurementQuotationState();
}

class _AddEditProcurementQuotationState
    extends State<AddEditProcurementQuotation> {
  List<AttachmentModel> attachments = [];
  List<PurchaseRequisitionModel> allRequesitions = [];
  List<PurchaseRequisitionModel> displayedRequesitions = [];
  List<Map<String, dynamic>> quotationsList = [];
  ValueNotifier<bool> loading = ValueNotifier(false);
  GlobalKey<FormState> addQuotationKey = GlobalKey<FormState>();
  final TextEditingController pricePerItemController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  TextEditingController discountController = TextEditingController(text: '0');
  String? selectedVendorId;
  String? selectQuantity;
  String? selectedVendor;
  String? selectedBrandId;
  String? selectedBrand;
  List<VendorModel> vendors = [];
  List<BrandModel> brands = [];
  List<Map<String, dynamic>> requisitions = [];
  // bool isLoading = true;
  int? selectedRequisitionIndex;
  Map<String, String> productNames = {};
  Map<String, String> subCatNames = {};
  Map<String, String> branchName = {};
  Map<String, String> brandsName = {};
  Map<String, String> productsName = {};
  UniqueKey _pickerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    dataInits();
  }

  void dataInits() async {
    await fetchVendors();
    await fetchBrands();
    await _loadRequesitions();
    await _loadProductAndSubCatNames();
    //  DataFetchService.fetchBrands(),

    if (widget.isEdit && widget.quotaionModel != null) {
      _loadExistingQuotationData(widget.quotaionModel!);
    }
  }

  void _calculateTotalPrice() {
    double price = double.tryParse(pricePerItemController.text) ?? 0;
    int quantity = selectQuantity != 'Any'
        ? int.tryParse(selectQuantity!) ?? 0
        : 0;
    double discount = double.tryParse(discountController.text) ?? 0;

    double total = price * quantity;
    if (discount > 0) {
      total = total - (total * discount / 100);
    }

    totalPriceController.text = total.toStringAsFixed(2);
    setState(() {});
  }

  void _loadExistingQuotationData(QuotationProcurementModel model) {
    final selectedReqId = model.requisitionIds;
    final index = allRequesitions.indexWhere(
      (r) => r.requisitionId == selectedReqId,
    );

    if (index != -1) {
      selectedRequisitionIndex = index;
    }

    quotationsList = model.quotationList.map((quotation) {
      return {
        'images': quotation.imageURL,
        'vendorId': quotation.vendorId,
        'vendorName': quotation.vendorName,
        'quantity': quotation.quantity.toString(),
        'perItem': quotation.perItem.toString(),
        'totalPrice': quotation.totalPrice.toString(),
        //'brandId': quotation.brandId;
        'discount': '0', // Add default discount if not present
      };
    }).toList();
    setState(() {});
  }

  Future<void> _loadProductAndSubCatNames() async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('productsCategory')
        .get();
    final subCatSnapshot = await FirebaseFirestore.instance
        .collection('subCategory')
        .get();
    final branchNameSnashot = await FirebaseFirestore.instance
        .collection('branches')
        .get();
    final brandsSnapshot = await FirebaseFirestore.instance
        .collection('brand')
        .get();
    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();
    setState(() {
      productNames = {
        for (var doc in productSnapshot.docs)
          doc.id: doc.data()['productName'] ?? 'Unnamed Product',
      };
      subCatNames = {
        for (var doc in subCatSnapshot.docs)
          doc.id: doc.data()['name'] ?? 'Unnamed Subcategory',
      };
      branchName = {
        for (var doc in branchNameSnashot.docs)
          doc.id: doc.data()['branchName'] ?? 'Unnamed Branch',
      };
      brandsName = {
        for (var doc in brandsSnapshot.docs)
          doc.id: doc.data()['name'] ?? "Brand",
      };
      productsName = {
        for (var doc in productsSnapshot.docs)
          doc.id: doc.data()['productName'] ?? "product name",
      };
    });
  }

  Future<void> fetchVendors() async {
    final result = await DataFetchService.fetchVendor();
    setState(() {
      vendors = result;
    });
  }

  Future<void> fetchBrands() async {
    final result = await DataFetchService.fetchBrands();
    setState(() {
      brands = result;
    });
  }

  Future<void> _loadRequesitions() async {
    setState(() => loading.value = true);
    try {
      final results = await DataFetchService.fetchPurchseRequistionOnApproval();
      setState(() {
        allRequesitions = results;
        displayedRequesitions = List.from(allRequesitions);
        loading.value = false;
      });
    } catch (e) {
      debugPrint('Error fetching requisition data: $e');
      setState(() => loading.value = false);
    }
  }

  void _addImageVendorPair() async {
    if (!_validateQuotationForm()) return;
    setState(() {
      loading.value = true;
    });
    final discount = double.tryParse(discountController.text) ?? 0;

    quotationsList.add({
      'images': List<AttachmentModel>.from(attachments),
      'vendorId': selectedVendorId,
      'vendorName': selectedVendor,
      'quantity': selectQuantity,
      'perItem': pricePerItemController.text,
      'totalPrice': totalPriceController.text,
      'discount': discount.toString(),
      'brandId': selectedBrandId,
    });
    _clearQuotationForm();
    Constants.showMessage(context, 'Quotation added successfully'.tr());
  }

  bool _validateQuotationForm() {
    if (selectedVendor == null) {
      Constants.showMessage(context, 'Please select a vendor'.tr());
      return false;
    }
    if (attachments.isEmpty) {
      Constants.showMessage(context, 'Please upload at least one image'.tr());
      return false;
    }
    if (selectQuantity == null) {
      Constants.showMessage(context, 'Please select quantity'.tr());
      return false;
    }
    if (pricePerItemController.text.isEmpty) {
      Constants.showMessage(context, 'Please enter price per item'.tr());
      return false;
    }
    if (totalPriceController.text.isEmpty) {
      Constants.showMessage(context, 'Please enter total price'.tr());
      return false;
    }
    if (selectedBrandId == null) {
      Constants.showMessage(context, 'Please select brand'.tr());
      return false;
    }
    return true;
  }

  void _clearQuotationForm() {
    setState(() {
      attachments = [];
      attachments.clear();
      selectedVendor = null;
      selectedVendorId = null;
      selectQuantity = null;
      pricePerItemController.clear();
      totalPriceController.clear();
      discountController.text = '0';
      _pickerKey = UniqueKey();
      loading.value = false;
    });
  }

  void _removeQuotation(int index) {
    setState(() {
      quotationsList.removeAt(index);
    });
    Constants.showMessage(context, 'Quotation removed'.tr());
  }

  void _editQuotation(int index) {
    final quotation = quotationsList[index];
    setState(() {
      attachments = List<AttachmentModel>.from(quotation['images'] ?? []);
      selectedVendorId = quotation['vendorId'];
      selectedVendor = quotation['vendorName'];
      selectQuantity = quotation['quantity'];
      pricePerItemController.text = quotation['perItem'];
      totalPriceController.text = quotation['totalPrice'];
      discountController.text = quotation['discount'] ?? '0';
    });
    quotationsList.removeAt(index);
  }

  void _submitVendor() async {
    if (quotationsList.isEmpty) {
      Constants.showMessage(context, 'Please add at least one quotation'.tr());
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final profile = context.read<MmResourceProvider>().getProfileByID(uid!);
    if (loading.value) return;
    loading.value = true;

    try {
      if (profile.id.isEmpty) {
        if (!mounted) return;
        Constants.showMessage(context, 'User profile not found'.tr());
        loading.value = false;
        return;
      }

      final quotationList = <Quotation>[];

      for (var item in quotationsList) {
        final List<AttachmentModel> images = List<AttachmentModel>.from(
          item['images'] ?? [],
        );
        final discount = double.tryParse(item['discount'].toString()) ?? 0;

        for (var img in images) {
          List<String> urls = await Future.wait(
            images.map((attachment) async {
              return await Constants.uploadAttachment(attachment);
            }),
          );
          quotationList.add(
            Quotation(
              imageURL: urls.first,
              vendorId: item['vendorId'],
              vendorName: item['vendorName'],
              quantity: int.tryParse(item['quantity'].toString()) ?? 0,
              perItem: double.tryParse(item['perItem'].toString()) ?? 0,
              totalPrice: double.tryParse(item['totalPrice'].toString()) ?? 0,
              discount: discount, // Include discount in the model
              status: 'pending',
            ),
          );
        }
      }

      final selectedRequisitionId = selectedRequisitionIndex != null
          ? displayedRequesitions[selectedRequisitionIndex!].requisitionId
          : null;
      final purchaseId = selectedRequisitionIndex != null
          ? displayedRequesitions[selectedRequisitionIndex!].purchaseId
          : null;
      final brandId = selectedRequisitionIndex != null
          ? displayedRequesitions[selectedRequisitionIndex!].brandId
          : null;
      final productCatId = selectedRequisitionIndex != null
          ? displayedRequesitions[selectedRequisitionIndex!].category
          : null;
      final productSubCatId = selectedRequisitionIndex != null
          ? displayedRequesitions[selectedRequisitionIndex!].subCatId
          : null;
      final requisitionSerial = selectedRequisitionIndex != null
          ? displayedRequesitions[selectedRequisitionIndex!].serialNumber
          : null;
      final productId = selectedRequisitionIndex != null
          ? displayedRequesitions[selectedRequisitionIndex!].productId
          : null;
      final newModel = QuotationProcurementModel(
        purchaseId: purchaseId!,
        id: "",
        userId: profile.id,
        quotationList: quotationList,
        timestamp: Timestamp.now(),
        requisitionIds: selectedRequisitionId!,
        productCategoryId: productCatId!,
        productSubcategoryId: productSubCatId!,
        status: "pending",
        requisitionSerial: requisitionSerial!,
        productId: productId!,

        // productCategoryId: productCatId!,
        // productSubcategoryId: productSubCatId!,
      );

      await FirebaseFirestore.instance
          .collection('purchase')
          .doc(purchaseId)
          .collection('quotations')
          .add(newModel.toMap());

      if (!mounted) return;
      Constants.showMessage(context, 'Quotations added successfully'.tr());
      widget.onBack?.call();
      if (mounted) Navigator.of(context).pop();
    } catch (e, stackTrace) {
      if (!mounted) return;
      Constants.showMessage(context, 'Something went wrong'.tr());
      debugPrint('Error saving quotation: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      loading.value = false;
    }
  }

  final Map<String, String> quantityItems = {
    'any': 'Any',
    for (int i = 1; i <= 500; i += 1) '$i': '$i',
  };

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
    });
    // files.clear();
  }

  @override
  void dispose() {
    pricePerItemController.dispose();
    totalPriceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  // Enhanced Requisition Selection Dialog
  void _showRequisitionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(
                  maxWidth: 700,
                  maxHeight: 650,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogHeader(context),
                    //_buildSearchSection(setDialogState),
                    Flexible(child: _buildRequisitionsList(setDialogState)),
                    _buildDialogFooter(context, setDialogState),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 20, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Purchase Requisition'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.blackColor,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose a requisition to create quotations for'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.blackColor.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, color: AppTheme.grey, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.borderColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(StateSetter setDialogState) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.borderColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor.withOpacity(0.1)),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search by product name, category, or branch...'.tr(),
            hintStyle: TextStyle(color: AppTheme.grey.withOpacity(0.6)),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppTheme.primaryColor,
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildRequisitionsList(StateSetter setDialogState) {
    if (displayedRequesitions.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultsHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: displayedRequesitions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _buildRequisitionCard(index, setDialogState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.borderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppTheme.grey.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Requisitions Available'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.blackColor.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no approved requisitions available for quotation'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.grey.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Row(
      children: [
        Text(
          'Available Requisitions'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.blackColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.1),
                AppTheme.primaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${displayedRequesitions.length}',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequisitionCard(int index, StateSetter setDialogState) {
    final req = displayedRequesitions[index];
    final isSelected = selectedRequisitionIndex == index;

    return Card(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          //color: Colors.transparent,
          child: InkWell(
            onTap: () => setDialogState(() => selectedRequisitionIndex = index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.greenColor.withOpacity(0.1)
                    : AppTheme.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.greenColor.withOpacity(0.1)
                      : AppTheme.borderColor.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  _buildSelectionIndicator(isSelected),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRequisitionInfo(req)),
                  if (isSelected) _buildSelectedIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppTheme.greenColor : AppTheme.borderColor,
          width: 2,
        ),
        color: isSelected ? AppTheme.greenColor : Colors.transparent,
      ),
      child: isSelected
          ? Icon(Icons.check, color: AppTheme.whiteColor, size: 14)
          : null,
    );
  }

  Widget _buildRequisitionInfo(PurchaseRequisitionModel req) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${"REQ"}-${req.serialNumber}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.blackColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          productsName[req.productId] ?? 'Product',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.blackColor,
            fontSize: 14,
          ),
        ),
        Text(
          productNames[req.category] ?? 'Product',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.blackColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subCatNames[req.subCatId] ?? 'SubCategory',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.blackColor.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          brandsName[req.brandId] ?? 'brand',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.blackColor.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildInfoChip(
              Icons.inventory_2_outlined,
              'Qty: ${req.quantity}',
              AppTheme.primaryColor,
            ),
            _buildInfoChip(
              Icons.location_on_outlined,
              branchName[req.branchId] ?? 'Branch',
              AppTheme.orangeColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.greenColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Icons.check_rounded, color: AppTheme.whiteColor, size: 20),
    );
  }

  Widget _buildDialogFooter(BuildContext context, StateSetter setDialogState) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderColor.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          if (selectedRequisitionIndex != null) ...[
            Expanded(child: _buildSelectionSummary()),
            const SizedBox(width: 16),
          ] else
            const Spacer(),
          _buildActionButtons(context, setDialogState),
        ],
      ),
    );
  }

  Widget _buildSelectionSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.05),
            AppTheme.primaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Requisition'.tr(),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  productNames[displayedRequesitions[selectedRequisitionIndex!]
                          .productId] ??
                      'Product',
                  style: TextStyle(
                    color: AppTheme.blackColor.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, StateSetter setDialogState) {
    return Row(
      children: [
        SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.borderColor.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: Text(
              'Cancel'.tr(),
              style: TextStyle(
                color: AppTheme.blackColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: selectedRequisitionIndex != null
                ? () {
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.greenColor,
              disabledBackgroundColor: AppTheme.borderColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              elevation: selectedRequisitionIndex != null ? 3 : 0,
            ),
            child: Text(
              'Select'.tr(),
              style: TextStyle(
                color: selectedRequisitionIndex != null
                    ? AppTheme.whiteColor
                    : AppTheme.blackColor.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Enhanced Quotation Form Section
  Widget _buildQuotationForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: [_buildFormHeader(), _buildFormContent()]),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.05),
            AppTheme.primaryColor.withOpacity(0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vendor selection and add button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Quotation'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              // SizedBox(
              //   height: 40,
              //   width: 40,
              //   child: CustomButton(
              //     onPressed: _addImageVendorPair,
              //     iconAsset: 'assets/add_icon.png',
              //     buttonType: ButtonType.IconOnly,
              //     iconColor: AppTheme.whiteColor,
              //     backgroundColor: AppTheme.primaryColor,
              //     iconSize: 18,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),

          // Vendor, Brand and quantity selection row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vendor'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CustomSearchableDropdown(
                      hintText: 'Choose Vendor'.tr(),
                      value: selectedVendorId,
                      items: {for (var v in vendors) v.id!: v.vendorName},
                      onChanged: (val) {
                        setState(() {
                          selectedVendorId = val;
                          selectedVendor = vendors
                              .firstWhere((v) => v.id == val)
                              .vendorName;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brand'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CustomSearchableDropdown(
                      hintText: 'Choose Brand'.tr(),
                      value: selectedBrandId,
                      items: {for (var b in brands) b.id!: b.name},
                      onChanged: (val) {
                        setState(() {
                          selectedBrandId = val;
                          selectedBrand = brands
                              .firstWhere((b) => b.id == val)
                              .name;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quantity selection row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CustomSearchableDropdown(
                      hintText: 'Choose Quantity'.tr(),
                      value: selectQuantity,
                      items: quantityItems,
                      onChanged: (val) {
                        setState(() {
                          selectQuantity = val == 'any' ? 'Any' : val;
                          _calculateTotalPrice();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(),
              ), // Empty container for layout balance
            ],
          ),
          const SizedBox(height: 12),

          // Discount field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discount (%)'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              CustomMmTextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                hintText: '0',
                onChanged: (value) {
                  _calculateTotalPrice();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Price fields
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price per item'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CustomMmTextField(
                      controller: pricePerItemController,
                      keyboardType: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      validator: ValidationUtils.price,
                      hintText: '0.00',
                      onChanged: (value) {
                        _calculateTotalPrice();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total price'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CustomMmTextField(
                      controller: totalPriceController,
                      keyboardType: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      validator: ValidationUtils.price,
                      hintText: '0.00',
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Image upload section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Images'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  PickerWidget(
                    key: _pickerKey,
                    multipleAllowed: true,
                    attachments: attachments,
                    galleryAllowed: true,
                    onFilesPicked: onFilesPicked,
                    memoAllowed: false,
                    filesAllowed: true,
                    videoAllowed: false,
                    cameraAllowed: true,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: attachments.isNotEmpty
                          ? kIsWeb
                                ? Image.memory(
                                    attachments.last.bytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(attachments.last.url),
                                    fit: BoxFit.cover,
                                  )
                          : Icon(
                              Icons.add_photo_alternate_outlined,
                              color: AppTheme.grey,
                              size: 24,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 36,
                          width: 120,
                          child: CustomButton(
                            text: 'Add Quotation'.tr(),
                            onPressed: _addImageVendorPair,
                            fontSize: 12,
                            buttonType: ButtonType.Filled,
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'JPEG, PNG (Max 2MB)'.tr(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.grey, fontSize: 10),
                        ),
                        if (attachments.isNotEmpty)
                          Text(
                            '${attachments.length} image(s) selected'.tr(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontSize: 10,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Update the _buildQuotationItem to be more compact
  Widget _buildQuotationItem(int index) {
    final quotation = quotationsList[index];
    final List<AttachmentModel> quotationImages =
        (quotation['images'] as List<dynamic>?)?.cast<AttachmentModel>() ?? [];
    return Container(
      padding: const EdgeInsets.all(12), // Reduced padding
      margin: const EdgeInsets.only(bottom: 8), // Added margin between items
      decoration: BoxDecoration(
        color: AppTheme.borderColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          if (quotationImages.isNotEmpty)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: kIsWeb
                      ? MemoryImage(quotationImages.first.bytes!)
                      : FileImage(File(quotationImages.first.url))
                            as ImageProvider,
                ),
              ),
            )
          else
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.borderColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppTheme.grey,
                size: 20,
              ), // Smaller icon
            ),

          const SizedBox(width: 12),

          // Quotation details - more compact
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quotation['vendorName'] ?? 'Vendor',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Qty: ${quotation['quantity']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Price: ${quotation['perItem']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Total: ${quotation['totalPrice']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (quotation['discount'] != null &&
                        quotation['discount'] != '0')
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '(${quotation['discount']}% off)',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.greenColor),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Actions - smaller icons
          Row(
            children: [
              IconButton(
                onPressed: () => _editQuotation(index),
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ), // Smaller
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () => _removeQuotation(index),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.redColor,
                  size: 20,
                ), // Smaller
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, value, child) {
          return OverlayLoader(
            loader: value,
            child: value
                ? MmloadingWidget()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Form(
                      key: addQuotationKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PageHeaderWidget(
                            title: 'Add Quotations'.tr(),
                            buttonText: 'Back to Quotation'.tr(),
                            subTitle: 'Create New Quotations'.tr(),
                            onCreateIcon: 'assets/images/back.png',
                            selectedItems: [],
                            buttonWidth: 0.4,
                            onCreate: () {
                              if (widget.onBack != null) {
                                widget.onBack!();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            onDelete: () async {},
                          ),
                          const SizedBox(height: 20),

                          // Requisition selection card
                          Card(
                            margin: const EdgeInsets.only(bottom: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected Requisition'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 12),
                                  if (selectedRequisitionIndex != null)
                                    _buildSelectedRequisitionInfo()
                                  else
                                    _buildNoRequisitionSelected(),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _showRequisitionDialog,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      child: Text(
                                        selectedRequisitionIndex != null
                                            ? 'Change Requisition'.tr()
                                            : 'Select Requisition'.tr(),
                                        style: TextStyle(
                                          color: AppTheme.whiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Quotation form
                          if (selectedRequisitionIndex != null)
                            _buildQuotationForm(),

                          // Quotations list
                          if (quotationsList.isNotEmpty) _buildQuotationsList(),

                          // Submit button
                          if (selectedRequisitionIndex != null &&
                              quotationsList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 40,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: widget.isEdit
                                      ? 'Update Quotation'.tr()
                                      : 'Submit Quotation'.tr(),
                                  onPressed: _submitVendor,
                                  buttonType: ButtonType.Filled,
                                  backgroundColor: AppTheme.primaryColor,
                                  textColor: AppTheme.whiteColor,
                                  fontSize: 16,
                                  height: 50,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedRequisitionInfo() {
    final req = displayedRequesitions[selectedRequisitionIndex!];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productNames[req.productId] ?? 'Product',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            subCatNames[req.subCatId] ?? 'Subcategory',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            brandsName[req.branchId] ?? 'brand',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Quantity: ${req.quantity}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 16),
              Text(
                'Branch: ${branchName[req.branchId] ?? 'Unknown'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoRequisitionSelected() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.borderColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppTheme.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Please select a requisition to continue'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationsList() {
    return Card(
      margin: const EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Added Quotations'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              key: UniqueKey(),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quotationsList.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) => _buildQuotationItem(index),
            ),
          ],
        ),
      ),
    );
  }
}
