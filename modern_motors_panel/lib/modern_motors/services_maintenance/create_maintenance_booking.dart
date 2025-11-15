// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/commission_transaction_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/employees_commision_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/sales_model/credit_days_model.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/inventory_selection_bridge.dart';
import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/sales_invoice_dropdown_view.dart';
import 'package:modern_motors_panel/modern_motors/widgets/selected_items_page.dart';
import 'package:modern_motors_panel/provider/maintenance_booking_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/dialogue_box_picker.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

class PaymentMethod {
  final String id;
  final String name;

  PaymentMethod({required this.id, required this.name});

  static List<PaymentMethod> get methods => [
    PaymentMethod(id: 'cash', name: 'Cash'),
    PaymentMethod(id: 'credit_card', name: 'Credit Card'),
    PaymentMethod(id: 'Debit Card', name: 'Debit Card'),
    PaymentMethod(id: 'bank_transfer', name: 'Bank Transfer'),
    PaymentMethod(id: 'pos', name: 'POS'),
    PaymentMethod(id: 'multiple', name: 'Multiple'),
  ];
}

class PaymentRow {
  PaymentMethod? method;
  String reference = '';
  double amount = 0;

  PaymentRow({this.method, this.reference = '', this.amount = 0});
}

class DiscountType {
  final String id;
  final String name;

  DiscountType({required this.id, required this.name});

  static List<DiscountType> get types => [
    DiscountType(id: 'percentage', name: '%'),
    DiscountType(id: 'amount', name: 'OMR'),
  ];
}

class DepositType {
  final String id;
  final String name;

  DepositType({required this.id, required this.name});

  static List<DepositType> get types => [
    DepositType(id: 'percentage', name: '%'),
    DepositType(id: 'amount', name: 'OMR'),
  ];
}

class ProductRow {
  SaleItem? saleItem;
  String? type;
  double? sellingPrice;
  double? selectedPrice;
  double margin = 0;
  int quantity = 1;
  double discount = 0;
  bool applyVat = true;
  double subtotal = 0;
  double vatAmount = 0;
  double total = 0;
  double profit = 0;
  double cost = 0;
  late Key dropdownKey;
  late Key priceKey;
  late Key quantityKey;
  late Key discountKey;

  ProductRow({
    this.total = 0,
    this.subtotal = 0,
    this.saleItem,
    this.type,
    this.sellingPrice,
    this.selectedPrice,
    this.quantity = 1,
    this.discount = 0,
    this.applyVat = true,
    this.cost = 0,
  }) {
    dropdownKey = UniqueKey();
    priceKey = UniqueKey();
    quantityKey = UniqueKey();
    discountKey = UniqueKey();
  }

  void calculateTotals() {
    if (type == "service") {
      subtotal = (selectedPrice ?? 0) * quantity;
    } else {
      if (sellingPrice == null && margin != 0) {
        sellingPrice = cost * (1 + margin / 100);
      }
      subtotal = (sellingPrice ?? 0) * quantity;
    }
    final discountAmount = subtotal * (discount / 100);
    final amountAfterDiscount = subtotal - discountAmount;
    vatAmount = applyVat ? amountAfterDiscount * 0.00 : 0;
    total = amountAfterDiscount + vatAmount;
    if (type == "product") {
      profit = (sellingPrice ?? 0) - cost;
    }
  }
}

class CreateMaintenanceBooking extends StatefulWidget {
  final VoidCallback? onBack;
  final SaleModel? sale;
  final List<InventoryModel>? selectedInventory;
  final List<ProductModel>? products;
  final String? type;

  const CreateMaintenanceBooking({
    super.key,
    this.onBack,
    this.sale,
    this.products,
    this.selectedInventory,
    this.type,
  });

  @override
  State<CreateMaintenanceBooking> createState() =>
      _CreateMaintenanceBookingState();
}

class _CreateMaintenanceBookingState extends State<CreateMaintenanceBooking> {
  final customerNameController = TextEditingController();
  final discountController = TextEditingController();
  final depositAmountController = TextEditingController();

  // Data
  List<CustomerModel> allCustomers = [];
  List<CustomerModel> filteredCustomers = [];
  List<MmtrucksModel> allTrucks = [];
  List<ServiceTypeModel> allServices = [];
  List<DiscountModel> allDiscounts = [];
  List<ProductModel> allProducts = [];
  List<EmployeeModel> employees = [];
  CreditDaysModel? creditDays;
  List<ProductRow> productRows = [];
  double productsGrandTotal = 0;
  bool loading = false;
  double servicesGrandTotal = 0;
  List<SaleItem> salesItem = [];
  bool isAlreadyPaid = false;
  bool isMultiple = false;
  List<PaymentRow> paymentRows = [PaymentRow()];
  double remainingAmount = 0;
  bool _isLoadingDiscounts = true;
  DiscountType selectedDiscountType = DiscountType.types[0];
  DepositType selectedDepositType = DepositType.types[0];
  bool requireDeposit = false;
  double depositAmount = 0;
  double depositPercentage = 0;
  bool depositAlreadyPaid = false;
  double nextPaymentAmount = 0;
  List<AttachmentModel> displayPicture = [];
  double invNumber = 0;
  int? selectedCreditDays;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<MaintenanceBookingProvider>();
      p.clearData();
      DateTime t = DateTime.now();
      if (widget.sale == null) {
        p.setBookingTime(t);
      } else {
        p.setBookingTime(widget.sale!.createdAt);
      }
    });

    if (widget.sale == null) {
      productRows.add(ProductRow());
    }

    _loadInitialData();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    discountController.dispose();
    depositAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (mounted) {
      setState(() => _isLoadingDiscounts = true);
    }

    if (widget.sale == null) {
      var value = await Constants.getUniqueNumberValue("MM");
      invNumber = value;
    } else {
      invNumber = double.parse(widget.sale!.invoice);
    }

    try {
      final results = await Future.wait([
        DataFetchService.fetchDiscount(),
        DataFetchService.fetchCustomers(),
        DataFetchService.fetchTrucks(),
        DataFetchService.fetchServiceTypes(),
        DataFetchService.fetchProducts(),
        DataFetchService.getCreditDays(),
      ]);

      allDiscounts = results[0] as List<DiscountModel>;
      allCustomers = results[1] as List<CustomerModel>;
      allTrucks = results[2] as List<MmtrucksModel>;
      allServices = results[3] as List<ServiceTypeModel>;
      allProducts = results[4] as List<ProductModel>;
      creditDays = results[5] as CreditDaysModel;

      // Get employees from provider
      final provider = context.read<MmResourceProvider>();
      employees = provider.employees;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget.sale != null) {
          CustomerModel? customer;
          customer = allCustomers.firstWhere(
            (item) => item.id == widget.sale!.customerName,
          );
          customerNameController.text = customer.customerName;
          final p = context.read<MaintenanceBookingProvider>();
          p.setCustomer(id: widget.sale!.customerName);

          for (var element in widget.sale!.items) {
            productRows.add(
              ProductRow(
                saleItem: element,
                type: element.type,
                sellingPrice: element.sellingPrice,
                quantity: element.quantity,
                total: element.totalPrice,
                subtotal: element.discount + element.totalPrice,
                discount: element.discount,
              ),
            );
          }

          discountController.text = widget.sale!.discount.toString();
          p.getValues(widget.sale!.taxAmount, widget.sale!.total!);
          p.discountType = widget.sale!.discountType;

          if (widget.sale!.discountType == 'percentage') {
            selectedDiscountType = DiscountType.types[0];
            p.discountType = selectedDiscountType.id;
            p.setDiscountPercent(widget.sale!.discount);
          } else {
            selectedDiscountType = DiscountType.types[1];
            p.discountType = selectedDiscountType.id;
            p.setDiscountPercent(widget.sale!.discount);
          }

          productsGrandTotal = productRows.fold(
            0,
            (sum, row) => sum + row.total,
          );
          _applyDiscount(p, productsGrandTotal);

          if (widget.sale!.paymentData.paymentMethods.isNotEmpty) {
            isAlreadyPaid = true;
            paymentRows.clear();
            isMultiple = widget.sale!.paymentData.paymentMethods.length > 1;

            for (
              var i = 0;
              i < widget.sale!.paymentData.paymentMethods.length;
              i++
            ) {
              final element = widget.sale!.paymentData.paymentMethods[i];
              PaymentMethod? paymentMethod;
              try {
                paymentMethod = PaymentMethod.methods.firstWhere(
                  (method) =>
                      method.id.toLowerCase() == element.method?.toLowerCase(),
                );
              } catch (e) {
                paymentMethod = PaymentMethod(
                  id: element.method ?? 'unknown',
                  name: element.method ?? 'Unknown',
                );
              }

              final newPaymentRow = PaymentRow(
                method: paymentMethod,
                reference: element.reference,
                amount: element.amount,
              );
              paymentRows.add(newPaymentRow);
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                final double subtotal = servicesGrandTotal + productsGrandTotal;
                final double discountAmount = p.discountAmount;
                final double amountAfterDiscount = subtotal - discountAmount;
                final double taxAmount = p.getIsTaxApply
                    ? amountAfterDiscount * (p.taxPercent / 100)
                    : 0;
                final double total = amountAfterDiscount + taxAmount;

                _calculateRemainingAmount(total);
                if (mounted) {
                  setState(() {});
                }
              }
            });
          }
          //   await fetchCommission();
        }
      });

      salesItem = mergeProductsAndServices(allProducts, allServices);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoadingDiscounts = false);
    }
  }

  List<SaleItem> mergeProductsAndServices(
    List<ProductModel> products,
    List<ServiceTypeModel> services,
  ) {
    List<SaleItem> mergedList = [];

    mergedList.addAll(
      products.map(
        (product) => SaleItem(
          discount: 0,
          margin: 0,
          minimumPrice: product.minimumPrice ?? 0,
          productId: product.id ?? '',
          productName: product.productName ?? '',
          quantity: 1,
          sellingPrice: product.sellingPrice ?? product.lastCost ?? 0,
          totalPrice: (product.sellingPrice ?? product.lastCost ?? 0) * 1,
          unitPrice: product.averageCost ?? product.lastCost ?? 0,
          type: 'product',
          cost: product.averageCost ?? 0,
        ),
      ),
    );

    mergedList.addAll(
      services.map((service) {
        double price = service.prices?.isNotEmpty == true
            ? (service.prices?[0] as num).toDouble()
            : 0;

        return SaleItem(
          discount: 0,
          margin: 0,
          productId: service.id ?? '',
          productName: service.name,
          minimumPrice: service.minimumPrice ?? 0,
          quantity: 1,
          sellingPrice: price,
          totalPrice: price,
          unitPrice: price,
          type: 'service',
          cost: price,
        );
      }),
    );

    return mergedList;
  }

  void _addProductRow() {
    if (mounted) {
      setState(() {
        productRows.add(ProductRow());
      });
    }
  }

  double _getCurrentTotalPaid() {
    double total = 0.0;
    for (var row in paymentRows) {
      total += row.amount;
    }
    return total;
  }

  void _calculateRemainingAmount(double grandTotal) {
    double paidAmount = _getCurrentTotalPaid();

    if (isAlreadyPaid && paymentRows.length == 1 && !isMultiple) {
      if (paymentRows.first.amount == 0) {
        paymentRows.first.amount = grandTotal;
        paidAmount = grandTotal;
      }
    }

    remainingAmount = grandTotal - paidAmount;

    if (remainingAmount < 0) {
      remainingAmount = 0;
    }
  }

  void _ensurePaymentAmounts(double grandTotal) {
    if (isAlreadyPaid && paymentRows.isNotEmpty) {
      double totalPaid = paymentRows.fold(
        0.0,
        (sum, row) => sum + (row.amount ?? 0.0),
      );

      if (totalPaid == 0 && grandTotal > 0) {
        if (paymentRows.length == 1 && !isMultiple) {
          paymentRows.first.amount = grandTotal;
        } else if (paymentRows.length > 1 || isMultiple) {
          double equalAmount = grandTotal / paymentRows.length;
          for (var row in paymentRows) {
            row.amount = equalAmount;
          }
        }
        _calculateRemainingAmount(grandTotal);
      }
    }
  }

  void _updateAllCalculations(MaintenanceBookingProvider p) {
    if (!mounted) return;
    final double subtotal = servicesGrandTotal + productsGrandTotal;
    final double discountAmount = p.discountAmount;
    final double amountAfterDiscount = subtotal - discountAmount;
    final double taxAmount = p.getIsTaxApply
        ? amountAfterDiscount * (p.taxPercent / 100)
        : 0;
    final double total = amountAfterDiscount + taxAmount;

    _updateDepositCalculation(total, p);
  }

  void _updateDepositCalculation(
    double grandTotal,
    MaintenanceBookingProvider p,
  ) {
    if (requireDeposit) {
      if (selectedDepositType.id == 'percentage') {
        depositAmount = grandTotal * (depositPercentage / 100);
      } else {
        depositAmount = double.tryParse(depositAmountController.text) ?? 0;
        if (depositAmount > grandTotal) {
          depositAmount = grandTotal;
          depositAmountController.text = grandTotal.toStringAsFixed(2);
        }
      }
      p.depositAmount = depositAmount;
      nextPaymentAmount = grandTotal - depositAmount;
      p.remainingAmount = nextPaymentAmount;
    } else {
      depositAmount = 0;
      nextPaymentAmount = grandTotal;
    }
    _calculateRemainingAmount(grandTotal);
  }

  void _applyDiscount(MaintenanceBookingProvider p, double subtotal) {
    final discountValue = double.tryParse(discountController.text) ?? 0;
    p.discountType = selectedDiscountType.id;
    if (selectedDiscountType.id == 'percentage') {
      p.setDiscountPercent(discountValue);
    } else {
      final discountPercent = discountValue > 0
          ? (discountValue / subtotal) * 100
          : 0;
      if (widget.sale != null) {
        p.setDiscountValue(widget.sale!.discount);
      } else {
        p.setDiscountPercent(discountPercent.toDouble());
      }
    }
    _updateAllCalculations(p);
  }

  void _removeProductRow(int index, MaintenanceBookingProvider p) {
    if (mounted) {
      setState(() {
        if (productRows.length > 1) {
          productRows.removeAt(index);
          _calculateProductsGrandTotal();
        } else {
          productRows.clear();
          productsGrandTotal = 0;
          p.setProductsTotal(0);
        }
      });
    }
    discountController.clear();
    final discount = double.tryParse(discountController.text) ?? 0;
    p.setDiscountPercent(discount);
    _updateAllCalculations(p);
  }

  void _updateProductRow(
    int index,
    ProductRow updatedRow,
    MaintenanceBookingProvider p,
  ) {
    if (mounted) {
      setState(() {
        productRows[index] = updatedRow;
        _calculateProductsGrandTotal();
      });
    }
    discountController.clear();
    final discount = double.tryParse(discountController.text) ?? 0;
    p.setDiscountPercent(discount);
    _updateAllCalculations(p);
  }

  void _calculateProductsGrandTotal() {
    productsGrandTotal = productRows.fold(0, (sum, row) => sum + row.total);
    final p = context.read<MaintenanceBookingProvider>();
  }

  // Employee Commission Methods
  void _showEmployeeCommissionDialog(MaintenanceBookingProvider p) {
    // Start with currently selected employees
    final selectedEmployees = Set<String>.from(p.selectedEmployeeIds);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Select Employees'),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  Text(
                    'Select employees for commission',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),

                  // Employee list with checkboxes
                  Expanded(
                    child: employees.isEmpty
                        ? Center(child: Text('No employees available'))
                        : ListView.builder(
                            itemCount: employees.length,
                            itemBuilder: (context, index) {
                              final employee = employees[index];
                              final isSelected = selectedEmployees.contains(
                                employee.id,
                              );

                              return CheckboxListTile(
                                title: Text(employee.name),
                                value: isSelected,
                                onChanged: (value) {
                                  setDialogState(() {
                                    if (value == true) {
                                      selectedEmployees.add(employee.id!);
                                    } else {
                                      selectedEmployees.remove(employee.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    '${selectedEmployees.length} employees selected',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  p.setSelectedEmployees(selectedEmployees.toList());
                  Navigator.of(context).pop();
                },
                child: Text('Save Selection'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCommissionRow(
    int index,
    MaintenanceBookingProvider p,
    double grandTotal,
  ) {
    final commission = p.employeeCommissions[index];

    final employee = employees.firstWhere(
      (e) => e.id == commission.employeeId,
      // orElse: () => EmployeeModel(id: '', fullName: 'Unknown Employee'),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              employee.name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: 8),

          Expanded(
            flex: 1,
            child: CustomSearchableDropdown(
              hintText: 'Type',
              items: {'percentage': '%', 'amount': 'OMR'},
              value: commission.type,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  p.updateEmployeeCommission(index, type: value);
                  p.updateEmployeeCommission(index, value: 0);
                  _recalculateCommission(p, grandTotal);
                }
              },
            ),
          ),
          SizedBox(width: 8),

          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: commission.commission > 0
                  ? commission.commission.toStringAsFixed(2)
                  : '',
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                suffixText: commission.type == 'percentage' ? '%' : '',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final commissionValue = double.tryParse(value) ?? 0;
                  p.updateEmployeeCommission(index, value: commissionValue);
                  _recalculateCommission(p, grandTotal);
                }
              },
            ),
          ),
          SizedBox(width: 8),

          Expanded(
            flex: 1,
            child: Text(
              'OMR ${_calculateCommissionAmount(commission, grandTotal).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.purple,
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.remove_circle, size: 18, color: Colors.red),
            onPressed: () => p.removeEmployeeCommission(index),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  double _calculateCommissionAmount(
    CommissionTransactionModel commission,
    double grandTotal,
  ) {
    if (commission.type == 'percentage') {
      return grandTotal * (commission.commission / 100);
    }
    return commission.commission;
  }

  void _recalculateCommission(MaintenanceBookingProvider p, double grandTotal) {
    //   p.recalculateAllCommissions(grandTotal);
  }

  // Future<void> fetchCommission() async {
  //   try {
  //     final p = context.read<MaintenanceBookingProvider>();

  //     final commSnap = await FirebaseFirestore.instance
  //         .collection('mmEmployeeCommissions')
  //         .where('bookingId', isEqualTo: widget.sale!.id)
  //         .limit(1)
  //         .get();
  //     if (commSnap.docs.isNotEmpty) {
  //       final comm = EmployeeCommissionModel.fromDoc(commSnap.docs.first);
  //       p.setEmployeeCommissionModel(comm);
  //       p.setCommission(true);
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching commission: $e');
  //   }
  // }

  Widget _productSelectionSection(
    BuildContext context,
    MaintenanceBookingProvider p,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
          color: AppTheme.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Item',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Qty',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Discount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Subtotal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productRows.length,
              itemBuilder: (context, index) {
                return ProductRowWidget(
                  productRow: productRows[index],
                  allItems: salesItem,
                  index: index,
                  onUpdate: (updatedRow) =>
                      _updateProductRow(index, updatedRow, p),
                  onRemove: () => _removeProductRow(index, p),
                  showRemoveButton: true,
                );
              },
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addProductRow,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Products Grand Total:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'OMR ${productsGrandTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickBookingDate(MaintenanceBookingProvider p) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: p.saleDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      if (!mounted) return;
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(p.saleDate),
      );
      final finalDt = (t == null)
          ? DateTime(picked.year, picked.month, picked.day)
          : DateTime(picked.year, picked.month, picked.day, t.hour, t.minute);

      p.setBookingTime(finalDt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundGreyColor,
      child: Consumer<MaintenanceBookingProvider>(
        builder: (context, p, _) {
          return p.isItemsSelection
              ? SelectItemsPage(bridge: bridgeFromMaintenance(p))
              : SingleChildScrollView(
                  child: Form(
                    key: p.createBookingKey,
                    child: OverlayLoader(
                      loader: _isLoadingDiscounts,
                      child: Column(
                        children: [
                          PageHeaderWidget(
                            title: 'Create Invoice',
                            buttonText: 'Back to Invoices',
                            subTitle: 'Create New Invoice',
                            onCreateIcon: 'assets/images/back.png',
                            selectedItems: [],
                            buttonWidth: 0.25,
                            onCreate: widget.onBack!.call,
                            onDelete: () async {},
                          ),
                          20.h,
                          _topCard(context, p),
                          12.h,
                          p.orderLoading
                              ? MmloadingWidget()
                              : Column(
                                  children: [
                                    _productSelectionSection(context, p),
                                    12.h,
                                    _middleRow(context, p),
                                  ],
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

  Widget _topCard(BuildContext context, MaintenanceBookingProvider p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
          color: AppTheme.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${"Invoice #"} MM-${invNumber.toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.pageHeaderTitleColor,
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Preview Invoice',
                      preferBelow: false,
                      verticalOffset: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: TextStyle(color: Colors.white, fontSize: 12),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Preview logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        icon: Icon(
                          Icons.preview_sharp,
                          size: 18,
                          color: AppTheme.whiteColor,
                        ),
                        label: Text('Preview', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: 'Save as Draft',
                      preferBelow: false,
                      verticalOffset: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: TextStyle(color: Colors.white, fontSize: 12),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _saveInvoice(p, "draft");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.grey[800],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        icon: Icon(Icons.save, size: 18),
                        label: Text('Draft', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            16.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomMmTextField(
                    onTap: () => _pickBookingDate(p),
                    readOnly: true,
                    labelText: 'Invoice Date',
                    hintText: 'Invoice Date',
                    controller: p.bookingDateController,
                    autovalidateMode: _isLoadingDiscounts
                        ? AutovalidateMode.disabled
                        : AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Select Invoice date' : null,
                  ),
                ),
                if (p.billingParty != BillingParty.ish) ...[
                  Expanded(
                    child: Column(
                      children: [
                        CustomMmTextField(
                          labelText: 'Customer Name',
                          hintText: 'Customer Name',
                          controller: customerNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: ValidationUtils.customerName,
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                filteredCustomers = allCustomers
                                    .where(
                                      (c) => c.customerName
                                          .toLowerCase()
                                          .contains(value.toLowerCase()),
                                    )
                                    .toList();
                              } else {
                                filteredCustomers = [];
                              }
                            });
                          },
                        ),
                        if (filteredCustomers.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 6,
                                  right: 6,
                                  top: 10,
                                ),
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: ListView.builder(
                                  itemCount: filteredCustomers.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final c = filteredCustomers[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0,
                                              vertical: 8,
                                            ),
                                            child: Text(c.customerName),
                                          ),
                                          onTap: () {
                                            p.setCustomer(id: c.id!);
                                            setState(() {
                                              customerNameController.text =
                                                  c.customerName;
                                              filteredCustomers.clear();
                                            });
                                          },
                                        ),
                                        if (index !=
                                            filteredCustomers.length - 1)
                                          const Divider(height: 1),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  12.w,
                ],
                Expanded(
                  child: CustomSearchableDropdown(
                    key: const ValueKey('truck_dropdown'),
                    hintText: 'Choose Truck',
                    value: p.truckId,
                    items: {
                      for (var t in allTrucks.where(
                        (t) => t.ownById == p.customerId,
                      ))
                        t.id!: '${t.code}-${t.plateNumber}',
                    },
                    onChanged: (val) => p.setTruckId(val),
                  ),
                ),
                12.w,
                Expanded(child: _buildCreditDropdown(p)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditDropdown(MaintenanceBookingProvider provider) {
    if (creditDays == null || creditDays!.creditDays.isEmpty) {
      return CustomSearchableDropdown(
        hintText: 'Loading credit days...',
        items: {},
        value: null,
        onChanged: (value) {},
      );
    }

    final Map<String, String> creditDaysMap = {};
    for (var days in creditDays!.creditDays) {
      creditDaysMap[days.toString()] = '$days days';
    }

    return CustomSearchableDropdown(
      key: ValueKey('credit_days_${creditDaysMap.length}'),
      hintText: 'Select Credit Days',
      items: creditDaysMap,
      value: selectedCreditDays?.toString(),
      onChanged: (value) {
        if (value.isNotEmpty) {
          if (mounted) {
            setState(() {
              selectedCreditDays = int.parse(value);
              provider.setPaymentDate(selectedCreditDays!);
            });
          }
        }
      },
    );
  }

  Widget _middleRow(BuildContext context, MaintenanceBookingProvider p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 700, child: _buildBookingSummarySection(context, p)),
        ],
      ),
    );
  }

  Widget _buildBookingSummarySection(
    BuildContext context,
    MaintenanceBookingProvider p,
  ) {
    final double subtotal = servicesGrandTotal + productsGrandTotal;
    p.itemsTotal = productsGrandTotal;

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          p.setServicesTotal(servicesGrandTotal);
          p.setSubtotal(subtotal);
        }
      });
    }

    final double discountAmount = p.discountAmount;
    final double amountAfterDiscount = subtotal - discountAmount;
    final double taxAmount = p.getIsTaxApply
        ? amountAfterDiscount * (p.taxPercent / 100)
        : 0;
    final double total = amountAfterDiscount + taxAmount;
    p.grandTotal = total;

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF3B82F6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'Invoice Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildUltraCompactCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Items',
                  children: [
                    _buildRow('Items Total', productsGrandTotal),
                    if (p.discountAmount > 0)
                      _buildRow(
                        'Discount',
                        -p.discountAmount,
                        color: Colors.red,
                      ),
                    _buildDivider(),
                    const SizedBox(height: 4),
                    _buildRow(
                      'Subtotal',
                      subtotal - discountAmount,
                      bold: true,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'VAT (% 5)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                  activeColor: AppTheme.greenColor,
                                  value: p.getIsTaxApply,
                                  onChanged: (v) =>
                                      p.setTax(v ?? false, p.taxPercent),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildRow("", taxAmount, color: Colors.red),
                      ],
                    ),
                    _buildDivider(),
                    const SizedBox(height: 4),
                    _buildRow('Total', total, bold: true),
                    if (depositAlreadyPaid) ...[
                      SizedBox(height: 4),
                      _buildRow('Paid', -depositAmount, color: Colors.red),
                      SizedBox(height: 2),
                      _buildRow('Balance Due', remainingAmount, bold: true),
                    ],
                  ],
                ),

                SizedBox(height: 8),

                // Discount Section
                _buildUltraCompactCard(
                  icon: Icons.local_offer_outlined,
                  title: 'Discount',
                  trailing: p.discountAmount > 0
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF198754),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'OMR ${p.discountAmount.toStringAsFixed(2)} OFF',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: CustomSearchableDropdown(
                              key: ValueKey(
                                'discount_type_${selectedDiscountType.id}',
                              ),
                              hintText: 'Type',
                              value: selectedDiscountType.id,
                              items: {
                                for (var type in DiscountType.types)
                                  type.id: type.name,
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    selectedDiscountType = DiscountType.types
                                        .firstWhere(
                                          (type) => type.id == value,
                                          orElse: () => DiscountType.types[0],
                                        );
                                    discountController.clear();
                                    p.setDiscountAmount(0);
                                    p.setDiscountPercent(0);
                                  });
                                  _updateAllCalculations(p);
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 32,
                            child: TextFormField(
                              controller: discountController,
                              decoration: InputDecoration(
                                hintText:
                                    selectedDiscountType.id == 'percentage'
                                    ? '%'
                                    : 'Amount',
                                hintStyle: TextStyle(fontSize: 11),
                                prefixIcon: Icon(
                                  selectedDiscountType.id == 'percentage'
                                      ? Icons.percent
                                      : Icons.attach_money,
                                  size: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 14),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return null;
                                final discountValue = double.tryParse(value);
                                if (discountValue == null)
                                  return 'Invalid number';
                                if (selectedDiscountType.id == 'percentage') {
                                  if (discountValue > 100)
                                    return 'Cannot exceed 100%';
                                  if (discountValue < 0)
                                    return 'Cannot be negative';
                                } else if (selectedDiscountType.id ==
                                    'amount') {
                                  if (discountValue > subtotal)
                                    return 'Cannot exceed total amount';
                                  if (discountValue < 0)
                                    return 'Cannot be negative';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  final discountValue = double.tryParse(value);
                                  if (discountValue != null) {
                                    if (selectedDiscountType.id ==
                                            'percentage' &&
                                        discountValue > 100) {
                                      discountController.text = '100';
                                      discountController.selection =
                                          TextSelection.collapsed(offset: 3);
                                    } else if (selectedDiscountType.id ==
                                            'amount' &&
                                        discountValue > subtotal) {
                                      discountController.text = subtotal
                                          .toStringAsFixed(2);
                                      discountController.selection =
                                          TextSelection.collapsed(
                                            offset: subtotal
                                                .toStringAsFixed(2)
                                                .length,
                                          );
                                    }
                                  }
                                }
                              },
                              onEditingComplete: () =>
                                  _applyDiscount(p, subtotal),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () => _applyDiscount(p, subtotal),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.greenColor,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size(50, 32),
                            ),
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Employee Commission Section
                // In _buildBookingSummarySection - Replace the commission section with:
                _buildUltraCompactCard(
                  icon: Icons.people_outline,
                  title: 'Employee Commission',
                  checkBoxIcon: Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      activeColor: AppTheme.greenColor,
                      value: p.isCommissionEnabled,
                      onChanged: (value) {
                        p.setCommission(value ?? false);
                        if (value == true) {
                          _showEmployeeCommissionDialog(p);
                        }
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  trailing:
                      p.isCommissionEnabled && p.selectedEmployeeIds.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${p.selectedEmployeeIds.length} employees',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assign Commission',
                          style: TextStyle(fontSize: 14),
                        ),
                        if (p.isCommissionEnabled)
                          IconButton(
                            icon: Icon(Icons.add, size: 18),
                            onPressed: () => _showEmployeeCommissionDialog(p),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                      ],
                    ),
                    if (p.isCommissionEnabled) ...[
                      SizedBox(height: 8),
                      // Commission percentage input
                      TextFormField(
                        initialValue: p.commissionPercentage > 0
                            ? p.commissionPercentage.toString()
                            : '',
                        decoration: InputDecoration(
                          labelText: 'Commission Percentage (%)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          suffixText: '%',
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final percentage = double.tryParse(value) ?? 0;
                            p.setCommissionPercentage(percentage);
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      // Selected employees count
                      Text(
                        '${p.selectedEmployeeIds.length} employees selected',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.purple,
                        ),
                      ),
                      // Selected employee names
                      if (p.selectedEmployeeIds.isNotEmpty) ...[
                        SizedBox(height: 8),
                        ...p.selectedEmployeeIds.map((employeeId) {
                          final employee = employees.firstWhere(
                            (e) => e.id == employeeId,
                            // orElse: () => EmployeeModel(id: '', fullName: 'Unknown'),
                          );
                          return Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• ${employee.name}',
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  ],
                ),

                SizedBox(height: 8),

                // Deposit Section
                if (widget.sale == null)
                  _buildUltraCompactCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Deposit',
                    checkBoxIcon: Transform.scale(
                      scale: 0.9,
                      child: Checkbox(
                        activeColor: AppTheme.greenColor,
                        value: requireDeposit,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              requireDeposit = value ?? false;
                              if (!requireDeposit) {
                                depositAlreadyPaid = false;
                                depositAmount = 0;
                                depositPercentage = 0;
                                depositAmountController.clear();
                              }
                              _updateAllCalculations(p);
                            });
                          }
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    trailing: requireDeposit && depositAmount > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'OMR ${depositAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Require Deposit',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (requireDeposit) ...[
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: CustomSearchableDropdown(
                                  key: ValueKey(
                                    'deposit_type_${selectedDepositType.id}',
                                  ),
                                  hintText: 'Type',
                                  value: selectedDepositType.id,
                                  items: {
                                    for (var type in DepositType.types)
                                      type.id: type.name,
                                  },
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      if (mounted) {
                                        setState(() {
                                          selectedDepositType = DepositType
                                              .types
                                              .firstWhere(
                                                (type) => type.id == value,
                                                orElse: () =>
                                                    DepositType.types[0],
                                              );
                                          if (selectedDepositType.id ==
                                              'percentage') {
                                            depositAmountController.text =
                                                depositPercentage.toString();
                                          } else {
                                            depositAmountController.text =
                                                depositAmount.toStringAsFixed(
                                                  2,
                                                );
                                          }
                                        });
                                      }
                                    }
                                    _updateAllCalculations(p);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 45,
                                child: CustomMmTextField(
                                  controller: depositAmountController,
                                  hintText:
                                      selectedDepositType.id == 'percentage'
                                      ? '%'
                                      : 'Amount',
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  onChanged: (value) {
                                    final val = double.tryParse(value) ?? 0;
                                    if (selectedDepositType.id ==
                                        'percentage') {
                                      depositPercentage = val;
                                    } else {
                                      depositAmount = val;
                                    }
                                    _updateAllCalculations(p);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Already Paid?',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 5),
                            Transform.scale(
                              scale: 0.9,
                              child: Checkbox(
                                activeColor: AppTheme.greenColor,
                                value: isAlreadyPaid,
                                onChanged: (value) {
                                  final newValue = value ?? false;
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted) {
                                      setState(() {
                                        isAlreadyPaid = newValue;
                                        if (!isAlreadyPaid) {
                                          paymentRows = [PaymentRow()];
                                          paymentRows.first.method =
                                              PaymentMethod.methods.firstWhere(
                                                (m) => m.id == 'cash',
                                              );
                                          paymentRows.first.amount = total;
                                        } else {
                                          depositAmount = 0;
                                          depositAlreadyPaid = false;
                                          requireDeposit = false;
                                          depositAmountController.clear();
                                          depositPercentage = 0;
                                        }
                                        _calculateRemainingAmount(total);
                                      });
                                    }
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Multiple Methods?',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 5),
                            Transform.scale(
                              scale: 0.9,
                              child: Checkbox(
                                activeColor: AppTheme.greenColor,
                                value: isMultiple,
                                onChanged: (value) {
                                  if (!isAlreadyPaid) return;
                                  final newValue = value ?? false;
                                  setState(() {
                                    isMultiple = newValue;
                                    if (isMultiple && paymentRows.length == 1) {
                                      paymentRows.add(PaymentRow());
                                      _distributeAmountsEqually(total);
                                    } else if (!isMultiple &&
                                        paymentRows.length > 1) {
                                      paymentRows = [paymentRows.first];
                                      paymentRows.first.amount = total;
                                    }
                                    _calculateRemainingAmount(total);
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        if (!depositAlreadyPaid)
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Next Payment:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                                Text(
                                  'OMR ${depositAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),

                SizedBox(height: 12),

                // Payment Section
                _buildUltraCompactCard(
                  icon: Icons.payment,
                  title: 'Payment',
                  children: [
                    if (depositAlreadyPaid && requireDeposit)
                      _buildRow(
                        'Balance Due',
                        nextPaymentAmount,
                        color: Colors.red,
                        bold: true,
                      ),
                    Row(
                      children: [
                        Text('Already Paid?', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 5),
                        Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            activeColor: AppTheme.greenColor,
                            value: isAlreadyPaid,
                            onChanged: (value) {
                              final newValue = value ?? false;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    isAlreadyPaid = newValue;
                                    if (!isAlreadyPaid) {
                                      paymentRows = [PaymentRow()];
                                      paymentRows.first.method = PaymentMethod
                                          .methods
                                          .firstWhere((m) => m.id == 'cash');
                                      paymentRows.first.amount = total;
                                    } else {
                                      depositAmount = 0;
                                      depositAlreadyPaid = false;
                                      requireDeposit = false;
                                      depositAmountController.clear();
                                      depositPercentage = 0;
                                    }
                                    _calculateRemainingAmount(total);
                                  });
                                }
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Multiple Methods?',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 5),
                        Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            activeColor: AppTheme.greenColor,
                            value: isMultiple,
                            onChanged: (value) {
                              if (!isAlreadyPaid) return;
                              final newValue = value ?? false;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    isMultiple = newValue;
                                    if (isMultiple && paymentRows.length == 1) {
                                      paymentRows.add(PaymentRow());
                                      _distributeAmountsEqually(total);
                                    } else if (!isMultiple &&
                                        paymentRows.length > 1) {
                                      paymentRows = [PaymentRow()];
                                      paymentRows.first.amount = total;
                                      if (paymentRows.isNotEmpty) {
                                        paymentRows.first.method =
                                            paymentRows.first.method;
                                      }
                                    }
                                    _calculateRemainingAmount(total);
                                  });
                                }
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    if (isAlreadyPaid) ...[
                      const SizedBox(height: 8),
                      ...paymentRows.asMap().entries.map((entry) {
                        return _buildPaymentRow(entry.key, total);
                      }).toList(),
                    ],
                    if (isMultiple && isAlreadyPaid) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (paymentRows.length >= 10) return;
                            paymentRows.add(PaymentRow());
                            if (mounted) setState(() {});
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Payment Method'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.greenColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: remainingAmount > 0
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Paid:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${_getCurrentTotalPaid().toStringAsFixed(2)} OMR',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getRemaningText(p),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: remainingAmount > 0
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                              Text(
                                '${_getRemaining(p).toStringAsFixed(2)} OMR',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: remainingAmount > 0
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!_validatePaymentAmounts(total) && isAlreadyPaid)
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Total payment amount exceeds invoice total by ${(_getCurrentTotalPaid() - total).toStringAsFixed(2)} OMR',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 12),

                // Attachment Section
                if (widget.sale == null)
                  _buildUltraCompactCard(
                    icon: Icons.attach_file_sharp,
                    title: 'Attachment',
                    children: [
                      DialogueBoxPicker(
                        showOldRow: false,
                        uploadDocument: true,
                        onFilesPicked: (List<AttachmentModel> files) {
                          setState(() {
                            displayPicture = files;
                          });
                        },
                      ),
                    ],
                  ),

                // Create Invoice Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => _saveInvoice(p, "pending"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: p.loading.value
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.sale != null
                                    ? Icons.update_rounded
                                    : Icons.add_circle_outline_rounded,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                widget.sale != null
                                    ? 'Update Invoice'
                                    : 'Create Invoice',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveInvoice(MaintenanceBookingProvider p, String statusType) async {
    if (!_validatePaymentAmounts(p.grandTotal) && widget.sale == null) {
      return;
    }

    setState(() {
      p.orderLoading = true;
    });

    if (displayPicture.isNotEmpty) {
      await p.getImages(displayPicture);
    }

    double d = double.tryParse(discountController.text) ?? 0;
    List<Map<String, dynamic>> productsData = [];

    try {
      productsData = Constants.buildProductsData(productRows);
      if (productsData.isEmpty) {
        Constants.showValidationError(context, "Items cannot be empty");
        setState(() {
          p.orderLoading = false;
        });
        return;
      }
    } catch (e) {
      setState(() {
        p.orderLoading = false;
      });
      Constants.showValidationError(context, e);
      return;
    }

    final depositData = {
      'requireDeposit': requireDeposit,
      'depositType': selectedDepositType.id,
      'depositAmount': depositAmount,
      'depositPercentage': depositPercentage,
      'nextPaymentAmount': nextPaymentAmount,
    };

    double t = _getCurrentTotalPaid();
    double r = p.grandTotal - t;

    final paymentData = isAlreadyPaid
        ? {
            'isAlreadyPaid': true,
            'paymentMethods': paymentRows
                .map(
                  (row) => {
                    'method': row.method?.id,
                    'methodName': row.method?.name,
                    'reference': row.reference,
                    'amount': row.amount,
                  },
                )
                .toList(),
            'totalPaid': t,
            'remainingAmount': r,
          }
        : {
            'isAlreadyPaid': false,
            'paymentMethods': [],
            'totalPaid': 0,
            'remainingAmount': p.grandTotal,
          };

    // Add commission data
    final commissionData = p.isCommissionEnabled
        ? {
            'isCommissionEnabled': true,
            'commissions': p.employeeCommissions
                .map(
                  (commission) => {
                    'employeeId': commission.employeeId,
                    'type': commission.type,
                    'value': commission.commission,
                    'calculatedAmount': _calculateCommissionAmount(
                      commission,
                      p.grandTotal,
                    ),
                    'status': commission.status,
                  },
                )
                .toList(),
            'totalCommission': p.totalCommission,
          }
        : {
            'isCommissionEnabled': false,
            'commissions': [],
            'totalCommission': 0,
          };

    p.saveBooking(
      productsData: productsData,
      depositData: depositData,
      context: context,
      onBack: widget.onBack!.call,
      isEdit: widget.sale != null,
      total: p.grandTotal,
      discount: d,
      taxAmount: p.taxAmount,
      paymentData: paymentData,
      sale: widget.sale,
      statusType: statusType,
    );
  }

  // Helper methods
  Widget _buildUltraCompactCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
    Widget? checkBoxIcon,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFE9ECEF), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Color(0xFF495057)),
              SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                ),
              ),
              if (checkBoxIcon != null) ...[SizedBox(width: 4), checkBoxIcon],
              if (trailing != null) ...[Spacer(), trailing],
            ],
          ),
          SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    double amount, {
    Color? color,
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: color ?? Color(0xFF495057),
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} OMR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: color ?? Color(0xFF212529),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 0.5,
      color: Color(0xFFDEE2E6),
    );
  }

  Widget _buildPaymentRow(int index, double grandTotal) {
    final paymentRow = paymentRows[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomSearchableDropdown(
              key: ValueKey('payment_method_${index}_${paymentRows.length}'),
              hintText: 'Method',
              items: {for (var m in PaymentMethod.methods) m.id: m.name},
              value: paymentRow.method?.id,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final newMethod = PaymentMethod.methods.firstWhere(
                    (m) => m.id == value,
                  );
                  paymentRow.method = newMethod;
                  if (value == 'multiple' && paymentRows.length == 1) {
                    paymentRows.add(PaymentRow());
                    _distributeAmountsEqually(grandTotal);
                    if (mounted) setState(() {});
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              key: ValueKey('payment_ref_$index'),
              initialValue: paymentRow.reference,
              decoration: const InputDecoration(
                labelText: 'Reference',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              onChanged: (value) => paymentRow.reference = value,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextFormField(
              key: ValueKey('payment_amount_$index'),
              initialValue: paymentRow.amount > 0
                  ? paymentRow.amount.toStringAsFixed(2)
                  : '',
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              readOnly: !isMultiple && paymentRows.length == 1,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final newAmount = double.tryParse(value) ?? 0.0;
                  paymentRow.amount = newAmount;
                } else {
                  paymentRow.amount = 0.0;
                }
              },
              onEditingComplete: () {
                if (isMultiple) _validateAndRecalculate(grandTotal);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          if (isMultiple && paymentRows.length > 1)
            IconButton(
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 20,
              ),
              onPressed: () {
                paymentRows.removeAt(index);
                _distributeAmountsEqually(grandTotal);
                if (mounted) setState(() {});
              },
            ),
        ],
      ),
    );
  }

  void _validateAndRecalculate(double grandTotal) {
    if (!isMultiple) return;
    final totalPaid = _getCurrentTotalPaid();
    if (totalPaid > grandTotal) {
      double excess = totalPaid - grandTotal;
      _adjustPaymentAmounts(grandTotal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Total payment amount adjusted to not exceed invoice total',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
    _calculateRemainingAmount(grandTotal);
    if (mounted) setState(() {});
  }

  void _adjustPaymentAmounts(double grandTotal) {
    final totalPaid = _getCurrentTotalPaid();
    if (totalPaid <= grandTotal) return;
    final ratio = grandTotal / totalPaid;
    for (var row in paymentRows) {
      row.amount *= ratio;
    }
  }

  void _distributeAmountsEqually(double grandTotal) {
    if (!isMultiple || paymentRows.isEmpty) return;
    final equalAmount = grandTotal / paymentRows.length;
    for (var i = 0; i < paymentRows.length; i++) {
      paymentRows[i].amount = equalAmount;
    }
  }

  void _initializePaymentRows(double grandTotal) {
    if (isAlreadyPaid) {
      if (isMultiple && paymentRows.length > 1) {
        _distributeAmountsEqually(grandTotal);
      } else {
        if (paymentRows.isNotEmpty) {
          paymentRows.first.amount = grandTotal;
        }
      }
    }
  }

  bool _validatePaymentAmounts(double grandTotal) {
    final totalPaid = _getCurrentTotalPaid();
    return totalPaid <= grandTotal;
  }

  String getRemaningText(MaintenanceBookingProvider p) {
    String d = "";
    double previousTotal = 0;
    double paid = _getCurrentTotalPaid();
    d = 'Remaining Balance';
    if (widget.sale != null) {
      previousTotal = widget.sale!.total!;
    }
    if (widget.sale != null && previousTotal > p.grandTotal) {
      paid > p.grandTotal;
      d = "Over Paid";
    }
    return d;
  }

  double _getRemaining(MaintenanceBookingProvider p) {
    double paid = _getCurrentTotalPaid();
    double remaining = p.grandTotal - paid;
    return remaining;
  }
}

// ProductRowWidget class remains the same as in your original code
class ProductRowWidget extends StatefulWidget {
  final ProductRow productRow;
  final List<SaleItem> allItems;
  final int index;
  final Function(ProductRow) onUpdate;
  final VoidCallback onRemove;
  final bool showRemoveButton;

  const ProductRowWidget({
    super.key,
    required this.productRow,
    required this.allItems,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.showRemoveButton,
  });

  @override
  State<ProductRowWidget> createState() => _ProductRowWidgetState();
}

class _ProductRowWidgetState extends State<ProductRowWidget> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _qtyFocusNode = FocusNode();
  double _originalPrice = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _priceFocusNode.addListener(_onPriceFocusChange);
  }

  @override
  void dispose() {
    _priceFocusNode.removeListener(_onPriceFocusChange);
    _priceController.dispose();
    _qtyController.dispose();
    _priceFocusNode.dispose();
    _qtyFocusNode.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    if (widget.productRow.type == 'service') {
      _priceController.text =
          widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
      _originalPrice = widget.productRow.selectedPrice ?? 0;
    } else {
      _priceController.text =
          widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '0';
      _originalPrice = widget.productRow.sellingPrice ?? 0;
    }
    _qtyController.text = widget.productRow.quantity.toString();
  }

  void _onPriceFocusChange() {
    if (!_priceFocusNode.hasFocus) {
      _validateAndUpdatePrice();
    }
  }

  void _validateAndUpdatePrice() {
    final newPrice = double.tryParse(_priceController.text) ?? 0;
    final minimumPrice = widget.productRow.saleItem?.minimumPrice ?? 0;
    final sellingPrice = widget.productRow.saleItem?.sellingPrice ?? 0;

    if (newPrice < minimumPrice) {
      _showMinimumPriceError(minimumPrice);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _priceController.text = sellingPrice.toStringAsFixed(2);
            _updatePriceInModel(sellingPrice);
          });
        }
      });
    } else {
      _updatePriceInModel(newPrice);
    }
  }

  void _updatePriceInModel(double newPrice) {
    if (widget.productRow.type == 'service') {
      widget.productRow.selectedPrice = newPrice;
    } else {
      widget.productRow.sellingPrice = newPrice;
      if (widget.productRow.cost > 0) {
        widget.productRow.margin =
            ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
            100;
      }
    }
    widget.productRow.calculateTotals();
    widget.onUpdate(widget.productRow);
  }

  void _showMinimumPriceError(double minimumPrice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Price cannot be less than minimum price: OMR ${minimumPrice.toStringAsFixed(2)}',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildProductDropdown() {
    final Map<String, String> itemMap = {};
    for (var item in widget.allItems) {
      String displayName = item.productName;
      if (item.type == 'service') {
        displayName = '⚡ $displayName (Service)';
      } else {
        displayName = '📦 $displayName (Product)';
      }
      itemMap[item.productId] = displayName;
    }

    return CustomSearchableDropdown(
      key: widget.productRow.dropdownKey,
      hintText: 'Select Item',
      items: itemMap,
      value: widget.productRow.saleItem?.productId,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final selected = widget.allItems.firstWhere(
            (item) => item.productId == value,
          );
          if (mounted) {
            setState(() {
              widget.productRow.saleItem = selected;
              widget.productRow.type = selected.type;
              if (selected.type == 'service') {
                widget.productRow.selectedPrice = selected.sellingPrice;
                widget.productRow.sellingPrice = null;
                widget.productRow.cost = selected.cost;
                _priceController.text = selected.sellingPrice.toStringAsFixed(
                  2,
                );
              } else {
                widget.productRow.sellingPrice = selected.sellingPrice;
                _priceController.text = selected.sellingPrice.toStringAsFixed(
                  2,
                );
                widget.productRow.cost = selected.cost;
                widget.productRow.margin = selected.cost > 0
                    ? ((selected.sellingPrice - selected.cost) /
                              selected.cost) *
                          100
                    : 0;
              }
              _originalPrice = selected.sellingPrice;
              widget.productRow.calculateTotals();
              widget.onUpdate(widget.productRow);
              FocusScope.of(context).requestFocus(_qtyFocusNode);
            });
          }
        }
      },
    );
  }

  Widget _buildPriceInput() {
    return TextFormField(
      key: widget.productRow.priceKey,
      controller: _priceController,
      focusNode: _priceFocusNode,
      enabled: true,
      decoration: InputDecoration(
        labelText: 'Price (OMR)',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final newPrice = double.tryParse(value) ?? 0;
          final minimumPrice = widget.productRow.saleItem?.minimumPrice ?? 0;
          if (newPrice >= minimumPrice) {
            _updatePriceInModel(newPrice);
          }
        }
      },
      onEditingComplete: () {
        _validateAndUpdatePrice();
        FocusScope.of(context).requestFocus(_qtyFocusNode);
      },
      onFieldSubmitted: (value) {
        _validateAndUpdatePrice();
      },
    );
  }

  Widget _buildQuantityInput() {
    return TextFormField(
      key: widget.productRow.quantityKey,
      controller: _qtyController,
      focusNode: _qtyFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Qty',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
      ],
      validator: (value) {
        final error = ValidationUtils.quantity(value);
        return error;
      },
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final quantity = int.tryParse(value) ?? 0;
          if (quantity == 0) {
            _qtyController.text = "1";
            widget.productRow.quantity = 1;
          }
          if (quantity > 0 && quantity <= 999999) {
            if (mounted) {
              setState(() {
                widget.productRow.quantity = quantity;
                widget.productRow.calculateTotals();
                widget.onUpdate(widget.productRow);
              });
            }
          }
        } else {
          _qtyController.text = "1";
          widget.productRow.quantity = 1;
          if (mounted) {
            setState(() {
              widget.productRow.quantity = 1;
              widget.productRow.calculateTotals();
              widget.onUpdate(widget.productRow);
            });
          }
        }
      },
      onEditingComplete: () {
        final value = _qtyController.text;
        final quantity = int.tryParse(value) ?? 0;
        if (quantity < 1) {
          if (mounted) {
            setState(() {
              widget.productRow.quantity = 1;
              _qtyController.text = '1';
              widget.productRow.calculateTotals();
              widget.onUpdate(widget.productRow);
            });
          }
        }
        _qtyFocusNode.unfocus();
      },
    );
  }

  Widget _buildDiscountInput() {
    return TextFormField(
      key: widget.productRow.discountKey,
      initialValue: widget.productRow.discount.toString(),
      decoration: const InputDecoration(
        labelText: 'Discount %',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        suffixText: '%',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      validator: (value) {
        final error = ValidationUtils.discount(value);
        return error;
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        if (value.isNotEmpty) {
          final discount = double.tryParse(value) ?? 0;
          if (mounted) {
            setState(() {
              widget.productRow.discount = discount;
              widget.productRow.calculateTotals();
              widget.onUpdate(widget.productRow);
            });
          }
        }
      },
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildAmountDisplay(String amount, {bool isTotal = false}) {
    return Text(
      amount,
      style: TextStyle(
        fontSize: 12,
        fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
        color: isTotal ? AppTheme.primaryColor : Colors.black,
      ),
    );
  }

  @override
  void didUpdateWidget(ProductRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productRow != widget.productRow) {
      _initializeControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _buildProductDropdown()),
          const SizedBox(width: 8),
          Expanded(flex: 1, child: _buildPriceInput()),
          const SizedBox(width: 8),
          Expanded(flex: 1, child: _buildQuantityInput()),
          const SizedBox(width: 8),
          Expanded(flex: 1, child: _buildDiscountInput()),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: _buildAmountDisplay(
              'OMR ${widget.productRow.subtotal.toStringAsFixed(2)}',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: _buildAmountDisplay(
              'OMR ${widget.productRow.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ),
          const SizedBox(width: 8),
          if (widget.showRemoveButton)
            IconButton(
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 20,
              ),
              onPressed: widget.onRemove,
            ),
        ],
      ),
    );
  }
}
