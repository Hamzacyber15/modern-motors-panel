// // // ignore_for_file: deprecated_member_use

// // import 'dart:async';
// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/services.dart';
// // import 'package:modern_motors_panel/app_theme.dart';
// // import 'package:modern_motors_panel/constants.dart';
// // import 'package:modern_motors_panel/extensions.dart';
// // import 'package:modern_motors_panel/model/attachment_model.dart';
// // import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
// // import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
// // import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/employees_commision_model.dart';
// // import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
// // import 'package:modern_motors_panel/model/product_models/product_model.dart';
// // import 'package:modern_motors_panel/model/sales_model/credit_days_model.dart';
// // import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
// // import 'package:modern_motors_panel/model/services_model/services_model.dart';
// // import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
// // import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/inventory_selection_bridge.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/sales_invoice_dropdown_view.dart';
// // import 'package:modern_motors_panel/modern_motors/widgets/selected_items_page.dart';
// // import 'package:modern_motors_panel/provider/maintenance_booking_provider.dart';
// // import 'package:modern_motors_panel/widgets/dialogue_box_picker.dart';
// // import 'package:modern_motors_panel/widgets/overlay_loader.dart';
// // import 'package:provider/provider.dart';

// // class PaymentMethod {
// //   final String id;
// //   final String name;

// //   PaymentMethod({required this.id, required this.name});

// //   static List<PaymentMethod> get methods => [
// //     PaymentMethod(id: 'cash', name: 'Cash'),
// //     PaymentMethod(id: 'credit_card', name: 'Credit Card'),
// //     PaymentMethod(id: 'Debit Card', name: 'Debit Card'),
// //     PaymentMethod(id: 'bank_transfer', name: 'Bank Transfer'),
// //     PaymentMethod(id: 'pos', name: 'POS'),
// //     PaymentMethod(id: 'multiple', name: 'Multiple'),
// //   ];
// // }

// // class PaymentRow {
// //   PaymentMethod? method;
// //   String reference = '';
// //   double amount = 0;

// //   PaymentRow({this.method, this.reference = '', this.amount = 0});
// // }

// // class DiscountType {
// //   final String id;
// //   final String name;

// //   DiscountType({required this.id, required this.name});

// //   static List<DiscountType> get types => [
// //     DiscountType(id: 'percentage', name: '%'),
// //     DiscountType(id: 'amount', name: 'OMR'),
// //   ];
// // }

// // class DepositType {
// //   final String id;
// //   final String name;

// //   DepositType({required this.id, required this.name});

// //   static List<DepositType> get types => [
// //     DepositType(id: 'percentage', name: '%'),
// //     DepositType(id: 'amount', name: 'OMR'),
// //   ];
// // }

// // class ProductRow {
// //   SaleItem? saleItem; // Changed from ProductModel to SaleItem
// //   String? type; // 'product' or 'service'
// //   double? sellingPrice;
// //   double? selectedPrice;
// //   double margin = 0;
// //   int quantity = 1;
// //   double discount = 0;
// //   bool applyVat = true;
// //   double subtotal = 0;
// //   double vatAmount = 0;
// //   double total = 0;
// //   double profit = 0;
// //   double cost = 0; // Added cost field
// //   late Key dropdownKey;
// //   late Key priceKey;
// //   late Key quantityKey;
// //   late Key discountKey;
// //   ProductRow({
// //     this.total = 0,
// //     this.subtotal = 0,
// //     this.saleItem,
// //     this.type,
// //     this.sellingPrice,
// //     this.selectedPrice,
// //     this.quantity = 1,
// //     this.discount = 0,
// //     this.applyVat = true,
// //     this.cost = 0,
// //   }) {
// //     // Generate keys once in constructor
// //     dropdownKey = UniqueKey();
// //     priceKey = UniqueKey();
// //     quantityKey = UniqueKey();
// //     discountKey = UniqueKey();
// //   }

// //   void calculateTotals() {
// //     if (type == "service") {
// //       subtotal = (selectedPrice ?? 0) * quantity;
// //     } else {
// //       if (sellingPrice == null && margin != 0) {
// //         sellingPrice = cost * (1 + margin / 100);
// //       }
// //       subtotal = (sellingPrice ?? 0) * quantity;
// //     }
// //     final discountAmount = subtotal * (discount / 100);
// //     final amountAfterDiscount = subtotal - discountAmount;
// //     vatAmount = applyVat ? amountAfterDiscount * 0.00 : 0;
// //     total = amountAfterDiscount + vatAmount;
// //     if (type == "product") {
// //       profit = (sellingPrice ?? 0) - cost;
// //     }
// //   }
// // }

// // class PurchaseInvoice extends StatefulWidget {
// //   final VoidCallback? onBack;
// //   final NewPurchaseModel? sale;
// //   final List<InventoryModel>? selectedInventory;
// //   final List<ProductModel>? products;
// //   final String? type;
// //   const PurchaseInvoice({
// //     super.key,
// //     this.onBack,
// //     this.sale,
// //     this.products,
// //     this.selectedInventory,
// //     this.type,
// //   });

// //   @override
// //   State<PurchaseInvoice> createState() => _PurchaseInvoiceState();
// // }

// // class _PurchaseInvoiceState extends State<PurchaseInvoice> {
// //   final customerNameController = TextEditingController();
// //   final discountController = TextEditingController();
// //   final depositAmountController = TextEditingController();

// //   // Data
// //   List<CustomerModel> allCustomers = [];
// //   List<CustomerModel> filteredCustomers = [];
// //   List<MmtrucksModel> allTrucks = [];
// //   List<ServiceTypeModel> allServices = [];
// //   List<DiscountModel> allDiscounts = [];
// //   List<ProductModel> allProducts = [];
// //   CreditDaysModel? creditDays;
// //   List<ProductRow> productRows = [
// //     //ProductRow()
// //   ];
// //   double productsGrandTotal = 0;
// //   bool loading = false;
// //   // Service rows
// //   double servicesGrandTotal = 0;
// //   List<SaleItem> salesItem = [];
// //   bool isAlreadyPaid = false;
// //   bool isMultiple = false;
// //   List<PaymentRow> paymentRows = [PaymentRow()];
// //   double remainingAmount = 0;
// //   bool _isLoadingDiscounts = true;
// //   DiscountType selectedDiscountType = DiscountType.types[0];
// //   DepositType selectedDepositType = DepositType.types[0];
// //   bool requireDeposit = false;
// //   double depositAmount = 0;
// //   double depositPercentage = 0;
// //   bool depositAlreadyPaid = false;
// //   double nextPaymentAmount = 0;
// //   List<AttachmentModel> displayPicture = [];
// //   double invNumber = 0;
// //   int? selectedCreditDays;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final p = context.read<PurchaseInvoiceProvider>();
// //       p.clearData();
// //       DateTime t = DateTime.now();
// //       if (widget.purchase == null) {
// //         p.setBookingTime(t);
// //       } else {
// //         p.setBookingTime(widget.purchase!.createdAt);
// //       }
// //     });
// //     if (widget.purchase == null) {
// //       productRows.add(ProductRow());
// //     }
// //     // if (widget.items != null) {
// //     //   for (var element in widget.items!) {
// //     //     productRows.add(ProductRow(
// //     //       saleItem: element,
// //     //       type: element.type,
// //     //       sellingPrice: element.sellingPrice,
// //     //       quantity: element.quantity,
// //     //       total: element.totalPrice,
// //     //       subtotal: element.discount + element.totalPrice,
// //     //       discount: element.discount,
// //     //     ));
// //     //   }
// //     // }
// //     _loadInitialData();
// //   }

// //   @override
// //   void dispose() {
// //     customerNameController.dispose();
// //     discountController.dispose();
// //     depositAmountController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _loadInitialData() async {
// //     if (mounted) {
// //       setState(() => _isLoadingDiscounts = true);
// //     }
// //     if (widget.purchase == null) {
// //       var value = await Constants.getUniqueNumberValue("MM");
// //       invNumber = value;
// //     } else {
// //       invNumber = double.parse(widget.purchase!.invoice);
// //     }

// //     try {
// //       final results = await Future.wait([
// //         DataFetchService.fetchDiscount(),
// //         DataFetchService.fetchCustomers(),
// //         DataFetchService.fetchTrucks(),
// //         DataFetchService.fetchServiceTypes(),
// //         DataFetchService.fetchProducts(),
// //         DataFetchService.getCreditDays(),
// //       ]);
// //       allDiscounts = results[0] as List<DiscountModel>;
// //       allCustomers = results[1] as List<CustomerModel>;
// //       allTrucks = results[2] as List<MmtrucksModel>;
// //       allServices = results[3] as List<ServiceTypeModel>;
// //       allProducts = results[4] as List<ProductModel>;
// //       creditDays = results[5] as CreditDaysModel;
// //       WidgetsBinding.instance.addPostFrameCallback((_) async {
// //         if (widget.purchase != null) {
// //           CustomerModel? customer;
// //           customer = allCustomers.firstWhere(
// //             (item) => item.id == widget.purchase!.customerName,
// //           );
// //           customerNameController.text = customer.customerName;
// //           final p = context.read<PurchaseInvoiceProvider>();
// //           p.setCustomer(id: widget.purchase!.customerName);
// //           // if (widget.purchase!.items.isNotEmpty) {
// //           //   productRows.clear();
// //           // }
// //           for (var element in widget.purchase!.items) {
// //             productRows.add(
// //               ProductRow(
// //                 saleItem: element,
// //                 type: element.type,
// //                 sellingPrice: element.sellingPrice,
// //                 quantity: element.quantity,
// //                 total: element.totalPrice,
// //                 subtotal: element.discount + element.totalPrice,
// //                 discount: element.discount,
// //               ),
// //             );
// //           }
// //           discountController.text = widget.purchase!.discount.toString();
// //           p.getValues(widget.purchase!.taxAmount, widget.purchase!.total!);
// //           p.discountType = widget.purchase!.discountType;
// //           //p.taxAmount = widget.purchase!.taxAmount;
// //           if (widget.purchase!.discountType == 'percentage') {
// //             selectedDiscountType = DiscountType.types[0];
// //             p.discountType = selectedDiscountType.id;
// //             p.setDiscountPercent(widget.purchase!.discount);
// //           } else {
// //             selectedDiscountType = DiscountType.types[1];
// //             p.discountType = selectedDiscountType.id;
// //             p.setDiscountPercent(widget.purchase!.discount);
// //           }
// //           productsGrandTotal = productRows.fold(
// //             0,
// //             (sum, row) => sum + row.total,
// //           );
// //           // p.grandTotal = widget.purchase!.total!;
// //           //_updateAllCalculations(p);
// //           // if (widget.purchase!.discount > 0) {
// //           //   p.setDiscountAmount(widget.purchase!.discount);
// //           //   //  productsGrandTotal + widget.purchase!.discount;
// //           // }
// //           _applyDiscount(p, productsGrandTotal);
// //           // if (widget.purchase!.paymentData.paymentMethods.isNotEmpty) {
// //           //   isAlreadyPaid = true;
// //           //   paymentRows.clear();
// //           //   if (widget.purchase!.paymentData.paymentMethods.length > 1) {
// //           //     isMultiple = true;
// //           //   }
// //           //   for (var element in widget.purchase!.paymentData.paymentMethods) {
// //           //     paymentRows.add(
// //           //       PaymentRow(
// //           //         method: PaymentMethod(
// //           //           id: element.method,
// //           //           name: element.method,
// //           //         ),
// //           //         amount: element.amount,
// //           //       ),
// //           //     );
// //           //   }
// //           // }
// //           if (widget.purchase!.paymentData.paymentMethods.isNotEmpty) {
// //             isAlreadyPaid = true;
// //             paymentRows.clear();

// //             debugPrint('Loading payment data from sale:');
// //             debugPrint(
// //               'Number of payment methods: ${widget.purchase!.paymentData.paymentMethods.length}',
// //             );
// //             debugPrint(
// //               'Is multiple: ${widget.purchase!.paymentData.paymentMethods.length > 1}',
// //             );

// //             isMultiple = widget.purchase!.paymentData.paymentMethods.length > 1;

// //             for (
// //               var i = 0;
// //               i < widget.purchase!.paymentData.paymentMethods.length;
// //               i++
// //             ) {
// //               final element = widget.purchase!.paymentData.paymentMethods[i];
// //               debugPrint(
// //                 'Payment method $i: ${element.method}, Reference: ${element.reference}, Amount: ${element.amount}',
// //               );
// //               PaymentMethod? paymentMethod;
// //               try {
// //                 paymentMethod = PaymentMethod.methods.firstWhere(
// //                   (method) =>
// //                       method.id.toLowerCase() == element.method?.toLowerCase(),
// //                 );
// //               } catch (e) {
// //                 // If method not found in predefined list, create a custom one
// //                 paymentMethod = PaymentMethod(
// //                   id: element.method ?? 'unknown',
// //                   name: element.method ?? 'Unknown',
// //                 );
// //               }
// //               final newPaymentRow = PaymentRow(
// //                 method: paymentMethod,
// //                 reference: element.reference,
// //                 amount: element.amount,
// //               );
// //               paymentRows.add(newPaymentRow);
// //               debugPrint(
// //                 'Added PaymentRow: ${newPaymentRow.method?.name}, ${newPaymentRow.reference}, ${newPaymentRow.amount}',
// //               );
// //             }
// //             WidgetsBinding.instance.addPostFrameCallback((_) {
// //               if (mounted) {
// //                 final double subtotal = servicesGrandTotal + productsGrandTotal;
// //                 final double discountAmount = p.discountAmount;
// //                 final double amountAfterDiscount = subtotal - discountAmount;
// //                 final double taxAmount = p.getIsTaxApply
// //                     ? amountAfterDiscount * (p.taxPercent / 100)
// //                     : 0;
// //                 final double total = amountAfterDiscount + taxAmount;

// //                 _calculateRemainingAmount(total);
// //                 // Force UI update
// //                 if (mounted) {
// //                   setState(() {});
// //                 }
// //               }
// //             });
// //             WidgetsBinding.instance.addPostFrameCallback((_) {
// //               if (widget.purchase != null) {
// //                 final double subtotal = servicesGrandTotal + productsGrandTotal;
// //                 final double discountAmount = p.discountAmount;
// //                 final double amountAfterDiscount = subtotal - discountAmount;
// //                 final double taxAmount = p.getIsTaxApply
// //                     ? amountAfterDiscount * (p.taxPercent / 100)
// //                     : 0;
// //                 final double total = amountAfterDiscount + taxAmount;

// //                 _ensurePaymentAmounts(total);
// //               }
// //             });
// //           }
// //         }
// //       });
// //       salesItem = mergeProductsAndServices(allProducts, allServices);
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(
// //           context,
// //         ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
// //       }
// //     } finally {
// //       if (mounted) setState(() => _isLoadingDiscounts = false);
// //     }
// //   }

// //   List<SaleItem> mergeProductsAndServices(
// //     List<ProductModel> products,
// //     List<ServiceTypeModel> services,
// //   ) {
// //     List<SaleItem> mergedList = [];

// //     // Add products
// //     mergedList.addAll(
// //       products.map(
// //         (product) => SaleItem(
// //           discount: 0,
// //           margin: 0,
// //           minimumPrice: product.minimumPrice ?? 0,
// //           productId: product.id ?? '',
// //           productName: product.productName ?? '',
// //           quantity: 1,
// //           sellingPrice: product.sellingPrice ?? product.lastCost ?? 0,
// //           totalPrice: (product.sellingPrice ?? product.lastCost ?? 0) * 1,
// //           unitPrice: product.averageCost ?? product.lastCost ?? 0,
// //           type: 'product', // Add type identifier
// //           cost: product.averageCost ?? 0, // Add cost for profit calculation
// //         ),
// //       ),
// //     );

// //     // Add services
// //     mergedList.addAll(
// //       services.map((service) {
// //         double price = service.prices?.isNotEmpty == true
// //             ? (service.prices?[0] as num).toDouble()
// //             : 0;

// //         return SaleItem(
// //           discount: 0,
// //           margin: 0,
// //           productId: service.id ?? '',
// //           productName: service.name,
// //           minimumPrice: service.minimumPrice ?? 0,
// //           quantity: 1,
// //           sellingPrice: price,
// //           totalPrice: price,
// //           unitPrice: price,
// //           type: 'service', // Add type identifier
// //           cost: price, // Services typically don't have cost
// //         );
// //       }),
// //     );

// //     return mergedList;
// //   }

// //   void _addProductRow() {
// //     if (mounted) {
// //       setState(() {
// //         productRows.add(ProductRow());
// //       });
// //     }
// //   }

// //   double _getRemainingAmount(double grandTotal) {
// //     double paidAmount = paymentRows.fold(
// //       0.0,
// //       (sum, row) => sum + (row.amount ?? 0),
// //     );
// //     return grandTotal - paidAmount;
// //   }

// //   void _calculateRemainingAmount(double grandTotal) {
// //     double paidAmount = _getCurrentTotalPaid();

// //     // Auto-set amounts for single payment method
// //     if (isAlreadyPaid && paymentRows.length == 1 && !isMultiple) {
// //       if (paymentRows.first.amount == 0) {
// //         paymentRows.first.amount = grandTotal;
// //         paidAmount = grandTotal;
// //       }
// //     }

// //     remainingAmount = grandTotal - paidAmount;

// //     // Ensure remaining amount is not negative
// //     if (remainingAmount < 0) {
// //       remainingAmount = 0;
// //     }
// //   }

// //   void _ensurePaymentAmounts(double grandTotal) {
// //     if (isAlreadyPaid && paymentRows.isNotEmpty) {
// //       double totalPaid = paymentRows.fold(
// //         0.0,
// //         (sum, row) => sum + (row.amount ?? 0.0),
// //       );

// //       // If no amounts are set but payment is marked as already paid, set amounts
// //       if (totalPaid == 0 && grandTotal > 0) {
// //         if (paymentRows.length == 1 && !isMultiple) {
// //           // Single payment - set to grand total
// //           paymentRows.first.amount = grandTotal;
// //         } else if (paymentRows.length > 1 || isMultiple) {
// //           // Multiple payments - distribute equally (or you can implement your own logic)
// //           double equalAmount = grandTotal / paymentRows.length;
// //           for (var row in paymentRows) {
// //             row.amount = equalAmount;
// //           }
// //         }
// //         _calculateRemainingAmount(grandTotal);
// //       }
// //     }
// //   }

// //   void _updateAllCalculations(PurchaseInvoiceProvider p) {
// //     if (!mounted) return;
// //     final double subtotal = servicesGrandTotal + productsGrandTotal;
// //     final double discountAmount = p.discountAmount;
// //     final double amountAfterDiscount = subtotal - discountAmount;
// //     final double taxAmount = p.getIsTaxApply
// //         ? amountAfterDiscount * (p.taxPercent / 100)
// //         : 0;
// //     final double total = amountAfterDiscount + taxAmount;

// //     _updateDepositCalculation(total, p);
// //   }

// //   void _updateDepositCalculation(
// //     double grandTotal,
// //     PurchaseInvoiceProvider p,
// //   ) {
// //     if (requireDeposit) {
// //       if (selectedDepositType.id == 'percentage') {
// //         depositAmount = grandTotal * (depositPercentage / 100);
// //       } else {
// //         depositAmount = double.tryParse(depositAmountController.text) ?? 0;
// //         // Ensure deposit doesn't exceed total
// //         if (depositAmount > grandTotal) {
// //           depositAmount = grandTotal;
// //           depositAmountController.text = grandTotal.toStringAsFixed(2);
// //         }
// //       }
// //       p.depositAmount = depositAmount;
// //       nextPaymentAmount = grandTotal - depositAmount;
// //       p.remainingAmount = nextPaymentAmount;
// //     } else {
// //       depositAmount = 0;
// //       nextPaymentAmount = grandTotal;
// //     }
// //     _calculateRemainingAmount(grandTotal);
// //   }

// //   void _applyDiscount(PurchaseInvoiceProvider p, double subtotal) {
// //     final discountValue = double.tryParse(discountController.text) ?? 0;
// //     p.discountType = selectedDiscountType.id;
// //     if (selectedDiscountType.id == 'percentage') {
// //       p.setDiscountPercent(discountValue);
// //     } else {
// //       // Convert amount to percentage for the provider if needed
// //       final discountPercent = discountValue > 0
// //           ? (discountValue / subtotal) * 100
// //           : 0;
// //       if (widget.purchase != null) {
// //         p.setDiscountValue(widget.purchase!.discount);
// //       } else {
// //         p.setDiscountPercent(discountPercent.toDouble());
// //       }
// //     }
// //     _updateAllCalculations(p);
// //   }

// //   void _removeProductRow(int index, PurchaseInvoiceProvider p) {
// //     if (mounted) {
// //       setState(() {
// //         if (productRows.length > 1) {
// //           productRows.removeAt(index);
// //           _calculateProductsGrandTotal();
// //         } else {
// //           productRows.clear();
// //           productsGrandTotal = 0;
// //           p.setProductsTotal(0);
// //         }
// //       });
// //     }
// //     discountController.clear();
// //     final discount = double.tryParse(discountController.text) ?? 0;

// //     //   // apply discount
// //     p.setDiscountPercent(discount);
// //     _updateAllCalculations(p);
// //   }

// //   void _updateProductRow(
// //     int index,
// //     ProductRow updatedRow,
// //     PurchaseInvoiceProvider p,
// //   ) {
// //     if (mounted) {
// //       setState(() {
// //         productRows[index] = updatedRow;
// //         _calculateProductsGrandTotal();
// //       });
// //     }
// //     discountController.clear();
// //     final discount = double.tryParse(discountController.text) ?? 0;
// //     //   // apply discount
// //     p.setDiscountPercent(discount);
// //     _updateAllCalculations(p);
// //   }

// //   void _calculateProductsGrandTotal() {
// //     productsGrandTotal = productRows.fold(0, (sum, row) => sum + row.total);

// //     // Update the provider with the new products total
// //     final p = context.read<PurchaseInvoiceProvider>();
// //     // p.setProductsTotal(productsGrandTotal); // Uncomment if you have this method
// //   }

// //   Widget _productSelectionSection(
// //     BuildContext context,
// //     PurchaseInvoiceProvider p,
// //   ) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: AppTheme.borderColor),
// //           color: AppTheme.whiteColor,
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Products',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 16),

// //             // Product rows header
// //             const Row(
// //               children: [
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text(
// //                     'Item',
// //                     style: TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   flex: 1,
// //                   child: Text(
// //                     'Price',
// //                     style: TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 // Expanded(
// //                 //     flex: 1,
// //                 //     child: Text('Margin %',
// //                 //         style: TextStyle(fontWeight: FontWeight.bold))),
// //                 Expanded(
// //                   flex: 1,
// //                   child: Text(
// //                     'Qty',
// //                     style: TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   flex: 1,
// //                   child: Text(
// //                     'Discount',
// //                     style: TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   flex: 1,
// //                   child: Text(
// //                     'Subtotal',
// //                     style: TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 // Expanded(
// //                 //     flex: 1,
// //                 //     child: Text('VAT',
// //                 //         style: TextStyle(fontWeight: FontWeight.bold))),
// //                 Expanded(
// //                   flex: 1,
// //                   child: Text(
// //                     'Total',
// //                     style: TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 SizedBox(width: 40),
// //               ],
// //             ),
// //             const SizedBox(height: 8),
// //             // Product rows
// //             ListView.builder(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: productRows.length,
// //               itemBuilder: (context, index) {
// //                 return ProductRowWidget(
// //                   productRow: productRows[index],
// //                   allItems: salesItem,
// //                   index: index,
// //                   onUpdate: (updatedRow) =>
// //                       _updateProductRow(index, updatedRow, p),
// //                   onRemove: () => _removeProductRow(index, p),
// //                   showRemoveButton: true, //productRows.length > 1,
// //                 );
// //               },
// //             ),
// //             const SizedBox(height: 16),
// //             // Add product button
// //             Align(
// //               alignment: Alignment.centerRight,
// //               child: ElevatedButton.icon(
// //                 onPressed: _addProductRow,
// //                 icon: const Icon(Icons.add),
// //                 label: const Text('Add Product'),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             const Divider(),
// //             // Grand total
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 const Text(
// //                   'Products Grand Total:',
// //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 ),
// //                 Text(
// //                   'OMR ${productsGrandTotal.toStringAsFixed(2)}',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: AppTheme.primaryColor,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _pickBookingDate(PurchaseInvoiceProvider p) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: p.saleDate,
// //       firstDate: DateTime(2023),
// //       lastDate: DateTime(2050),
// //     );
// //     if (picked != null) {
// //       if (!mounted) return;
// //       final t = await showTimePicker(
// //         context: context,
// //         initialTime: TimeOfDay.fromDateTime(p.saleDate),
// //       );
// //       final finalDt = (t == null)
// //           ? DateTime(picked.year, picked.month, picked.day)
// //           : DateTime(picked.year, picked.month, picked.day, t.hour, t.minute);

// //       p.setBookingTime(finalDt);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: AppTheme.backgroundGreyColor,
// //       child: Consumer<PurchaseInvoiceProvider>(
// //         builder: (context, p, _) {
// //           return SingleChildScrollView(
// //             child: Form(
// //               key: p.createBookingKey,
// //               child: OverlayLoader(
// //                 loader: _isLoadingDiscounts,
// //                 child: Column(
// //                   children: [
// //                     PageHeaderWidget(
// //                       title: 'Create Purchase Invoice',
// //                       buttonText: 'Back to Invoices',
// //                       subTitle: 'Create New Purchase Invoice',
// //                       onCreateIcon: 'assets/images/back.png',
// //                       selectedItems: [],
// //                       buttonWidth: 0.25,
// //                       onCreate: widget.onBack!.call,
// //                       onDelete: () async {},
// //                     ),
// //                     20.h,
// //                     _topCard(context, p),
// //                     12.h,
// //                     //_serviceSelectionSection(context, p),
// //                     12.h,
// //                     p.orderLoading
// //                         ? MmloadingWidget()
// //                         : Column(
// //                             children: [
// //                               _productSelectionSection(context, p),
// //                               12.h,
// //                               _middleRow(context, p),
// //                             ],
// //                           ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   void saleTemplate(NewPurchaseModel saleDetails) async {
// //     if (mounted) {
// //       Navigator.of(context).push(
// //         MaterialPageRoute(
// //           builder: (_) {
// //             return SalesInvoiceDropdownView(sale: saleDetails);
// //           },
// //         ),
// //       );
// //     }
// //   }

// //   Widget _topCard(BuildContext context, PurchaseInvoiceProvider p) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Container(
// //         padding: const EdgeInsets.all(14),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: AppTheme.borderColor),
// //           color: AppTheme.whiteColor,
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             8.h,
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(
// //                   "${"Invoice #"} MM-${invNumber.toString()}",
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 16,
// //                     color: AppTheme.pageHeaderTitleColor,
// //                   ),
// //                 ),
// //                 Row(
// //                   children: [
// //                     Tooltip(
// //                       message: 'Preview Invoice',
// //                       preferBelow: false,
// //                       verticalOffset: 20,
// //                       decoration: BoxDecoration(
// //                         color: Colors.grey[800],
// //                         borderRadius: BorderRadius.circular(6),
// //                       ),
// //                       textStyle: TextStyle(color: Colors.white, fontSize: 12),
// //                       child: ElevatedButton.icon(
// //                         onPressed: () {
// //                           double d =
// //                               double.tryParse(discountController.text) ?? 0;
// //                           final productsData = Constants.buildProductsData(
// //                             productRows,
// //                           );
// //                           final depositData = {
// //                             'requireDeposit': requireDeposit,
// //                             'depositType': selectedDepositType.id,
// //                             'depositAmount': depositAmount,
// //                             'depositPercentage': depositPercentage,
// //                             //'depositAlreadyPaid': depositAlreadyPaid,
// //                             'nextPaymentAmount': nextPaymentAmount,
// //                           };
// //                           final paymentData = isAlreadyPaid
// //                               ? {
// //                                   'isAlreadyPaid': true,
// //                                   'paymentMethods': paymentRows
// //                                       .map(
// //                                         (row) => {
// //                                           'method': row.method?.id,
// //                                           'methodName': row.method?.name,
// //                                           'reference': row.reference,
// //                                           'amount': row.amount,
// //                                         },
// //                                       )
// //                                       .toList(),
// //                                   'totalPaid': paymentRows.fold(
// //                                     0,
// //                                     (sum, row) => sum + row.amount as int,
// //                                   ),
// //                                   'remainingAmount': remainingAmount,
// //                                 }
// //                               : {
// //                                   'isAlreadyPaid': false,
// //                                   'paymentMethods': [],
// //                                   'totalPaid': 0,
// //                                   'remainingAmount': p.total,
// //                                 };
// //                           final NewPurchaseModel saleDetails =
// //                               Constants.parseToNewPurchaseModel(
// //                                 productsData: productsData,
// //                                 depositData: depositData,
// //                                 paymentData: paymentData,
// //                                 totalRevenue: p.total,
// //                                 discount: d,
// //                                 taxAmount: p.taxAmount,
// //                                 customerName: p.customerId!,
// //                                 truckId: p.truckId ?? "",
// //                                 isEdit: false, //widget.purchase != null,
// //                               );
// //                           saleTemplate(saleDetails);
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: AppTheme.primaryColor,
// //                           //foregroundColor: Colors.grey[800],
// //                           elevation: 0,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: 12,
// //                             vertical: 8,
// //                           ),
// //                         ),
// //                         icon: Icon(
// //                           Icons.preview_sharp,
// //                           size: 18,
// //                           color: AppTheme.whiteColor,
// //                         ),
// //                         label: Text('Preview', style: TextStyle(fontSize: 14)),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Tooltip(
// //                       message: 'Save as Draft',
// //                       preferBelow: false,
// //                       verticalOffset: 20,
// //                       decoration: BoxDecoration(
// //                         color: Colors.grey[800],
// //                         borderRadius: BorderRadius.circular(6),
// //                       ),
// //                       textStyle: TextStyle(color: Colors.white, fontSize: 12),
// //                       child: ElevatedButton.icon(
// //                         onPressed: () {
// //                           double d =
// //                               double.tryParse(discountController.text) ?? 0;
// //                           final productsData = Constants.buildProductsData(
// //                             productRows,
// //                           );
// //                           final depositData = {
// //                             'requireDeposit': requireDeposit,
// //                             'depositType': selectedDepositType.id,
// //                             'depositAmount': depositAmount,
// //                             'depositPercentage': depositPercentage,
// //                             //'depositAlreadyPaid': depositAlreadyPaid,
// //                             'nextPaymentAmount': nextPaymentAmount,
// //                           };
// //                           final paymentData = isAlreadyPaid
// //                               ? {
// //                                   'isAlreadyPaid': true,
// //                                   'paymentMethods': paymentRows
// //                                       .map(
// //                                         (row) => {
// //                                           'method': row.method?.id,
// //                                           'methodName': row.method?.name,
// //                                           'reference': row.reference,
// //                                           'amount': row.amount,
// //                                         },
// //                                       )
// //                                       .toList(),
// //                                   'totalPaid': paymentRows.fold(
// //                                     0,
// //                                     (sum, row) => sum + row.amount as int,
// //                                   ),
// //                                   'remainingAmount': remainingAmount,
// //                                 }
// //                               : {
// //                                   'isAlreadyPaid': false,
// //                                   'paymentMethods': [],
// //                                   'totalPaid': 0,
// //                                   'remainingAmount': p.total,
// //                                 };

// //                           p.saveBooking(
// //                             productsData: productsData,
// //                             depositData: depositData,
// //                             context: context,
// //                             onBack: widget.onBack!.call, //close,
// //                             isEdit: widget.purchase != null,
// //                             total: p.grandTotal,
// //                             discount: d,
// //                             taxAmount: p.taxAmount,
// //                             paymentData: paymentData,
// //                             statusType: "draft",
// //                           );
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.grey[200],
// //                           foregroundColor: Colors.grey[800],
// //                           elevation: 0,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: 12,
// //                             vertical: 8,
// //                           ),
// //                         ),
// //                         icon: Icon(Icons.save, size: 18),
// //                         label: Text('Draft', style: TextStyle(fontSize: 14)),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             16.h,
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Expanded(
// //                   child: CustomMmTextField(
// //                     onTap: () => _pickBookingDate(p),
// //                     readOnly: true,
// //                     labelText: 'Invoice Date',
// //                     hintText: 'Invoice Date',
// //                     controller: p.bookingDateController,
// //                     autovalidateMode: _isLoadingDiscounts
// //                         ? AutovalidateMode.disabled
// //                         : AutovalidateMode.onUserInteraction,
// //                     validator: (v) =>
// //                         (v == null || v.isEmpty) ? 'Select Invoice date' : null,
// //                   ),
// //                 ),
// //                 if (p.billingParty != BillingParty.ish) ...[
// //                   Expanded(
// //                     child: Column(
// //                       children: [
// //                         CustomMmTextField(
// //                           labelText: 'Customer Name',
// //                           hintText: 'Customer Name',
// //                           controller: customerNameController,
// //                           autovalidateMode: AutovalidateMode.onUserInteraction,
// //                           validator: ValidationUtils.customerName,
// //                           onChanged: (value) {
// //                             setState(() {
// //                               if (value.isNotEmpty) {
// //                                 filteredCustomers = allCustomers
// //                                     .where(
// //                                       (c) => c.customerName
// //                                           .toLowerCase()
// //                                           .contains(value.toLowerCase()),
// //                                     )
// //                                     .toList();
// //                               } else {
// //                                 filteredCustomers = [];
// //                               }
// //                             });
// //                           },
// //                         ),
// //                         if (filteredCustomers.isNotEmpty)
// //                           Padding(
// //                             padding: const EdgeInsets.only(top: 8.0),
// //                             child: Material(
// //                               elevation: 4,
// //                               borderRadius: BorderRadius.circular(8),
// //                               child: Container(
// //                                 padding: const EdgeInsets.only(
// //                                   left: 6,
// //                                   right: 6,
// //                                   top: 10,
// //                                 ),
// //                                 height: 150,
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(8),
// //                                   border: Border.all(
// //                                     color: Colors.grey.shade300,
// //                                   ),
// //                                 ),
// //                                 child: ListView.builder(
// //                                   itemCount: filteredCustomers.length,
// //                                   padding: EdgeInsets.zero,
// //                                   itemBuilder: (context, index) {
// //                                     final c = filteredCustomers[index];
// //                                     return Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         InkWell(
// //                                           child: Padding(
// //                                             padding: const EdgeInsets.symmetric(
// //                                               horizontal: 6.0,
// //                                               vertical: 8,
// //                                             ),
// //                                             child: Text(c.customerName),
// //                                           ),
// //                                           onTap: () {
// //                                             p.setCustomer(id: c.id!);
// //                                             setState(() {
// //                                               customerNameController.text =
// //                                                   c.customerName;
// //                                               filteredCustomers.clear();
// //                                             });
// //                                           },
// //                                         ),
// //                                         if (index !=
// //                                             filteredCustomers.length - 1)
// //                                           const Divider(height: 1),
// //                                       ],
// //                                     );
// //                                   },
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                       ],
// //                     ),
// //                   ),
// //                   12.w,
// //                 ],
// //                 Expanded(
// //                   child: CustomSearchableDropdown(
// //                     key: const ValueKey('truck_dropdown'),
// //                     hintText: 'Choose Truck',
// //                     value: p.truckId,
// //                     items: {
// //                       for (var t in allTrucks.where(
// //                         (t) => t.ownById == p.customerId,
// //                       ))
// //                         t.id!: '${t.code}-${t.plateNumber}',
// //                     },
// //                     onChanged: (val) => p.setTruckId(val),
// //                   ),
// //                 ),
// //                 12.w,

// //                 Expanded(
// //                   child: CustomSearchableDropdown(
// //                     key: const ValueKey('Due Date'),
// //                     hintText: 'Due Date',
// //                     value: p.truckId,
// //                     items: {
// //                       for (var t in allTrucks.where(
// //                         (t) => t.id == p.customerId,
// //                       ))
// //                         t.id!: '${t.code}-${t.plateNumber}',
// //                     },
// //                     onChanged: (val) => p.setTruckId(val),
// //                   ),
// //                 ),

// //                 Expanded(child: _buildCreditDropdown(p)),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCreditDropdown(PurchaseInvoiceProvider provider) {
// //     // Check if creditDays is null or not loaded yet
// //     if (creditDays == null || creditDays!.creditDays.isEmpty) {
// //       return CustomSearchableDropdown(
// //         hintText: 'Loading credit days...',
// //         items: {},
// //         value: null,
// //         onChanged: (value) {},
// //       );
// //     }

// //     // Create a map for credit days selection
// //     final Map<String, String> creditDaysMap = {};

// //     for (var days in creditDays!.creditDays) {
// //       creditDaysMap[days.toString()] = '$days days';
// //     }

// //     return CustomSearchableDropdown(
// //       key: ValueKey('credit_days_${creditDaysMap.length}'),
// //       hintText: 'Select Credit Days',
// //       items: creditDaysMap,
// //       value: selectedCreditDays?.toString(),
// //       onChanged: (value) {
// //         if (value.isNotEmpty) {
// //           if (mounted) {
// //             setState(() {
// //               selectedCreditDays = int.parse(value);
// //               //  provider.setTruckId(selectedCreditDays);
// //               // You can also update the provider if needed
// //               // context.read<PurchaseInvoiceProvider>().setCreditDays(selectedCreditDays);
// //             });
// //           }
// //         }
// //       },
// //     );
// //   }

// //   Widget _middleRow(BuildContext context, PurchaseInvoiceProvider p) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.end,
// //         mainAxisAlignment: MainAxisAlignment.end,
// //         children: [
// //           SizedBox(width: 700, child: _buildBookingSummarySection(context, p)),
// //         ],
// //       ),
// //     );
// //   }

// //   void close() {
// //     widget.onBack;
// //   }

// //   Widget _buildBookingSummarySection(
// //     BuildContext context,
// //     PurchaseInvoiceProvider p,
// //   ) {
// //     final double subtotal = servicesGrandTotal + productsGrandTotal;
// //     p.itemsTotal = productsGrandTotal;
// //     // p.setServicesTotal(servicesGrandTotal);
// //     // p.setSubtotal(subtotal);
// //     if (mounted) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         if (mounted) {
// //           p.setServicesTotal(servicesGrandTotal);
// //           p.setSubtotal(subtotal);
// //         }
// //       });
// //     }

// //     final double discountAmount = p.discountAmount;
// //     final double amountAfterDiscount = subtotal - discountAmount;
// //     final double taxAmount = p.getIsTaxApply
// //         ? amountAfterDiscount * (p.taxPercent / 100)
// //         : 0;
// //     final double total = amountAfterDiscount + taxAmount;
// //     p.grandTotal = total;
// //     return Container(
// //       margin: const EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.03),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           // Ultra-compact header
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //             decoration: BoxDecoration(
// //               color: Color(0xFF3B82F6),
// //               borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
// //             ),
// //             child: Row(
// //               children: [
// //                 Icon(Icons.receipt_long_rounded, color: Colors.white, size: 18),
// //                 SizedBox(width: 6),
// //                 Text(
// //                   'Invoice Summary',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w600,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           Padding(
// //             padding: const EdgeInsets.all(12),
// //             child: Column(
// //               children: [
// //                 // Order Items - Ultra compact
// //                 _buildUltraCompactCard(
// //                   icon: Icons.inventory_2_outlined,
// //                   title: 'Items',
// //                   children: [
// //                     _buildRow('Items Total', productsGrandTotal),
// //                     // if (discountAmount > 0) ...[
// //                     //   SizedBox(height: 4),
// //                     //   _buildOrderItem(
// //                     //     'Discount Applied',
// //                     //     p.discountAmount,
// //                     //     Icons.local_offer_outlined,
// //                     //     const Color(0xFFDC3545),
// //                     //   ),
// //                     // ],
// //                     //if (discountAmount > 0)
// //                     if (p.discountAmount > 0)
// //                       _buildRow(
// //                         'Discount',
// //                         -p.discountAmount,
// //                         color: Colors.red,
// //                       ),
// //                     _buildDivider(),
// //                     const SizedBox(height: 4),
// //                     _buildRow(
// //                       'Subtotal',
// //                       subtotal - discountAmount,
// //                       bold: true,
// //                     ),
// //                     //if (taxAmount > 0) ...[
// //                     SizedBox(height: 4),

// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Expanded(
// //                           // width: 100,
// //                           child: Row(
// //                             children: [
// //                               Text(
// //                                 'VAT (% 5)',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w400,
// //                                   color: Colors.red,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 5),
// //                               Transform.scale(
// //                                 scale: 0.9,
// //                                 child: Checkbox(
// //                                   activeColor: AppTheme.greenColor,
// //                                   value: p.getIsTaxApply,
// //                                   onChanged: (v) =>
// //                                       p.setTax(v ?? false, p.taxPercent),
// //                                   materialTapTargetSize:
// //                                       MaterialTapTargetSize.shrinkWrap,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         // const SizedBox(
// //                         //   width: 5,
// //                         // ),
// //                         _buildRow("", taxAmount, color: Colors.red),
// //                       ],
// //                     ),
// //                     //],
// //                     _buildDivider(),
// //                     const SizedBox(height: 4),
// //                     _buildRow('Total', total, bold: true),
// //                     if (depositAlreadyPaid) ...[
// //                       SizedBox(height: 4),
// //                       _buildRow('Paid', -depositAmount, color: Colors.red),
// //                       SizedBox(height: 2),
// //                       _buildRow('Balance Due', remainingAmount, bold: true),
// //                     ],
// //                   ],
// //                 ),

// //                 SizedBox(height: 8),

// //                 // Discount - Ultra compact
// //                 _buildUltraCompactCard(
// //                   icon: Icons.local_offer_outlined,
// //                   title: 'Discount',
// //                   trailing: p.discountAmount > 0
// //                       ? Container(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: 6,
// //                             vertical: 2,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Color(0xFF198754),
// //                             borderRadius: BorderRadius.circular(4),
// //                           ),
// //                           child: Text(
// //                             'OMR ${p.discountAmount.toStringAsFixed(2)} OFF',
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.w600,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                         )
// //                       : null,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: SizedBox(
// //                             height: 40,
// //                             child: CustomSearchableDropdown(
// //                               key: ValueKey(
// //                                 'discount_type_${selectedDiscountType.id}',
// //                               ),
// //                               hintText: 'Type',
// //                               value: selectedDiscountType.id,
// //                               items: {
// //                                 for (var type in DiscountType.types)
// //                                   type.id: type.name,
// //                               },
// //                               onChanged: (value) {
// //                                 if (value.isNotEmpty) {
// //                                   setState(() {
// //                                     selectedDiscountType = DiscountType.types
// //                                         .firstWhere(
// //                                           (type) => type.id == value,
// //                                           orElse: () => DiscountType.types[0],
// //                                         );
// //                                     discountController.clear();
// //                                     p.setDiscountAmount(0);
// //                                     p.setDiscountPercent(0);
// //                                   });
// //                                   _updateAllCalculations(p);
// //                                 }
// //                               },
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(width: 6),
// //                         Expanded(
// //                           flex: 2,
// //                           child: SizedBox(
// //                             height: 32,
// //                             child: TextFormField(
// //                               controller: discountController,
// //                               decoration: InputDecoration(
// //                                 hintText:
// //                                     selectedDiscountType.id == 'percentage'
// //                                     ? '%'
// //                                     : 'Amount',
// //                                 hintStyle: TextStyle(fontSize: 11),
// //                                 prefixIcon: Icon(
// //                                   selectedDiscountType.id == 'percentage'
// //                                       ? Icons.percent
// //                                       : Icons.attach_money,
// //                                   size: 14,
// //                                 ),
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(6),
// //                                 ),
// //                                 contentPadding: EdgeInsets.symmetric(
// //                                   horizontal: 8,
// //                                   vertical: 4,
// //                                 ),
// //                                 isDense: true,
// //                               ),
// //                               style: TextStyle(fontSize: 14),
// //                               keyboardType: TextInputType.numberWithOptions(
// //                                 decimal: true,
// //                               ),
// //                               validator: (value) {
// //                                 if (value == null || value.isEmpty) return null;

// //                                 final discountValue = double.tryParse(value);
// //                                 if (discountValue == null) {
// //                                   return 'Invalid number';
// //                                 }

// //                                 if (selectedDiscountType.id == 'percentage') {
// //                                   if (discountValue > 100) {
// //                                     return 'Cannot exceed 100%';
// //                                   }
// //                                   if (discountValue < 0) {
// //                                     return 'Cannot be negative';
// //                                   }
// //                                 } else if (selectedDiscountType.id ==
// //                                     'amount') {
// //                                   if (discountValue > subtotal) {
// //                                     return 'Cannot exceed total amount';
// //                                   }
// //                                   if (discountValue < 0) {
// //                                     return 'Cannot be negative';
// //                                   }
// //                                 }
// //                                 return null;
// //                               },
// //                               onChanged: (value) {
// //                                 if (value.isNotEmpty) {
// //                                   final discountValue = double.tryParse(value);
// //                                   if (discountValue != null) {
// //                                     if (selectedDiscountType.id ==
// //                                             'percentage' &&
// //                                         discountValue > 100) {
// //                                       discountController.text = '100';
// //                                       discountController.selection =
// //                                           TextSelection.collapsed(offset: 3);
// //                                     } else if (selectedDiscountType.id ==
// //                                             'amount' &&
// //                                         discountValue > subtotal) {
// //                                       discountController.text = subtotal
// //                                           .toStringAsFixed(2);
// //                                       discountController.selection =
// //                                           TextSelection.collapsed(
// //                                             offset: subtotal
// //                                                 .toStringAsFixed(2)
// //                                                 .length,
// //                                           );
// //                                     }
// //                                   }
// //                                 }
// //                               },
// //                               onEditingComplete: () =>
// //                                   _applyDiscount(p, subtotal),
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(width: 6),
// //                         SizedBox(
// //                           height: 32,
// //                           child: ElevatedButton(
// //                             onPressed: () => _applyDiscount(p, subtotal),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: AppTheme.greenColor,
// //                               padding: EdgeInsets.symmetric(horizontal: 8),
// //                               minimumSize: Size(50, 32),
// //                             ),
// //                             child: Text(
// //                               'Apply',
// //                               style: TextStyle(
// //                                 fontSize: 12,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: 8),
// //                 // Deposit - Ultra compact
// //                 _buildUltraCompactCard(
// //                   icon: Icons.account_balance_wallet_outlined,
// //                   title: 'Deposit',
// //                   checkBoxIcon: Transform.scale(
// //                     scale: 0.9,
// //                     child: Checkbox(
// //                       activeColor: AppTheme.greenColor,
// //                       value: requireDeposit,
// //                       onChanged: (value) {
// //                         if (mounted) {
// //                           setState(() {
// //                             requireDeposit = value ?? false;
// //                             if (!requireDeposit) {
// //                               depositAlreadyPaid = false;
// //                               depositAmount = 0;
// //                               depositPercentage = 0;
// //                               depositAmountController.clear();
// //                             }
// //                             _updateAllCalculations(p);
// //                           });
// //                         }
// //                       },
// //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //                     ),
// //                   ),
// //                   trailing: requireDeposit && depositAmount > 0
// //                       ? Container(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: 6,
// //                             vertical: 2,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.red,
// //                             borderRadius: BorderRadius.circular(4),
// //                           ),
// //                           child: Text(
// //                             'OMR ${depositAmount.toStringAsFixed(2)}',
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.w600,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                         )
// //                       : null,
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text('Require Deposit', style: TextStyle(fontSize: 14)),
// //                       ],
// //                     ),
// //                     if (requireDeposit) ...[
// //                       SizedBox(height: 6),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: SizedBox(
// //                               height: 40,
// //                               child: CustomSearchableDropdown(
// //                                 key: ValueKey(
// //                                   'deposit_type_${selectedDepositType.id}',
// //                                 ),
// //                                 hintText: 'Type',
// //                                 value: selectedDepositType.id,
// //                                 items: {
// //                                   for (var type in DepositType.types)
// //                                     type.id: type.name,
// //                                 },
// //                                 onChanged: (value) {
// //                                   if (value.isNotEmpty) {
// //                                     if (mounted) {
// //                                       setState(() {
// //                                         selectedDepositType = DepositType.types
// //                                             .firstWhere(
// //                                               (type) => type.id == value,
// //                                               orElse: () =>
// //                                                   DepositType.types[0],
// //                                             );
// //                                         if (selectedDepositType.id ==
// //                                             'percentage') {
// //                                           depositAmountController.text =
// //                                               depositPercentage.toString();
// //                                         } else {
// //                                           depositAmountController.text =
// //                                               depositAmount.toStringAsFixed(2);
// //                                         }
// //                                       });
// //                                     }
// //                                   }
// //                                   _updateAllCalculations(p);
// //                                 },
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 6),
// //                           Expanded(
// //                             flex: 2,
// //                             child: SizedBox(
// //                               height: 45,
// //                               child: CustomMmTextField(
// //                                 controller: depositAmountController,
// //                                 hintText: selectedDepositType.id == 'percentage'
// //                                     ? '%'
// //                                     : 'Amount',
// //                                 keyboardType: TextInputType.numberWithOptions(
// //                                   decimal: true,
// //                                 ),
// //                                 onChanged: (value) {
// //                                   final val = double.tryParse(value) ?? 0;
// //                                   if (selectedDepositType.id == 'percentage') {
// //                                     depositPercentage = val;
// //                                   } else {
// //                                     depositAmount = val;
// //                                   }
// //                                   _updateAllCalculations(p);
// //                                 },
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       // SizedBox(height: 4),
// //                       // _buildRow('Amount', depositAmount),
// //                       SizedBox(height: 4),
// //                       // Row(
// //                       //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       //   children: [
// //                       //     Text('Already Paid?', style: TextStyle(fontSize: 14)),
// //                       //     const SizedBox(width: 5),
// //                       //     Transform.scale(
// //                       //       scale: 0.9,
// //                       //       child: Checkbox(
// //                       //         // checkColor: AppTheme.greenColor,
// //                       //         activeColor: AppTheme.greenColor,
// //                       //         value: depositAlreadyPaid,
// //                       //         onChanged: (value) {
// //                       //           if (mounted) {
// //                       //             setState(() {
// //                       //               depositAlreadyPaid = value ?? false;
// //                       //               _updateAllCalculations(p);
// //                       //             });
// //                       //           }
// //                       //         },
// //                       //         materialTapTargetSize:
// //                       //             MaterialTapTargetSize.shrinkWrap,
// //                       //       ),
// //                       //     ),
// //                       //   ],
// //                       // ),
// //                       // Payment Configuration
// //                       Row(
// //                         children: [
// //                           Text('Already Paid?', style: TextStyle(fontSize: 14)),
// //                           const SizedBox(width: 5),
// //                           // Transform.scale(
// //                           //   scale: 0.9,
// //                           //   child: Checkbox(
// //                           //     activeColor: AppTheme.greenColor,
// //                           //     value: isAlreadyPaid,
// //                           //     onChanged: (value) {
// //                           //       final newValue = value ?? false;

// //                           //       WidgetsBinding.instance.addPostFrameCallback((
// //                           //         _,
// //                           //       ) {
// //                           //         if (mounted) {
// //                           //           setState(() {
// //                           //             isAlreadyPaid = newValue;

// //                           //             if (!isAlreadyPaid) {
// //                           //               // Reset to default single payment
// //                           //               paymentRows = [PaymentRow()];
// //                           //               paymentRows.first.method = PaymentMethod
// //                           //                   .methods
// //                           //                   .firstWhere((m) => m.id == 'cash');
// //                           //               paymentRows.first.amount = total;
// //                           //               isMultiple =
// //                           //                   false; // Reset multiple when turning off payment
// //                           //             } else {
// //                           //               // Clear deposit when payment is marked as paid
// //                           //               depositAmount = 0;
// //                           //               depositAlreadyPaid = false;
// //                           //               requireDeposit = false;
// //                           //               depositAmountController.clear();
// //                           //               depositPercentage = 0;
// //                           //             }

// //                           //             _calculateRemainingAmount(total);
// //                           //           });
// //                           //         }
// //                           //       });
// //                           //     },
// //                           //     materialTapTargetSize:
// //                           //         MaterialTapTargetSize.shrinkWrap,
// //                           //   ),
// //                           // ),
// //                           Transform.scale(
// //                             scale: 0.9,
// //                             child: Checkbox(
// //                               activeColor: AppTheme.greenColor,
// //                               value: isAlreadyPaid,
// //                               onChanged: (value) {
// //                                 final newValue = value ?? false;

// //                                 WidgetsBinding.instance.addPostFrameCallback((
// //                                   _,
// //                                 ) {
// //                                   if (mounted) {
// //                                     setState(() {
// //                                       isAlreadyPaid = newValue;

// //                                       if (!isAlreadyPaid) {
// //                                         // Reset payment rows when turning off payment
// //                                         paymentRows = [PaymentRow()];
// //                                         paymentRows.first.method = PaymentMethod
// //                                             .methods
// //                                             .firstWhere((m) => m.id == 'cash');
// //                                         paymentRows.first.amount = 0;
// //                                         isMultiple = false;
// //                                       } else {
// //                                         // Initialize payment rows when turning on payment
// //                                         _initializePaymentRows(total);

// //                                         // Clear deposit when payment is marked as paid
// //                                         depositAmount = 0;
// //                                         depositAlreadyPaid = false;
// //                                         requireDeposit = false;
// //                                         depositAmountController.clear();
// //                                         depositPercentage = 0;
// //                                       }

// //                                       _calculateRemainingAmount(total);
// //                                     });
// //                                   }
// //                                 });
// //                               },
// //                               materialTapTargetSize:
// //                                   MaterialTapTargetSize.shrinkWrap,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 10),
// //                           Text(
// //                             'Multiple Methods?',
// //                             style: TextStyle(fontSize: 14),
// //                           ),
// //                           const SizedBox(width: 5),
// //                           // Transform.scale(
// //                           //   scale: 0.9,
// //                           //   child: Checkbox(
// //                           //     activeColor: AppTheme.greenColor,
// //                           //     value: isMultiple,
// //                           //     onChanged: (value) {
// //                           //       if (!isAlreadyPaid) {
// //                           //         // Force false if not already paid
// //                           //         ScaffoldMessenger.of(context).showSnackBar(
// //                           //           SnackBar(
// //                           //             content: Text(
// //                           //               'Please enable "Already Paid?" first',
// //                           //             ),
// //                           //             backgroundColor: Colors.orange,
// //                           //           ),
// //                           //         );
// //                           //         return;
// //                           //       }

// //                           //       final newValue = value ?? false;

// //                           //       WidgetsBinding.instance.addPostFrameCallback((
// //                           //         _,
// //                           //       ) {
// //                           //         if (mounted) {
// //                           //           setState(() {
// //                           //             isMultiple = newValue;

// //                           //             if (isMultiple &&
// //                           //                 paymentRows.length == 1) {
// //                           //               // When enabling multiple, keep the existing row and allow adding more
// //                           //               // Don't automatically add rows - let user add them manually
// //                           //               // This preserves the existing payment data
// //                           //             } else if (!isMultiple &&
// //                           //                 paymentRows.length > 1) {
// //                           //               // When disabling multiple, consolidate to single payment
// //                           //               final totalPaid =
// //                           //                   _getCurrentTotalPaid();
// //                           //               paymentRows = [PaymentRow()];
// //                           //               paymentRows.first.amount = totalPaid;
// //                           //               // Keep the method from the first row if it exists
// //                           //               if (paymentRows.isNotEmpty) {
// //                           //                 paymentRows.first.method =
// //                           //                     paymentRows.first.method;
// //                           //               }
// //                           //             }

// //                           //             _calculateRemainingAmount(total);
// //                           //           });
// //                           //         }
// //                           //       });
// //                           //     },
// //                           //     materialTapTargetSize:
// //                           //         MaterialTapTargetSize.shrinkWrap,
// //                           //   ),
// //                           // ),
// //                           // Transform.scale(
// //                           //   scale: 0.9,
// //                           //   child: Checkbox(
// //                           //     activeColor: AppTheme.greenColor,
// //                           //     value: isMultiple,
// //                           //     onChanged: (value) {
// //                           //       if (!isAlreadyPaid) {
// //                           //         ScaffoldMessenger.of(context).showSnackBar(
// //                           //           SnackBar(
// //                           //             content: Text(
// //                           //               'Please enable "Already Paid?" first',
// //                           //             ),
// //                           //             backgroundColor: Colors.orange,
// //                           //           ),
// //                           //         );
// //                           //         return;
// //                           //       }

// //                           //       final newValue = value ?? false;

// //                           //       WidgetsBinding.instance.addPostFrameCallback((
// //                           //         _,
// //                           //       ) {
// //                           //         if (mounted) {
// //                           //           setState(() {
// //                           //             isMultiple = newValue;

// //                           //             if (isMultiple &&
// //                           //                 paymentRows.length == 1) {
// //                           //               // When enabling multiple, add one more row and distribute amounts
// //                           //               paymentRows.add(PaymentRow());
// //                           //               _distributeAmountsEqually(total);
// //                           //             } else if (!isMultiple &&
// //                           //                 paymentRows.length > 1) {
// //                           //               // When disabling multiple, consolidate to single payment
// //                           //               final totalPaid =
// //                           //                   _getCurrentTotalPaid();
// //                           //               paymentRows = [PaymentRow()];
// //                           //               paymentRows.first.amount = totalPaid;
// //                           //               if (paymentRows.isNotEmpty) {
// //                           //                 paymentRows.first.method =
// //                           //                     paymentRows.first.method;
// //                           //               }
// //                           //             }

// //                           //             _calculateRemainingAmount(total);
// //                           //           });
// //                           //         }
// //                           //       });
// //                           //     },
// //                           //     materialTapTargetSize:
// //                           //         MaterialTapTargetSize.shrinkWrap,
// //                           //   ),
// //                           // ),
// //                           Transform.scale(
// //                             scale: 0.9,
// //                             child: Checkbox(
// //                               activeColor: AppTheme.greenColor,
// //                               value: isMultiple,
// //                               onChanged: (value) {
// //                                 if (!isAlreadyPaid) return;

// //                                 final newValue = value ?? false;

// //                                 setState(() {
// //                                   isMultiple = newValue;

// //                                   if (isMultiple && paymentRows.length == 1) {
// //                                     paymentRows.add(PaymentRow());
// //                                     _distributeAmountsEqually(total);
// //                                   } else if (!isMultiple &&
// //                                       paymentRows.length > 1) {
// //                                     paymentRows = [paymentRows.first];
// //                                     paymentRows.first.amount = total;
// //                                   }

// //                                   _calculateRemainingAmount(total);
// //                                 });
// //                               },
// //                               materialTapTargetSize:
// //                                   MaterialTapTargetSize.shrinkWrap,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       if (!depositAlreadyPaid)
// //                         Container(
// //                           margin: EdgeInsets.only(top: 2),
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: 6,
// //                             vertical: 2,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.orange.withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(4),
// //                           ),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 'Next Payment:',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   color: Colors.orange.shade700,
// //                                 ),
// //                               ),
// //                               Text(
// //                                 'OMR ${depositAmount.toStringAsFixed(2)}',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Colors.orange.shade700,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                     ],
// //                   ],
// //                 ),
// //                 SizedBox(height: 12),
// //                 // Payment Details - Ultra compact
// //                 // _buildUltraCompactCard(
// //                 //   icon: Icons.payment,
// //                 //   title: 'Payment',
// //                 //   children: [
// //                 //     if (depositAlreadyPaid && requireDeposit)
// //                 //       _buildRow(
// //                 //         'Balance Due',
// //                 //         nextPaymentAmount,
// //                 //         color: Colors.red,
// //                 //         bold: true,
// //                 //       ),
// //                 //     Row(
// //                 //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 //       children: [
// //                 //         Text('Already Paid?', style: TextStyle(fontSize: 14)),
// //                 //         const SizedBox(width: 5),
// //                 //         Transform.scale(
// //                 //           scale: 0.9,
// //                 //           child: Checkbox(
// //                 //             //checkColor: AppTheme.greenColor,
// //                 //             activeColor: AppTheme.greenColor,
// //                 //             value: isAlreadyPaid,
// //                 //             onChanged: (value) {
// //                 //               setState(() {
// //                 //                 isAlreadyPaid = value ?? false;
// //                 //                 if (!isAlreadyPaid) {
// //                 //                   paymentRows = [PaymentRow()];
// //                 //                 }
// //                 //                 if (isAlreadyPaid) {
// //                 //                   depositAmount = 0;
// //                 //                   depositAlreadyPaid = false;
// //                 //                   requireDeposit = false;
// //                 //                   depositAmountController.clear();
// //                 //                   depositPercentage = 0;
// //                 //                   remainingAmount = 0;
// //                 //                 }
// //                 //                 _calculateRemainingAmount(total);
// //                 //               });
// //                 //             },
// //                 //             materialTapTargetSize:
// //                 //                 MaterialTapTargetSize.shrinkWrap,
// //                 //           ),
// //                 //         ),
// //                 //         const SizedBox(width: 10),
// //                 //         Text('Multiple?', style: TextStyle(fontSize: 14)),
// //                 //         const SizedBox(width: 5),
// //                 //         Transform.scale(
// //                 //           scale: 0.9,
// //                 //           child: Checkbox(
// //                 //             //checkColor: AppTheme.greenColor,
// //                 //             activeColor: AppTheme.greenColor,
// //                 //             value: isMultiple,
// //                 //             onChanged: (value) {
// //                 //               // setState(() {
// //                 //               //   isMultiple = value ?? false;
// //                 //               // });
// //                 //               setState(() {
// //                 //                 if (isAlreadyPaid) {
// //                 //                   // allow true/false normally
// //                 //                   isMultiple = value ?? false;
// //                 //                 } else {
// //                 //                   // force false if not already paid
// //                 //                   isMultiple = false;
// //                 //                 }
// //                 //               });
// //                 //             },
// //                 //             materialTapTargetSize:
// //                 //                 MaterialTapTargetSize.shrinkWrap,
// //                 //           ),
// //                 //         ),
// //                 //       ],
// //                 //     ),
// //                 //     // if (isAlreadyPaid) ...[
// //                 //     //   SizedBox(height: 6),
// //                 //     //   Text('Methods:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
// //                 //     //   SizedBox(height: 4),
// //                 //     //   ListView.builder(
// //                 //     //     shrinkWrap: true,
// //                 //     //     physics: NeverScrollableScrollPhysics(),
// //                 //     //     itemCount: paymentRows.length,
// //                 //     //     itemBuilder: (context, index) => _buildUltraCompactPaymentRow(index, total),
// //                 //     //   ),
// //                 //     //   if (paymentRows.length > 1 ||
// //                 //     //       (paymentRows.isNotEmpty && paymentRows.first.method?.id == 'multiple')) ...[
// //                 //     //     SizedBox(height: 4),
// //                 //     //     SizedBox(
// //                 //     //       height: 28,
// //                 //     //       child: TextButton.icon(
// //                 //     //         onPressed: () {
// //                 //     //           setState(() {
// //                 //     //             paymentRows.add(PaymentRow());
// //                 //     //             _calculateRemainingAmount(total);
// //                 //     //           });
// //                 //     //         },
// //                 //     //         icon: Icon(Icons.add, size: 12),
// //                 //     //         label: Text('Add Payment', style: TextStyle(fontSize: 10)),
// //                 //     //         style: TextButton.styleFrom(
// //                 //     //           padding: EdgeInsets.symmetric(horizontal: 8),
// //                 //     //         ),
// //                 //     //       ),
// //                 //     //     ),
// //                 //     //   ],
// //                 //     //   _buildRow(
// //                 //     //     'Remaining',
// //                 //     //     remainingAmount,
// //                 //     //     color: remainingAmount > 0 ? Colors.red : Colors.green,
// //                 //     //     bold: true,
// //                 //     //   ),
// //                 //     // ],
// //                 //     // Payment rows
// //                 //     // if (isAlreadyPaid)
// //                 //     //   ListView.builder(
// //                 //     //     shrinkWrap: true,
// //                 //     //     physics: const NeverScrollableScrollPhysics(),
// //                 //     //     itemCount: paymentRows.length,
// //                 //     //     itemBuilder: (context, index) {
// //                 //     //       return _buildPaymentRow(index, total);
// //                 //     //     },
// //                 //     //   ),
// //                 //     // if (paymentRows.length > 1 ||
// //                 //     //     (paymentRows.isNotEmpty &&
// //                 //     //         paymentRows.first.method?.id == 'multiple')) ...[
// //                 //     //   const SizedBox(height: 12),
// //                 //     //   Row(
// //                 //     //     mainAxisAlignment: MainAxisAlignment.end,
// //                 //     //     children: [
// //                 //     //       ElevatedButton.icon(
// //                 //     //         onPressed: () {
// //                 //     //           setState(() {
// //                 //     //             paymentRows.add(PaymentRow());
// //                 //     //             _calculateRemainingAmount(total);
// //                 //     //           });
// //                 //     //         },
// //                 //     //         icon: const Icon(Icons.add, size: 16),
// //                 //     //         label: const Text('Add'),
// //                 //     //         style: ElevatedButton.styleFrom(
// //                 //     //           backgroundColor: AppTheme.greenColor,
// //                 //     //           foregroundColor: Colors.white,
// //                 //     //         ),
// //                 //     //       ),
// //                 //     //     ],
// //                 //     //   ),
// //                 //     // ],
// //                 //     // In your build method
// //                 //     if (isAlreadyPaid)
// //                 //       ListView.builder(
// //                 //         shrinkWrap: true,
// //                 //         physics: const NeverScrollableScrollPhysics(),
// //                 //         itemCount: paymentRows.length,
// //                 //         itemBuilder: (context, index) {
// //                 //           return _buildPaymentRow(index, total);
// //                 //         },
// //                 //       ),

// //                 //     // if (paymentRows.length > 1 ||
// //                 //     //     (paymentRows.isNotEmpty &&
// //                 //     //         paymentRows.first.method?.id == 'multiple')) ...[
// //                 //     const SizedBox(height: 12),
// //                 //     if (isMultiple)
// //                 //       Row(
// //                 //         mainAxisAlignment: MainAxisAlignment.end,
// //                 //         children: [
// //                 //           ElevatedButton.icon(
// //                 //             onPressed: () {
// //                 //               setState(() {
// //                 //                 paymentRows.add(PaymentRow());
// //                 //                 _calculateRemainingAmount(total);
// //                 //               });
// //                 //             },
// //                 //             icon: const Icon(Icons.add, size: 16),
// //                 //             label: const Text('Add'),
// //                 //             style: ElevatedButton.styleFrom(
// //                 //               backgroundColor: AppTheme.greenColor,
// //                 //               foregroundColor: Colors.white,
// //                 //             ),
// //                 //           ),
// //                 //         ],
// //                 //       ),
// //                 //     //],

// //                 //     // Add this widget to show remaining balance
// //                 //     const SizedBox(height: 12),
// //                 //     Text(
// //                 //       'Remaining Balance: ${_getRemainingAmount(total).toStringAsFixed(2)} OMR',
// //                 //       style: TextStyle(
// //                 //         fontSize: 16,
// //                 //         fontWeight: FontWeight.bold,
// //                 //         color: _getRemainingAmount(total) > 0
// //                 //             ? Colors.red
// //                 //             : Colors.green,
// //                 //       ),
// //                 //     ),
// //                 //   ],
// //                 // ),
// //                 // Payment Details - Ultra compact
// //                 _buildUltraCompactCard(
// //                   icon: Icons.payment,
// //                   title: 'Payment',
// //                   children: [
// //                     if (depositAlreadyPaid && requireDeposit)
// //                       _buildRow(
// //                         'Balance Due',
// //                         nextPaymentAmount,
// //                         color: Colors.red,
// //                         bold: true,
// //                       ),

// //                     // Payment Configuration
// //                     Row(
// //                       children: [
// //                         Text('Already Paid?', style: TextStyle(fontSize: 14)),
// //                         const SizedBox(width: 5),
// //                         Transform.scale(
// //                           scale: 0.9,
// //                           child: Checkbox(
// //                             activeColor: AppTheme.greenColor,
// //                             value: isAlreadyPaid,
// //                             onChanged: (value) {
// //                               final newValue = value ?? false;

// //                               WidgetsBinding.instance.addPostFrameCallback((_) {
// //                                 if (mounted) {
// //                                   setState(() {
// //                                     isAlreadyPaid = newValue;

// //                                     if (!isAlreadyPaid) {
// //                                       // Reset to default single payment
// //                                       paymentRows = [PaymentRow()];
// //                                       paymentRows.first.method = PaymentMethod
// //                                           .methods
// //                                           .firstWhere((m) => m.id == 'cash');
// //                                       paymentRows.first.amount = total;
// //                                     } else {
// //                                       // Clear deposit when payment is marked as paid
// //                                       depositAmount = 0;
// //                                       depositAlreadyPaid = false;
// //                                       requireDeposit = false;
// //                                       depositAmountController.clear();
// //                                       depositPercentage = 0;
// //                                     }

// //                                     _calculateRemainingAmount(total);
// //                                   });
// //                                 }
// //                               });
// //                             },
// //                             materialTapTargetSize:
// //                                 MaterialTapTargetSize.shrinkWrap,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 10),
// //                         Text(
// //                           'Multiple Methods?',
// //                           style: TextStyle(fontSize: 14),
// //                         ),
// //                         const SizedBox(width: 5),
// //                         Transform.scale(
// //                           scale: 0.9,
// //                           child: Checkbox(
// //                             activeColor: AppTheme.greenColor,
// //                             value: isMultiple,
// //                             onChanged: (value) {
// //                               if (!isAlreadyPaid) {
// //                                 // Force false if not already paid
// //                                 return;
// //                               }

// //                               final newValue = value ?? false;

// //                               WidgetsBinding.instance.addPostFrameCallback((_) {
// //                                 if (mounted) {
// //                                   setState(() {
// //                                     isMultiple = newValue;

// //                                     // if (isMultiple && paymentRows.length == 1) {
// //                                     //   // Convert to multiple payments
// //                                     //   final currentAmount =
// //                                     //       paymentRows.first.amount;
// //                                     //   paymentRows.add(PaymentRow());
// //                                     //   // Split existing amount
// //                                     //   paymentRows.first.amount =
// //                                     //       currentAmount / 2;
// //                                     //   paymentRows.last.amount =
// //                                     //       currentAmount / 2;
// //                                     // } else if (!isMultiple &&
// //                                     //     paymentRows.length > 1) {
// //                                     //   // Convert to single payment
// //                                     //   final totalPaid = _getCurrentTotalPaid();
// //                                     //   paymentRows = [PaymentRow()];
// //                                     //   paymentRows.first.amount = totalPaid;
// //                                     // }

// //                                     _calculateRemainingAmount(total);
// //                                   });
// //                                 }
// //                               });
// //                             },
// //                             materialTapTargetSize:
// //                                 MaterialTapTargetSize.shrinkWrap,
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     // Payment rows
// //                     if (isAlreadyPaid) ...[
// //                       const SizedBox(height: 8),
// //                       ...paymentRows.asMap().entries.map((entry) {
// //                         return _buildPaymentRow(entry.key, total);
// //                       }).toList(),
// //                     ],

// //                     // Add payment method button
// //                     // if (isMultiple && isAlreadyPaid) ...[
// //                     //   const SizedBox(height: 8),
// //                     //   Align(
// //                     //     alignment: Alignment.centerRight,
// //                     //     child: ElevatedButton.icon(
// //                     //       onPressed: () {
// //                     //         // Check if adding another row would exceed reasonable limits
// //                     //         if (paymentRows.length >= 10) {
// //                     //           ScaffoldMessenger.of(context).showSnackBar(
// //                     //             SnackBar(
// //                     //               content: Text(
// //                     //                 'Maximum 10 payment methods allowed',
// //                     //               ),
// //                     //               backgroundColor: Colors.orange,
// //                     //             ),
// //                     //           );
// //                     //           return;
// //                     //         }

// //                     //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //                     //           if (mounted) {
// //                     //             setState(() {
// //                     //               paymentRows.add(PaymentRow());
// //                     //               _calculateRemainingAmount(total);
// //                     //             });
// //                     //           }
// //                     //         });
// //                     //       },
// //                     //       icon: const Icon(Icons.add, size: 16),
// //                     //       label: const Text('Add Payment Method'),
// //                     //       style: ElevatedButton.styleFrom(
// //                     //         backgroundColor: AppTheme.greenColor,
// //                     //         foregroundColor: Colors.white,
// //                     //       ),
// //                     //     ),
// //                     //   ),
// //                     // ],
// //                     if (isMultiple && isAlreadyPaid) ...[
// //                       const SizedBox(height: 8),
// //                       Align(
// //                         alignment: Alignment.centerRight,
// //                         child: ElevatedButton.icon(
// //                           onPressed: () {
// //                             if (paymentRows.length >= 10) return;

// //                             // Add row and distribute
// //                             paymentRows.add(PaymentRow());
// //                             // _distributeAmountsEqually(total);

// //                             // Force ONE single update
// //                             if (mounted) setState(() {});
// //                           },
// //                           icon: const Icon(Icons.add, size: 16),
// //                           label: const Text('Add Payment Method'),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: AppTheme.greenColor,
// //                             foregroundColor: Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                     ],

// //                     // Payment summary
// //                     // const SizedBox(height: 12),
// //                     // Container(
// //                     //   padding: EdgeInsets.all(8),
// //                     //   decoration: BoxDecoration(
// //                     //     color: remainingAmount > 0
// //                     //         ? Colors.orange.withOpacity(0.1)
// //                     //         : Colors.green.withOpacity(0.1),
// //                     //     borderRadius: BorderRadius.circular(4),
// //                     //   ),
// //                     //   child: Column(
// //                     //     children: [
// //                     //       Row(
// //                     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     //         children: [
// //                     //           Text(
// //                     //             'Total Paid:',
// //                     //             style: TextStyle(
// //                     //               fontSize: 14,
// //                     //               fontWeight: FontWeight.w600,
// //                     //               color: Colors.grey[700],
// //                     //             ),
// //                     //           ),
// //                     //           Text(
// //                     //             '${_getCurrentTotalPaid().toStringAsFixed(2)} OMR',
// //                     //             style: TextStyle(
// //                     //               fontSize: 14,
// //                     //               fontWeight: FontWeight.w600,
// //                     //               color: Colors.grey[700],
// //                     //             ),
// //                     //           ),
// //                     //         ],
// //                     //       ),
// //                     //       const SizedBox(height: 4),
// //                     //       Row(
// //                     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     //         children: [
// //                     //           Text(
// //                     //             'Remaining Balance:',
// //                     //             style: TextStyle(
// //                     //               fontSize: 14,
// //                     //               fontWeight: FontWeight.bold,
// //                     //               color: remainingAmount > 0
// //                     //                   ? Colors.orange
// //                     //                   : Colors.green,
// //                     //             ),
// //                     //           ),
// //                     //           Text(
// //                     //             '${remainingAmount.toStringAsFixed(2)} OMR',
// //                     //             style: TextStyle(
// //                     //               fontSize: 16,
// //                     //               fontWeight: FontWeight.bold,
// //                     //               color: remainingAmount > 0
// //                     //                   ? Colors.orange
// //                     //                   : Colors.green,
// //                     //             ),
// //                     //           ),
// //                     //         ],
// //                     //       ),
// //                     //     ],
// //                     //   ),
// //                     // ),
// //                     // Payment summary - This will update automatically when remainingAmount changes
// //                     const SizedBox(height: 12),
// //                     Container(
// //                       padding: EdgeInsets.all(8),
// //                       decoration: BoxDecoration(
// //                         color: remainingAmount > 0
// //                             ? Colors.orange.withOpacity(0.1)
// //                             : Colors.green.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                       child: Column(
// //                         children: [
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 'Total Paid:',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Colors.grey[700],
// //                                 ),
// //                               ),
// //                               Text(
// //                                 '${_getCurrentTotalPaid().toStringAsFixed(2)} OMR',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Colors.grey[700],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 'Remaining Balance:',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: remainingAmount > 0
// //                                       ? Colors.orange
// //                                       : Colors.green,
// //                                 ),
// //                               ),
// //                               Text(
// //                                 '${remainingAmount.toStringAsFixed(2)} OMR',
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: remainingAmount > 0
// //                                       ? Colors.orange
// //                                       : Colors.green,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),

// //                     // Validation message
// //                     if (!_validatePaymentAmounts(total) && isAlreadyPaid)
// //                       Container(
// //                         margin: EdgeInsets.only(top: 8),
// //                         padding: EdgeInsets.all(8),
// //                         decoration: BoxDecoration(
// //                           color: Colors.red.withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(4),
// //                         ),
// //                         child: Row(
// //                           children: [
// //                             Icon(Icons.warning, size: 16, color: Colors.red),
// //                             SizedBox(width: 8),
// //                             Expanded(
// //                               child: Text(
// //                                 'Total payment amount exceeds invoice total by ${(_getCurrentTotalPaid() - total).toStringAsFixed(2)} OMR',
// //                                 style: TextStyle(
// //                                   fontSize: 12,
// //                                   color: Colors.red,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                   ],
// //                 ),

// //                 SizedBox(height: 12),
// //                 // Attachment
// //                 _buildUltraCompactCard(
// //                   icon: Icons.attach_file_sharp,
// //                   title: 'Attachment',
// //                   children: [
// //                     DialogueBoxPicker(
// //                       showOldRow: false,
// //                       uploadDocument: true,
// //                       onFilesPicked: (List<AttachmentModel> files) {
// //                         setState(() {
// //                           displayPicture = files;
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                 ),

// //                 // Action Button - Compact
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 40,
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       if (!_validatePaymentAmounts(total)) {
// //                         return;
// //                       }
// //                       setState(() {
// //                         p.orderLoading = true;
// //                       });
// //                       double d = double.tryParse(discountController.text) ?? 0;
// //                       List<Map<String, dynamic>> productsData = [];
// //                       try {
// //                         // This will throw exceptions if validation fails
// //                         productsData = Constants.buildProductsData(productRows);
// //                         if (productsData.isEmpty) {
// //                           Constants.showValidationError(
// //                             context,
// //                             "Items cannot be empty",
// //                           );
// //                           setState(() {
// //                             p.orderLoading = false;
// //                           });
// //                           return;
// //                         }
// //                         // If we get here, validation passed - proceed with API call
// //                         // _sendToBackend(productsData);
// //                       } catch (e) {
// //                         setState(() {
// //                           p.orderLoading = false;
// //                         });
// //                         Constants.showValidationError(context, e);
// //                         return
// //                         // Log technical error for debugging
// //                         debugPrint('Invoice submission error: $e');
// //                       }
// //                       // final productsData = Constants.buildProductsData(
// //                       //   productRows,
// //                       // ); // final productsData = productRows.map((row) {
// //                       //   return {
// //                       //     'type': row.saleItem!.type,
// //                       //     'productId': row.saleItem!.productId,
// //                       //     'productName': row.saleItem?.productName,
// //                       //     'sellingPrice': row.sellingPrice,
// //                       //     // 'margin': row.margin,
// //                       //     'quantity': row.quantity,
// //                       //     'discount': row.discount,
// //                       //     'applyVat': row.applyVat,
// //                       //     'subtotal': row.subtotal,
// //                       //     'vatAmount': row.vatAmount,
// //                       //     'total': row.total,
// //                       //     'profit': row.profit,
// //                       //   };
// //                       // }).toList();
// //                       final depositData = {
// //                         'requireDeposit': requireDeposit,
// //                         'depositType': selectedDepositType.id,
// //                         'depositAmount': depositAmount,
// //                         'depositPercentage': depositPercentage,
// //                         //'depositAlreadyPaid': depositAlreadyPaid,
// //                         'nextPaymentAmount': nextPaymentAmount,
// //                       };

// //                       final paymentData = isAlreadyPaid
// //                           ? {
// //                               'isAlreadyPaid': true,
// //                               'paymentMethods': paymentRows
// //                                   .map(
// //                                     (row) => {
// //                                       'method': row.method?.id,
// //                                       'methodName': row.method?.name,
// //                                       'reference': row.reference,
// //                                       'amount': row.amount,
// //                                     },
// //                                   )
// //                                   .toList(),
// //                               'totalPaid': paymentRows.fold(
// //                                 0.0,
// //                                 (sum, row) => sum + (row.amount ?? 0.0),
// //                               ),
// //                               // paymentRows.length > 1
// //                               //     ? paymentRows
// //                               //         .fold(0.0, (sum, row) => sum + row.amount)
// //                               //         .toInt()
// //                               //     // ? paymentRows.fold(
// //                               //     //     0, (sum, row) => sum + row.amount as int)
// //                               //     : p.total,
// //                               'remainingAmount': remainingAmount,
// //                             }
// //                           : {
// //                               'isAlreadyPaid': false,
// //                               'paymentMethods': [],
// //                               'totalPaid': 0,
// //                               'remainingAmount': total,
// //                             };

// //                       p.saveBooking(
// //                         productsData: productsData,
// //                         depositData: depositData,
// //                         context: context,
// //                         onBack: widget.onBack!.call, //close,
// //                         isEdit: widget.purchase != null,
// //                         total: total,
// //                         discount: d,
// //                         taxAmount: taxAmount,
// //                         paymentData: paymentData,
// //                         sale: widget.purchase,
// //                         statusType: "pending",
// //                       );
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: AppTheme.primaryColor,
// //                       foregroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                     child: p.loading.value
// //                         ? SizedBox(
// //                             width: 16,
// //                             height: 16,
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                               valueColor: AlwaysStoppedAnimation<Color>(
// //                                 Colors.white,
// //                               ),
// //                             ),
// //                           )
// //                         : Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Icon(
// //                                 widget.purchase != null
// //                                     ? Icons.update_rounded
// //                                     : Icons.add_circle_outline_rounded,
// //                                 size: 16,
// //                               ),
// //                               SizedBox(width: 6),
// //                               Text(
// //                                 widget.purchase != null
// //                                     ? 'Update Invoice'
// //                                     : 'Create Invoice',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w600,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Ultra-compact card builder
// //   Widget _buildUltraCompactCard({
// //     required IconData icon,
// //     required String title,
// //     required List<Widget> children,
// //     Widget? checkBoxIcon,
// //     Widget? trailing,
// //   }) {
// //     return Container(
// //       padding: EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         color: Color(0xFFF8F9FA),
// //         borderRadius: BorderRadius.circular(6),
// //         border: Border.all(color: Color(0xFFE9ECEF), width: 0.5),
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, size: 14, color: Color(0xFF495057)),
// //               SizedBox(width: 4),
// //               Text(
// //                 title,
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF212529),
// //                 ),
// //               ),
// //               if (checkBoxIcon != null) ...[SizedBox(width: 4), checkBoxIcon],
// //               if (trailing != null) ...[Spacer(), trailing],
// //             ],
// //           ),
// //           SizedBox(height: 6),
// //           ...children,
// //         ],
// //       ),
// //     );
// //   }

// //   // Ultra-compact row builder
// //   Widget _buildRow(
// //     String label,
// //     double amount, {
// //     Color? color,
// //     bool bold = false,
// //   }) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 1),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             label,
// //             style: TextStyle(
// //               fontSize: 14,
// //               fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
// //               color: color ?? Color(0xFF495057),
// //             ),
// //           ),
// //           Text(
// //             '${amount.toStringAsFixed(2)} OMR',
// //             style: TextStyle(
// //               fontSize: 14,
// //               fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
// //               color: color ?? Color(0xFF212529),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Ultra-compact divider
// //   Widget _buildDivider() {
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 4),
// //       height: 0.5,
// //       color: Color(0xFFDEE2E6),
// //     );
// //   }

// //   // Widget _buildPaymentRow(int index, double grandTotal) {
// //   //   final paymentRow = paymentRows[index];
// //   //   bool hasMultiplePaymentMethod =
// //   //       paymentRows.any((row) => row.method?.name == 'Multiple');
// //   //   return Container(
// //   //     margin: const EdgeInsets.only(bottom: 12),
// //   //     padding: const EdgeInsets.all(12),
// //   //     decoration: BoxDecoration(
// //   //       color: Colors.white,
// //   //       borderRadius: BorderRadius.circular(8),
// //   //       border: Border.all(color: Colors.grey[300]!),
// //   //     ),
// //   //     child: Row(
// //   //       children: [
// //   //         // Payment Method Dropdown
// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: CustomSearchableDropdown(
// //   //             key: ValueKey('payment_method_$index'),
// //   //             hintText: 'Method',
// //   //             items: {for (var m in PaymentMethod.methods) m.id: m.name},
// //   //             value: paymentRow.method?.id,
// //   //             onChanged: (value) {
// //   //               if (value.isNotEmpty) {
// //   //                 setState(() {
// //   //                   paymentRow.method =
// //   //                       PaymentMethod.methods.firstWhere((m) => m.id == value);

// //   //                   // If selecting "multiple", add more rows
// //   //                   if (value == 'multiple' && paymentRows.length == 1) {
// //   //                     paymentRows.add(PaymentRow());
// //   //                   }

// //   //                   _calculateRemainingAmount(grandTotal);
// //   //                 });
// //   //               }
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Reference Number

// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: TextFormField(
// //   //             key: ValueKey('payment_ref_$index'),
// //   //             decoration: const InputDecoration(
// //   //               labelText: 'Reference',
// //   //               border: OutlineInputBorder(),
// //   //               contentPadding:
// //   //                   EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //   //             ),
// //   //             onChanged: (value) {
// //   //               paymentRow.reference = value;
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Amount

// //   //         if (hasMultiplePaymentMethod)
// //   //           Expanded(
// //   //             flex: 1,
// //   //             child: TextFormField(
// //   //               key: ValueKey('payment_amount_$index'),
// //   //               decoration: const InputDecoration(
// //   //                 labelText: 'Amount',
// //   //                 border: OutlineInputBorder(),
// //   //                 contentPadding:
// //   //                     EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //   //               ),
// //   //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //   //               onChanged: (value) {
// //   //                 paymentRow.amount = double.tryParse(value) ?? 0;
// //   //                 _calculateRemainingAmount(grandTotal);
// //   //               },
// //   //             ),
// //   //           ),
// //   //         const SizedBox(width: 8),

// //   //         // Remove button for multiple payments
// //   //         if (paymentRows.length > 1)
// //   //           IconButton(
// //   //             icon:
// //   //                 const Icon(Icons.remove_circle, color: Colors.red, size: 20),
// //   //             onPressed: () {
// //   //               setState(() {
// //   //                 paymentRows.removeAt(index);
// //   //                 _calculateRemainingAmount(grandTotal);
// //   //               });
// //   //             },
// //   //           ),
// //   //       ],
// //   //     ),
// //   //   );
// //   // }
// //   // Widget _buildPaymentRow(int index, double grandTotal) {
// //   //   final paymentRow = paymentRows[index];

// //   //   // Check if this specific row should show amount field
// //   //   // bool shouldShowAmountField = paymentRows.length > 1 ||
// //   //   //     paymentRows.any((row) => row.method?.id == 'multiple');

// //   //   return Container(
// //   //     margin: const EdgeInsets.only(bottom: 12),
// //   //     padding: const EdgeInsets.all(12),
// //   //     decoration: BoxDecoration(
// //   //       color: Colors.white,
// //   //       borderRadius: BorderRadius.circular(8),
// //   //       border: Border.all(color: Colors.grey[300]!),
// //   //     ),
// //   //     child: Row(
// //   //       children: [
// //   //         // Payment Method Dropdown
// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: CustomSearchableDropdown(
// //   //             key: ValueKey('payment_method_$index'),
// //   //             hintText: 'Method',
// //   //             items: {for (var m in PaymentMethod.methods) m.id: m.name},
// //   //             value: paymentRow.method?.id,
// //   //             onChanged: (value) {
// //   //               if (value.isNotEmpty) {
// //   //                 setState(() {
// //   //                   paymentRow.method = PaymentMethod.methods.firstWhere(
// //   //                     (m) => m.id == value,
// //   //                   );

// //   //                   // If selecting "multiple" in any row, ensure we have at least 2 rows
// //   //                   if (isMultiple //value == 'multiple'
// //   //                       &&
// //   //                       paymentRows.length == 1) {
// //   //                     paymentRows.add(PaymentRow());
// //   //                   }

// //   //                   // If changing from multiple to single method and we have multiple rows,
// //   //                   // set the amount to grand total for the first row
// //   //                   if (!isMultiple
// //   //                       //value != 'multiple'
// //   //                       &&
// //   //                       index == 0 &&
// //   //                       paymentRows.length > 1) {
// //   //                     paymentRow.amount = grandTotal;
// //   //                     // Remove extra rows if not needed
// //   //                     if (paymentRows.length > 1) {
// //   //                       paymentRows.removeRange(1, paymentRows.length);
// //   //                     }
// //   //                   }

// //   //                   _calculateRemainingAmount(grandTotal);
// //   //                 });
// //   //               }
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Reference Number
// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: TextFormField(
// //   //             key: ValueKey('payment_ref_$index'),
// //   //             decoration: const InputDecoration(
// //   //               labelText: 'Reference',
// //   //               border: OutlineInputBorder(),
// //   //               contentPadding: EdgeInsets.symmetric(
// //   //                 horizontal: 8,
// //   //                 vertical: 4,
// //   //               ),
// //   //             ),
// //   //             onChanged: (value) {
// //   //               paymentRow.reference = value;
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Amount field - only show when appropriate
// //   //         if (isMultiple)
// //   //           Expanded(
// //   //             flex: 1,
// //   //             child: TextFormField(
// //   //               key: ValueKey('payment_amount_$index'),
// //   //               decoration: const InputDecoration(
// //   //                 labelText: 'Amount',
// //   //                 border: OutlineInputBorder(),
// //   //                 contentPadding: EdgeInsets.symmetric(
// //   //                   horizontal: 8,
// //   //                   vertical: 4,
// //   //                 ),
// //   //               ),
// //   //               autovalidateMode: AutovalidateMode.onUserInteraction,
// //   //               validator: ValidationUtils.price,
// //   //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //   //               onChanged: (value) {
// //   //                 setState(() {
// //   //                   paymentRow.amount = double.tryParse(value) ?? 0;
// //   //                   _calculateRemainingAmount(grandTotal);
// //   //                 });
// //   //               },
// //   //             ),
// //   //           ),

// //   //         // if (shouldShowAmountField) const SizedBox(width: 8),

// //   //         // Remove button for multiple payments
// //   //         if (paymentRows.length > 1)
// //   //           IconButton(
// //   //             icon: const Icon(
// //   //               Icons.remove_circle,
// //   //               color: Colors.red,
// //   //               size: 20,
// //   //             ),
// //   //             onPressed: () {
// //   //               setState(() {
// //   //                 paymentRows.removeAt(index);
// //   //                 // If we're left with one row and it's not "multiple", set its amount to grand total
// //   //                 if (paymentRows.length == 1 &&
// //   //                     paymentRows.first.method?.id != 'multiple') {
// //   //                   paymentRows.first.amount = grandTotal;
// //   //                 }
// //   //                 _calculateRemainingAmount(grandTotal);
// //   //               });
// //   //             },
// //   //           ),
// //   //       ],
// //   //     ),
// //   //   );
// //   // }
// //   // Widget _buildPaymentRow(int index, double grandTotal) {
// //   //   final paymentRow = paymentRows[index];

// //   //   return Container(
// //   //     margin: const EdgeInsets.only(bottom: 12),
// //   //     padding: const EdgeInsets.all(12),
// //   //     decoration: BoxDecoration(
// //   //       color: Colors.white,
// //   //       borderRadius: BorderRadius.circular(8),
// //   //       border: Border.all(color: Colors.grey[300]!),
// //   //     ),
// //   //     child: Row(
// //   //       children: [
// //   //         // Payment Method Dropdown
// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: CustomSearchableDropdown(
// //   //             key: ValueKey('payment_method_$index'),
// //   //             hintText: 'Method',
// //   //             items: {for (var m in PaymentMethod.methods) m.id: m.name},
// //   //             value: paymentRow.method?.id,
// //   //             onChanged: (value) {
// //   //               if (value.isNotEmpty) {
// //   //                 setState(() {
// //   //                   paymentRow.method = PaymentMethod.methods.firstWhere(
// //   //                     (m) => m.id == value,
// //   //                   );

// //   //                   // If selecting "multiple" in any row, ensure we have at least 2 rows
// //   //                   if (isMultiple && paymentRows.length == 1) {
// //   //                     paymentRows.add(PaymentRow());
// //   //                   }

// //   //                   // If changing from multiple to single method and we have multiple rows,
// //   //                   // set the amount to grand total for the first row
// //   //                   if (!isMultiple && index == 0 && paymentRows.length > 1) {
// //   //                     paymentRow.amount = grandTotal;
// //   //                     // Remove extra rows if not needed
// //   //                     if (paymentRows.length > 1) {
// //   //                       paymentRows.removeRange(1, paymentRows.length);
// //   //                     }
// //   //                   }

// //   //                   _calculateRemainingAmount(grandTotal);
// //   //                 });
// //   //               }
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Reference Number
// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: TextFormField(
// //   //             key: ValueKey('payment_ref_$index'),
// //   //             controller: TextEditingController(text: paymentRow.reference),
// //   //             decoration: const InputDecoration(
// //   //               labelText: 'Reference',
// //   //               border: OutlineInputBorder(),
// //   //               contentPadding: EdgeInsets.symmetric(
// //   //                 horizontal: 8,
// //   //                 vertical: 4,
// //   //               ),
// //   //             ),
// //   //             onChanged: (value) {
// //   //               paymentRow.reference = value;
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Amount field - ALWAYS SHOW for all payment methods
// //   //         Expanded(
// //   //           flex: 1,
// //   //           child: TextFormField(
// //   //             key: ValueKey('payment_amount_$index'),
// //   //             controller: TextEditingController(
// //   //               text: paymentRow.amount > 0
// //   //                   ? paymentRow.amount.toStringAsFixed(2)
// //   //                   : '',
// //   //             ),
// //   //             decoration: const InputDecoration(
// //   //               labelText: 'Amount',
// //   //               border: OutlineInputBorder(),
// //   //               contentPadding: EdgeInsets.symmetric(
// //   //                 horizontal: 8,
// //   //                 vertical: 4,
// //   //               ),
// //   //             ),
// //   //             autovalidateMode: AutovalidateMode.onUserInteraction,
// //   //             validator: ValidationUtils.price,
// //   //             keyboardType: TextInputType.numberWithOptions(decimal: true),
// //   //             onChanged: (value) {
// //   //               setState(() {
// //   //                 paymentRow.amount = double.tryParse(value) ?? 0.0;
// //   //                 _calculateRemainingAmount(grandTotal);
// //   //               });
// //   //             },
// //   //           ),
// //   //         ),

// //   //         // Remove button for multiple payments
// //   //         if (paymentRows.length > 1)
// //   //           IconButton(
// //   //             icon: const Icon(
// //   //               Icons.remove_circle,
// //   //               color: Colors.red,
// //   //               size: 20,
// //   //             ),
// //   //             onPressed: () {
// //   //               setState(() {
// //   //                 paymentRows.removeAt(index);
// //   //                 // If we're left with one row and it's not "multiple", set its amount to grand total
// //   //                 if (paymentRows.length == 1) {
// //   //                   paymentRows.first.amount = grandTotal;
// //   //                 }
// //   //                 _calculateRemainingAmount(grandTotal);
// //   //               });
// //   //             },
// //   //           ),
// //   //       ],
// //   //     ),
// //   //   );
// //   // }

// //   // Calculate current total paid across all payment rows
// //   double _getCurrentTotalPaid() {
// //     double total = 0.0;
// //     for (var row in paymentRows) {
// //       total += row.amount;
// //     }
// //     return total;
// //   }

// //   // Validate payment amounts don't exceed grand total
// //   bool _validatePaymentAmounts(double grandTotal) {
// //     final totalPaid = _getCurrentTotalPaid();
// //     return totalPaid <= grandTotal;
// //   }

// //   void _updateCalculationsWithoutRebuild(double grandTotal) {
// //     // Update calculations without triggering full rebuild
// //     double paidAmount = _getCurrentTotalPaid();
// //     remainingAmount = grandTotal - paidAmount;

// //     if (remainingAmount < 0) {
// //       remainingAmount = 0;
// //     }

// //     // Only update the summary display, not the entire payment rows
// //     // This prevents the typing issues
// //   }

// //   // Widget _buildPaymentRow(int index, double grandTotal) {
// //   //   final paymentRow = paymentRows[index];

// //   //   return Container(
// //   //     margin: const EdgeInsets.only(bottom: 12),
// //   //     padding: const EdgeInsets.all(12),
// //   //     decoration: BoxDecoration(
// //   //       color: Colors.white,
// //   //       borderRadius: BorderRadius.circular(8),
// //   //       border: Border.all(color: Colors.grey[300]!),
// //   //     ),
// //   //     child: Row(
// //   //       children: [
// //   //         // Payment Method Dropdown
// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: CustomSearchableDropdown(
// //   //             key: ValueKey('payment_method_${index}_${paymentRows.length}'),
// //   //             hintText: 'Method',
// //   //             items: {for (var m in PaymentMethod.methods) m.id: m.name},
// //   //             value: paymentRow.method?.id,
// //   //             onChanged: (value) {
// //   //               if (value.isNotEmpty) {
// //   //                 final newMethod = PaymentMethod.methods.firstWhere(
// //   //                   (m) => m.id == value,
// //   //                 );

// //   //                 // Update the method without affecting other rows
// //   //                 paymentRow.method = newMethod;

// //   //                 // ONLY handle the special case of selecting "multiple" method
// //   //                 // This should only add rows when specifically selecting "multiple"
// //   //                 if (value == 'multiple' && paymentRows.length == 1) {
// //   //                   // Only add one additional row when switching to multiple from single
// //   //                   paymentRows.add(PaymentRow());
// //   //                 }
// //   //                 // DO NOT remove rows when selecting other methods
// //   //                 // Let the user manage rows manually with the Add/Remove buttons

// //   //                 // Single update at the end
// //   //                 WidgetsBinding.instance.addPostFrameCallback((_) {
// //   //                   if (mounted) {
// //   //                     setState(() {
// //   //                       _calculateRemainingAmount(grandTotal);
// //   //                     });
// //   //                   }
// //   //                 });
// //   //               }
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Reference Number
// //   //         Expanded(
// //   //           flex: 2,
// //   //           child: TextFormField(
// //   //             key: ValueKey('payment_ref_$index'),
// //   //             controller: TextEditingController(text: paymentRow.reference),
// //   //             decoration: const InputDecoration(
// //   //               labelText: 'Reference',
// //   //               border: OutlineInputBorder(),
// //   //               contentPadding: EdgeInsets.symmetric(
// //   //                 horizontal: 8,
// //   //                 vertical: 4,
// //   //               ),
// //   //             ),
// //   //             onChanged: (value) {
// //   //               paymentRow.reference = value;
// //   //             },
// //   //           ),
// //   //         ),
// //   //         const SizedBox(width: 8),

// //   //         // Amount field
// //   //         // Expanded(
// //   //         //   flex: 1,
// //   //         //   child: TextFormField(
// //   //         //     key: ValueKey('payment_amount_$index'),
// //   //         //     controller: TextEditingController(
// //   //         //       text: paymentRow.amount > 0
// //   //         //           ? paymentRow.amount.toStringAsFixed(2)
// //   //         //           : '',
// //   //         //     ),
// //   //         //     decoration: const InputDecoration(
// //   //         //       labelText: 'Amount',
// //   //         //       border: OutlineInputBorder(),
// //   //         //       contentPadding: EdgeInsets.symmetric(
// //   //         //         horizontal: 8,
// //   //         //         vertical: 4,
// //   //         //       ),
// //   //         //     ),
// //   //         //     keyboardType: TextInputType.numberWithOptions(decimal: true),
// //   //         //     inputFormatters: [
// //   //         //       FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //   //         //     ],
// //   //         //     onChanged: (value) {
// //   //         //       if (value.isNotEmpty) {
// //   //         //         final newAmount = double.tryParse(value) ?? 0.0;

// //   //         //         // Validate amount doesn't exceed remaining balance
// //   //         //         final currentTotalPaid = _getCurrentTotalPaid();
// //   //         //         final otherPayments =
// //   //         //             currentTotalPaid - (paymentRow.amount ?? 0.0);
// //   //         //         final maxAllowed = grandTotal - otherPayments;

// //   //         //         if (newAmount > maxAllowed) {
// //   //         //           // Don't update if exceeds total
// //   //         //           return;
// //   //         //         }

// //   //         //         paymentRow.amount = newAmount;
// //   //         //       } else {
// //   //         //         paymentRow.amount = 0.0;
// //   //         //       }

// //   //         //       // Debounced update
// //   //         //       _debouncedCalculation(grandTotal);
// //   //         //     },
// //   //         //   ),
// //   //         // ),
// //   //         // Amount field - Real-time updates without performance issues
// //   //         Expanded(
// //   //           flex: 1,
// //   //           child: TextFormField(
// //   //             key: ValueKey('payment_amount_$index'),
// //   //             controller: TextEditingController(
// //   //               text: paymentRow.amount > 0
// //   //                   ? paymentRow.amount.toStringAsFixed(2)
// //   //                   : '',
// //   //             ),
// //   //             decoration: const InputDecoration(
// //   //               labelText: 'Amount',
// //   //               border: OutlineInputBorder(),
// //   //               contentPadding: EdgeInsets.symmetric(
// //   //                 horizontal: 8,
// //   //                 vertical: 4,
// //   //               ),
// //   //             ),
// //   //             keyboardType: TextInputType.numberWithOptions(decimal: true),
// //   //             inputFormatters: [
// //   //               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //   //             ],
// //   //             onChanged: (value) {
// //   //               if (value.isNotEmpty) {
// //   //                 final newAmount = double.tryParse(value) ?? 0.0;

// //   //                 // Validate in real-time but don't setState immediately
// //   //                 final currentTotalPaid = _getCurrentTotalPaid();
// //   //                 final otherPayments =
// //   //                     currentTotalPaid - (paymentRow.amount ?? 0.0);
// //   //                 final maxAllowed = grandTotal - otherPayments;

// //   //                 if (newAmount <= maxAllowed) {
// //   //                   paymentRow.amount = newAmount;
// //   //                 }
// //   //                 // If exceeds max, don't update the value - let user see their input but it won't be accepted
// //   //               } else {
// //   //                 paymentRow.amount = 0.0;
// //   //               }

// //   //               // Update calculations without rebuilding the entire UI
// //   //               _updateCalculationsWithoutRebuild(grandTotal);
// //   //             },
// //   //           ),
// //   //         ),

// //   //         // Remove button - show for all rows except the first one
// //   //         if (paymentRows.length > 1)
// //   //           IconButton(
// //   //             icon: const Icon(
// //   //               Icons.remove_circle,
// //   //               color: Colors.red,
// //   //               size: 20,
// //   //             ),
// //   //             onPressed: () {
// //   //               paymentRows.removeAt(index);

// //   //               WidgetsBinding.instance.addPostFrameCallback((_) {
// //   //                 if (mounted) {
// //   //                   setState(() {
// //   //                     _calculateRemainingAmount(grandTotal);
// //   //                   });
// //   //                 }
// //   //               });
// //   //             },
// //   //           ),
// //   //       ],
// //   //     ),
// //   //   );
// //   // }

// //   void _validateAndRecalculate(double grandTotal) {
// //     if (!isMultiple)
// //       return; // No validation needed for single payment (it's locked)

// //     // Check if total payments exceed the grand total
// //     final totalPaid = _getCurrentTotalPaid();

// //     if (totalPaid > grandTotal) {
// //       double excess = totalPaid - grandTotal;

// //       // Distribute the excess reduction proportionally
// //       _adjustPaymentAmounts(grandTotal);

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //             'Total payment amount adjusted to not exceed invoice total',
// //           ),
// //           backgroundColor: Colors.orange,
// //           duration: Duration(seconds: 2),
// //         ),
// //       );
// //     }

// //     _calculateRemainingAmount(grandTotal);

// //     if (mounted) {
// //       setState(() {});
// //     }
// //   }

// //   void _adjustPaymentAmounts(double grandTotal) {
// //     final totalPaid = _getCurrentTotalPaid();
// //     if (totalPaid <= grandTotal) return;

// //     final ratio = grandTotal / totalPaid;

// //     for (var row in paymentRows) {
// //       row.amount *= ratio;
// //     }
// //   }

// //   void _distributeAmountsEqually(double grandTotal) {
// //     if (!isMultiple || paymentRows.isEmpty) return;

// //     // Calculate equal amount for ALL rows
// //     final equalAmount = grandTotal / paymentRows.length;

// //     // Update the model but DON'T call setState here
// //     for (var i = 0; i < paymentRows.length; i++) {
// //       paymentRows[i].amount = equalAmount;
// //     }

// //     // The UI will update naturally when the parent rebuilds
// //   }

// //   void _initializePaymentRows(double grandTotal) {
// //     if (isAlreadyPaid) {
// //       if (isMultiple && paymentRows.length > 1) {
// //         // For multiple payments, distribute equally
// //         _distributeAmountsEqually(grandTotal);
// //       } else {
// //         // For single payment, set to total amount
// //         if (paymentRows.isNotEmpty) {
// //           paymentRows.first.amount = grandTotal;
// //         }
// //       }
// //     }
// //   }

// //   Widget _buildPaymentRow(int index, double grandTotal) {
// //     final paymentRow = paymentRows[index];

// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.grey[300]!),
// //       ),
// //       child: Row(
// //         children: [
// //           // Payment Method Dropdown
// //           Expanded(
// //             flex: 2,
// //             child: CustomSearchableDropdown(
// //               key: ValueKey('payment_method_${index}_${paymentRows.length}'),
// //               hintText: 'Method',
// //               items: {for (var m in PaymentMethod.methods) m.id: m.name},
// //               value: paymentRow.method?.id,
// //               onChanged: (value) {
// //                 if (value.isNotEmpty) {
// //                   final newMethod = PaymentMethod.methods.firstWhere(
// //                     (m) => m.id == value,
// //                   );

// //                   paymentRow.method = newMethod;

// //                   if (value == 'multiple' && paymentRows.length == 1) {
// //                     paymentRows.add(PaymentRow());
// //                     _distributeAmountsEqually(grandTotal);
// //                     // Force ONE update after adding row and distributing
// //                     if (mounted) setState(() {});
// //                   }
// //                 }
// //               },
// //             ),
// //           ),
// //           const SizedBox(width: 8),

// //           // Reference Number - This was working fine
// //           Expanded(
// //             flex: 2,
// //             child: TextFormField(
// //               key: ValueKey('payment_ref_$index'),
// //               initialValue: paymentRow.reference,
// //               decoration: const InputDecoration(
// //                 labelText: 'Reference',
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 8,
// //                   vertical: 4,
// //                 ),
// //               ),
// //               onChanged: (value) {
// //                 paymentRow.reference = value;
// //               },
// //             ),
// //           ),
// //           const SizedBox(width: 8),

// //           // Amount field - This was working fine
// //           Expanded(
// //             flex: 1,
// //             child: TextFormField(
// //               key: ValueKey('payment_amount_$index'),
// //               initialValue: paymentRow.amount > 0
// //                   ? paymentRow.amount.toStringAsFixed(2)
// //                   : '',
// //               decoration: const InputDecoration(
// //                 labelText: 'Amount',
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 8,
// //                   vertical: 4,
// //                 ),
// //               ),
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //               readOnly: !isMultiple && paymentRows.length == 1,
// //               onChanged: (value) {
// //                 if (value.isNotEmpty) {
// //                   final newAmount = double.tryParse(value) ?? 0.0;
// //                   paymentRow.amount = newAmount;
// //                 } else {
// //                   paymentRow.amount = 0.0;
// //                 }
// //               },
// //               onEditingComplete: () {
// //                 if (isMultiple) {
// //                   _validateAndRecalculate(grandTotal);
// //                 }
// //                 FocusScope.of(context).unfocus();
// //               },
// //             ),
// //           ),

// //           // Remove button
// //           if (isMultiple && paymentRows.length > 1)
// //             IconButton(
// //               icon: const Icon(
// //                 Icons.remove_circle,
// //                 color: Colors.red,
// //                 size: 20,
// //               ),
// //               onPressed: () {
// //                 paymentRows.removeAt(index);
// //                 _distributeAmountsEqually(grandTotal);
// //                 // Force ONE update after removal and distribution
// //                 if (mounted) setState(() {});
// //               },
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class ProductRowWidget extends StatefulWidget {
// //   final ProductRow productRow;
// //   final List<SaleItem> allItems;
// //   final int index;
// //   final Function(ProductRow) onUpdate;
// //   final VoidCallback onRemove;
// //   final bool showRemoveButton;

// //   const ProductRowWidget({
// //     super.key,
// //     required this.productRow,
// //     required this.allItems,
// //     required this.index,
// //     required this.onUpdate,
// //     required this.onRemove,
// //     required this.showRemoveButton,
// //   });

// //   @override
// //   State<ProductRowWidget> createState() => _ProductRowWidgetState();
// // }

// // class _ProductRowWidgetState extends State<ProductRowWidget> {
// //   final TextEditingController _priceController = TextEditingController();
// //   final TextEditingController _qtyController = TextEditingController();
// //   final FocusNode _priceFocusNode = FocusNode();
// //   final FocusNode _qtyFocusNode = FocusNode();
// //   double _originalPrice = 0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeControllers();
// //     _priceFocusNode.addListener(_onPriceFocusChange);
// //   }

// //   @override
// //   void dispose() {
// //     _priceFocusNode.removeListener(_onPriceFocusChange);
// //     _priceController.dispose();
// //     _qtyController.dispose();
// //     _priceFocusNode.dispose();
// //     _qtyFocusNode.dispose();
// //     super.dispose();
// //   }

// //   void _initializeControllers() {
// //     if (widget.productRow.type == 'service') {
// //       _priceController.text =
// //           widget.productRow.selectedPrice?.toStringAsFixed(2) ?? '0';
// //       _originalPrice = widget.productRow.selectedPrice ?? 0;
// //     } else {
// //       _priceController.text =
// //           widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '0';
// //       _originalPrice = widget.productRow.sellingPrice ?? 0;
// //     }
// //     _qtyController.text = widget.productRow.quantity.toString();
// //   }

// //   void _onPriceFocusChange() {
// //     if (!_priceFocusNode.hasFocus) {
// //       _validateAndUpdatePrice();
// //     }
// //   }

// //   void _validateAndUpdatePrice() {
// //     final newPrice = double.tryParse(_priceController.text) ?? 0;
// //     final minimumPrice = widget.productRow.saleItem?.minimumPrice ?? 0;
// //     final sellingPrice = widget.productRow.saleItem?.sellingPrice ?? 0;

// //     debugPrint(
// //       'Validating price - New: $newPrice, Min: $minimumPrice, Selling: $sellingPrice',
// //     );

// //     if (newPrice < minimumPrice) {
// //       debugPrint('Price below minimum - resetting to selling price');
// //       _showMinimumPriceError(minimumPrice);
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         if (mounted) {
// //           setState(() {
// //             _priceController.text = sellingPrice.toStringAsFixed(2);
// //             _updatePriceInModel(sellingPrice);
// //           });
// //         }
// //       });
// //     } else {
// //       _updatePriceInModel(newPrice);
// //     }
// //   }

// //   void _updatePriceInModel(double newPrice) {
// //     if (widget.productRow.type == 'service') {
// //       widget.productRow.selectedPrice = newPrice;
// //     } else {
// //       widget.productRow.sellingPrice = newPrice;

// //       // Recalculate margin for products
// //       if (widget.productRow.cost > 0) {
// //         widget.productRow.margin =
// //             ((newPrice - widget.productRow.cost) / widget.productRow.cost) *
// //             100;
// //       }
// //     }

// //     widget.productRow.calculateTotals();
// //     widget.onUpdate(widget.productRow);
// //   }

// //   void _showMinimumPriceError(double minimumPrice) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(
// //           'Price cannot be less than minimum price: OMR ${minimumPrice.toStringAsFixed(2)}',
// //         ),
// //         backgroundColor: Colors.red,
// //         duration: Duration(seconds: 3),
// //       ),
// //     );
// //   }

// //   Widget _buildProductDropdown() {
// //     final Map<String, String> itemMap = {};
// //     for (var item in widget.allItems) {
// //       String displayName = item.productName;
// //       if (item.type == 'service') {
// //         displayName = '⚡ $displayName (Service)';
// //       } else {
// //         displayName = '📦 $displayName (Product)';
// //       }
// //       itemMap[item.productId] = displayName;
// //     }

// //     return CustomSearchableDropdown(
// //       key: widget.productRow.dropdownKey,
// //       hintText: 'Select Item',
// //       items: itemMap,
// //       value: widget.productRow.saleItem?.productId,
// //       onChanged: (value) {
// //         if (value.isNotEmpty) {
// //           final selected = widget.allItems.firstWhere(
// //             (item) => item.productId == value,
// //           );
// //           if (mounted) {
// //             setState(() {
// //               widget.productRow.saleItem = selected;
// //               widget.productRow.type = selected.type;

// //               if (selected.type == 'service') {
// //                 widget.productRow.selectedPrice = selected.sellingPrice;
// //                 widget.productRow.sellingPrice = null;
// //                 widget.productRow.cost = selected.cost;
// //                 _priceController.text = selected.sellingPrice.toStringAsFixed(
// //                   2,
// //                 );
// //               } else {
// //                 widget.productRow.sellingPrice = selected.sellingPrice;
// //                 _priceController.text = selected.sellingPrice.toStringAsFixed(
// //                   2,
// //                 );
// //                 widget.productRow.cost = selected.cost;
// //                 widget.productRow.margin = selected.cost > 0
// //                     ? ((selected.sellingPrice - selected.cost) /
// //                               selected.cost) *
// //                           100
// //                     : 0;
// //               }
// //               _originalPrice = selected.sellingPrice;
// //               widget.productRow.calculateTotals();
// //               widget.onUpdate(widget.productRow);
// //               FocusScope.of(context).requestFocus(_qtyFocusNode);
// //             });
// //           }
// //         }
// //       },
// //     );
// //   }

// //   Widget _buildPriceInput() {
// //     return TextFormField(
// //       key: widget.productRow.priceKey,
// //       controller: _priceController,
// //       focusNode: _priceFocusNode,
// //       enabled: true,
// //       decoration: InputDecoration(
// //         labelText: 'Price (OMR)',
// //         border: OutlineInputBorder(),
// //         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       ),
// //       keyboardType: TextInputType.numberWithOptions(decimal: true),
// //       textInputAction: TextInputAction.next,
// //       onChanged: (value) {
// //         if (value.isNotEmpty) {
// //           final newPrice = double.tryParse(value) ?? 0;
// //           final minimumPrice = widget.productRow.saleItem?.minimumPrice ?? 0;
// //           if (newPrice >= minimumPrice) {
// //             _updatePriceInModel(newPrice);
// //           }
// //         }
// //       },
// //       onEditingComplete: () {
// //         _validateAndUpdatePrice();
// //         FocusScope.of(context).requestFocus(_qtyFocusNode);
// //       },
// //       onFieldSubmitted: (value) {
// //         _validateAndUpdatePrice();
// //       },
// //     );
// //   }

// //   Widget _buildQuantityInput() {
// //     return TextFormField(
// //       key: widget.productRow.quantityKey,
// //       controller: _qtyController,
// //       focusNode: _qtyFocusNode,
// //       autovalidateMode: AutovalidateMode.onUserInteraction,
// //       decoration: const InputDecoration(
// //         labelText: 'Qty',
// //         border: OutlineInputBorder(),
// //         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       ),
// //       inputFormatters: [
// //         FilteringTextInputFormatter.digitsOnly,
// //         LengthLimitingTextInputFormatter(5),
// //       ],
// //       validator: (value) {
// //         debugPrint('Validator called with value: $value');
// //         final error = ValidationUtils.quantity(value);
// //         debugPrint('Validation error: $error');
// //         return error;
// //       },
// //       keyboardType: TextInputType.number,
// //       onChanged: (value) {
// //         if (value.isNotEmpty) {
// //           final quantity = int.tryParse(value) ?? 0;
// //           if (quantity == 0) {
// //             _qtyController.text = "1";
// //             widget.productRow.quantity = 1;
// //           }

// //           if (quantity > 0 && quantity <= 999999) {
// //             // Valid quantity - update the model
// //             if (mounted) {
// //               setState(() {
// //                 widget.productRow.quantity = quantity;
// //                 widget.productRow.calculateTotals();
// //                 widget.onUpdate(widget.productRow);
// //               });
// //             }
// //           }
// //         } else {
// //           _qtyController.text = "1";
// //           widget.productRow.quantity = 1;
// //           if (mounted) {
// //             setState(() {
// //               widget.productRow.quantity = 1;
// //               widget.productRow.calculateTotals();
// //               widget.onUpdate(widget.productRow);
// //             });
// //           }
// //         }
// //       },
// //       onEditingComplete: () {
// //         // Final cleanup when user finishes editing
// //         final value = _qtyController.text;
// //         final quantity = int.tryParse(value) ?? 0;

// //         if (quantity < 1) {
// //           // Reset to minimum 1
// //           if (mounted) {
// //             setState(() {
// //               widget.productRow.quantity = 1;
// //               _qtyController.text = '1';
// //               widget.productRow.calculateTotals();
// //               widget.onUpdate(widget.productRow);
// //             });
// //           }
// //         }
// //         _qtyFocusNode.unfocus();
// //       },
// //     );
// //   }

// //   Widget _buildDiscountInput() {
// //     return TextFormField(
// //       key: widget.productRow.discountKey,
// //       initialValue: widget.productRow.discount.toString(),
// //       decoration: const InputDecoration(
// //         labelText: 'Discount %',
// //         border: OutlineInputBorder(),
// //         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //         suffixText: '%',
// //       ),
// //       autovalidateMode: AutovalidateMode.onUserInteraction,
// //       inputFormatters: [
// //         FilteringTextInputFormatter.digitsOnly,
// //         LengthLimitingTextInputFormatter(2),
// //       ],
// //       validator: (value) {
// //         debugPrint('Validator called with value: $value');
// //         final error = ValidationUtils.discount(value);
// //         debugPrint('Validation error: $error');
// //         return error;
// //       },
// //       keyboardType: TextInputType.numberWithOptions(decimal: true),
// //       onChanged: (value) {
// //         if (value.isNotEmpty) {
// //           final discount = double.tryParse(value) ?? 0;
// //           if (mounted) {
// //             setState(() {
// //               widget.productRow.discount = discount;
// //               widget.productRow.calculateTotals();
// //               widget.onUpdate(widget.productRow);
// //             });
// //           }
// //         }
// //       },
// //       onEditingComplete: () {
// //         FocusScope.of(context).unfocus();
// //       },
// //     );
// //   }

// //   Widget _buildAmountDisplay(String amount, {bool isTotal = false}) {
// //     return Text(
// //       amount,
// //       style: TextStyle(
// //         fontSize: 12,
// //         fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
// //         color: isTotal ? AppTheme.primaryColor : Colors.black,
// //       ),
// //     );
// //   }

// //   @override
// //   void didUpdateWidget(ProductRowWidget oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     // Update controllers when widget data changes
// //     if (oldWidget.productRow != widget.productRow) {
// //       _initializeControllers();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 8),
// //       padding: const EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         color: Colors.grey[50],
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.grey[300]!),
// //       ),
// //       child: Row(
// //         children: [
// //           // Product Dropdown
// //           Expanded(flex: 2, child: _buildProductDropdown()),
// //           const SizedBox(width: 8),

// //           // Price Input
// //           Expanded(flex: 1, child: _buildPriceInput()),
// //           const SizedBox(width: 8),

// //           // Quantity Input
// //           Expanded(flex: 1, child: _buildQuantityInput()),
// //           const SizedBox(width: 8),

// //           // Discount Input
// //           Expanded(flex: 1, child: _buildDiscountInput()),
// //           const SizedBox(width: 8),

// //           // Subtotal
// //           Expanded(
// //             flex: 1,
// //             child: _buildAmountDisplay(
// //               'OMR ${widget.productRow.subtotal.toStringAsFixed(2)}',
// //             ),
// //           ),
// //           const SizedBox(width: 8),

// //           // Total
// //           Expanded(
// //             flex: 1,
// //             child: _buildAmountDisplay(
// //               'OMR ${widget.productRow.total.toStringAsFixed(2)}',
// //               isTotal: true,
// //             ),
// //           ),
// //           const SizedBox(width: 8),

// //           // Remove Button
// //           if (widget.showRemoveButton)
// //             IconButton(
// //               icon: const Icon(
// //                 Icons.remove_circle,
// //                 color: Colors.red,
// //                 size: 20,
// //               ),
// //               onPressed: widget.onRemove,
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // ignore_for_file: deprecated_member_use

// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:modern_motors_panel/app_theme.dart';
// import 'package:modern_motors_panel/constants.dart';
// import 'package:modern_motors_panel/extensions.dart';
// import 'package:modern_motors_panel/model/attachment_model.dart';
// import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
// import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
// import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/employees_commision_model.dart';
// import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
// import 'package:modern_motors_panel/model/product_models/product_model.dart';
// import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
// import 'package:modern_motors_panel/model/sales_model/credit_days_model.dart';
// import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
// import 'package:modern_motors_panel/model/services_model/services_model.dart';
// import 'package:modern_motors_panel/model/supplier/supplier_model.dart';
// import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
// import 'package:modern_motors_panel/provider/purchase_invoice_provider.dart';
// import 'package:modern_motors_panel/widgets/dialogue_box_picker.dart';
// import 'package:modern_motors_panel/widgets/overlay_loader.dart';
// import 'package:provider/provider.dart';

// mixin PerformanceOptimizer on State<PurchaseInvoice> {
//   final Map<String, Timer> _timers = {};

//   void debouncedSetState(String key, Duration duration, VoidCallback callback) {
//     _timers[key]?.cancel();
//     _timers[key] = Timer(duration, () {
//       if (mounted) {
//         setState(callback);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timers.forEach((key, timer) => timer.cancel());
//     _timers.clear();
//     super.dispose();
//   }
// }

// class PaymentMethod {
//   final String id;
//   final String name;

//   PaymentMethod({required this.id, required this.name});

//   static List<PaymentMethod> get methods => [
//     PaymentMethod(id: 'cash', name: 'Cash'),
//     PaymentMethod(id: 'credit_card', name: 'Credit Card'),
//     PaymentMethod(id: 'Debit Card', name: 'Debit Card'),
//     PaymentMethod(id: 'bank_transfer', name: 'Bank Transfer'),
//     PaymentMethod(id: 'pos', name: 'POS'),
//     PaymentMethod(id: 'multiple', name: 'Multiple'),
//   ];
// }

// class PaymentRow {
//   PaymentMethod? method;
//   String reference = '';
//   double amount = 0;

//   PaymentRow({this.method, this.reference = '', this.amount = 0});
// }

// class DiscountType {
//   final String id;
//   final String name;

//   DiscountType({required this.id, required this.name});

//   static List<DiscountType> get types => [
//     DiscountType(id: 'percentage', name: '%'),
//     DiscountType(id: 'amount', name: 'OMR'),
//   ];
// }

// class DepositType {
//   final String id;
//   final String name;

//   DepositType({required this.id, required this.name});

//   static List<DepositType> get types => [
//     DepositType(id: 'percentage', name: '%'),
//     DepositType(id: 'amount', name: 'OMR'),
//   ];
// }

// class ProductRow {
//   PurchaseItem? purchaseItem;
//   String? type;
//   double? avgPrice;
//   double? selectedPrice;
//   double margin = 0;
//   int quantity = 1;
//   double discount = 0;
//   bool applyVat = true;
//   double subtotal = 0;
//   double vatAmount = 0;
//   double total = 0;
//   double profit = 0;
//   double cost = 0;
//   double serviceCost = 0;
//   String? serviceType;
//   late Key dropdownKey;
//   late Key priceKey;
//   late Key quantityKey;
//   late Key discountKey;
//   late Key serviceCostKey;

//   ProductRow({
//     this.total = 0,
//     this.subtotal = 0,
//     this.purchaseItem,
//     this.type,
//     this.avgPrice,
//     this.selectedPrice,
//     this.quantity = 1,
//     this.discount = 0,
//     this.applyVat = true,
//     this.cost = 0,
//     this.serviceCost = 0,
//     this.serviceType,
//   }) {
//     dropdownKey = UniqueKey();
//     priceKey = UniqueKey();
//     quantityKey = UniqueKey();
//     discountKey = UniqueKey();
//     serviceCostKey = UniqueKey();
//   }

//   void calculateTotals() {
//     if (type == "service") {
//       subtotal = (selectedPrice ?? 0) * quantity;
//     } else {
//       if (avgPrice == null && margin != 0) {
//         avgPrice = cost * (1 + margin / 100);
//       }
//       subtotal = (avgPrice ?? 0) * quantity;
//       subtotal = subtotal + serviceCost;
//     }
//     final discountAmount = subtotal * (discount / 100);
//     final amountAfterDiscount = subtotal - discountAmount;
//     vatAmount = applyVat ? amountAfterDiscount * 0.00 : 0;
//     total = amountAfterDiscount + vatAmount;
//     if (type == "product") {
//       profit = (avgPrice ?? 0) - cost;
//     }
//   }
// }

// class PurchaseInvoice extends StatefulWidget {
//   final VoidCallback? onBack;
//   final NewPurchaseModel? purchase;
//   final List<ProductModel>? products;
//   final String? type;
//   const PurchaseInvoice({
//     super.key,
//     this.onBack,
//     this.purchase,
//     this.products,
//     this.type,
//   });

//   @override
//   State<PurchaseInvoice> createState() => _PurchaseInvoiceState();
// }

// class _PurchaseInvoiceState extends State<PurchaseInvoice>
//     with PerformanceOptimizer {
//   final supplierNameController = TextEditingController();
//   final discountController = TextEditingController();
//   final depositAmountController = TextEditingController();

//   // Data
//   List<SupplierModel> allSuppliers = [];
//   List<SupplierModel> filteredSuppliers = [];
//   List<ServiceTypeModel> allServices = [];
//   List<ProductModel> allProducts = [];
//   CreditDaysModel? creditDays;
//   List<ProductRow> productRows = [];
//   double productsGrandTotal = 0;
//   bool loading = false;
//   double servicesGrandTotal = 0;
//   List<PurchaseItem> purchaseItem = [];
//   bool isAlreadyPaid = false;
//   bool isMultiple = false;
//   List<PaymentRow> paymentRows = [PaymentRow()];
//   double remainingAmount = 0;
//   bool _isLoadingDiscounts = true;
//   DiscountType selectedDiscountType = DiscountType.types[0];
//   DepositType selectedDepositType = DepositType.types[0];
//   bool requireDeposit = false;
//   double depositAmount = 0;
//   double depositPercentage = 0;
//   bool depositAlreadyPaid = false;
//   double nextPaymentAmount = 0;
//   List<AttachmentModel> displayPicture = [];
//   double invNumber = 0;
//   int? selectedCreditDays;
//   Timer? _calculationTimer;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final p = context.read<PurchaseInvoiceProvider>();
//       p.clearData();
//       DateTime t = DateTime.now();
//       if (widget.purchase == null) {
//         p.setBookingTime(t);
//       } else {
//         p.setBookingTime(widget.purchase!.createdAt);
//       }
//     });
//     if (widget.purchase == null) {
//       productRows.add(ProductRow());
//     }
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     supplierNameController.dispose();
//     discountController.dispose();
//     depositAmountController.dispose();
//     _calculationTimer?.cancel();
//     super.dispose();
//   }

//   void _debouncedCalculateRemaining(double grandTotal) {
//     _calculationTimer?.cancel();
//     _calculationTimer = Timer(const Duration(milliseconds: 300), () {
//       if (mounted) {
//         setState(() {
//           _calculateRemainingAmount(grandTotal);
//         });
//       }
//     });
//   }

//   Future<void> _loadInitialData() async {
//     if (mounted) {
//       setState(() => _isLoadingDiscounts = true);
//     }
//     if (widget.purchase == null) {
//       var value = await Constants.getUniqueNumberValue("purchase");
//       invNumber = value;
//     } else {
//       invNumber = double.parse(widget.purchase!.invoice);
//     }

//     try {
//       final results = await Future.wait([
//         // DataFetchService.fetchDiscount(),
//         DataFetchService.fetchSuppliers(),
//         //DataFetchService.fetchTrucks(),
//         //DataFetchService.fetchServiceTypes(),
//         DataFetchService.fetchProducts(),
//         DataFetchService.getCreditDays(),
//       ]);
//       allSuppliers = results[0] as List<SupplierModel>;
//       //allTrucks = results[2] as List<MmtrucksModel>;
//       //allServices = results[3] as List<ServiceTypeModel>;
//       allProducts = results[1] as List<ProductModel>;
//       creditDays = results[2] as CreditDaysModel;
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         if (widget.purchase != null) {
//           SupplierModel? supplier;
//           supplier = allSuppliers.firstWhere(
//             (item) => item.id == widget.purchase!.supplierId,
//           );
//           supplierNameController.text = supplier.supplierName;
//           final p = context.read<PurchaseInvoiceProvider>();
//           p.setCustomer(id: widget.purchase!.supplierId);
//           for (var element in widget.purchase!.items) {
//             productRows.add(
//               ProductRow(
//                 purchaseItem: element,
//                 type: element.type,
//                 avgPrice: element.cost,
//                 quantity: element.quantity,
//                 total: element.totalPrice,
//                 subtotal: element.discount + element.totalPrice,
//                 discount: element.discount,
//                 serviceCost: 0,
//               ),
//             );
//           }
//           discountController.text = widget.purchase!.discount.toString();
//           p.getValues(widget.purchase!.taxAmount, widget.purchase!.total!);
//           p.discountType = widget.purchase!.discountType;
//           if (widget.purchase!.discountType == 'percentage') {
//             selectedDiscountType = DiscountType.types[0];
//             p.discountType = selectedDiscountType.id;
//             p.setDiscountPercent(widget.purchase!.discount);
//           } else {
//             selectedDiscountType = DiscountType.types[1];
//             p.discountType = selectedDiscountType.id;
//             p.setDiscountPercent(widget.purchase!.discount);
//           }
//           productsGrandTotal = productRows.fold(
//             0,
//             (sum, row) => sum + row.total,
//           );
//           _applyDiscount(p, productsGrandTotal);
//           if (widget.purchase!.paymentData.paymentMethods.isNotEmpty) {
//             isAlreadyPaid = true;
//             paymentRows.clear();

//             debugPrint('Loading payment data from sale:');
//             debugPrint(
//               'Number of payment methods: ${widget.purchase!.paymentData.paymentMethods.length}',
//             );
//             debugPrint(
//               'Is multiple: ${widget.purchase!.paymentData.paymentMethods.length > 1}',
//             );

//             isMultiple = widget.purchase!.paymentData.paymentMethods.length > 1;

//             for (
//               var i = 0;
//               i < widget.purchase!.paymentData.paymentMethods.length;
//               i++
//             ) {
//               final element = widget.purchase!.paymentData.paymentMethods[i];
//               debugPrint(
//                 'Payment method $i: ${element.method}, Reference: ${element.reference}, Amount: ${element.amount}',
//               );
//               PaymentMethod? paymentMethod;
//               try {
//                 paymentMethod = PaymentMethod.methods.firstWhere(
//                   (method) =>
//                       method.id.toLowerCase() == element.method?.toLowerCase(),
//                 );
//               } catch (e) {
//                 paymentMethod = PaymentMethod(
//                   id: element.method ?? 'unknown',
//                   name: element.method ?? 'Unknown',
//                 );
//               }
//               final newPaymentRow = PaymentRow(
//                 method: paymentMethod,
//                 reference: element.reference,
//                 amount: element.amount,
//               );
//               paymentRows.add(newPaymentRow);
//               debugPrint(
//                 'Added PaymentRow: ${newPaymentRow.method?.name}, ${newPaymentRow.reference}, ${newPaymentRow.amount}',
//               );
//             }
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (mounted) {
//                 final double subtotal = servicesGrandTotal + productsGrandTotal;
//                 final double discountAmount = p.discountAmount;
//                 final double amountAfterDiscount = subtotal - discountAmount;
//                 final double taxAmount = p.getIsTaxApply
//                     ? amountAfterDiscount * (p.taxPercent / 100)
//                     : 0;
//                 final double total = amountAfterDiscount + taxAmount;

//                 _calculateRemainingAmount(total);
//                 if (mounted) {
//                   setState(() {});
//                 }
//               }
//             });
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (widget.purchase != null) {
//                 final double subtotal = servicesGrandTotal + productsGrandTotal;
//                 final double discountAmount = p.discountAmount;
//                 final double amountAfterDiscount = subtotal - discountAmount;
//                 final double taxAmount = p.getIsTaxApply
//                     ? amountAfterDiscount * (p.taxPercent / 100)
//                     : 0;
//                 final double total = amountAfterDiscount + taxAmount;

//                 _ensurePaymentAmounts(total);
//               }
//             });
//           }
//         }
//       });
//       purchaseItem = mergeProductsAndServices(allProducts, allServices);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
//       }
//     } finally {
//       if (mounted) setState(() => _isLoadingDiscounts = false);
//     }
//   }

//   List<PurchaseItem> mergeProductsAndServices(
//     List<ProductModel> products,
//     List<ServiceTypeModel> services,
//   ) {
//     List<PurchaseItem> mergedList = [];

//     mergedList.addAll(
//       products.map(
//         (product) => PurchaseItem(
//           discount: 0,
//           margin: 0,
//           minimumPrice: product.minimumPrice ?? 0,
//           productId: product.id ?? '',
//           productName: product.productName ?? '',
//           quantity: 1,
//           sellingPrice: product.sellingPrice ?? product.lastCost ?? 0,
//           totalPrice: (product.sellingPrice ?? product.lastCost ?? 0) * 1,
//           unitPrice: product.averageCost ?? product.lastCost ?? 0,
//           type: 'product',
//           cost: product.averageCost ?? 0,
//         ),
//       ),
//     );

//     mergedList.addAll(
//       services.map((service) {
//         double price = service.prices?.isNotEmpty == true
//             ? (service.prices?[0] as num).toDouble()
//             : 0;

//         return PurchaseItem(
//           discount: 0,
//           margin: 0,
//           productId: service.id ?? '',
//           productName: service.name,
//           minimumPrice: service.minimumPrice ?? 0,
//           quantity: 1,
//           sellingPrice: price,
//           totalPrice: price,
//           unitPrice: price,
//           type: 'service',
//           cost: price,
//         );
//       }),
//     );

//     return mergedList;
//   }

//   void _addProductRow() {
//     if (mounted) {
//       setState(() {
//         productRows.add(ProductRow());
//       });
//     }
//   }

//   double _getRemainingAmount(double grandTotal) {
//     double paidAmount = paymentRows.fold(
//       0.0,
//       (sum, row) => sum + (row.amount ?? 0),
//     );
//     return grandTotal - paidAmount;
//   }

//   void _calculateRemainingAmount(double grandTotal) {
//     double paidAmount = _getCurrentTotalPaid();

//     if (isAlreadyPaid && paymentRows.length == 1 && !isMultiple) {
//       if (paymentRows.first.amount == 0) {
//         paymentRows.first.amount = grandTotal;
//         paidAmount = grandTotal;
//       }
//     }

//     remainingAmount = grandTotal - paidAmount;

//     if (remainingAmount < 0) {
//       remainingAmount = 0;
//     }
//   }

//   void _ensurePaymentAmounts(double grandTotal) {
//     if (isAlreadyPaid && paymentRows.isNotEmpty) {
//       double totalPaid = paymentRows.fold(
//         0.0,
//         (sum, row) => sum + (row.amount ?? 0.0),
//       );

//       if (totalPaid == 0 && grandTotal > 0) {
//         if (paymentRows.length == 1 && !isMultiple) {
//           paymentRows.first.amount = grandTotal;
//         } else if (paymentRows.length > 1 || isMultiple) {
//           double equalAmount = grandTotal / paymentRows.length;
//           for (var row in paymentRows) {
//             row.amount = equalAmount;
//           }
//         }
//         _calculateRemainingAmount(grandTotal);
//       }
//     }
//   }

//   void _updateAllCalculations(PurchaseInvoiceProvider p) {
//     if (!mounted) return;
//     final double subtotal = servicesGrandTotal + productsGrandTotal;
//     final double discountAmount = p.discountAmount;
//     final double amountAfterDiscount = subtotal - discountAmount;
//     final double taxAmount = p.getIsTaxApply
//         ? amountAfterDiscount * (p.taxPercent / 100)
//         : 0;
//     final double total = amountAfterDiscount + taxAmount;

//     _updateDepositCalculation(total, p);
//   }

//   void _updateDepositCalculation(double grandTotal, PurchaseInvoiceProvider p) {
//     if (requireDeposit) {
//       if (selectedDepositType.id == 'percentage') {
//         depositAmount = grandTotal * (depositPercentage / 100);
//       } else {
//         depositAmount = double.tryParse(depositAmountController.text) ?? 0;
//         if (depositAmount > grandTotal) {
//           depositAmount = grandTotal;
//           depositAmountController.text = grandTotal.toStringAsFixed(2);
//         }
//       }
//       p.depositAmount = depositAmount;
//       nextPaymentAmount = grandTotal - depositAmount;
//       p.remainingAmount = nextPaymentAmount;
//     } else {
//       depositAmount = 0;
//       nextPaymentAmount = grandTotal;
//     }
//     _calculateRemainingAmount(grandTotal);
//   }

//   void _applyDiscount(PurchaseInvoiceProvider p, double subtotal) {
//     final discountValue = double.tryParse(discountController.text) ?? 0;
//     p.discountType = selectedDiscountType.id;
//     if (selectedDiscountType.id == 'percentage') {
//       p.setDiscountPercent(discountValue);
//     } else {
//       final discountPercent = discountValue > 0
//           ? (discountValue / subtotal) * 100
//           : 0;
//       if (widget.purchase != null) {
//         p.setDiscountValue(widget.purchase!.discount);
//       } else {
//         p.setDiscountPercent(discountPercent.toDouble());
//       }
//     }
//     _updateAllCalculations(p);
//   }

//   void _removeProductRow(int index, PurchaseInvoiceProvider p) {
//     if (mounted) {
//       setState(() {
//         if (productRows.length > 1) {
//           productRows.removeAt(index);
//           _calculateProductsGrandTotal();
//         } else {
//           productRows.clear();
//           productsGrandTotal = 0;
//           p.setProductsTotal(0);
//         }
//       });
//     }
//     discountController.clear();
//     final discount = double.tryParse(discountController.text) ?? 0;
//     p.setDiscountPercent(discount);
//     _updateAllCalculations(p);
//   }

//   void _updateProductRow(
//     int index,
//     ProductRow updatedRow,
//     PurchaseInvoiceProvider p,
//   ) {
//     if (mounted) {
//       setState(() {
//         productRows[index] = updatedRow;
//         _calculateProductsGrandTotal();
//       });
//     }
//     discountController.clear();
//     final discount = double.tryParse(discountController.text) ?? 0;
//     p.setDiscountPercent(discount);
//     _updateAllCalculations(p);
//   }

//   void _calculateProductsGrandTotal() {
//     productsGrandTotal = productRows.fold(0, (sum, row) => sum + row.total);
//     final p = context.read<PurchaseInvoiceProvider>();
//   }

//   Widget _productSelectionSection(
//     BuildContext context,
//     PurchaseInvoiceProvider p,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppTheme.borderColor),
//           color: AppTheme.whiteColor,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Products',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             const Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Item',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Price',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Qty',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Discount',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Product Expense',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Expense Type',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Subtotal',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Total',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(width: 40),
//               ],
//             ),
//             const SizedBox(height: 8),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: productRows.length,
//               itemBuilder: (context, index) {
//                 return ProductRowWidget(
//                   productRow: productRows[index],
//                   allItems: purchaseItem,
//                   index: index,
//                   onUpdate: (updatedRow) =>
//                       _updateProductRow(index, updatedRow, p),
//                   onRemove: () => _removeProductRow(index, p),
//                   showRemoveButton: true,
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton.icon(
//                 onPressed: _addProductRow,
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add Product'),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Products Grand Total:',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'OMR ${productsGrandTotal.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppTheme.primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickBookingDate(PurchaseInvoiceProvider p) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: p.purchaseDate,
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2050),
//     );
//     if (picked != null) {
//       if (!mounted) return;
//       final t = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(p.purchaseDate),
//       );
//       final finalDt = (t == null)
//           ? DateTime(picked.year, picked.month, picked.day)
//           : DateTime(picked.year, picked.month, picked.day, t.hour, t.minute);

//       p.setBookingTime(finalDt);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppTheme.backgroundGreyColor,
//       child: Consumer<PurchaseInvoiceProvider>(
//         builder: (context, p, _) {
//           return SingleChildScrollView(
//             child: Form(
//               key: p.createBookingKey,
//               child: OverlayLoader(
//                 loader: _isLoadingDiscounts,
//                 child: Column(
//                   children: [
//                     PageHeaderWidget(
//                       title: 'Create Purchase Invoice',
//                       buttonText: 'Back to Invoices',
//                       subTitle: 'Create New Purchase Invoice',
//                       onCreateIcon: 'assets/images/back.png',
//                       selectedItems: [],
//                       buttonWidth: 0.25,
//                       onCreate: widget.onBack!.call,
//                       onDelete: () async {},
//                     ),
//                     20.h,
//                     _topCard(context, p),
//                     12.h,
//                     p.orderLoading
//                         ? MmloadingWidget()
//                         : Column(
//                             children: [
//                               _productSelectionSection(context, p),
//                               12.h,
//                               _middleRow(context, p),
//                             ],
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void saleTemplate(NewPurchaseModel saleDetails) async {
//     // if (mounted) {
//     //   Navigator.of(context).push(
//     //     MaterialPageRoute(
//     //       builder: (_) {
//     //         return SalesInvoiceDropdownView(sale: saleDetails);
//     //       },
//     //     ),
//     //   );
//     // }
//   }

//   Widget _topCard(BuildContext context, PurchaseInvoiceProvider p) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppTheme.borderColor),
//           color: AppTheme.whiteColor,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             8.h,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${"Invoice #"} MM-${invNumber.toString()}",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: AppTheme.pageHeaderTitleColor,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Tooltip(
//                       message: 'Preview Invoice',
//                       preferBelow: false,
//                       verticalOffset: 20,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[800],
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       textStyle: TextStyle(color: Colors.white, fontSize: 12),
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           double d =
//                               double.tryParse(discountController.text) ?? 0;
//                           final productsData = Constants.buildProductsData(
//                             productRows,
//                           );
//                           final depositData = {
//                             'requireDeposit': requireDeposit,
//                             'depositType': selectedDepositType.id,
//                             'depositAmount': depositAmount,
//                             'depositPercentage': depositPercentage,
//                             'nextPaymentAmount': nextPaymentAmount,
//                           };
//                           final paymentData = isAlreadyPaid
//                               ? {
//                                   'isAlreadyPaid': true,
//                                   'paymentMethods': paymentRows
//                                       .map(
//                                         (row) => {
//                                           'method': row.method?.id,
//                                           'methodName': row.method?.name,
//                                           'reference': row.reference,
//                                           'amount': row.amount,
//                                         },
//                                       )
//                                       .toList(),
//                                   'totalPaid': paymentRows.fold(
//                                     0,
//                                     (sum, row) => sum + row.amount as int,
//                                   ),
//                                   'remainingAmount': remainingAmount,
//                                 }
//                               : {
//                                   'isAlreadyPaid': false,
//                                   'paymentMethods': [],
//                                   'totalPaid': 0,
//                                   'remainingAmount': p.total,
//                                 };
//                           final NewPurchaseModel saleDetails =
//                               Constants.parseToPurchaseModel(
//                                 productsData: productsData,
//                                 depositData: depositData,
//                                 paymentData: paymentData,
//                                 totalRevenue: p.total,
//                                 discount: d,
//                                 taxAmount: p.taxAmount,
//                                 supplierId: p.supplierId!,
//                                 isEdit: false,
//                               );
//                           saleTemplate(saleDetails);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                         ),
//                         icon: Icon(
//                           Icons.preview_sharp,
//                           size: 18,
//                           color: AppTheme.whiteColor,
//                         ),
//                         label: Text('Preview', style: TextStyle(fontSize: 14)),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Tooltip(
//                       message: 'Save as Draft',
//                       preferBelow: false,
//                       verticalOffset: 20,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[800],
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       textStyle: TextStyle(color: Colors.white, fontSize: 12),
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           double d =
//                               double.tryParse(discountController.text) ?? 0;
//                           final productsData = Constants.buildProductsData(
//                             productRows,
//                           );
//                           final depositData = {
//                             'requireDeposit': requireDeposit,
//                             'depositType': selectedDepositType.id,
//                             'depositAmount': depositAmount,
//                             'depositPercentage': depositPercentage,
//                             'nextPaymentAmount': nextPaymentAmount,
//                           };
//                           final paymentData = isAlreadyPaid
//                               ? {
//                                   'isAlreadyPaid': true,
//                                   'paymentMethods': paymentRows
//                                       .map(
//                                         (row) => {
//                                           'method': row.method?.id,
//                                           'methodName': row.method?.name,
//                                           'reference': row.reference,
//                                           'amount': row.amount,
//                                         },
//                                       )
//                                       .toList(),
//                                   'totalPaid': paymentRows.fold(
//                                     0,
//                                     (sum, row) => sum + row.amount as int,
//                                   ),
//                                   'remainingAmount': remainingAmount,
//                                 }
//                               : {
//                                   'isAlreadyPaid': false,
//                                   'paymentMethods': [],
//                                   'totalPaid': 0,
//                                   'remainingAmount': p.total,
//                                 };

//                           p.savePurchase(
//                             productsData: productsData,
//                             depositData: depositData,
//                             context: context,
//                             onBack: widget.onBack!.call,
//                             isEdit: widget.purchase != null,
//                             total: p.grandTotal,
//                             discount: d,
//                             taxAmount: p.taxAmount,
//                             paymentData: paymentData,
//                             statusType: "draft",
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey[200],
//                           foregroundColor: Colors.grey[800],
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                         ),
//                         icon: Icon(Icons.save, size: 18),
//                         label: Text('Draft', style: TextStyle(fontSize: 14)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             16.h,
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: CustomMmTextField(
//                     onTap: () => _pickBookingDate(p),
//                     readOnly: true,
//                     labelText: 'Invoice Date',
//                     hintText: 'Invoice Date',
//                     controller: p.bookingDateController,
//                     autovalidateMode: _isLoadingDiscounts
//                         ? AutovalidateMode.disabled
//                         : AutovalidateMode.onUserInteraction,
//                     validator: (v) =>
//                         (v == null || v.isEmpty) ? 'Select Invoice date' : null,
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       CustomMmTextField(
//                         labelText: 'Supplier Name',
//                         hintText: 'Supplier Name',
//                         controller: supplierNameController,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: ValidationUtils.customerName,
//                         onChanged: (value) {
//                           setState(() {
//                             if (value.isNotEmpty) {
//                               filteredSuppliers = allSuppliers
//                                   .where(
//                                     (c) => c.supplierName
//                                         .toLowerCase()
//                                         .contains(value.toLowerCase()),
//                                   )
//                                   .toList();
//                             } else {
//                               filteredSuppliers = [];
//                             }
//                           });
//                         },
//                       ),
//                       if (filteredSuppliers.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Material(
//                             elevation: 4,
//                             borderRadius: BorderRadius.circular(8),
//                             child: Container(
//                               padding: const EdgeInsets.only(
//                                 left: 6,
//                                 right: 6,
//                                 top: 10,
//                               ),
//                               height: 150,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(color: Colors.grey.shade300),
//                               ),
//                               child: ListView.builder(
//                                 itemCount: filteredSuppliers.length,
//                                 padding: EdgeInsets.zero,
//                                 itemBuilder: (context, index) {
//                                   final c = filteredSuppliers[index];
//                                   return Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       InkWell(
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 6.0,
//                                             vertical: 8,
//                                           ),
//                                           child: Text(c.supplierName),
//                                         ),
//                                         onTap: () {
//                                           p.setCustomer(id: c.id!);
//                                           setState(() {
//                                             supplierNameController.text =
//                                                 c.supplierName;
//                                             filteredSuppliers.clear();
//                                           });
//                                         },
//                                       ),
//                                       if (index != filteredSuppliers.length - 1)
//                                         const Divider(height: 1),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 12.w,
//                 Expanded(child: _buildCreditDropdown(p)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCreditDropdown(PurchaseInvoiceProvider provider) {
//     if (creditDays == null || creditDays!.creditDays.isEmpty) {
//       return CustomSearchableDropdown(
//         hintText: 'Loading credit days...',
//         items: {},
//         value: null,
//         onChanged: (value) {},
//       );
//     }

//     final Map<String, String> creditDaysMap = {};

//     for (var days in creditDays!.creditDays) {
//       creditDaysMap[days.toString()] = '$days days';
//     }

//     return CustomSearchableDropdown(
//       key: ValueKey('credit_days_${creditDaysMap.length}'),
//       hintText: 'Select Credit Days',
//       items: creditDaysMap,
//       value: selectedCreditDays?.toString(),
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           if (mounted) {
//             setState(() {
//               selectedCreditDays = int.parse(value);
//             });
//           }
//         }
//       },
//     );
//   }

//   Widget _middleRow(BuildContext context, PurchaseInvoiceProvider p) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           SizedBox(width: 700, child: _buildBookingSummarySection(context, p)),
//         ],
//       ),
//     );
//   }

//   void close() {
//     widget.onBack;
//   }

//   double _getCurrentTotalPaid() {
//     double total = 0.0;
//     for (var row in paymentRows) {
//       total += row.amount;
//     }
//     return total;
//   }

//   bool _validatePaymentAmounts(double grandTotal) {
//     final totalPaid = _getCurrentTotalPaid();
//     return totalPaid <= grandTotal;
//   }

//   void _validateAndRecalculate(double grandTotal) {
//     if (!isMultiple) return;

//     final totalPaid = _getCurrentTotalPaid();

//     if (totalPaid > grandTotal) {
//       _adjustPaymentAmounts(grandTotal);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Total payment amount adjusted to not exceed invoice total',
//           ),
//           backgroundColor: Colors.orange,
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }

//     _calculateRemainingAmount(grandTotal);

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void _adjustPaymentAmounts(double grandTotal) {
//     final totalPaid = _getCurrentTotalPaid();
//     if (totalPaid <= grandTotal) return;

//     final ratio = grandTotal / totalPaid;

//     for (var row in paymentRows) {
//       row.amount *= ratio;
//     }
//   }

//   void _distributeAmountsEqually(double grandTotal) {
//     if (!isMultiple || paymentRows.isEmpty) return;

//     final equalAmount = grandTotal / paymentRows.length;

//     for (var i = 0; i < paymentRows.length; i++) {
//       paymentRows[i].amount = equalAmount;
//     }
//   }

//   void _initializePaymentRows(double grandTotal) {
//     if (isAlreadyPaid) {
//       if (isMultiple && paymentRows.length > 1) {
//         _distributeAmountsEqually(grandTotal);
//       } else {
//         if (paymentRows.isNotEmpty) {
//           paymentRows.first.amount = grandTotal;
//         }
//       }
//     }
//   }

//   Widget _buildPaymentRow(int index, double grandTotal) {
//     final paymentRow = paymentRows[index];

//     return StatefulBuilder(
//       builder: (context, setLocalState) {
//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: CustomSearchableDropdown(
//                   key: ValueKey(
//                     'payment_method_${index}_${paymentRows.length}',
//                   ),
//                   hintText: 'Method',
//                   items: {for (var m in PaymentMethod.methods) m.id: m.name},
//                   value: paymentRow.method?.id,
//                   onChanged: (value) {
//                     if (value.isNotEmpty) {
//                       final newMethod = PaymentMethod.methods.firstWhere(
//                         (m) => m.id == value,
//                       );

//                       setLocalState(() {
//                         paymentRow.method = newMethod;
//                       });

//                       if (value == 'multiple' && paymentRows.length == 1) {
//                         setState(() {
//                           paymentRows.add(PaymentRow());
//                           _distributeAmountsEqually(grandTotal);
//                         });
//                       } else {
//                         _debouncedCalculateRemaining(grandTotal);
//                       }
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),

//               Expanded(
//                 flex: 2,
//                 child: TextFormField(
//                   key: ValueKey('payment_ref_$index'),
//                   initialValue: paymentRow.reference,
//                   decoration: const InputDecoration(
//                     labelText: 'Reference',
//                     border: OutlineInputBorder(),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                   ),
//                   onChanged: (value) {
//                     paymentRow.reference = value;
//                   },
//                 ),
//               ),
//               const SizedBox(width: 8),

//               Expanded(
//                 flex: 1,
//                 child: TextFormField(
//                   key: ValueKey('payment_amount_$index'),
//                   initialValue: paymentRow.amount > 0
//                       ? paymentRow.amount.toStringAsFixed(2)
//                       : '',
//                   decoration: const InputDecoration(
//                     labelText: 'Amount',
//                     border: OutlineInputBorder(),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                   ),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(
//                       RegExp(r'^\d*\.?\d{0,2}'),
//                     ),
//                   ],
//                   readOnly: !isMultiple && paymentRows.length == 1,
//                   onChanged: (value) {
//                     if (value.isNotEmpty) {
//                       final newAmount = double.tryParse(value) ?? 0.0;
//                       setLocalState(() {
//                         paymentRow.amount = newAmount;
//                       });
//                     } else {
//                       setLocalState(() {
//                         paymentRow.amount = 0.0;
//                       });
//                     }
//                   },
//                   onEditingComplete: () {
//                     if (isMultiple) {
//                       _validateAndRecalculate(grandTotal);
//                     }
//                     FocusScope.of(context).unfocus();
//                   },
//                 ),
//               ),

//               if (isMultiple && paymentRows.length > 1)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.remove_circle,
//                     color: Colors.red,
//                     size: 20,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       paymentRows.removeAt(index);
//                       _distributeAmountsEqually(grandTotal);
//                     });
//                   },
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBookingSummarySection(
//     BuildContext context,
//     PurchaseInvoiceProvider p,
//   ) {
//     final double subtotal = servicesGrandTotal + productsGrandTotal;
//     p.itemsTotal = productsGrandTotal;

//     if (mounted) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           p.setServicesTotal(servicesGrandTotal);
//           p.setSubtotal(subtotal);
//         }
//       });
//     }

//     final double discountAmount = p.discountAmount;
//     final double amountAfterDiscount = subtotal - discountAmount;
//     final double taxAmount = p.getIsTaxApply
//         ? amountAfterDiscount * (p.taxPercent / 100)
//         : 0;
//     final double total = amountAfterDiscount + taxAmount;
//     p.grandTotal = total;

//     return Container(
//       margin: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Color(0xFF3B82F6),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.receipt_long_rounded, color: Colors.white, size: 18),
//                 SizedBox(width: 6),
//                 Text(
//                   'Invoice Summary',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 _buildUltraCompactCard(
//                   icon: Icons.inventory_2_outlined,
//                   title: 'Items',
//                   children: [
//                     _buildRow('Items Total', productsGrandTotal),
//                     if (p.discountAmount > 0)
//                       _buildRow(
//                         'Discount',
//                         -p.discountAmount,
//                         color: Colors.red,
//                       ),
//                     _buildDivider(),
//                     const SizedBox(height: 4),
//                     _buildRow(
//                       'Subtotal',
//                       subtotal - discountAmount,
//                       bold: true,
//                     ),
//                     SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Text(
//                                 'VAT (% 5)',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               Transform.scale(
//                                 scale: 0.9,
//                                 child: Checkbox(
//                                   activeColor: AppTheme.greenColor,
//                                   value: p.getIsTaxApply,
//                                   onChanged: (v) =>
//                                       p.setTax(v ?? false, p.taxPercent),
//                                   materialTapTargetSize:
//                                       MaterialTapTargetSize.shrinkWrap,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         _buildRow("", taxAmount, color: Colors.red),
//                       ],
//                     ),
//                     _buildDivider(),
//                     const SizedBox(height: 4),
//                     _buildRow('Total', total, bold: true),
//                     if (depositAlreadyPaid) ...[
//                       SizedBox(height: 4),
//                       _buildRow('Paid', -depositAmount, color: Colors.red),
//                       SizedBox(height: 2),
//                       _buildRow('Balance Due', remainingAmount, bold: true),
//                     ],
//                   ],
//                 ),

//                 SizedBox(height: 8),

//                 _buildUltraCompactCard(
//                   icon: Icons.local_offer_outlined,
//                   title: 'Discount',
//                   trailing: p.discountAmount > 0
//                       ? Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Color(0xFF198754),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             'OMR ${p.discountAmount.toStringAsFixed(2)} OFF',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         )
//                       : null,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             height: 40,
//                             child: CustomSearchableDropdown(
//                               key: ValueKey(
//                                 'discount_type_${selectedDiscountType.id}',
//                               ),
//                               hintText: 'Type',
//                               value: selectedDiscountType.id,
//                               items: {
//                                 for (var type in DiscountType.types)
//                                   type.id: type.name,
//                               },
//                               onChanged: (value) {
//                                 if (value.isNotEmpty) {
//                                   setState(() {
//                                     selectedDiscountType = DiscountType.types
//                                         .firstWhere(
//                                           (type) => type.id == value,
//                                           orElse: () => DiscountType.types[0],
//                                         );
//                                     discountController.clear();
//                                     p.setDiscountAmount(0);
//                                     p.setDiscountPercent(0);
//                                   });
//                                   _updateAllCalculations(p);
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 6),
//                         Expanded(
//                           flex: 2,
//                           child: SizedBox(
//                             height: 32,
//                             child: TextFormField(
//                               controller: discountController,
//                               decoration: InputDecoration(
//                                 hintText:
//                                     selectedDiscountType.id == 'percentage'
//                                     ? '%'
//                                     : 'Amount',
//                                 hintStyle: TextStyle(fontSize: 11),
//                                 prefixIcon: Icon(
//                                   selectedDiscountType.id == 'percentage'
//                                       ? Icons.percent
//                                       : Icons.attach_money,
//                                   size: 14,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 isDense: true,
//                               ),
//                               style: TextStyle(fontSize: 14),
//                               keyboardType: TextInputType.numberWithOptions(
//                                 decimal: true,
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) return null;

//                                 final discountValue = double.tryParse(value);
//                                 if (discountValue == null) {
//                                   return 'Invalid number';
//                                 }

//                                 if (selectedDiscountType.id == 'percentage') {
//                                   if (discountValue > 100) {
//                                     return 'Cannot exceed 100%';
//                                   }
//                                   if (discountValue < 0) {
//                                     return 'Cannot be negative';
//                                   }
//                                 } else if (selectedDiscountType.id ==
//                                     'amount') {
//                                   if (discountValue > subtotal) {
//                                     return 'Cannot exceed total amount';
//                                   }
//                                   if (discountValue < 0) {
//                                     return 'Cannot be negative';
//                                   }
//                                 }
//                                 return null;
//                               },
//                               onChanged: (value) {
//                                 if (value.isNotEmpty) {
//                                   final discountValue = double.tryParse(value);
//                                   if (discountValue != null) {
//                                     if (selectedDiscountType.id ==
//                                             'percentage' &&
//                                         discountValue > 100) {
//                                       discountController.text = '100';
//                                       discountController.selection =
//                                           TextSelection.collapsed(offset: 3);
//                                     } else if (selectedDiscountType.id ==
//                                             'amount' &&
//                                         discountValue > subtotal) {
//                                       discountController.text = subtotal
//                                           .toStringAsFixed(2);
//                                       discountController.selection =
//                                           TextSelection.collapsed(
//                                             offset: subtotal
//                                                 .toStringAsFixed(2)
//                                                 .length,
//                                           );
//                                     }
//                                   }
//                                 }
//                               },
//                               onEditingComplete: () =>
//                                   _applyDiscount(p, subtotal),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 6),
//                         SizedBox(
//                           height: 32,
//                           child: ElevatedButton(
//                             onPressed: () => _applyDiscount(p, subtotal),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppTheme.greenColor,
//                               padding: EdgeInsets.symmetric(horizontal: 8),
//                               minimumSize: Size(50, 32),
//                             ),
//                             child: Text(
//                               'Apply',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 _buildUltraCompactCard(
//                   icon: Icons.account_balance_wallet_outlined,
//                   title: 'Deposit',
//                   checkBoxIcon: Transform.scale(
//                     scale: 0.9,
//                     child: Checkbox(
//                       activeColor: AppTheme.greenColor,
//                       value: requireDeposit,
//                       onChanged: (value) {
//                         if (mounted) {
//                           setState(() {
//                             requireDeposit = value ?? false;
//                             if (!requireDeposit) {
//                               depositAlreadyPaid = false;
//                               depositAmount = 0;
//                               depositPercentage = 0;
//                               depositAmountController.clear();
//                             }
//                             _updateAllCalculations(p);
//                           });
//                         }
//                       },
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                   ),
//                   trailing: requireDeposit && depositAmount > 0
//                       ? Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             'OMR ${depositAmount.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         )
//                       : null,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Require Deposit', style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                     if (requireDeposit) ...[
//                       SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: SizedBox(
//                               height: 40,
//                               child: CustomSearchableDropdown(
//                                 key: ValueKey(
//                                   'deposit_type_${selectedDepositType.id}',
//                                 ),
//                                 hintText: 'Type',
//                                 value: selectedDepositType.id,
//                                 items: {
//                                   for (var type in DepositType.types)
//                                     type.id: type.name,
//                                 },
//                                 onChanged: (value) {
//                                   if (value.isNotEmpty) {
//                                     if (mounted) {
//                                       setState(() {
//                                         selectedDepositType = DepositType.types
//                                             .firstWhere(
//                                               (type) => type.id == value,
//                                               orElse: () =>
//                                                   DepositType.types[0],
//                                             );
//                                         if (selectedDepositType.id ==
//                                             'percentage') {
//                                           depositAmountController.text =
//                                               depositPercentage.toString();
//                                         } else {
//                                           depositAmountController.text =
//                                               depositAmount.toStringAsFixed(2);
//                                         }
//                                       });
//                                     }
//                                   }
//                                   _updateAllCalculations(p);
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 6),
//                           Expanded(
//                             flex: 2,
//                             child: SizedBox(
//                               height: 45,
//                               child: CustomMmTextField(
//                                 controller: depositAmountController,
//                                 hintText: selectedDepositType.id == 'percentage'
//                                     ? '%'
//                                     : 'Amount',
//                                 keyboardType: TextInputType.numberWithOptions(
//                                   decimal: true,
//                                 ),
//                                 onChanged: (value) {
//                                   final val = double.tryParse(value) ?? 0;
//                                   if (selectedDepositType.id == 'percentage') {
//                                     depositPercentage = val;
//                                   } else {
//                                     depositAmount = val;
//                                   }
//                                   _updateAllCalculations(p);
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text('Already Paid?', style: TextStyle(fontSize: 14)),
//                           const SizedBox(width: 5),
//                           Transform.scale(
//                             scale: 0.9,
//                             child: Checkbox(
//                               activeColor: AppTheme.greenColor,
//                               value: isAlreadyPaid,
//                               onChanged: (value) {
//                                 final newValue = value ?? false;

//                                 WidgetsBinding.instance.addPostFrameCallback((
//                                   _,
//                                 ) {
//                                   if (mounted) {
//                                     setState(() {
//                                       isAlreadyPaid = newValue;

//                                       if (!isAlreadyPaid) {
//                                         paymentRows = [PaymentRow()];
//                                         paymentRows.first.method = PaymentMethod
//                                             .methods
//                                             .firstWhere((m) => m.id == 'cash');
//                                         paymentRows.first.amount = total;
//                                       } else {
//                                         _initializePaymentRows(total);
//                                         depositAmount = 0;
//                                         depositAlreadyPaid = false;
//                                         requireDeposit = false;
//                                         depositAmountController.clear();
//                                         depositPercentage = 0;
//                                       }

//                                       _calculateRemainingAmount(total);
//                                     });
//                                   }
//                                 });
//                               },
//                               materialTapTargetSize:
//                                   MaterialTapTargetSize.shrinkWrap,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Text(
//                             'Multiple Methods?',
//                             style: TextStyle(fontSize: 14),
//                           ),
//                           const SizedBox(width: 5),
//                           Transform.scale(
//                             scale: 0.9,
//                             child: Checkbox(
//                               activeColor: AppTheme.greenColor,
//                               value: isMultiple,
//                               onChanged: (value) {
//                                 if (!isAlreadyPaid) {
//                                   return;
//                                 }

//                                 final newValue = value ?? false;

//                                 WidgetsBinding.instance.addPostFrameCallback((
//                                   _,
//                                 ) {
//                                   if (mounted) {
//                                     setState(() {
//                                       isMultiple = newValue;
//                                       _calculateRemainingAmount(total);
//                                     });
//                                   }
//                                 });
//                               },
//                               materialTapTargetSize:
//                                   MaterialTapTargetSize.shrinkWrap,
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (!depositAlreadyPaid)
//                         Container(
//                           margin: EdgeInsets.only(top: 2),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.orange.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Next Payment:',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.orange.shade700,
//                                 ),
//                               ),
//                               Text(
//                                 'OMR ${depositAmount.toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.orange.shade700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 _buildUltraCompactCard(
//                   icon: Icons.payment,
//                   title: 'Payment',
//                   children: [
//                     if (depositAlreadyPaid && requireDeposit)
//                       _buildRow(
//                         'Balance Due',
//                         nextPaymentAmount,
//                         color: Colors.red,
//                         bold: true,
//                       ),
//                     Row(
//                       children: [
//                         Text('Already Paid?', style: TextStyle(fontSize: 14)),
//                         const SizedBox(width: 5),
//                         Transform.scale(
//                           scale: 0.9,
//                           child: Checkbox(
//                             activeColor: AppTheme.greenColor,
//                             value: isAlreadyPaid,
//                             onChanged: (value) {
//                               final newValue = value ?? false;

//                               WidgetsBinding.instance.addPostFrameCallback((_) {
//                                 if (mounted) {
//                                   setState(() {
//                                     isAlreadyPaid = newValue;

//                                     if (!isAlreadyPaid) {
//                                       paymentRows = [PaymentRow()];
//                                       paymentRows.first.method = PaymentMethod
//                                           .methods
//                                           .firstWhere((m) => m.id == 'cash');
//                                       paymentRows.first.amount = total;
//                                     } else {
//                                       depositAmount = 0;
//                                       depositAlreadyPaid = false;
//                                       requireDeposit = false;
//                                       depositAmountController.clear();
//                                       depositPercentage = 0;
//                                     }

//                                     _calculateRemainingAmount(total);
//                                   });
//                                 }
//                               });
//                             },
//                             materialTapTargetSize:
//                                 MaterialTapTargetSize.shrinkWrap,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           'Multiple Methods?',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         const SizedBox(width: 5),
//                         Transform.scale(
//                           scale: 0.9,
//                           child: Checkbox(
//                             activeColor: AppTheme.greenColor,
//                             value: isMultiple,
//                             onChanged: (value) {
//                               if (!isAlreadyPaid) {
//                                 return;
//                               }

//                               final newValue = value ?? false;

//                               WidgetsBinding.instance.addPostFrameCallback((_) {
//                                 if (mounted) {
//                                   setState(() {
//                                     isMultiple = newValue;

//                                     if (isMultiple && paymentRows.length == 1) {
//                                       paymentRows.add(PaymentRow());
//                                       _distributeAmountsEqually(total);
//                                     } else if (!isMultiple &&
//                                         paymentRows.length > 1) {
//                                       paymentRows = [paymentRows.first];
//                                       paymentRows.first.amount = total;
//                                     }

//                                     _calculateRemainingAmount(total);
//                                   });
//                                 }
//                               });
//                             },
//                             materialTapTargetSize:
//                                 MaterialTapTargetSize.shrinkWrap,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (isAlreadyPaid) ...[
//                       const SizedBox(height: 8),
//                       ...paymentRows.asMap().entries.map((entry) {
//                         return _buildPaymentRow(entry.key, total);
//                       }).toList(),
//                     ],
//                     if (isMultiple && isAlreadyPaid) ...[
//                       const SizedBox(height: 8),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             if (paymentRows.length >= 10) return;
//                             paymentRows.add(PaymentRow());
//                             if (mounted) setState(() {});
//                           },
//                           icon: const Icon(Icons.add, size: 16),
//                           label: const Text('Add Payment Method'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppTheme.greenColor,
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                     const SizedBox(height: 12),
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: remainingAmount > 0
//                             ? Colors.orange.withOpacity(0.1)
//                             : Colors.green.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Total Paid:',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                               Text(
//                                 '${_getCurrentTotalPaid().toStringAsFixed(2)} OMR',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Remaining Balance:',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: remainingAmount > 0
//                                       ? Colors.orange
//                                       : Colors.green,
//                                 ),
//                               ),
//                               Text(
//                                 '${remainingAmount.toStringAsFixed(2)} OMR',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: remainingAmount > 0
//                                       ? Colors.orange
//                                       : Colors.green,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (!_validatePaymentAmounts(total) && isAlreadyPaid)
//                       Container(
//                         margin: EdgeInsets.only(top: 8),
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.red.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.warning, size: 16, color: Colors.red),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'Total payment amount exceeds invoice total by ${(_getCurrentTotalPaid() - total).toStringAsFixed(2)} OMR',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 _buildUltraCompactCard(
//                   icon: Icons.attach_file_sharp,
//                   title: 'Attachment',
//                   children: [
//                     DialogueBoxPicker(
//                       showOldRow: false,
//                       uploadDocument: true,
//                       onFilesPicked: (List<AttachmentModel> files) {
//                         setState(() {
//                           displayPicture = files;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 40,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (!_validatePaymentAmounts(total)) {
//                         return;
//                       }
//                       setState(() {
//                         p.orderLoading = true;
//                       });
//                       double d = double.tryParse(discountController.text) ?? 0;
//                       List<Map<String, dynamic>> productsData = [];
//                       try {
//                         productsData = Constants.buildProductsData(productRows);
//                         if (productsData.isEmpty) {
//                           Constants.showValidationError(
//                             context,
//                             "Items cannot be empty",
//                           );
//                           setState(() {
//                             p.orderLoading = false;
//                           });
//                           return;
//                         }
//                       } catch (e) {
//                         setState(() {
//                           p.orderLoading = false;
//                         });
//                         Constants.showValidationError(context, e);
//                         return;
//                       }
//                       final depositData = {
//                         'requireDeposit': requireDeposit,
//                         'depositType': selectedDepositType.id,
//                         'depositAmount': depositAmount,
//                         'depositPercentage': depositPercentage,
//                         'nextPaymentAmount': nextPaymentAmount,
//                       };

//                       final paymentData = isAlreadyPaid
//                           ? {
//                               'isAlreadyPaid': true,
//                               'paymentMethods': paymentRows
//                                   .map(
//                                     (row) => {
//                                       'method': row.method?.id,
//                                       'methodName': row.method?.name,
//                                       'reference': row.reference,
//                                       'amount': row.amount,
//                                     },
//                                   )
//                                   .toList(),
//                               'totalPaid': paymentRows.fold(
//                                 0.0,
//                                 (sum, row) => sum + (row.amount ?? 0.0),
//                               ),
//                               'remainingAmount': remainingAmount,
//                             }
//                           : {
//                               'isAlreadyPaid': false,
//                               'paymentMethods': [],
//                               'totalPaid': 0,
//                               'remainingAmount': total,
//                             };

//                       // p.saveBooking(
//                       //   productsData: productsData,
//                       //   depositData: depositData,
//                       //   context: context,
//                       //   onBack: widget.onBack!.call,
//                       //   isEdit: widget.purchase != null,
//                       //   total: total,
//                       //   discount: d,
//                       //   taxAmount: taxAmount,
//                       //   paymentData: paymentData,
//                       //   sale: widget.purchase,
//                       //   statusType: "pending",
//                       // );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primaryColor,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: p.loading.value
//                         ? SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 widget.purchase != null
//                                     ? Icons.update_rounded
//                                     : Icons.add_circle_outline_rounded,
//                                 size: 16,
//                               ),
//                               SizedBox(width: 6),
//                               Text(
//                                 widget.purchase != null
//                                     ? 'Update Invoice'
//                                     : 'Create Invoice',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUltraCompactCard({
//     required IconData icon,
//     required String title,
//     required List<Widget> children,
//     Widget? checkBoxIcon,
//     Widget? trailing,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Color(0xFFF8F9FA),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: Color(0xFFE9ECEF), width: 0.5),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 14, color: Color(0xFF495057)),
//               SizedBox(width: 4),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF212529),
//                 ),
//               ),
//               if (checkBoxIcon != null) ...[SizedBox(width: 4), checkBoxIcon],
//               if (trailing != null) ...[Spacer(), trailing],
//             ],
//           ),
//           SizedBox(height: 6),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildRow(
//     String label,
//     double amount, {
//     Color? color,
//     bool bold = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 1),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
//               color: color ?? Color(0xFF495057),
//             ),
//           ),
//           Text(
//             '${amount.toStringAsFixed(2)} OMR',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
//               color: color ?? Color(0xFF212529),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 4),
//       height: 0.5,
//       color: Color(0xFFDEE2E6),
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
//   final FocusNode _priceFocusNode = FocusNode();
//   final FocusNode _qtyFocusNode = FocusNode();
//   double _originalPrice = 0;
//   Timer? _updateTimer;
//   List<String> serviceCostList = ["Freight", "Handling", "Bundle", "Other"];

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
//   }

//   void _onPriceFocusChange() {
//     if (!_priceFocusNode.hasFocus) {
//       _validateAndUpdatePrice();
//     }
//   }

//   void _validateAndUpdatePrice() {
//     final newPrice = double.tryParse(_priceController.text) ?? 0;
//     final minimumPrice = widget.productRow.purchaseItem?.minimumPrice ?? 0;
//     final sellingPrice = widget.productRow.purchaseItem?.sellingPrice ?? 0;

//     debugPrint(
//       'Validating price - New: $newPrice, Min: $minimumPrice, Selling: $sellingPrice',
//     );

//     if (newPrice < minimumPrice) {
//       debugPrint('Price below minimum - resetting to selling price');
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

//   void _updateProductWithDebounce() {
//     widget.productRow.calculateTotals();

//     _updateTimer?.cancel();
//     _updateTimer = Timer(const Duration(milliseconds: 500), () {
//       widget.onUpdate(widget.productRow);
//     });
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

//   Widget _buildServiceDropdown() {
//     final Map<String, String> itemMap = {};
//     for (var item in serviceCostList) {
//       String displayName = item;
//       // if (item.type == 'service') {
//       //   displayName = '⚡ $displayName (Service)';
//       // } else {
//       //   displayName = '📦 $displayName (Product)';
//       // }
//       itemMap[item] = displayName;
//     }

//     return CustomSearchableDropdown(
//       key: widget.productRow.serviceCostKey,
//       hintText: 'Select Service Cost',
//       items: itemMap,
//       value: widget.productRow.serviceType,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final selected = serviceCostList.firstWhere((item) => item == value);
//           if (mounted) {
//             setState(() {
//               widget.productRow.serviceType = selected;
//               widget.productRow.serviceType = selected;

//               // widget.productRow.cost = selected.cost;
//               // widget.productRow.margin = selected.cost > 0
//               //     ? ((selected.sellingPrice - selected.cost) /
//               //               selected.cost) *
//               //           100
//               //     : 0;
//               // _originalPrice = selected.sellingPrice;
//               // widget.productRow.calculateTotals();
//               // widget.onUpdate(widget.productRow);
//               //FocusScope.of(context).requestFocus(_qtyFocusNode);
//             });
//           }
//         }
//       },
//     );
//   }

//   Widget _buildServiceInput() {
//     return TextFormField(
//       key: widget.productRow.priceKey,
//       controller: _serviceCostController,
//       //focusNode: _priceFocusNode,
//       enabled: true,
//       decoration: InputDecoration(
//         labelText: 'Service Cost (OMR)',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       textInputAction: TextInputAction.next,
//       // onChanged: (value) {
//       //   if (value.isNotEmpty) {
//       //     final newPrice = double.tryParse(value) ?? 0;
//       //     final minimumPrice = widget.productRow.saleItem?.minimumPrice ?? 0;
//       //     if (newPrice >= minimumPrice) {
//       //       _updatePriceInModel(newPrice);
//       //     }
//       //   }
//       // },
//       onEditingComplete: () {
//         // _validateAndUpdatePrice();
//         // FocusScope.of(context).requestFocus(_qtyFocusNode);
//       },
//       onFieldSubmitted: (value) {
//         //  _validateAndUpdatePrice();
//       },
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
//           if (newPrice >= minimumPrice) {
//             _updatePriceInModel(newPrice);
//           }
//         }
//       },
//       onEditingComplete: () {
//         _validateAndUpdatePrice();
//         FocusScope.of(context).requestFocus(_qtyFocusNode);
//       },
//       onFieldSubmitted: (value) {
//         _validateAndUpdatePrice();
//       },
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
//       validator: (value) {
//         debugPrint('Validator called with value: $value');
//         final error = ValidationUtils.quantity(value);
//         debugPrint('Validation error: $error');
//         return error;
//       },
//       keyboardType: TextInputType.number,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final quantity = int.tryParse(value) ?? 0;
//           if (quantity == 0) {
//             _qtyController.text = "1";
//             widget.productRow.quantity = 1;
//           }

//           if (quantity > 0 && quantity <= 999999) {
//             if (mounted) {
//               setState(() {
//                 widget.productRow.quantity = quantity;
//                 widget.productRow.calculateTotals();
//                 _updateProductWithDebounce();
//               });
//             }
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

//         if (quantity < 1) {
//           if (mounted) {
//             setState(() {
//               widget.productRow.quantity = 1;
//               _qtyController.text = '1';
//               widget.productRow.calculateTotals();
//               widget.onUpdate(widget.productRow);
//             });
//           }
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
//       validator: (value) {
//         debugPrint('Validator called with value: $value');
//         final error = ValidationUtils.discount(value);
//         debugPrint('Validation error: $error');
//         return error;
//       },
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           final discount = double.tryParse(value) ?? 0;
//           if (mounted) {
//             setState(() {
//               widget.productRow.discount = discount;
//               widget.productRow.calculateTotals();
//               _updateProductWithDebounce();
//             });
//           }
//         }
//       },
//       onEditingComplete: () {
//         FocusScope.of(context).unfocus();
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
//     if (oldWidget.productRow != widget.productRow) {
//       _initializeControllers();
//     }
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
//           Expanded(flex: 1, child: _buildServiceInput()),
//           const SizedBox(width: 8),
//           Expanded(flex: 1, child: _buildServiceDropdown()),
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

// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
import 'package:modern_motors_panel/model/sales_model/credit_days_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/model/supplier/supplier_model.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
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
  bool includeInProductCost = true;

  BillExpense({
    this.type,
    this.supplier,
    this.amount = 0,
    this.description = '',
    this.includeInProductCost = true,
  });
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
  }) {
    dropdownKey = UniqueKey();
    priceKey = UniqueKey();
    quantityKey = UniqueKey();
    discountKey = UniqueKey();
    serviceCostKey = UniqueKey();
    serviceTypeKey = UniqueKey();
  }

  void calculateTotals() {
    // Calculate subtotal
    subtotal = (avgPrice ?? selectedPrice ?? 0) * quantity;

    // Apply discount based on type
    double discountAmount = 0.0;
    if (discountType == 'percentage') {
      discountAmount = subtotal * (discount / 100);
    } else {
      discountAmount = discount; // Fixed amount
    }

    double amountAfterDiscount = subtotal - discountAmount;

    // Calculate VAT
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

    // Calculate total
    total = amountAfterDiscount + serviceCost + vatAmount;
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
        DataFetchService.fetchProducts(),
        DataFetchService.getCreditDays(),
      ]);
      allSuppliers = results[0] as List<SupplierModel>;
      allProducts = results[1] as List<ProductModel>;
      creditDays = results[2] as CreditDaysModel;
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
                avgPrice: element.cost,
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
      purchaseItem = mergeProductsAndServices(allProducts, allServices);
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

  double _getSubtotalForDiscount() {
    return productsGrandTotal + billExpensesTotal;
  }

  double _calculateTotal(PurchaseInvoiceProvider p) {
    final double subtotal = _getSubtotalForDiscount() + billExpensesTotal;
    final double discountAmount = p.discountAmount;
    final double amountAfterDiscount = subtotal - discountAmount;
    final double taxAmount = p.getIsTaxApply
        ? amountAfterDiscount * (p.taxPercent / 100)
        : 0;
    return amountAfterDiscount + taxAmount;
  }

  List<PurchaseItem> mergeProductsAndServices(
    List<ProductModel> products,
    List<ServiceTypeModel> services,
  ) {
    List<PurchaseItem> mergedList = [];

    mergedList.addAll(
      products.map(
        (product) => PurchaseItem(
          discount: 0,
          margin: 0,
          minimumPrice: product.minimumPrice ?? 0,
          productId: product.id ?? '',
          productName: product.productName ?? '',
          quantity: 1,
          sellingPrice: product.averageCost ?? product.lastCost ?? 0,
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

        return PurchaseItem(
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
    billExpensesTotal = billExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
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

  void _updateAllCalculations(PurchaseInvoiceProvider p) {
    if (!mounted) return;
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
            // const Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: Text(
            //         'Item',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: Text(
            //         'Price',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: Text(
            //         'Qty',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: Text(
            //         'Discount',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     // Expanded(
            //     //   flex: 1,
            //     //   child: Text(
            //     //     'Product Expense',
            //     //     style: TextStyle(fontWeight: FontWeight.bold),
            //     //   ),
            //     // ),
            //     // Expanded(
            //     //   flex: 1,
            //     //   child: Text(
            //     //     'Expense Type',
            //     //     style: TextStyle(fontWeight: FontWeight.bold),
            //     //   ),
            //     // ),
            //     Expanded(
            //       flex: 1,
            //       child: Text(
            //         'Subtotal',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: Text(
            //         'VAT',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: Text(
            //         'Total',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     SizedBox(width: 40),
            //   ],
            // ),
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
                Row(
                  children: [
                    Text(
                      'Include in Product Cost',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Transform.scale(
                      scale: 0.9,
                      child: Checkbox(
                        activeColor: AppTheme.greenColor,
                        value: includeExpensesInProductCost,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              includeExpensesInProductCost = value ?? true;
                            });
                          }
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Expense Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Supplier',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Amount',
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
              itemCount: billExpenses.length,
              itemBuilder: (context, index) {
                return BillExpenseRowWidget(
                  supplierList: allSuppliers,
                  expense: billExpenses[index],
                  index: index,
                  onUpdate: (updatedExpense) =>
                      _updateBillExpense(index, updatedExpense, p),
                  onRemove: () => _removeBillExpense(index, p),
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
                      subTitle: 'Create New Purchase Invoice',
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
                          final NewPurchaseModel saleDetails =
                              Constants.parseToPurchaseModel(
                                productsData: productsData,
                                // expensesData: expensesData,
                                depositData: depositData,
                                paymentData: paymentData,
                                totalRevenue: p.total,
                                discount: d,
                                taxAmount: p.taxAmount,
                                supplierId: p.supplierId!,
                                isEdit: false,
                              );
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
                            onBack: widget.onBack!.call,
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

  List<Map<String, dynamic>> _buildProductsData() {
    return productRows.map((row) {
      return {
        'type': row.purchaseItem?.type,
        'productId': row.purchaseItem?.productId,
        'productName': row.purchaseItem?.productName,
        'avgPrice': row.avgPrice,
        'quantity': row.quantity,
        'discount': row.discount,
        'applyVat': row.applyVat,
        'subtotal': row.subtotal,
        'vatAmount': row.vatAmount,
        'total': row.total,
        'profit': row.profit,
        'cost': row.cost,
        'serviceCost': row.serviceCost,
        'serviceType': row.serviceType,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _buildExpensesData() {
    return billExpenses.map((expense) {
      return {
        'type': expense.type?.id,
        'typeName': expense.type?.name,
        'amount': expense.amount,
        'description': expense.description,
        'includeInProductCost': expense.includeInProductCost,
      };
    }).toList();
  }

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

  Widget _buildBookingSummarySection(
    BuildContext context,
    PurchaseInvoiceProvider p,
  ) {
    final double subtotal = _getSubtotalForDiscount();
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
                    _buildRow('Products Total', productsGrandTotal),
                    if (billExpensesTotal > 0)
                      _buildRow('Bill Expenses', billExpensesTotal),
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
                    onPressed: () {
                      if (!_validatePaymentAmounts(total)) return;
                      setState(() => p.orderLoading = true);
                      double d = double.tryParse(discountController.text) ?? 0;
                      List<Map<String, dynamic>> productsData =
                          _buildProductsData();
                      List<Map<String, dynamic>> expensesData =
                          _buildExpensesData();
                      try {
                        if (productsData.isEmpty) {
                          Constants.showValidationError(
                            context,
                            "Items cannot be empty",
                          );
                          setState(() => p.orderLoading = false);
                          return;
                        }
                      } catch (e) {
                        setState(() => p.orderLoading = false);
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
                              'remainingAmount': remainingAmount,
                            }
                          : {
                              'isAlreadyPaid': false,
                              'paymentMethods': [],
                              'totalPaid': 0,
                              'remainingAmount': total,
                            };

                      p.savePurchase(
                        productsData: productsData,
                        expensesData: expensesData,
                        depositData: depositData,
                        context: context,
                        onBack: widget.onBack!.call,
                        isEdit: widget.purchase != null,
                        total: total,
                        discount: d,
                        taxAmount: taxAmount,
                        paymentData: paymentData,
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
  const ProductRowWidget({
    super.key,
    required this.productRow,
    required this.allItems,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.showRemoveButton,
    required this.supplierList,
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

  void _updateServiceCostInModel(double serviceCost) {
    widget.productRow.serviceCost = serviceCost;
    widget.productRow.calculateTotals();
    _updateProductWithDebounce();
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

  void _updateProductWithDebounce() {
    widget.productRow.calculateTotals();
    _updateTimer?.cancel();
    _updateTimer = Timer(
      const Duration(milliseconds: 500),
      () => widget.onUpdate(widget.productRow),
    );
  }

  // void _showMinimumPriceError(double minimumPrice) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Price cannot be less than minimum price: OMR ${minimumPrice.toStringAsFixed(2)}',
  //       ),
  //       backgroundColor: Colors.red,
  //       duration: Duration(seconds: 3),
  //     ),
  //   );
  // }

  @override
  void didUpdateWidget(ProductRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productRow != widget.productRow) _initializeControllers();
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
      if (item.type == 'service') {
        displayName = '⚡ $displayName';
      } else {
        displayName = '📦 $displayName';
      }
      itemMap[item.productId] = displayName;
    }
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: widget.productRow.purchaseItem?.productId,
          hint: Text(
            'Select Item',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          items: itemMap.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(
                entry.value,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null && value.isNotEmpty) {
              final selected = widget.allItems.firstWhere(
                (item) => item.productId == value,
              );
              if (mounted) {
                setState(() {
                  widget.productRow.purchaseItem = selected;
                  widget.productRow.type = selected.type;
                  widget.productRow.avgPrice = selected.sellingPrice;
                  _priceController.text = selected.sellingPrice.toStringAsFixed(
                    2,
                  );
                  widget.productRow.cost = selected.cost;
                  widget.productRow.margin = selected.cost > 0
                      ? ((selected.sellingPrice - selected.cost) /
                                selected.cost) *
                            100
                      : 0;
                  _originalPrice = selected.sellingPrice;
                  widget.productRow.calculateTotals();
                  widget.onUpdate(widget.productRow);
                  FocusScope.of(context).requestFocus(_qtyFocusNode);
                });
              }
            }
          },
        ),
      ),
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
    required String hint,
    required Function(String) onChanged,
    double? width,
  }) {
    return Container(
      width: width,
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          items: items.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(
                entry.value,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }

  bool _addToPurchaseCost = false;
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
                  header: 'PRICE',
                  flex: 2,
                  child: _buildTextField(
                    controller: _priceController,
                    focusNode: _priceFocusNode,
                    hint: '0.00',
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final newPrice = double.tryParse(value) ?? 0;
                        final minimumPrice =
                            widget.productRow.purchaseItem?.minimumPrice ?? 0;
                        if (newPrice >= minimumPrice) {
                          _updatePriceInModel(newPrice);
                        }
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
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _updateServiceCostInModel(
                                double.tryParse(value) ?? 0,
                              );
                            }
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
                              hint: 'Select Type',
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
                              hint: 'Select Supplier',
                              onChanged: _updateSupplierInModel,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Add to Purchase Cost Checkbox
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
  const BillExpenseRowWidget({
    super.key,
    required this.expense,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.supplierList,
  });

  @override
  State<BillExpenseRowWidget> createState() => _BillExpenseRowWidgetState();
}

class _BillExpenseRowWidgetState extends State<BillExpenseRowWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _updateTimer?.cancel();
    super.dispose();
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
    _updateExpenseWithDebounce(); // Add this line
  }

  Widget _buildExpenseTypeDropdown() {
    final Map<String, String> expenseTypes = {};
    for (var type in ExpenseType.types) {
      expenseTypes[type.id] = type.name;
    }
    return CustomSearchableDropdown(
      hintText: 'Expense Type',
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
    );
  }

  Widget _buildSupplierTypeDropdown() {
    final Map<String, String> suppliers = {};
    for (var supplier in widget.supplierList) {
      suppliers[supplier.id!] = supplier.supplierName;
    }

    return CustomSearchableDropdown(
      hintText: 'Select Supplier',
      items: suppliers,
      value: widget.expense.supplier?.id, // Fixed: was widget.expense.type?.id
      onChanged: (value) {
        if (value.isNotEmpty) {
          final selectedSupplier = widget.supplierList.firstWhere(
            (supplier) => supplier.id == value,
          );
          _updateSupplier(selectedSupplier);
        } else {
          _updateSupplier(null); // Handle clear selection
        }
      },
    );
  }

  Widget _buildAmountInput() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: 'Amount',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        if (value.isNotEmpty) _updateAmount(double.tryParse(value) ?? 0);
      },
    );
  }

  @override
  void didUpdateWidget(BillExpenseRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expense != widget.expense) _initializeControllers();
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
          Expanded(flex: 2, child: _buildExpenseTypeDropdown()),
          const SizedBox(width: 8),
          Expanded(flex: 1, child: _buildAmountInput()),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: _buildSupplierTypeDropdown()),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red, size: 20),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
