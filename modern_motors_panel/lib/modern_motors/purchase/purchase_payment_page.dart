import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/payment_data.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
import 'package:modern_motors_panel/model/supplier/supplier_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class PurchasePaymentPage extends StatefulWidget {
  final NewPurchaseModel purchase;
  const PurchasePaymentPage({super.key, required this.purchase});

  @override
  State<PurchasePaymentPage> createState() => _PurchasePaymentPageState();
}

class _PurchasePaymentPageState extends State<PurchasePaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _detailsController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Cash';
  bool _isLoading = false;
  double payableAmount = 0;

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
    double remainingAmount = widget.purchase.subInvoices.isEmpty
        ? widget.purchase.totals.total
        : widget.purchase.mainInvoiceTotal;
    //widget.sale.paymentData.remainingAmount;
    if (remainingAmount > 0) {
      _amountController.text = remainingAmount.toStringAsFixed(2);
    }
  }

  double getValue() {
    double d = 0;
    if (widget.purchase.subInvoices.isNotEmpty) {
      d = widget.purchase.mainInvoiceTotal;
    } else {
      d = widget.purchase.totals.total;
    }
    return d;
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
        ...widget.purchase.paymentData.paymentMethods,
        newPayment,
      ];

      double newTotalPaid =
          widget.purchase.paymentData.totalPaid + paymentAmount;
      double newRemainingAmount = widget.purchase.totals.total - newTotalPaid;
      bool isFullyPaid = newRemainingAmount <= 0;

      PaymentData updatedPaymentData = PaymentData(
        isAlreadyPaid: isFullyPaid,
        paymentMethods: updatedPaymentMethods,
        remainingAmount: newRemainingAmount < 0 ? 0 : newRemainingAmount,
        totalPaid: newTotalPaid,
      );

      // Update sale status if fully paid
      String updatedStatus = widget.purchase.status;
      if (isFullyPaid && updatedStatus != 'completed') {
        updatedStatus = 'paid';
      }
      double d = double.parse(_amountController.text) ?? 0;
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'makePaymentForPurchase',
      );
      final results = await callable({
        'purchaseId': widget.purchase.id, //'000testSale',
        "payment": {
          "reference": _referenceController.text.trim(),
          "method": _selectedPaymentMethod,
          "amount": d,
          "date":
              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
        },
      });
      debugPrint(results.data.toString());

      if (mounted) {
        if (results.data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          String errorMessage =
              results.data['status'] ??
              results.data['error'] ??
              results.data['message'] ??
              'Failed to add payment';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment failed: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
                            'Purchase Information Information',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow('Supplier', widget.purchase.supplierId),
                          _buildInfoRow(
                            'Purchase ID:',
                            "${"MM"}-${widget.purchase.invoice}",
                          ),
                          _buildInfoRow(
                            'Total Amount:',
                            'OMR ${widget.purchase.totals.total.toStringAsFixed(2)}',
                          ),
                          _buildInfoRow(
                            'Already Paid:',
                            'OMR ${widget.purchase.paymentData.totalPaid.toStringAsFixed(2)}',
                          ),
                          _buildInfoRow(
                            'Remaining:',
                            'OMR ${widget.purchase.paymentData.remainingAmount.toStringAsFixed(2)}',
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
                            hintText: payableAmount
                                .toString(), //widget.purchase.remaining.toString(),
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
                                  widget.purchase.paymentData.remainingAmount +
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
                          ),
                          const SizedBox(height: 16),

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
    SupplierModel? customer = context
        .read<MmResourceProvider>()
        .suppliersList
        .firstWhere((item) => item.id == widget.purchase.supplierId);
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
              label == "Supplier" ? customer.supplierName : value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
