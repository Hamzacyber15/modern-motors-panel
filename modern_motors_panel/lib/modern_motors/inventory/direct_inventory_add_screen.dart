// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/form_validation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

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
//         'quantity': _adjustmentType == 'addition'
//             ? quantity
//             : _adjustmentType == 'purchase'
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
//         'addedBy': user.uid
//       };

//       await FirebaseFirestore.instance
//           .collection('inventoryAdjustments')
//           .add(inventoryData);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               'Inventory ${_adjustmentType == 'addition' || _adjustmentType == 'purchase' ? 'added' : 'removed'} successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       double q =
//           (_adjustmentType == 'addition' || _adjustmentType == 'purchase')
//               ? quantity.toDouble()
//               : -quantity.toDouble();
//       Navigator.of(context).pop(q);
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
//         title: Text(widget.product != null
//             ? 'Add Inventory - ${widget.product!.productName}'
//             : 'Add Inventory'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               if (widget.product != null) ...[
//                 _buildProductInfo(),
//                 20.h,
//               ],

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
//               CustomMmTextField(
//                 controller: _quantityController,
//                 labelText: 'Quantity'.tr(),
//                 hintText: _adjustmentType == 'addition'
//                     ? 'Units to add'
//                     : 'Units to remove',
//                 keyboardType: TextInputType.number,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: ValidationUtils.quantity,
//               ),

//               20.h,

//               // Unit Cost (only for additions)
//               if (_adjustmentType == 'addition' ||
//                   _adjustmentType == 'purchase')
//                 TextFormField(
//                   controller: _unitCostController,
//                   decoration: InputDecoration(
//                     labelText: 'Unit Cost (OMR)'.tr(),
//                     border: OutlineInputBorder(),
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
//                   backgroundColor: _adjustmentType == 'addition' ||
//                           _adjustmentType == 'purchase'
//                       ? Colors.green
//                       : Colors.orange,
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : Text(
//                         _adjustmentType == 'addition' ||
//                                 _adjustmentType == 'purchase'
//                             ? 'Add Stock'.tr()
//                             : 'Remove Stock'.tr(),
//                         style: const TextStyle(fontSize: 16),
//                       ),
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
//                 'Current Stock: ${widget.product!.totalStockOnHand ?? 0} units'),
//             5.h,
//             Text(
//                 'Average Cost: OMR ${widget.product!.averageCost?.toStringAsFixed(2) ?? "0.00"}'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';

class DirectInventoryAddScreen extends StatefulWidget {
  final ProductModel? product;

  const DirectInventoryAddScreen({super.key, this.product});

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

  String _adjustmentType = 'purchase';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _unitCostController.text =
          widget.product!.averageCost?.toStringAsFixed(2) ?? '0.00';
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitCostController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

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
        return;
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
        'adjustedBy': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'addedBy': user.uid,
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
    } catch (e) {
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
            color: Colors.black.withOpacity(0.02),
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
          _buildInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
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
            color: Colors.black.withOpacity(0.02),
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
          _buildQuantitySection(),
          if (_adjustmentType == 'addition' ||
              _adjustmentType == 'purchase') ...[
            const SizedBox(height: 20),
            _buildUnitCostSection(),
          ],
          const SizedBox(height: 20),
          _buildReasonSection(),
          const SizedBox(height: 20),
          _buildNotesSection(),
        ],
      ),
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
        CustomMmTextField(
          controller: _quantityController,
          hintText: _adjustmentType == 'reduction'
              ? 'Units to remove'
              : 'Units to add',
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: ValidationUtils.quantity,
          //  prefixIcon: const Icon(Icons.numbers, color: Color(0xFF64748B)),
        ), //,
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
              if (cost == null || cost <= 0) {
                return 'Please enter valid cost';
              }
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
            if (value == null || value.isEmpty) {
              return 'Please enter reason';
            }
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
    return ElevatedButton(
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
    );
  }

  Color _getButtonColor() {
    switch (_adjustmentType) {
      case 'purchase':
        return AppTheme.greenColor;
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
