// // import 'package:app/modern_motors/models/product/product_model.dart';
// // import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// // import 'package:app/modern_motors/widgets/extension.dart';
// // import 'package:app/modern_motors/widgets/form_validation.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class DirectInventoryAddScreen extends StatefulWidget {
// //   final ProductModel? product;

// //   const DirectInventoryAddScreen({super.key, this.product});

// //   @override
// //   State<DirectInventoryAddScreen> createState() =>
// //       _DirectInventoryAddScreenState();
// // }

// // class _DirectInventoryAddScreenState extends State<DirectInventoryAddScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _quantityController = TextEditingController();
// //   final TextEditingController _unitCostController = TextEditingController();
// //   final TextEditingController _reasonController = TextEditingController();
// //   final TextEditingController _notesController = TextEditingController();

// //   String _adjustmentType = 'purchase';
// //   bool _isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.product != null) {
// //       _unitCostController.text =
// //           widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _quantityController.dispose();
// //     _unitCostController.dispose();
// //     _reasonController.dispose();
// //     _notesController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _submitForm() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       final quantity = int.parse(_quantityController.text);
// //       final unitCost = double.parse(_unitCostController.text);
// //       final reason = _reasonController.text;
// //       final notes = _notesController.text;
// //       User? user = FirebaseAuth.instance.currentUser;
// //       if (user == null) {
// //         return;
// //       }
// //       final inventoryData = {
// //         'productId': widget.product?.id,
// //         'quantity': _adjustmentType == 'addition'
// //             ? quantity
// //             : _adjustmentType == 'purchase'
// //                 ? quantity
// //                 : -quantity,
// //         'unitCost': unitCost,
// //         'adjustmentType': _adjustmentType,
// //         'reason': reason,
// //         'notes': notes,
// //         'adjustedBy': user.uid, // Replace with actual user ID
// //         'timestamp': FieldValue.serverTimestamp(),
// //         'status': 'completed',
// //         'createdAt': FieldValue.serverTimestamp(),
// //         'updatedAt': FieldValue.serverTimestamp(),
// //         'addedBy': user.uid
// //       };

// //       await FirebaseFirestore.instance
// //           .collection('inventoryAdjustments')
// //           .add(inventoryData);

// //       if (!mounted) return;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //               'Inventory ${_adjustmentType == 'addition' || _adjustmentType == 'purchase' ? 'added' : 'removed'} successfully'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       double q =
// //           (_adjustmentType == 'addition' || _adjustmentType == 'purchase')
// //               ? quantity.toDouble()
// //               : -quantity.toDouble();
// //       Navigator.of(context).pop(q);
// //     } catch (e) {
// //       if (!mounted) return;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Error: ${e.toString()}'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.product != null
// //             ? 'Add Inventory - ${widget.product!.productName}'
// //             : 'Add Inventory'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: ListView(
// //             children: [
// //               if (widget.product != null) ...[
// //                 _buildProductInfo(),
// //                 20.h,
// //               ],

// //               // Adjustment Type
// //               DropdownButtonFormField<String>(
// //                 value: _adjustmentType,
// //                 decoration: InputDecoration(
// //                   labelText: 'Adjustment Type'.tr(),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 items: [
// //                   DropdownMenuItem(
// //                     value: 'purchase',
// //                     child: Text('Stock Purchase'.tr()),
// //                   ),
// //                   DropdownMenuItem(
// //                     value: 'addition',
// //                     child: Text('Stock Addition'.tr()),
// //                   ),
// //                   DropdownMenuItem(
// //                     value: 'reduction',
// //                     child: Text('Stock Reduction'.tr()),
// //                   ),
// //                 ],
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _adjustmentType = value!;
// //                   });
// //                 },
// //                 validator: (value) {
// //                   if (value == null) return 'Please select adjustment type';
// //                   return null;
// //                 },
// //               ),

// //               20.h,

// //               // Quantity
// //               // TextFormField(
// //               //   controller: _quantityController,
// //               //   decoration: InputDecoration(
// //               //     labelText: 'Quantity'.tr(),
// //               //     border: OutlineInputBorder(),
// //               //     suffixText: _adjustmentType == 'addition'
// //               //         ? 'Units to add'
// //               //         : 'Units to remove',
// //               //   ),
// //               //   keyboardType: TextInputType.number,
// //               //   validator: (value) {
// //               //     if (value == null || value.isEmpty)
// //               //       return 'Please enter quantity';
// //               //     final quantity = int.tryParse(value);
// //               //     if (quantity == null || quantity <= 0)
// //               //       return 'Please enter valid quantity';
// //               //     if (_adjustmentType == 'reduction' &&
// //               //         widget.product != null) {
// //               //       if (quantity > (widget.product!.totalStockOnHand ?? 0)) {
// //               //         return 'Cannot remove more than available stock';
// //               //       }
// //               //     }
// //               //     return null;
// //               //   },
// //               // ),
// //               CustomMmTextField(
// //                 controller: _quantityController,
// //                 labelText: 'Quantity'.tr(),
// //                 hintText: _adjustmentType == 'addition'
// //                     ? 'Units to add'
// //                     : 'Units to remove',
// //                 keyboardType: TextInputType.number,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 validator: ValidationUtils.quantity,
// //               ),

// //               20.h,

// //               // Unit Cost (only for additions)
// //               if (_adjustmentType == 'addition' ||
// //                   _adjustmentType == 'purchase')
// //                 TextFormField(
// //                   controller: _unitCostController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Unit Cost (OMR)'.tr(),
// //                     border: OutlineInputBorder(),
// //                   ),
// //                   keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                   validator: (value) {
// //                     if (_adjustmentType == 'addition') {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter unit cost';
// //                       }
// //                       final cost = double.tryParse(value);
// //                       if (cost == null || cost <= 0) {
// //                         return 'Please enter valid cost';
// //                       }
// //                     }
// //                     return null;
// //                   },
// //                 ),

// //               if (_adjustmentType == 'addition') 20.h,
// //               // Reason
// //               TextFormField(
// //                 controller: _reasonController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Reason'.tr(),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 maxLines: 2,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter reason';
// //                   }
// //                   return null;
// //                 },
// //               ),

// //               20.h,

// //               // Notes
// //               TextFormField(
// //                 controller: _notesController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Notes (Optional)'.tr(),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 maxLines: 3,
// //               ),

// //               30.h,

// //               // Submit Button
// //               ElevatedButton(
// //                 onPressed: _isLoading ? null : _submitForm,
// //                 style: ElevatedButton.styleFrom(
// //                   padding: const EdgeInsets.symmetric(vertical: 16),
// //                   backgroundColor: _adjustmentType == 'addition' ||
// //                           _adjustmentType == 'purchase'
// //                       ? Colors.green
// //                       : Colors.orange,
// //                 ),
// //                 child: _isLoading
// //                     ? const CircularProgressIndicator()
// //                     : Text(
// //                         _adjustmentType == 'addition' ||
// //                                 _adjustmentType == 'purchase'
// //                             ? 'Add Stock'.tr()
// //                             : 'Remove Stock'.tr(),
// //                         style: const TextStyle(fontSize: 16),
// //                       ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildProductInfo() {
// //     return Card(
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Product Information',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.grey[700],
// //               ),
// //             ),
// //             10.h,
// //             Text('Name: ${widget.product!.productName}'),
// //             5.h,
// //             Text('Code: ${widget.product!.code}'),
// //             5.h,
// //             Text(
// //                 'Current Stock: ${widget.product!.totalStockOnHand ?? 0} units'),
// //             5.h,
// //             Text(
// //                 'Average Cost: OMR ${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:modern_motors_panel/app_theme.dart';
// import 'package:modern_motors_panel/model/product_models/product_model.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';

// class DirectInventoryAddScreen extends StatefulWidget {
//   final ProductModel? product;
//   final VoidCallback? onBack;
//   const DirectInventoryAddScreen({super.key, this.product, this.onBack});

//   @override
//   State<DirectInventoryAddScreen> createState() =>
//       _DirectInventoryAddScreenState();
// }

// class _DirectInventoryAddScreenState extends State<DirectInventoryAddScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _unitCostController = TextEditingController();
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();

//   String _adjustmentType = 'purchase';
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.product != null) {
//       _unitCostController.text =
//           widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
//     }
//   }

//   @override
//   void dispose() {
//     _quantityController.dispose();
//     _unitCostController.dispose();
//     _reasonController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final quantity = int.parse(_quantityController.text);
//       final unitCost = double.parse(_unitCostController.text);
//       final reason = _reasonController.text;
//       final notes = _notesController.text;
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         return;
//       }
//       final inventoryData = {
//         'productId': widget.product?.id,
//         'quantity': _adjustmentType == 'addition'
//             ? quantity
//             : _adjustmentType == 'purchase'
//             ? quantity
//             : -quantity,
//         'unitCost': unitCost,
//         'adjustmentType': _adjustmentType,
//         'reason': reason,
//         'notes': notes,
//         'adjustedBy': user.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//         'status': 'completed',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'addedBy': user.uid,
//       };

//       await FirebaseFirestore.instance
//           .collection('inventoryAdjustments')
//           .add(inventoryData);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Inventory ${_adjustmentType == 'addition' || _adjustmentType == 'purchase' ? 'added' : 'removed'} successfully',
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//       double q =
//           (_adjustmentType == 'addition' || _adjustmentType == 'purchase')
//           ? quantity.toDouble()
//           : -quantity.toDouble();
//       Navigator.of(context).pop(q);
//       // widget.onBack?.call();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Inventory Management',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             if (widget.product != null)
//               Text(
//                 widget.product!.productName ?? 'Unknown Product',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//           ],
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (widget.product != null) ...[
//                 _buildProductInfoCard(),
//                 const SizedBox(height: 20),
//               ],
//               _buildAdjustmentCard(),
//               const SizedBox(height: 20),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductInfoCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.inventory_2_outlined,
//                   color: Color(0xFF475569),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Product Information',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildInfoGrid(),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoGrid() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: _buildInfoItem(
//                 'Product Name',
//                 widget.product!.productName ?? 'N/A',
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildInfoItem(
//                 'Product Code',
//                 widget.product!.code ?? 'N/A',
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildInfoItem(
//                 'Current Stock',
//                 '${widget.product!.totalStockOnHand ?? 0} units',
//                 valueColor: _getStockColor(
//                   (widget.product!.totalStockOnHand ?? 0).toInt(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildInfoItem(
//                 'Average Cost',
//                 'OMR ${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoItem(String label, String value, {Color? valueColor}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF64748B),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: valueColor ?? const Color(0xFF1E293B),
//           ),
//         ),
//       ],
//     );
//   }

//   Color _getStockColor(int stock) {
//     if (stock <= 0) return const Color(0xFFDC2626);
//     if (stock <= 10) return const Color(0xFFF59E0B);
//     return const Color(0xFF059669);
//   }

//   Widget _buildAdjustmentCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.tune,
//                   color: Color(0xFF475569),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Stock Adjustment',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildAdjustmentTypeSection(),
//           const SizedBox(height: 20),
//           _buildQuantitySection(),
//           if (_adjustmentType == 'addition' ||
//               _adjustmentType == 'purchase') ...[
//             const SizedBox(height: 20),
//             _buildUnitCostSection(),
//           ],
//           const SizedBox(height: 20),
//           _buildReasonSection(),
//           const SizedBox(height: 20),
//           _buildNotesSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdjustmentTypeSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Adjustment Type',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFFD1D5DB)),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: _adjustmentType,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             items: [
//               DropdownMenuItem(
//                 value: 'purchase',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF059669),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Purchase'.tr()),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'addition',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF3B82F6),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Addition'.tr()),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'reduction',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFEF4444),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Reduction'.tr()),
//                   ],
//                 ),
//               ),
//             ],
//             onChanged: (value) {
//               setState(() {
//                 _adjustmentType = value!;
//               });
//             },
//             validator: (value) {
//               if (value == null) return 'Please select adjustment type';
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuantitySection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quantity',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         CustomMmTextField(
//           controller: _quantityController,
//           hintText: _adjustmentType == 'reduction'
//               ? 'Units to remove'
//               : 'Units to add',
//           keyboardType: TextInputType.number,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           validator: ValidationUtils.quantity,
//           //  prefixIcon: const Icon(Icons.numbers, color: Color(0xFF64748B)),
//         ), //,
//       ],
//     );
//   }

//   Widget _buildUnitCostSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Unit Cost (OMR)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _unitCostController,
//           decoration: InputDecoration(
//             hintText: 'Enter unit cost',
//             prefixIcon: const Icon(
//               Icons.attach_money,
//               color: Color(0xFF64748B),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           validator: (value) {
//             if (_adjustmentType == 'addition' ||
//                 _adjustmentType == 'purchase') {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter unit cost';
//               }
//               final cost = double.tryParse(value);
//               if (cost == null || cost <= 0) {
//                 return 'Please enter valid cost';
//               }
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildReasonSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Reason',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _reasonController,
//           decoration: InputDecoration(
//             hintText: 'Enter reason for adjustment',
//             prefixIcon: const Icon(Icons.description, color: Color(0xFF64748B)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           maxLines: 2,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter reason';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildNotesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Notes (Optional)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _notesController,
//           decoration: InputDecoration(
//             hintText: 'Add any additional notes...',
//             prefixIcon: const Icon(Icons.note, color: Color(0xFF64748B)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           maxLines: 3,
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : _submitForm,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: _getButtonColor(),
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         elevation: 0,
//       ),
//       child: _isLoading
//           ? const SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//           : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(_getButtonIcon(), size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                   _getButtonText(),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Color _getButtonColor() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return AppTheme.greenColor;
//       case 'addition':
//         return const Color(0xFF3B82F6);
//       case 'reduction':
//         return const Color(0xFFEF4444);
//       default:
//         return const Color(0xFF6B7280);
//     }
//   }

//   IconData _getButtonIcon() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return Icons.shopping_cart;
//       case 'addition':
//         return Icons.add_circle;
//       case 'reduction':
//         return Icons.remove_circle;
//       default:
//         return Icons.check;
//     }
//   }

//   String _getButtonText() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return 'Record Purchase'.tr();
//       case 'addition':
//         return 'Add Stock'.tr();
//       case 'reduction':
//         return 'Remove Stock'.tr();
//       default:
//         return 'Submit';
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';

// class DirectInventoryAddScreen extends StatefulWidget {
//   final ProductModel? product;
//   final VoidCallback? onBack;
//   const DirectInventoryAddScreen({super.key, this.product, this.onBack});

//   @override
//   State<DirectInventoryAddScreen> createState() =>
//       _DirectInventoryAddScreenState();
// }

// class _DirectInventoryAddScreenState extends State<DirectInventoryAddScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _unitCostController = TextEditingController();
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();
//   final TextEditingController _locationTagController = TextEditingController();

//   String _adjustmentType = 'purchase';
//   bool _isLoading = false;
//   List<String> _locationTags = [];
//   List<String> _filteredTags = [];
//   bool _showDropdown = false;
//   final FocusNode _locationFocusNode = FocusNode();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.product != null) {
//       _unitCostController.text =
//           widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
//     }
//     _loadLocationTags();

//     _locationTagController.addListener(() {
//       _filterTags(_locationTagController.text);
//       if (_locationFocusNode.hasFocus) {
//         _showOverlay();
//       }
//     });

//     _locationFocusNode.addListener(() {
//       if (_locationFocusNode.hasFocus) {
//         _showOverlay();
//       } else {
//         _hideOverlay();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _hideOverlay();
//     _quantityController.dispose();
//     _unitCostController.dispose();
//     _reasonController.dispose();
//     _notesController.dispose();
//     _locationTagController.dispose();
//     _locationFocusNode.dispose();
//     super.dispose();
//   }

//   void _showOverlay() {
//     _hideOverlay();
//     _overlayEntry = _createOverlayEntry();
//     Overlay.of(context).insert(_overlayEntry!);
//   }

//   void _hideOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;

//     return OverlayEntry(
//       builder: (context) => Positioned(
//         width: size.width - 32,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           offset: const Offset(0, 60),
//           child: Material(
//             elevation: 4,
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               constraints: const BoxConstraints(maxHeight: 200),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: const Color(0xFFE2E8F0)),
//               ),
//               child:
//                   _filteredTags.isEmpty &&
//                       _locationTagController.text.isNotEmpty
//                   ? _buildAddNewTagOption()
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       padding: EdgeInsets.zero,
//                       itemCount:
//                           _filteredTags.length +
//                           (_locationTagController.text.isNotEmpty &&
//                                   !_filteredTags.any(
//                                     (tag) =>
//                                         tag.toLowerCase() ==
//                                         _locationTagController.text
//                                             .toLowerCase(),
//                                   )
//                               ? 1
//                               : 0),
//                       itemBuilder: (context, index) {
//                         if (index == _filteredTags.length) {
//                           return _buildAddNewTagOption();
//                         }

//                         final tag = _filteredTags[index];
//                         return ListTile(
//                           dense: true,
//                           leading: const Icon(
//                             Icons.pin_drop,
//                             size: 18,
//                             color: Color(0xFF3B82F6),
//                           ),
//                           title: Text(
//                             tag,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           onTap: () {
//                             setState(() {
//                               _locationTagController.text = tag;
//                             });
//                             _locationFocusNode.unfocus();
//                           },
//                         );
//                       },
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _loadLocationTags() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('locationTags')
//           .orderBy('name')
//           .get();

//       setState(() {
//         _locationTags = snapshot.docs
//             .map((doc) => doc.data()['name'] as String)
//             .toList();
//         _filteredTags = _locationTags;
//       });
//     } catch (e) {
//       print('Error loading location tags: $e');
//     }
//   }

//   void _filterTags(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredTags = _locationTags;
//       } else {
//         _filteredTags = _locationTags
//             .where((tag) => tag.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   Future<void> _addNewLocationTag(String tagName) async {
//     if (tagName.trim().isEmpty) return;

//     final trimmedTag = tagName.trim();

//     final exists = _locationTags.any(
//       (tag) => tag.toLowerCase() == trimmedTag.toLowerCase(),
//     );

//     if (!exists) {
//       try {
//         await FirebaseFirestore.instance.collection('locationTags').add({
//           'name': trimmedTag,
//           'createdAt': FieldValue.serverTimestamp(),
//           'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
//         });

//         setState(() {
//           _locationTags.add(trimmedTag);
//           _locationTags.sort();
//           _filteredTags = _locationTags;
//         });

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('New location "$trimmedTag" added successfully'),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Error adding location: $e'),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       }
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     final locationTag = _locationTagController.text.trim();

//     if (locationTag.isNotEmpty &&
//         !_locationTags.any(
//           (tag) => tag.toLowerCase() == locationTag.toLowerCase(),
//         )) {
//       await _addNewLocationTag(locationTag);
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final quantity = int.parse(_quantityController.text);
//       final unitCost = double.parse(_unitCostController.text);
//       final reason = _reasonController.text;
//       final notes = _notesController.text;

//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         return;
//       }

//       final inventoryData = {
//         'productId': widget.product?.id,
//         'quantity': _adjustmentType == 'addition'
//             ? quantity
//             : _adjustmentType == 'purchase'
//             ? quantity
//             : -quantity,
//         'unitCost': unitCost,
//         'adjustmentType': _adjustmentType,
//         'reason': reason,
//         'notes': notes,
//         'locationTag': locationTag,
//         'adjustedBy': user.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//         'status': 'completed',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'addedBy': user.uid,
//       };

//       await FirebaseFirestore.instance
//           .collection('inventoryAdjustments')
//           .add(inventoryData);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Inventory ${_adjustmentType == 'addition' || _adjustmentType == 'purchase' ? 'added' : 'removed'} successfully',
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//       double q =
//           (_adjustmentType == 'addition' || _adjustmentType == 'purchase')
//           ? quantity.toDouble()
//           : -quantity.toDouble();
//       Navigator.of(context).pop(q);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildAddNewTagOption() {
//     return ListTile(
//       dense: true,
//       leading: Container(
//         padding: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           color: const Color(0xFF10B981).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: const Icon(Icons.add, size: 18, color: Color(0xFF10B981)),
//       ),
//       title: Text(
//         'Add "${_locationTagController.text}"',
//         style: const TextStyle(
//           fontSize: 14,
//           color: Color(0xFF10B981),
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       subtitle: const Text(
//         'Create new location tag',
//         style: TextStyle(fontSize: 11),
//       ),
//       onTap: () {
//         _locationFocusNode.unfocus();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Inventory Management',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             if (widget.product != null)
//               Text(
//                 widget.product!.productName ?? 'Unknown Product',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//           ],
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (widget.product != null) ...[
//                 _buildProductInfoCard(),
//                 const SizedBox(height: 20),
//               ],
//               _buildAdjustmentCard(),
//               const SizedBox(height: 20),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductInfoCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.inventory_2_outlined,
//                   color: Color(0xFF475569),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Product Information',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildInfoItem(
//                   'Product Name',
//                   widget.product!.productName ?? 'N/A',
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildInfoItem(
//                   'Product Code',
//                   widget.product!.code ?? 'N/A',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildInfoItem(
//                   'Current Stock',
//                   '${widget.product!.totalStockOnHand ?? 0} units',
//                   valueColor: _getStockColor(
//                     (widget.product!.totalStockOnHand ?? 0).toInt(),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildInfoItem(
//                   'Average Cost',
//                   'OMR ${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoItem(String label, String value, {Color? valueColor}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF64748B),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: valueColor ?? const Color(0xFF1E293B),
//           ),
//         ),
//       ],
//     );
//   }

//   Color _getStockColor(int stock) {
//     if (stock <= 0) return const Color(0xFFDC2626);
//     if (stock <= 10) return const Color(0xFFF59E0B);
//     return const Color(0xFF059669);
//   }

//   Widget _buildAdjustmentCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.tune,
//                   color: Color(0xFF475569),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Stock Adjustment',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildAdjustmentTypeSection(),
//           const SizedBox(height: 20),
//           _buildQuantitySection(),
//           const SizedBox(height: 20),
//           _buildLocationSection(),
//           if (_adjustmentType == 'addition' ||
//               _adjustmentType == 'purchase') ...[
//             const SizedBox(height: 20),
//             _buildUnitCostSection(),
//           ],
//           const SizedBox(height: 20),
//           _buildReasonSection(),
//           const SizedBox(height: 20),
//           _buildNotesSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Text(
//               'Storage Location',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF374151),
//               ),
//             ),
//             const SizedBox(width: 6),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF59E0B).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Text(
//                 'REQUIRED',
//                 style: TextStyle(
//                   fontSize: 9,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFF59E0B),
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         CompositedTransformTarget(
//           link: _layerLink,
//           child: TextFormField(
//             controller: _locationTagController,
//             focusNode: _locationFocusNode,
//             decoration: InputDecoration(
//               hintText: 'Search or add new location',
//               prefixIcon: const Icon(
//                 Icons.location_on,
//                 color: Color(0xFF64748B),
//               ),
//               suffixIcon: _locationTagController.text.isNotEmpty
//                   ? IconButton(
//                       icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
//                       onPressed: () {
//                         setState(() {
//                           _locationTagController.clear();
//                           _filteredTags = _locationTags;
//                         });
//                       },
//                     )
//                   : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF3B82F6),
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Please enter storage location';
//               }
//               return null;
//             },
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Type to search existing locations or add a new one',
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade600,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAdjustmentTypeSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Adjustment Type',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFFD1D5DB)),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: _adjustmentType,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             items: [
//               DropdownMenuItem(
//                 value: 'purchase',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF059669),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Purchase'.tr()),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'addition',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF3B82F6),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Addition'.tr()),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'reduction',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFEF4444),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Reduction'.tr()),
//                   ],
//                 ),
//               ),
//             ],
//             onChanged: (value) {
//               setState(() {
//                 _adjustmentType = value!;
//               });
//             },
//             validator: (value) {
//               if (value == null) return 'Please select adjustment type';
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuantitySection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quantity',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _quantityController,
//           decoration: InputDecoration(
//             hintText: _adjustmentType == 'reduction'
//                 ? 'Units to remove'
//                 : 'Units to add',
//             prefixIcon: const Icon(Icons.numbers, color: Color(0xFF64748B)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           keyboardType: TextInputType.number,
//           validator: (value) {
//             if (value == null || value.isEmpty) return 'Please enter quantity';
//             final quantity = int.tryParse(value);
//             if (quantity == null || quantity <= 0)
//               return 'Please enter valid quantity';
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildUnitCostSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Unit Cost (OMR)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _unitCostController,
//           decoration: InputDecoration(
//             hintText: 'Enter unit cost',
//             prefixIcon: const Icon(
//               Icons.attach_money,
//               color: Color(0xFF64748B),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           validator: (value) {
//             if (_adjustmentType == 'addition' ||
//                 _adjustmentType == 'purchase') {
//               if (value == null || value.isEmpty)
//                 return 'Please enter unit cost';
//               final cost = double.tryParse(value);
//               if (cost == null || cost <= 0) return 'Please enter valid cost';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildReasonSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Reason',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _reasonController,
//           decoration: InputDecoration(
//             hintText: 'Enter reason for adjustment',
//             prefixIcon: const Icon(Icons.description, color: Color(0xFF64748B)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           maxLines: 2,
//           validator: (value) {
//             if (value == null || value.isEmpty) return 'Please enter reason';
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildNotesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Notes (Optional)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _notesController,
//           decoration: InputDecoration(
//             hintText: 'Add any additional notes...',
//             prefixIcon: const Icon(Icons.note, color: Color(0xFF64748B)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           maxLines: 3,
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : _submitForm,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _getButtonColor(),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           elevation: 0,
//         ),
//         child: _isLoading
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(_getButtonIcon(), size: 20),
//                   const SizedBox(width: 8),
//                   Text(
//                     _getButtonText(),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Color _getButtonColor() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return const Color(0xFF059669);
//       case 'addition':
//         return const Color(0xFF3B82F6);
//       case 'reduction':
//         return const Color(0xFFEF4444);
//       default:
//         return const Color(0xFF6B7280);
//     }
//   }

//   IconData _getButtonIcon() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return Icons.shopping_cart;
//       case 'addition':
//         return Icons.add_circle;
//       case 'reduction':
//         return Icons.remove_circle;
//       default:
//         return Icons.check;
//     }
//   }

//   String _getButtonText() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return 'Record Purchase'.tr();
//       case 'addition':
//         return 'Add Stock'.tr();
//       case 'reduction':
//         return 'Remove Stock'.tr();
//       default:
//         return 'Submit';
//     }
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:practice_erp/model/product_model.dart';
// import 'package:practice_erp/utils/form_validation.dart';
// import 'package:practice_erp/view/unit/extensions.dart';
// import 'package:practice_erp/widgets/custom_text_field.dart';

// class DirectInventoryAddScreen extends StatefulWidget {
//   final ProductModel? product;

//   const DirectInventoryAddScreen({super.key, this.product});

//   @override
//   State<DirectInventoryAddScreen> createState() =>
//       _DirectInventoryAddScreenState();
// }

// class _DirectInventoryAddScreenState extends State<DirectInventoryAddScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _unitCostController = TextEditingController();
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();

//   String _adjustmentType = 'purchase';
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.product != null) {
//       _unitCostController.text =
//           widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
//     }
//   }

//   @override
//   void dispose() {
//     _quantityController.dispose();
//     _unitCostController.dispose();
//     _reasonController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final quantity = int.parse(_quantityController.text);
//       final unitCost = double.parse(_unitCostController.text);
//       final reason = _reasonController.text;
//       final notes = _notesController.text;
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         return;
//       }
//       final inventoryData = {
//         'productId': widget.product?.id,
//         'quantity':
//             _adjustmentType == 'addition'
//                 ? quantity
//                 : _adjustmentType == 'purchase'
//                 ? quantity
//                 : -quantity,
//         'unitCost': unitCost,
//         'adjustmentType': _adjustmentType,
//         'reason': reason,
//         'notes': notes,
//         'adjustedBy': user.uid, // Replace with actual user ID
//         'timestamp': FieldValue.serverTimestamp(),
//         'status': 'completed',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       await FirebaseFirestore.instance
//           .collection('inventoryAdjustments')
//           .add(inventoryData);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Inventory ${_adjustmentType == 'addition' ? 'added' : 'removed'} successfully',
//           ),
//           backgroundColor: Colors.green,
//         ),
//       );
//       Navigator.of(context).pop();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.product != null
//               ? 'Add Inventory - ${widget.product!.productName}'
//               : 'Add Inventory',
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               if (widget.product != null) ...[_buildProductInfo(), 20.h],

//               // Adjustment Type
//               DropdownButtonFormField<String>(
//                 value: _adjustmentType,
//                 decoration: InputDecoration(
//                   labelText: 'Adjustment Type'.tr(),
//                   border: OutlineInputBorder(),
//                 ),
//                 items: [
//                   DropdownMenuItem(
//                     value: 'purchase',
//                     child: Text('Stock Purchase'.tr()),
//                   ),
//                   DropdownMenuItem(
//                     value: 'addition',
//                     child: Text('Stock Addition'.tr()),
//                   ),
//                   DropdownMenuItem(
//                     value: 'reduction',
//                     child: Text('Stock Reduction'.tr()),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _adjustmentType = value!;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) return 'Please select adjustment type';
//                   return null;
//                 },
//               ),

//               20.h,

//               // Quantity
//               // TextFormField(
//               //   controller: _quantityController,
//               //   decoration: InputDecoration(
//               //     labelText: 'Quantity'.tr(),
//               //     border: OutlineInputBorder(),
//               //     suffixText: _adjustmentType == 'addition'
//               //         ? 'Units to add'
//               //         : 'Units to remove',
//               //   ),
//               //   keyboardType: TextInputType.number,
//               //   validator: (value) {
//               //     if (value == null || value.isEmpty)
//               //       return 'Please enter quantity';
//               //     final quantity = int.tryParse(value);
//               //     if (quantity == null || quantity <= 0)
//               //       return 'Please enter valid quantity';
//               //     if (_adjustmentType == 'reduction' &&
//               //         widget.product != null) {
//               //       if (quantity > (widget.product!.totalStockOnHand ?? 0)) {
//               //         return 'Cannot remove more than available stock';
//               //       }
//               //     }
//               //     return null;
//               //   },
//               // ),
//               CustomTextField(
//                 controller: _quantityController,
//                 labelText: 'Quantity'.tr(),
//                 hintText:
//                     _adjustmentType == 'addition'
//                         ? 'Units to add'
//                         : 'Units to remove',
//                 keyboardType: TextInputType.number,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: ValidationUtils.quantity,
//               ),

//               20.h,

//               // Unit Cost (only for additions)
//               if (_adjustmentType == 'addition')
//                 TextFormField(
//                   controller: _unitCostController,
//                   decoration: InputDecoration(
//                     labelText: 'Unit Cost'.tr(),
//                     border: OutlineInputBorder(),
//                     prefixText: 'OMR',
//                   ),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   validator: (value) {
//                     if (_adjustmentType == 'addition') {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter unit cost';
//                       }
//                       final cost = double.tryParse(value);
//                       if (cost == null || cost <= 0) {
//                         return 'Please enter valid cost';
//                       }
//                     }
//                     return null;
//                   },
//                 ),

//               if (_adjustmentType == 'addition') 20.h,
//               // Reason
//               TextFormField(
//                 controller: _reasonController,
//                 decoration: InputDecoration(
//                   labelText: 'Reason'.tr(),
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 2,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter reason';
//                   }
//                   return null;
//                 },
//               ),

//               20.h,

//               // Notes
//               TextFormField(
//                 controller: _notesController,
//                 decoration: InputDecoration(
//                   labelText: 'Notes (Optional)'.tr(),
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),

//               30.h,

//               // Submit Button
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _submitForm,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor:
//                       _adjustmentType == 'addition' ||
//                               _adjustmentType == 'purchase'
//                           ? Colors.green
//                           : Colors.orange,
//                 ),
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator()
//                         : Text(
//                           _adjustmentType == 'addition' ||
//                                   _adjustmentType == 'purchase'
//                               ? 'Add Stock'.tr()
//                               : 'Remove Stock'.tr(),
//                           style: const TextStyle(fontSize: 16),
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductInfo() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Product Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ),
//             10.h,
//             Text('Name: ${widget.product!.productName}'),
//             5.h,
//             Text('Code: ${widget.product!.code}'),
//             5.h,
//             Text(
//               'Current Stock: ${widget.product!.totalStockOnHand ?? 0} units',
//             ),
//             5.h,
//             Text(
//               'Average Cost: \$${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:app/modern_motors/models/product/product_model.dart';
// // import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// // import 'package:app/modern_motors/widgets/extension.dart';
// // import 'package:app/modern_motors/widgets/form_validation.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class DirectInventoryAddScreen extends StatefulWidget {
// //   final ProductModel? product;

// //   const DirectInventoryAddScreen({super.key, this.product});

// //   @override
// //   State<DirectInventoryAddScreen> createState() =>
// //       _DirectInventoryAddScreenState();
// // }

// // class _DirectInventoryAddScreenState extends State<DirectInventoryAddScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _quantityController = TextEditingController();
// //   final TextEditingController _unitCostController = TextEditingController();
// //   final TextEditingController _reasonController = TextEditingController();
// //   final TextEditingController _notesController = TextEditingController();

// //   String _adjustmentType = 'purchase';
// //   bool _isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.product != null) {
// //       _unitCostController.text =
// //           widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _quantityController.dispose();
// //     _unitCostController.dispose();
// //     _reasonController.dispose();
// //     _notesController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _submitForm() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       final quantity = int.parse(_quantityController.text);
// //       final unitCost = double.parse(_unitCostController.text);
// //       final reason = _reasonController.text;
// //       final notes = _notesController.text;
// //       User? user = FirebaseAuth.instance.currentUser;
// //       if (user == null) {
// //         return;
// //       }
// //       final inventoryData = {
// //         'productId': widget.product?.id,
// //         'quantity': _adjustmentType == 'addition'
// //             ? quantity
// //             : _adjustmentType == 'purchase'
// //                 ? quantity
// //                 : -quantity,
// //         'unitCost': unitCost,
// //         'adjustmentType': _adjustmentType,
// //         'reason': reason,
// //         'notes': notes,
// //         'adjustedBy': user.uid, // Replace with actual user ID
// //         'timestamp': FieldValue.serverTimestamp(),
// //         'status': 'completed',
// //         'createdAt': FieldValue.serverTimestamp(),
// //         'updatedAt': FieldValue.serverTimestamp(),
// //         'addedBy': user.uid
// //       };

// //       await FirebaseFirestore.instance
// //           .collection('inventoryAdjustments')
// //           .add(inventoryData);

// //       if (!mounted) return;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //               'Inventory ${_adjustmentType == 'addition' || _adjustmentType == 'purchase' ? 'added' : 'removed'} successfully'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       double q =
// //           (_adjustmentType == 'addition' || _adjustmentType == 'purchase')
// //               ? quantity.toDouble()
// //               : -quantity.toDouble();
// //       Navigator.of(context).pop(q);
// //     } catch (e) {
// //       if (!mounted) return;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Error: ${e.toString()}'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.product != null
// //             ? 'Add Inventory - ${widget.product!.productName}'
// //             : 'Add Inventory'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: ListView(
// //             children: [
// //               if (widget.product != null) ...[
// //                 _buildProductInfo(),
// //                 20.h,
// //               ],

// //               // Adjustment Type
// //               DropdownButtonFormField<String>(
// //                 value: _adjustmentType,
// //                 decoration: InputDecoration(
// //                   labelText: 'Adjustment Type'.tr(),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 items: [
// //                   DropdownMenuItem(
// //                     value: 'purchase',
// //                     child: Text('Stock Purchase'.tr()),
// //                   ),
// //                   DropdownMenuItem(
// //                     value: 'addition',
// //                     child: Text('Stock Addition'.tr()),
// //                   ),
// //                   DropdownMenuItem(
// //                     value: 'reduction',
// //                     child: Text('Stock Reduction'.tr()),
// //                   ),
// //                 ],
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _adjustmentType = value!;
// //                   });
// //                 },
// //                 validator: (value) {
// //                   if (value == null) return 'Please select adjustment type';
// //                   return null;
// //                 },
// //               ),

// //               20.h,

// //               // Quantity
// //               // TextFormField(
// //               //   controller: _quantityController,
// //               //   decoration: InputDecoration(
// //               //     labelText: 'Quantity'.tr(),
// //               //     border: OutlineInputBorder(),
// //               //     suffixText: _adjustmentType == 'addition'
// //               //         ? 'Units to add'
// //               //         : 'Units to remove',
// //               //   ),
// //               //   keyboardType: TextInputType.number,
// //               //   validator: (value) {
// //               //     if (value == null || value.isEmpty)
// //               //       return 'Please enter quantity';
// //               //     final quantity = int.tryParse(value);
// //               //     if (quantity == null || quantity <= 0)
// //               //       return 'Please enter valid quantity';
// //               //     if (_adjustmentType == 'reduction' &&
// //               //         widget.product != null) {
// //               //       if (quantity > (widget.product!.totalStockOnHand ?? 0)) {
// //               //         return 'Cannot remove more than available stock';
// //               //       }
// //               //     }
// //               //     return null;
// //               //   },
// //               // ),
// //               CustomMmTextField(
// //                 controller: _quantityController,
// //                 labelText: 'Quantity'.tr(),
// //                 hintText: _adjustmentType == 'addition'
// //                     ? 'Units to add'
// //                     : 'Units to remove',
// //                 keyboardType: TextInputType.number,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 validator: ValidationUtils.quantity,
// //               ),

// //               20.h,

// //               // Unit Cost (only for additions)
// //               if (_adjustmentType == 'addition' ||
// //                   _adjustmentType == 'purchase')
// //                 TextFormField(
// //                   controller: _unitCostController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Unit Cost (OMR)'.tr(),
// //                     border: OutlineInputBorder(),
// //                   ),
// //                   keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                   validator: (value) {
// //                     if (_adjustmentType == 'addition') {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter unit cost';
// //                       }
// //                       final cost = double.tryParse(value);
// //                       if (cost == null || cost <= 0) {
// //                         return 'Please enter valid cost';
// //                       }
// //                     }
// //                     return null;
// //                   },
// //                 ),

// //               if (_adjustmentType == 'addition') 20.h,
// //               // Reason
// //               TextFormField(
// //                 controller: _reasonController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Reason'.tr(),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 maxLines: 2,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter reason';
// //                   }
// //                   return null;
// //                 },
// //               ),

// //               20.h,

// //               // Notes
// //               TextFormField(
// //                 controller: _notesController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Notes (Optional)'.tr(),
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 maxLines: 3,
// //               ),

// //               30.h,

// //               // Submit Button
// //               ElevatedButton(
// //                 onPressed: _isLoading ? null : _submitForm,
// //                 style: ElevatedButton.styleFrom(
// //                   padding: const EdgeInsets.symmetric(vertical: 16),
// //                   backgroundColor: _adjustmentType == 'addition' ||
// //                           _adjustmentType == 'purchase'
// //                       ? Colors.green
// //                       : Colors.orange,
// //                 ),
// //                 child: _isLoading
// //                     ? const CircularProgressIndicator()
// //                     : Text(
// //                         _adjustmentType == 'addition' ||
// //                                 _adjustmentType == 'purchase'
// //                             ? 'Add Stock'.tr()
// //                             : 'Remove Stock'.tr(),
// //                         style: const TextStyle(fontSize: 16),
// //                       ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildProductInfo() {
// //     return Card(
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Product Information',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.grey[700],
// //               ),
// //             ),
// //             10.h,
// //             Text('Name: ${widget.product!.productName}'),
// //             5.h,
// //             Text('Code: ${widget.product!.code}'),
// //             5.h,
// //             Text(
// //                 'Current Stock: ${widget.product!.totalStockOnHand ?? 0} units'),
// //             5.h,
// //             Text(
// //                 'Average Cost: OMR ${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:modern_motors_panel/app_theme.dart';
// import 'package:modern_motors_panel/model/product_models/product_model.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';

// class DirectInventoryAddScreen extends StatefulWidget {
//   final ProductModel? product;
//   final VoidCallback? onBack;
//   const DirectInventoryAddScreen({super.key, this.product, this.onBack});

//   @override
//   State<DirectInventoryAddScreen> createState() =>
//       _DirectInventoryAddScreenState();
// }

// class _DirectInventoryAddScreenState extends State<DirectInventoryAddScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _unitCostController = TextEditingController();
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();

//   String _adjustmentType = 'purchase';
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.product != null) {
//       _unitCostController.text =
//           widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
//     }
//   }

//   @override
//   void dispose() {
//     _quantityController.dispose();
//     _unitCostController.dispose();
//     _reasonController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final quantity = int.parse(_quantityController.text);
//       final unitCost = double.parse(_unitCostController.text);
//       final reason = _reasonController.text;
//       final notes = _notesController.text;
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         return;
//       }
//       final inventoryData = {
//         'productId': widget.product?.id,
//         'quantity': _adjustmentType == 'addition'
//             ? quantity
//             : _adjustmentType == 'purchase'
//             ? quantity
//             : -quantity,
//         'unitCost': unitCost,
//         'adjustmentType': _adjustmentType,
//         'reason': reason,
//         'notes': notes,
//         'adjustedBy': user.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//         'status': 'completed',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'addedBy': user.uid,
//       };

//       await FirebaseFirestore.instance
//           .collection('inventoryAdjustments')
//           .add(inventoryData);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Inventory ${_adjustmentType == 'addition' || _adjustmentType == 'purchase' ? 'added' : 'removed'} successfully',
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//       double q =
//           (_adjustmentType == 'addition' || _adjustmentType == 'purchase')
//           ? quantity.toDouble()
//           : -quantity.toDouble();
//       Navigator.of(context).pop(q);
//       // widget.onBack?.call();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Inventory Management',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             if (widget.product != null)
//               Text(
//                 widget.product!.productName ?? 'Unknown Product',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//           ],
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (widget.product != null) ...[
//                 _buildProductInfoCard(),
//                 const SizedBox(height: 20),
//               ],
//               _buildAdjustmentCard(),
//               const SizedBox(height: 20),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductInfoCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha:0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.inventory_2_outlined,
//                   color: Color(0xFF475569),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Product Information',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildInfoGrid(),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoGrid() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: _buildInfoItem(
//                 'Product Name',
//                 widget.product!.productName ?? 'N/A',
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildInfoItem(
//                 'Product Code',
//                 widget.product!.code ?? 'N/A',
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildInfoItem(
//                 'Current Stock',
//                 '${widget.product!.totalStockOnHand ?? 0} units',
//                 valueColor: _getStockColor(
//                   (widget.product!.totalStockOnHand ?? 0).toInt(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildInfoItem(
//                 'Average Cost',
//                 'OMR ${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoItem(String label, String value, {Color? valueColor}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF64748B),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: valueColor ?? const Color(0xFF1E293B),
//           ),
//         ),
//       ],
//     );
//   }

//   Color _getStockColor(int stock) {
//     if (stock <= 0) return const Color(0xFFDC2626);
//     if (stock <= 10) return const Color(0xFFF59E0B);
//     return const Color(0xFF059669);
//   }

//   Widget _buildAdjustmentCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha:0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.tune,
//                   color: Color(0xFF475569),
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Stock Adjustment',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildAdjustmentTypeSection(),
//           const SizedBox(height: 20),
//           _buildQuantitySection(),
//           if (_adjustmentType == 'addition' ||
//               _adjustmentType == 'purchase') ...[
//             const SizedBox(height: 20),
//             _buildUnitCostSection(),
//           ],
//           const SizedBox(height: 20),
//           _buildReasonSection(),
//           const SizedBox(height: 20),
//           _buildNotesSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdjustmentTypeSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Adjustment Type',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFFD1D5DB)),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: _adjustmentType,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             items: [
//               DropdownMenuItem(
//                 value: 'purchase',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF059669),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Purchase'.tr()),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'addition',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF3B82F6),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Addition'.tr()),
//                   ],
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'reduction',
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFEF4444),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('Stock Reduction'.tr()),
//                   ],
//                 ),
//               ),
//             ],
//             onChanged: (value) {
//               setState(() {
//                 _adjustmentType = value!;
//               });
//             },
//             validator: (value) {
//               if (value == null) return 'Please select adjustment type';
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuantitySection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quantity',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         CustomMmTextField(
//           controller: _quantityController,
//           hintText: _adjustmentType == 'reduction'
//               ? 'Units to remove'
//               : 'Units to add',
//           keyboardType: TextInputType.number,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           validator: ValidationUtils.quantity,
//           //  prefixIcon: const Icon(Icons.numbers, color: Color(0xFF64748B)),
//         ), //,
//       ],
//     );
//   }

//   Widget _buildUnitCostSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Unit Cost (OMR)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _unitCostController,
//           decoration: InputDecoration(
//             hintText: 'Enter unit cost',
//             prefixIcon: const Icon(
//               Icons.attach_money,
//               color: Color(0xFF64748B),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           validator: (value) {
//             if (_adjustmentType == 'addition' ||
//                 _adjustmentType == 'purchase') {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter unit cost';
//               }
//               final cost = double.tryParse(value);
//               if (cost == null || cost <= 0) {
//                 return 'Please enter valid cost';
//               }
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildReasonSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Reason',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _reasonController,
//           decoration: InputDecoration(
//             hintText: 'Enter reason for adjustment',
//             prefixIcon: const Icon(Icons.description, color: Color(0xFF64748B)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           maxLines: 2,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter reason';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildNotesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Notes (Optional)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _notesController,
//           decoration: InputDecoration(
//             hintText: 'Add any additional notes...',
//             prefixIcon: const Icon(Icons.note, color: Color(0xFF64748B)),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//           maxLines: 3,
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : _submitForm,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: _getButtonColor(),
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         elevation: 0,
//       ),
//       child: _isLoading
//           ? const SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//           : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(_getButtonIcon(), size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                   _getButtonText(),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Color _getButtonColor() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return AppTheme.greenColor;
//       case 'addition':
//         return const Color(0xFF3B82F6);
//       case 'reduction':
//         return const Color(0xFFEF4444);
//       default:
//         return const Color(0xFF6B7280);
//     }
//   }

//   IconData _getButtonIcon() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return Icons.shopping_cart;
//       case 'addition':
//         return Icons.add_circle;
//       case 'reduction':
//         return Icons.remove_circle;
//       default:
//         return Icons.check;
//     }
//   }

//   String _getButtonText() {
//     switch (_adjustmentType) {
//       case 'purchase':
//         return 'Record Purchase'.tr();
//       case 'addition':
//         return 'Add Stock'.tr();
//       case 'reduction':
//         return 'Remove Stock'.tr();
//       default:
//         return 'Submit';
//     }
//   }
// }

import 'package:provider/provider.dart';
import '../../provider/resource_provider.dart';

class DirectInventoryAddScreen extends StatefulWidget {
  final ProductModel? product;
  final VoidCallback? onBack;

  const DirectInventoryAddScreen({super.key, this.product, this.onBack});

  @override
  State<DirectInventoryAddScreen> createState() =>
      _DirectInventoryAddScreenState();
}

class _DirectInventoryAddScreenState extends State<DirectInventoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitCostController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _locationTagController = TextEditingController();
  bool isTapped = false;

  String _adjustmentType = 'purchase';
  String? selectBranchId;
  bool _isLoading = false;
  List<String> _locationTags = [];
  final List<String> _selectedTags = [];
  List<BranchModel> branches = [];
  List<String> _filteredTags = [];
  final FocusNode _locationFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _locationFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _unitCostController.text =
          widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
    }
    _loadLocationTags();
    loadBranches();
    _locationFocusNode.addListener(() {
      if (!_locationFocusNode.hasFocus) {
        setState(() {
          isTapped = false; // Hide the dropdown/list
        });
      }
    });
    _locationTagController.addListener(() {
      _filterTags(_locationTagController.text);
      if (_locationFocusNode.hasFocus) {
        _showOverlay();
      }
    });

    _locationFocusNode.addListener(() {
      if (_locationFocusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  void loadBranches() {
    final provider = context.read<MmResourceProvider>();
    branches = provider.branchesList;
  }

  @override
  void dispose() {
    _hideOverlay();
    _quantityController.dispose();
    _unitCostController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    _locationTagController.dispose();
    _locationFocusNode.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
        _locationFieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 6, // Just below the text field
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child:
                _filteredTags.isEmpty && _locationTagController.text.isNotEmpty
                ? _buildAddNewTagOption()
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount:
                        _filteredTags.length +
                        (_locationTagController.text.isNotEmpty &&
                                !_filteredTags.any(
                                  (tag) =>
                                      tag.toLowerCase() ==
                                      _locationTagController.text.toLowerCase(),
                                )
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (index == _filteredTags.length) {
                        return _buildAddNewTagOption();
                      }

                      final tag = _filteredTags[index];
                      return InkWell(
                        onTap: () {
                          debugPrint('sdfsdfsfdfdsfdfs');
                          setState(() {
                            if (!_selectedTags.contains(tag)) {
                              _selectedTags.add(tag);
                            }
                            debugPrint('_selectedTags: $_selectedTags');
                            _locationTagController.clear();
                            _filteredTags = [];
                          });
                          _hideOverlay();
                        },
                        child: ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.pin_drop,
                            size: 18,
                            color: Color(0xFF3B82F6),
                          ),
                          title: Text(
                            tag,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    _hideOverlay(); // prevent double overlays
    if (_filteredTags.isEmpty && _locationTagController.text.isEmpty) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  Future<void> _loadLocationTags() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('locationTags')
          .orderBy('name')
          .get();

      setState(() {
        _locationTags = snapshot.docs
            .map((doc) => doc.data()['name'] as String)
            .toList();
        _filteredTags = _locationTags;
      });
    } catch (e) {
      print('Error loading location tags: $e');
    }
  }

  void _filterTags(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTags = _locationTags;
      } else {
        _filteredTags = _locationTags
            .where((tag) => tag.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _addNewLocationTag(String tagName) async {
    if (tagName.trim().isEmpty) return;

    final trimmedTag = tagName.trim();

    final exists = _locationTags.any(
      (tag) => tag.toLowerCase() == trimmedTag.toLowerCase(),
    );

    if (!exists) {
      try {
        await FirebaseFirestore.instance.collection('locationTags').add({
          'name': trimmedTag,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
        });

        setState(() {
          _locationTags.add(trimmedTag);
          _locationTags.sort();
          _filteredTags = _locationTags;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New location "$trimmedTag" added successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding location: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Combine both typed + selected tags (avoid duplicates)
    final locationTag = _locationTagController.text.trim();
    final List<String> finalTags = [
      ..._selectedTags,
      if (locationTag.isNotEmpty) locationTag,
    ].map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();

    // Add any *new* location tags that don’t exist already
    for (final tag in finalTags) {
      final exists = _locationTags.any(
        (t) => t.toLowerCase() == tag.toLowerCase(),
      );
      if (!exists) {
        await _addNewLocationTag(tag);
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final quantity = int.parse(_quantityController.text);
      final unitCost = double.parse(_unitCostController.text);
      final reason = _reasonController.text;
      final notes = _notesController.text;

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final inventoryData = {
        'productId': widget.product?.id,
        'quantity': _adjustmentType == 'addition'
            ? quantity
            : _adjustmentType == 'purchase'
            ? quantity
            : -quantity,
        'unitCost': unitCost,
        'adjustmentType': _adjustmentType,
        'reason': reason,
        'notes': notes,
        'locationTags': finalTags, // ✅ save as list now
        'adjustedBy': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'addedBy': user.uid,
        'branchId': selectBranchId,
      };

      await FirebaseFirestore.instance
          .collection('inventoryAdjustments')
          .add(inventoryData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inventory ${_adjustmentType == 'addition' || _adjustmentType == 'purchase' ? 'added' : 'removed'} successfully',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      double q =
          (_adjustmentType == 'addition' || _adjustmentType == 'purchase')
          ? quantity.toDouble()
          : -quantity.toDouble();

      Navigator.of(context).pop(q);
    } catch (e, st) {
      debugPrint('SubmitForm Error: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAddNewTagOption() {
    return ListTile(
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.add, size: 18, color: Color(0xFF10B981)),
      ),
      title: Text(
        'Add "${_locationTagController.text}"',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF10B981),
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: const Text(
        'Create new location tag',
        style: TextStyle(fontSize: 11),
      ),
      onTap: () {
        _locationFocusNode.unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            if (widget.product != null)
              Text(
                widget.product!.productName ?? 'Unknown Product',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.product != null) ...[
                _buildProductInfoCard(),
                const SizedBox(height: 20),
              ],
              _buildAdjustmentCard(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF475569),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Product Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Product Name',
                  widget.product!.productName ?? 'N/A',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Product Code',
                  widget.product!.code ?? 'N/A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Current Stock',
                  '${widget.product!.totalStockOnHand ?? 0} units',
                  valueColor: _getStockColor(
                    (widget.product!.totalStockOnHand ?? 0).toInt(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Average Cost',
                  'OMR ${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Color _getStockColor(int stock) {
    if (stock <= 0) return const Color(0xFFDC2626);
    if (stock <= 10) return const Color(0xFFF59E0B);
    return const Color(0xFF059669);
  }

  Widget _buildAdjustmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Color(0xFF475569),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Stock Adjustment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAdjustmentTypeSection(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildQuantitySection()),
              20.w,
              if (_adjustmentType == 'addition' ||
                  _adjustmentType == 'purchase') ...[
                const SizedBox(height: 20),
                Expanded(child: _buildUnitCostSection()),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildLocationSection()),
              20.w,
              Expanded(child: _buildChooseBranch()),
            ],
          ),
          const SizedBox(height: 20),
          _buildReasonSection(),
          const SizedBox(height: 20),
          _buildNotesSection(),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Storage Location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'REQUIRED',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF59E0B),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _locationTagController,
          focusNode: _locationFocusNode,
          onTap: () {
            _filteredTags = _locationTags;
            isTapped = true;
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Search or add new location',
            prefixIcon: _selectedTags.isNotEmpty
                ? Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _selectedTags.map((tag) {
                      return Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() => _selectedTags.remove(tag));
                        },
                      );
                    }).toList(),
                  )
                : null,
            suffixIcon: _locationTagController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                    onPressed: () {
                      setState(() {
                        _locationTagController.clear();
                        _filteredTags = _locationTags;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: (value) {
            // Combine selected tags + current typed value (if any)
            final hasSelectedTags = _selectedTags.isNotEmpty;
            final hasTypedValue = value != null && value.trim().isNotEmpty;

            if (!hasSelectedTags && !hasTypedValue) {
              return 'Please select or enter at least one storage location';
            }

            return null;
          },

          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _filteredTags = [];
              } else {
                _filteredTags = _locationTags
                    .where(
                      (tag) => tag.toLowerCase().contains(value.toLowerCase()),
                    )
                    .toList();
                if (!_locationTags.any(
                  (tag) => tag.toLowerCase() == value.toLowerCase(),
                )) {
                  _filteredTags.add(value);
                }
              }
            });
          },
          onFieldSubmitted: (value) {
            if (value.trim().isNotEmpty && !_selectedTags.contains(value)) {
              setState(() {
                _selectedTags.add(value);
                if (!_locationTags.contains(value)) {
                  _locationTags.add(value);
                }
                _locationTagController.clear();
                _filteredTags = [];
              });
            }
          },
        ),
        const SizedBox(height: 8),
        if (isTapped) ...[
          _filteredTags.isEmpty && _locationTagController.text.isNotEmpty
              ? _buildAddNewTagOption()
              : Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  height: 150,
                  width: context.width,
                  child: ListView.builder(
                    itemCount: _filteredTags.length,
                    itemBuilder: (context, index) {
                      if (index == _filteredTags.length) {
                        return _buildAddNewTagOption();
                      }
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (!_selectedTags.contains(_filteredTags[index])) {
                              _selectedTags.add(_filteredTags[index]);
                            }
                            _locationTagController.clear();
                            _filteredTags = [];
                            isTapped = false;
                          });
                        },
                        child: ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.pin_drop,
                            size: 18,
                            color: Color(0xFF3B82F6),
                          ),
                          title: Text(
                            _filteredTags[index],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
        Text(
          'Type to search existing locations or add a new one',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildAdjustmentTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Adjustment Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: _adjustmentType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: [
              DropdownMenuItem(
                value: 'purchase',
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF059669),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Stock Purchase'.tr()),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'addition',
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Stock Addition'.tr()),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'reduction',
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Stock Reduction'.tr()),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _adjustmentType = value!;
              });
            },
            validator: (value) {
              if (value == null) return 'Please select adjustment type';
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChooseBranch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Branch',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        CustomSearchableDropdown(
          key: UniqueKey(),
          hintText: 'Choose Branch'.tr(),
          value: selectBranchId,
          verticalPadding: 12,
          items: {for (var u in branches) u.id!: u.branchName},
          onChanged: (val) => setState(() {
            selectBranchId = val;
          }),
        ),
      ],
    );
  }

  Widget _buildQuantitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _quantityController,
          decoration: InputDecoration(
            hintText: _adjustmentType == 'reduction'
                ? 'Units to remove'
                : 'Units to add',
            prefixIcon: const Icon(Icons.numbers, color: Color(0xFF64748B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter quantity';
            final quantity = int.tryParse(value);
            if (quantity == null || quantity <= 0) {
              return 'Please enter valid quantity';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUnitCostSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unit Cost (OMR)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _unitCostController,
          decoration: InputDecoration(
            hintText: 'Enter unit cost',
            prefixIcon: const Icon(
              Icons.attach_money,
              color: Color(0xFF64748B),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (_adjustmentType == 'addition' ||
                _adjustmentType == 'purchase') {
              if (value == null || value.isEmpty) {
                return 'Please enter unit cost';
              }
              final cost = double.tryParse(value);
              if (cost == null || cost <= 0) return 'Please enter valid cost';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reason',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _reasonController,
          decoration: InputDecoration(
            hintText: 'Enter reason for adjustment',
            prefixIcon: const Icon(Icons.description, color: Color(0xFF64748B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter reason';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Add any additional notes...',
            prefixIcon: const Icon(Icons.note, color: Color(0xFF64748B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getButtonIcon(), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _getButtonText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getButtonColor() {
    switch (_adjustmentType) {
      case 'purchase':
        return const Color(0xFF059669);
      case 'addition':
        return const Color(0xFF3B82F6);
      case 'reduction':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getButtonIcon() {
    switch (_adjustmentType) {
      case 'purchase':
        return Icons.shopping_cart;
      case 'addition':
        return Icons.add_circle;
      case 'reduction':
        return Icons.remove_circle;
      default:
        return Icons.check;
    }
  }

  String _getButtonText() {
    switch (_adjustmentType) {
      case 'purchase':
        return 'Record Purchase'.tr();
      case 'addition':
        return 'Add Stock'.tr();
      case 'reduction':
        return 'Remove Stock'.tr();
      default:
        return 'Submit';
    }
  }
}

class LocationTagSelector extends StatefulWidget {
  final List<String> allTags;
  final List<String> selectedTags;
  final Function(String) onAddNewTag;
  final Function(String) onSelectTag;
  final Function(String) onSearch;
  final Function(String) onRemoveTag;

  const LocationTagSelector({
    super.key,
    required this.allTags,
    required this.selectedTags,
    required this.onAddNewTag,
    required this.onSelectTag,
    required this.onSearch,
    required this.onRemoveTag,
  });

  @override
  State<LocationTagSelector> createState() => _LocationTagSelectorState();
}

class _LocationTagSelectorState extends State<LocationTagSelector> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _filteredTags = [];

  @override
  void initState() {
    super.initState();
    _filteredTags = List.from(widget.allTags);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _filterTags(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTags = widget.allTags;
      } else {
        _filteredTags = widget.allTags
            .where((tag) => tag.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    widget.onSearch(query);
    _refreshOverlay();
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _refreshOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  if (_filteredTags.isEmpty)
                    ListTile(
                      leading: const Icon(Icons.add, color: Colors.green),
                      title: Text('Add "${_controller.text.trim()}"'),
                      onTap: () {
                        widget.onAddNewTag(_controller.text.trim());
                        _controller.clear();
                        _removeOverlay();
                        _focusNode.unfocus();
                      },
                    )
                  else
                    ..._filteredTags.map(
                      (tag) => ListTile(
                        title: Text(tag),
                        onTap: () {
                          widget.onSelectTag(tag);
                          _controller.clear();
                          _removeOverlay();
                          _focusNode.unfocus();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.selectedTags.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.selectedTags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => widget.onRemoveTag(tag),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _filterTags,
            decoration: InputDecoration(
              hintText: 'Search or add new location',
              prefixIcon: const Icon(
                Icons.location_on,
                color: Color(0xFF64748B),
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                      onPressed: () {
                        setState(() => _controller.clear());
                        _filterTags('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Type to search existing locations or add a new one',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }
}
