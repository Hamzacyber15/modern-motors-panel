import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/payment_data.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final SaleModel sale;

  const PaymentPage({super.key, required this.sale});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _detailsController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Cash';
  bool _isLoading = false;

  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Check',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill amount with remaining balance if available
    double remainingAmount = widget.sale.paymentData.remainingAmount;
    if (remainingAmount > 0) {
      _amountController.text = remainingAmount.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _detailsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Future<void> _processPayment() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     double paymentAmount = double.parse(_amountController.text);

  //     // Create new payment method entry
  //     PaymentMethod newPayment = PaymentMethod(
  //       amount: paymentAmount,
  //       method: _selectedPaymentMethod,
  //       methodName: _selectedPaymentMethod,
  //       reference: _referenceController.text.trim(),
  //     );

  //     // Update payment data
  //     List<PaymentMethod> updatedPaymentMethods = [
  //       ...widget.sale.paymentData.paymentMethods,
  //       newPayment
  //     ];

  //     double newTotalPaid = widget.sale.paymentData.totalPaid + paymentAmount;
  //     double newRemainingAmount = widget.sale.totalRevenue - newTotalPaid;
  //     bool isFullyPaid = newRemainingAmount <= 0;

  //     PaymentData updatedPaymentData = PaymentData(
  //       isAlreadyPaid: isFullyPaid,
  //       paymentMethods: updatedPaymentMethods,
  //       remainingAmount: newRemainingAmount < 0 ? 0 : newRemainingAmount,
  //       totalPaid: newTotalPaid,
  //     );

  //     // Update sale status if fully paid
  //     String updatedStatus = widget.sale.status;
  //     if (isFullyPaid && updatedStatus != 'completed') {
  //       updatedStatus = 'paid';
  //     }

  //     // Update Firestore document
  //     await FirebaseFirestore.instance
  //         .collection('sales')
  //         .doc(widget.sale.id)
  //         .update({
  //       'paymentData': updatedPaymentData.toMap(),
  //       'status': updatedStatus,
  //       'updatedAt': Timestamp.now(),
  //       'remaining': newRemainingAmount < 0 ? 0 : newRemainingAmount,
  //     });

  //     // Add payment record to payments subcollection (optional)
  //     await FirebaseFirestore.instance
  //         .collection('sales')
  //         .doc(widget.sale.id)
  //         .collection('payments')
  //         .add({
  //       'amount': paymentAmount,
  //       'paymentMethod': _selectedPaymentMethod,
  //       'reference': _referenceController.text.trim(),
  //       'details': _detailsController.text.trim(),
  //       'notes': _notesController.text.trim(),
  //       'paymentDate': Timestamp.fromDate(_selectedDate),
  //       'createdAt': Timestamp.now(),
  //       'createdBy': 'current_user', // Replace with actual user ID
  //     });

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(isFullyPaid
  //               ? 'Payment successful! Sale is now fully paid.'
  //               : 'Payment added successfully!'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //       Navigator.of(context).pop(true); // Return true to indicate success
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error processing payment: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  // Future<void> updateSalePaymentData({
  //   required String saleId,
  //   required PaymentData paymentData,
  //   String? status,
  //   double? remaining,
  // }) async {
  //   try {
  //     final Map<String, dynamic> updateData = {
  //       'paymentData': paymentData.toMap(),
  //       'updatedAt': Timestamp.now(),
  //     };
  //     if (status != null) {
  //       updateData['status'] = status;
  //     }
  //     if (remaining != null) {
  //       updateData['remaining'] = remaining;
  //     }
  //     await FirebaseFirestore.instance
  //         .collection('sales')
  //         .doc(saleId)
  //         .update(updateData);

  //     debugPrint('Sale payment data updated successfully for sale: $saleId');
  //   } catch (e) {
  //     debugPrint('Error updating sale payment data: $e');
  //     throw e;
  //   }
  // }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      double paymentAmount = double.parse(_amountController.text);

      // Create new payment method entry
      PaymentMethod newPayment = PaymentMethod(
        amount: paymentAmount,
        method: _selectedPaymentMethod,
        methodName: _selectedPaymentMethod,
        reference: _referenceController.text.trim(),
      );

      // Update payment data
      List<PaymentMethod> updatedPaymentMethods = [
        ...widget.sale.paymentData.paymentMethods,
        newPayment,
      ];

      double newTotalPaid = widget.sale.paymentData.totalPaid + paymentAmount;
      double newRemainingAmount = widget.sale.totalRevenue - newTotalPaid;
      bool isFullyPaid = newRemainingAmount <= 0;

      PaymentData updatedPaymentData = PaymentData(
        isAlreadyPaid: isFullyPaid,
        paymentMethods: updatedPaymentMethods,
        remainingAmount: newRemainingAmount < 0 ? 0 : newRemainingAmount,
        totalPaid: newTotalPaid,
      );

      // Update sale status if fully paid
      String updatedStatus = widget.sale.status;
      if (isFullyPaid && updatedStatus != 'completed') {
        updatedStatus = 'paid';
      }

      // Use the utility function to update Firestore
      // await updateSalePaymentData(
      //   saleId: widget.sale.id,
      //   paymentData: updatedPaymentData,
      //   status: updatedStatus,
      //   remaining: newRemainingAmount < 0 ? 0 : newRemainingAmount,
      // );
      // "2025-09-16"
      double d = double.parse(_amountController.text) ?? 0;
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'makePaymentForSale',
      );
      final results = await callable({
        'saleId': widget.sale.id, //'000testSale',
        "payment": {
          "reference": _referenceController.text.trim(),
          "method": _selectedPaymentMethod,
          "amount": d,
          "date":
              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
        },
      });
      debugPrint(results.data.toString());

      // Add payment record to payments subcollection (optional)
      // await FirebaseFirestore.instance
      //     .collection('sales')
      //     .doc(widget.sale.id)
      //     .collection('payments')
      //     .add({
      //   'amount': paymentAmount,
      //   'paymentMethod': _selectedPaymentMethod,
      //   'reference': _referenceController.text.trim(),
      //   'details': _detailsController.text.trim(),
      //   'notes': _notesController.text.trim(),
      //   'paymentDate': Timestamp.fromDate(_selectedDate),
      //   'createdAt': Timestamp.now(),
      //   'createdBy': 'current_user', // Replace with actual user ID
      // });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sale Information Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sale Information',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow('Customer', widget.sale.customerName),
                          _buildInfoRow(
                            'Sale ID:',
                            "${"MM"}-${widget.sale.invoice}",
                          ),
                          _buildInfoRow(
                            'Total Amount:',
                            'OMR ${widget.sale.totalRevenue.toStringAsFixed(2)}',
                          ),
                          _buildInfoRow(
                            'Already Paid:',
                            'OMR ${widget.sale.paymentData.totalPaid.toStringAsFixed(2)}',
                          ),
                          _buildInfoRow(
                            'Remaining:',
                            'OMR ${widget.sale.paymentData.remainingAmount.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Form
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          // Amount Field
                          CustomMmTextField(
                            controller: _amountController,
                            hintText: widget.sale.remaining.toString(),
                            // decoration: const InputDecoration(
                            //   labelText: 'Payment Amount',
                            //   prefixText: '\$ ',
                            //   border: OutlineInputBorder(),
                            //   hintText: 'Enter payment amount',
                            // ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp(r'^\d+\.?\d{0,2}')),
                            // ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter payment amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              if (amount >
                                  widget.sale.paymentData.remainingAmount +
                                      100) {
                                return 'Amount exceeds remaining balance by too much';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Payment Date
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _selectDate,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Payment Date',
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_today),
                                      contentPadding: EdgeInsets.all(6),
                                    ),
                                    child: Text(
                                      '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedPaymentMethod,
                                  decoration: const InputDecoration(
                                    labelText: 'Payment Method',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(6),
                                  ),
                                  items: _paymentMethods.map((method) {
                                    return DropdownMenuItem(
                                      value: method,
                                      child: Text(method),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedPaymentMethod = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Reference Number
                          CustomMmTextField(
                            hintText: "Add Reference",
                            controller: _referenceController,
                            // decoration: const InputDecoration(
                            //   labelText: 'Reference Number',
                            //   border: OutlineInputBorder(),
                            //   hintText: 'Transaction/Check number (optional)',
                            // ),
                          ),
                          const SizedBox(height: 16),
                          // // Payment Details
                          // TextFormField(
                          //   controller: _detailsController,
                          //   decoration: const InputDecoration(
                          //     labelText: 'Payment Details',
                          //     border: OutlineInputBorder(),
                          //     hintText: 'Additional payment information',
                          //   ),
                          //   maxLines: 2,
                          // ),
                          // const SizedBox(height: 16),
                          // Notes
                          CustomMmTextField(
                            hintText: 'Internal notes (optional)',
                            controller: _notesController,
                            // decoration: const InputDecoration(
                            //   labelText: 'Notes',
                            //   border: OutlineInputBorder(),
                            //   hintText: 'Internal notes (optional)',
                            // ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _processPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Process Payment'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    CustomerModel? customer = context
        .read<MmResourceProvider>()
        .customersList
        .firstWhere((item) => item.id == widget.sale.customerName);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              label == "Customer" ? customer.customerName : value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// Usage example - how to navigate to payment page
class PaymentNavigationExample extends StatelessWidget {
  final SaleModel sale;
  final String saleId;

  const PaymentNavigationExample({
    Key? key,
    required this.sale,
    required this.saleId,
  }) : super(key: key);

  void _navigateToPaymentPage(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => PaymentPage(sale: sale)),
    );

    if (result == true) {
      // Payment was successful, refresh the sale data or update UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment processed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToPaymentPage(context),
      icon: const Icon(Icons.payment),
      label: const Text('Add Payment'),
    );
  }
}
