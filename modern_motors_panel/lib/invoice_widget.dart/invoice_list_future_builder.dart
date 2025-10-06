// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/invoice_widget.dart/pdf_invoices.dart/payment_invoice1.dart';
import 'package:modern_motors_panel/model/invoices/invoice_model.dart';

class InvoiceListFutureBuilder extends StatefulWidget {
  final String orderId;
  const InvoiceListFutureBuilder({required this.orderId, super.key});

  @override
  State<InvoiceListFutureBuilder> createState() =>
      _InvoiceListFutureBuilderState();
}

class _InvoiceListFutureBuilderState extends State<InvoiceListFutureBuilder> {
  Future<List<InvoiceModel>> getPaymentDetails() async {
    List<InvoiceModel> invoiceList = [];
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .where("orderId", isEqualTo: widget.orderId)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              InvoiceModel i = InvoiceModel.fromMap(doc);
              if (i.orderId.isNotEmpty) {
                invoiceList.add(i);
              }
            }
          });
    } catch (e) {
      Constants.showMessage(context, e.toString());
    }
    return invoiceList;
  }

  void navInvoices(InvoiceModel invoice) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PaymentInvoice1(invoice: invoice);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InvoiceModel>>(
      future: getPaymentDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Failed to load invoices",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  "${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.receipt_long, color: Colors.grey, size: 48),
                const SizedBox(height: 16),
                Text(
                  "No invoices found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final invoices = snapshot.data!;
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          //constraints: BoxConstraints(maxHeight: 400),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: invoices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return GestureDetector(
                onTap: () => navInvoices(invoice),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          size: 24,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Invoice #${invoice.invoice}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    if (invoice.ref != null)
                                      Text(
                                        "Ref #${invoice.ref}",
                                        style: TextStyle(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "OMR ${invoice.amount.toStringAsFixed(3)}",
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat(
                                'MMM dd, yyyy - hh:mm a',
                              ).format(invoice.timeStamp.toDate()),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
