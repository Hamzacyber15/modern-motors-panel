import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// // class PurchaseInvoicePDF {
// //   static Future<Uint8List> generate(NewPurchaseModel purchase) async {
// //     final pdf = pw.Document();

// //     // Pre-fetch all async data before building PDF
// //     final supplierName = await _getSupplierName(purchase.supplierId);
// //     final productCosts = _calculateProductCosts(purchase);

// //     pdf.addPage(
// //       pw.Page(
// //         pageFormat: PdfPageFormat.a4,
// //         build: (pw.Context context) {
// //           return pw.Column(
// //             crossAxisAlignment: pw.CrossAxisAlignment.start,
// //             children: [
// //               // Header
// //               _buildHeader(purchase),
// //               pw.SizedBox(height: 20),

// //               // Supplier and Invoice Info
// //               _buildSupplierInfo(purchase, supplierName),
// //               pw.SizedBox(height: 15),

// //               // Items Table
// //               _buildItemsTable(purchase, productCosts),
// //               pw.SizedBox(height: 15),

// //               // Expenses Table (only for same supplier)
// //               _buildExpensesTable(purchase),
// //               pw.SizedBox(height: 15),

// //               // Totals
// //               _buildTotals(purchase),
// //               pw.SizedBox(height: 20),

// //               // Footer
// //               _buildFooter(),
// //             ],
// //           );
// //         },
// //       ),
// //     );

// //     return pdf.save();
// //   }

// //   static pw.Widget _buildHeader(NewPurchaseModel purchase) {
// //     return pw.Row(
// //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
// //       children: [
// //         pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Text(
// //               'PURCHASE INVOICE',
// //               style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
// //             ),
// //             pw.Text(
// //               'Modern Motors',
// //               style: pw.TextStyle(fontSize: 14, color: PdfColors.grey600),
// //             ),
// //           ],
// //         ),
// //         pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.end,
// //           children: [
// //             pw.Text(
// //               'Invoice #: ${purchase.invoice}',
// //               style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
// //             ),
// //             pw.Text(
// //               'Date: ${_formatDate(purchase.createdAt)}',
// //               style: pw.TextStyle(fontSize: 12),
// //             ),
// //             pw.Text(
// //               'Status: ${purchase.status.toUpperCase()}',
// //               style: pw.TextStyle(fontSize: 12),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   static pw.Widget _buildSupplierInfo(
// //     NewPurchaseModel purchase,
// //     String supplierName,
// //   ) {
// //     return pw.Container(
// //       padding: pw.EdgeInsets.all(10),
// //       decoration: pw.BoxDecoration(
// //         border: pw.Border.all(color: PdfColors.grey300),
// //         borderRadius: pw.BorderRadius.circular(5),
// //       ),
// //       child: pw.Row(
// //         crossAxisAlignment: pw.CrossAxisAlignment.start,
// //         children: [
// //           pw.Expanded(
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.start,
// //               children: [
// //                 pw.Text(
// //                   'Supplier Information',
// //                   style: pw.TextStyle(
// //                     fontWeight: pw.FontWeight.bold,
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //                 pw.SizedBox(height: 5),
// //                 pw.Text(
// //                   'Name: $supplierName',
// //                   style: pw.TextStyle(fontSize: 12),
// //                 ),
// //                 pw.Text(
// //                   'Supplier ID: ${purchase.supplierId}',
// //                   style: pw.TextStyle(fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           pw.Expanded(
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.start,
// //               children: [
// //                 pw.Text(
// //                   'Purchase Details',
// //                   style: pw.TextStyle(
// //                     fontWeight: pw.FontWeight.bold,
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //                 pw.SizedBox(height: 5),
// //                 pw.Text(
// //                   'Payment Method: ${purchase.paymentMethod}',
// //                   style: pw.TextStyle(fontSize: 12),
// //                 ),
// //                 pw.Text(
// //                   'Due Date: ${_formatDate(purchase.dueDate)}',
// //                   style: pw.TextStyle(fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   static Map<String, double> _calculateProductCosts(NewPurchaseModel purchase) {
// //     final productCosts = <String, double>{};

// //     // Calculate total expenses to be included in product costs
// //     double totalIncludedExpenses = 0;

// //     // Add expenseData costs if includeInProductCost is true and same supplier
// //     for (final expense in purchase.expenseData) {
// //       if (expense.includeInProductCost &&
// //           expense.supplierId == purchase.supplierId) {
// //         totalIncludedExpenses += expense.amount;
// //       }
// //     }

// //     // Add directExpense costs if includeInCost is true and same supplier
// //     for (final item in purchase.items) {
// //       if (item.directExpense.includeInCost &&
// //           item.directExpense.supplierId == purchase.supplierId) {
// //         totalIncludedExpenses += item.directExpense.amount;
// //       }
// //     }

// //     // Calculate per unit cost for each product
// //     final totalQuantity = purchase.items.fold(
// //       0,
// //       (sum, item) => sum + item.quantity,
// //     );

// //     if (totalQuantity > 0) {
// //       final costPerUnit = totalIncludedExpenses / totalQuantity;

// //       for (final item in purchase.items) {
// //         final originalCost = item.buyingPrice;
// //         final additionalCost = costPerUnit;
// //         productCosts[item.productId] = originalCost + additionalCost;
// //       }
// //     } else {
// //       for (final item in purchase.items) {
// //         productCosts[item.productId] = item.buyingPrice;
// //       }
// //     }

// //     return productCosts;
// //   }

// //   static pw.Widget _buildItemsTable(
// //     NewPurchaseModel purchase,
// //     Map<String, double> productCosts,
// //   ) {
// //     final headers = [
// //       'Item',
// //       'Description',
// //       'Qty',
// //       'Unit Price',
// //       'Discount',
// //       'VAT',
// //       'Subtotal',
// //       'Total',
// //     ];

// //     // Prepare table data
// //     final tableData = <List<String>>[];

// //     for (final item in purchase.items) {
// //       final adjustedUnitPrice = productCosts[item.productId] ?? item.unitPrice;
// //       final discountAmount = _calculateDiscount(
// //         item.unitPrice * item.quantity,
// //         item.discount,
// //         item.discountType,
// //       );
// //       final subtotal = (adjustedUnitPrice * item.quantity) - discountAmount;
// //       final vatAmount = item.vatAmount;
// //       final total = subtotal + vatAmount;

// //       tableData.add([
// //         item.productName, // Using productName directly since we have it
// //         item.productName, // Description - you can modify this as needed
// //         item.quantity.toString(),
// //         _formatCurrency(adjustedUnitPrice),
// //         _formatCurrency(discountAmount),
// //         _formatCurrency(vatAmount),
// //         _formatCurrency(subtotal),
// //         _formatCurrency(total),
// //       ]);
// //     }

// //     return pw.Column(
// //       crossAxisAlignment: pw.CrossAxisAlignment.start,
// //       children: [
// //         pw.Text(
// //           'Products & Services',
// //           style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
// //         ),
// //         pw.SizedBox(height: 10),
// //         pw.TableHelper.fromTextArray(
// //           border: pw.TableBorder.all(color: PdfColors.grey300),
// //           headerStyle: pw.TextStyle(
// //             fontWeight: pw.FontWeight.bold,
// //             fontSize: 10,
// //             color: PdfColors.white,
// //           ),
// //           headerDecoration: pw.BoxDecoration(color: PdfColors.blue700),
// //           cellAlignment: pw.Alignment.centerRight,
// //           cellStyle: pw.TextStyle(fontSize: 9),
// //           headerAlignment: pw.Alignment.center,
// //           rowDecoration: pw.BoxDecoration(
// //             border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200)),
// //           ),
// //           headers: headers,
// //           data: tableData,
// //         ),

// //         // Show included expenses note
// //         if (_hasIncludedExpenses(purchase)) ...[
// //           pw.SizedBox(height: 8),
// //           pw.Container(
// //             padding: pw.EdgeInsets.all(6),
// //             decoration: pw.BoxDecoration(
// //               color: PdfColors.blue50,
// //               border: pw.Border.all(color: PdfColors.blue100),
// //             ),
// //             child: pw.Text(
// //               '* Product costs include additional expenses allocated per unit',
// //               style: pw.TextStyle(
// //                 fontSize: 8,
// //                 color: PdfColors.blue800,
// //                 fontStyle: pw.FontStyle.italic,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ],
// //     );
// //   }

// //   static pw.Widget _buildExpensesTable(NewPurchaseModel purchase) {
// //     // Filter expenses that should be shown as separate rows
// //     final visibleExpenses = purchase.expenseData.where((expense) {
// //       return expense.supplierId == purchase.supplierId &&
// //           !expense.includeInProductCost;
// //     }).toList();

// //     if (visibleExpenses.isEmpty) {
// //       return pw.SizedBox.shrink();
// //     }

// //     final headers = ['Type', 'Description', 'Amount', 'VAT', 'Total'];

// //     // Prepare table data
// //     final tableData = visibleExpenses.map((expense) {
// //       final total = expense.amount + expense.vatAmount;
// //       return [
// //         expense.typeName,
// //         expense.description.isNotEmpty ? expense.description : '-',
// //         _formatCurrency(expense.amount),
// //         _formatCurrency(expense.vatAmount),
// //         _formatCurrency(total),
// //       ];
// //     }).toList();

// //     return pw.Column(
// //       crossAxisAlignment: pw.CrossAxisAlignment.start,
// //       children: [
// //         pw.Text(
// //           'Additional Expenses',
// //           style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
// //         ),
// //         pw.SizedBox(height: 10),
// //         pw.TableHelper.fromTextArray(
// //           border: pw.TableBorder.all(color: PdfColors.grey300),
// //           headerStyle: pw.TextStyle(
// //             fontWeight: pw.FontWeight.bold,
// //             fontSize: 10,
// //             color: PdfColors.white,
// //           ),
// //           headerDecoration: pw.BoxDecoration(color: PdfColors.green700),
// //           cellAlignment: pw.Alignment.centerRight,
// //           cellStyle: pw.TextStyle(fontSize: 9),
// //           headerAlignment: pw.Alignment.center,
// //           rowDecoration: pw.BoxDecoration(
// //             border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200)),
// //           ),
// //           headers: headers,
// //           data: tableData,
// //         ),
// //       ],
// //     );
// //   }

// //   static pw.Widget _buildTotals(NewPurchaseModel purchase) {
// //     final productCosts = _calculateProductCosts(purchase);

// //     // Calculate items totals with adjusted prices
// //     double itemsSubtotal = 0;
// //     double itemsVatTotal = 0;

// //     for (final item in purchase.items) {
// //       final adjustedUnitPrice = productCosts[item.productId] ?? item.unitPrice;
// //       final discountAmount = _calculateDiscount(
// //         adjustedUnitPrice * item.quantity,
// //         item.discount,
// //         item.discountType,
// //       );
// //       final subtotal = (adjustedUnitPrice * item.quantity) - discountAmount;

// //       itemsSubtotal += subtotal;
// //       itemsVatTotal += item.vatAmount;
// //     }

// //     final visibleExpenses = purchase.expenseData.where((expense) {
// //       return expense.supplierId == purchase.supplierId &&
// //           !expense.includeInProductCost;
// //     }).toList();

// //     final expensesSubtotal = visibleExpenses.fold(
// //       0.0,
// //       (sum, expense) => sum + expense.amount,
// //     );
// //     final expensesVatTotal = visibleExpenses.fold(
// //       0.0,
// //       (sum, expense) => sum + expense.vatAmount,
// //     );

// //     final grandSubtotal = itemsSubtotal + expensesSubtotal;
// //     final grandVatTotal = itemsVatTotal + expensesVatTotal;
// //     final grandTotal = grandSubtotal + grandVatTotal;

// //     return pw.Container(
// //       padding: pw.EdgeInsets.all(10),
// //       decoration: pw.BoxDecoration(
// //         border: pw.Border.all(color: PdfColors.grey300),
// //         borderRadius: pw.BorderRadius.circular(5),
// //       ),
// //       child: pw.Row(
// //         mainAxisAlignment: pw.MainAxisAlignment.end,
// //         children: [
// //           pw.Column(
// //             crossAxisAlignment: pw.CrossAxisAlignment.end,
// //             children: [
// //               _buildTotalRow('Items Subtotal:', itemsSubtotal),
// //               _buildTotalRow('Items VAT:', itemsVatTotal),
// //               if (expensesSubtotal > 0)
// //                 _buildTotalRow('Expenses Subtotal:', expensesSubtotal),
// //               if (expensesVatTotal > 0)
// //                 _buildTotalRow('Expenses VAT:', expensesVatTotal),
// //               pw.Divider(),
// //               _buildTotalRow('Grand Subtotal:', grandSubtotal, isBold: true),
// //               _buildTotalRow('Total VAT:', grandVatTotal, isBold: true),
// //               _buildTotalRow(
// //                 'GRAND TOTAL:',
// //                 grandTotal,
// //                 isBold: true,
// //                 isTotal: true,
// //               ),
// //               pw.SizedBox(height: 10),
// //               _buildTotalRow('Total Paid:', purchase.paymentData.totalPaid),
// //               _buildTotalRow(
// //                 'Remaining Due:',
// //                 purchase.paymentData.remainingAmount,
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   static pw.Widget _buildTotalRow(
// //     String label,
// //     double amount, {
// //     bool isBold = false,
// //     bool isTotal = false,
// //   }) {
// //     return pw.Container(
// //       width: 200,
// //       child: pw.Row(
// //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
// //         children: [
// //           pw.Text(
// //             label,
// //             style: pw.TextStyle(
// //               fontSize: 10,
// //               fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
// //             ),
// //           ),
// //           pw.Text(
// //             _formatCurrency(amount),
// //             style: pw.TextStyle(
// //               fontSize: isTotal ? 12 : 10,
// //               fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
// //               color: isTotal ? PdfColors.blue700 : PdfColors.black,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   static pw.Widget _buildFooter() {
// //     return pw.Container(
// //       padding: pw.EdgeInsets.all(10),
// //       decoration: pw.BoxDecoration(
// //         border: pw.Border.all(color: PdfColors.grey300),
// //         borderRadius: pw.BorderRadius.circular(5),
// //       ),
// //       child: pw.Column(
// //         children: [
// //           pw.Text(
// //             'Terms & Conditions',
// //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
// //           ),
// //           pw.SizedBox(height: 5),
// //           pw.Text(
// //             '• Payment due within 30 days\n• Late payments subject to interest\n• Goods remain property until paid in full',
// //             style: pw.TextStyle(fontSize: 9),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Helper methods
// //   static double _calculateDiscount(
// //     double amount,
// //     double discount,
// //     String discountType,
// //   ) {
// //     if (discountType == 'percentage') {
// //       return amount * (discount / 100);
// //     } else {
// //       return discount;
// //     }
// //   }

// //   static String _formatCurrency(double amount) {
// //     return 'OMR ${amount.toStringAsFixed(2)}';
// //   }

// //   static String _formatDate(DateTime date) {
// //     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
// //   }

// //   static bool _hasIncludedExpenses(NewPurchaseModel purchase) {
// //     final hasExpenseData = purchase.expenseData.any(
// //       (expense) =>
// //           expense.includeInProductCost &&
// //           expense.supplierId == purchase.supplierId,
// //     );

// //     final hasDirectExpense = purchase.items.any(
// //       (item) =>
// //           item.directExpense.includeInCost &&
// //           item.directExpense.supplierId == purchase.supplierId,
// //     );

// //     return hasExpenseData || hasDirectExpense;
// //   }

// //   static Future<String> _getSupplierName(String supplierId) async {
// //     try {
// //       final doc = await FirebaseFirestore.instance
// //           .collection('suppliers')
// //           .doc(supplierId)
// //           .get();
// //       return doc.data()?['name'] ?? 'Unknown Supplier';
// //     } catch (e) {
// //       return 'Supplier Loading Failed';
// //     }
// //   }
// // }

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class PurchaseInvoicePDF {
//   static Future<Uint8List> generate(NewPurchaseModel purchase) async {
//     final pdf = pw.Document();

//     // Pre-fetch all async data before building PDF
//     final supplierName = await _getSupplierName(purchase.supplierId);
//     final productCosts = _calculateProductCosts(purchase);

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: pw.EdgeInsets.all(20),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Header
//               _buildHeader(purchase),
//               pw.SizedBox(height: 25),

//               // Supplier and Invoice Info
//               _buildSupplierInfo(purchase, supplierName),
//               pw.SizedBox(height: 20),

//               // Items Table
//               _buildItemsTable(purchase, productCosts),
//               pw.SizedBox(height: 15),

//               // Expenses Table (only for same supplier)
//               _buildExpensesTable(purchase),
//               pw.SizedBox(height: 20),

//               // Totals
//               _buildTotals(purchase, productCosts),
//               pw.SizedBox(height: 25),

//               // Footer
//               _buildFooter(),
//             ],
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   static pw.Widget _buildHeader(NewPurchaseModel purchase) {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       children: [
//         pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'PURCHASE INVOICE',
//               style: pw.TextStyle(
//                 fontSize: 28,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.blue800,
//               ),
//             ),
//             pw.SizedBox(height: 5),
//             pw.Text(
//               'Modern Motors',
//               style: pw.TextStyle(
//                 fontSize: 16,
//                 color: PdfColors.grey600,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//             pw.Text(
//               'Your Trusted Automotive Partner',
//               style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
//             ),
//           ],
//         ),
//         pw.Container(
//           padding: pw.EdgeInsets.all(12),
//           decoration: pw.BoxDecoration(
//             border: pw.Border.all(color: PdfColors.blue700, width: 2),
//             borderRadius: pw.BorderRadius.circular(8),
//           ),
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.end,
//             children: [
//               pw.Text(
//                 'INVOICE #${purchase.invoice}',
//                 style: pw.TextStyle(
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColors.blue700,
//                 ),
//               ),
//               pw.SizedBox(height: 4),
//               pw.Text(
//                 'Date: ${_formatDate(purchase.createdAt)}',
//                 style: pw.TextStyle(fontSize: 11),
//               ),
//               pw.Text(
//                 'Status: ${purchase.status.toUpperCase()}',
//                 style: pw.TextStyle(
//                   fontSize: 11,
//                   color: _getStatusColor(purchase.status),
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   static pw.Widget _buildSupplierInfo(
//     NewPurchaseModel purchase,
//     String supplierName,
//   ) {
//     return pw.Container(
//       width: double.infinity,
//       padding: pw.EdgeInsets.all(15),
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.grey400),
//         borderRadius: pw.BorderRadius.circular(8),
//         color: PdfColors.grey50,
//       ),
//       child: pw.Row(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Expanded(
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   'SUPPLIER INFORMATION',
//                   style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     fontSize: 14,
//                     color: PdfColors.blue700,
//                   ),
//                 ),
//                 pw.SizedBox(height: 8),
//                 pw.Text(
//                   'Name: $supplierName',
//                   style: pw.TextStyle(
//                     fontSize: 12,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 // pw.Text(
//                 //   'Supplier ID: ${purchase.supplierId}',
//                 //   style: pw.TextStyle(fontSize: 11),
//                 // ),
//               ],
//             ),
//           ),
//           pw.Expanded(
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   'PURCHASE DETAILS',
//                   style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     fontSize: 14,
//                     color: PdfColors.blue700,
//                   ),
//                 ),
//                 pw.SizedBox(height: 8),
//                 pw.Text(
//                   'Payment Method: ${purchase.paymentMethod.toUpperCase()}',
//                   style: pw.TextStyle(
//                     fontSize: 12,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.Text(
//                   'Due Date: ${_formatDate(purchase.dueDate)}',
//                   style: pw.TextStyle(fontSize: 11),
//                 ),
//                 pw.Text(
//                   'Created By: ${purchase.createdBy}',
//                   style: pw.TextStyle(fontSize: 11),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static Map<String, double> _calculateProductCosts(NewPurchaseModel purchase) {
//     final productCosts = <String, double>{};

//     // Calculate total expenses to be included in product costs
//     double totalIncludedExpenses = 0;

//     // Add expenseData costs if includeInProductCost is true and same supplier
//     for (final expense in purchase.expenseData) {
//       if (expense.includeInProductCost &&
//           expense.supplierId == purchase.supplierId) {
//         totalIncludedExpenses += expense.amount;
//       }
//     }

//     // Add directExpense costs if includeInCost is true and same supplier
//     for (final item in purchase.items) {
//       if (item.directExpense.includeInCost &&
//           item.directExpense.supplierId == purchase.supplierId) {
//         totalIncludedExpenses += item.directExpense.amount;
//       }
//     }

//     // Calculate per unit cost for each product
//     final totalQuantity = purchase.items.fold(
//       0,
//       (sum, item) => sum + item.quantity,
//     );

//     if (totalQuantity > 0) {
//       final costPerUnit = totalIncludedExpenses / totalQuantity;

//       for (final item in purchase.items) {
//         final originalCost = item.buyingPrice;
//         final additionalCost = costPerUnit;
//         productCosts[item.productId] = originalCost + additionalCost;
//       }
//     } else {
//       for (final item in purchase.items) {
//         productCosts[item.productId] = item.buyingPrice;
//       }
//     }

//     return productCosts;
//   }

//   static pw.Widget _buildItemsTable(
//     NewPurchaseModel purchase,
//     Map<String, double> productCosts,
//   ) {
//     final headers = [
//       'Item',
//       'Description',
//       'Qty',
//       'Unit Price',
//       'Discount',
//       'VAT',
//       'Subtotal',
//       'Total',
//     ];

//     final tableData = <List<pw.Widget>>[];

//     for (final item in purchase.items) {
//       final adjustedUnitPrice = productCosts[item.productId] ?? item.unitPrice;
//       final discountAmount = _calculateDiscount(
//         item.unitPrice * item.quantity,
//         item.discount,
//         item.discountType,
//       );
//       final subtotal = (adjustedUnitPrice * item.quantity) - discountAmount;
//       final vatAmount = item.vatAmount;
//       final total = subtotal + vatAmount;

//       tableData.add([
//         pw.Text(item.productName, style: pw.TextStyle(fontSize: 9)),
//         pw.Text(item.productName, style: pw.TextStyle(fontSize: 9)),
//         pw.Text(item.quantity.toString(), style: pw.TextStyle(fontSize: 9)),
//         pw.Text(
//           _formatCurrency(adjustedUnitPrice),
//           style: pw.TextStyle(fontSize: 9),
//         ),
//         pw.Text(
//           _formatCurrency(discountAmount),
//           style: pw.TextStyle(fontSize: 9),
//         ),
//         pw.Text(_formatCurrency(vatAmount), style: pw.TextStyle(fontSize: 9)),
//         pw.Text(_formatCurrency(subtotal), style: pw.TextStyle(fontSize: 9)),
//         pw.Text(
//           _formatCurrency(total),
//           style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//         ),
//       ]);
//     }

//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'PRODUCTS & SERVICES',
//           style: pw.TextStyle(
//             fontWeight: pw.FontWeight.bold,
//             fontSize: 16,
//             color: PdfColors.blue700,
//           ),
//         ),
//         pw.SizedBox(height: 12),
//         pw.Table(
//           border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
//           columnWidths: {
//             0: pw.FlexColumnWidth(2),
//             1: pw.FlexColumnWidth(2),
//             2: pw.FlexColumnWidth(1),
//             3: pw.FlexColumnWidth(1.5),
//             4: pw.FlexColumnWidth(1.5),
//             5: pw.FlexColumnWidth(1.5),
//             6: pw.FlexColumnWidth(1.5),
//             7: pw.FlexColumnWidth(1.5),
//           },
//           children: [
//             // Header row
//             pw.TableRow(
//               decoration: pw.BoxDecoration(color: PdfColors.blue700),
//               children: headers
//                   .map(
//                     (header) => pw.Padding(
//                       padding: pw.EdgeInsets.all(8),
//                       child: pw.Text(
//                         header,
//                         style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontSize: 10,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                         textAlign: pw.TextAlign.center,
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//             // Data rows
//             ...tableData.map(
//               (row) => pw.TableRow(
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border(
//                     bottom: pw.BorderSide(color: PdfColors.grey300),
//                   ),
//                 ),
//                 children: row
//                     .map(
//                       (cell) => pw.Padding(
//                         padding: pw.EdgeInsets.all(6),
//                         child: cell,
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),

//         if (_hasIncludedExpenses(purchase)) ...[
//           pw.SizedBox(height: 10),
//           pw.Container(
//             padding: pw.EdgeInsets.all(8),
//             decoration: pw.BoxDecoration(
//               color: PdfColors.blue50,
//               border: pw.Border.all(color: PdfColors.blue200),
//               borderRadius: pw.BorderRadius.circular(4),
//             ),
//             child: pw.Row(
//               children: [
//                 //pw.Icon(pw.Icons.info, size: 10, color: PdfColors.blue700),
//                 pw.SizedBox(width: 6),
//                 pw.Expanded(
//                   child: pw.Text(
//                     'Note: Product costs include additional expenses allocated per unit',
//                     style: pw.TextStyle(
//                       fontSize: 9,
//                       color: PdfColors.blue800,
//                       fontStyle: pw.FontStyle.italic,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   static pw.Widget _buildExpensesTable(NewPurchaseModel purchase) {
//     // Filter expenses that should be shown as separate rows
//     final visibleExpenses = purchase.expenseData.where((expense) {
//       return expense.supplierId == purchase.supplierId &&
//           !expense.includeInProductCost;
//     }).toList();

//     if (visibleExpenses.isEmpty) {
//       return pw.SizedBox.shrink();
//     }

//     final headers = ['Type', 'Description', 'Amount', 'VAT', 'Total'];

//     final tableData = <List<pw.Widget>>[];

//     for (final expense in visibleExpenses) {
//       final total = expense.amount + expense.vatAmount;
//       tableData.add([
//         pw.Text(expense.typeName, style: pw.TextStyle(fontSize: 9)),
//         pw.Text(
//           expense.description.isNotEmpty ? expense.description : '-',
//           style: pw.TextStyle(fontSize: 9),
//         ),
//         pw.Text(
//           _formatCurrency(expense.amount),
//           style: pw.TextStyle(fontSize: 9),
//         ),
//         pw.Text(
//           _formatCurrency(expense.vatAmount),
//           style: pw.TextStyle(fontSize: 9),
//         ),
//         pw.Text(
//           _formatCurrency(total),
//           style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//         ),
//       ]);
//     }

//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'ADDITIONAL EXPENSES',
//           style: pw.TextStyle(
//             fontWeight: pw.FontWeight.bold,
//             fontSize: 16,
//             color: PdfColors.green700,
//           ),
//         ),
//         pw.SizedBox(height: 12),
//         pw.Table(
//           border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
//           columnWidths: {
//             0: pw.FlexColumnWidth(1.5),
//             1: pw.FlexColumnWidth(2.5),
//             2: pw.FlexColumnWidth(1.5),
//             3: pw.FlexColumnWidth(1.5),
//             4: pw.FlexColumnWidth(1.5),
//           },
//           children: [
//             // Header row
//             pw.TableRow(
//               decoration: pw.BoxDecoration(color: PdfColors.green700),
//               children: headers
//                   .map(
//                     (header) => pw.Padding(
//                       padding: pw.EdgeInsets.all(8),
//                       child: pw.Text(
//                         header,
//                         style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontSize: 10,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                         textAlign: pw.TextAlign.center,
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//             // Data rows
//             ...tableData.map(
//               (row) => pw.TableRow(
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border(
//                     bottom: pw.BorderSide(color: PdfColors.grey300),
//                   ),
//                 ),
//                 children: row
//                     .map(
//                       (cell) => pw.Padding(
//                         padding: pw.EdgeInsets.all(6),
//                         child: cell,
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   static pw.Widget _buildTotals(
//     NewPurchaseModel purchase,
//     Map<String, double> productCosts,
//   ) {
//     // Calculate items totals with adjusted prices
//     double itemsSubtotal = 0;
//     double itemsVatTotal = 0;

//     for (final item in purchase.items) {
//       final adjustedUnitPrice = productCosts[item.productId] ?? item.unitPrice;
//       final discountAmount = _calculateDiscount(
//         adjustedUnitPrice * item.quantity,
//         item.discount,
//         item.discountType,
//       );
//       final subtotal = (adjustedUnitPrice * item.quantity) - discountAmount;

//       itemsSubtotal += subtotal;
//       itemsVatTotal += item.vatAmount;
//     }

//     final visibleExpenses = purchase.expenseData.where((expense) {
//       return expense.supplierId == purchase.supplierId &&
//           !expense.includeInProductCost;
//     }).toList();

//     final expensesSubtotal = visibleExpenses.fold(
//       0.0,
//       (sum, expense) => sum + expense.amount,
//     );
//     final expensesVatTotal = visibleExpenses.fold(
//       0.0,
//       (sum, expense) => sum + expense.vatAmount,
//     );

//     final grandSubtotal = itemsSubtotal + expensesSubtotal;
//     final grandVatTotal = itemsVatTotal + expensesVatTotal;
//     final grandTotal = grandSubtotal + grandVatTotal;

//     return pw.Container(
//       width: double.infinity,
//       padding: pw.EdgeInsets.all(15),
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.grey400),
//         borderRadius: pw.BorderRadius.circular(8),
//         color: PdfColors.grey50,
//       ),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.end,
//         children: [
//           pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.end,
//             children: [
//               _buildTotalRow('Items Subtotal:', itemsSubtotal),
//               _buildTotalRow('Items VAT:', itemsVatTotal),
//               if (expensesSubtotal > 0)
//                 _buildTotalRow('Expenses Subtotal:', expensesSubtotal),
//               if (expensesVatTotal > 0)
//                 _buildTotalRow('Expenses VAT:', expensesVatTotal),
//               pw.SizedBox(height: 8),
//               pw.Divider(color: PdfColors.grey400, thickness: 1),
//               pw.SizedBox(height: 8),
//               _buildTotalRow('Grand Subtotal:', grandSubtotal, isBold: true),
//               _buildTotalRow('Total VAT:', grandVatTotal, isBold: true),
//               pw.SizedBox(height: 8),
//               _buildTotalRow(
//                 'GRAND TOTAL:',
//                 grandTotal,
//                 isBold: true,
//                 isTotal: true,
//               ),
//               pw.SizedBox(height: 12),
//               pw.Container(
//                 width: 250,
//                 padding: pw.EdgeInsets.all(8),
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(color: PdfColors.blue300),
//                   borderRadius: pw.BorderRadius.circular(4),
//                   color: PdfColors.blue50,
//                 ),
//                 child: pw.Column(
//                   children: [
//                     _buildTotalRow(
//                       'Total Paid:',
//                       purchase.paymentData.totalPaid,
//                     ),
//                     _buildTotalRow(
//                       'Remaining Due:',
//                       purchase.paymentData.remainingAmount,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   static pw.Widget _buildTotalRow(
//     String label,
//     double amount, {
//     bool isBold = false,
//     bool isTotal = false,
//   }) {
//     return pw.Container(
//       width: 250,
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(
//             label,
//             style: pw.TextStyle(
//               fontSize: isTotal ? 12 : 10,
//               fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
//               color: isTotal ? PdfColors.blue800 : PdfColors.black,
//             ),
//           ),
//           pw.Text(
//             _formatCurrency(amount),
//             style: pw.TextStyle(
//               fontSize: isTotal ? 14 : 10,
//               fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
//               color: isTotal ? PdfColors.blue700 : PdfColors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static pw.Widget _buildFooter() {
//     return pw.Container(
//       width: double.infinity,
//       padding: pw.EdgeInsets.all(12),
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.grey400),
//         borderRadius: pw.BorderRadius.circular(6),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'TERMS & CONDITIONS',
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//               fontSize: 12,
//               color: PdfColors.blue700,
//             ),
//           ),
//           pw.SizedBox(height: 6),
//           pw.Text(
//             '• Payment due within 30 days of invoice date\n'
//             '• Late payments subject to 1.5% monthly interest\n'
//             '• Goods remain company property until paid in full\n'
//             '• Returns accepted within 7 days with original receipt\n'
//             '• All disputes subject to local jurisdiction',
//             style: pw.TextStyle(fontSize: 9),
//           ),
//           pw.SizedBox(height: 8),
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'Thank you for your business!',
//                     style: pw.TextStyle(
//                       fontSize: 10,
//                       fontWeight: pw.FontWeight.bold,
//                       color: PdfColors.blue700,
//                     ),
//                   ),
//                   pw.Text(
//                     'Modern Motors - Quality Automotive Solutions',
//                     style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
//                   ),
//                 ],
//               ),
//               pw.Text(
//                 'Generated on: ${_formatDate(DateTime.now())}',
//                 style: pw.TextStyle(
//                   fontSize: 8,
//                   color: PdfColors.grey500,
//                   fontStyle: pw.FontStyle.italic,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper methods
//   static double _calculateDiscount(
//     double amount,
//     double discount,
//     String discountType,
//   ) {
//     if (discountType == 'percentage') {
//       return amount * (discount / 100);
//     } else {
//       return discount;
//     }
//   }

//   static String _formatCurrency(double amount) {
//     return 'OMR ${amount.toStringAsFixed(2)}';
//   }

//   static String _formatDate(DateTime date) {
//     return DateFormat('dd/MM/yyyy').format(date);
//   }

//   static bool _hasIncludedExpenses(NewPurchaseModel purchase) {
//     final hasExpenseData = purchase.expenseData.any(
//       (expense) =>
//           expense.includeInProductCost &&
//           expense.supplierId == purchase.supplierId,
//     );

//     final hasDirectExpense = purchase.items.any(
//       (item) =>
//           item.directExpense.includeInCost &&
//           item.directExpense.supplierId == purchase.supplierId,
//     );

//     return hasExpenseData || hasDirectExpense;
//   }

//   static Future<String> _getSupplierName(String supplierId) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('suppliers')
//           .doc(supplierId)
//           .get();
//       return doc.data()?['supplierName'] ?? 'Unknown Supplier';
//     } catch (e) {
//       return 'Supplier Loading Failed';
//     }
//   }

//   static PdfColor _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'paid':
//       case 'completed':
//       case 'save':
//         return PdfColors.green;
//       case 'pending':
//         return PdfColors.orange;
//       case 'cancelled':
//         return PdfColors.red;
//       case 'draft':
//         return PdfColors.grey;
//       default:
//         return PdfColors.blue;
//     }
//   }
// }

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PurchaseInvoicePDF {
  static Future<Uint8List> generate(NewPurchaseModel purchase) async {
    final pdf = pw.Document();

    // Pre-fetch all async data before building PDF
    final supplierName = await _getSupplierName(purchase.supplierId);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(purchase),
              pw.SizedBox(height: 25),

              // Supplier and Invoice Info
              _buildSupplierInfo(purchase, supplierName),
              pw.SizedBox(height: 20),

              // Products Table
              _buildProductsTable(purchase),
              pw.SizedBox(height: 15),

              // Direct Expenses Table
              _buildDirectExpensesTable(purchase),
              pw.SizedBox(height: 15),

              // Other Expenses Table
              _buildOtherExpensesTable(purchase),
              pw.SizedBox(height: 20),

              // Totals
              _buildTotals(purchase),
              pw.SizedBox(height: 25),

              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(NewPurchaseModel purchase) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'PURCHASE INVOICE',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Modern Motors',
              style: pw.TextStyle(
                fontSize: 16,
                color: PdfColors.grey600,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.Container(
          padding: pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.blue700, width: 2),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'INVOICE #${purchase.invoice}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Date: ${_formatDate(purchase.createdAt)}',
                style: pw.TextStyle(fontSize: 11),
              ),
              pw.Text(
                'Status: ${purchase.status.toUpperCase()}',
                style: pw.TextStyle(
                  fontSize: 11,
                  color: _getStatusColor(purchase.status),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSupplierInfo(
    NewPurchaseModel purchase,
    String supplierName,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'SUPPLIER INFORMATION',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    color: PdfColors.blue700,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Name: $supplierName',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Supplier ID: ${purchase.supplierId}',
                  style: pw.TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'PURCHASE DETAILS',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    color: PdfColors.blue700,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Payment Method: ${purchase.paymentMethod.toUpperCase()}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Due Date: ${_formatDate(purchase.dueDate)}',
                  style: pw.TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildProductsTable(NewPurchaseModel purchase) {
    final headers = [
      'Product',
      'Description',
      'Qty',
      'Unit Price',
      'Discount',
      'VAT',
      'Subtotal',
      'Total',
    ];

    final tableData = <List<pw.Widget>>[];

    for (final item in purchase.items) {
      final discountAmount = _calculateDiscount(
        item.unitPrice * item.quantity,
        item.discount,
        item.discountType,
      );
      final subtotal = (item.unitPrice * item.quantity) - discountAmount;
      final total = subtotal + item.vatAmount;

      tableData.add([
        pw.Text(item.productName, style: pw.TextStyle(fontSize: 9)),
        pw.Text(item.productName, style: pw.TextStyle(fontSize: 9)),
        pw.Text(item.quantity.toString(), style: pw.TextStyle(fontSize: 9)),
        pw.Text(
          _formatCurrency(item.unitPrice),
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          _formatCurrency(discountAmount),
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          _formatCurrency(item.vatAmount),
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(_formatCurrency(subtotal), style: pw.TextStyle(fontSize: 9)),
        pw.Text(
          _formatCurrency(total),
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ]);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PRODUCTS',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 16,
            color: PdfColors.blue700,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(1),
            3: pw.FlexColumnWidth(1.5),
            4: pw.FlexColumnWidth(1.5),
            5: pw.FlexColumnWidth(1.5),
            6: pw.FlexColumnWidth(1.5),
            7: pw.FlexColumnWidth(1.5),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue700),
              children: headers
                  .map(
                    (header) => pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Data rows
            ...tableData.map(
              (row) => pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                children: row
                    .map(
                      (cell) => pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: cell,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildDirectExpensesTable(NewPurchaseModel purchase) {
    // Get direct expenses from items (same supplier only)
    final directExpenses = <Map<String, dynamic>>[];

    for (final item in purchase.items) {
      if (item.directExpense.amount > 0 &&
          item.directExpense.supplierId == purchase.supplierId) {
        directExpenses.add({
          'productName': item.productName,
          'type': item.directExpense.type.isNotEmpty
              ? item.directExpense.type
              : 'Direct Expense',
          'description': 'Direct expense for ${item.productName}',
          'amount': item.directExpense.amount,
          'vatAmount': item.directExpense.vatAmount,
        });
      }
    }

    if (directExpenses.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final headers = ['Type', 'Description', 'Amount', 'VAT', 'Total'];

    final tableData = <List<pw.Widget>>[];

    for (final expense in directExpenses) {
      final total = expense['amount'] + expense['vatAmount'];
      tableData.add([
        pw.Text(expense['type'], style: pw.TextStyle(fontSize: 9)),
        pw.Text(expense['description'], style: pw.TextStyle(fontSize: 9)),
        pw.Text(
          _formatCurrency(expense['amount']),
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          _formatCurrency(expense['vatAmount']),
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          _formatCurrency(total),
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ]);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DIRECT EXPENSES',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 16,
            color: PdfColors.purple700,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
          columnWidths: {
            0: pw.FlexColumnWidth(1.5),
            1: pw.FlexColumnWidth(2.5),
            2: pw.FlexColumnWidth(1.5),
            3: pw.FlexColumnWidth(1.5),
            4: pw.FlexColumnWidth(1.5),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.purple700),
              children: headers
                  .map(
                    (header) => pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Data rows
            ...tableData.map(
              (row) => pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                children: row
                    .map(
                      (cell) => pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: cell,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildOtherExpensesTable(NewPurchaseModel purchase) {
    // Get other expenses (same supplier only, not included in product cost)
    final otherExpenses = purchase.expenseData.where((expense) {
      return expense.supplierId == purchase.supplierId &&
          !expense.includeInProductCost;
    }).toList();

    if (otherExpenses.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final headers = ['Type', 'Description', 'Amount', 'VAT', 'Total'];

    final tableData = <List<pw.Widget>>[];

    for (final expense in otherExpenses) {
      final total = expense.amount + expense.vatAmount;
      tableData.add([
        pw.Text(expense.typeName, style: pw.TextStyle(fontSize: 9)),
        pw.Text(
          expense.description.isNotEmpty ? expense.description : '-',
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          _formatCurrency(expense.amount),
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          _formatCurrency(expense.vatAmount),
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          _formatCurrency(total),
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ]);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'OTHER EXPENSES',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 16,
            color: PdfColors.green700,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
          columnWidths: {
            0: pw.FlexColumnWidth(1.5),
            1: pw.FlexColumnWidth(2.5),
            2: pw.FlexColumnWidth(1.5),
            3: pw.FlexColumnWidth(1.5),
            4: pw.FlexColumnWidth(1.5),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.green700),
              children: headers
                  .map(
                    (header) => pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Data rows
            ...tableData.map(
              (row) => pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                children: row
                    .map(
                      (cell) => pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: cell,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTotals(NewPurchaseModel purchase) {
    // Calculate totals from the actual data
    double itemsSubtotal = purchase.items.fold(0.0, (sum, item) {
      final discountAmount = _calculateDiscount(
        item.unitPrice * item.quantity,
        item.discount,
        item.discountType,
      );
      return sum + (item.unitPrice * item.quantity) - discountAmount;
    });

    double itemsVatTotal = purchase.items.fold(
      0.0,
      (sum, item) => sum + item.vatAmount,
    );

    // Direct expenses totals
    double directExpensesSubtotal = 0;
    double directExpensesVatTotal = 0;
    for (final item in purchase.items) {
      if (item.directExpense.amount > 0 &&
          item.directExpense.supplierId == purchase.supplierId) {
        directExpensesSubtotal += item.directExpense.amount;
        directExpensesVatTotal += item.directExpense.vatAmount;
      }
    }

    // Other expenses totals
    final otherExpenses = purchase.expenseData.where((expense) {
      return expense.supplierId == purchase.supplierId &&
          !expense.includeInProductCost;
    }).toList();

    double otherExpensesSubtotal = otherExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    double otherExpensesVatTotal = otherExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.vatAmount,
    );

    final grandSubtotal =
        itemsSubtotal + directExpensesSubtotal + otherExpensesSubtotal;
    final grandVatTotal =
        itemsVatTotal + directExpensesVatTotal + otherExpensesVatTotal;
    final grandTotal = grandSubtotal + grandVatTotal;

    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _buildTotalRow('Products Subtotal:', itemsSubtotal),
              _buildTotalRow('Products VAT:', itemsVatTotal),
              if (directExpensesSubtotal > 0)
                _buildTotalRow('Direct Expenses:', directExpensesSubtotal),
              if (directExpensesVatTotal > 0)
                _buildTotalRow('Direct Expenses VAT:', directExpensesVatTotal),
              if (otherExpensesSubtotal > 0)
                _buildTotalRow('Other Expenses:', otherExpensesSubtotal),
              if (otherExpensesVatTotal > 0)
                _buildTotalRow('Other Expenses VAT:', otherExpensesVatTotal),
              pw.SizedBox(height: 8),
              pw.Divider(color: PdfColors.grey400, thickness: 1),
              pw.SizedBox(height: 8),
              _buildTotalRow('Grand Subtotal:', grandSubtotal, isBold: true),
              _buildTotalRow('Total VAT:', grandVatTotal, isBold: true),
              pw.SizedBox(height: 8),
              _buildTotalRow(
                'GRAND TOTAL:',
                grandTotal,
                isBold: true,
                isTotal: true,
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                width: 250,
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blue300),
                  borderRadius: pw.BorderRadius.circular(4),
                  color: PdfColors.blue50,
                ),
                child: pw.Column(
                  children: [
                    _buildTotalRow(
                      'Total Paid:',
                      purchase.paymentData.totalPaid,
                    ),
                    _buildTotalRow(
                      'Remaining Due:',
                      purchase.paymentData.remainingAmount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTotalRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return pw.Container(
      width: 250,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 12 : 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isTotal ? PdfColors.blue800 : PdfColors.black,
            ),
          ),
          pw.Text(
            _formatCurrency(amount),
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isTotal ? PdfColors.blue700 : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'TERMS & CONDITIONS',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
              color: PdfColors.blue700,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            '• Payment due within 30 days of invoice date',
            style: pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Thank you for your business!',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  static double _calculateDiscount(
    double amount,
    double discount,
    String discountType,
  ) {
    if (discountType == 'percentage') {
      return amount * (discount / 100);
    } else {
      return discount;
    }
  }

  static String _formatCurrency(double amount) {
    return 'OMR ${amount.toStringAsFixed(2)}';
  }

  static String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static Future<String> _getSupplierName(String supplierId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .get();
      return doc.data()?['supplierName'] ?? 'Unknown Supplier';
    } catch (e) {
      return 'Supplier Loading Failed';
    }
  }

  static PdfColor _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
      case 'save':
        return PdfColors.green;
      case 'pending':
        return PdfColors.orange;
      case 'cancelled':
        return PdfColors.red;
      case 'draft':
        return PdfColors.grey;
      default:
        return PdfColors.blue;
    }
  }
}
