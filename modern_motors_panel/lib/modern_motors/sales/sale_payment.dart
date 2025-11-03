// // ============================================================================
// // MODEL
// // ============================================================================
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class SalePaymentModel {
//   final String id;
//   final double amount;
//   final Timestamp? createdAt;
//   final String? createdBy;
//   final String? invoice;
//   final String? method;
//   final String? reference;
//   final String? saleId;

//   SalePaymentModel({
//     required this.id,
//     required this.amount,
//     this.createdAt,
//     this.createdBy,
//     this.invoice,
//     this.method,
//     this.reference,
//     this.saleId,
//   });

//   factory SalePaymentModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return SalePaymentModel(
//       id: doc.id,
//       amount: (data['amount'] ?? 0).toDouble(),
//       createdAt: data['createdAt'] as Timestamp?,
//       createdBy: data['createdBy'] as String?,
//       invoice: data['invoice'] as String?,
//       method: data['method'] as String?,
//       reference: data['reference'] as String?,
//       saleId: data['saleId'] as String?,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'amount': amount,
//       'createdAt': createdAt,
//       'createdBy': createdBy,
//       'invoice': invoice,
//       'method': method,
//       'reference': reference,
//       'saleId': saleId,
//     };
//   }
// }

// // ============================================================================
// // SERVICE
// // ============================================================================
// class SalePaymentService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _collection = 'salePayments';

//   Stream<List<SalePaymentModel>> getSalePayments({
//     String? invoiceFilter,
//     String? referenceFilter,
//     String? methodFilter,
//     DateTime? startDate,
//     DateTime? endDate,
//     double? minAmount,
//     double? maxAmount,
//   }) {
//     Query query = _firestore.collection(_collection);

//     // Apply filters
//     if (invoiceFilter != null && invoiceFilter.isNotEmpty) {
//       query = query.where('invoice', isEqualTo: invoiceFilter);
//     }

//     if (referenceFilter != null && referenceFilter.isNotEmpty) {
//       query = query.where('reference', isEqualTo: referenceFilter);
//     }

//     if (methodFilter != null && methodFilter.isNotEmpty) {
//       query = query.where('method', isEqualTo: methodFilter);
//     }

//     // Order by createdAt descending
//     query = query.orderBy('createdAt', descending: true);

//     return query.snapshots().map((snapshot) {
//       var payments = snapshot.docs
//           .map((doc) => SalePaymentModel.fromFirestore(doc))
//           .toList();

//       // Apply client-side filters for date range and amount
//       if (startDate != null) {
//         payments = payments.where((payment) {
//           if (payment.createdAt == null) return false;
//           return payment.createdAt!.toDate().isAfter(startDate) ||
//               payment.createdAt!.toDate().isAtSameMomentAs(startDate);
//         }).toList();
//       }

//       if (endDate != null) {
//         final endOfDay = DateTime(
//           endDate.year,
//           endDate.month,
//           endDate.day,
//           23,
//           59,
//           59,
//         );
//         payments = payments.where((payment) {
//           if (payment.createdAt == null) return false;
//           return payment.createdAt!.toDate().isBefore(endOfDay);
//         }).toList();
//       }

//       if (minAmount != null) {
//         payments = payments
//             .where((payment) => payment.amount >= minAmount)
//             .toList();
//       }

//       if (maxAmount != null) {
//         payments = payments
//             .where((payment) => payment.amount <= maxAmount)
//             .toList();
//       }

//       return payments;
//     });
//   }

//   Future<List<String>> getUniqueMethods() async {
//     final snapshot = await _firestore.collection(_collection).get();
//     final methods = snapshot.docs
//         .map((doc) => doc.data()['method'] as String?)
//         .where((method) => method != null && method.isNotEmpty)
//         .cast<String>() // Add this to cast from String? to String
//         .toSet()
//         .toList();
//     methods.sort();
//     return methods;
//   }
// }

// class SalePaymentsScreen extends StatefulWidget {
//   const SalePaymentsScreen({super.key});

//   @override
//   State<SalePaymentsScreen> createState() => _SalePaymentsScreenState();
// }

// class _SalePaymentsScreenState extends State<SalePaymentsScreen> {
//   final SalePaymentService _service = SalePaymentService();

//   // Filter controllers
//   final TextEditingController _invoiceController = TextEditingController();
//   final TextEditingController _referenceController = TextEditingController();
//   final TextEditingController _minAmountController = TextEditingController();
//   final TextEditingController _maxAmountController = TextEditingController();

//   String? _selectedMethod;
//   DateTime? _startDate;
//   DateTime? _endDate;

//   bool _showFilters = false;

//   @override
//   void dispose() {
//     _invoiceController.dispose();
//     _referenceController.dispose();
//     _minAmountController.dispose();
//     _maxAmountController.dispose();
//     super.dispose();
//   }

//   void _clearFilters() {
//     setState(() {
//       _invoiceController.clear();
//       _referenceController.clear();
//       _minAmountController.clear();
//       _maxAmountController.clear();
//       _selectedMethod = null;
//       _startDate = null;
//       _endDate = null;
//     });
//   }

//   Future<void> _selectDateRange() async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       initialDateRange: _startDate != null && _endDate != null
//           ? DateTimeRange(start: _startDate!, end: _endDate!)
//           : null,
//     );

//     if (picked != null) {
//       setState(() {
//         _startDate = picked.start;
//         _endDate = picked.end;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text('Sale Payments'),
//         actions: [
//           IconButton(
//             icon: Icon(
//               _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
//             ),
//             onPressed: () {
//               setState(() {
//                 _showFilters = !_showFilters;
//               });
//             },
//           ),
//           if (_invoiceController.text.isNotEmpty ||
//               _referenceController.text.isNotEmpty ||
//               _selectedMethod != null ||
//               _startDate != null ||
//               _minAmountController.text.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.clear_all),
//               onPressed: _clearFilters,
//               tooltip: 'Clear Filters',
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filter Section
//           if (_showFilters)
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _invoiceController,
//                           decoration: InputDecoration(
//                             labelText: 'Invoice Number',
//                             prefixIcon: const Icon(Icons.receipt, size: 20),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                           ),
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: TextField(
//                           controller: _referenceController,
//                           decoration: InputDecoration(
//                             labelText: 'Reference',
//                             prefixIcon: const Icon(Icons.tag, size: 20),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                           ),
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: FutureBuilder<List<String>>(
//                           future: _service.getUniqueMethods(),
//                           builder: (context, snapshot) {
//                             final methods = snapshot.data ?? [];
//                             return DropdownButtonFormField<String>(
//                               value: _selectedMethod,
//                               decoration: InputDecoration(
//                                 labelText: 'Payment Method',
//                                 prefixIcon: const Icon(Icons.payment, size: 20),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                               ),
//                               items: [
//                                 const DropdownMenuItem(
//                                   value: null,
//                                   child: Text('All Methods'),
//                                 ),
//                                 ...methods.map(
//                                   (method) => DropdownMenuItem(
//                                     value: method,
//                                     child: Text(method.toUpperCase()),
//                                   ),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedMethod = value;
//                                 });
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: InkWell(
//                           onTap: _selectDateRange,
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               labelText: 'Date Range',
//                               prefixIcon: const Icon(
//                                 Icons.date_range,
//                                 size: 20,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                             ),
//                             child: Text(
//                               _startDate != null && _endDate != null
//                                   ? '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}'
//                                   : 'Select dates',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: _startDate != null
//                                     ? Colors.black87
//                                     : Colors.grey.shade600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _minAmountController,
//                           decoration: InputDecoration(
//                             labelText: 'Min Amount',
//                             prefixIcon: const Icon(
//                               Icons.attach_money,
//                               size: 20,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                           ),
//                           keyboardType: TextInputType.number,
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: TextField(
//                           controller: _maxAmountController,
//                           decoration: InputDecoration(
//                             labelText: 'Max Amount',
//                             prefixIcon: const Icon(
//                               Icons.attach_money,
//                               size: 20,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                           ),
//                           keyboardType: TextInputType.number,
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//           // Payments List
//           Expanded(
//             child: StreamBuilder<List<SalePaymentModel>>(
//               stream: _service.getSalePayments(
//                 invoiceFilter: _invoiceController.text.isEmpty
//                     ? null
//                     : _invoiceController.text,
//                 referenceFilter: _referenceController.text.isEmpty
//                     ? null
//                     : _referenceController.text,
//                 methodFilter: _selectedMethod,
//                 startDate: _startDate,
//                 endDate: _endDate,
//                 minAmount: _minAmountController.text.isEmpty
//                     ? null
//                     : double.tryParse(_minAmountController.text),
//                 maxAmount: _maxAmountController.text.isEmpty
//                     ? null
//                     : double.tryParse(_maxAmountController.text),
//               ),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final payments = snapshot.data!;

//                 if (payments.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.payment_outlined,
//                           size: 64,
//                           color: Colors.grey.shade400,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No payments found',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: payments.length,
//                   itemBuilder: (context, index) {
//                     final payment = payments[index];
//                     return SalePaymentCard(payment: payment);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================================
// // PAYMENT CARD WIDGET
// // ============================================================================
// class SalePaymentCard extends StatelessWidget {
//   final SalePaymentModel payment;

//   const SalePaymentCard({super.key, required this.payment});

//   Color _getMethodColor(String? method) {
//     switch (method?.toLowerCase()) {
//       case 'cash':
//         return Colors.green;
//       case 'card':
//         return Colors.blue;
//       case 'bank':
//         return Colors.purple;
//       case 'cheque':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getMethodIcon(String? method) {
//     switch (method?.toLowerCase()) {
//       case 'cash':
//         return Icons.money;
//       case 'card':
//         return Icons.credit_card;
//       case 'bank':
//         return Icons.account_balance;
//       case 'cheque':
//         return Icons.request_page;
//       default:
//         return Icons.payment;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.05),
//             spreadRadius: 0,
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             // Invoice Badge
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Theme.of(context).primaryColor,
//                     Theme.of(context).primaryColor.withOpacity(0.8),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 'INV-${payment.invoice ?? 'N/A'}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),

//             const SizedBox(width: 16),

//             // Payment Method Icon
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: _getMethodColor(payment.method).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 _getMethodIcon(payment.method),
//                 color: _getMethodColor(payment.method),
//                 size: 24,
//               ),
//             ),

//             const SizedBox(width: 16),

//             // Payment Details
//             Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     (payment.method ?? 'Unknown').toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1a202c),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   if (payment.reference != null &&
//                       payment.reference!.isNotEmpty)
//                     Row(
//                       children: [
//                         Icon(Icons.tag, size: 14, color: Colors.grey.shade600),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Ref: ${payment.reference}',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   if (payment.saleId != null)
//                     Text(
//                       'Sale: ${payment.saleId}',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade500,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                 ],
//               ),
//             ),

//             // Amount
//             Expanded(
//               flex: 1,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     '\$${payment.amount.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF059669),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 6,
//                       vertical: 2,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                     child: const Text(
//                       'PAID',
//                       style: TextStyle(
//                         color: Color(0xFF059669),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 16),

//             // Date & Created By
//             Expanded(
//               flex: 1,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     DateFormat(
//                       'MMM dd, yyyy',
//                     ).format(payment.createdAt?.toDate() ?? DateTime.now()),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade700,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     DateFormat(
//                       'hh:mm a',
//                     ).format(payment.createdAt?.toDate() ?? DateTime.now()),
//                     style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//                   ),
//                   const SizedBox(height: 4),
//                   if (payment.createdBy != null)
//                     MmEmployeeInfoTile(employeeId: payment.createdBy!),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 8),

//             // Action Menu
//             PopupMenuButton<String>(
//               icon: Icon(
//                 Icons.more_vert,
//                 size: 18,
//                 color: Colors.grey.shade600,
//               ),
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'view',
//                   child: Row(
//                     children: [
//                       Icon(Icons.visibility, size: 18, color: Colors.blue),
//                       SizedBox(width: 8),
//                       Text('View Details'),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'print',
//                   child: Row(
//                     children: [
//                       Icon(Icons.print, size: 18, color: Colors.green),
//                       SizedBox(width: 8),
//                       Text('Print Receipt'),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuDivider(),
//                 const PopupMenuItem(
//                   value: 'delete',
//                   child: Row(
//                     children: [
//                       Icon(Icons.delete, size: 18, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('Delete', style: TextStyle(color: Colors.red)),
//                     ],
//                   ),
//                 ),
//               ],
//               onSelected: (value) {
//                 // Handle action
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // EMPLOYEE INFO TILE (Placeholder - replace with your actual implementation)
// // ============================================================================
// class MmEmployeeInfoTile extends StatelessWidget {
//   final String employeeId;

//   const MmEmployeeInfoTile({super.key, required this.employeeId});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'By: ${employeeId.substring(0, 8)}...',
//       style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

// ============================================================================
// MODEL
// ============================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SalePaymentModel {
  final String id;
  final double amount;
  final Timestamp? createdAt;
  final String? createdBy;
  final String? invoice;
  final String? method;
  final String? reference;
  final String? saleId;

  SalePaymentModel({
    required this.id,
    required this.amount,
    this.createdAt,
    this.createdBy,
    this.invoice,
    this.method,
    this.reference,
    this.saleId,
  });

  factory SalePaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SalePaymentModel(
      id: doc.id,
      amount: (data['amount'] ?? 0).toDouble(),
      createdAt: data['createdAt'] as Timestamp?,
      createdBy: data['createdBy'] as String?,
      invoice: data['invoice'] as String?,
      method: data['method'] as String?,
      reference: data['reference'] as String?,
      saleId: data['saleId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'invoice': invoice,
      'method': method,
      'reference': reference,
      'saleId': saleId,
    };
  }
}

// ============================================================================
// SERVICE
// ============================================================================
class SalePaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'salePayments';

  Future<List<SalePaymentModel>> getSalePayments({
    String? invoiceFilter,
    String? referenceFilter,
    String? methodFilter,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    Query query = _firestore.collection(_collection);

    // Apply filters
    if (invoiceFilter != null && invoiceFilter.isNotEmpty) {
      query = query.where('invoice', isEqualTo: invoiceFilter);
    }

    if (referenceFilter != null && referenceFilter.isNotEmpty) {
      query = query.where('reference', isEqualTo: referenceFilter);
    }

    if (methodFilter != null && methodFilter.isNotEmpty) {
      query = query.where('method', isEqualTo: methodFilter);
    }

    // Order by createdAt descending
    query = query.orderBy('createdAt', descending: true);

    final snapshot = await query.get();
    var payments = snapshot.docs
        .map((doc) => SalePaymentModel.fromFirestore(doc))
        .toList();

    // Apply client-side filters for date range and amount
    if (startDate != null) {
      payments = payments.where((payment) {
        if (payment.createdAt == null) return false;
        return payment.createdAt!.toDate().isAfter(startDate) ||
            payment.createdAt!.toDate().isAtSameMomentAs(startDate);
      }).toList();
    }

    if (endDate != null) {
      final endOfDay = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );
      payments = payments.where((payment) {
        if (payment.createdAt == null) return false;
        return payment.createdAt!.toDate().isBefore(endOfDay);
      }).toList();
    }

    if (minAmount != null) {
      payments = payments
          .where((payment) => payment.amount >= minAmount)
          .toList();
    }

    if (maxAmount != null) {
      payments = payments
          .where((payment) => payment.amount <= maxAmount)
          .toList();
    }

    return payments;
  }

  Future<List<String>> getUniqueMethods() async {
    final snapshot = await _firestore.collection(_collection).get();
    final methods = snapshot.docs
        .map((doc) => doc.data()['method'] as String?)
        .where((method) => method != null && method.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    methods.sort();
    return methods;
  }
}

class SalePaymentsScreen extends StatefulWidget {
  const SalePaymentsScreen({super.key});

  @override
  State<SalePaymentsScreen> createState() => _SalePaymentsScreenState();
}

class _SalePaymentsScreenState extends State<SalePaymentsScreen> {
  final SalePaymentService _service = SalePaymentService();

  // Filter controllers
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();

  String? _selectedMethod;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showFilters = false;
  bool _loading = false;
  List<SalePaymentModel> _payments = [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    _referenceController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadPayments() async {
    setState(() {
      _loading = true;
    });

    try {
      final payments = await _service.getSalePayments(
        invoiceFilter: _invoiceController.text.isEmpty
            ? null
            : _invoiceController.text,
        referenceFilter: _referenceController.text.isEmpty
            ? null
            : _referenceController.text,
        methodFilter: _selectedMethod,
        startDate: _startDate,
        endDate: _endDate,
        minAmount: _minAmountController.text.isEmpty
            ? null
            : double.tryParse(_minAmountController.text),
        maxAmount: _maxAmountController.text.isEmpty
            ? null
            : double.tryParse(_maxAmountController.text),
      );

      setState(() {
        _payments = payments;
      });
    } catch (e) {
      // Handle error
      debugPrint('Error loading payments: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _invoiceController.clear();
      _referenceController.clear();
      _minAmountController.clear();
      _maxAmountController.clear();
      _selectedMethod = null;
      _startDate = null;
      _endDate = null;
    });
    _loadPayments();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadPayments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Sale Payments'),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          if (_invoiceController.text.isNotEmpty ||
              _referenceController.text.isNotEmpty ||
              _selectedMethod != null ||
              _startDate != null ||
              _minAmountController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFilters,
              tooltip: 'Clear Filters',
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          if (_showFilters)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _invoiceController,
                          decoration: InputDecoration(
                            labelText: 'Invoice Number',
                            prefixIcon: const Icon(Icons.receipt, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (_) => _loadPayments(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _referenceController,
                          decoration: InputDecoration(
                            labelText: 'Reference',
                            prefixIcon: const Icon(Icons.tag, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (_) => _loadPayments(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<String>>(
                          future: _service.getUniqueMethods(),
                          builder: (context, snapshot) {
                            final methods = snapshot.data ?? [];
                            return DropdownButtonFormField<String>(
                              value: _selectedMethod,
                              decoration: InputDecoration(
                                labelText: 'Payment Method',
                                prefixIcon: const Icon(Icons.payment, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('All Methods'),
                                ),
                                ...methods.map(
                                  (method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(method.toUpperCase()),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedMethod = value;
                                });
                                _loadPayments();
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: _selectDateRange,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date Range',
                              prefixIcon: const Icon(
                                Icons.date_range,
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              _startDate != null && _endDate != null
                                  ? '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}'
                                  : 'Select dates',
                              style: TextStyle(
                                fontSize: 14,
                                color: _startDate != null
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minAmountController,
                          decoration: InputDecoration(
                            labelText: 'Min Amount',
                            prefixIcon: const Icon(
                              Icons.attach_money,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _loadPayments(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _maxAmountController,
                          decoration: InputDecoration(
                            labelText: 'Max Amount',
                            prefixIcon: const Icon(
                              Icons.attach_money,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _loadPayments(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Payments List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _payments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No payments found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _payments.length,
                    itemBuilder: (context, index) {
                      final payment = _payments[index];
                      return SalePaymentCard(payment: payment);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAYMENT CARD WIDGET
// ============================================================================
class SalePaymentCard extends StatelessWidget {
  final SalePaymentModel payment;

  const SalePaymentCard({super.key, required this.payment});

  Color _getMethodColor(String? method) {
    switch (method?.toLowerCase()) {
      case 'cash':
        return Colors.green;
      case 'card':
        return Colors.blue;
      case 'bank':
        return Colors.purple;
      case 'cheque':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getMethodIcon(String? method) {
    switch (method?.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'bank':
        return Icons.account_balance;
      case 'cheque':
        return Icons.request_page;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Invoice Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'MM-${payment.invoice ?? 'N/A'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Payment Method Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getMethodColor(payment.method).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getMethodIcon(payment.method),
                color: _getMethodColor(payment.method),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Payment Details
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (payment.method ?? 'Unknown').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a202c),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (payment.invoice != null && payment.invoice!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.receipt,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Invoice: ${payment.invoice}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  if (payment.reference != null &&
                      payment.reference!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.tag, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Ref: ${payment.reference}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  if (payment.saleId != null)
                    Text(
                      'Sale: ${payment.saleId}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Amount
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\OMR ${payment.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'PAID',
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Date & Created By
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat(
                      'MMM dd, yyyy',
                    ).format(payment.createdAt?.toDate() ?? DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat(
                      'hh:mm a',
                    ).format(payment.createdAt?.toDate() ?? DateTime.now()),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 4),
                  if (payment.createdBy != null)
                    MmEmployeeInfoTile(employeeId: payment.createdBy!),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action Menu
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 18,
                color: Colors.grey.shade600,
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'print',
                  child: Row(
                    children: [
                      Icon(Icons.print, size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Print Receipt'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                // Handle action
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EMPLOYEE INFO TILE (Placeholder - replace with your actual implementation)
// ============================================================================
class MmEmployeeInfoTile extends StatelessWidget {
  final String employeeId;

  const MmEmployeeInfoTile({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Text(
      'By: ${employeeId.substring(0, 8)}...',
      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
    );
  }
}
