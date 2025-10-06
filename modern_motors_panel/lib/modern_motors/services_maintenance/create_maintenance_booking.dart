// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/employees_commision_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
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
    PaymentMethod(id: 'debit_card', name: 'Debit Card'),
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
  SaleItem? saleItem; // Changed from ProductModel to SaleItem
  String? type; // 'product' or 'service'
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
  double cost = 0; // Added cost field
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
    // Generate keys once in constructor
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
  List<ProductRow> productRows = [
    //ProductRow()
  ];
  double productsGrandTotal = 0;
  bool loading = false;
  // Service rows
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
    // if (widget.items != null) {
    //   for (var element in widget.items!) {
    //     productRows.add(ProductRow(
    //       saleItem: element,
    //       type: element.type,
    //       sellingPrice: element.sellingPrice,
    //       quantity: element.quantity,
    //       total: element.totalPrice,
    //       subtotal: element.discount + element.totalPrice,
    //       discount: element.discount,
    //     ));
    //   }
    // }
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
      ]);
      allDiscounts = results[0] as List<DiscountModel>;
      allCustomers = results[1] as List<CustomerModel>;
      allTrucks = results[2] as List<MmtrucksModel>;
      allServices = results[3] as List<ServiceTypeModel>;
      allProducts = results[4] as List<ProductModel>;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget.sale != null) {
          CustomerModel? customer;
          customer = allCustomers.firstWhere(
            (item) => item.id == widget.sale!.customerName,
          );
          customerNameController.text = customer.customerName;
          final p = context.read<MaintenanceBookingProvider>();
          p.setCustomer(id: widget.sale!.customerName);
          // if (widget.sale!.items.isNotEmpty) {
          //   productRows.clear();
          // }
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
          //p.taxAmount = widget.sale!.taxAmount;
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
          // p.grandTotal = widget.sale!.total!;
          //_updateAllCalculations(p);
          // if (widget.sale!.discount > 0) {
          //   p.setDiscountAmount(widget.sale!.discount);
          //   //  productsGrandTotal + widget.sale!.discount;
          // }
          _applyDiscount(p, productsGrandTotal);
          // p.setSelectedInventoryFromItems(selectedInvs);
          // if (widget.sale!.customerName.isNotEmpty) {
          //   final cust = allCustomers.firstWhere(
          //     (c) => c.id == widget.sale!.customerName,
          //     orElse: () => CustomerModel(
          //       customerName: '',
          //       customerType: '',
          //       contactNumber: '',
          //       telePhoneNumber: '',
          //       streetAddress1: '',
          //       streetAddress2: '',
          //       city: '',
          //       state: '',
          //       postalCode: '',
          //       countryId: '',
          //       accountNumber: '',
          //       currencyId: '',
          //       emailAddress: '',
          //       bankName: '',
          //       notes: '',
          //       status: '',
          //       addedBy: '',
          //       codeNumber: '',
          //     ),
          //   );
          //   customerNameController.text = cust.customerName;
          // }

          // if ((widget.sale!.discount ?? false) &&
          //     (widget.sale!.discountId?.isNotEmpty ?? false)) {
          //   final found = allDiscounts.firstWhere(
          //     (d) => d.id == widget.sale!.discountId,
          //     orElse: () => DiscountModel.getDiscount(),
          //   );
          //   p.setDiscount(
          //     true,
          //     found.id == null ? null : found,
          //     percent: (widget.bookingModel!.discountPercent ?? 0).toDouble(),
          //     isEdit: true,
          //   );
          // }
          await fetchCommission();
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

    // Add products
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
          type: 'product', // Add type identifier
          cost: product.averageCost ?? 0, // Add cost for profit calculation
        ),
      ),
    );

    // Add services
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
          type: 'service', // Add type identifier
          cost: price, // Services typically don't have cost
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

  // void _calculateRemainingAmount(double grandTotal) {
  //   if (!mounted) return;
  //   double paidAmount = paymentRows.fold(0, (sum, row) => sum + row.amount);

  //   // Add deposit if already paid
  //   if (requireDeposit && depositAlreadyPaid) {
  //     paidAmount += depositAmount;
  //   }
  //   if (isAlreadyPaid &&
  //           !paymentRows.any((row) => row.method?.name == "multiple")) {
  //     for (var row in paymentRows) {
  //       row.amount = grandTotal;
  //     }
  //     paidAmount = grandTotal;
  //   }
  //   remainingAmount = grandTotal - paidAmount;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  double _getRemainingAmount(double grandTotal) {
    double paidAmount = paymentRows.fold(
      0.0,
      (sum, row) => sum + (row.amount ?? 0),
    );
    return grandTotal - paidAmount;
  }

  void _calculateRemainingAmount(double grandTotal) {
    double paidAmount = paymentRows.fold(
      0.0,
      (sum, row) => sum + (row.amount ?? 0),
    );
    double remaining = grandTotal - paidAmount;

    // If it's a single payment method (not multiple), auto-set the amount
    if (paymentRows.length == 1 &&
        !isMultiple //paymentRows.first.method?.id != 'multiple'
        ) {
      paymentRows.first.amount = grandTotal;
    }

    // You can use the remaining amount as needed
    print('Remaining balance: $remaining');
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
        // Ensure deposit doesn't exceed total
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

  // void _applyEditDiscount(MaintenanceBookingProvider p, double subtotal) {
  //   final discountValue = double.tryParse(discountController.text) ?? 0;
  //   p.discountType = selectedDiscountType.id;
  //   if (selectedDiscountType.id == 'percentage') {
  //     p.setDiscountPercent(discountValue);
  //   } else {
  //     // Convert amount to percentage for the provider if needed
  //     final discountPercent =
  //         discountValue > 0 ? (discountValue / subtotal) * 100 : 0;
  //     p.setDiscountPercent(discountPercent.toDouble());
  //   }
  //   _updateAllCalculations(p);
  // }

  void _applyDiscount(MaintenanceBookingProvider p, double subtotal) {
    final discountValue = double.tryParse(discountController.text) ?? 0;
    p.discountType = selectedDiscountType.id;
    if (selectedDiscountType.id == 'percentage') {
      p.setDiscountPercent(discountValue);
    } else {
      // Convert amount to percentage for the provider if needed
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

    //   // apply discount
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
    //   // apply discount
    p.setDiscountPercent(discount);
    _updateAllCalculations(p);
  }

  void _calculateProductsGrandTotal() {
    productsGrandTotal = productRows.fold(0, (sum, row) => sum + row.total);

    // Update the provider with the new products total
    final p = context.read<MaintenanceBookingProvider>();
    // p.setProductsTotal(productsGrandTotal); // Uncomment if you have this method
  }

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

            // Product rows header
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
                // Expanded(
                //     flex: 1,
                //     child: Text('Margin %',
                //         style: TextStyle(fontWeight: FontWeight.bold))),
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
                // Expanded(
                //     flex: 1,
                //     child: Text('VAT',
                //         style: TextStyle(fontWeight: FontWeight.bold))),
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
            // Product rows
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
                  showRemoveButton: true, //productRows.length > 1,
                );
              },
            ),
            const SizedBox(height: 16),
            // Add product button
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
            // Grand total
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

  Future<void> fetchCommission() async {
    try {
      final p = context.read<MaintenanceBookingProvider>();

      final commSnap = await FirebaseFirestore.instance
          .collection('mmEmployeeCommissions')
          .where('bookingId', isEqualTo: widget.sale!.id)
          .limit(1)
          .get();
      if (commSnap.docs.isNotEmpty) {
        final comm = EmployeeCommissionModel.fromDoc(commSnap.docs.first);
        p.setEmployeeCommissionModel(comm);
        p.setCommission(true);
      }
    } catch (e) {
      debugPrint('Error fetching commission: $e');
    }
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
                          //_serviceSelectionSection(context, p),
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

  void saleTemplate(SaleModel saleDetails) async {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return SalesInvoiceDropdownView(sale: saleDetails);
          },
        ),
      );
    }
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
                          double d =
                              double.tryParse(discountController.text) ?? 0;
                          final productsData = Constants.buildProductsData(
                            productRows,
                          );
                          final depositData = {
                            'requireDeposit': requireDeposit,
                            'depositType': selectedDepositType.id,
                            'depositAmount': depositAmount,
                            'depositPercentage': depositPercentage,
                            //'depositAlreadyPaid': depositAlreadyPaid,
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
                          final SaleModel saleDetails =
                              Constants.parseToSaleModel(
                                productsData: productsData,
                                depositData: depositData,
                                paymentData: paymentData,
                                totalRevenue: p.total,
                                discount: d,
                                taxAmount: p.taxAmount,
                                customerName: p.customerId!,
                                truckId: p.truckId ?? "",
                                isEdit: false, //widget.sale != null,
                              );
                          saleTemplate(saleDetails);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          //foregroundColor: Colors.grey[800],
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
                          final productsData = Constants.buildProductsData(
                            productRows,
                          );
                          final depositData = {
                            'requireDeposit': requireDeposit,
                            'depositType': selectedDepositType.id,
                            'depositAmount': depositAmount,
                            'depositPercentage': depositPercentage,
                            //'depositAlreadyPaid': depositAlreadyPaid,
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

                          p.saveBooking(
                            productsData: productsData,
                            depositData: depositData,
                            context: context,
                            onBack: widget.onBack!.call, //close,
                            isEdit: widget.sale != null,
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
              ],
            ),
          ],
        ),
      ),
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

  void close() {
    widget.onBack;
  }

  Widget _buildBookingSummarySection(
    BuildContext context,
    MaintenanceBookingProvider p,
  ) {
    final double subtotal = servicesGrandTotal + productsGrandTotal;
    p.itemsTotal = productsGrandTotal;
    // p.setServicesTotal(servicesGrandTotal);
    // p.setSubtotal(subtotal);
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
          // Ultra-compact header
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
                // Order Items - Ultra compact
                _buildUltraCompactCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Items',
                  children: [
                    _buildRow('Items Total', productsGrandTotal),
                    // if (discountAmount > 0) ...[
                    //   SizedBox(height: 4),
                    //   _buildOrderItem(
                    //     'Discount Applied',
                    //     p.discountAmount,
                    //     Icons.local_offer_outlined,
                    //     const Color(0xFFDC3545),
                    //   ),
                    // ],
                    //if (discountAmount > 0)
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
                    //if (taxAmount > 0) ...[
                    SizedBox(height: 4),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // width: 100,
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
                        // const SizedBox(
                        //   width: 5,
                        // ),
                        _buildRow("", taxAmount, color: Colors.red),
                      ],
                    ),
                    //],
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

                // Discount - Ultra compact
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
                                if (discountValue == null) {
                                  return 'Invalid number';
                                }

                                if (selectedDiscountType.id == 'percentage') {
                                  if (discountValue > 100) {
                                    return 'Cannot exceed 100%';
                                  }
                                  if (discountValue < 0) {
                                    return 'Cannot be negative';
                                  }
                                } else if (selectedDiscountType.id ==
                                    'amount') {
                                  if (discountValue > subtotal) {
                                    return 'Cannot exceed total amount';
                                  }
                                  if (discountValue < 0) {
                                    return 'Cannot be negative';
                                  }
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
                // Deposit - Ultra compact
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
                      // SizedBox(height: 4),
                      // _buildRow('Amount', depositAmount),
                      SizedBox(height: 4),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Already Paid?', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 5),
                          Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                              // checkColor: AppTheme.greenColor,
                              activeColor: AppTheme.greenColor,
                              value: depositAlreadyPaid,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    depositAlreadyPaid = value ?? false;
                                    _updateAllCalculations(p);
                                  });
                                }
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
                // Payment Details - Ultra compact
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
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Already Paid?', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 5),
                        Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            //checkColor: AppTheme.greenColor,
                            activeColor: AppTheme.greenColor,
                            value: isAlreadyPaid,
                            onChanged: (value) {
                              setState(() {
                                isAlreadyPaid = value ?? false;
                                if (!isAlreadyPaid) {
                                  paymentRows = [PaymentRow()];
                                }
                                if (isAlreadyPaid) {
                                  depositAmount = 0;
                                  depositAlreadyPaid = false;
                                  requireDeposit = false;
                                  depositAmountController.clear();
                                  depositPercentage = 0;
                                  remainingAmount = 0;
                                }
                                _calculateRemainingAmount(total);
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Multiple?', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 5),
                        Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            //checkColor: AppTheme.greenColor,
                            activeColor: AppTheme.greenColor,
                            value: isMultiple,
                            onChanged: (value) {
                              // setState(() {
                              //   isMultiple = value ?? false;
                              // });
                              setState(() {
                                if (isAlreadyPaid) {
                                  // allow true/false normally
                                  isMultiple = value ?? false;
                                } else {
                                  // force false if not already paid
                                  isMultiple = false;
                                }
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    // if (isAlreadyPaid) ...[
                    //   SizedBox(height: 6),
                    //   Text('Methods:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                    //   SizedBox(height: 4),
                    //   ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: NeverScrollableScrollPhysics(),
                    //     itemCount: paymentRows.length,
                    //     itemBuilder: (context, index) => _buildUltraCompactPaymentRow(index, total),
                    //   ),
                    //   if (paymentRows.length > 1 ||
                    //       (paymentRows.isNotEmpty && paymentRows.first.method?.id == 'multiple')) ...[
                    //     SizedBox(height: 4),
                    //     SizedBox(
                    //       height: 28,
                    //       child: TextButton.icon(
                    //         onPressed: () {
                    //           setState(() {
                    //             paymentRows.add(PaymentRow());
                    //             _calculateRemainingAmount(total);
                    //           });
                    //         },
                    //         icon: Icon(Icons.add, size: 12),
                    //         label: Text('Add Payment', style: TextStyle(fontSize: 10)),
                    //         style: TextButton.styleFrom(
                    //           padding: EdgeInsets.symmetric(horizontal: 8),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    //   _buildRow(
                    //     'Remaining',
                    //     remainingAmount,
                    //     color: remainingAmount > 0 ? Colors.red : Colors.green,
                    //     bold: true,
                    //   ),
                    // ],
                    // Payment rows
                    // if (isAlreadyPaid)
                    //   ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: paymentRows.length,
                    //     itemBuilder: (context, index) {
                    //       return _buildPaymentRow(index, total);
                    //     },
                    //   ),
                    // if (paymentRows.length > 1 ||
                    //     (paymentRows.isNotEmpty &&
                    //         paymentRows.first.method?.id == 'multiple')) ...[
                    //   const SizedBox(height: 12),
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       ElevatedButton.icon(
                    //         onPressed: () {
                    //           setState(() {
                    //             paymentRows.add(PaymentRow());
                    //             _calculateRemainingAmount(total);
                    //           });
                    //         },
                    //         icon: const Icon(Icons.add, size: 16),
                    //         label: const Text('Add'),
                    //         style: ElevatedButton.styleFrom(
                    //           backgroundColor: AppTheme.greenColor,
                    //           foregroundColor: Colors.white,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ],
                    // In your build method
                    if (isAlreadyPaid)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paymentRows.length,
                        itemBuilder: (context, index) {
                          return _buildPaymentRow(index, total);
                        },
                      ),

                    // if (paymentRows.length > 1 ||
                    //     (paymentRows.isNotEmpty &&
                    //         paymentRows.first.method?.id == 'multiple')) ...[
                    const SizedBox(height: 12),
                    if (isMultiple)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                paymentRows.add(PaymentRow());
                                _calculateRemainingAmount(total);
                              });
                            },
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.greenColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    //],

                    // Add this widget to show remaining balance
                    const SizedBox(height: 12),
                    Text(
                      'Remaining Balance: ${_getRemainingAmount(total).toStringAsFixed(2)} OMR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getRemainingAmount(total) > 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),
                // Attachment
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

                // Action Button - Compact
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        p.orderLoading = true;
                      });
                      double d = double.tryParse(discountController.text) ?? 0;
                      final productsData = Constants.buildProductsData(
                        productRows,
                      ); // final productsData = productRows.map((row) {
                      //   return {
                      //     'type': row.saleItem!.type,
                      //     'productId': row.saleItem!.productId,
                      //     'productName': row.saleItem?.productName,
                      //     'sellingPrice': row.sellingPrice,
                      //     // 'margin': row.margin,
                      //     'quantity': row.quantity,
                      //     'discount': row.discount,
                      //     'applyVat': row.applyVat,
                      //     'subtotal': row.subtotal,
                      //     'vatAmount': row.vatAmount,
                      //     'total': row.total,
                      //     'profit': row.profit,
                      //   };
                      // }).toList();
                      final depositData = {
                        'requireDeposit': requireDeposit,
                        'depositType': selectedDepositType.id,
                        'depositAmount': depositAmount,
                        'depositPercentage': depositPercentage,
                        //'depositAlreadyPaid': depositAlreadyPaid,
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
                                0.0,
                                (sum, row) => sum + (row.amount ?? 0.0),
                              ),
                              // paymentRows.length > 1
                              //     ? paymentRows
                              //         .fold(0.0, (sum, row) => sum + row.amount)
                              //         .toInt()
                              //     // ? paymentRows.fold(
                              //     //     0, (sum, row) => sum + row.amount as int)
                              //     : p.total,
                              'remainingAmount': remainingAmount,
                            }
                          : {
                              'isAlreadyPaid': false,
                              'paymentMethods': [],
                              'totalPaid': 0,
                              'remainingAmount': total,
                            };

                      p.saveBooking(
                        productsData: productsData,
                        depositData: depositData,
                        context: context,
                        onBack: widget.onBack!.call, //close,
                        isEdit: widget.sale != null,
                        total: total,
                        discount: d,
                        taxAmount: taxAmount,
                        paymentData: paymentData,
                        sale: widget.sale,
                        statusType: "pending",
                      );
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

  // Ultra-compact card builder
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

  // Ultra-compact row builder
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

  // Ultra-compact divider
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 0.5,
      color: Color(0xFFDEE2E6),
    );
  }

  // Widget _buildPaymentRow(int index, double grandTotal) {
  //   final paymentRow = paymentRows[index];
  //   bool hasMultiplePaymentMethod =
  //       paymentRows.any((row) => row.method?.name == 'Multiple');
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey[300]!),
  //     ),
  //     child: Row(
  //       children: [
  //         // Payment Method Dropdown
  //         Expanded(
  //           flex: 2,
  //           child: CustomSearchableDropdown(
  //             key: ValueKey('payment_method_$index'),
  //             hintText: 'Method',
  //             items: {for (var m in PaymentMethod.methods) m.id: m.name},
  //             value: paymentRow.method?.id,
  //             onChanged: (value) {
  //               if (value.isNotEmpty) {
  //                 setState(() {
  //                   paymentRow.method =
  //                       PaymentMethod.methods.firstWhere((m) => m.id == value);

  //                   // If selecting "multiple", add more rows
  //                   if (value == 'multiple' && paymentRows.length == 1) {
  //                     paymentRows.add(PaymentRow());
  //                   }

  //                   _calculateRemainingAmount(grandTotal);
  //                 });
  //               }
  //             },
  //           ),
  //         ),
  //         const SizedBox(width: 8),

  //         // Reference Number

  //         Expanded(
  //           flex: 2,
  //           child: TextFormField(
  //             key: ValueKey('payment_ref_$index'),
  //             decoration: const InputDecoration(
  //               labelText: 'Reference',
  //               border: OutlineInputBorder(),
  //               contentPadding:
  //                   EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //             ),
  //             onChanged: (value) {
  //               paymentRow.reference = value;
  //             },
  //           ),
  //         ),
  //         const SizedBox(width: 8),

  //         // Amount

  //         if (hasMultiplePaymentMethod)
  //           Expanded(
  //             flex: 1,
  //             child: TextFormField(
  //               key: ValueKey('payment_amount_$index'),
  //               decoration: const InputDecoration(
  //                 labelText: 'Amount',
  //                 border: OutlineInputBorder(),
  //                 contentPadding:
  //                     EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //               ),
  //               keyboardType: TextInputType.numberWithOptions(decimal: true),
  //               onChanged: (value) {
  //                 paymentRow.amount = double.tryParse(value) ?? 0;
  //                 _calculateRemainingAmount(grandTotal);
  //               },
  //             ),
  //           ),
  //         const SizedBox(width: 8),

  //         // Remove button for multiple payments
  //         if (paymentRows.length > 1)
  //           IconButton(
  //             icon:
  //                 const Icon(Icons.remove_circle, color: Colors.red, size: 20),
  //             onPressed: () {
  //               setState(() {
  //                 paymentRows.removeAt(index);
  //                 _calculateRemainingAmount(grandTotal);
  //               });
  //             },
  //           ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildPaymentRow(int index, double grandTotal) {
    final paymentRow = paymentRows[index];

    // Check if this specific row should show amount field
    // bool shouldShowAmountField = paymentRows.length > 1 ||
    //     paymentRows.any((row) => row.method?.id == 'multiple');

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
          // Payment Method Dropdown
          Expanded(
            flex: 2,
            child: CustomSearchableDropdown(
              key: ValueKey('payment_method_$index'),
              hintText: 'Method',
              items: {for (var m in PaymentMethod.methods) m.id: m.name},
              value: paymentRow.method?.id,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    paymentRow.method = PaymentMethod.methods.firstWhere(
                      (m) => m.id == value,
                    );

                    // If selecting "multiple" in any row, ensure we have at least 2 rows
                    if (isMultiple //value == 'multiple'
                        &&
                        paymentRows.length == 1) {
                      paymentRows.add(PaymentRow());
                    }

                    // If changing from multiple to single method and we have multiple rows,
                    // set the amount to grand total for the first row
                    if (!isMultiple
                        //value != 'multiple'
                        &&
                        index == 0 &&
                        paymentRows.length > 1) {
                      paymentRow.amount = grandTotal;
                      // Remove extra rows if not needed
                      if (paymentRows.length > 1) {
                        paymentRows.removeRange(1, paymentRows.length);
                      }
                    }

                    _calculateRemainingAmount(grandTotal);
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),

          // Reference Number
          Expanded(
            flex: 2,
            child: TextFormField(
              key: ValueKey('payment_ref_$index'),
              decoration: const InputDecoration(
                labelText: 'Reference',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              onChanged: (value) {
                paymentRow.reference = value;
              },
            ),
          ),
          const SizedBox(width: 8),

          // Amount field - only show when appropriate
          if (isMultiple)
            Expanded(
              flex: 1,
              child: TextFormField(
                key: ValueKey('payment_amount_$index'),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidationUtils.price,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    paymentRow.amount = double.tryParse(value) ?? 0;
                    _calculateRemainingAmount(grandTotal);
                  });
                },
              ),
            ),

          // if (shouldShowAmountField) const SizedBox(width: 8),

          // Remove button for multiple payments
          if (paymentRows.length > 1)
            IconButton(
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  paymentRows.removeAt(index);
                  // If we're left with one row and it's not "multiple", set its amount to grand total
                  if (paymentRows.length == 1 &&
                      paymentRows.first.method?.id != 'multiple') {
                    paymentRows.first.amount = grandTotal;
                  }
                  _calculateRemainingAmount(grandTotal);
                });
              },
            ),
        ],
      ),
    );
  }
}

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
  //final TextEditingController _marginController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _marginFocusNode = FocusNode();
  final FocusNode _qtyFocusNode = FocusNode();
  bool _isEditingPrice = true;
  double _originalPrice = 0;
  @override
  void initState() {
    super.initState();
    _updateControllers();
    _priceFocusNode.addListener(_onPriceFocusChange);
    _marginFocusNode.addListener(_onMarginFocusChange);
    _qtyFocusNode.addListener((_onQtyFocusChange));
    if (widget.productRow.type == 'service') {
      _priceController.text =
          widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
    } else {
      _priceController.text =
          widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '0';
    }
  }

  @override
  void dispose() {
    _priceFocusNode.removeListener(_onPriceFocusChange);
    _marginFocusNode.dispose();
    _marginFocusNode.removeListener(_onMarginFocusChange);
    _priceController.dispose();
    _qtyFocusNode.removeListener(_onQtyFocusChange);
    _qtyFocusNode.dispose();
    super.dispose();
  }

  void _focusOnQuantity() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted && _qtyFocusNode.hasFocus == false) {
        FocusScope.of(context).requestFocus(_qtyFocusNode);
      }
    });
  }

  void _startEditingPrice() {
    setState(() {
      _isEditingPrice = true;
      // Store original price for validation
      _originalPrice = widget.productRow.type == 'service'
          ? (widget.productRow.selectedPrice ?? 0)
          : (widget.productRow.sellingPrice ?? 0);
    });

    // Focus on the price field
    FocusScope.of(context).requestFocus(_priceFocusNode);
  }

  void _savePriceChanges() {
    if (!_isEditingPrice) return;

    final newPrice = double.tryParse(_priceController.text) ?? 0;
    final minimumPrice = widget.productRow.saleItem?.minimumPrice ?? 0;

    // Validate minimum price
    if (newPrice < minimumPrice) {
      _showMinimumPriceError(minimumPrice);
      _priceController.text = _originalPrice.toStringAsFixed(2);
      setState(() {
        _isEditingPrice = false;
      });
      return;
    }

    setState(() {
      _isEditingPrice = false;

      if (widget.productRow.type == 'service') {
        widget.productRow.selectedPrice = newPrice;
      } else {
        widget.productRow.sellingPrice = newPrice;

        // Recalculate margin for products
        if (widget.productRow.cost > 0) {
          widget.productRow.margin =
              ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
              100;
        }
      }

      // Recalculate all totals
      widget.productRow.calculateTotals();
      widget.onUpdate(widget.productRow);
    });
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

  void _cancelEditingPrice() {
    setState(() {
      _isEditingPrice = false;
      _priceController.text = _originalPrice.toStringAsFixed(2);
    });
  }

  void _updateControllers() {
    if (!_isEditingPrice) {
      if (widget.productRow.type == 'service') {
        _priceController.text =
            widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
      } else {
        _priceController.text =
            widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '0';
      }
    }
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
                // For services, use the selling price directly
                widget.productRow.selectedPrice = selected.sellingPrice;
                widget.productRow.sellingPrice = null;
                widget.productRow.cost = selected.cost;
                _priceController.text = widget.productRow.selectedPrice
                    .toString();
              } else {
                // For products, set up cost and calculate margin
                widget.productRow.sellingPrice = selected.sellingPrice;
                _priceController.text = widget.productRow.sellingPrice
                    .toString();
                widget.productRow.cost = selected.cost;
                widget.productRow.margin = selected.cost > 0
                    ? ((selected.sellingPrice - selected.cost) /
                              selected.cost) *
                          100
                    : 0;
              }

              _updateControllers();
              widget.productRow.calculateTotals();
              widget.onUpdate(widget.productRow);
              _focusOnQuantity();
            });
          }
        }
      },
    );
  }

  void _onPriceFocusChange() {
    if (!_priceFocusNode.hasFocus) {
      // Lost focus (Tab pressed or clicked elsewhere)
      _updatePriceFromField();
    }
  }

  void _onMarginFocusChange() {
    if (!_marginFocusNode.hasFocus) {
      // Lost focus (Tab pressed or clicked elsewhere)
      //_updateMarginFromField();
    }
  }

  void _onQtyFocusChange() {
    if (!_qtyFocusNode.hasFocus) {
      // Lost focus (Tab pressed or clicked elsewhere)
      //_updateMarginFromField();
    }
  }

  void _updatePriceFromField() {
    if (widget.productRow.type == 'product' &&
        _priceController.text.isNotEmpty) {
      final newPrice = double.tryParse(_priceController.text) ?? 0;
      widget.productRow.sellingPrice = newPrice;

      if (widget.productRow.cost > 0) {
        widget.productRow.margin =
            ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
            100;
        // _marginController.text = widget.productRow.margin.toStringAsFixed(2);
      }

      widget.productRow.calculateTotals();
      widget.onUpdate(widget.productRow);
    }
  }

  @override
  void didUpdateWidget(ProductRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllers();
  }

  Widget _buildPriceInput() {
    // For services, show editable price if user has permission
    if (widget.productRow.type == 'service') {
      return _buildEditablePriceField();
    } else {
      // For products, show editable price field
      return _buildEditablePriceField();
    }
  }

  Widget _buildEditablePriceField() {
    return GestureDetector(
      onTap: _startEditingPrice,
      child: AbsorbPointer(
        absorbing: !_isEditingPrice, // Only allow pointer when editing
        child: TextFormField(
          key: widget.productRow.priceKey,
          controller: _priceController,
          focusNode: _priceFocusNode,
          //enabled: widget.hasPriceEditPermission,
          decoration: InputDecoration(
            labelText: 'Price (OMR)',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, size: 16, color: Colors.green),
                  onPressed: _savePriceChanges,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 16, color: Colors.red),
                  onPressed: _cancelEditingPrice,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            // : widget.hasPriceEditPermission
            //     ? Icon(Icons.edit, size: 16, color: Colors.grey)
            //     : null,
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            _savePriceChanges();
            _focusOnQuantity();
          },

          onTap: () {
            _startEditingPrice();
          },
        ),
      ),
    );
  }

  // void _updateControllers() {
  //   _priceController.text =
  //       widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '';
  //   //_marginController.text = widget.productRow.margin.toStringAsFixed(2);
  // }

  // Widget _buildPriceInput() {
  //   if (widget.productRow.type == 'service') {
  //     // For services, show the fixed price
  //     _priceController.text =
  //         widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
  //     // return Text(
  //     //   'OMR ${widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0.00'}',
  //     //   style: TextStyle(fontSize: 12),
  //     // );
  //   }
  //   // else {
  //   //   _priceController.text =
  //   //       widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '0';
  //   // }
  //   //else {
  //   // For products, show editable price field
  //   return TextFormField(
  //     key: widget.productRow.priceKey,
  //     controller: _priceController,
  //     focusNode: _priceFocusNode,
  //     decoration: const InputDecoration(
  //       labelText: 'Price (OMR)',
  //       border: OutlineInputBorder(),
  //       contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     ),
  //     keyboardType: TextInputType.numberWithOptions(decimal: true),
  //     textInputAction: TextInputAction.next,
  //     onEditingComplete: () {
  //       _updatePriceFromField();
  //       FocusScope.of(context).requestFocus(_marginFocusNode);
  //     },
  //   );
  // }

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
          // Product Dropdown
          Expanded(flex: 2, child: _buildProductDropdown()),
          const SizedBox(width: 8),

          // Price Input
          Expanded(flex: 1, child: _buildPriceInput()),
          const SizedBox(width: 8),

          // Margin Input
          // Expanded(
          //   flex: 1,
          //   child: _buildMarginInput(),
          // ),
          // const SizedBox(width: 8),

          // Quantity Dropdown
          Expanded(flex: 1, child: _buildQuantityInput()),
          const SizedBox(width: 8),

          // Discount Dropdown
          Expanded(flex: 1, child: _buildDiscountInput()),
          const SizedBox(width: 8),

          // Subtotal
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

          // Remove Button
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

  Widget _buildQuantityInput() {
    return TextFormField(
      key: widget.productRow.quantityKey,
      initialValue: widget.productRow.quantity.toString(),
      focusNode: _qtyFocusNode,
      decoration: const InputDecoration(
        labelText: 'Qty',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final quantity = int.tryParse(value) ?? 1;
          if (mounted) {
            setState(() {
              widget.productRow.quantity = quantity;
              widget.productRow.calculateTotals();
              widget.onUpdate(widget.productRow);
            });
          }
        }
      },
      onEditingComplete: () {
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
}
