// import 'package:app/app_theme.dart';
// import 'package:app/models/discount_model.dart';
// import 'package:app/models/maintenance/maintenance_booking_model.dart';
// import 'package:app/modern_motors/models/customer/customer_model.dart';
// import 'package:app/modern_motors/models/employees/employees_commission_model.dart';
// import 'package:app/modern_motors/models/inventory/inventory_model.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/models/services_maintenance/services_type_model.dart';
// import 'package:app/modern_motors/models/trucks/mmtrucks_model.dart';
// import 'package:app/modern_motors/products/build_product_list_screen.dart';
// import 'package:app/modern_motors/provider/maintenance_provider.dart';
// import 'package:app/modern_motors/services/data_fetch_service.dart';
// import 'package:app/modern_motors/widgets/add_commision_form_widget.dart';
// import 'package:app/modern_motors/widgets/buttons/custom_button.dart';
// import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:app/modern_motors/widgets/discounts/discount_selector.dart';
// import 'package:app/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// import 'package:app/modern_motors/widgets/employee_commission_widget.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/form_validation.dart';
// import 'package:app/modern_motors/widgets/inventory_selection_bridge.dart';
// import 'package:app/modern_motors/widgets/ish_others_switch.dart';
// import 'package:app/modern_motors/widgets/page_header_widget.dart';
// import 'package:app/modern_motors/widgets/selected_items_page.dart';
// import 'package:app/modern_motors/widgets/two_col_widget.dart';
// import 'package:app/widgets/overlayloader.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CreateMaintenanceBookingOriginal extends StatefulWidget {
//   final VoidCallback? onBack;
//   final MaintenanceBookingModel? bookingModel;
//   final List<InventoryModel>? selectedInventory;
//   final List<ProductModel>? products;

//   const CreateMaintenanceBookingOriginal({
//     super.key,
//     this.onBack,
//     this.bookingModel,
//     this.products,
//     this.selectedInventory,
//   });

//   @override
//   State<CreateMaintenanceBookingOriginal> createState() =>
//       _CreateMaintenanceBookingOriginalState();
// }

// class _CreateMaintenanceBookingOriginalState
//     extends State<CreateMaintenanceBookingOriginal> {
//   final customerNameController = TextEditingController();

//   // Data
//   List<CustomerModel> allCustomers = [];
//   List<CustomerModel> filteredCustomers = [];
//   List<MmtrucksModel> allTrucks = [];
//   List<ServiceTypeModel> allServices = [];
//   List<DiscountModel> allDiscounts = [];

//   bool _isLoadingDiscounts = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final p = context.read<MaintenanceBookingProvider>();
//       p.clearData();

//       if (widget.selectedInventory != null &&
//           widget.selectedInventory!.isNotEmpty) {
//         p.addAllInventory(widget.selectedInventory!, widget.products!);
//       }
//     });

//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     customerNameController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadInitialData() async {
//     setState(() => _isLoadingDiscounts = true);
//     try {
//       final results = await Future.wait([
//         DataFetchService.fetchDiscount(),
//         DataFetchService.fetchCustomers(),
//         DataFetchService.fetchTrucks(),
//         DataFetchService.fetchServiceTypes(),
//         DataFetchService.fetchInventory(),
//       ]);

//       allDiscounts = results[0] as List<DiscountModel>;
//       allCustomers = results[1] as List<CustomerModel>;
//       allTrucks = results[2] as List<MmtrucksModel>;
//       allServices = results[3] as List<ServiceTypeModel>;
//       final allInvs = results[4] as List<InventoryModel>; // ✅

//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         if (widget.bookingModel != null) {
//           final p = context.read<MaintenanceBookingProvider>();

//           final svcMap = {for (var s in allServices) s.id!: s.name};

//           p.setFromBooking(widget.bookingModel!, servicesIdToName: svcMap);

//           final selectedInvs = <InventoryModel>[];
//           final ids = (widget.bookingModel!.items ?? [])
//               .map((e) => e.productId)
//               .toSet();
//           for (final inv in allInvs) {
//             if (inv.id != null && ids.contains(inv.id)) selectedInvs.add(inv);
//           }
//           p.setSelectedInventoryFromItems(selectedInvs);

//           if (widget.bookingModel!.customerId != null) {
//             final cust = allCustomers.firstWhere(
//               (c) => c.id == widget.bookingModel!.customerId,
//               orElse: () => CustomerModel(
//                 customerName: '',
//                 customerType: '',
//                 contactNumber: '',
//                 telePhoneNumber: '',
//                 streetAddress1: '',
//                 streetAddress2: '',
//                 city: '',
//                 state: '',
//                 postalCode: '',
//                 countryId: '',
//                 accountNumber: '',
//                 currencyId: '',
//                 emailAddress: '',
//                 bankName: '',
//                 notes: '',
//                 status: '',
//                 addedBy: '',
//                 codeNumber: '',
//               ),
//             );
//             customerNameController.text = cust.customerName;
//           }

//           if ((widget.bookingModel!.isDiscountApplied ?? false) &&
//               (widget.bookingModel!.discountId?.isNotEmpty ?? false)) {
//             final found = allDiscounts.firstWhere(
//               (d) => d.id == widget.bookingModel!.discountId,
//               orElse: () => DiscountModel.getDiscount(), // safe
//             );
//             p.setDiscount(
//               true,
//               found.id == null ? null : found,
//               percent: (widget.bookingModel!.discountPercent ?? 0).toDouble(),
//               isEdit: true,
//             );
//           }
//           await fetchCommission();
//         }
//       });
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

//   Future<void> fetchCommission() async {
//     try {
//       final p = context.read<MaintenanceBookingProvider>();

//       final commSnap = await FirebaseFirestore.instance
//           .collection('employeeCommissions')
//           .where('bookingId', isEqualTo: widget.bookingModel!.id)
//           .limit(1)
//           .get();
//       if (commSnap.docs.isNotEmpty) {
//         final comm = EmployeeCommissionModel.fromDoc(commSnap.docs.first);
//         p.setEmployeeCommissionModel(comm);
//         p.setCommission(true);
//       }
//     } catch (e) {
//       debugPrint('Error fetching commission: $e');
//     }
//   }

//   Future<void> _pickBookingDate(MaintenanceBookingProvider p) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: p.bookingDate,
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2050),
//     );
//     if (picked != null) {
//       if (!mounted) return;
//       final t = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(p.bookingDate),
//       );
//       final finalDt = (t == null)
//           ? DateTime(picked.year, picked.month, picked.day)
//           : DateTime(
//               picked.year,
//               picked.month,
//               picked.day,
//               t.hour,
//               t.minute,
//             );

//       p.setBookingTime(finalDt);
//     }
//   }

//   Future<void> _pickPriceForService({
//     required MaintenanceBookingProvider p,
//     required String serviceId,
//   }) async {
//     final svc = allServices.firstWhere(
//       (s) => s.id == serviceId,
//       orElse: () => ServiceTypeModel(name: ''),
//     );
//     final prices =
//         (svc.prices ?? []).whereType<num>().map((e) => e.toDouble()).toList();
//     if (prices.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No prices defined for this service')),
//       );
//       return;
//     }

//     final chosen = await showModalBottomSheet<double>(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return SafeArea(
//           child: ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemBuilder: (context, i) {
//               final price = prices[i];
//               final isSel = p.selectedServicesWithPrice[serviceId] == price;
//               return ListTile(
//                 title: Text(price.toStringAsFixed(2)),
//                 trailing: isSel
//                     ? const Icon(Icons.check_circle, color: Colors.green)
//                     : null,
//                 onTap: () => Navigator.pop(context, price),
//               );
//             },
//             separatorBuilder: (_, __) => const Divider(height: 1),
//             itemCount: prices.length,
//           ),
//         );
//       },
//     );

//     if (chosen != null) {
//       p.setServicePrice(serviceId, chosen);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppTheme.backgroundGreyColor,
//       child: Consumer<MaintenanceBookingProvider>(
//         builder: (context, p, _) {
//           return p.isItemsSelection
//               ? SelectItemsPage(bridge: bridgeFromMaintenance(p))
//               : SingleChildScrollView(
//                   child: Form(
//                     key: p.createBookingKey,
//                     child: OverlayLoader(
//                       loader: _isLoadingDiscounts,
//                       child: Column(
//                         children: [
//                           PageHeaderWidget(
//                             title: 'Create Booking',
//                             buttonText: 'Back to Bookings',
//                             subTitle: 'Create New Booking',
//                             onCreateIcon: 'assets/icons/back.png',
//                             selectedItems: [],
//                             buttonWidth: 0.4,
//                             onCreate: widget.onBack!.call,
//                             onDelete: () async {},
//                           ),
//                           20.h,
//                           _topCard(context, p),
//                           12.h,
//                           _middleRow(context, p),
//                           // 20.h,
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//         },
//       ),
//     );
//   }

//   Widget _topCard(BuildContext context, MaintenanceBookingProvider p) {
//     final serviceItems = {for (var s in allServices) s.id!: s.name};
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
//             IshOthersSwitch(
//               value: p.billingParty,
//               onChanged: (mode) => p.setBillingParty(mode),
//             ),
//             16.h,
//             if (p.selectedServiceNamePairs.isNotEmpty) ...[
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: p.selectedServiceNamePairs.map((entry) {
//                   final id = entry.key;
//                   final name = entry.value;
//                   final chosen = p.selectedServicesWithPrice[id];
//                   return InputChip(
//                     label: Text(
//                       chosen == null
//                           ? name
//                           : '$name — ${chosen.toStringAsFixed(2)}',
//                     ),
//                     onPressed: () => _pickPriceForService(p: p, serviceId: id),
//                     onDeleted: () => p.removeService(id),
//                   );
//                 }).toList(),
//               ),
//               12.h,
//             ],
//             Row(
//               children: [
//                 Expanded(
//                   child: CustomSearchableDropdown(
//                     isMultiSelect: true,
//                     key: const ValueKey('services_dropdown'),
//                     hintText: 'Choose Services',
//                     items: serviceItems,
//                     value: null,
//                     selectedValues:
//                         p.selectedServiceNamePairs.map((e) => e.key).toList(),
//                     onMultiChanged: (List<MapEntry<String, String>> items) =>
//                         p.setSelectedServices(items),
//                     onChanged: (_) {},
//                   ),
//                 ),
//                 if (p.selectedServiceNamePairs.isNotEmpty) ...[
//                   Expanded(
//                     child: CustomSearchableDropdown(
//                       isMultiSelect: true,
//                       key: const ValueKey('Price_dropdown'),
//                       hintText: 'Choose Price',
//                       items: serviceItems,
//                       value: null,
//                       selectedValues:
//                           p.selectedServiceNamePairs.map((e) => e.key).toList(),
//                       onMultiChanged: (List<MapEntry<String, String>> items) =>
//                           p.setSelectedServices(items),
//                       onChanged: (_) {},
//                     ),
//                   ),
//                 ]
//               ],
//             ),
//             10.h,
//             Row(
//               children: [
//                 Expanded(
//                   child: CustomMmTextField(
//                     labelText: 'Booking Number',
//                     hintText: 'Booking Number',
//                     controller: p.generateBookingNumberController,
//                     icon: Icons.generating_tokens,
//                     readOnly: true,
//                     autovalidateMode: _isLoadingDiscounts
//                         ? AutovalidateMode.disabled
//                         : AutovalidateMode.onUserInteraction,
//                     validator: (v) => (v == null || v.isEmpty)
//                         ? 'Please generate booking number'
//                         : null,
//                     onIcon: p.generateRandomBookingNumber,
//                   ),
//                 ),
//                 12.w,
//                 Expanded(
//                   child: CustomMmTextField(
//                     onTap: () => _pickBookingDate(p),
//                     readOnly: true,
//                     labelText: 'Booking Date',
//                     hintText: 'Booking Date',
//                     controller: p.bookingDateController,
//                     autovalidateMode: _isLoadingDiscounts
//                         ? AutovalidateMode.disabled
//                         : AutovalidateMode.onUserInteraction,
//                     validator: (v) =>
//                         (v == null || v.isEmpty) ? 'Select booking date' : null,
//                   ),
//                 ),
//               ],
//             ),
//             10.h,
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (p.billingParty != BillingParty.ish) ...[
//                   Expanded(
//                     child: Column(
//                       children: [
//                         CustomMmTextField(
//                           labelText: 'Customer Name',
//                           hintText: 'Customer Name',
//                           controller: customerNameController,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: ValidationUtils.customerName,
//                           onChanged: (value) {
//                             setState(() {
//                               if (value.isNotEmpty) {
//                                 filteredCustomers = allCustomers
//                                     .where(
//                                       (c) => c.customerName
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
//                         // Customer overlay (unchanged)
//                         if (filteredCustomers.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Material(
//                               elevation: 4,
//                               borderRadius: BorderRadius.circular(8),
//                               child: Container(
//                                 padding: const EdgeInsets.only(
//                                   left: 6,
//                                   right: 6,
//                                   top: 10,
//                                 ),
//                                 height: 150,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color: Colors.grey.shade300,
//                                   ),
//                                 ),
//                                 child: ListView.builder(
//                                   itemCount: filteredCustomers.length,
//                                   padding: EdgeInsets.zero,
//                                   itemBuilder: (context, index) {
//                                     final c = filteredCustomers[index];
//                                     return Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         InkWell(
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 6.0,
//                                               vertical: 8,
//                                             ),
//                                             child: Text(c.customerName),
//                                           ),
//                                           onTap: () {
//                                             p.setCustomer(id: c.id!);
//                                             setState(() {
//                                               customerNameController.text =
//                                                   c.customerName;
//                                               filteredCustomers.clear();
//                                             });
//                                           },
//                                         ),
//                                         if (index !=
//                                             filteredCustomers.length - 1)
//                                           const Divider(height: 1),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   12.w,
//                 ],
//                 Expanded(
//                   child: CustomSearchableDropdown(
//                     key: const ValueKey('truck_dropdown'),
//                     hintText: 'Choose Truck',
//                     value: p.truckId,
//                     items: {
//                       for (var t in allTrucks.where(
//                         (t) => t.ownById == p.customerId,
//                       ))
//                         t.id!: '${t.code}-${t.plateNumber}',
//                     },
//                     onChanged: (val) => p.setTruckId(val),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _middleRow(BuildContext context, MaintenanceBookingProvider p) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 4,
//             child: SelectedItemsList(
//               contextHeight: context.height,
//               selectedInventory: p.getSelectedInventory,
//               selectedProducts: p.productsList,
//               lines: p.items,
//               itemsTotal: p.itemsTotal,
//               onAddItems: () => p.setIsSelection(true),
//               onIncreaseQty: (index, inv) => p.increaseQuantity(
//                 index: index,
//                 context: context,
//                 inventory: inv,
//               ),
//               onDecreaseQty: (index) =>
//                   p.decreaseQuantity(index: index, context: context),
//               onRemoveItem: (index) => p.removeInventory(
//                 p.getSelectedInventory[index],
//                 p.productsList[index],
//               ),
//             ),
//           ),
//           10.w,
//           Expanded(flex: 2, child: _buildBookingSummarySection(context, p)),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingSummarySection(
//     BuildContext context,
//     MaintenanceBookingProvider p,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//       decoration: BoxDecoration(
//         color: AppTheme.whiteColor,
//         border: Border.all(color: AppTheme.borderColor),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Order Summary:',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           const SizedBox(height: 10),

//           twoCol('Items Total', p.itemsTotal.toStringAsFixed(2)),
//           twoCol('Services Total', p.servicesTotal.toStringAsFixed(2)),
//           twoCol('Discount', '-${p.discountAmount.toStringAsFixed(2)}'),
//           twoCol('Tax', p.taxAmount.toStringAsFixed(2)),
//           const Divider(),

//           // Discount toggle
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Apply Discount'),
//               Switch(
//                 value: p.getIsDiscountApply,
//                 onChanged: (v) => p.setDiscount(v, null),
//               ),
//             ],
//           ),

//           if (p.getIsDiscountApply)
//             DiscountSelector(
//               applyDiscount: p.getIsDiscountApply,
//               isLoadingDiscounts: _isLoadingDiscounts,
//               discounts: allDiscounts,
//               selectedDiscount: p.selectedDiscount,
//               onDiscountSelected: (d) {
//                 p.setDiscount(
//                   d.status == "active" ? true : false,
//                   d,
//                   percent: (d.discount).toDouble(),
//                 );
//               },
//             ),

//           // Tax toggle
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Apply Tax ?'),
//               Switch(
//                 value: p.getIsTaxApply,
//                 onChanged: (v) => p.setTax(v, p.taxPercent),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Include Commission ?'),
//               Switch(
//                 value: p.isCommissionApply,
//                 onChanged: (v) async {
//                   if (v && !p.isCommissionApply) {
//                     final model = await showDialog<EmployeeCommissionModel>(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (_) => Dialog(
//                         backgroundColor: AppTheme.whiteColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         insetPadding: EdgeInsets.zero,
//                         child: const AddCommissionFormWidget(),
//                       ),
//                     );

//                     if (model != null) {
//                       p.setCommission(true);
//                       p.setEmployeeCommissionModel(model);
//                     }
//                   } else if (!v && p.isCommissionApply) {
//                     p.setCommission(false);
//                   }
//                 },
//               ),
//             ],
//           ),

//           const Divider(),
//           twoCol('Total', p.total.toStringAsFixed(2)),
//           const SizedBox(height: 12),
//           if (p.isCommissionApply) ...[
//             EmployeeCommissionWidget(
//               model: p.employeeCommissionModel!,
//               onTap: () async {
//                 final edited = await showDialog<EmployeeCommissionModel>(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (_) => Dialog(
//                     backgroundColor: AppTheme.whiteColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     insetPadding: EdgeInsets.zero,
//                     child: AddCommissionFormWidget(
//                       initial: p.employeeCommissionModel,
//                     ),
//                   ),
//                 );

//                 if (edited != null) {
//                   p.setCommission(true);
//                   p.setEmployeeCommissionModel(edited);
//                 }
//               },
//             ),
//             const SizedBox(height: 12),
//           ],

//           SizedBox(
//             height: 44,
//             width: 180,
//             child: CustomButton(
//               loadingNotifier: p.loading,
//               text: widget.bookingModel != null
//                   ? 'Update Booking'
//                   : 'Create Booking',
//               onPressed: () {
//                 if (p.createBookingKey.currentState?.validate() != true) return;
//                 // p.saveBooking(
//                 //   context: context,
//                 //   onBack: widget.onBack,
//                 //   isEdit: widget.bookingModel != null,
//                 // );
//               },
//               buttonType: ButtonType.Filled,
//               backgroundColor: AppTheme.primaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
