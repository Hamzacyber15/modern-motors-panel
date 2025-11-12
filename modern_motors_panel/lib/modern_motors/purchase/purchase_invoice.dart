import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/purchase_models/expense_category_model.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
import 'package:modern_motors_panel/model/sales_model/credit_days_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/model/supplier/supplier_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/purchase_invoice_provider.dart';
import 'package:modern_motors_panel/widgets/dialogue_box_picker.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

mixin PerformanceOptimizer on State<PurchaseInvoice> {
  final Map<String, Timer> _timers = {};

  void debouncedSetState(String key, Duration duration, VoidCallback callback) {
    _timers[key]?.cancel();
    _timers[key] = Timer(duration, () {
      if (mounted) {
        setState(callback);
      }
    });
  }

  @override
  void dispose() {
    _timers.forEach((key, timer) => timer.cancel());
    _timers.clear();
    super.dispose();
  }
}

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

class ExpenseType {
  final String id;
  final String name;

  ExpenseType({required this.id, required this.name});

  static List<ExpenseType> get types => [
    ExpenseType(id: 'freight', name: 'Freight'),
    ExpenseType(id: 'handling', name: 'Handling'),
    ExpenseType(id: 'bundle', name: 'Bundle'),
    ExpenseType(id: 'other', name: 'Other'),
  ];
}

class BillExpense {
  ExpenseType? type;
  SupplierModel? supplier;
  double amount = 0;
  String description = '';
  bool includeInProductCost = false;
  String? vatType;
  double vatAmount = 0;

  BillExpense({
    this.type,
    this.supplier,
    this.amount = 0,
    this.description = '',
    this.includeInProductCost = true,
    this.vatType = 'none', // Default to none
    this.vatAmount = 0,
  });

  void calculateVat() {
    switch (vatType) {
      case 'standard':
        vatAmount = amount * 0.05;
        break;
      case 'zero':
      case 'exempt':
      case 'none':
      default:
        vatAmount = 0.0;
        break;
    }
  }
}

class ProductRow {
  PurchaseItem? purchaseItem;
  String? type;
  double? avgPrice;
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
  double serviceCost = 0;
  String? serviceType;
  String? vatType; // 'standard', 'zero', 'exempt', 'none'
  String? supplierId;
  bool? addToPurchaseCost = false;
  String discountType = 'percentage';
  Key? vatKey;
  late Key dropdownKey;
  late Key priceKey;
  late Key quantityKey;
  late Key discountKey;
  late Key serviceCostKey;
  late Key serviceTypeKey;
  String? directExpenseVatType = 'none';
  double directExpenseVatAmount = 0;

  ProductRow({
    this.total = 0,
    this.subtotal = 0,
    this.purchaseItem,
    this.type,
    this.avgPrice,
    this.selectedPrice,
    this.quantity = 1,
    this.discount = 0,
    this.applyVat = true,
    this.cost = 0,
    this.serviceCost = 0,
    this.serviceType,
    this.vatType,
    this.directExpenseVatType = 'none', // Add this
    this.directExpenseVatAmount = 0,
  }) {
    dropdownKey = UniqueKey();
    priceKey = UniqueKey();
    quantityKey = UniqueKey();
    discountKey = UniqueKey();
    serviceCostKey = UniqueKey();
    serviceTypeKey = UniqueKey();
  }

  void calculateTotals() {
    // Ensure no null values
    final price = (avgPrice ?? selectedPrice ?? 0.0);
    final qty = quantity;

    // Calculate subtotal
    subtotal = price * qty;

    // Apply discount based on type
    double discountAmount = 0.0;
    if (discountType == 'percentage') {
      discountAmount = subtotal * ((discount ?? 0.0) / 100);
    } else {
      discountAmount = discount ?? 0.0; // Fixed amount
    }

    double amountAfterDiscount = subtotal - discountAmount;

    // Calculate VAT for this row only (no bill-level VAT)
    switch (vatType) {
      case 'standard':
        vatAmount = amountAfterDiscount * 0.05;
        break;
      case 'zero':
      case 'exempt':
      case 'none':
      default:
        vatAmount = 0.0;
        break;
    }

    // Ensure direct expense VAT is properly calculated
    if (serviceCost > 0 && directExpenseVatType == 'standard') {
      directExpenseVatAmount = serviceCost * 0.05;
    } else {
      directExpenseVatAmount =
          0.0; // Explicitly set to 0 when no expense or non-standard VAT
    }

    // Calculate total for this row (includes row-level VAT, excludes direct expenses from product total)
    total = amountAfterDiscount + vatAmount;
  }
}

class PurchaseInvoice extends StatefulWidget {
  final VoidCallback? onBack;
  final NewPurchaseModel? purchase;
  final List<ProductModel>? products;
  final String? type;
  const PurchaseInvoice({
    super.key,
    this.onBack,
    this.purchase,
    this.products,
    this.type,
  });

  @override
  State<PurchaseInvoice> createState() => _PurchaseInvoiceState();
}

class _PurchaseInvoiceState extends State<PurchaseInvoice>
    with PerformanceOptimizer {
  final supplierNameController = TextEditingController();
  final discountController = TextEditingController();
  final depositAmountController = TextEditingController();

  // Data
  List<SupplierModel> allSuppliers = [];
  List<SupplierModel> filteredSuppliers = [];
  List<ServiceTypeModel> allServices = [];
  List<ProductModel> allProducts = [];
  List<ExpenseCategoryModel> expensesList = [];
  CreditDaysModel? creditDays;
  List<ProductRow> productRows = [];
  double productsGrandTotal = 0;
  bool loading = false;
  double servicesGrandTotal = 0;
  List<PurchaseItem> purchaseItem = [];
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
  Timer? _calculationTimer;
  String selectSupplierId = "";

  // New fields for bill-level expenses
  List<BillExpense> billExpenses = [];
  List<SupplierModel> expensesSuppliers = [];
  double billExpensesTotal = 0;
  bool includeExpensesInProductCost = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<PurchaseInvoiceProvider>();
      p.clearData();
      DateTime t = DateTime.now();
      if (widget.purchase == null) {
        p.setBookingTime(t);
      } else {
        p.setBookingTime(widget.purchase!.createdAt);
      }
    });
    if (widget.purchase == null) {
      productRows.add(ProductRow());
    }
    _loadInitialData();
  }

  @override
  void dispose() {
    supplierNameController.dispose();
    discountController.dispose();
    depositAmountController.dispose();
    _calculationTimer?.cancel();
    super.dispose();
  }

  void _debouncedCalculateRemaining(double grandTotal) {
    _calculationTimer?.cancel();
    _calculationTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _calculateRemainingAmount(grandTotal);
        });
      }
    });
  }

  Future<void> _loadInitialData() async {
    if (mounted) {
      setState(() => _isLoadingDiscounts = true);
    }
    if (widget.purchase == null) {
      var value = await Constants.getUniqueNumberValue("purchase");
      if (value != null) {
        invNumber = value;
      } else {
        invNumber = 1;
      }
    } else {
      invNumber = double.parse(widget.purchase!.invoice);
    }

    try {
      final results = await Future.wait([
        DataFetchService.fetchSuppliers(),
        DataFetchService.fetchAllProducts(),
        DataFetchService.getCreditDays(),
        DataFetchService.fetchExpenseCategories(),
      ]);
      allSuppliers = results[0] as List<SupplierModel>;
      allProducts = results[1] as List<ProductModel>;
      creditDays = results[2] as CreditDaysModel;
      expensesList = results[3] as List<ExpenseCategoryModel>;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget.purchase != null) {
          SupplierModel? supplier;
          supplier = allSuppliers.firstWhere(
            (item) => item.id == widget.purchase!.supplierId,
          );
          supplierNameController.text = supplier.supplierName;
          final p = context.read<PurchaseInvoiceProvider>();
          p.setCustomer(id: widget.purchase!.supplierId);
          for (var element in widget.purchase!.items) {
            productRows.add(
              ProductRow(
                purchaseItem: element,
                type: element.type,
                avgPrice: element.buyingPrice,
                quantity: element.quantity,
                total: element.totalPrice,
                subtotal: element.discount + element.totalPrice,
                discount: element.discount,
                serviceCost: 0,
              ),
            );
          }
          discountController.text = widget.purchase!.discount.toString();
          p.getValues(widget.purchase!.taxAmount, widget.purchase!.total!);
          p.discountType = widget.purchase!.discountType;
          if (widget.purchase!.discountType == 'percentage') {
            selectedDiscountType = DiscountType.types[0];
            p.discountType = selectedDiscountType.id;
            p.setDiscountPercent(widget.purchase!.discount);
          } else {
            selectedDiscountType = DiscountType.types[1];
            p.discountType = selectedDiscountType.id;
            p.setDiscountPercent(widget.purchase!.discount);
          }
          productsGrandTotal = productRows.fold(
            0,
            (sum, row) => sum + row.total,
          );

          // Load payment data if exists
          if (widget.purchase!.paymentData.paymentMethods.isNotEmpty) {
            isAlreadyPaid = true;
            paymentRows.clear();

            isMultiple = widget.purchase!.paymentData.paymentMethods.length > 1;

            for (
              var i = 0;
              i < widget.purchase!.paymentData.paymentMethods.length;
              i++
            ) {
              final element = widget.purchase!.paymentData.paymentMethods[i];
              PaymentMethod? paymentMethod;
              try {
                paymentMethod = PaymentMethod.methods.firstWhere(
                  (method) =>
                      method.id.toLowerCase() == element.method.toLowerCase(),
                );
              } catch (e) {
                paymentMethod = PaymentMethod(
                  id: element.method,
                  name: element.method,
                );
              }
              final newPaymentRow = PaymentRow(
                method: paymentMethod,
                reference: element.reference,
                amount: element.amount,
              );
              paymentRows.add(newPaymentRow);
            }
          }

          _applyDiscount(p, _getSubtotalForDiscount());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              final double total = _calculateTotal(p);
              _calculateRemainingAmount(total);
              setState(() {});
            }
          });
        }
      });
      purchaseItem = mergeProductsAndServices(allProducts, expensesList);
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

  // double _getSubtotalForDiscount() {
  //   return productsGrandTotal + billExpensesTotal;
  // }

  double _getSubtotalForDiscount() {
    // Calculate products subtotal without VAT
    double productsSubtotal = productRows.fold(0.0, (sum, row) {
      // Calculate row subtotal without VAT
      final price = (row.avgPrice ?? row.selectedPrice ?? 0.0);
      final qty = row.quantity;
      double rowSubtotal = price * qty;

      // Apply discount to get amount after discount (without VAT)
      double discountAmount = 0.0;
      if (row.discountType == 'percentage') {
        discountAmount = rowSubtotal * ((row.discount ?? 0.0) / 100);
      } else {
        discountAmount = row.discount ?? 0.0;
      }

      double amountAfterDiscount = rowSubtotal - discountAmount;

      // Add service cost (without its VAT)
      amountAfterDiscount += row.serviceCost;

      return sum + amountAfterDiscount;
    });

    // Calculate bill expenses subtotal without VAT
    double expensesSubtotal = billExpenses.fold(0.0, (sum, expense) {
      return sum + expense.amount; // Just the base amount, not including VAT
    });

    return productsSubtotal + expensesSubtotal;
  }

  // double _calculateTotal(PurchaseInvoiceProvider p) {
  //   final double subtotal = _getSubtotalForDiscount() + billExpensesTotal;
  //   final double discountAmount = p.discountAmount;
  //   final double amountAfterDiscount = subtotal - discountAmount;
  //   // final double taxAmount = p.getIsTaxApply
  //   //     ? amountAfterDiscount * (p.taxPercent / 100)
  //   //     : 0;
  //   final double totalVatAmount = _calculateTotalVatAmount();
  //   return amountAfterDiscount + totalVatAmount; //taxAmount;
  // }

  double _calculateTotal(PurchaseInvoiceProvider p) {
    // Calculate subtotal (products + bill expenses)
    final double subtotal = _getSubtotalForDiscount();

    // Apply discount
    final double discountAmount = p.discountAmount;
    final double amountAfterDiscount = subtotal - discountAmount;

    // Return the amount after discount (VAT is already included in row totals)
    return amountAfterDiscount;
  }

  List<PurchaseItem> mergeProductsAndServices(
    List<ProductModel> products,
    List<ExpenseCategoryModel> expenses,
  ) {
    List<PurchaseItem> mergedList = [];

    mergedList.addAll(
      products.map(
        (product) => PurchaseItem(
          buyingPrice: 0,
          discountType: "",
          subtotal: 0,
          amountAfterDiscount: 0,
          total: 0,
          vatType: "",
          vatAmount: 0,
          addToPurchaseCost: false,
          directExpense: DirectExpense.empty(),
          discount: 0,
          productId: product.id ?? '',
          productName: product.productName ?? '',
          quantity: 1,
          totalPrice: (product.sellingPrice ?? product.lastCost ?? 0) * 1,
          unitPrice: product.averageCost ?? product.lastCost ?? 0,
          type: 'product',
        ),
      ),
    );
    mergedList.addAll(
      expenses.map((expense) {
        return PurchaseItem(
          buyingPrice: 0,
          discountType: "",
          subtotal: 0,
          amountAfterDiscount: 0,
          total: 0,
          vatType: "",
          vatAmount: 0,
          addToPurchaseCost: false,
          directExpense: DirectExpense.empty(),
          discount: 0,
          productId: expense.id ?? '',
          productName: expense.name ?? 'Expense', // Use expense name
          quantity: 1,
          totalPrice: 0, // Default to 0, user will enter amount
          unitPrice: 0, // Default to 0
          type: 'expense', // Mark as expense type
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

  void _addBillExpense(PurchaseInvoiceProvider p) {
    if (mounted) {
      setState(() {
        billExpenses.add(BillExpense());
        _calculateBillExpensesTotal(p);
        _updateAllCalculations(context.read<PurchaseInvoiceProvider>());
      });
    }
  }

  void _removeBillExpense(int index, PurchaseInvoiceProvider p) {
    if (mounted) {
      setState(() {
        billExpenses.removeAt(index);
        _calculateBillExpensesTotal(p);
        _updateAllCalculations(context.read<PurchaseInvoiceProvider>());
      });
    }
  }

  void _calculateBillExpensesTotal(PurchaseInvoiceProvider p) {
    double expensesSubtotal = billExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    double vatTotal = billExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.vatAmount,
    );

    billExpensesTotal = expensesSubtotal + vatTotal;
    p.billExpenseTotal = billExpensesTotal;
  }

  void _updateBillExpense(
    int index,
    BillExpense updatedExpense,
    PurchaseInvoiceProvider p,
  ) {
    if (mounted) {
      setState(() {
        billExpenses[index] = updatedExpense;
        _calculateBillExpensesTotal(p);
        _updateAllCalculations(context.read<PurchaseInvoiceProvider>());
      });
    }
  }

  double _getRemainingAmount(double grandTotal) {
    double paidAmount = paymentRows.fold(
      0.0,
      (sum, row) => sum + (row.amount ?? 0),
    );
    return grandTotal - paidAmount;
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

  // void _updateAllCalculations(PurchaseInvoiceProvider p) {
  //   if (!mounted) return;
  //   final double total = _calculateTotal(p);
  //   _updateDepositCalculation(total, p);
  // }

  void _updateAllCalculations(PurchaseInvoiceProvider p) {
    if (!mounted) return;

    // Calculate total VAT from rows only
    final double totalVatAmount = _calculateTotalVatAmount();

    // Update provider with row-level VAT only
    p.taxAmount = totalVatAmount;

    final double total = _calculateTotal(p);
    _updateDepositCalculation(total, p);
  }

  void _updateDepositCalculation(double grandTotal, PurchaseInvoiceProvider p) {
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

  void _applyDiscount(PurchaseInvoiceProvider p, double subtotal) {
    final discountValue = double.tryParse(discountController.text) ?? 0;
    p.discountType = selectedDiscountType.id;

    if (selectedDiscountType.id == 'percentage') {
      p.setDiscountPercent(discountValue);
    } else {
      // For amount discount, calculate the percentage based on the subtotal
      final discountPercent = subtotal > 0
          ? (discountValue / subtotal) * 100
          : 0;
      p.setDiscountPercent(discountPercent.toDouble());
    }
    _updateAllCalculations(p);
  }

  void _removeProductRow(int index, PurchaseInvoiceProvider p) {
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
    PurchaseInvoiceProvider p,
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
    final p = context.read<PurchaseInvoiceProvider>();
    p.setProductsTotal(productsGrandTotal);
  }

  Widget _productSelectionSection(
    BuildContext context,
    PurchaseInvoiceProvider p,
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
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productRows.length,
              itemBuilder: (context, index) {
                return ProductRowWidget(
                  supplierList: allSuppliers,
                  productRow: productRows[index],
                  allItems: purchaseItem,
                  index: index,
                  onUpdate: (updatedRow) =>
                      _updateProductRow(index, updatedRow, p),
                  onRemove: () => _removeProductRow(index, p),
                  showRemoveButton: true,
                  defaultSupplierId: p.supplierId,
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

  Widget _billExpensesSection(BuildContext context, PurchaseInvoiceProvider p) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Other Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: billExpenses.length,
              itemBuilder: (context, index) {
                return BillExpenseRowWidget(
                  supplierList: allSuppliers,
                  expense: billExpenses[index],
                  index: index,
                  onUpdate: (updatedExpense) =>
                      _updateBillExpense(index, updatedExpense, p),
                  onRemove: () => _removeBillExpense(index, p),
                  defaultSupplierId: p.supplierId,
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _addBillExpense(p),
                icon: const Icon(Icons.add),
                label: const Text('Add Bill Expense'),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bill Expenses Total:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'OMR ${billExpensesTotal.toStringAsFixed(2)}',
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

  Future<void> _pickBookingDate(PurchaseInvoiceProvider p) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: p.purchaseDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      if (!mounted) return;
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(p.purchaseDate),
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
      child: Consumer<PurchaseInvoiceProvider>(
        builder: (context, p, _) {
          return SingleChildScrollView(
            child: Form(
              key: p.createBookingKey,
              child: OverlayLoader(
                loader: _isLoadingDiscounts,
                child: Column(
                  children: [
                    PageHeaderWidget(
                      title: 'Create Purchase Invoice',
                      buttonText: 'Back to Invoices',
                      subTitle: 'Create Invoice',
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
                              _billExpensesSection(context, p),
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

  Widget _topCard(BuildContext context, PurchaseInvoiceProvider p) {
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
                          double d =
                              double.tryParse(discountController.text) ?? 0;
                          final productsData = _buildProductsData();
                          final expensesData = _buildExpensesData();
                          final depositData = {
                            'requireDeposit': requireDeposit,
                            'depositType': selectedDepositType.id,
                            'depositAmount': depositAmount,
                            'depositPercentage': depositPercentage,
                            'nextPaymentAmount': nextPaymentAmount,
                          };
                          // final paymentData = isAlreadyPaid
                          //     ? {
                          //         'isAlreadyPaid': true,
                          //         'paymentMethods': paymentRows
                          //             .map(
                          //               (row) => {
                          //                 'method': row.method?.id,
                          //                 'methodName': row.method?.name,
                          //                 'reference': row.reference,
                          //                 'amount': row.amount,
                          //               },
                          //             )
                          //             .toList(),
                          //         'totalPaid': paymentRows.fold(
                          //           0,
                          //           (sum, row) => sum + row.amount as int,
                          //         ),
                          //         'remainingAmount': remainingAmount,
                          //       }
                          //     : {
                          //         'isAlreadyPaid': false,
                          //         'paymentMethods': [],
                          //         'totalPaid': 0,
                          //         'remainingAmount': p.total,
                          //       };
                          final paymentData = isAlreadyPaid
                              ? {
                                  'isAlreadyPaid': true,
                                  'paymentMethods': paymentRows.map((row) {
                                    return {
                                      'method': row.method?.id ?? 'cash',
                                      'methodName': row.method?.name ?? 'Cash',
                                      'reference': row.reference ?? '',
                                      'amount': row.amount ?? 0.0,
                                    };
                                  }).toList(),
                                  'totalPaid': _getCurrentTotalPaid(),
                                  'remainingAmount': remainingAmount,
                                }
                              : {
                                  'isAlreadyPaid': false,
                                  'paymentMethods': [],
                                  'totalPaid': 0.0,
                                  'remainingAmount': p.total,
                                };
                          // final NewPurchaseModel saleDetails =
                          //     Constants.parseToPurchaseModel(
                          //       productsData: productsData,
                          //       // expensesData: expensesData,
                          //       depositData: depositData,
                          //       paymentData: paymentData,
                          //       totalRevenue: p.total,
                          //       discount: d,
                          //       taxAmount: p.taxAmount,
                          //       supplierId: p.supplierId!,
                          //       isEdit: false,
                          //     );
                          // saleTemplate(saleDetails);
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
                          double d =
                              double.tryParse(discountController.text) ?? 0;
                          final productsData = _buildProductsData();
                          final expensesData = _buildExpensesData();
                          final depositData = {
                            'requireDeposit': requireDeposit,
                            'depositType': selectedDepositType.id,
                            'depositAmount': depositAmount,
                            'depositPercentage': depositPercentage,
                            'nextPaymentAmount': nextPaymentAmount,
                          };
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
                                  'totalPaid': paymentRows.fold(
                                    0,
                                    (sum, row) => sum + row.amount as int,
                                  ),
                                  'remainingAmount': remainingAmount,
                                }
                              : {
                                  'isAlreadyPaid': false,
                                  'paymentMethods': [],
                                  'totalPaid': 0,
                                  'remainingAmount': p.total,
                                };

                          p.savePurchase(
                            productsData: productsData,
                            expensesData: expensesData,
                            depositData: depositData,
                            context: context,
                            // onBack: widget.onBack!.call,
                            isEdit: widget.purchase != null,
                            total: p.grandTotal,
                            discount: d,
                            taxAmount: p.taxAmount,
                            paymentData: paymentData,
                            statusType: "draft",
                          );
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
                Expanded(
                  child: Column(
                    children: [
                      CustomMmTextField(
                        labelText: 'Supplier Name',
                        hintText: 'Supplier Name',
                        controller: supplierNameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: ValidationUtils.customerName,
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              filteredSuppliers = allSuppliers
                                  .where(
                                    (c) => c.supplierName
                                        .toLowerCase()
                                        .contains(value.toLowerCase()),
                                  )
                                  .toList();
                            } else {
                              filteredSuppliers = [];
                            }
                          });
                        },
                      ),
                      if (filteredSuppliers.isNotEmpty)
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
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ListView.builder(
                                itemCount: filteredSuppliers.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final c = filteredSuppliers[index];
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
                                          child: Text(c.supplierName),
                                        ),
                                        onTap: () {
                                          p.setCustomer(id: c.id!);
                                          setState(() {
                                            supplierNameController.text =
                                                c.supplierName;
                                            filteredSuppliers.clear();
                                          });
                                        },
                                      ),
                                      if (index != filteredSuppliers.length - 1)
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
                Expanded(child: _buildCreditDropdown(p)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // List<Map<String, dynamic>> _buildProductsData() {
  //   return productRows.map((row) {
  //     return {
  //       'type': row.purchaseItem?.type,
  //       'productId': row.purchaseItem?.productId,
  //       'productName': row.purchaseItem?.productName,
  //       'avgPrice': row.avgPrice,
  //       'quantity': row.quantity,
  //       'discount': row.discount,
  //       'applyVat': row.applyVat,
  //       'subtotal': row.subtotal,
  //       'vatAmount': row.vatAmount,
  //       'total': row.total,
  //       'profit': row.profit,
  //       'cost': row.cost,
  //       'serviceCost': row.serviceCost,
  //       'serviceType': row.serviceType,
  //     };
  //   }).toList();
  // }

  List<Map<String, dynamic>> _buildProductsData() {
    return productRows.map((row) {
      return {
        'type': row.purchaseItem?.type ?? 'product',
        'productId': row.purchaseItem?.productId ?? '',
        'productName': row.purchaseItem?.productName ?? '',
        'avgPrice': row.avgPrice ?? 0.0,
        'selectedPrice': row.selectedPrice ?? 0.0,
        'quantity': row.quantity,
        'discount': row.discount,
        'applyVat': row.applyVat,
        'subtotal': row.subtotal,
        'vatAmount': row.vatAmount,
        'total': row.total,
        'profit': row.profit,
        'cost': row.cost ?? 0.0,
        'serviceCost': row.serviceCost,
        'serviceType': row.serviceType ?? '',
        'vatType': row.vatType ?? 'none',
        'supplierId': row.supplierId ?? '',
        'addToPurchaseCost': row.addToPurchaseCost ?? false,
        'discountType': row.discountType,
        'sellingPrice': row.avgPrice ?? row.selectedPrice ?? 0.0,
        'isExpense': row.purchaseItem?.type == 'expense',
      };
    }).toList();
  }

  List<Map<String, dynamic>> _buildExpensesData() {
    return billExpenses.map((expense) {
      return {
        'type': expense.type?.id ?? '',
        'typeName': expense.type?.name ?? '',
        'amount': expense.amount,
        'description': expense.description,
        'supplierId': expense.supplier?.id ?? '',
        'vatType': expense.vatType ?? 'none',
        'vatAmount': expense.vatAmount,
        'includeInProductCost': false, //expense.includeInProductCost,
      };
    }).toList();
  }

  // List<Map<String, dynamic>> _buildExpensesData() {
  //   return billExpenses.map((expense) {
  //     return {
  //       'type': expense.type?.id,
  //       'typeName': expense.type?.name,
  //       'amount': expense.amount,
  //       'description': expense.description,
  //       'includeInProductCost': expense.includeInProductCost,
  //     };
  //   }).toList();
  // }

  double _getCurrentTotalPaid() {
    double total = 0.0;
    for (var row in paymentRows) {
      total += row.amount;
    }
    return total;
  }

  bool _validatePaymentAmounts(double grandTotal) {
    final totalPaid = _getCurrentTotalPaid();
    return totalPaid <= grandTotal;
  }

  void _validateAndRecalculate(double grandTotal) {
    if (!isMultiple) return;

    final totalPaid = _getCurrentTotalPaid();

    if (totalPaid > grandTotal) {
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

  Widget _buildPaymentRow(int index, double grandTotal) {
    final paymentRow = paymentRows[index];
    return StatefulBuilder(
      builder: (context, setLocalState) {
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
                  key: ValueKey(
                    'payment_method_${index}_${paymentRows.length}',
                  ),
                  hintText: 'Method',
                  items: {for (var m in PaymentMethod.methods) m.id: m.name},
                  value: paymentRow.method?.id,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final newMethod = PaymentMethod.methods.firstWhere(
                        (m) => m.id == value,
                      );
                      setLocalState(() => paymentRow.method = newMethod);
                      if (value == 'multiple' && paymentRows.length == 1) {
                        setState(() {
                          paymentRows.add(PaymentRow());
                          _distributeAmountsEqually(grandTotal);
                        });
                      } else {
                        _debouncedCalculateRemaining(grandTotal);
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
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  readOnly: !isMultiple && paymentRows.length == 1,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final newAmount = double.tryParse(value) ?? 0.0;
                      setLocalState(() => paymentRow.amount = newAmount);
                    } else {
                      setLocalState(() => paymentRow.amount = 0.0);
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
                    setState(() {
                      paymentRows.removeAt(index);
                      _distributeAmountsEqually(grandTotal);
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreditDropdown(PurchaseInvoiceProvider provider) {
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
        if (value.isNotEmpty && mounted) {
          setState(() => selectedCreditDays = int.parse(value));
        }
      },
    );
  }

  Widget _middleRow(BuildContext context, PurchaseInvoiceProvider p) {
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

  // double _calculateTotalVatAmount() {
  //   // Calculate VAT from product rows
  //   double productVatTotal = productRows.fold(0.0, (sum, row) {
  //     return sum + (row.vatAmount ?? 0.0);
  //   });

  //   // Calculate VAT from bill expenses
  //   double expenseVatTotal = billExpenses.fold(0.0, (sum, expense) {
  //     return sum + (expense.vatAmount ?? 0.0);
  //   });

  //   // Calculate VAT from direct expenses in product rows
  //   double directExpenseVatTotal = productRows.fold(0.0, (sum, row) {
  //     return sum + (row.directExpenseVatAmount ?? 0.0);
  //   });

  //   return productVatTotal + expenseVatTotal + directExpenseVatTotal;
  // }

  double _calculateTotalVatAmount() {
    // Calculate VAT from product rows
    double productVatTotal = productRows.fold(0.0, (sum, row) {
      return sum + (row.vatAmount ?? 0.0);
    });

    // Calculate VAT from bill expenses
    double expenseVatTotal = billExpenses.fold(0.0, (sum, expense) {
      return sum + (expense.vatAmount ?? 0.0);
    });

    // Calculate VAT from direct expenses in product rows
    double directExpenseVatTotal = productRows.fold(0.0, (sum, row) {
      return sum + (row.directExpenseVatAmount ?? 0.0);
    });

    return productVatTotal + expenseVatTotal + directExpenseVatTotal;
  }

  double _getProductsSubtotal() {
    return productRows.fold(0.0, (sum, row) {
      final price = (row.avgPrice ?? row.selectedPrice ?? 0.0);
      final qty = row.quantity;
      return sum + (price * qty);
    });
  }

  double _getProductsDiscount() {
    return productRows.fold(0.0, (sum, row) {
      final price = (row.avgPrice ?? row.selectedPrice ?? 0.0);
      final qty = row.quantity;
      final rowSubtotal = price * qty;

      double discountAmount = 0.0;
      if (row.discountType == 'percentage') {
        discountAmount = rowSubtotal * ((row.discount ?? 0.0) / 100);
      } else {
        discountAmount = row.discount ?? 0.0;
      }

      return sum + discountAmount;
    });
  }

  double _getDirectExpensesSubtotal() {
    return productRows.fold(0.0, (sum, row) {
      // Sum only the base direct expenses (without VAT)
      return sum + row.serviceCost;
    });
  }

  double _getOtherExpensesSubtotal() {
    return billExpenses.fold(0.0, (sum, expense) {
      return sum + expense.amount;
    });
  }

  double _calculateProductsVat() {
    return productRows.fold(0.0, (sum, row) {
      return sum + (row.vatAmount ?? 0.0);
    });
  }

  double _calculateDirectExpensesVat() {
    return productRows.fold(0.0, (sum, row) {
      return sum + (row.directExpenseVatAmount ?? 0.0);
    });
  }

  double _calculateOtherExpensesVat() {
    return billExpenses.fold(0.0, (sum, expense) {
      return sum + (expense.vatAmount ?? 0.0);
    });
  }

  // double _calculateProductsTotal(
  //   double subtotal,
  //   double vat,
  //   PurchaseInvoiceProvider p,
  // ) {
  //   final discountAmount = p.discountAmount;
  //   return (subtotal - discountAmount) + vat;
  // }

  double _calculateProductsTotal() {
    return productRows.fold(0.0, (sum, row) {
      // Only include product costs, not direct expenses
      return sum + row.total;
    });
  }

  // double _calculateDirectExpensesTotal(
  //   double subtotal,
  //   double vat,
  //   PurchaseInvoiceProvider p,
  // ) {
  //   // Apply discount logic for direct expenses if needed
  //   return subtotal + vat;
  // }

  double _calculateOtherExpensesTotal(
    double subtotal,
    double vat,
    PurchaseInvoiceProvider p,
  ) {
    // Apply discount logic for other expenses if needed
    return subtotal + vat;
  }

  double _calculateDirectExpensesTotal() {
    return productRows.fold(0.0, (sum, row) {
      // Sum all direct expenses from product rows + their VAT
      return sum + row.serviceCost + row.directExpenseVatAmount;
    });
  }

  double _calculateDirectExpensesVatTotal() {
    return productRows.fold(0.0, (sum, row) {
      // Sum all direct expenses VAT from product rows
      return sum + row.directExpenseVatAmount;
    });
  }

  Widget _buildBookingSummarySection(
    BuildContext context,
    PurchaseInvoiceProvider p,
  ) {
    // final double subtotal = _getSubtotalForDiscount();
    p.itemsTotal = productsGrandTotal;

    // final double subtotal = _getSubtotalForDiscount();

    // // final double discountAmount = p.discountAmount;
    // // final double amountAfterDiscount = subtotal - discountAmount;
    // final double discountAmount = p.discountAmount;
    // final double amountAfterDiscount = subtotal - discountAmount;

    // final double totalVatAmount = _calculateTotalVatAmount();

    // // final double taxAmount = p.getIsTaxApply
    // //     ? amountAfterDiscount * (p.taxPercent / 100)
    // //     : 0;
    // // final double total = amountAfterDiscount + taxAmount;
    // // p.grandTotal = total;
    // final double total = amountAfterDiscount; // + totalVatAmount;
    // p.grandTotal = total;
    // p.taxAmount = totalVatAmount;
    final double productsSubtotal = _getProductsSubtotal();
    final double productsDiscount = _getProductsDiscount();
    final double productsAmountAfterDiscount =
        productsSubtotal - productsDiscount;
    final double directExpensesSubtotal = _getDirectExpensesSubtotal();
    final double directExpensesTotal = _calculateDirectExpensesTotal();
    final double otherExpensesSubtotal = _getOtherExpensesSubtotal();

    // Calculate VAT for each section
    final double productsVat = _calculateProductsVat();
    final double directExpensesVat = _calculateDirectExpensesVat();
    final double otherExpensesVat = _calculateOtherExpensesVat();

    // Calculate totals for each section (after discount and VAT)
    final double productsTotal = _calculateProductsTotal(
      // productsSubtotal,
      // productsVat,
      // p,
    );
    final double otherExpensesTotal = _calculateOtherExpensesTotal(
      otherExpensesSubtotal,
      otherExpensesVat,
      p,
    );

    // Grand total
    final double grandTotal =
        productsTotal + directExpensesTotal + otherExpensesTotal;
    p.grandTotal = grandTotal;
    final double total = grandTotal;
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          p.setServicesTotal(servicesGrandTotal);
          p.setSubtotal(grandTotal);
        }
      });
    }
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
                // _buildUltraCompactCard(
                //   icon: Icons.inventory_2_outlined,
                //   title: 'Items',
                //   children: [
                //     _buildRow('Products Total', productsGrandTotal),
                //     if (billExpensesTotal > 0)
                //       _buildRow('Bill Expenses', billExpensesTotal),
                //     if (p.discountAmount > 0)
                //       _buildRow(
                //         'Discount',
                //         -p.discountAmount,
                //         color: Colors.red,
                //       ),
                //     _buildDivider(),
                //     const SizedBox(height: 4),
                //     _buildRow('Subtotal', subtotal, bold: true),
                //     if (discountAmount > 0)
                //       _buildRow('Discount', -discountAmount, color: Colors.red),
                //     _buildRow("Amount After Discount", amountAfterDiscount),
                //     _buildRow("Total VAT", totalVatAmount, color: Colors.green),
                //     _buildDivider(),
                //     _buildRow('GRAND TOTAL', total, bold: true),
                //     SizedBox(height: 4),
                //     // Row(
                //     //mainAxisAlignment: MainAxisAlignment.end,
                //     //  children: [
                //     // Expanded(
                //     //   child: Row(
                //     //     children: [
                //     //       Text(
                //     //         'VAT (% 5)',
                //     //         style: TextStyle(
                //     //           fontSize: 14,
                //     //           fontWeight: FontWeight.w400,
                //     //           color: Colors.red,
                //     //         ),
                //     //       ),
                //     //       const SizedBox(width: 5),
                //     //       Transform.scale(
                //     //         scale: 0.9,
                //     //         child: Checkbox(
                //     //           activeColor: AppTheme.greenColor,
                //     //           value: p.getIsTaxApply,
                //     //           onChanged: (v) =>
                //     //               p.setTax(v ?? false, p.taxPercent),
                //     //           materialTapTargetSize:
                //     //               MaterialTapTargetSize.shrinkWrap,
                //     //         ),
                //     //       ),
                //     //     ],
                //     //   ),
                //     // ),
                //     //  _buildRow("VAT", totalVatAmount, color: Colors.red),
                //     // ],
                //     // ),
                //     _buildDivider(),
                //     const SizedBox(height: 4),
                //     //  _buildRow('Total', total, bold: true),
                //     if (depositAlreadyPaid) ...[
                //       SizedBox(height: 4),
                //       _buildRow('Paid', -depositAmount, color: Colors.red),
                //       SizedBox(height: 2),
                //       _buildRow('Balance Due', remainingAmount, bold: true),
                //     ],
                //   ],
                // ),
                // _buildUltraCompactCard(
                //   icon: Icons.inventory_2_outlined,
                //   title: 'Products',
                //   children: [
                //     _buildRow('Products Subtotal', productsSubtotal),
                //     // if (p.discountAmount > 0)
                //     //   _buildRow(
                //     //     'Products Discount',
                //     //     -p.discountAmount,
                //     //     color: Colors.red,
                //     //   ),
                //     if (productsDiscount > 0)
                //       _buildRow(
                //         'Products Discount',
                //         -productsDiscount,
                //         color: Colors.red,
                //       ),
                //     _buildRow(
                //       'Amount After Discount',
                //       productsAmountAfterDiscount,
                //     ),
                //     _buildRow("Products VAT", productsVat, color: Colors.green),
                //     _buildDivider(),
                //     _buildRow('Products Total', productsTotal, bold: true),
                //   ],
                // ),
                _buildUltraCompactCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Products',
                  children: [
                    _buildRow('Products Subtotal', productsSubtotal),
                    if (productsDiscount > 0)
                      _buildRow(
                        'Products Discount',
                        -productsDiscount,
                        color: Colors.red,
                      ),
                    _buildRow(
                      'Amount After Discount',
                      productsAmountAfterDiscount,
                    ),
                    _buildRow("Products VAT", productsVat, color: Colors.green),
                    _buildDivider(),
                    _buildRow('Products Total', productsTotal, bold: true),
                  ],
                ),
                SizedBox(height: 8),

                // DIRECT EXPENSES SECTION
                _buildUltraCompactCard(
                  icon: Icons.receipt_long,
                  title: 'Direct Expenses',
                  children: [
                    _buildRow('Direct Expenses', directExpensesSubtotal),
                    _buildRow(
                      "Direct Expenses VAT",
                      directExpensesVat,
                      color: Colors.green,
                    ),
                    _buildDivider(),
                    _buildRow(
                      'Direct Expenses Total',
                      directExpensesTotal,
                      bold: true,
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // OTHER EXPENSES SECTION
                _buildUltraCompactCard(
                  icon: Icons.attach_money,
                  title: 'Other Expenses',
                  children: [
                    _buildRow('Other Expenses Subtotal', otherExpensesSubtotal),
                    // Add other expenses discount logic if needed
                    // _buildRow('Other Expenses Discount', -otherExpensesDiscount, color: Colors.red),
                    _buildRow(
                      "Other Expenses VAT",
                      otherExpensesVat,
                      color: Colors.green,
                    ),
                    _buildDivider(),
                    _buildRow(
                      'Other Expenses Total',
                      otherExpensesTotal,
                      bold: true,
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // GRAND TOTAL SECTION
                _buildUltraCompactCard(
                  icon: Icons.summarize,
                  title: 'Grand Total',
                  children: [
                    _buildRow('Products Total', productsTotal),
                    _buildRow('Direct Expenses Total', directExpensesTotal),
                    _buildRow('Other Expenses Total', otherExpensesTotal),
                    _buildDivider(),
                    _buildRow('GRAND TOTAL', grandTotal, bold: true),
                  ],
                ),
                SizedBox(height: 8),
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
                        // Expanded(
                        //   flex: 2,
                        //   child: SizedBox(
                        //     height: 32,
                        //     child: TextFormField(
                        //       controller: discountController,
                        //       decoration: InputDecoration(
                        //         hintText:
                        //             selectedDiscountType.id == 'percentage'
                        //             ? '%'
                        //             : 'Amount',
                        //         hintStyle: TextStyle(fontSize: 11),
                        //         prefixIcon: Icon(
                        //           selectedDiscountType.id == 'percentage'
                        //               ? Icons.percent
                        //               : Icons.attach_money,
                        //           size: 14,
                        //         ),
                        //         border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(6),
                        //         ),
                        //         contentPadding: EdgeInsets.symmetric(
                        //           horizontal: 8,
                        //           vertical: 4,
                        //         ),
                        //         isDense: true,
                        //       ),
                        //       style: TextStyle(fontSize: 14),
                        //       keyboardType: TextInputType.numberWithOptions(
                        //         decimal: true,
                        //       ),
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) return null;
                        //         final discountValue = double.tryParse(value);
                        //         if (discountValue == null) {
                        //           return 'Invalid number';
                        //         }

                        //         if (selectedDiscountType.id == 'percentage') {
                        //           if (discountValue > 100) {
                        //             return 'Cannot exceed 100%';
                        //           }
                        //           if (discountValue < 0) {
                        //             return 'Cannot be negative';
                        //           }
                        //         } else if (selectedDiscountType.id ==
                        //             'amount') {
                        //           if (discountValue > subtotal) {
                        //             return 'Cannot exceed total amount';
                        //           }
                        //           if (discountValue < 0) {
                        //             return 'Cannot be negative';
                        //           }
                        //         }
                        //         return null;
                        //       },
                        //       onChanged: (value) {
                        //         if (value.isNotEmpty) {
                        //           final discountValue = double.tryParse(value);
                        //           if (discountValue != null) {
                        //             if (selectedDiscountType.id ==
                        //                     'percentage' &&
                        //                 discountValue > 100) {
                        //               discountController.text = '100';
                        //               discountController.selection =
                        //                   TextSelection.collapsed(offset: 3);
                        //             } else if (selectedDiscountType.id ==
                        //                     'amount' &&
                        //                 discountValue > subtotal) {
                        //               discountController.text = subtotal
                        //                   .toStringAsFixed(2);
                        //               discountController.selection =
                        //                   TextSelection.collapsed(
                        //                     offset: subtotal
                        //                         .toStringAsFixed(2)
                        //                         .length,
                        //                   );
                        //             }
                        //           }
                        //         }
                        //       },
                        //       onEditingComplete: () =>
                        //           _applyDiscount(p, subtotal),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 6),
                        // SizedBox(
                        //   height: 32,
                        //   child: ElevatedButton(
                        //     onPressed: () => _applyDiscount(p, subtotal),
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppTheme.greenColor,
                        //       padding: EdgeInsets.symmetric(horizontal: 8),
                        //       minimumSize: Size(50, 32),
                        //     ),
                        //     child: Text(
                        //       'Apply',
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
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
                        Text('Require Deposit', style: TextStyle(fontSize: 14)),
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
                                        selectedDepositType = DepositType.types
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
                                              depositAmount.toStringAsFixed(2);
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
                                hintText: selectedDepositType.id == 'percentage'
                                    ? '%'
                                    : 'Amount',
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                onChanged: (value) {
                                  final val = double.tryParse(value) ?? 0;
                                  if (selectedDepositType.id == 'percentage') {
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
                          Text('Already Paid?', style: TextStyle(fontSize: 14)),
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
                                        paymentRows.first.method = PaymentMethod
                                            .methods
                                            .firstWhere((m) => m.id == 'cash');
                                        paymentRows.first.amount = total;
                                      } else {
                                        _initializePaymentRows(total);
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
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted) {
                                    setState(() {
                                      isMultiple = newValue;
                                      if (isMultiple &&
                                          paymentRows.length == 1) {
                                        paymentRows.add(PaymentRow());
                                        _distributeAmountsEqually(total);
                                      } else if (!isMultiple &&
                                          paymentRows.length > 1) {
                                        paymentRows = [paymentRows.first];
                                        paymentRows.first.amount = total;
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
                                      paymentRows = [paymentRows.first];
                                      paymentRows.first.amount = total;
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
                      ...paymentRows
                          .asMap()
                          .entries
                          .map((entry) => _buildPaymentRow(entry.key, total))
                          .toList(),
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
                                'Remaining Balance:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: remainingAmount > 0
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                              Text(
                                '${remainingAmount.toStringAsFixed(2)} OMR',
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
                _buildUltraCompactCard(
                  icon: Icons.attach_file_sharp,
                  title: 'Attachment',
                  children: [
                    DialogueBoxPicker(
                      showOldRow: false,
                      uploadDocument: true,
                      onFilesPicked: (List<AttachmentModel> files) {
                        setState(() => displayPicture = files);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() => p.orderLoading = true);

                      try {
                        // Prepare data with proper validation
                        List<Map<String, dynamic>> productsData =
                            _buildProductsData();
                        List<Map<String, dynamic>> expensesData =
                            _buildExpensesData();
                        final depositData = {
                          'requireDeposit': requireDeposit,
                          'depositType': selectedDepositType.id,
                          'depositAmount': depositAmount,
                          'depositPercentage': depositPercentage,
                          'nextPaymentAmount': nextPaymentAmount,
                        };

                        final paymentData = isAlreadyPaid
                            ? {
                                'isAlreadyPaid': true,
                                'paymentMethods': paymentRows.map((row) {
                                  return {
                                    'method': row.method?.id ?? 'cash',
                                    'methodName': row.method?.name ?? 'Cash',
                                    'reference': row.reference,
                                    'amount': row.amount,
                                  };
                                }).toList(),
                                'totalPaid': _getCurrentTotalPaid(),
                                'remainingAmount': remainingAmount,
                              }
                            : {
                                'isAlreadyPaid': false,
                                'paymentMethods': [],
                                'totalPaid': 0.0,
                                'remainingAmount': total,
                              };

                        double d =
                            double.tryParse(discountController.text) ?? 0.0;

                        // Call the save method
                        await p.savePurchase(
                          productsData: productsData,
                          expensesData: expensesData,
                          depositData: depositData,
                          context: context,
                          isEdit: widget.purchase != null,
                          total: total,
                          discount: d,
                          onBack: widget.onBack!.call,
                          taxAmount:
                              _calculateTotalVatAmount(), //totalVatAmount,
                          paymentData: paymentData,
                          statusType: "pending", //"save",
                        );
                      } catch (e) {
                        setState(() => p.orderLoading = false);
                        if (context.mounted) {
                          Constants.showValidationError(
                            context,
                            "Failed to save: ${e.toString()}",
                          );
                        }
                      }
                    },
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
                                widget.purchase != null
                                    ? Icons.update_rounded
                                    : Icons.add_circle_outline_rounded,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                widget.purchase != null
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
}

// ProductRowWidget and BillExpenseRowWidget classes remain the same as in the previous code
// They are included in the complete solution but omitted here for brevity

// class ProductRowWidget extends StatefulWidget {
//   final ProductRow productRow;
//   final List<PurchaseItem> allItems;
//   final int index;
//   final Function(ProductRow) onUpdate;
//   final VoidCallback onRemove;
//   final bool showRemoveButton;
//   const ProductRowWidget({
//     super.key,
//     required this.productRow,
//     required this.allItems,
//     required this.index,
//     required this.onUpdate,
//     required this.onRemove,
//     required this.showRemoveButton,
//   });

//   @override
//   State<ProductRowWidget> createState() => _ProductRowWidgetState();
// }

// class _ProductRowWidgetState extends State<ProductRowWidget> {
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _qtyController = TextEditingController();
//   final TextEditingController _serviceCostController = TextEditingController();
//   final FocusNode _priceFocusNode = FocusNode();
//   final FocusNode _qtyFocusNode = FocusNode();
//   double _originalPrice = 0;
//   Timer? _updateTimer;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _priceFocusNode.addListener(_onPriceFocusChange);
//   }

//   @override
//   void dispose() {
//     _priceFocusNode.removeListener(_onPriceFocusChange);
//     _priceController.dispose();
//     _serviceCostController.dispose();
//     _qtyController.dispose();
//     _priceFocusNode.dispose();
//     _qtyFocusNode.dispose();
//     _updateTimer?.cancel();
//     super.dispose();
//   }

//   void _initializeControllers() {
//     if (widget.productRow.type == 'service') {
//       _priceController.text =
//           widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
//       _originalPrice = widget.productRow.selectedPrice ?? 0;
//     } else {
//       _priceController.text =
//           widget.productRow.avgPrice?.toStringAsFixed(2) ?? '0';
//       _originalPrice = widget.productRow.avgPrice ?? 0;
//     }
//     _qtyController.text = widget.productRow.quantity.toString();
//     _serviceCostController.text = widget.productRow.serviceCost.toStringAsFixed(
//       2,
//     );
//   }

//   void _onPriceFocusChange() {
//     if (!_priceFocusNode.hasFocus) _validateAndUpdatePrice();
//   }

//   void _validateAndUpdatePrice() {
//     final newPrice = double.tryParse(_priceController.text) ?? 0;
//     final minimumPrice = widget.productRow.purchaseItem?.minimumPrice ?? 0;
//     final sellingPrice = widget.productRow.purchaseItem?.sellingPrice ?? 0;
//     if (newPrice < minimumPrice) {
//       _showMinimumPriceError(minimumPrice);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           setState(() {
//             _priceController.text = sellingPrice.toStringAsFixed(2);
//             _updatePriceInModel(sellingPrice);
//           });
//         }
//       });
//     } else {
//       _updatePriceInModel(newPrice);
//     }
//   }

//   void _updatePriceInModel(double newPrice) {
//     if (widget.productRow.type == 'service') {
//       widget.productRow.selectedPrice = newPrice;
//     } else {
//       widget.productRow.avgPrice = newPrice;
//       if (widget.productRow.cost > 0) {
//         widget.productRow.margin =
//             ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
//             100;
//       }
//     }
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateServiceCostInModel(double serviceCost) {
//     widget.productRow.serviceCost = serviceCost;
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateServiceTypeInModel(String serviceType) {
//     widget.productRow.serviceType = serviceType;
//     _updateProductWithDebounce();
//   }

//   void _updateProductWithDebounce() {
//     widget.productRow.calculateTotals();
//     _updateTimer?.cancel();
//     _updateTimer = Timer(
//       const Duration(milliseconds: 500),
//       () => widget.onUpdate(widget.productRow),
//     );
//   }

//   void _showMinimumPriceError(double minimumPrice) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Price cannot be less than minimum price: OMR ${minimumPrice.toStringAsFixed(2)}',
//         ),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Widget _buildProductDropdown() {
//     final Map<String, String> itemMap = {};
//     for (var item in widget.allItems) {
//       String displayName = item.productName;
//       if (item.type == 'service') {
//         displayName = '⚡ $displayName (Service)';
//       } else {
//         displayName = '📦 $displayName (Product)';
//       }
//       itemMap[item.productId] = displayName;
//     }
//     return CustomSearchableDropdown(
//       key: widget.productRow.dropdownKey,
//       hintText: 'Select Item',
//       items: itemMap,
//       value: widget.productRow.purchaseItem?.productId,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final selected = widget.allItems.firstWhere(
//             (item) => item.productId == value,
//           );
//           if (mounted) {
//             setState(() {
//               widget.productRow.purchaseItem = selected;
//               widget.productRow.type = selected.type;
//               widget.productRow.avgPrice = selected.sellingPrice;
//               _priceController.text = selected.sellingPrice.toStringAsFixed(2);
//               widget.productRow.cost = selected.cost;
//               widget.productRow.margin = selected.cost > 0
//                   ? ((selected.sellingPrice - selected.cost) / selected.cost) *
//                         100
//                   : 0;
//               _originalPrice = selected.sellingPrice;
//               widget.productRow.calculateTotals();
//               widget.onUpdate(widget.productRow);
//               FocusScope.of(context).requestFocus(_qtyFocusNode);
//             });
//           }
//         }
//       },
//     );
//   }

//   Widget _buildServiceTypeDropdown() {
//     final Map<String, String> expenseTypes = {};
//     for (var type in ExpenseType.types) {
//       expenseTypes[type.id] = type.name;
//     }
//     return CustomSearchableDropdown(
//       key: widget.productRow.serviceTypeKey,
//       hintText: 'Expense Type',
//       items: expenseTypes,
//       value: widget.productRow.serviceType,
//       onChanged: (value) {
//         if (value.isNotEmpty && mounted) {
//           setState(() => _updateServiceTypeInModel(value));
//         }
//       },
//     );
//   }

//   Widget _buildServiceCostInput() {
//     return TextFormField(
//       key: widget.productRow.serviceCostKey,
//       controller: _serviceCostController,
//       decoration: InputDecoration(
//         labelText: 'Expense (OMR)',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       textInputAction: TextInputAction.next,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           _updateServiceCostInModel(double.tryParse(value) ?? 0);
//         }
//       },
//       onEditingComplete: () => FocusScope.of(context).unfocus(),
//     );
//   }

//   Widget _buildPriceInput() {
//     return TextFormField(
//       key: widget.productRow.priceKey,
//       controller: _priceController,
//       focusNode: _priceFocusNode,
//       enabled: true,
//       decoration: InputDecoration(
//         labelText: 'Price (OMR)',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       textInputAction: TextInputAction.next,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final newPrice = double.tryParse(value) ?? 0;
//           final minimumPrice =
//               widget.productRow.purchaseItem?.minimumPrice ?? 0;
//           if (newPrice >= minimumPrice) _updatePriceInModel(newPrice);
//         }
//       },
//       onEditingComplete: () {
//         _validateAndUpdatePrice();
//         FocusScope.of(context).requestFocus(_qtyFocusNode);
//       },
//       onFieldSubmitted: (value) => _validateAndUpdatePrice(),
//     );
//   }

//   Widget _buildQuantityInput() {
//     return TextFormField(
//       key: widget.productRow.quantityKey,
//       controller: _qtyController,
//       focusNode: _qtyFocusNode,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       decoration: const InputDecoration(
//         labelText: 'Qty',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(5),
//       ],
//       validator: (value) => ValidationUtils.quantity(value),
//       keyboardType: TextInputType.number,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final quantity = int.tryParse(value) ?? 0;
//           if (quantity == 0) {
//             _qtyController.text = "1";
//             widget.productRow.quantity = 1;
//           }
//           if (quantity > 0 && quantity <= 999999 && mounted) {
//             setState(() {
//               widget.productRow.quantity = quantity;
//               widget.productRow.calculateTotals();
//               _updateProductWithDebounce();
//             });
//           }
//         } else {
//           _qtyController.text = "1";
//           widget.productRow.quantity = 1;
//           if (mounted) {
//             setState(() {
//               widget.productRow.quantity = 1;
//               widget.productRow.calculateTotals();
//               _updateProductWithDebounce();
//             });
//           }
//         }
//       },
//       onEditingComplete: () {
//         final value = _qtyController.text;
//         final quantity = int.tryParse(value) ?? 0;
//         if (quantity < 1 && mounted) {
//           setState(() {
//             widget.productRow.quantity = 1;
//             _qtyController.text = '1';
//             widget.productRow.calculateTotals();
//             widget.onUpdate(widget.productRow);
//           });
//         }
//         _qtyFocusNode.unfocus();
//       },
//     );
//   }

//   Widget _buildDiscountInput() {
//     return TextFormField(
//       key: widget.productRow.discountKey,
//       initialValue: widget.productRow.discount.toString(),
//       decoration: const InputDecoration(
//         labelText: 'Discount %',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         suffixText: '%',
//       ),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(2),
//       ],
//       validator: (value) => ValidationUtils.discount(value),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       onChanged: (value) {
//         if (value.isNotEmpty && mounted) {
//           setState(() {
//             widget.productRow.discount = double.tryParse(value) ?? 0;
//             widget.productRow.calculateTotals();
//             _updateProductWithDebounce();
//           });
//         }
//       },
//       onEditingComplete: () => FocusScope.of(context).unfocus(),
//     );
//   }

//   Widget _buildStaticAmountDisplay(
//     double amount,
//     String label, {
//     bool isTotal = false,
//   }) {
//     return Tooltip(
//       message: label,
//       child: Text(
//         'OMR ${amount.toStringAsFixed(2)}',
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//           color: isTotal ? AppTheme.primaryColor : Colors.black,
//         ),
//       ),
//     );
//   }

//   @override
//   void didUpdateWidget(ProductRowWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.productRow != widget.productRow) _initializeControllers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         children: [
//           Expanded(flex: 2, child: _buildProductDropdown()),
//           const SizedBox(width: 8),
//           Expanded(flex: 1, child: _buildPriceInput()),
//           const SizedBox(width: 8),
//           Expanded(flex: 1, child: _buildQuantityInput()),
//           const SizedBox(width: 8),
//           Expanded(flex: 1, child: _buildDiscountInput()),
//           const SizedBox(width: 8),
//           Expanded(flex: 1, child: _buildServiceCostInput()),
//           const SizedBox(width: 8),
//           Expanded(flex: 1, child: _buildServiceTypeDropdown()),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 1,
//             child: _buildStaticAmountDisplay(
//               widget.productRow.subtotal,
//               'Subtotal',
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 1,
//             child: _buildStaticAmountDisplay(
//               widget.productRow.total,
//               'Total',
//               isTotal: true,
//             ),
//           ),
//           const SizedBox(width: 8),
//           if (widget.showRemoveButton)
//             IconButton(
//               icon: const Icon(
//                 Icons.remove_circle,
//                 color: Colors.red,
//                 size: 20,
//               ),
//               onPressed: widget.onRemove,
//             ),
//         ],
//       ),
//     );
//   }
// }

// class ProductRowWidget extends StatefulWidget {
//   final ProductRow productRow;
//   final List<PurchaseItem> allItems;
//   final int index;
//   final Function(ProductRow) onUpdate;
//   final VoidCallback onRemove;
//   final bool showRemoveButton;
//   const ProductRowWidget({
//     super.key,
//     required this.productRow,
//     required this.allItems,
//     required this.index,
//     required this.onUpdate,
//     required this.onRemove,
//     required this.showRemoveButton,
//   });

//   @override
//   State<ProductRowWidget> createState() => _ProductRowWidgetState();
// }

// class _ProductRowWidgetState extends State<ProductRowWidget> {
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _qtyController = TextEditingController();
//   final TextEditingController _serviceCostController = TextEditingController();
//   final TextEditingController _discountAmountController =
//       TextEditingController();
//   final FocusNode _priceFocusNode = FocusNode();
//   final FocusNode _qtyFocusNode = FocusNode();
//   double _originalPrice = 0;
//   Timer? _updateTimer;

//   // VAT options
//   final Map<String, String> vatOptions = {
//     'standard': '5%',
//     'zero': '0%',
//     'exempt': 'Exempt',
//     'none': 'None',
//   };

//   // Discount type options
//   final Map<String, String> discountTypes = {
//     'percentage': '%',
//     'amount': 'OMR',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _priceFocusNode.addListener(_onPriceFocusChange);
//   }

//   @override
//   void dispose() {
//     _priceFocusNode.removeListener(_onPriceFocusChange);
//     _priceController.dispose();
//     _serviceCostController.dispose();
//     _qtyController.dispose();
//     _discountAmountController.dispose();
//     _priceFocusNode.dispose();
//     _qtyFocusNode.dispose();
//     _updateTimer?.cancel();
//     super.dispose();
//   }

//   void _initializeControllers() {
//     if (widget.productRow.type == 'service') {
//       _priceController.text =
//           widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
//       _originalPrice = widget.productRow.selectedPrice ?? 0;
//     } else {
//       _priceController.text =
//           widget.productRow.avgPrice?.toStringAsFixed(2) ?? '0';
//       _originalPrice = widget.productRow.avgPrice ?? 0;
//     }
//     _qtyController.text = widget.productRow.quantity.toString();
//     _serviceCostController.text = widget.productRow.serviceCost.toStringAsFixed(
//       2,
//     );
//     _discountAmountController.text = widget.productRow.discount.toString();
//   }

//   void _onPriceFocusChange() {
//     if (!_priceFocusNode.hasFocus) _validateAndUpdatePrice();
//   }

//   void _validateAndUpdatePrice() {
//     final newPrice = double.tryParse(_priceController.text) ?? 0;
//     final minimumPrice = widget.productRow.purchaseItem?.minimumPrice ?? 0;
//     final sellingPrice = widget.productRow.purchaseItem?.sellingPrice ?? 0;
//     if (newPrice < minimumPrice) {
//       _showMinimumPriceError(minimumPrice);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           setState(() {
//             _priceController.text = sellingPrice.toStringAsFixed(2);
//             _updatePriceInModel(sellingPrice);
//           });
//         }
//       });
//     } else {
//       _updatePriceInModel(newPrice);
//     }
//   }

//   void _updatePriceInModel(double newPrice) {
//     if (widget.productRow.type == 'service') {
//       widget.productRow.selectedPrice = newPrice;
//     } else {
//       widget.productRow.avgPrice = newPrice;
//       if (widget.productRow.cost > 0) {
//         widget.productRow.margin =
//             ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
//             100;
//       }
//     }
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateServiceCostInModel(double serviceCost) {
//     widget.productRow.serviceCost = serviceCost;
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateServiceTypeInModel(String serviceType) {
//     widget.productRow.serviceType = serviceType;
//     _updateProductWithDebounce();
//   }

//   void _updateVatTypeInModel(String vatType) {
//     widget.productRow.vatType = vatType;

//     // Calculate VAT amount based on type
//     switch (vatType) {
//       case 'standard':
//         widget.productRow.vatAmount = widget.productRow.subtotal * 0.05;
//         break;
//       case 'zero':
//       case 'exempt':
//       case 'none':
//         widget.productRow.vatAmount = 0.0;
//         break;
//     }

//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateDiscountTypeInModel(String discountType) {
//     widget.productRow.discountType = discountType;

//     // Convert discount value when switching types
//     if (discountType == 'percentage' && widget.productRow.discount > 100) {
//       // If switching from amount to percentage and value is too high, cap at 100%
//       widget.productRow.discount = 100.0;
//       _discountAmountController.text = '100';
//     }

//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateDiscountInModel(String value) {
//     if (value.isEmpty) {
//       widget.productRow.discount = 0.0;
//     } else {
//       final discountValue = double.tryParse(value) ?? 0.0;

//       if (widget.productRow.discountType == 'percentage' &&
//           discountValue > 100) {
//         // Cap percentage discount at 100%
//         widget.productRow.discount = 100.0;
//         _discountAmountController.text = '100';
//       } else {
//         widget.productRow.discount = discountValue;
//       }
//     }

//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateProductWithDebounce() {
//     widget.productRow.calculateTotals();
//     _updateTimer?.cancel();
//     _updateTimer = Timer(
//       const Duration(milliseconds: 500),
//       () => widget.onUpdate(widget.productRow),
//     );
//   }

//   void _showMinimumPriceError(double minimumPrice) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Price cannot be less than minimum price: OMR ${minimumPrice.toStringAsFixed(2)}',
//         ),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Widget _buildProductDropdown() {
//     final Map<String, String> itemMap = {};
//     for (var item in widget.allItems) {
//       String displayName = item.productName;
//       if (item.type == 'service') {
//         displayName = '⚡ $displayName';
//       } else {
//         displayName = '📦 $displayName';
//       }
//       itemMap[item.productId] = displayName;
//     }
//     return CustomSearchableDropdown(
//       key: widget.productRow.dropdownKey,
//       hintText: 'Item',
//       items: itemMap,
//       value: widget.productRow.purchaseItem?.productId,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final selected = widget.allItems.firstWhere(
//             (item) => item.productId == value,
//           );
//           if (mounted) {
//             setState(() {
//               widget.productRow.purchaseItem = selected;
//               widget.productRow.type = selected.type;
//               widget.productRow.avgPrice = selected.sellingPrice;
//               _priceController.text = selected.sellingPrice.toStringAsFixed(2);
//               widget.productRow.cost = selected.cost;
//               widget.productRow.margin = selected.cost > 0
//                   ? ((selected.sellingPrice - selected.cost) / selected.cost) *
//                         100
//                   : 0;
//               _originalPrice = selected.sellingPrice;
//               widget.productRow.calculateTotals();
//               widget.onUpdate(widget.productRow);
//               FocusScope.of(context).requestFocus(_qtyFocusNode);
//             });
//           }
//         }
//       },
//     );
//   }

//   Widget _buildServiceTypeDropdown() {
//     final Map<String, String> expenseTypes = {};
//     for (var type in ExpenseType.types) {
//       expenseTypes[type.id] = type.name;
//     }
//     return CustomSearchableDropdown(
//       key: widget.productRow.serviceTypeKey,
//       hintText: 'Type',
//       items: expenseTypes,
//       value: widget.productRow.serviceType,
//       onChanged: (value) {
//         if (value.isNotEmpty && mounted) {
//           setState(() => _updateServiceTypeInModel(value));
//         }
//       },
//     );
//   }

//   Widget _buildVatDropdown() {
//     return CustomSearchableDropdown(
//       key: widget.productRow.vatKey ?? Key('vat_${widget.index}'),
//       hintText: 'VAT',
//       items: vatOptions,
//       value: widget.productRow.vatType ?? 'none',
//       onChanged: (value) {
//         if (value.isNotEmpty && mounted) {
//           setState(() => _updateVatTypeInModel(value));
//         }
//       },
//     );
//   }

//   Widget _buildDiscountTypeDropdown() {
//     return CustomSearchableDropdown(
//       key: Key('discount_type_${widget.index}'),
//       hintText: 'Type',
//       items: discountTypes,
//       value: widget.productRow.discountType ?? 'percentage',
//       onChanged: (value) {
//         if (value.isNotEmpty && mounted) {
//           setState(() => _updateDiscountTypeInModel(value));
//         }
//       },
//     );
//   }

//   Widget _buildServiceCostInput() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             key: widget.productRow.serviceCostKey,
//             controller: _serviceCostController,
//             decoration: InputDecoration(
//               labelText: 'Expense',
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             ),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             textInputAction: TextInputAction.next,
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 _updateServiceCostInModel(double.tryParse(value) ?? 0);
//               }
//             },
//             onEditingComplete: () => FocusScope.of(context).unfocus(),
//           ),
//         ),
//         SizedBox(width: 4),
//         Container(width: 80, child: _buildServiceTypeDropdown()),
//       ],
//     );
//   }

//   Widget _buildDiscountInput() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             key: widget.productRow.discountKey,
//             controller: _discountAmountController,
//             decoration: InputDecoration(
//               labelText: 'Discount',
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             ),
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//             ],
//             validator: (value) {
//               if (widget.productRow.discountType == 'percentage') {
//                 return ValidationUtils.discount(value);
//               }
//               return null;
//             },
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) {
//               if (value.isNotEmpty && mounted) {
//                 _updateDiscountInModel(value);
//               }
//             },
//             onEditingComplete: () => FocusScope.of(context).unfocus(),
//           ),
//         ),
//         SizedBox(width: 4),
//         Container(width: 80, child: _buildDiscountTypeDropdown()),
//       ],
//     );
//   }

//   Widget _buildVatInput() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               'OMR ${widget.productRow.vatAmount.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//         ),
//         SizedBox(width: 4),
//         Container(width: 100, child: _buildVatDropdown()),
//       ],
//     );
//   }

//   Widget _buildPriceInput() {
//     return TextFormField(
//       key: widget.productRow.priceKey,
//       controller: _priceController,
//       focusNode: _priceFocusNode,
//       enabled: true,
//       decoration: InputDecoration(
//         labelText: 'Price',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       textInputAction: TextInputAction.next,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final newPrice = double.tryParse(value) ?? 0;
//           final minimumPrice =
//               widget.productRow.purchaseItem?.minimumPrice ?? 0;
//           if (newPrice >= minimumPrice) _updatePriceInModel(newPrice);
//         }
//       },
//       onEditingComplete: () {
//         _validateAndUpdatePrice();
//         FocusScope.of(context).requestFocus(_qtyFocusNode);
//       },
//       onFieldSubmitted: (value) => _validateAndUpdatePrice(),
//     );
//   }

//   Widget _buildQuantityInput() {
//     return TextFormField(
//       key: widget.productRow.quantityKey,
//       controller: _qtyController,
//       focusNode: _qtyFocusNode,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       decoration: const InputDecoration(
//         labelText: 'Qty',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(5),
//       ],
//       validator: (value) => ValidationUtils.quantity(value),
//       keyboardType: TextInputType.number,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final quantity = int.tryParse(value) ?? 0;
//           if (quantity == 0) {
//             _qtyController.text = "1";
//             widget.productRow.quantity = 1;
//           }
//           if (quantity > 0 && quantity <= 999999 && mounted) {
//             setState(() {
//               widget.productRow.quantity = quantity;
//               widget.productRow.calculateTotals();
//               _updateProductWithDebounce();
//             });
//           }
//         } else {
//           _qtyController.text = "1";
//           widget.productRow.quantity = 1;
//           if (mounted) {
//             setState(() {
//               widget.productRow.quantity = 1;
//               widget.productRow.calculateTotals();
//               _updateProductWithDebounce();
//             });
//           }
//         }
//       },
//       onEditingComplete: () {
//         final value = _qtyController.text;
//         final quantity = int.tryParse(value) ?? 0;
//         if (quantity < 1 && mounted) {
//           setState(() {
//             widget.productRow.quantity = 1;
//             _qtyController.text = '1';
//             widget.productRow.calculateTotals();
//             widget.onUpdate(widget.productRow);
//           });
//         }
//         _qtyFocusNode.unfocus();
//       },
//     );
//   }

//   Widget _buildStaticAmountDisplay(
//     double amount,
//     String label, {
//     bool isTotal = false,
//   }) {
//     return Tooltip(
//       message: label,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Text(
//           'OMR ${amount.toStringAsFixed(2)}',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             color: isTotal ? AppTheme.primaryColor : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void didUpdateWidget(ProductRowWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.productRow != widget.productRow) _initializeControllers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               SizedBox(width: 200, child: _buildProductDropdown()),
//               SizedBox(width: 6),
//               SizedBox(width: 80, child: _buildPriceInput()),
//               SizedBox(width: 6),
//               SizedBox(width: 60, child: _buildQuantityInput()),
//               SizedBox(width: 6),
//               Expanded(flex: 1, child: _buildDiscountInput()),

//               SizedBox(width: 6),
//               SizedBox(
//                 width: 80,
//                 child: _buildStaticAmountDisplay(
//                   widget.productRow.subtotal,
//                   'Subtotal',
//                 ),
//               ),
//               SizedBox(width: 6),
//               Expanded(flex: 1, child: _buildVatInput()),
//               SizedBox(width: 6),
//               SizedBox(
//                 width: 80,
//                 child: _buildStaticAmountDisplay(
//                   widget.productRow.total,
//                   'Total',
//                   isTotal: true,
//                 ),
//               ),
//               SizedBox(width: 6),
//               if (widget.showRemoveButton)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.remove_circle,
//                     color: Colors.red,
//                     size: 20,
//                   ),
//                   onPressed: widget.onRemove,
//                 ),
//               PopupMenuButton<String>(
//                 onSelected: (String type) {
//                   if (type == "view") {}
//                 },
//                 icon: Icon(
//                   Icons.more_vert,
//                   size: 18,
//                   color: Colors.grey.shade600,
//                 ),
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(minWidth: 0),
//                 itemBuilder: (BuildContext context) => [
//                   PopupMenuItem(
//                     value: "direct cost",
//                     child: Row(
//                       children: [
//                         Icon(Icons.visibility, size: 18, color: Colors.blue),
//                         const SizedBox(width: 8),
//                         Text('Direct Expense'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 4),

//           Row(children: [Expanded(flex: 1, child: _buildServiceCostInput())]),
//         ],
//       ),
//     );
//   }
// }

// class ProductRowWidget extends StatefulWidget {
//   final ProductRow productRow;
//   final List<PurchaseItem> allItems;
//   final int index;
//   final Function(ProductRow) onUpdate;
//   final VoidCallback onRemove;
//   final bool showRemoveButton;

//   const ProductRowWidget({
//     super.key,
//     required this.productRow,
//     required this.allItems,
//     required this.index,
//     required this.onUpdate,
//     required this.onRemove,
//     required this.showRemoveButton,
//   });

//   @override
//   State<ProductRowWidget> createState() => _ProductRowWidgetState();
// }

// class _ProductRowWidgetState extends State<ProductRowWidget> {
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _qtyController = TextEditingController();
//   final TextEditingController _serviceCostController = TextEditingController();
//   final TextEditingController _discountAmountController =
//       TextEditingController();
//   final FocusNode _priceFocusNode = FocusNode();
//   final FocusNode _qtyFocusNode = FocusNode();
//   double _originalPrice = 0;
//   Timer? _updateTimer;
//   bool _showExpense = false;

//   final Map<String, String> vatOptions = {
//     'standard': '5%',
//     'zero': '0%',
//     'exempt': 'Exempt',
//     'none': 'None',
//   };

//   final Map<String, String> discountTypes = {
//     'percentage': '%',
//     'amount': 'OMR',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _priceFocusNode.addListener(_onPriceFocusChange);
//     _showExpense = widget.productRow.serviceCost > 0;
//   }

//   @override
//   void dispose() {
//     _priceFocusNode.removeListener(_onPriceFocusChange);
//     _priceController.dispose();
//     _serviceCostController.dispose();
//     _qtyController.dispose();
//     _discountAmountController.dispose();
//     _priceFocusNode.dispose();
//     _qtyFocusNode.dispose();
//     _updateTimer?.cancel();
//     super.dispose();
//   }

//   void _initializeControllers() {
//     if (widget.productRow.type == 'service') {
//       _priceController.text =
//           widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
//       _originalPrice = widget.productRow.selectedPrice ?? 0;
//     } else {
//       _priceController.text =
//           widget.productRow.avgPrice?.toStringAsFixed(2) ?? '0';
//       _originalPrice = widget.productRow.avgPrice ?? 0;
//     }
//     _qtyController.text = widget.productRow.quantity.toString();
//     _serviceCostController.text = widget.productRow.serviceCost.toStringAsFixed(
//       2,
//     );
//     _discountAmountController.text = widget.productRow.discount.toString();
//   }

//   void _onPriceFocusChange() {
//     if (!_priceFocusNode.hasFocus) _validateAndUpdatePrice();
//   }

//   void _validateAndUpdatePrice() {
//     final newPrice = double.tryParse(_priceController.text) ?? 0;
//     final minimumPrice = widget.productRow.purchaseItem?.minimumPrice ?? 0;
//     final sellingPrice = widget.productRow.purchaseItem?.sellingPrice ?? 0;
//     if (newPrice < minimumPrice) {
//       _showMinimumPriceError(minimumPrice);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           setState(() {
//             _priceController.text = sellingPrice.toStringAsFixed(2);
//             _updatePriceInModel(sellingPrice);
//           });
//         }
//       });
//     } else {
//       _updatePriceInModel(newPrice);
//     }
//   }

//   void _updatePriceInModel(double newPrice) {
//     if (widget.productRow.type == 'service') {
//       widget.productRow.selectedPrice = newPrice;
//     } else {
//       widget.productRow.avgPrice = newPrice;
//       if (widget.productRow.cost > 0) {
//         widget.productRow.margin =
//             ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
//             100;
//       }
//     }
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateServiceCostInModel(double serviceCost) {
//     widget.productRow.serviceCost = serviceCost;
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateServiceTypeInModel(String serviceType) {
//     widget.productRow.serviceType = serviceType;
//     _updateProductWithDebounce();
//   }

//   void _updateVatTypeInModel(String vatType) {
//     widget.productRow.vatType = vatType;
//     switch (vatType) {
//       case 'standard':
//         widget.productRow.vatAmount = widget.productRow.subtotal * 0.05;
//         break;
//       case 'zero':
//       case 'exempt':
//       case 'none':
//         widget.productRow.vatAmount = 0.0;
//         break;
//     }
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateDiscountTypeInModel(String discountType) {
//     widget.productRow.discountType = discountType;
//     if (discountType == 'percentage' && widget.productRow.discount > 100) {
//       widget.productRow.discount = 100.0;
//       _discountAmountController.text = '100';
//     }
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateDiscountInModel(String value) {
//     if (value.isEmpty) {
//       widget.productRow.discount = 0.0;
//     } else {
//       final discountValue = double.tryParse(value) ?? 0.0;
//       if (widget.productRow.discountType == 'percentage' &&
//           discountValue > 100) {
//         widget.productRow.discount = 100.0;
//         _discountAmountController.text = '100';
//       } else {
//         widget.productRow.discount = discountValue;
//       }
//     }
//     widget.productRow.calculateTotals();
//     _updateProductWithDebounce();
//   }

//   void _updateProductWithDebounce() {
//     widget.productRow.calculateTotals();
//     _updateTimer?.cancel();
//     _updateTimer = Timer(
//       const Duration(milliseconds: 500),
//       () => widget.onUpdate(widget.productRow),
//     );
//   }

//   void _showMinimumPriceError(double minimumPrice) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Price cannot be less than minimum price: OMR ${minimumPrice.toStringAsFixed(2)}',
//         ),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   void didUpdateWidget(ProductRowWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.productRow != widget.productRow) _initializeControllers();
//   }

//   // Build a field block with header on top
//   Widget _buildFieldBlock({
//     required String header,
//     required Widget child,
//     required double width,
//   }) {
//     return SizedBox(
//       width: width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 4, bottom: 4),
//             child: Text(
//               header,
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget _buildProductDropdown() {
//     final Map<String, String> itemMap = {};
//     for (var item in widget.allItems) {
//       String displayName = item.productName;
//       if (item.type == 'service') {
//         displayName = '⚡ $displayName';
//       } else {
//         displayName = '📦 $displayName';
//       }
//       itemMap[item.productId] = displayName;
//     }
//     return CustomSearchableDropdown(
//       key: widget.productRow.dropdownKey,
//       hintText: 'Select Item',
//       items: itemMap,
//       value: widget.productRow.purchaseItem?.productId,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final selected = widget.allItems.firstWhere(
//             (item) => item.productId == value,
//           );
//           if (mounted) {
//             setState(() {
//               widget.productRow.purchaseItem = selected;
//               widget.productRow.type = selected.type;
//               widget.productRow.avgPrice = selected.sellingPrice;
//               _priceController.text = selected.sellingPrice.toStringAsFixed(2);
//               widget.productRow.cost = selected.cost;
//               widget.productRow.margin = selected.cost > 0
//                   ? ((selected.sellingPrice - selected.cost) / selected.cost) *
//                         100
//                   : 0;
//               _originalPrice = selected.sellingPrice;
//               widget.productRow.calculateTotals();
//               widget.onUpdate(widget.productRow);
//               FocusScope.of(context).requestFocus(_qtyFocusNode);
//             });
//           }
//         }
//       },
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     FocusNode? focusNode,
//     required String hint,
//     Function(String)? onChanged,
//     VoidCallback? onEditingComplete,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return TextFormField(
//       controller: controller,
//       focusNode: focusNode,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         isDense: true,
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       inputFormatters: inputFormatters,
//       onChanged: onChanged,
//       onEditingComplete: onEditingComplete,
//     );
//   }

//   Widget _buildDropdown({
//     required Map<String, String> items,
//     required String? value,
//     required Function(String) onChanged,
//     Key? key,
//   }) {
//     return CustomSearchableDropdown(
//       key: key,
//       hintText: '',
//       items: items,
//       value: value,
//       onChanged: (val) {
//         if (val.isNotEmpty) onChanged(val);
//       },
//     );
//   }

//   Widget _buildAmountDisplay(double amount, {bool isTotal = false}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isTotal ? AppTheme.primaryColor : Colors.grey[300]!,
//         ),
//         borderRadius: BorderRadius.circular(4),
//         color: isTotal
//             ? AppTheme.primaryColor.withOpacity(0.08)
//             : Colors.grey[50],
//       ),
//       child: Text(
//         'OMR ${amount.toStringAsFixed(2)}',
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
//           color: isTotal ? AppTheme.primaryColor : Colors.black87,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: Colors.grey[300]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Main row with headers
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Item
//               _buildFieldBlock(
//                 header: 'ITEM',
//                 width: 280,
//                 child: _buildProductDropdown(),
//               ),
//               SizedBox(width: 10),

//               // Price
//               _buildFieldBlock(
//                 header: 'PRICE',
//                 width: 100,
//                 child: _buildTextField(
//                   controller: _priceController,
//                   focusNode: _priceFocusNode,
//                   hint: '0.00',
//                   onChanged: (value) {
//                     if (value.isNotEmpty) {
//                       final newPrice = double.tryParse(value) ?? 0;
//                       final minimumPrice =
//                           widget.productRow.purchaseItem?.minimumPrice ?? 0;
//                       if (newPrice >= minimumPrice)
//                         _updatePriceInModel(newPrice);
//                     }
//                   },
//                   onEditingComplete: () {
//                     _validateAndUpdatePrice();
//                     FocusScope.of(context).requestFocus(_qtyFocusNode);
//                   },
//                 ),
//               ),
//               SizedBox(width: 10),

//               // Qty
//               _buildFieldBlock(
//                 header: 'QTY',
//                 width: 70,
//                 child: _buildTextField(
//                   controller: _qtyController,
//                   focusNode: _qtyFocusNode,
//                   hint: '1',
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(5),
//                   ],
//                   onChanged: (value) {
//                     if (value.isNotEmpty) {
//                       final quantity = int.tryParse(value) ?? 1;
//                       if (quantity > 0 && quantity <= 999999 && mounted) {
//                         setState(() {
//                           widget.productRow.quantity = quantity;
//                           widget.productRow.calculateTotals();
//                           _updateProductWithDebounce();
//                         });
//                       }
//                     }
//                   },
//                 ),
//               ),
//               SizedBox(width: 10),

//               // Discount
//               _buildFieldBlock(
//                 header: 'DISCOUNT',
//                 width: 100,
//                 child: _buildTextField(
//                   controller: _discountAmountController,
//                   hint: '0',
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(
//                       RegExp(r'^\d*\.?\d{0,2}'),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     if (mounted) _updateDiscountInModel(value);
//                   },
//                 ),
//               ),
//               SizedBox(width: 10),

//               // Discount Type
//               _buildFieldBlock(
//                 header: 'TYPE',
//                 width: 80,
//                 child: _buildDropdown(
//                   items: discountTypes,
//                   value: widget.productRow.discountType ?? 'percentage',
//                   onChanged: (value) {
//                     if (mounted)
//                       setState(() => _updateDiscountTypeInModel(value));
//                   },
//                 ),
//               ),
//               SizedBox(width: 10),

//               // Subtotal
//               _buildFieldBlock(
//                 header: 'SUBTOTAL',
//                 width: 110,
//                 child: _buildAmountDisplay(widget.productRow.subtotal),
//               ),
//               SizedBox(width: 10),

//               // VAT Type
//               _buildFieldBlock(
//                 header: 'VAT',
//                 width: 90,
//                 child: _buildDropdown(
//                   items: vatOptions,
//                   value: widget.productRow.vatType ?? 'none',
//                   onChanged: (value) {
//                     if (mounted) setState(() => _updateVatTypeInModel(value));
//                   },
//                   key: widget.productRow.vatKey,
//                 ),
//               ),
//               SizedBox(width: 10),

//               // VAT Amount
//               _buildFieldBlock(
//                 header: 'VAT AMT',
//                 width: 100,
//                 child: _buildAmountDisplay(widget.productRow.vatAmount),
//               ),
//               SizedBox(width: 10),

//               // Total
//               _buildFieldBlock(
//                 header: 'TOTAL',
//                 width: 120,
//                 child: _buildAmountDisplay(
//                   widget.productRow.total,
//                   isTotal: true,
//                 ),
//               ),
//               SizedBox(width: 10),

//               // Actions
//               Column(
//                 children: [
//                   SizedBox(height: 18),
//                   Row(
//                     children: [
//                       IconButton(
//                         padding: EdgeInsets.all(4),
//                         constraints: BoxConstraints(),
//                         icon: Icon(
//                           _showExpense ? Icons.expand_less : Icons.add,
//                           size: 20,
//                           color: AppTheme.primaryColor,
//                         ),
//                         onPressed: () =>
//                             setState(() => _showExpense = !_showExpense),
//                         tooltip: _showExpense ? 'Hide Expense' : 'Add Expense',
//                       ),
//                       if (widget.showRemoveButton) ...[
//                         SizedBox(width: 4),
//                         IconButton(
//                           padding: EdgeInsets.all(4),
//                           constraints: BoxConstraints(),
//                           icon: Icon(
//                             Icons.delete_outline,
//                             color: Colors.red,
//                             size: 20,
//                           ),
//                           onPressed: widget.onRemove,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           // Expense section
//           if (_showExpense) ...[
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.amber[50],
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: Colors.amber[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.receipt_long,
//                         size: 16,
//                         color: Colors.amber[900],
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         'Direct Expense',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.amber[900],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 150,
//                         child: TextFormField(
//                           controller: _serviceCostController,
//                           decoration: InputDecoration(
//                             labelText: 'Amount (OMR)',
//                             border: OutlineInputBorder(),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 12,
//                             ),
//                             isDense: true,
//                           ),
//                           keyboardType: TextInputType.numberWithOptions(
//                             decimal: true,
//                           ),
//                           onChanged: (value) {
//                             if (value.isNotEmpty) {
//                               _updateServiceCostInModel(
//                                 double.tryParse(value) ?? 0,
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: ExpenseType.types.map((type) {
//                             final isSelected =
//                                 widget.productRow.serviceType == type.id;
//                             return ChoiceChip(
//                               label: Text(
//                                 type.name,
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                               selected: isSelected,
//                               onSelected: (selected) {
//                                 if (selected && mounted) {
//                                   setState(
//                                     () => _updateServiceTypeInModel(type.id),
//                                   );
//                                 }
//                               },
//                               selectedColor: Colors.amber[200],
//                               backgroundColor: Colors.white,
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

class ProductRowWidget extends StatefulWidget {
  final ProductRow productRow;
  final List<PurchaseItem> allItems;
  final int index;
  final Function(ProductRow) onUpdate;
  final VoidCallback onRemove;
  final bool showRemoveButton;
  final List<SupplierModel> supplierList;
  final String? defaultSupplierId;
  const ProductRowWidget({
    super.key,
    required this.productRow,
    required this.allItems,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.showRemoveButton,
    required this.supplierList,
    this.defaultSupplierId,
  });

  @override
  State<ProductRowWidget> createState() => _ProductRowWidgetState();
}

class _ProductRowWidgetState extends State<ProductRowWidget> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _serviceCostController = TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _qtyFocusNode = FocusNode();
  double _originalPrice = 0;
  Timer? _updateTimer;
  bool _showExpense = false;
  String? _directExpenseVatType = 'none';
  double _directExpenseVatAmount = 0;

  final Map<String, String> vatOptions = {
    'standard': '5%',
    'zero': '0%',
    'exempt': 'Exempt',
    'none': 'None',
  };

  final Map<String, String> discountTypes = {
    'percentage': '%',
    'amount': 'OMR',
  };

  // Expense type options
  final Map<String, String> expenseTypes = {
    'freight': 'Freight',
    'handling': 'Handling',
    'multiple': 'Multiple',
    'other': 'Other',
  };

  // Supplier options (you can populate this from your data)
  Map<String, String> get supplierOptions {
    final Map<String, String> options = {};
    for (var supplier in widget.supplierList) {
      if (supplier.id != null && supplier.supplierName.isNotEmpty) {
        options[supplier.id!] = supplier.supplierName;
      }
    }
    return options;
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _priceFocusNode.addListener(_onPriceFocusChange);
    _showExpense = widget.productRow.serviceCost > 0;
    // _directExpenseVatType = widget.productRow.serviceType ?? 'none';
    // _calculateDirectExpenseVat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.defaultSupplierId != null &&
          widget.productRow.supplierId == null &&
          mounted) {
        _setDefaultSupplier();
      }
    });
  }

  void _setDefaultSupplier() {
    _updateSupplierInModel(widget.defaultSupplierId!);
  }

  @override
  void dispose() {
    _priceFocusNode.removeListener(_onPriceFocusChange);
    _priceController.dispose();
    _serviceCostController.dispose();
    _qtyController.dispose();
    _discountAmountController.dispose();
    _priceFocusNode.dispose();
    _qtyFocusNode.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProductRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productRow != widget.productRow) _initializeControllers();

    // Update supplier if default supplier changed
    if (oldWidget.defaultSupplierId != widget.defaultSupplierId &&
        widget.defaultSupplierId != null &&
        mounted) {
      _setDefaultSupplier();
    }
  }

  void _initializeControllers() {
    if (widget.productRow.type == 'service') {
      _priceController.text =
          widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
      _originalPrice = widget.productRow.selectedPrice ?? 0;
    } else {
      _priceController.text =
          widget.productRow.avgPrice?.toStringAsFixed(2) ?? '0';
      _originalPrice = widget.productRow.avgPrice ?? 0;
    }
    _qtyController.text = widget.productRow.quantity.toString();
    _serviceCostController.text = widget.productRow.serviceCost.toStringAsFixed(
      2,
    );
    _discountAmountController.text = widget.productRow.discount.toString();
    if (widget.productRow.serviceCost > 0) {
      _updateDirectExpenseVatInModel();
    }
  }

  void _onPriceFocusChange() {
    if (!_priceFocusNode.hasFocus) {} // _validateAndUpdatePrice();
  }

  // void _validateAndUpdatePrice() {
  //   final newPrice = double.tryParse(_priceController.text) ?? 0;
  //   final minimumPrice = widget.productRow.purchaseItem?.minimumPrice ?? 0;
  //   final sellingPrice = widget.productRow.purchaseItem?.sellingPrice ?? 0;
  //   if (newPrice < minimumPrice) {
  //     _showMinimumPriceError(minimumPrice);
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (mounted) {
  //         setState(() {
  //           _priceController.text = sellingPrice.toStringAsFixed(2);
  //           _updatePriceInModel(sellingPrice);
  //         });
  //       }
  //     });
  //   } else {
  //     _updatePriceInModel(newPrice);
  //   }
  // }

  void _updatePriceInModel(double newPrice) {
    if (widget.productRow.type == 'service') {
      widget.productRow.selectedPrice = newPrice;
    } else {
      widget.productRow.avgPrice = newPrice;
      if (widget.productRow.cost > 0) {
        widget.productRow.margin =
            ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
            100;
      }
    }
    widget.productRow.calculateTotals();
    _updateProductWithDebounce();
  }

  // void _updateServiceCostInModel(double serviceCost) {
  //   widget.productRow.serviceCost = serviceCost;
  //   widget.productRow.calculateTotals();
  //   _updateProductWithDebounce();
  // }

  void _updateServiceCostInModel(double serviceCost) {
    if (mounted) {
      setState(() {
        widget.productRow.serviceCost = serviceCost;

        // Recalculate direct expense VAT
        _updateDirectExpenseVatInModel();

        widget.productRow.calculateTotals();
      });

      // Use immediate update for cost changes to ensure real-time calculation
      _updateProductImmediately();
    }
  }

  void _updateServiceTypeInModel(String serviceType) {
    widget.productRow.serviceType = serviceType;
    _updateProductWithDebounce();
  }

  void _updateVatTypeInModel(String vatType) {
    widget.productRow.vatType = vatType;
    switch (vatType) {
      case 'standard':
        widget.productRow.vatAmount = widget.productRow.subtotal * 0.05;
        break;
      case 'zero':
      case 'exempt':
      case 'none':
        widget.productRow.vatAmount = 0.0;
        break;
    }
    widget.productRow.calculateTotals();
    _updateProductWithDebounce();
  }

  void _updateDiscountTypeInModel(String discountType) {
    widget.productRow.discountType = discountType;
    if (discountType == 'percentage' && widget.productRow.discount > 100) {
      widget.productRow.discount = 100.0;
      _discountAmountController.text = '100';
    }
    widget.productRow.calculateTotals();
    _updateProductWithDebounce();
  }

  void _updateDiscountInModel(String value) {
    if (value.isEmpty) {
      widget.productRow.discount = 0.0;
    } else {
      final discountValue = double.tryParse(value) ?? 0.0;
      if (widget.productRow.discountType == 'percentage' &&
          discountValue > 100) {
        widget.productRow.discount = 100.0;
        _discountAmountController.text = '100';
      } else {
        widget.productRow.discount = discountValue;
      }
    }
    widget.productRow.calculateTotals();
    _updateProductWithDebounce();
  }

  void _updateSupplierInModel(String supplierId) {
    widget.productRow.supplierId = supplierId;
    _updateProductWithDebounce();
  }

  void _updateAddToPurchaseCost(bool value) {
    widget.productRow.addToPurchaseCost = value;
    _updateProductWithDebounce();
  }

  void _updateDirectExpenseVatType(String vatType) {
    if (mounted) {
      setState(() {
        widget.productRow.directExpenseVatType = vatType;
        _updateDirectExpenseVatInModel();
        widget.productRow.calculateTotals();
      });
      _updateProductImmediately(); // Use immediate update for VAT changes
    }
  }

  void _updateProductImmediately() {
    _updateTimer?.cancel(); // Cancel any pending debounced updates
    if (mounted) {
      widget.onUpdate(widget.productRow);
    }
  }

  Widget _buildVatDropdownForDirectExpense() {
    return _buildDropdown(
      items: vatOptions,
      value: widget.productRow.directExpenseVatType,
      onChanged: _updateDirectExpenseVatType,
    );
  }

  Widget _buildDirectExpenseDisplay() {
    final hasDirectExpense = widget.productRow.serviceCost > 0;

    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: hasDirectExpense ? Colors.amber[50] : Colors.grey[50],
        border: Border.all(
          color: hasDirectExpense ? Colors.amber[200]! : Colors.grey[300]!,
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        hasDirectExpense
            ? 'OMR ${widget.productRow.serviceCost.toStringAsFixed(2)}'
            : 'OMR 0.00',
        style: TextStyle(
          fontSize: 13,
          fontWeight: hasDirectExpense ? FontWeight.w600 : FontWeight.normal,
          color: hasDirectExpense ? Colors.amber[900] : Colors.grey[800],
        ),
      ),
    );
  }

  // _buildRow(
  //                     'Direct Expenses Total',
  //                     directExpensesTotal,
  //                     bold: true,
  //                   ),

  Widget _buildVatAmountDisplayForDirectExpense() {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[50],
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        'OMR ${widget.productRow.directExpenseVatAmount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  // Add this new method for the total display
  Widget _buildTotalAmountDisplayForDirectExpense() {
    final total =
        widget.productRow.serviceCost +
        widget.productRow.directExpenseVatAmount;
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
        color: Colors.blue[50],
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        'OMR ${total.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  // Add a method to clear direct expense completely
  void _clearDirectExpense() {
    if (mounted) {
      setState(() {
        _serviceCostController.text = '0';
        widget.productRow.serviceCost = 0;
        widget.productRow.serviceType = null;
        widget.productRow.directExpenseVatType = 'none';
        widget.productRow.directExpenseVatAmount = 0;
        widget.productRow.calculateTotals();
      });
      _updateProductImmediately();
    }
  }

  void _updateDirectExpenseVatInModel() {
    // Reset VAT amount first
    widget.productRow.directExpenseVatAmount = 0.0;

    // Only calculate VAT if there's a service cost AND VAT type is standard
    if (widget.productRow.serviceCost > 0 &&
        widget.productRow.directExpenseVatType == 'standard') {
      widget.productRow.directExpenseVatAmount =
          widget.productRow.serviceCost * 0.05;
    }
  }

  void _updateProductWithDebounce() {
    // For expense items, quantity should always be 1
    if (widget.productRow.type == 'expense') {
      widget.productRow.quantity = 1;
      _qtyController.text = '1';
    }

    widget.productRow.calculateTotals();
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        widget.onUpdate(widget.productRow);
      }
    });
  }

  // Professional field block with header
  Widget _buildFieldBlock({
    required String header,
    required Widget child,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
              color: Colors.white,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildProductDropdown() {
    final Map<String, String> itemMap = {};

    for (var item in widget.allItems) {
      String displayName = item.productName;

      // Add icons and labels based on type
      if (item.type == 'service') {
        displayName = '⚡ $displayName (Service)';
      } else if (item.type == 'expense') {
        displayName = '💰 $displayName (Expense)';
      } else {
        displayName = '📦 $displayName (Product)';
      }

      itemMap[item.productId] = displayName;
    }

    return CustomSearchableDropdown(
      key: widget.productRow.dropdownKey,
      hintText: 'Select Item',
      items: itemMap,
      value: widget.productRow.purchaseItem?.productId,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final selected = widget.allItems.firstWhere(
            (item) => item.productId == value,
          );
          if (mounted) {
            setState(() {
              widget.productRow.purchaseItem = selected;
              widget.productRow.type = selected.type;
              debugPrint("${"expense"}${selected.type}");
              // Set different default prices based on type
              if (selected.type == 'expense') {
                // For expenses, default price is 0 since user will enter the expense amount
                widget.productRow.avgPrice = 0;
                _priceController.text = '0.00';
              } else {
                // For products, use the buying price
                widget.productRow.avgPrice = selected.buyingPrice;
                _priceController.text = selected.buyingPrice.toStringAsFixed(2);
              }

              widget.productRow.cost = selected.unitPrice;
              _originalPrice = selected.unitPrice;
              widget.productRow.calculateTotals();
              widget.onUpdate(widget.productRow);
              FocusScope.of(context).requestFocus(_qtyFocusNode);
            });
          }
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String hint,
    Function(String)? onChanged,
    VoidCallback? onEditingComplete,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
        ),
        style: TextStyle(fontSize: 14),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      ),
    );
  }

  Widget _buildAmountDisplay(double amount, {bool isTotal = false}) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isTotal ? Colors.blue[50] : Colors.grey[50],
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        'OMR ${amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          color: isTotal ? Colors.blue[900] : Colors.grey[800],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDropdown({
    required Map<String, String> items,
    required String? value,
    required Function(String) onChanged,
  }) {
    // Ensure the current value exists in items, otherwise use null
    final validValue = items.containsKey(value) ? value : null;

    return DropdownButton<String>(
      value: validValue,
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: items.entries.map((entry) {
        return DropdownMenuItem(value: entry.key, child: Text(entry.value));
      }).toList(),
      hint: Text('Select...'),
    );
  }

  bool _addToPurchaseCost = false;
  @override
  Widget build(BuildContext context) {
    final isExpense = widget.productRow.type == 'expense';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main row with headers and fields - fully responsive
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item - flexible, takes more space
                _buildFieldBlock(
                  header: 'ITEM',
                  flex: 4,
                  child: _buildProductDropdown(),
                ),
                SizedBox(width: 8),

                // Price
                _buildFieldBlock(
                  header: isExpense ? 'AMOUNT' : 'PRICE',
                  flex: 2,
                  child: _buildTextField(
                    controller: _priceController,
                    focusNode: _priceFocusNode,
                    hint: isExpense ? 'Expense Amount' : '0.00',
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final newPrice = double.tryParse(value) ?? 0;
                        // final minimumPrice =
                        //   widget.productRow.purchaseItem?.buyingPrice ?? 0;
                        //if (newPrice >= minimumPrice) {
                        _updatePriceInModel(newPrice);
                        // }
                      }
                    },
                    onEditingComplete: () {
                      // _validateAndUpdatePrice();
                      FocusScope.of(context).requestFocus(_qtyFocusNode);
                    },
                  ),
                ),
                SizedBox(width: 8),

                // Qty
                _buildFieldBlock(
                  header: 'QTY',
                  flex: 1,
                  child: IgnorePointer(
                    ignoring: widget.productRow.type == 'expense',
                    child: Opacity(
                      opacity: widget.productRow.type == 'expense' ? 0.5 : 1.0,
                      child: _buildTextField(
                        controller: _qtyController,
                        focusNode: _qtyFocusNode,
                        hint: '1',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final quantity = int.tryParse(value) ?? 1;
                            if (quantity > 0 && quantity <= 999999 && mounted) {
                              setState(() {
                                widget.productRow.quantity = quantity;
                                widget.productRow.calculateTotals();
                                _updateProductWithDebounce();
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),

                // Discount (merged with type)
                _buildFieldBlock(
                  header: 'DISCOUNT',
                  flex: 3,
                  child: SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _discountAmountController,
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 14),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            onChanged: (value) {
                              if (mounted) _updateDiscountInModel(value);
                            },
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value:
                                  widget.productRow.discountType ??
                                  'percentage',
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              items: discountTypes.entries.map((entry) {
                                return DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null && mounted) {
                                  setState(
                                    () => _updateDiscountTypeInModel(value),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),

                // Subtotal
                _buildFieldBlock(
                  header: 'SUBTOTAL',
                  flex: 2,
                  child: _buildAmountDisplay(widget.productRow.subtotal),
                ),
                SizedBox(width: 8),

                // VAT (merged with amount)
                _buildFieldBlock(
                  header: 'VAT',
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            key: widget.productRow.vatKey,
                            isExpanded: true,
                            value: widget.productRow.vatType ?? 'none',
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            items: vatOptions.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(
                                  entry.value,
                                  style: TextStyle(fontSize: 13),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null && mounted) {
                                setState(() => _updateVatTypeInModel(value));
                              }
                            },
                          ),
                        ),
                      ),
                      Container(width: 1, height: 30, color: Colors.grey[300]),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(color: Colors.grey[50]),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'OMR ${widget.productRow.vatAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // direct expense to be added here
                // _buildFieldBlock(
                //   header: 'DIRECT EXPENSE',
                //   flex: 2,
                //   child: _buildDirectExpenseDisplay(),
                // ),
                // SizedBox(width: 8),
                SizedBox(width: 8),
                // Total
                _buildFieldBlock(
                  header: 'TOTAL',
                  flex: 2,
                  child: _buildAmountDisplay(
                    widget.productRow.total,
                    isTotal: true,
                  ),
                ),
                SizedBox(width: 8),
                // Actions
                Container(
                  padding: EdgeInsets.only(top: 28),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(),
                          icon: Icon(
                            _showExpense ? Icons.keyboard_arrow_up : Icons.add,
                            size: 20,
                            color: Colors.blue[700],
                          ),
                          onPressed: () =>
                              setState(() => _showExpense = !_showExpense),
                          tooltip: _showExpense
                              ? 'Hide Expense'
                              : 'Add Expense',
                        ),
                      ),
                      if (widget.showRemoveButton) ...[
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[700],
                              size: 20,
                            ),
                            onPressed: widget.onRemove,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Expense section
          if (_showExpense)
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          size: 16,
                          color: Colors.amber[900],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Direct Expense',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[900],
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    children: [
                      // Expense Amount
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isEmpty || value == '0') {
                              // If field is cleared or set to 0, clear everything
                              _clearDirectExpense();
                            } else if (value.isNotEmpty) {
                              _updateServiceCostInModel(
                                double.tryParse(value) ?? 0,
                              );
                            }
                          },
                          controller: _serviceCostController,
                          decoration: InputDecoration(
                            labelText: 'Amount (OMR)',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            isDense: true,
                          ),
                          style: TextStyle(fontSize: 14),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          // onChanged: (value) {
                          //   if (value.isNotEmpty) {
                          //     _updateServiceCostInModel(
                          //       double.tryParse(value) ?? 0,
                          //     );
                          //   }
                          // },
                          onEditingComplete: () {
                            // Force update when user presses enter
                            if (_serviceCostController.text.isEmpty ||
                                _serviceCostController.text == '0') {
                              _clearDirectExpense();
                            }
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      SizedBox(width: 16),

                      // Expense Type Dropdown
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expense Type',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            _buildDropdown(
                              items: expenseTypes,
                              value: widget.productRow.serviceType,
                              // hint: 'Select Type',
                              onChanged: _updateServiceTypeInModel,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Supplier Dropdown
                      SizedBox(
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Supplier',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            _buildDropdown(
                              items: supplierOptions,
                              value: widget.productRow.supplierId,
                              //hint: 'Select Supplier',
                              onChanged: _updateSupplierInModel,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Add to Purchase Cost Checkbox
                      // VAT Dropdown for Direct Expense
                      SizedBox(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VAT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            _buildVatDropdownForDirectExpense(), // Use the new method
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // VAT Amount Display for Direct Expense
                      SizedBox(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VAT Amount',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            _buildVatAmountDisplayForDirectExpense(), // Use the new method
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // total to be displayed here
                      SizedBox(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            _buildVatAmountDisplayForDirectExpense(), // Use the new method
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add to Cost',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          SizedBox(
                            height: 44,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _addToPurchaseCost,
                                  onChanged: (value) {
                                    if (mounted) {
                                      _addToPurchaseCost = value ?? false;
                                      setState(() {
                                        _updateAddToPurchaseCost(
                                          value ?? false,
                                        );
                                      });
                                    }
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                Text(
                                  'Include in\nPurchase Cost',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
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
            ),
        ],
      ),
    );
  }
}

class BillExpenseRowWidget extends StatefulWidget {
  final BillExpense expense;
  final int index;
  final Function(BillExpense) onUpdate;
  final VoidCallback onRemove;
  final List<SupplierModel> supplierList;
  final String? defaultSupplierId;
  const BillExpenseRowWidget({
    super.key,
    required this.expense,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.supplierList,
    this.defaultSupplierId,
  });

  @override
  State<BillExpenseRowWidget> createState() => _BillExpenseRowWidgetState();
}

class _BillExpenseRowWidgetState extends State<BillExpenseRowWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Timer? _updateTimer;

  final Map<String, String> vatOptions = {
    'standard': '5%',
    'zero': '0%',
    'exempt': 'Exempt',
    'none': 'None',
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.defaultSupplierId != null &&
          widget.expense.supplier == null &&
          mounted) {
        _setDefaultSupplier();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  void _setDefaultSupplier() {
    final defaultSupplier = widget.supplierList.firstWhere(
      (supplier) => supplier.id == widget.defaultSupplierId,
      orElse: () => widget.supplierList.first,
    );
    _updateSupplier(defaultSupplier);
  }

  void _initializeControllers() {
    _amountController.text = widget.expense.amount.toStringAsFixed(2);
    _descriptionController.text = widget.expense.description;
  }

  void _updateExpenseWithDebounce() {
    _updateTimer?.cancel();
    _updateTimer = Timer(
      const Duration(milliseconds: 500),
      () => widget.onUpdate(widget.expense),
    );
  }

  void _updateAmount(double amount) {
    widget.expense.amount = amount;
    widget.expense.calculateVat();
    _updateExpenseWithDebounce();
  }

  void _updateDescription(String description) {
    widget.expense.description = description;
    _updateExpenseWithDebounce();
  }

  void _updateType(ExpenseType? type) {
    setState(() {
      widget.expense.type = type;
    });
    _updateExpenseWithDebounce();
  }

  void _updateSupplier(SupplierModel? supplier) {
    setState(() {
      widget.expense.supplier = supplier;
    });
    _updateExpenseWithDebounce();
  }

  void _updateVatType(String vatType) {
    setState(() {
      widget.expense.vatType = vatType;
      widget.expense.calculateVat();
    });
    _updateExpenseWithDebounce();
  }

  void _updateIncludeInProductCost(bool value) {
    setState(() {
      widget.expense.includeInProductCost = value;
    });
    _updateExpenseWithDebounce();
  }

  // Calculate total for this expense (amount + VAT)
  double _calculateExpenseTotal() {
    return widget.expense.amount + widget.expense.vatAmount;
  }

  // Professional field block with header (matching ProductRowWidget)
  Widget _buildFieldBlock({
    required String header,
    required Widget child,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
              color: Colors.white,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTypeDropdown() {
    final Map<String, String> expenseTypes = {};
    for (var type in ExpenseType.types) {
      expenseTypes[type.id] = type.name;
    }

    return SizedBox(
      height: 44,
      child: CustomSearchableDropdown(
        hintText: 'Select Type',
        items: expenseTypes,
        value: widget.expense.type?.id,
        onChanged: (value) {
          if (value.isNotEmpty) {
            final selectedType = ExpenseType.types.firstWhere(
              (type) => type.id == value,
              orElse: () => ExpenseType.types[0],
            );
            _updateType(selectedType);
          } else {
            _updateType(null);
          }
        },
      ),
    );
  }

  Widget _buildSupplierTypeDropdown() {
    final Map<String, String> suppliers = {};
    for (var supplier in widget.supplierList) {
      suppliers[supplier.id!] = supplier.supplierName;
    }

    return SizedBox(
      height: 44,
      child: CustomSearchableDropdown(
        hintText: 'Select Supplier',
        items: suppliers,
        value: widget.expense.supplier?.id,
        onChanged: (value) {
          if (value.isNotEmpty) {
            final selectedSupplier = widget.supplierList.firstWhere(
              (supplier) => supplier.id == value,
            );
            _updateSupplier(selectedSupplier);
          } else {
            _updateSupplier(null);
          }
        },
      ),
    );
  }

  Widget _buildVatDropdown() {
    return SizedBox(
      height: 44,
      child: CustomSearchableDropdown(
        hintText: 'VAT',
        items: vatOptions,
        value: widget.expense.vatType ?? 'none',
        onChanged: (value) {
          if (value.isNotEmpty) {
            _updateVatType(value);
          }
        },
      ),
    );
  }

  Widget _buildAmountInput() {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: _amountController,
        decoration: InputDecoration(
          hintText: '0.00',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
        ),
        style: TextStyle(fontSize: 14),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          if (value.isNotEmpty) _updateAmount(double.tryParse(value) ?? 0);
        },
      ),
    );
  }

  Widget _buildVatAmountDisplay() {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.grey[50]),
      alignment: Alignment.centerLeft,
      child: Text(
        'OMR ${widget.expense.vatAmount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildTotalDisplay() {
    final total = _calculateExpenseTotal();
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.blue[50]),
      alignment: Alignment.centerLeft,
      child: Text(
        'OMR ${total.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildIncludeInProductCostCheckbox() {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Checkbox(
            value: widget.expense.includeInProductCost,
            onChanged: (value) {
              _updateIncludeInProductCost(value ?? false);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(
            'Include in Cost',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(BillExpenseRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expense != widget.expense) _initializeControllers();

    if (oldWidget.defaultSupplierId != widget.defaultSupplierId &&
        widget.defaultSupplierId != null &&
        mounted) {
      _setDefaultSupplier();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expense Type
            _buildFieldBlock(
              header: 'EXPENSE TYPE',
              flex: 3,
              child: _buildExpenseTypeDropdown(),
            ),
            SizedBox(width: 8),

            // Amount
            _buildFieldBlock(
              header: 'AMOUNT',
              flex: 2,
              child: _buildAmountInput(),
            ),
            SizedBox(width: 8),

            // Supplier
            _buildFieldBlock(
              header: 'SUPPLIER',
              flex: 3,
              child: _buildSupplierTypeDropdown(),
            ),
            SizedBox(width: 8),

            // VAT (merged with amount)
            _buildFieldBlock(
              header: 'VAT',
              flex: 3,
              child: Row(
                children: [
                  Expanded(flex: 2, child: _buildVatDropdown()),
                  Container(width: 1, height: 30, color: Colors.grey[300]),
                  Expanded(flex: 3, child: _buildVatAmountDisplay()),
                ],
              ),
            ),
            SizedBox(width: 8),

            // Total
            _buildFieldBlock(
              header: 'TOTAL',
              flex: 2,
              child: _buildTotalDisplay(),
            ),
            SizedBox(width: 8),

            // Include in Cost
            _buildFieldBlock(
              header: 'INCLUDE IN COST',
              flex: 2,
              child: _buildIncludeInProductCostCheckbox(),
            ),
            SizedBox(width: 8),

            // Remove Button
            Container(
              padding: EdgeInsets.only(top: 28),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[700],
                        size: 20,
                      ),
                      onPressed: widget.onRemove,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
