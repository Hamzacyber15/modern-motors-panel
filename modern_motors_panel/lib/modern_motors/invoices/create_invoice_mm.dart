// import 'dart:math';

// import 'package:app/app_theme.dart';
// import 'package:app/models/discount_model.dart';
// import 'package:app/models/invoice/invoice_mm_model.dart';
// import 'package:app/modern_motors/models/customer/customer_model.dart';
// import 'package:app/modern_motors/models/inventory/inventory_model.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/products/build_product_list_screen.dart';
// import 'package:app/modern_motors/provider/selected_inventories_provider.dart';
// import 'package:app/modern_motors/services/data_fetch_service.dart';
// import 'package:app/modern_motors/widgets/buttons/custom_button.dart';
// import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:app/modern_motors/widgets/discounts/discount_selector.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/form_validation.dart';
// import 'package:app/modern_motors/widgets/inventory_selection_bridge.dart';
// import 'package:app/modern_motors/widgets/invoices/order_summary_details.dart';
// import 'package:app/modern_motors/widgets/page_header_widget.dart';
// import 'package:app/modern_motors/widgets/selected_items_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CreateInvoiceMm extends StatefulWidget {
//   final VoidCallback? onBack;
//   final InvoiceMmModel? invoiceModel;
//   final List<InventoryModel>? selectedInventory;
//   final List<ProductModel>? products;

//   const CreateInvoiceMm({
//     super.key,
//     this.onBack,
//     this.invoiceModel,
//     this.products,
//     this.selectedInventory,
//   });

//   @override
//   CreateInvoiceMmPageState createState() => CreateInvoiceMmPageState();
// }

// class CreateInvoiceMmPageState extends State<CreateInvoiceMm> {
//   final customerNameController = TextEditingController();
//   List<CustomerModel> allCustomers = [];
//   List<CustomerModel> filteredCustomers = [];
//   List<DiscountModel> _discounts = [];
//   bool creditPayment = false;
//   bool _isLoadingDiscounts = true;
//   int currentPage = 0;
//   int itemsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       final provider = context.read<SelectedInventoriesProvider>();
//       provider.clearData();
//       if (widget.selectedInventory != null &&
//           widget.selectedInventory!.isNotEmpty) {
//         final provider = Provider.of<SelectedInventoriesProvider>(
//           context,
//           listen: false,
//         );
//         provider.addAllInventory(
//           widget.selectedInventory ?? [],
//           widget.products ?? [],
//         );
//         provider.setInvoice(widget.invoiceModel!);
//         debugPrint('widget.invoiceModel:${widget.invoiceModel!.id}');
//       }
//     });
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     customerNameController.dispose();
//     final provider = context.read<SelectedInventoriesProvider>();
//     provider.clearData();
//     super.dispose();
//   }

//   void _loadInitialData() async {
//     setState(() {
//       _isLoadingDiscounts = true;
//     });
//     try {
//       Future.wait([
//         DataFetchService.fetchDiscount(),
//         DataFetchService.fetchCustomers(),
//       ]).then((results) {
//         setState(() {
//           _discounts = results[0] as List<DiscountModel>;
//           allCustomers = results[1] as List<CustomerModel>;
//           _isLoadingDiscounts = false;
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             if (widget.invoiceModel != null) {
//               final provider = Provider.of<SelectedInventoriesProvider>(
//                 context,
//                 listen: false,
//               );

//               //
//               // debugPrint('invoice.customerId: ${invoice.customerId}');
//               // debugPrint('invoice.discountId: ${invoice.discountId}');
//               // for (final customer in allCustomers) {
//               //   debugPrint('customer: ${customer.toIndividualMap()}');
//               // }

//               final selectedCustomer = allCustomers.firstWhere(
//                 (c) => c.id == widget.invoiceModel!.customerId,
//               );
//               customerNameController.text = selectedCustomer.customerName;
//               debugPrint(
//                 'customerNameController.text:${customerNameController.text}',
//               );
//               debugPrint(
//                 'widget.invoiceModel!.discountId: ${widget.invoiceModel!.discountId}',
//               );
//               final foundDiscount = _discounts.firstWhere(
//                 (d) => d.id == widget.invoiceModel!.discountId,
//               );
//               provider.setDiscount(
//                 widget.invoiceModel!.isDiscountApplied!,
//                 foundDiscount,
//                 isEdit: true,
//                 percent: widget.invoiceModel!.discountPercent!.toDouble(),
//               );
//             }
//           });
//         });
//       });
//     } catch (e) {
//       setState(() {
//         _isLoadingDiscounts = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load data: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       color: AppTheme.backgroundGreyColor,
//       child: Consumer<SelectedInventoriesProvider>(
//         builder: (context, provider, child) {
//           return provider.isItemsSelection
//               // ? SelectItemsPage(provider: provider)
//               ? SelectItemsPage(bridge: bridgeFromInvoice(provider))
//               : SingleChildScrollView(
//                   child: screenWidth < 800
//                       ? _buildMobileLayout(context, provider)
//                       : _buildDesktopLayout(context, provider),
//                 );
//         },
//       ),
//     );
//   }

//   Widget _buildDesktopLayout(context, SelectedInventoriesProvider provider) {
//     return Form(
//       key: provider.createInvoiceKey,
//       child: Column(
//         children: [
//           PageHeaderWidget(
//             title: 'Create Invoice',
//             buttonText: 'Back to Invoices',
//             subTitle: 'Create New Invoice',
//             onCreateIcon: 'assets/icons/back.png',
//             selectedItems: [],
//             buttonWidth: 0.4,
//             onCreate: widget.onBack!.call,
//             onDelete: () async {},
//           ),
//           20.h,
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Container(
//               padding: EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppTheme.borderColor),
//                 color: AppTheme.whiteColor,
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       // Expanded(
//                       //   child: CustomMmTextField(
//                       //     labelText: 'Invoice Number',
//                       //     hintText: 'Invoice Number',
//                       //     controller: provider.generateInvoiceNumberController,
//                       //     icon: Icons.generating_tokens,
//                       //     readOnly: true,
//                       //     autovalidateMode: AutovalidateMode.onUserInteraction,
//                       //     validator: ValidationUtils.invoiceNumber,
//                       //     onIcon: () {
//                       //       final random = Random();
//                       //       final random5Digit = 10000 + random.nextInt(90000);
//                       //       provider.generateInvoiceNumberController.text =
//                       //           random5Digit.toString();
//                       //     },
//                       //     onChanged: (value) {
//                       //       setState(() {
//                       //         if (value.isNotEmpty) {
//                       //           filteredCustomers = allCustomers
//                       //               .where(
//                       //                 (customer) => customer.customerName
//                       //                     .toLowerCase()
//                       //                     .contains(value.toLowerCase()),
//                       //               )
//                       //               .toList();
//                       //         } else {
//                       //           filteredCustomers = [];
//                       //         }
//                       //       });
//                       //     },
//                       //   ),
//                       // ),

//                       Expanded(
//                         child: CustomMmTextField(
//                           onTap: () {
//                             provider.pickDate(
//                               context: context,
//                               selectedDate: provider.invoiceDate,
//                               type: 'invoice',
//                             );
//                           },
//                           readOnly: true,
//                           labelText: 'Invoice Date',
//                           hintText: 'Invoice Date',
//                           controller: provider.invoiceDateController,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: ValidationUtils.invoiceDate,
//                         ),
//                       ),
//                       12.w,
//                       // SizedBox(
//                       //   width: 80,
//                       //   child: SwitchListTile(
//                       //       title: Text("Credit Payment"),
//                       //       value: creditPayment,
//                       //       onChanged: (value) {
//                       //         setState(() {
//                       //           creditPayment != creditPayment;
//                       //         });
//                       //       }),
//                       // ),
//                     ],
//                   ),
//                   10.h,
//                   Row(
//                     children: [
//                       // Expanded(
//                       //   child: CustomMmTextField(
//                       //     onTap: () {
//                       //       provider.pickDate(
//                       //         context: context,
//                       //         selectedDate: provider.issueDate,
//                       //         type: 'issue',
//                       //       );
//                       //     },
//                       //     labelText: 'Issue Date',
//                       //     hintText: 'Issue Date',
//                       //     controller: provider.issueDateController,
//                       //     autovalidateMode: AutovalidateMode.onUserInteraction,
//                       //     validator: ValidationUtils.issueDate,
//                       //   ),
//                       // ),
//                       12.w,

//                       // Expanded(
//                       //   child: Row(
//                       //     children: [
//                       //       Expanded(
//                       //         child: CustomMmTextField(
//                       //           labelText: 'Payment Terms',
//                       //           hintText: 'Payment Terms',
//                       //           controller: provider.paymentTermsController,
//                       //           onChanged: (value) {},
//                       //         ),
//                       //       ),
//                       //       4.h,
//                       //       Text('days'),
//                       //     ],
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           12.h,
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 4,
//                   child: SingleChildScrollView(
//                     child: buildProductListSection(context, provider),
//                   ),
//                 ),
//                 10.w,
//                 Expanded(
//                   flex: 2,
//                   child: SingleChildScrollView(
//                     child: _buildOrderSummarySection(context, provider),
//                     // child: _buildOrderSummarySection(context, provider),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           20.h,
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileLayout(
//     BuildContext context,
//     SelectedInventoriesProvider provider,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildOrderSummarySection(context, provider),
//         const SizedBox(height: 20),
//         // buildProductListSection(context, provider),
//         SelectedItemsList(
//           contextHeight: context.height,
//           selectedInventory: provider.getSelectedInventory,
//           selectedProducts: provider.productsList,
//           lines: provider.getInvoiceModelValue.items ?? const [],
//           itemsTotal: provider.itemsTotal,
//           onAddItems: () => provider.setIsSelection(true),
//           onIncreaseQty: (index, inv) => provider.increaseQuantity(
//             index: index,
//             context: context,
//             inventory: inv,
//           ),
//           onDecreaseQty: (index) =>
//               provider.decreaseQuantity(index: index, context: context),
//           onRemoveItem: (index) => provider.removeInventory(
//             provider.getSelectedInventory[index],
//             provider.productsList[index],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOrderSummarySection(
//     BuildContext context,
//     SelectedInventoriesProvider provider,
//   ) {
//     return Stack(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//           decoration: BoxDecoration(
//             color: AppTheme.whiteColor,
//             border: Border.all(color: AppTheme.borderColor),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Order Summary:',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               const SizedBox(height: 10),
//               CustomMmTextField(
//                 labelText: 'Customer Name',
//                 hintText: 'Customer Name',
//                 controller: customerNameController,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 inputFormatter: [],
//                 validator: ValidationUtils.customerName,
//                 onChanged: (value) {
//                   setState(() {
//                     if (value.isNotEmpty) {
//                       filteredCustomers = allCustomers
//                           .where(
//                             (customer) => customer.customerName
//                                 .toLowerCase()
//                                 .contains(value.toLowerCase()),
//                           )
//                           .toList();
//                     } else {
//                       filteredCustomers = [];
//                     }
//                   });
//                 },
//               ),
//               const SizedBox(height: 8),
//               OrderSummaryDetails(
//                 subTotal: provider.subTotal,
//                 applyDiscount: provider.getIsDiscountApply,
//                 selectedDiscount: provider.selectedDiscount,
//                 discountAmount:
//                     provider.getInvoiceModelValue.discountedAmount ?? 0.0,
//                 taxAmount: provider.getInvoiceModelValue.taxAmount ?? 0.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Apply Discount',
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   Checkbox(
//                     value: provider.getIsDiscountApply,
//                     onChanged: (value) {
//                       provider.setDiscount(value!, null);
//                       // setState(() {
//                       //
//                       //   _applyDiscount = value ?? false;
//                       //   _selectedDiscount = null;
//                       // });
//                     },
//                   ),
//                 ],
//               ),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Apply Tax ?',
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   Checkbox(
//                     value: provider.getIsTaxApply,
//                     onChanged: (value) {
//                       provider.setTax(value!, 5);
//                     },
//                   ),
//                 ],
//               ),
//               if (provider.getIsDiscountApply)
//                 DiscountSelector(
//                   applyDiscount: provider.getIsDiscountApply,
//                   isLoadingDiscounts: _isLoadingDiscounts,
//                   discounts: _discounts,
//                   selectedDiscount: provider.selectedDiscount,
//                   onDiscountSelected: (discount) {
//                     provider.setDiscount(
//                       discount.status == "active" ? true : false,
//                       discount,
//                       percent: discount.discount.toDouble(),
//                     );
//                   },
//                 ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.titleMedium?.copyWith(fontSize: 20),
//                   ),
//                   Text(
//                     provider.total.toString(),
//                     style: Theme.of(
//                       context,
//                     ).textTheme.titleMedium?.copyWith(fontSize: 20),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               SizedBox(
//                 height: context.height * 0.06,
//                 width: context.width * 0.12,
//                 child: CustomButton(
//                   loadingNotifier: provider.loading,
//                   text:
//                       widget.invoiceModel != null ? 'Update' : 'Create Invoice',
//                   onPressed: () {
//                     if (provider.createInvoiceKey.currentState!.validate()) {
//                       provider.createInvoices(
//                         context,
//                         widget.onBack!.call,
//                         widget.invoiceModel != null,
//                       );
//                     }
//                   },
//                   buttonType: ButtonType.TextOnly,
//                   backgroundColor: AppTheme.primaryColor,
//                 ),
//               ),
//               // SizedBox(
//               //   width: double.infinity,
//               //   child: PrimaryButton(
//               //     label: 'Submit Order',
//               //     onPressed: provider.,
//               //   ),
//               // ),
//             ],
//           ),
//         ),

//         /// This overlays the customer suggestions dropdown
//         if (filteredCustomers.isNotEmpty)
//           Positioned(
//             top: 90,
//             left: 22,
//             right: 22,
//             child: Material(
//               elevation: 4,
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 padding: EdgeInsets.only(left: 6, right: 6, top: 10),
//                 height: 150,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: ListView.builder(
//                   itemCount: filteredCustomers.length,
//                   padding: EdgeInsets.zero,
//                   itemBuilder: (context, index) {
//                     final customer = filteredCustomers[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                           child: InkWell(
//                             child: Text(customer.customerName),
//                             onTap: () {
//                               provider.customerId = customer.id;
//                               setState(() {
//                                 customerNameController.text =
//                                     customer.customerName;
//                                 debugPrint(
//                                   'customer name: ${customerNameController.text}',
//                                 );
//                                 filteredCustomers.clear();
//                               });
//                             },
//                           ),
//                         ),
//                         if (index != filteredCustomers.length - 1) Divider(),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/selected_inventories_provider.dart';
import 'package:provider/provider.dart';

// Add SaleItem class
// class SaleItem {
//   final ProductModel product;
//   final int quantity;
//   final double costPrice;
//   final double marginPercent;
//   final double unitPrice;
//   final double totalPrice;

//   SaleItem({
//     required this.product,
//     required this.quantity,
//     required this.costPrice,
//     required this.marginPercent,
//     required this.unitPrice,
//     required this.totalPrice,
//   });
// }

// class CreateInvoiceMm extends StatefulWidget {
//   final VoidCallback? onBack;
//   final InvoiceMmModel? invoiceModel;
//   final List<InventoryModel>? selectedInventory;
//   final List<ProductModel>? products;

//   const CreateInvoiceMm({
//     super.key,
//     this.onBack,
//     this.invoiceModel,
//     this.products,
//     this.selectedInventory,
//   });

//   @override
//   CreateInvoiceMmPageState createState() => CreateInvoiceMmPageState();
// }

// class CreateInvoiceMmPageState extends State<CreateInvoiceMm> {
//   final customerNameController = TextEditingController();
//   final TextEditingController _globalMarginController =
//       TextEditingController(text: '20');
//   final TextEditingController _searchController = TextEditingController();

//   List<CustomerModel> allCustomers = [];
//   List<CustomerModel> filteredCustomers = [];
//   List<DiscountModel> _discounts = [];
//   List<ProductModel> allProducts = [];
//   List<ProductModel> filteredProducts = [];
//   List<SaleItem> selectedSaleItems = [];

//   bool creditPayment = false;
//   bool _isLoadingDiscounts = true;
//   bool _isLoadingProducts = true;
//   bool showProductSelection = true;

//   double totalCost = 0;
//   double totalRevenue = 0;
//   double totalProfit = 0;
//   double totalMargin = 0;

//   int currentPage = 0;
//   int itemsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_filterProducts);
//     _globalMarginController.addListener(_applyGlobalMargin);

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       final provider = context.read<SelectedInventoriesProvider>();
//       provider.clearData();
//       if (widget.selectedInventory != null &&
//           widget.selectedInventory!.isNotEmpty) {
//         final provider =
//             Provider.of<SelectedInventoriesProvider>(context, listen: false);
//         provider.addAllInventory(
//             widget.selectedInventory ?? [], widget.products ?? []);
//         provider.setInvoice(widget.invoiceModel!);
//         debugPrint('widget.invoiceModel:${widget.invoiceModel!.id}');
//       }
//     });
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     customerNameController.dispose();
//     _searchController.removeListener(_filterProducts);
//     _globalMarginController.removeListener(_applyGlobalMargin);
//     _searchController.dispose();
//     _globalMarginController.dispose();

//     final provider = context.read<SelectedInventoriesProvider>();
//     provider.clearData();
//     super.dispose();
//   }

//   void _loadInitialData() async {
//     setState(() {
//       _isLoadingDiscounts = true;
//       _isLoadingProducts = true;
//     });

//     try {
//       Future.wait([
//         DataFetchService.fetchDiscount(),
//         DataFetchService.fetchCustomers(),
//         DataFetchService.fetchProducts(),
//       ]).then((results) {
//         setState(() {
//           _discounts = results[0] as List<DiscountModel>;
//           allCustomers = results[1] as List<CustomerModel>;
//           allProducts = results[2] as List<ProductModel>;
//           filteredProducts = allProducts;
//           _isLoadingDiscounts = false;
//           _isLoadingProducts = false;

//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             if (widget.invoiceModel != null) {
//               final provider = Provider.of<SelectedInventoriesProvider>(context,
//                   listen: false);
//               final selectedCustomer = allCustomers
//                   .firstWhere((c) => c.id == widget.invoiceModel!.customerId);
//               customerNameController.text = selectedCustomer.customerName;

//               final foundDiscount = _discounts
//                   .firstWhere((d) => d.id == widget.invoiceModel!.discountId);
//               provider.setDiscount(
//                   widget.invoiceModel!.isDiscountApplied!, foundDiscount,
//                   isEdit: true,
//                   percent: widget.invoiceModel!.discountPercent!.toDouble());

//               // Convert existing items to sale items
//               _convertExistingItemsToSaleItems(provider);
//             }
//           });
//         });
//       });
//     } catch (e) {
//       setState(() {
//         _isLoadingDiscounts = false;
//         _isLoadingProducts = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load data: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   void _convertExistingItemsToSaleItems(SelectedInventoriesProvider provider) {
//     selectedSaleItems.clear();
//     for (int i = 0; i < provider.getSelectedInventory.length; i++) {
//       final inv = provider.getSelectedInventory[i];
//       final product = provider.productsList[i];
//       final item = provider.getInvoiceModelValue.items?[i];

//       if (item != null) {
//         selectedSaleItems.add(SaleItem(
//           product: product,
//           quantity: item.quantity,
//           costPrice: inv.costPrice ?? 0,
//           marginPercent: 20, // Default margin
//           unitPrice: item.perItemPrice,
//           totalPrice: item.totalPrice,
//         ));
//       }
//     }
//     _calculateTotals();
//   }

//   void _filterProducts() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredProducts = allProducts.where((product) {
//         return product.productName!.toLowerCase().contains(query) ||
//             product.code!.toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   void _applyGlobalMargin() {
//     final margin = double.tryParse(_globalMarginController.text) ?? 0;
//     if (margin > 0) {
//       setState(() {
//         for (final item in selectedSaleItems) {
//           final newUnitPrice = item.costPrice * (1 + (margin / 100));
//           final index = selectedSaleItems
//               .indexWhere((i) => i.product.id == item.product.id);
//           if (index != -1) {
//             selectedSaleItems[index] = SaleItem(
//               product: item.product,
//               quantity: item.quantity,
//               costPrice: item.costPrice,
//               marginPercent: margin,
//               unitPrice: newUnitPrice,
//               totalPrice: newUnitPrice * item.quantity,
//             );
//           }
//         }
//         _calculateTotals();
//       });
//     }
//   }

//   void _calculateTotals() {
//     totalRevenue =
//         selectedSaleItems.fold(0, (sum, item) => sum + item.totalPrice);
//     totalCost = selectedSaleItems.fold(
//         0, (sum, item) => sum + (item.costPrice * item.quantity));
//     totalProfit = totalRevenue - totalCost;
//     totalMargin = totalCost > 0 ? (totalProfit / totalCost) * 100 : 0;

//     // Update the provider with new totals
//     final provider = context.read<SelectedInventoriesProvider>();
//     provider.updateTotals(totalRevenue, totalCost);
//   }

//   void _addProductToSale(ProductModel product) {
//     final existingItem = selectedSaleItems.firstWhere(
//       (item) => item.product.id == product.id,
//       orElse: () => SaleItem(
//         product: ProductModel(),
//         quantity: 0,
//         costPrice: 0,
//         marginPercent: 0,
//         unitPrice: 0,
//         totalPrice: 0,
//       ),
//     );

//     if (existingItem.product.id != null) {
//       _showEditProductDialog(existingItem);
//     } else {
//       _showAddProductDialog(product);
//     }
//   }

//   void _showAddProductDialog(ProductModel product) {
//     final quantityController = TextEditingController(text: '1');
//     final marginController =
//         TextEditingController(text: _globalMarginController.text);
//     final costPrice = product.averageCost ?? 0;
//     final initialSellingPrice =
//         costPrice * (1 + (double.parse(marginController.text) / 100));

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           void updateSellingPrice() {
//             final margin = double.tryParse(marginController.text) ?? 0;
//             final sellingPrice = costPrice * (1 + (margin / 100));
//             setState(() {});
//           }

//           return AlertDialog(
//             title: Text('Add ${product.productName} to Sale'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomMmTextField(
//                   controller: quantityController,
//                   labelText: 'Quantity',
//                   hintText: "20",
//                   // decoration: const InputDecoration(
//                   //   labelText: 'Quantity',
//                   //   border: OutlineInputBorder(),
//                   // ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Cost Price: OMR ${costPrice.toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//                 16.h,
//                 CustomMmTextField(
//                   controller: marginController,
//                   labelText: 'Margin %',
//                   hintText: "20",
//                   // decoration: const InputDecoration(
//                   //   labelText: 'Margin %',
//                   //   border: OutlineInputBorder(),
//                   //   suffixText: '%',
//                   // ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Selling Price: OMR ${(costPrice * (1 + ((double.tryParse(marginController.text) ?? 0) / 100))).toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final quantity = int.tryParse(quantityController.text) ?? 0;
//                   final margin = double.tryParse(marginController.text) ?? 0;

//                   if (quantity <= 0) return;
//                   if (quantity > (product.totalStockOnHand ?? 0)) return;

//                   final unitPrice = costPrice * (1 + (margin / 100));

//                   setState(() {
//                     selectedSaleItems.add(SaleItem(
//                       product: product,
//                       quantity: quantity,
//                       costPrice: costPrice,
//                       marginPercent: margin,
//                       unitPrice: unitPrice,
//                       totalPrice: unitPrice * quantity,
//                     ));
//                     _calculateTotals();
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Add'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _showEditProductDialog(SaleItem item) {
//     final quantityController =
//         TextEditingController(text: item.quantity.toString());
//     final marginController =
//         TextEditingController(text: item.marginPercent.toStringAsFixed(1));

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           void updateSellingPrice() {
//             final margin = double.tryParse(marginController.text) ?? 0;
//             final sellingPrice = item.costPrice * (1 + (margin / 100));
//             setState(() {});
//           }

//           return AlertDialog(
//             title: Text('Edit ${item.product.productName}'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: quantityController,
//                   decoration: const InputDecoration(
//                     labelText: 'Quantity',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Cost Price: OMR ${item.costPrice.toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//                 16.h,
//                 TextFormField(
//                   controller: marginController,
//                   decoration: const InputDecoration(
//                     labelText: 'Margin %',
//                     border: OutlineInputBorder(),
//                     suffixText: '%',
//                   ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Selling Price: OMR ${(item.costPrice * (1 + ((double.tryParse(marginController.text) ?? 0) / 100))).toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final quantity = int.tryParse(quantityController.text) ?? 0;
//                   final margin = double.tryParse(marginController.text) ?? 0;

//                   if (quantity <= 0) return;
//                   if (quantity > (item.product.totalStockOnHand ?? 0)) return;

//                   final unitPrice = item.costPrice * (1 + (margin / 100));

//                   setState(() {
//                     final index = selectedSaleItems
//                         .indexWhere((i) => i.product.id == item.product.id);
//                     if (index != -1) {
//                       selectedSaleItems[index] = SaleItem(
//                         product: item.product,
//                         quantity: quantity,
//                         costPrice: item.costPrice,
//                         marginPercent: margin,
//                         unitPrice: unitPrice,
//                         totalPrice: unitPrice * quantity,
//                       );
//                       _calculateTotals();
//                     }
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Update'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _removeProductFromSale(ProductModel product) {
//     setState(() {
//       selectedSaleItems.removeWhere((item) => item.product.id == product.id);
//       _calculateTotals();
//     });
//   }

//   void _toggleView() {
//     setState(() {
//       showProductSelection = !showProductSelection;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width > 768;

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               PageHeaderWidget(
//                 // subtitle: "",

//                 // title: widget.invoiceModel != null
//                 //     ? 'Edit Invoice'
//                 //     : 'Create Invoice',
//                 // onBack: widget.onBack
//                 title: 'Create Invoice',
//                 buttonText: 'Back to Invoices',
//                 subTitle: 'Create New Invoice',
//                 onCreateIcon: 'assets/icons/back.png',
//                 selectedItems: [],
//                 buttonWidth: 0.4,
//                 onCreate: widget.onBack!.call,
//                 onDelete: () async {},
//               ),
//               16.h,
//               Expanded(
//                 child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDesktopLayout() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Left side - Product selection
//         Expanded(
//           flex: 2,
//           child: _buildProductSelectionSection(),
//         ),
//         16.w,
//         // Right side - Order summary
//         Expanded(
//           flex: 1,
//           child: _buildOrderSummarySection(),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileLayout() {
//     return Column(
//       children: [
//         // Toggle button for mobile
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomButton(
//               onPressed: _toggleView,
//               text:
//                   showProductSelection ? 'View Order Summary' : 'View Products',
//               buttonType: ButtonType.Filled,
//             ),
//           ],
//         ),
//         16.h,
//         // Content based on toggle
//         Expanded(
//           child: showProductSelection
//               ? _buildProductSelectionSection()
//               : _buildOrderSummarySection(),
//         ),
//       ],
//     );
//   }

//   Widget _buildProductSelectionSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Products',
//             // style: AppTheme.headline.copyWith(fontSize: 18),
//           ),
//           16.h,
//           // Search and global margin
//           Row(
//             children: [
//               Expanded(
//                 child: CustomMmTextField(
//                   controller: _searchController,
//                   hintText: 'Search products...',
//                   // prefixIcon: const Icon(Icons.search),
//                 ),
//               ),
//               16.w,
//               SizedBox(
//                 width: 120,
//                 child: CustomMmTextField(
//                   controller: _globalMarginController,
//                   hintText: 'Margin %',
//                   //suffixText: '%',
//                   keyboardType: TextInputType.number,
//                 ),
//               ),
//             ],
//           ),
//           16.h,
//           // Product list
//           Expanded(
//             child: _isLoadingProducts
//                 ? const Center(child: CircularProgressIndicator())
//                 : _buildProductList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductList() {
//     final startIndex = currentPage * itemsPerPage;
//     final endIndex = min(startIndex + itemsPerPage, filteredProducts.length);
//     final currentProducts = filteredProducts.sublist(startIndex, endIndex);

//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             itemCount: currentProducts.length,
//             itemBuilder: (context, index) {
//               final product = currentProducts[index];
//               final isSelected = selectedSaleItems
//                   .any((item) => item.product.id == product.id);

//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 child: ListTile(
//                   title: Text(product.productName ?? ''),
//                   subtitle: Text(
//                       'Code: ${product.code} | Stock: ${product.totalStockOnHand}'),
//                   trailing: isSelected
//                       ? IconButton(
//                           icon: const Icon(Icons.remove_circle,
//                               color: Colors.red),
//                           onPressed: () => _removeProductFromSale(product),
//                         )
//                       : IconButton(
//                           icon:
//                               const Icon(Icons.add_circle, color: Colors.green),
//                           onPressed: () => _addProductToSale(product),
//                         ),
//                   onTap: () => _addProductToSale(product),
//                 ),
//               );
//             },
//           ),
//         ),
//         // Pagination controls
//         if (filteredProducts.length > itemsPerPage)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: currentPage > 0
//                     ? () => setState(() => currentPage--)
//                     : null,
//               ),
//               Text(
//                   'Page ${currentPage + 1} of ${(filteredProducts.length / itemsPerPage).ceil()}'),
//               IconButton(
//                 icon: const Icon(Icons.arrow_forward),
//                 onPressed:
//                     (currentPage + 1) * itemsPerPage < filteredProducts.length
//                         ? () => setState(() => currentPage++)
//                         : null,
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget _buildOrderSummarySection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Order Summary',
//             // style: AppTheme.-.copyWith(fontSize: 18),
//           ),
//           16.h,
//           // Customer selection
//           CustomMmTextField(
//             controller: customerNameController,
//             hintText: 'Customer Name',
//             //prefixIcon: const Icon(Icons.person),
//           ),
//           16.h,
//           // Discount selector
//           // DiscountSelector(
//           //   discounts: _discounts,
//           //  // isLoading: _isLoadingDiscounts,
//           //   onDiscountSelected: (discount, isApplied, percent) {
//           //     final provider = context.read<SelectedInventoriesProvider>();
//           //     provider.setDiscount(isApplied, discount, percent: percent);
//           //   }, applyDiscount: null, isLoadingDiscounts: null, selectedDiscount: null,
//           // ),
//           //           DiscountSelector(
//           //   applyDiscount: provider.getIsDiscountApply,
//           //   isLoadingDiscounts: _isLoadingDiscounts,
//           //   discounts: _discounts,
//           //   selectedDiscount: provider.selectedDiscount,
//           //   onDiscountSelected: (discount) {
//           //     provider.setDiscount(
//           //       discount.status == "active" ? true : false,
//           //       discount,
//           //       percent: discount.discount.toDouble(),
//           //     );
//           //   },
//           // ),
//           16.h,
//           // Selected items list
//           Expanded(
//             child: selectedSaleItems.isEmpty
//                 ? const Center(child: Text('No products added to sale'))
//                 : ListView.builder(
//                     itemCount: selectedSaleItems.length,
//                     itemBuilder: (context, index) {
//                       final item = selectedSaleItems[index];
//                       return ListTile(
//                         title: Text(item.product.productName ?? ''),
//                         subtitle: Text(
//                             'Qty: ${item.quantity} | Price: OMR ${item.unitPrice.toStringAsFixed(2)}'),
//                         trailing:
//                             Text('OMR ${item.totalPrice.toStringAsFixed(2)}'),
//                         onTap: () => _showEditProductDialog(item),
//                       );
//                     },
//                   ),
//           ),
//           16.h,
//           // Financial summary
//           _buildFinancialSummary(),
//           16.h,
//           // Payment options
//           Row(
//             children: [
//               const Text('Payment Method:'),
//               16.w,
//               ChoiceChip(
//                 label: const Text('Cash'),
//                 selected: !creditPayment,
//                 onSelected: (selected) =>
//                     setState(() => creditPayment = !selected),
//               ),
//               8.w,
//               ChoiceChip(
//                 label: const Text('Credit'),
//                 selected: creditPayment,
//                 onSelected: (selected) =>
//                     setState(() => creditPayment = selected),
//               ),
//             ],
//           ),
//           16.h,
//           // Action buttons
//           Row(
//             children: [
//               Expanded(
//                 child: CustomButton(
//                   onPressed: () {
//                     // Save as draft functionality
//                   },
//                   text: 'Save as Draft',
//                   buttonType: ButtonType.Filled,
//                 ),
//               ),
//               16.w,
//               Expanded(
//                 child: CustomButton(
//                   onPressed: () {
//                     // Complete sale functionality
//                   },
//                   text: 'Complete Sale',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFinancialSummary() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const Divider(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Total Cost:'),
//             Text('OMR ${totalCost.toStringAsFixed(2)}'),
//           ],
//         ),
//         8.h,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Total Revenue:'),
//             Text('OMR ${totalRevenue.toStringAsFixed(2)}'),
//           ],
//         ),
//         8.h,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Total Profit:'),
//             Text(
//               'OMR ${totalProfit.toStringAsFixed(2)}',
//               style: TextStyle(
//                 color: totalProfit >= 0 ? Colors.green : Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         8.h,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Profit Margin:'),
//             Text(
//               '${totalMargin.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 color: totalMargin >= 0 ? Colors.green : Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

// Add SaleItem class
class SaleItemInternal {
  final ProductModel product;
  final int quantity;
  final double costPrice;
  final double marginPercent;
  final double unitPrice;
  final double totalPrice;
  final List<Map<String, dynamic>> batchAllocations;

  SaleItemInternal({
    required this.product,
    required this.quantity,
    required this.costPrice,
    required this.marginPercent,
    required this.unitPrice,
    required this.totalPrice,
    required this.batchAllocations,
  });
}

class CreateInvoiceMm extends StatefulWidget {
  final VoidCallback? onBack;
  final InvoiceMmModel? invoiceModel;
  final List<InventoryModel>? selectedInventory;
  final List<ProductModel>? products;

  const CreateInvoiceMm({
    super.key,
    this.onBack,
    this.invoiceModel,
    this.products,
    this.selectedInventory,
  });

  @override
  CreateInvoiceMmPageState createState() => CreateInvoiceMmPageState();
}

class CreateInvoiceMmPageState extends State<CreateInvoiceMm> {
  final customerNameController = TextEditingController();
  final TextEditingController _globalMarginController = TextEditingController(
    text: '20',
  );
  final TextEditingController _searchController = TextEditingController();

  List<CustomerModel> allCustomers = [];
  List<CustomerModel> filteredCustomers = [];
  List<DiscountModel> _discounts = [];
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<SaleItemInternal> selectedSaleItems = [];

  bool creditPayment = false;
  bool _isLoadingDiscounts = true;
  bool _isLoadingProducts = true;
  bool showProductSelection = true;
  bool _isProcessingSale = false;

  double totalCost = 0;
  double totalRevenue = 0;
  double totalProfit = 0;
  double totalMargin = 0;

  int currentPage = 0;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
    _globalMarginController.addListener(_applyGlobalMargin);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<SelectedInventoriesProvider>();
      provider.clearData();
      if (widget.selectedInventory != null &&
          widget.selectedInventory!.isNotEmpty) {
        final provider = Provider.of<SelectedInventoriesProvider>(
          context,
          listen: false,
        );
        provider.addAllInventory(
          widget.selectedInventory ?? [],
          widget.products ?? [],
        );
        provider.setInvoice(widget.invoiceModel!);
        debugPrint('widget.invoiceModel:${widget.invoiceModel!.id}');
      }
    });
    _loadInitialData();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    _searchController.removeListener(_filterProducts);
    _globalMarginController.removeListener(_applyGlobalMargin);
    _searchController.dispose();
    _globalMarginController.dispose();

    final provider = context.read<SelectedInventoriesProvider>();
    provider.clearData();
    super.dispose();
  }

  void _loadInitialData() async {
    setState(() {
      _isLoadingDiscounts = true;
      _isLoadingProducts = true;
    });

    try {
      Future.wait([
        DataFetchService.fetchDiscount(),
        DataFetchService.fetchCustomers(),
        DataFetchService.fetchProducts(),
      ]).then((results) {
        setState(() {
          _discounts = results[0] as List<DiscountModel>;
          allCustomers = results[1] as List<CustomerModel>;
          allProducts = results[2] as List<ProductModel>;
          filteredProducts = allProducts;
          _isLoadingDiscounts = false;
          _isLoadingProducts = false;

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (widget.invoiceModel != null) {
              final provider = Provider.of<SelectedInventoriesProvider>(
                context,
                listen: false,
              );
              final selectedCustomer = allCustomers.firstWhere(
                (c) => c.id == widget.invoiceModel!.customerId,
              );
              customerNameController.text = selectedCustomer.customerName;

              final foundDiscount = _discounts.firstWhere(
                (d) => d.id == widget.invoiceModel!.discountId,
              );
              provider.setDiscount(
                widget.invoiceModel!.isDiscountApplied!,
                foundDiscount,
                isEdit: true,
                percent: widget.invoiceModel!.discountPercent!.toDouble(),
              );

              // Convert existing items to sale items
              _convertExistingItemsToSaleItems(provider);
            }
          });
        });
      });
    } catch (e) {
      setState(() {
        _isLoadingDiscounts = false;
        _isLoadingProducts = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: ${e.toString()}')),
        );
      }
    }
  }

  void _convertExistingItemsToSaleItems(SelectedInventoriesProvider provider) {
    selectedSaleItems.clear();
    for (int i = 0; i < provider.getSelectedInventory.length; i++) {
      final inv = provider.getSelectedInventory[i];
      final product = provider.productsList[i];
      final item = provider.getInvoiceModelValue.items?[i];

      if (item != null) {
        selectedSaleItems.add(
          SaleItemInternal(
            product: product,
            quantity: item.quantity,
            costPrice: inv.costPrice ?? 0,
            marginPercent: 20, // Default margin
            unitPrice: item.perItemPrice,
            totalPrice: item.totalPrice,
            batchAllocations: [], // Will be populated during sale creation
          ),
        );
      }
    }
    _calculateTotals();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((product) {
        return product.productName!.toLowerCase().contains(query) ||
            product.code!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _applyGlobalMargin() {
    final margin = double.tryParse(_globalMarginController.text) ?? 0;
    if (margin > 0) {
      setState(() {
        for (final item in selectedSaleItems) {
          final newUnitPrice = item.costPrice * (1 + (margin / 100));
          final index = selectedSaleItems.indexWhere(
            (i) => i.product.id == item.product.id,
          );
          if (index != -1) {
            selectedSaleItems[index] = SaleItemInternal(
              product: item.product,
              quantity: item.quantity,
              costPrice: item.costPrice,
              marginPercent: margin,
              unitPrice: newUnitPrice,
              totalPrice: newUnitPrice * item.quantity,
              batchAllocations: item.batchAllocations,
            );
          }
        }
        _calculateTotals();
      });
    }
  }

  void _calculateTotals() {
    totalRevenue = selectedSaleItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    totalCost = selectedSaleItems.fold(
      0,
      (sum, item) => sum + (item.costPrice * item.quantity),
    );
    totalProfit = totalRevenue - totalCost;
    totalMargin = totalCost > 0 ? (totalProfit / totalCost) * 100 : 0;
  }

  Future<List<Map<String, dynamic>>> _performFifoAllocation(
    String productId,
    int quantity,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final batchesQuery = await firestore
        .collection('mmInventoryBatches')
        .where('productId', isEqualTo: productId)
        .where('isActive', isEqualTo: true)
        .where('quantityRemaining', isGreaterThan: 0)
        .orderBy('receivedDate', descending: false)
        .get();

    if (batchesQuery.docs.isEmpty) {
      throw Exception('No available batches found for product $productId');
    }

    final List<Map<String, dynamic>> batchAllocations = [];
    int remainingQuantity = quantity;

    for (final batchDoc in batchesQuery.docs) {
      if (remainingQuantity <= 0) break;

      final batchData = batchDoc.data() as Map<String, dynamic>;
      final int batchQtyRemaining = batchData['quantityRemaining'] ?? 0;
      final double unitCost = (batchData['unitCost'] ?? 0).toDouble();

      if (batchQtyRemaining > 0) {
        final int allocateQty = remainingQuantity > batchQtyRemaining
            ? batchQtyRemaining
            : remainingQuantity;

        final double allocationTotalCost = allocateQty * unitCost;

        batchAllocations.add({
          'batchId': batchDoc.id,
          'batchReference': batchData['batchReference'],
          'quantity': allocateQty,
          'unitCost': unitCost,
          'totalCost': allocationTotalCost,
          'batchQuantityRemaining': batchQtyRemaining,
        });

        remainingQuantity -= allocateQty;
      }
    }

    if (remainingQuantity > 0) {
      throw Exception(
        'Could not allocate full quantity. Only ${quantity - remainingQuantity} of $quantity could be allocated.',
      );
    }

    return batchAllocations;
  }

  Future<void> _completeSale() async {
    if (selectedSaleItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add products to the sale')),
      );
      return;
    }

    if (customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter customer name')),
      );
      return;
    }

    setState(() {
      _isProcessingSale = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // Prepare sale data
      final saleRef = firestore.collection('sales').doc();
      final saleData = {
        'saleId': saleRef.id,
        'productId': selectedSaleItems.first.product.id,
        'productName': selectedSaleItems.first.product.productName,
        'quantity': selectedSaleItems.fold(
          0,
          (sum, item) => sum + item.quantity,
        ),
        'sellingPrice': selectedSaleItems.first.unitPrice,
        'totalRevenue': totalRevenue,
        'totalCost': totalCost,
        'profit': totalProfit,
        'customerName': customerNameController.text,
        // 'notes': notesController.text.isNotEmpty ? notesController.text : '',
        'status': 'pending',
        'previousStock': selectedSaleItems.first.product.totalStockOnHand,
        'batchAllocations': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'paymentMethod': creditPayment ? 'credit' : 'cash',
        'items': selectedSaleItems
            .map(
              (item) => {
                'productId': item.product.id,
                'productName': item.product.productName,
                'quantity': item.quantity,
                'unitPrice': item.unitPrice,
                'totalPrice': item.quantity * item.unitPrice,
              },
            )
            .toList(),
      };

      // Perform FIFO allocation for each product
      for (final item in selectedSaleItems) {
        final allocations = await _performFifoAllocation(
          item.product.id!,
          item.quantity,
        );
        (saleData['batchAllocations'] as List).addAll(allocations);
      }

      // Create sale document

      await saleRef.set(saleData);

      // ✅ Call Cloud Function to process the sale
      await _processSaleWithCloudFunction(saleRef.id, saleData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale completed successfully!')),
      );

      // Reset form
      setState(() {
        selectedSaleItems.clear();
        _calculateTotals();
        customerNameController.clear();
        //      notesController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating sale: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isProcessingSale = false;
      });
    }
  }

  // Function to call Cloud Function
  // Future<void> _processSaleWithCloudFunction(
  //     String saleId, Map<String, dynamic> saleData) async {
  //   try {
  //     final functions = FirebaseFunctions.instance;
  //     //  // final callable = functions.httpsCallable('processSale');

  //     //   final result = await callable.call({
  //     //     'saleId': saleId,
  //     //     'saleData': saleData,
  //     //   });
  //     HttpsCallable callable =
  //         FirebaseFunctions.instance.httpsCallable('processSale');
  //     final results = await callable({
  //       'saleId': saleId,
  //       'saleData': saleData,
  //     });
  //     if (results.data != 'error') {
  //       if (!mounted) {
  //         return;
  //       }
  //     }
  //     debugPrint('Cloud Function result: ${results.data}');
  //   } catch (e) {
  //     debugPrint('Error calling Cloud Function: $e');
  //     throw Exception('Failed to process sale inventory updates');
  //   }
  // }

  // Future<void> _processSaleWithCloudFunction(
  //     String saleId, Map<String, dynamic> saleData) async {
  //   try {
  //     // Initialize Firebase Functions with your region if needed
  //     FirebaseFunctions functions = FirebaseFunctions.instance;

  //     // For web compatibility or specific regions, use:
  //     // FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  //     // Create the callable function reference
  //     HttpsCallable callable = functions.httpsCallable(
  //       'processSale',
  //       options: HttpsCallableOptions(
  //         timeout: const Duration(seconds: 30),
  //       ),
  //     );

  //     // Call the function
  //     final HttpsCallableResult result = await callable.call(<String, dynamic>{
  //       'saleId': saleId,
  //       'saleData': saleData,
  //     });

  //     debugPrint('Cloud Function result: ${result.data}');

  //     // Handle the response
  //     final responseData = result.data;
  //     if (responseData is Map && responseData['success'] == false) {
  //       throw Exception(responseData['message'] ?? 'Sale processing failed');
  //     }
  //   } on FirebaseFunctionsException catch (e) {
  //     debugPrint('Firebase Functions Exception: ${e.code} - ${e.message}');
  //     debugPrint('Details: ${e.details}');

  //     // Handle specific error codes
  //     switch (e.code) {
  //       case 'invalid-argument':
  //         throw Exception('Invalid sale data provided');
  //       case 'failed-precondition':
  //         throw Exception('Inventory validation failed: ${e.message}');
  //       case 'not-found':
  //         throw Exception('Required data not found: ${e.message}');
  //       case 'unauthenticated':
  //         throw Exception('Please sign in again to complete the sale');
  //       default:
  //         throw Exception('Failed to process sale: ${e.message}');
  //     }
  //   } catch (e) {
  //     debugPrint('Unexpected error calling Cloud Function: $e');
  //     throw Exception('Unexpected error processing sale');
  //   }
  // }

  dynamic _sanitizeForFirebase(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map(
          (e) => MapEntry(e.key.toString(), _sanitizeForFirebase(e.value)),
        ),
      );
    } else if (value is List) {
      return value.map(_sanitizeForFirebase).toList();
    } else if (value is FieldValue) {
      // Replace Firestore sentinel values with something serializable
      return DateTime.now().toIso8601String();
    } else {
      return value;
    }
  }

  Future<void> _processSaleWithCloudFunction(
    String saleId,
    Map<String, dynamic> saleData,
  ) async {
    try {
      final functions = FirebaseFunctions.instance;

      // Convert all data to ensure proper serialization
      final cleanSaleData = _sanitizeForFirebase(saleData);
      debugPrintMapTypes(cleanSaleData);
      final Map<String, dynamic> callData = {
        'saleId': saleId,
        'saleData': cleanSaleData,
      };

      // Use the modern API syntax
      final result = await functions
          .httpsCallable(
            'processSale',
            options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
          )
          .call(callData);

      debugPrint('Cloud Function result: ${result.data}');

      // Handle response
      final response = result.data;
      if (response is Map<String, dynamic> && response['success'] == false) {
        throw Exception(response['message'] ?? 'Sale processing failed');
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Firebase Functions Exception: ${e.code} - ${e.message}');
      throw Exception('Cloud Function Error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to process sale: $e');
    }
  }

  void debugPrintMapTypes(Map<String, dynamic> map, [String prefix = '']) {
    map.forEach((key, value) {
      final type = value.runtimeType;

      if (value is Map<String, dynamic>) {
        debugPrint('$prefix$key → Map');
        debugPrintMapTypes(value, '$prefix  ');
      } else if (value is List) {
        debugPrint('$prefix$key → List');
        for (int i = 0; i < value.length; i++) {
          final element = value[i];
          debugPrint('$prefix  [$i] → ${element.runtimeType}');
          if (element is Map<String, dynamic>) {
            debugPrintMapTypes(element, '$prefix    ');
          }
        }
      } else {
        debugPrint('$prefix$key → $type : $value');
      }
    });
  }

  void _addProductToSale(ProductModel product) {
    final existingItem = selectedSaleItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => SaleItemInternal(
        product: ProductModel(),
        quantity: 0,
        costPrice: 0,
        marginPercent: 0,
        unitPrice: 0,
        totalPrice: 0,
        batchAllocations: [],
      ),
    );

    if (existingItem.product.id != null) {
      _showEditProductDialog(existingItem);
    } else {
      _showAddProductDialog(product);
    }
    setState(() {});
  }

  void _showAddProductDialog(ProductModel product) {
    final quantityController = TextEditingController(text: '1');
    final marginController = TextEditingController(text: '20');
    final priceController = TextEditingController();
    final costPrice = product.averageCost ?? 0;
    var useCustomPrice = false;

    // Initialize with calculated price based on margin
    final initialPrice = costPrice * (1 + (20 / 100));
    priceController.text = initialPrice.toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void updateCalculations() {
            final quantity = int.tryParse(quantityController.text) ?? 1;
            final margin = double.tryParse(marginController.text) ?? 20;
            final customPrice = double.tryParse(priceController.text);

            if (useCustomPrice && customPrice != null) {
              final calculatedMargin =
                  ((customPrice - costPrice) / costPrice) * 100;
              marginController.text = calculatedMargin.toStringAsFixed(2);
            } else {
              final sellingPrice = costPrice * (1 + (margin / 100));
              priceController.text = sellingPrice.toStringAsFixed(2);
            }
          }

          return AlertDialog(
            title: Text('Add ${product.productName} to Sale'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomMmTextField(
                  controller: quantityController,
                  labelText: 'Quantity',
                  hintText: "1",
                  keyboardType: TextInputType.number,
                  onChanged: (value) => updateCalculations(),
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cost Price: OMR ${costPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                16.h,
                // Price input field (first option)
                CustomMmTextField(
                  controller: priceController,
                  labelText: 'Selling Price',
                  hintText: "0.00",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      useCustomPrice = true;
                      updateCalculations();
                    });
                  },
                ),
                16.h,
                // Margin input field (second option)
                CustomMmTextField(
                  controller: marginController,
                  labelText: 'Margin %',
                  hintText: "20",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      useCustomPrice = false;
                      updateCalculations();
                    });
                  },
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total: OMR ${((double.tryParse(priceController.text) ?? 0) * (int.tryParse(quantityController.text) ?? 1)).toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  final margin = double.tryParse(marginController.text) ?? 0;
                  final unitPrice =
                      double.tryParse(priceController.text) ??
                      costPrice * (1 + (margin / 100));

                  if (quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quantity must be greater than 0'),
                      ),
                    );
                    return;
                  }

                  if (quantity > (product.totalStockOnHand ?? 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Only ${product.totalStockOnHand} items available',
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    selectedSaleItems.add(
                      SaleItemInternal(
                        product: product,
                        quantity: quantity,
                        costPrice: costPrice,
                        marginPercent: margin,
                        unitPrice: unitPrice,
                        totalPrice: unitPrice * quantity,
                        batchAllocations: [],
                      ),
                    );
                    _calculateTotals();
                  });
                  closePopUp(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void closePopUp(BuildContext context) {
    Navigator.pop(context);
    setState(() {});
  }

  void _showEditProductDialog(SaleItemInternal item) {
    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );
    final marginController = TextEditingController(
      text: item.marginPercent.toStringAsFixed(1),
    );
    final priceController = TextEditingController(
      text: item.unitPrice.toStringAsFixed(2),
    );
    var useCustomPrice = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void updateCalculations() {
            final quantity = int.tryParse(quantityController.text) ?? 1;
            final margin = double.tryParse(marginController.text) ?? 20;
            final customPrice = double.tryParse(priceController.text);

            if (useCustomPrice && customPrice != null) {
              final calculatedMargin =
                  ((customPrice - item.costPrice) / item.costPrice) * 100;
              marginController.text = calculatedMargin.toStringAsFixed(2);
            } else {
              final sellingPrice = item.costPrice * (1 + (margin / 100));
              priceController.text = sellingPrice.toStringAsFixed(2);
            }
          }

          return AlertDialog(
            title: Text('Edit ${item.product.productName}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomMmTextField(
                  controller: quantityController,
                  labelText: 'Quantity',
                  hintText: "1",
                  keyboardType: TextInputType.number,
                  onChanged: (value) => updateCalculations(),
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cost Price: OMR ${item.costPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                16.h,
                // Price input field (first option)
                CustomMmTextField(
                  controller: priceController,
                  labelText: 'Selling Price',
                  hintText: "0.00",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      useCustomPrice = true;
                      updateCalculations();
                    });
                  },
                ),
                16.h,
                // Margin input field (second option)
                CustomMmTextField(
                  controller: marginController,
                  labelText: 'Margin %',
                  hintText: "20",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      useCustomPrice = false;
                      updateCalculations();
                    });
                  },
                ),
                16.h,
                Row(
                  children: [
                    // Expanded(
                    //   child: Text(
                    //       'Total: OMR ${((double.tryParse(priceController.text) || 0) * (int.tryParse(quantityController.text) || 1)).toStringAsFixed(2)}'),
                    // ),
                    Expanded(
                      child: Text(
                        'Total: OMR ${((double.tryParse(priceController.text) ?? 0) * (int.tryParse(quantityController.text) ?? 1)).toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  final margin = double.tryParse(marginController.text) ?? 0;
                  final unitPrice =
                      double.tryParse(priceController.text) ??
                      item.costPrice * (1 + (margin / 100));

                  if (quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quantity must be greater than 0'),
                      ),
                    );
                    return;
                  }

                  if (quantity > (item.product.totalStockOnHand ?? 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Only ${item.product.totalStockOnHand} items available',
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    final index = selectedSaleItems.indexWhere(
                      (i) => i.product.id == item.product.id,
                    );
                    if (index != -1) {
                      selectedSaleItems[index] = SaleItemInternal(
                        product: item.product,
                        quantity: quantity,
                        costPrice: item.costPrice,
                        marginPercent: margin,
                        unitPrice: unitPrice,
                        totalPrice: unitPrice * quantity,
                        batchAllocations: item.batchAllocations,
                      );
                      _calculateTotals();
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _removeProductFromSale(ProductModel product) {
    setState(() {
      selectedSaleItems.removeWhere((item) => item.product.id == product.id);
      _calculateTotals();
    });
  }

  void _toggleView() {
    setState(() {
      showProductSelection = !showProductSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeaderWidget(
                title: 'Create Invoice',
                buttonText: 'Back to Invoices',
                subTitle: 'Create New Invoice',
                onCreateIcon: 'assets/images/back.png',
                selectedItems: [],
                buttonWidth: 0.4,
                onCreate: widget.onBack?.call,
                onDelete: () async {},
              ),
              16.h,
              Expanded(
                child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildProductSelectionSection()),
        16.w,
        Expanded(flex: 1, child: _buildOrderSummarySection()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: _toggleView,
              text: showProductSelection
                  ? 'View Order Summary'
                  : 'View Products',
              buttonType: ButtonType.Filled,
            ),
          ],
        ),
        16.h,
        Expanded(
          child: showProductSelection
              ? _buildProductSelectionSection()
              : _buildOrderSummarySection(),
        ),
      ],
    );
  }

  Widget _buildProductSelectionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Products', style: Theme.of(context).textTheme.bodyLarge),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomMmTextField(
                  controller: _searchController,
                  hintText: 'Search products...',
                ),
              ),
              16.w,
              SizedBox(
                width: 120,
                child: CustomMmTextField(
                  controller: _globalMarginController,
                  hintText: 'Margin %',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          16.h,
          Expanded(
            child: _isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = min(startIndex + itemsPerPage, filteredProducts.length);
    final currentProducts = filteredProducts.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: currentProducts.length,
            itemBuilder: (context, index) {
              final product = currentProducts[index];
              final isSelected = selectedSaleItems.any(
                (item) => item.product.id == product.id,
              );

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(product.productName ?? ''),
                  subtitle: Text(
                    'Code: ${product.code} | Stock: ${product.totalStockOnHand}',
                  ),
                  trailing: isSelected
                      ? IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () => _removeProductFromSale(product),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () => _addProductToSale(product),
                        ),
                  onTap: () => _addProductToSale(product),
                ),
              );
            },
          ),
        ),
        if (filteredProducts.length > itemsPerPage)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: currentPage > 0
                    ? () => setState(() => currentPage--)
                    : null,
              ),
              Text(
                'Page ${currentPage + 1} of ${(filteredProducts.length / itemsPerPage).ceil()}',
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed:
                    (currentPage + 1) * itemsPerPage < filteredProducts.length
                    ? () => setState(() => currentPage++)
                    : null,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: Theme.of(context).textTheme.bodyLarge),
          16.h,
          CustomMmTextField(
            controller: customerNameController,
            hintText: 'Customer Name',
          ),
          16.h,
          Expanded(
            child: selectedSaleItems.isEmpty
                ? const Center(child: Text('No products added to sale'))
                : ListView.builder(
                    itemCount: selectedSaleItems.length,
                    itemBuilder: (context, index) {
                      final item = selectedSaleItems[index];
                      return ListTile(
                        title: Text(item.product.productName ?? ''),
                        subtitle: Text(
                          'Qty: ${item.quantity} | Price: OMR ${item.unitPrice.toStringAsFixed(2)}',
                        ),
                        trailing: Text(
                          'OMR ${item.totalPrice.toStringAsFixed(2)}',
                        ),
                        onTap: () => _showEditProductDialog(item),
                      );
                    },
                  ),
          ),
          16.h,
          _buildFinancialSummary(),
          16.h,
          Row(
            children: [
              const Text('Payment Method:'),
              16.w,
              ChoiceChip(
                label: const Text('Cash'),
                selected: !creditPayment,
                onSelected: (selected) =>
                    setState(() => creditPayment = !selected),
              ),
              8.w,
              ChoiceChip(
                label: const Text('Credit'),
                selected: creditPayment,
                onSelected: (selected) =>
                    setState(() => creditPayment = selected),
              ),
            ],
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    // Save as draft functionality
                  },
                  text: 'Save as Draft',
                  buttonType: ButtonType.Filled,
                ),
              ),
              16.w,
              Expanded(
                child: CustomButton(
                  onPressed: _isProcessingSale ? null : _completeSale,
                  text: _isProcessingSale ? 'Processing...' : 'Complete Sale',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Cost:'),
            Text('OMR ${totalCost.toStringAsFixed(2)}'),
          ],
        ),
        8.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Revenue:'),
            Text('OMR ${totalRevenue.toStringAsFixed(2)}'),
          ],
        ),
        8.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Profit:'),
            Text(
              'OMR ${totalProfit.toStringAsFixed(2)}',
              style: TextStyle(
                color: totalProfit >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        8.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Profit Margin:'),
            Text(
              '${totalMargin.toStringAsFixed(2)}%',
              style: TextStyle(
                color: totalMargin >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
