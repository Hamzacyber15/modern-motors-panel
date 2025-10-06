// import 'dart:math';

// import 'package:app/app_theme.dart';
// import 'package:app/models/discount_model.dart';
// import 'package:app/modern_motors/models/admin/brand_model.dart';
// import 'package:app/modern_motors/models/customer/customer_model.dart';
// import 'package:app/modern_motors/models/inventory/inventory_model.dart';
// import 'package:app/modern_motors/models/product/product_sub_catorymodel.dart';
// import 'package:app/modern_motors/models/product_category_model.dart';
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

// class CreateNewInvoice extends StatefulWidget {
//   final VoidCallback? onBack;
//   final InvoiceNewModel? invoiceModel;
//   final List<InventoryModel>? selectedInventory;

//   const CreateNewInvoice({
//     super.key,
//     this.onBack,
//     this.invoiceModel,
//     this.selectedInventory,
//   });

//   @override
//   CreateNewInvoicePageState createState() => CreateNewInvoicePageState();
// }

// class CreateNewInvoicePageState extends State<CreateNewInvoice> {
//   final customerNameController = TextEditingController();
//   List<InventoryModel> allInventories = [];
//   List<InventoryModel> displayedInventories = [];
//   List<BrandModel> brands = [];
//   List<ProductSubCatorymodel> subCategories = [];
//   List<ProductCategoryModel> productsCategories = [];
//   List<CustomerModel> allCustomers = [];
//   List<CustomerModel> filteredCustomers = [];
//   List<DiscountModel> _discounts = [];

//   bool _isLoadingDiscounts = true;
//   int currentPage = 0;
//   int itemsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       final provider = context.read<SelectedInventoriesProvider>();
//       provider.clearData();
//       if (widget.invoiceModel != null) {
//         final provider = Provider.of<SelectedInventoriesProvider>(
//           context,
//           listen: false,
//         );
//         provider.addAllInventory(widget.selectedInventory ?? []);
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
//                       Expanded(
//                         child: CustomMmTextField(
//                           labelText: 'Invoice Number',
//                           hintText: 'Invoice Number',
//                           controller: provider.generateInvoiceNumberController,
//                           icon: Icons.generating_tokens,
//                           readOnly: true,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: ValidationUtils.invoiceNumber,
//                           onIcon: () {
//                             final random = Random();
//                             final random5Digit = 10000 + random.nextInt(90000);
//                             provider.generateInvoiceNumberController.text =
//                                 random5Digit.toString();
//                           },
//                           onChanged: (value) {
//                             setState(() {
//                               if (value.isNotEmpty) {
//                                 filteredCustomers = allCustomers
//                                     .where(
//                                       (customer) => customer.customerName
//                                           .toLowerCase()
//                                           .contains(value.toLowerCase()),
//                                     )
//                                     .toList();
//                               } else {
//                                 filteredCustomers = [];
//                               }
//                             });
//                           },
//                         ),
//                       ),
//                       12.w,
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
//                     ],
//                   ),
//                   10.h,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomMmTextField(
//                           onTap: () {
//                             provider.pickDate(
//                               context: context,
//                               selectedDate: provider.issueDate,
//                               type: 'issue',
//                             );
//                           },
//                           labelText: 'Issue Date',
//                           hintText: 'Issue Date',
//                           controller: provider.issueDateController,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: ValidationUtils.issueDate,
//                         ),
//                       ),
//                       12.w,
//                       Expanded(
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: CustomMmTextField(
//                                 labelText: 'Payment Terms',
//                                 hintText: 'Payment Terms',
//                                 controller: provider.paymentTermsController,
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                             4.h,
//                             Text('days'),
//                           ],
//                         ),
//                       ),
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
//                       false,
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
