// // import 'package:app/app_theme.dart';
// // import 'package:app/models/discount_model.dart';
// // import 'package:app/models/maintenance/maintenance_booking_model.dart';
// // import 'package:app/modern_motors/models/customer/customer_model.dart';
// // import 'package:app/modern_motors/models/employees/employees_commission_model.dart';
// // import 'package:app/modern_motors/models/inventory/inventory_model.dart';
// // import 'package:app/modern_motors/models/product/product_model.dart';
// // import 'package:app/modern_motors/models/services_maintenance/services_type_model.dart';
// // import 'package:app/modern_motors/models/trucks/mmtrucks_model.dart';
// // import 'package:app/modern_motors/products/build_product_list_screen.dart';
// // import 'package:app/modern_motors/provider/maintenance_provider.dart';
// // import 'package:app/modern_motors/services/data_fetch_service.dart';
// // import 'package:app/modern_motors/widgets/add_commision_form_widget.dart';
// // import 'package:app/modern_motors/widgets/buttons/custom_button.dart';
// // import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// // import 'package:app/modern_motors/widgets/discounts/discount_selector.dart';
// // import 'package:app/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// // import 'package:app/modern_motors/widgets/employee_commission_widget.dart';
// // import 'package:app/modern_motors/widgets/extension.dart';
// // import 'package:app/modern_motors/widgets/form_validation.dart';
// // import 'package:app/modern_motors/widgets/inventory_selection_bridge.dart';
// // import 'package:app/modern_motors/widgets/ish_others_switch.dart';
// // import 'package:app/modern_motors/widgets/page_header_widget.dart';
// // import 'package:app/modern_motors/widgets/selected_items_page.dart';
// // import 'package:app/modern_motors/widgets/two_col_widget.dart';
// // import 'package:app/widgets/overlayloader.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // class CreateMaintenanceBookingPart1 extends StatefulWidget {
// //   final VoidCallback? onBack;
// //   final MaintenanceBookingModel? bookingModel;
// //   final List<InventoryModel>? selectedInventory;
// //   final List<ProductModel>? products;

// //   const CreateMaintenanceBookingPart1({
// //     super.key,
// //     this.onBack,
// //     this.bookingModel,
// //     this.products,
// //     this.selectedInventory,
// //   });

// //   @override
// //   State<CreateMaintenanceBookingPart1> createState() =>
// //       _CreateMaintenanceBookingPart1State();
// // }

// // class _CreateMaintenanceBookingPart1State extends State<CreateMaintenanceBookingPart1> {
// //   final customerNameController = TextEditingController();

// //   // Data
// //   List<CustomerModel> allCustomers = [];
// //   List<CustomerModel> filteredCustomers = [];
// //   List<MmtrucksModel> allTrucks = [];
// //   List<ServiceTypeModel> allServices = [];
// //   List<DiscountModel> allDiscounts = [];

// //   bool _isLoadingDiscounts = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final p = context.read<MaintenanceBookingProvider>();
// //       p.clearData();

// //       if (widget.selectedInventory != null &&
// //           widget.selectedInventory!.isNotEmpty) {
// //         p.addAllInventory(widget.selectedInventory!, widget.products!);
// //       }
// //     });

// //     _loadInitialData();
// //   }

// //   @override
// //   void dispose() {
// //     customerNameController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _loadInitialData() async {
// //     setState(() => _isLoadingDiscounts = true);
// //     try {
// //       final results = await Future.wait([
// //         DataFetchService.fetchDiscount(),
// //         DataFetchService.fetchCustomers(),
// //         DataFetchService.fetchTrucks(),
// //         DataFetchService.fetchServiceTypes(),
// //         DataFetchService.fetchInventory(),
// //       ]);

// //       allDiscounts = results[0] as List<DiscountModel>;
// //       allCustomers = results[1] as List<CustomerModel>;
// //       allTrucks = results[2] as List<MmtrucksModel>;
// //       allServices = results[3] as List<ServiceTypeModel>;
// //       final allInvs = results[4] as List<InventoryModel>; // ✅

// //       WidgetsBinding.instance.addPostFrameCallback((_) async {
// //         if (widget.bookingModel != null) {
// //           final p = context.read<MaintenanceBookingProvider>();

// //           final svcMap = {for (var s in allServices) s.id!: s.name};

// //           p.setFromBooking(widget.bookingModel!, servicesIdToName: svcMap);

// //           final selectedInvs = <InventoryModel>[];
// //           final ids = (widget.bookingModel!.items ?? [])
// //               .map((e) => e.productId)
// //               .toSet();
// //           for (final inv in allInvs) {
// //             if (inv.id != null && ids.contains(inv.id)) selectedInvs.add(inv);
// //           }
// //           p.setSelectedInventoryFromItems(selectedInvs);

// //           if (widget.bookingModel!.customerId != null) {
// //             final cust = allCustomers.firstWhere(
// //               (c) => c.id == widget.bookingModel!.customerId,
// //               orElse: () => CustomerModel(
// //                 customerName: '',
// //                 customerType: '',
// //                 contactNumber: '',
// //                 telePhoneNumber: '',
// //                 streetAddress1: '',
// //                 streetAddress2: '',
// //                 city: '',
// //                 state: '',
// //                 postalCode: '',
// //                 countryId: '',
// //                 accountNumber: '',
// //                 currencyId: '',
// //                 emailAddress: '',
// //                 bankName: '',
// //                 notes: '',
// //                 status: '',
// //                 addedBy: '',
// //                 codeNumber: '',
// //               ),
// //             );
// //             customerNameController.text = cust.customerName;
// //           }

// //           if ((widget.bookingModel!.isDiscountApplied ?? false) &&
// //               (widget.bookingModel!.discountId?.isNotEmpty ?? false)) {
// //             final found = allDiscounts.firstWhere(
// //               (d) => d.id == widget.bookingModel!.discountId,
// //               orElse: () => DiscountModel.getDiscount(), // safe
// //             );
// //             p.setDiscount(
// //               true,
// //               found.id == null ? null : found,
// //               percent: (widget.bookingModel!.discountPercent ?? 0).toDouble(),
// //               isEdit: true,
// //             );
// //           }
// //           await fetchCommission();
// //         }
// //       });
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

// //   Future<void> fetchCommission() async {
// //     try {
// //       final p = context.read<MaintenanceBookingProvider>();

// //       final commSnap = await FirebaseFirestore.instance
// //           .collection('employeeCommissions')
// //           .where('bookingId', isEqualTo: widget.bookingModel!.id)
// //           .limit(1)
// //           .get();
// //       if (commSnap.docs.isNotEmpty) {
// //         final comm = EmployeeCommissionModel.fromDoc(commSnap.docs.first);
// //         p.setEmployeeCommissionModel(comm);
// //         p.setCommission(true);
// //       }
// //     } catch (e) {
// //       debugPrint('Error fetching commission: $e');
// //     }
// //   }

// //   Future<void> _pickBookingDate(MaintenanceBookingProvider p) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: p.bookingDate,
// //       firstDate: DateTime(2023),
// //       lastDate: DateTime(2050),
// //     );
// //     if (picked != null) {
// //       if (!mounted) return;
// //       final t = await showTimePicker(
// //         context: context,
// //         initialTime: TimeOfDay.fromDateTime(p.bookingDate),
// //       );
// //       final finalDt = (t == null)
// //           ? DateTime(picked.year, picked.month, picked.day)
// //           : DateTime(
// //               picked.year,
// //               picked.month,
// //               picked.day,
// //               t.hour,
// //               t.minute,
// //             );

// //       p.setBookingTime(finalDt);
// //     }
// //   }

// //   Future<void> _pickPriceForService({
// //     required MaintenanceBookingProvider p,
// //     required String serviceId,
// //   }) async {
// //     final svc = allServices.firstWhere(
// //       (s) => s.id == serviceId,
// //       orElse: () => ServiceTypeModel(name: ''),
// //     );
// //     final prices =
// //         (svc.prices ?? []).whereType<num>().map((e) => e.toDouble()).toList();
// //     if (prices.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('No prices defined for this service')),
// //       );
// //       return;
// //     }

// //     final chosen = await showModalBottomSheet<double>(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
// //       ),
// //       builder: (_) {
// //         return SafeArea(
// //           child: ListView.separated(
// //             padding: const EdgeInsets.all(16),
// //             itemBuilder: (context, i) {
// //               final price = prices[i];
// //               final isSel = p.selectedServicesWithPrice[serviceId] == price;
// //               return ListTile(
// //                 title: Text(price.toStringAsFixed(2)),
// //                 trailing: isSel
// //                     ? const Icon(Icons.check_circle, color: Colors.green)
// //                     : null,
// //                 onTap: () => Navigator.pop(context, price),
// //               );
// //             },
// //             separatorBuilder: (_, __) => const Divider(height: 1),
// //             itemCount: prices.length,
// //           ),
// //         );
// //       },
// //     );

// //     if (chosen != null) {
// //       p.setServicePrice(serviceId, chosen);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: AppTheme.backgroundGreyColor,
// //       child: Consumer<MaintenanceBookingProvider>(
// //         builder: (context, p, _) {
// //           return p.isItemsSelection
// //               ? SelectItemsPage(bridge: bridgeFromMaintenance(p))
// //               : SingleChildScrollView(
// //                   child: Form(
// //                     key: p.createBookingKey,
// //                     child: OverlayLoader(
// //                       loader: _isLoadingDiscounts,
// //                       child: Column(
// //                         children: [
// //                           PageHeaderWidget(
// //                             title: 'Create Booking',
// //                             buttonText: 'Back to Bookings',
// //                             subTitle: 'Create New Booking',
// //                             onCreateIcon: 'assets/icons/back.png',
// //                             selectedItems: [],
// //                             buttonWidth: 0.4,
// //                             onCreate: widget.onBack!.call,
// //                             onDelete: () async {},
// //                           ),
// //                           20.h,
// //                           _topCard(context, p),
// //                           12.h,
// //                           _middleRow(context, p),
// //                           // 20.h,
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _topCard(BuildContext context, MaintenanceBookingProvider p) {
// //     final serviceItems = {for (var s in allServices) s.id!: s.name};
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
// //             // IshOthersSwitch(
// //             //   value: p.billingParty,
// //             //   onChanged: (mode) => p.setBillingParty(mode),
// //             // ),
// //             16.h,
// //             if (p.selectedServiceNamePairs.isNotEmpty) ...[
// //               Wrap(
// //                 spacing: 8,
// //                 runSpacing: 8,
// //                 children: p.selectedServiceNamePairs.map((entry) {
// //                   final id = entry.key;
// //                   final name = entry.value;
// //                   final chosen = p.selectedServicesWithPrice[id];
// //                   return InputChip(
// //                     label: Text(
// //                       chosen == null
// //                           ? name
// //                           : '$name — ${chosen.toStringAsFixed(2)}',
// //                     ),
// //                     onPressed: () => _pickPriceForService(p: p, serviceId: id),
// //                     onDeleted: () => p.removeService(id),
// //                   );
// //                 }).toList(),
// //               ),
// //               12.h,
// //             ],
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: CustomSearchableDropdown(
// //                     // isMultiSelect: true,
// //                     key: const ValueKey('services_dropdown'),
// //                     hintText: 'Choose Services',
// //                     items: serviceItems,
// //                     value: null,
// //                     selectedValues:
// //                         p.selectedServiceNamePairs.map((e) => e.key).toList(),
// //                     onMultiChanged: (List<MapEntry<String, String>> items) =>
// //                         p.setSelectedServices(items),
// //                     onChanged: (_) {},
// //                   ),
// //                 ),
// //                 if (p.selectedServiceNamePairs.isNotEmpty) ...[
// //                   Expanded(
// //                     child: CustomSearchableDropdown(
// //                       isMultiSelect: true,
// //                       key: const ValueKey('Price_dropdown'),
// //                       hintText: 'Choose Price',
// //                       items: serviceItems,
// //                       value: null,
// //                       selectedValues:
// //                           p.selectedServiceNamePairs.map((e) => e.key).toList(),
// //                       onMultiChanged: (List<MapEntry<String, String>> items) =>
// //                           p.setSelectedServices(items),
// //                       onChanged: (_) {},
// //                     ),
// //                   ),

// //                 ]
// //               ],
// //             ),
// //             10.h,
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: CustomMmTextField(
// //                     labelText: 'Booking Number',
// //                     hintText: 'Booking Number',
// //                     controller: p.generateBookingNumberController,
// //                     icon: Icons.generating_tokens,
// //                     readOnly: true,
// //                     autovalidateMode: _isLoadingDiscounts
// //                         ? AutovalidateMode.disabled
// //                         : AutovalidateMode.onUserInteraction,
// //                     validator: (v) => (v == null || v.isEmpty)
// //                         ? 'Please generate booking number'
// //                         : null,
// //                     onIcon: p.generateRandomBookingNumber,
// //                   ),
// //                 ),
// //                 12.w,
// //                 Expanded(
// //                   child: CustomMmTextField(
// //                     onTap: () => _pickBookingDate(p),
// //                     readOnly: true,
// //                     labelText: 'Booking Date',
// //                     hintText: 'Booking Date',
// //                     controller: p.bookingDateController,
// //                     autovalidateMode: _isLoadingDiscounts
// //                         ? AutovalidateMode.disabled
// //                         : AutovalidateMode.onUserInteraction,
// //                     validator: (v) =>
// //                         (v == null || v.isEmpty) ? 'Select booking date' : null,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             10.h,
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
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
// //                         // Customer overlay (unchanged)
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
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _middleRow(BuildContext context, MaintenanceBookingProvider p) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Expanded(
// //             flex: 4,
// //             child: SelectedItemsList(
// //               contextHeight: context.height,
// //               selectedInventory: p.getSelectedInventory,
// //               selectedProducts: p.productsList,
// //               lines: p.items,
// //               itemsTotal: p.itemsTotal,
// //               onAddItems: () => p.setIsSelection(true),
// //               onIncreaseQty: (index, inv) => p.increaseQuantity(
// //                 index: index,
// //                 context: context,
// //                 inventory: inv,
// //               ),
// //               onDecreaseQty: (index) =>
// //                   p.decreaseQuantity(index: index, context: context),
// //               onRemoveItem: (index) => p.removeInventory(
// //                 p.getSelectedInventory[index],
// //                 p.productsList[index],
// //               ),
// //             ),
// //           ),
// //           10.w,
// //           Expanded(flex: 2, child: _buildBookingSummarySection(context, p)),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildBookingSummarySection(
// //     BuildContext context,
// //     MaintenanceBookingProvider p,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
// //       decoration: BoxDecoration(
// //         color: AppTheme.whiteColor,
// //         border: Border.all(color: AppTheme.borderColor),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'Order Summary:',
// //             style: Theme.of(context).textTheme.titleMedium,
// //           ),
// //           const SizedBox(height: 10),

// //           twoCol('Items Total', p.itemsTotal.toStringAsFixed(2)),
// //           twoCol('Services Total', p.servicesTotal.toStringAsFixed(2)),
// //           twoCol('Discount', '-${p.discountAmount.toStringAsFixed(2)}'),
// //           twoCol('Tax', p.taxAmount.toStringAsFixed(2)),
// //           const Divider(),

// //           // Discount toggle
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               const Text('Apply Discount'),
// //               Switch(
// //                 value: p.getIsDiscountApply,
// //                 onChanged: (v) => p.setDiscount(v, null),
// //               ),
// //             ],
// //           ),

// //           if (p.getIsDiscountApply)
// //             DiscountSelector(
// //               applyDiscount: p.getIsDiscountApply,
// //               isLoadingDiscounts: _isLoadingDiscounts,
// //               discounts: allDiscounts,
// //               selectedDiscount: p.selectedDiscount,
// //               onDiscountSelected: (d) {
// //                 p.setDiscount(
// //                   d.status == "active" ? true : false,
// //                   d,
// //                   percent: (d.discount).toDouble(),
// //                 );
// //               },
// //             ),

// //           // Tax toggle
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               const Text('Apply Tax ?'),
// //               Switch(
// //                 value: p.getIsTaxApply,
// //                 onChanged: (v) => p.setTax(v, p.taxPercent),
// //               ),
// //             ],
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               const Text('Include Commission ?'),
// //               Switch(
// //                 value: p.isCommissionApply,
// //                 onChanged: (v) async {
// //                   if (v && !p.isCommissionApply) {
// //                     final model = await showDialog<EmployeeCommissionModel>(
// //                       context: context,
// //                       barrierDismissible: false,
// //                       builder: (_) => Dialog(
// //                         backgroundColor: AppTheme.whiteColor,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         insetPadding: EdgeInsets.zero,
// //                         child: const AddCommissionFormWidget(),
// //                       ),
// //                     );

// //                     if (model != null) {
// //                       p.setCommission(true);
// //                       p.setEmployeeCommissionModel(model);
// //                     }
// //                   } else if (!v && p.isCommissionApply) {
// //                     p.setCommission(false);
// //                   }
// //                 },
// //               ),
// //             ],
// //           ),

// //           const Divider(),
// //           twoCol('Total', p.total.toStringAsFixed(2)),
// //           const SizedBox(height: 12),
// //           if (p.isCommissionApply) ...[
// //             EmployeeCommissionWidget(
// //               model: p.employeeCommissionModel!,
// //               onTap: () async {
// //                 final edited = await showDialog<EmployeeCommissionModel>(
// //                   context: context,
// //                   barrierDismissible: false,
// //                   builder: (_) => Dialog(
// //                     backgroundColor: AppTheme.whiteColor,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     insetPadding: EdgeInsets.zero,
// //                     child: AddCommissionFormWidget(
// //                       initial: p.employeeCommissionModel,
// //                     ),
// //                   ),
// //                 );

// //                 if (edited != null) {
// //                   p.setCommission(true);
// //                   p.setEmployeeCommissionModel(edited);
// //                 }
// //               },
// //             ),
// //             const SizedBox(height: 12),
// //           ],

// //           SizedBox(
// //             height: 44,
// //             width: 180,
// //             child: CustomButton(
// //               loadingNotifier: p.loading,
// //               text: widget.bookingModel != null
// //                   ? 'Update Booking'
// //                   : 'Create Booking',
// //               onPressed: () {
// //                 if (p.createBookingKey.currentState?.validate() != true) return;
// //                 p.saveBooking(
// //                   context: context,
// //                   onBack: widget.onBack,
// //                   isEdit: widget.bookingModel != null,
// //                 );
// //               },
// //               buttonType: ButtonType.Filled,
// //               backgroundColor: AppTheme.primaryColor,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
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
// import 'package:easy_localization/easy_localization.dart';
// import 'package:provider/provider.dart';

// class ServiceRow {
//   ServiceTypeModel? service;
//   double? selectedPrice;
//   int quantity = 1;
//   double discount = 0;
//   bool applyVat = true;
//   double subtotal = 0;
//   double vatAmount = 0;
//   double total = 0;

//   void calculateTotals() {
//     // Calculate subtotal
//     // Provider p =
//     //     Provider.of<MaintenanceBookingProvider>(context, listen: false);
//     //final p = context.read<MaintenanceBookingProvider>();
//     subtotal = (selectedPrice ?? 0) * quantity;

//     // Apply discount
//     final discountAmount = subtotal * (discount / 100);
//     final amountAfterDiscount = subtotal - discountAmount;

//     // Calculate VAT (5% if applied)
//     vatAmount = applyVat ? amountAfterDiscount * 0.05 : 0;

//     // Calculate final total
//     total = amountAfterDiscount; //+ vatAmount;
//   }
// }

// class ProductRow {
//   ProductModel? product;
//   double? sellingPrice;
//   double margin = 0;
//   int quantity = 1;
//   double discount = 0;
//   bool applyVat = true;
//   double subtotal = 0;
//   double vatAmount = 0;
//   double total = 0;
//   double profit = 0;

//   void calculateTotals() {
//     // Calculate selling price if margin is applied
//     final cost = product?.averageCost ?? 0;
//     if (sellingPrice == null && margin != 0) {
//       sellingPrice = cost * (1 + margin / 100);
//     }

//     // Calculate subtotal
//     subtotal = (sellingPrice ?? cost) * quantity;

//     ///subtotal = p.itemsTotal;
//     // Apply discount
//     final discountAmount = subtotal * (discount / 100);
//     final amountAfterDiscount = subtotal - discountAmount;

//     // Calculate VAT (5% if applied)
//     // vatAmount = applyVat ? amountAfterDiscount * 0.05 : 0;

//     // Calculate final total
//     total = amountAfterDiscount; // + vatAmount;

//     // Calculate profit
//     final totalCost = cost * quantity;
//     profit = total - totalCost - (applyVat ? vatAmount : 0);
//   }
// }

// class CreateMaintenanceBookingPart1 extends StatefulWidget {
//   final VoidCallback? onBack;
//   final MaintenanceBookingModel? bookingModel;
//   final List<InventoryModel>? selectedInventory;
//   final List<ProductModel>? products;

//   const CreateMaintenanceBookingPart1({
//     super.key,
//     this.onBack,
//     this.bookingModel,
//     this.products,
//     this.selectedInventory,
//   });

//   @override
//   State<CreateMaintenanceBookingPart1> createState() =>
//       _CreateMaintenanceBookingPart1State();
// }

// class _CreateMaintenanceBookingPart1State
//     extends State<CreateMaintenanceBookingPart1> {
//   final customerNameController = TextEditingController();
//   final discountController = TextEditingController();
//   // Data
//   List<CustomerModel> allCustomers = [];
//   List<CustomerModel> filteredCustomers = [];
//   List<MmtrucksModel> allTrucks = [];
//   List<ServiceTypeModel> allServices = [];
//   List<DiscountModel> allDiscounts = [];
//   List<ProductModel> allProducts = [];
//   List<ProductRow> productRows = [ProductRow()];
//   double productsGrandTotal = 0;
//   bool loading = false;
//   // Service rows
//   List<ServiceRow> serviceRows = [ServiceRow()];
//   double servicesGrandTotal = 0;

//   bool _isLoadingDiscounts = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final p = context.read<MaintenanceBookingProvider>();
//       p.clearData();
//       DateTime t = DateTime.now();
//       p.setBookingTime(t);
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
//         DataFetchService.fetchProducts(),
//       ]);

//       allDiscounts = results[0] as List<DiscountModel>;
//       allCustomers = results[1] as List<CustomerModel>;
//       allTrucks = results[2] as List<MmtrucksModel>;
//       allServices = results[3] as List<ServiceTypeModel>;
//       final allInvs = results[4] as List<InventoryModel>;
//       allProducts = results[5] as List<ProductModel>;
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         if (widget.bookingModel != null) {
//           final p = context.read<MaintenanceBookingProvider>();

//           // Load existing services if editing
//           if (widget.bookingModel!.serviceTypes != null &&
//               widget.bookingModel!.serviceTypes!.isNotEmpty) {
//             serviceRows.clear();

//             for (var serviceData in widget.bookingModel!.serviceTypes!) {
//               final serviceRow = ServiceRow();
//               final service = allServices.firstWhere(
//                   (s) => s.id == serviceData.serviceId,
//                   orElse: () => ServiceTypeModel(name: 'Unknown'));

//               if (service.name != 'Unknown') {
//                 serviceRow.service = service;
//                 // serviceRow.selectedPrice = serviceData['price']?.toDouble();
//                 // serviceRow.quantity = serviceData['quantity'] ?? 1;
//                 // serviceRow.discount = serviceData['discount']?.toDouble() ?? 0;
//                 // serviceRow.applyVat = serviceData['applyVat'] ?? true;
//                 serviceRow.calculateTotals();
//                 serviceRows.add(serviceRow);
//               }
//             }

//             _calculateGrandTotal();
//           }

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
//               orElse: () => DiscountModel.getDiscount(),
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
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
//       }
//     } finally {
//       if (mounted) setState(() => _isLoadingDiscounts = false);
//     }
//   }

//   void _addProductRow() {
//     setState(() {
//       productRows.add(ProductRow());
//     });
//   }

//   void _removeProductRow(int index, MaintenanceBookingProvider p) {
//     setState(() {
//       if (productRows.length > 1) {
//         productRows.removeAt(index);
//         _calculateProductsGrandTotal();
//       } else {
//         productRows.clear();
//         productsGrandTotal = 0;
//         p.setProductsTotal(0);
//       }
//     });
//     discountController.clear();
//     final discount = double.tryParse(discountController.text) ?? 0;
//     //   // apply discount
//     p.setDiscountPercent(discount);
//   }

//   void _updateProductRow(
//       int index, ProductRow updatedRow, MaintenanceBookingProvider p) {
//     setState(() {
//       productRows[index] = updatedRow;
//       _calculateProductsGrandTotal();
//     });
//     discountController.clear();
//     final discount = double.tryParse(discountController.text) ?? 0;
//     //   // apply discount
//     p.setDiscountPercent(discount);
//   }

//   void _calculateProductsGrandTotal() {
//     productsGrandTotal = productRows.fold(0, (sum, row) => sum + row.total);

//     // Update the provider with the new products total
//     final p = context.read<MaintenanceBookingProvider>();
//     // p.setProductsTotal(productsGrandTotal); // Uncomment if you have this method
//   }

//   Widget _productSelectionSection(
//       BuildContext context, MaintenanceBookingProvider p) {
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

//             // Product rows header
//             const Row(
//               children: [
//                 Expanded(
//                     flex: 2,
//                     child: Text('Product',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Price',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Margin %',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Qty',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Discount',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Subtotal',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 // Expanded(
//                 //     flex: 1,
//                 //     child: Text('VAT',
//                 //         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Total',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 SizedBox(width: 40),
//               ],
//             ),
//             const SizedBox(height: 8),

//             // Product rows
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: productRows.length,
//               itemBuilder: (context, index) {
//                 return ProductRowWidget(
//                   productRow: productRows[index],
//                   allProducts: allProducts,
//                   index: index,
//                   onUpdate: (updatedRow) =>
//                       _updateProductRow(index, updatedRow, p),
//                   onRemove: () => _removeProductRow(index, p),
//                   showRemoveButton: true, //productRows.length > 1,
//                 );
//               },
//             ),

//             const SizedBox(height: 16),

//             // Add product button
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

//             // Grand total
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

//   void _addServiceRow() {
//     setState(() {
//       serviceRows.add(ServiceRow());
//     });
//   }

//   void _removeServiceRow(int index, MaintenanceBookingProvider p) {
//     setState(() {
//       if (serviceRows.length > 1) {
//         serviceRows.removeAt(index);
//         _calculateGrandTotal();
//       } else {
//         serviceRows.clear();
//         p.setServicesTotal(0);
//         servicesGrandTotal = 0;
//       }
//     });
//     discountController.text = "0";
//     final discount = double.tryParse(discountController.text) ?? 0;
//     //   // apply discount
//     p.setDiscountPercent(discount);
//   }

//   void _updateServiceRow(
//       int index, ServiceRow updatedRow, MaintenanceBookingProvider p) {
//     setState(() {
//       serviceRows[index] = updatedRow;
//       _calculateGrandTotal();
//     });
//     discountController.text = "0";
//     final discount = double.tryParse(discountController.text) ?? 0;
//     //   // apply discount
//     p.setDiscountPercent(discount);
//   }

//   void _calculateGrandTotal() {
//     servicesGrandTotal = serviceRows.fold(0, (sum, row) => sum + row.total);

//     // Update the provider with the new services total
//     final p = context.read<MaintenanceBookingProvider>();
//     //needs attention
//     // p.setServicesTotal(servicesGrandTotal);
//   }

//   Future<void> fetchCommission() async {
//     try {
//       final p = context.read<MaintenanceBookingProvider>();

//       final commSnap = await FirebaseFirestore.instance
//           .collection('mmEmployeeCommissions')
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
//                           _serviceSelectionSection(context, p),
//                           12.h,
//                           _productSelectionSection(context, p),
//                           12.h,
//                           _middleRow(context, p),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//         },
//       ),
//     );
//   }

//   Widget _serviceSelectionSection(
//       BuildContext context, MaintenanceBookingProvider p) {
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
//               'Services',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             // Service rows header
//             const Row(
//               children: [
//                 Expanded(
//                     flex: 2,
//                     child: Text('Service',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 2,
//                     child: Text('Price',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Qty',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Discount',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Subtotal',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 // Expanded(
//                 //     flex: 1,
//                 //     child: Text('VAT',
//                 //         style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(
//                     flex: 1,
//                     child: Text('Total',
//                         style: TextStyle(fontWeight: FontWeight.bold))),
//                 SizedBox(width: 40),
//               ],
//             ),
//             const SizedBox(height: 8),

//             // Service rows
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: serviceRows.length,
//               itemBuilder: (context, index) {
//                 return ServiceRowWidget(
//                     serviceRow: serviceRows[index],
//                     allServices: allServices,
//                     index: index,
//                     onUpdate: (updatedRow) =>
//                         _updateServiceRow(index, updatedRow, p),
//                     onRemove: () => _removeServiceRow(index, p),
//                     showRemoveButton: true //serviceRows.length > 1,
//                     );
//               },
//             ),

//             const SizedBox(height: 16),

//             // Add service button
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton.icon(
//                 onPressed: _addServiceRow,
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add Service'),
//               ),
//             ),

//             const SizedBox(height: 16),
//             const Divider(),

//             // Grand total
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Services Grand Total:',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'OMR ${servicesGrandTotal.toStringAsFixed(2)}',
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

//   Widget _topCard(BuildContext context, MaintenanceBookingProvider p) {
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
//             16.h,
//             Row(
//               children: [
//                 // Expanded(
//                 //   child: CustomMmTextField(
//                 //     labelText: 'Booking Number',
//                 //     hintText: 'Booking Number',
//                 //     controller: p.generateBookingNumberController,
//                 //     icon: Icons.generating_tokens,
//                 //     readOnly: true,
//                 //     autovalidateMode: _isLoadingDiscounts
//                 //         ? AutovalidateMode.disabled
//                 //         : AutovalidateMode.onUserInteraction,
//                 //     validator: (v) => (v == null || v.isEmpty)
//                 //         ? 'Please generate booking number'
//                 //         : null,
//                 //     onIcon: p.generateRandomBookingNumber,
//                 //   ),
//                 // ),
//                 // 12.w,
//                 // Expanded(
//                 //   child: CustomMmTextField(
//                 //     onTap: () => _pickBookingDate(p),
//                 //     readOnly: true,
//                 //     labelText: 'Booking Date',
//                 //     hintText: 'Booking Date',
//                 //     controller: p.bookingDateController,
//                 //     autovalidateMode: _isLoadingDiscounts
//                 //         ? AutovalidateMode.disabled
//                 //         : AutovalidateMode.onUserInteraction,
//                 //     validator: (v) =>
//                 //         (v == null || v.isEmpty) ? 'Select booking date' : null,
//                 //   ),
//                 // ),
//               ],
//             ),
//             10.h,
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
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
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           // Expanded(
//           //   flex: 4,
//           //   child: SelectedItemsList(
//           //     contextHeight: context.height,
//           //     selectedInventory: p.getSelectedInventory,
//           //     selectedProducts: p.productsList,
//           //     lines: p.items,
//           //     itemsTotal: p.itemsTotal,
//           //     onAddItems: () => p.setIsSelection(true),
//           //     onIncreaseQty: (index, inv) => p.increaseQuantity(
//           //       index: index,
//           //       context: context,
//           //       inventory: inv,
//           //     ),
//           //     onDecreaseQty: (index) =>
//           //         p.decreaseQuantity(index: index, context: context),
//           //     onRemoveItem: (index) => p.removeInventory(
//           //       p.getSelectedInventory[index],
//           //       p.productsList[index],
//           //     ),
//           //   ),
//           // ),
//           //10.w,
//           // Expanded(flex: 6, child: _buildBookingSummarySection(context, p)),
//           SizedBox(
//             width: 500,
//             child: _buildBookingSummarySection(context, p),
//           )
//         ],
//       ),
//     );
//   }

//   // Widget _buildBookingSummarySection(
//   //   BuildContext context,
//   //   MaintenanceBookingProvider p,
//   // ) {
//   //   return Container(
//   //     padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//   //     decoration: BoxDecoration(
//   //       color: AppTheme.whiteColor,
//   //       border: Border.all(color: AppTheme.borderColor),
//   //       borderRadius: BorderRadius.circular(12),
//   //     ),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Text(
//   //           'Order Summary:',
//   //           style: Theme.of(context).textTheme.titleMedium,
//   //         ),
//   //         const SizedBox(height: 10),

//   //         twoCol('Items Total', p.itemsTotal.toStringAsFixed(2)),
//   //         twoCol('Services Total', servicesGrandTotal.toStringAsFixed(2)),
//   //         twoCol('Products Total', productsGrandTotal.toStringAsFixed(2)),
//   //         twoCol('Discount', '-OMR ${p.discountAmount.toStringAsFixed(2)}'),
//   //         twoCol('Tax', p.taxAmount.toStringAsFixed(2)),
//   //         const Divider(),

//   //         // Discount toggle
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             const Text('Apply Discount'),
//   //             Switch(
//   //               value: p.getIsDiscountApply,
//   //               onChanged: (v) => p.setDiscount(v, null),
//   //             ),
//   //           ],
//   //         ),

//   //         if (p.getIsDiscountApply)
//   //           DiscountSelector(
//   //             applyDiscount: p.getIsDiscountApply,
//   //             isLoadingDiscounts: _isLoadingDiscounts,
//   //             discounts: allDiscounts,
//   //             selectedDiscount: p.selectedDiscount,
//   //             onDiscountSelected: (d) {
//   //               p.setDiscount(
//   //                 d.status == "active" ? true : false,
//   //                 d,
//   //                 percent: (d.discount).toDouble(),
//   //               );
//   //             },
//   //           ),

//   //         // Tax toggle
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             const Text('Apply Tax ?'),
//   //             Switch(
//   //               value: p.getIsTaxApply,
//   //               onChanged: (v) => p.setTax(v, p.taxPercent),
//   //             ),
//   //           ],
//   //         ),
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             const Text('Include Commission ?'),
//   //             Switch(
//   //               value: p.isCommissionApply,
//   //               onChanged: (v) async {
//   //                 if (v && !p.isCommissionApply) {
//   //                   final model = await showDialog<EmployeeCommissionModel>(
//   //                     context: context,
//   //                     barrierDismissible: false,
//   //                     builder: (_) => Dialog(
//   //                       backgroundColor: AppTheme.whiteColor,
//   //                       shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(12),
//   //                       ),
//   //                       insetPadding: EdgeInsets.zero,
//   //                       child: const AddCommissionFormWidget(),
//   //                     ),
//   //                   );

//   //                   if (model != null) {
//   //                     p.setCommission(true);
//   //                     p.setEmployeeCommissionModel(model);
//   //                   }
//   //                 } else if (!v && p.isCommissionApply) {
//   //                   p.setCommission(false);
//   //                 }
//   //               },
//   //             ),
//   //           ],
//   //         ),

//   //         const Divider(),
//   //         twoCol(
//   //             'Total',
//   //             (servicesGrandTotal +
//   //                     productsGrandTotal - // Add this line
//   //                     p.discountAmount +
//   //                     p.taxAmount)
//   //                 .toStringAsFixed(2)),
//   //         const SizedBox(height: 12),
//   //         if (p.isCommissionApply) ...[
//   //           EmployeeCommissionWidget(
//   //             model: p.employeeCommissionModel!,
//   //             onTap: () async {
//   //               final edited = await showDialog<EmployeeCommissionModel>(
//   //                 context: context,
//   //                 barrierDismissible: false,
//   //                 builder: (_) => Dialog(
//   //                   backgroundColor: AppTheme.whiteColor,
//   //                   shape: RoundedRectangleBorder(
//   //                     borderRadius: BorderRadius.circular(12),
//   //                   ),
//   //                   insetPadding: EdgeInsets.zero,
//   //                   child: AddCommissionFormWidget(
//   //                     initial: p.employeeCommissionModel,
//   //                   ),
//   //                 ),
//   //               );

//   //               if (edited != null) {
//   //                 p.setCommission(true);
//   //                 p.setEmployeeCommissionModel(edited);
//   //               }
//   //             },
//   //           ),
//   //           const SizedBox(height: 12),
//   //         ],

//   //         SizedBox(
//   //           height: 44,
//   //           width: 180,
//   //           child: CustomButton(
//   //             loadingNotifier: p.loading,
//   //             text: widget.bookingModel != null
//   //                 ? 'Update Booking'
//   //                 : 'Create Booking',
//   //             onPressed: () {
//   //               if (p.createBookingKey.currentState?.validate() != true) return;

//   //               // Prepare services data for saving
//   //               final servicesData = serviceRows.map((row) {
//   //                 return {
//   //                   'serviceId': row.service?.id,
//   //                   'serviceName': row.service?.name,
//   //                   'price': row.selectedPrice,
//   //                   'quantity': row.quantity,
//   //                   'discount': row.discount,
//   //                   'applyVat': row.applyVat,
//   //                   'subtotal': row.subtotal,
//   //                   'vatAmount': row.vatAmount,
//   //                   'total': row.total,
//   //                 };
//   //               }).toList();

//   //               p.saveBooking(
//   //                 context: context,
//   //                 onBack: widget.onBack,
//   //                 isEdit: widget.bookingModel != null,
//   //                 //needs attention
//   //                 //services: servicesData,
//   //               );
//   //             },
//   //             buttonType: ButtonType.Filled,
//   //             backgroundColor: AppTheme.primaryColor,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget _buildBookingSummarySection(
//   //   BuildContext context,
//   //   MaintenanceBookingProvider p,
//   // ) {
//   //   // Calculate totals
//   //   final double subtotal = servicesGrandTotal + productsGrandTotal;
//   //   p.itemsTotal = subtotal;
//   //   final double discountAmount = p.discountAmount;
//   //   final double amountAfterDiscount = subtotal - discountAmount;
//   //   final double taxAmount =
//   //       p.getIsTaxApply ? amountAfterDiscount * (p.taxPercent / 100) : 0;
//   //   final double total = amountAfterDiscount + taxAmount;

//   //   return Container(
//   //     padding: const EdgeInsets.all(16),
//   //     decoration: BoxDecoration(
//   //       color: AppTheme.whiteColor,
//   //       border: Border.all(color: AppTheme.borderColor),
//   //       borderRadius: BorderRadius.circular(12),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black.withOpacity(0.05),
//   //           blurRadius: 8,
//   //           offset: const Offset(0, 4),
//   //         ),
//   //       ],
//   //     ),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Text(
//   //           'Order Summary',
//   //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//   //                 fontWeight: FontWeight.bold,
//   //                 color: AppTheme.primaryColor,
//   //               ),
//   //         ),
//   //         const SizedBox(height: 16),

//   //         // Summary items
//   //         _buildSummaryItem('Services Total', servicesGrandTotal),
//   //         _buildSummaryItem('Products Total', productsGrandTotal),
//   //         const Divider(),

//   //         _buildSummaryItem('Subtotal', subtotal, isBold: true),
//   //         _buildSummaryItem('Discount Amount', -discountAmount,
//   //             isNegative: true),
//   //         _buildSummaryItem('Amount After Discount', amountAfterDiscount,
//   //             isBold: true),
//   //         if (p.getIsTaxApply) _buildSummaryItem('Tax Amount', taxAmount),
//   //         const SizedBox(height: 8),
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             const Text('Apply Discount'),
//   //             Switch(
//   //               value: p.getIsDiscountApply,
//   //               onChanged: (v) => p.setDiscount(v, null),
//   //             ),
//   //           ],
//   //         ),
//   //         // Discount section
//   //         Row(
//   //           children: [
//   //             Expanded(
//   //               flex: 2,
//   //               child: Text(
//   //                 'Discount',
//   //                 style: TextStyle(
//   //                   fontSize: 14,
//   //                   fontWeight: FontWeight.w500,
//   //                   color: Colors.grey[700],
//   //                 ),
//   //               ),
//   //             ),
//   //             Expanded(
//   //               flex: 3,
//   //               child: Row(
//   //                 children: [
//   //                   Expanded(
//   //                     child: TextFormField(
//   //                       // initialValue: p.discountAmount.toStringAsFixed(2),
//   //                       // controller: discountController,
//   //                       decoration: InputDecoration(
//   //                         hintText: '0.00',
//   //                         border: const OutlineInputBorder(),
//   //                         contentPadding: const EdgeInsets.symmetric(
//   //                             horizontal: 8, vertical: 4),
//   //                         prefixText: 'OMR ',
//   //                       ),
//   //                       keyboardType:
//   //                           TextInputType.numberWithOptions(decimal: true),
//   //                       // onChanged: (value) {
//   //                       //   final discount = double.tryParse(value) ?? 0;
//   //                       //   //needs attention
//   //                       //   p.setDiscountAmount(discount);
//   //                       // },
//   //                       onEditingComplete: () {
//   //                         final discount =
//   //                             double.tryParse(discountController.text) ?? 0;
//   //                         //needs attention
//   //                         p.setDiscountAmount(discount);
//   //                       },
//   //                     ),
//   //                   ),
//   //                   const SizedBox(width: 8),
//   //                   SizedBox(
//   //                     width: 60,
//   //                     child: TextFormField(
//   //                       // initialValue: p.discountPercent.toStringAsFixed(1),
//   //                       controller: discountController,
//   //                       decoration: InputDecoration(
//   //                         hintText: '%',
//   //                         border: const OutlineInputBorder(),
//   //                         contentPadding: const EdgeInsets.symmetric(
//   //                             horizontal: 8, vertical: 4),
//   //                         suffixText: '%',
//   //                       ),
//   //                       keyboardType:
//   //                           TextInputType.numberWithOptions(decimal: true),
//   //                       // onChanged: (value) {
//   //                       //   final percent = double.tryParse(value) ?? 0;
//   //                       //   p.setDiscountPercent(percent);
//   //                       // },
//   //                       onEditingComplete: () {
//   //                         final discount =
//   //                             double.tryParse(discountController.text) ?? 0;
//   //                         //needs attention
//   //                         p.setDiscountPercent(discount);
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         ),

//   //         // _buildSummaryItem('Discount Amount', -discountAmount,
//   //         //     isNegative: true),
//   //         // _buildSummaryItem('Amount After Discount', amountAfterDiscount,
//   //         //     isBold: true),
//   //         const SizedBox(height: 8),

//   //         // Tax section
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             Text(
//   //               'Tax (${p.taxPercent}%)',
//   //               style: TextStyle(
//   //                 fontSize: 14,
//   //                 fontWeight: FontWeight.w500,
//   //                 color: Colors.grey[700],
//   //               ),
//   //             ),
//   //             Switch(
//   //               value: p.getIsTaxApply,
//   //               onChanged: (v) => p.setTax(v, p.taxPercent),
//   //             ),
//   //           ],
//   //         ),

//   //         if (p.getIsTaxApply) _buildSummaryItem('Tax Amount', taxAmount),

//   //         const Divider(thickness: 2),

//   //         // Total
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             Text(
//   //               'TOTAL',
//   //               style: TextStyle(
//   //                 fontSize: 16,
//   //                 fontWeight: FontWeight.bold,
//   //                 color: AppTheme.primaryColor,
//   //               ),
//   //             ),
//   //             //totalAmount
//   //             Text(
//   //               'OMR ${total.toStringAsFixed(2)}',
//   //               style: TextStyle(
//   //                 fontSize: 18,
//   //                 fontWeight: FontWeight.bold,
//   //                 color: AppTheme.primaryColor,
//   //               ),
//   //             ),
//   //           ],
//   //         ),

//   //         const SizedBox(height: 16),
//   //         const Divider(),

//   //         // Commission toggle
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             Text(
//   //               'Include Commission',
//   //               style: TextStyle(
//   //                 fontSize: 14,
//   //                 fontWeight: FontWeight.w500,
//   //                 color: Colors.grey[700],
//   //               ),
//   //             ),
//   //             Switch(
//   //               value: p.isCommissionApply,
//   //               onChanged: (v) async {
//   //                 if (v && !p.isCommissionApply) {
//   //                   final model = await showDialog<EmployeeCommissionModel>(
//   //                     context: context,
//   //                     barrierDismissible: false,
//   //                     builder: (_) => Dialog(
//   //                       backgroundColor: AppTheme.whiteColor,
//   //                       shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(12),
//   //                       ),
//   //                       insetPadding: EdgeInsets.zero,
//   //                       child: const AddCommissionFormWidget(),
//   //                     ),
//   //                   );

//   //                   if (model != null) {
//   //                     p.setCommission(true);
//   //                     p.setEmployeeCommissionModel(model);
//   //                   }
//   //                 } else if (!v && p.isCommissionApply) {
//   //                   p.setCommission(false);
//   //                 }
//   //               },
//   //             ),
//   //           ],
//   //         ),

//   //         if (p.isCommissionApply) ...[
//   //           const SizedBox(height: 12),
//   //           EmployeeCommissionWidget(
//   //             model: p.employeeCommissionModel!,
//   //             onTap: () async {
//   //               final edited = await showDialog<EmployeeCommissionModel>(
//   //                 context: context,
//   //                 barrierDismissible: false,
//   //                 builder: (_) => Dialog(
//   //                   backgroundColor: AppTheme.whiteColor,
//   //                   shape: RoundedRectangleBorder(
//   //                     borderRadius: BorderRadius.circular(12),
//   //                   ),
//   //                   insetPadding: EdgeInsets.zero,
//   //                   child: AddCommissionFormWidget(
//   //                     initial: p.employeeCommissionModel,
//   //                   ),
//   //                 ),
//   //               );

//   //               if (edited != null) {
//   //                 p.setCommission(true);
//   //                 p.setEmployeeCommissionModel(edited);
//   //               }
//   //             },
//   //           ),
//   //         ],

//   //         const SizedBox(height: 20),

//   //         // Create/Update button
//   //         Center(
//   //           child: SizedBox(
//   //             height: 50,
//   //             width: 200,
//   //             child: CustomButton(
//   //               loadingNotifier: p.loading,
//   //               text: widget.bookingModel != null
//   //                   ? 'Update Booking'
//   //                   : 'Create Booking',
//   //               onPressed: () {
//   //                 if (p.createBookingKey.currentState?.validate() != true)
//   //                   return;

//   //                 // Prepare services data for saving
//   //                 final servicesData = serviceRows.map((row) {
//   //                   return {
//   //                     'serviceId': row.service?.id,
//   //                     'serviceName': row.service?.name,
//   //                     'price': row.selectedPrice,
//   //                     'quantity': row.quantity,
//   //                     'discount': row.discount,
//   //                     'applyVat': row.applyVat,
//   //                     'subtotal': row.subtotal,
//   //                     'vatAmount': row.vatAmount,
//   //                     'total': row.total,
//   //                   };
//   //                 }).toList();

//   //                 p.saveBooking(
//   //                   context: context,
//   //                   onBack: widget.onBack,
//   //                   isEdit: widget.bookingModel != null,
//   //                   //need attention
//   //                   // services: servicesData,
//   //                 );
//   //               },
//   //               buttonType: ButtonType.Filled,
//   //               backgroundColor: AppTheme.primaryColor,
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildBookingSummarySection(
//     BuildContext context,
//     MaintenanceBookingProvider p,
//   ) {
//     // Calculate totals
//     final double subtotal = servicesGrandTotal + productsGrandTotal;
//     p.itemsTotal = productsGrandTotal;
//     //p.servicesTotal = servicesGrandTotal;
//     p.setServicesTotal(servicesGrandTotal);
//     p.setSubtotal(subtotal);
//     final double discountAmount = p.discountAmount;
//     final double amountAfterDiscount = subtotal - discountAmount;
//     final double taxAmount =
//         p.getIsTaxApply ? amountAfterDiscount * (p.taxPercent / 100) : 0;
//     final double total = amountAfterDiscount + taxAmount;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 24,
//             offset: const Offset(0, 4),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Section
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: const BoxDecoration(
//               color: Color(0xFF1A1D29),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.receipt_long_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Booking Summary',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Review your order details',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white.withOpacity(0.7),
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Container(
//                 //   padding:
//                 //       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 //   decoration: BoxDecoration(
//                 //     color: const Color(0xFFFFF3CD),
//                 //     borderRadius: BorderRadius.circular(20),
//                 //     border: Border.all(
//                 //       color: const Color(0xFFFFE69C),
//                 //       width: 1,
//                 //     ),
//                 //   ),
//                 //   child: Row(
//                 //     mainAxisSize: MainAxisSize.min,
//                 //     children: [
//                 //       Container(
//                 //         width: 8,
//                 //         height: 8,
//                 //         decoration: const BoxDecoration(
//                 //           color: Color(0xFFFF8C00),
//                 //           shape: BoxShape.circle,
//                 //         ),
//                 //       ),
//                 //       const SizedBox(width: 6),
//                 //       const Text(
//                 //         'DRAFT',
//                 //         style: TextStyle(
//                 //           fontSize: 12,
//                 //           fontWeight: FontWeight.w600,
//                 //           color: Color(0xFF8B5A00),
//                 //           letterSpacing: 0.5,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),

//           // Content Section
//           Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Order Items Section
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8F9FA),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: const Color(0xFFE9ECEF),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.list_alt_rounded,
//                             size: 20,
//                             color: Color(0xFF495057),
//                           ),
//                           const SizedBox(width: 8),
//                           const Text(
//                             'Order Items',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF212529),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildOrderItem(
//                         'Services',
//                         servicesGrandTotal,
//                         Icons.build_circle_outlined,
//                         const Color(0xFF0D6EFD),
//                       ),
//                       const SizedBox(height: 12),
//                       _buildOrderItem(
//                         'Products',
//                         productsGrandTotal,
//                         Icons.inventory_2_outlined,
//                         const Color(0xFF198754),
//                       ),
//                       const SizedBox(height: 16),
//                       Container(
//                         height: 1,
//                         color: const Color(0xFFDEE2E6),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Subtotal',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF212529),
//                             ),
//                           ),
//                           Text(
//                             'OMR ${subtotal - discountAmount}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF212529),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Pricing Details
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: const Color(0xFFE9ECEF),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       // Discount Section

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Apply Tax',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF212529),
//                             ),
//                           ),
//                           Switch(
//                             value: p.getIsTaxApply,
//                             onChanged: (v) => p.setTax(v, p.taxPercent),
//                           ),
//                         ],
//                       ),
//                       // Tax Section
//                       if (p.getIsTaxApply) ...[
//                         _buildPricingRow(
//                           'Tax (${p.taxPercent.toStringAsFixed(1)}%)',
//                           'OMR ${taxAmount.toStringAsFixed(2)}',
//                           const Color(0xFF6C757D),
//                           Icons.receipt_outlined,
//                         ),
//                         const SizedBox(height: 12),
//                       ],

//                       // Commission Section
//                       // _buildCommissionSection(context, p),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 //_buildDiscountSection(context, p, p.subtotal),
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8F9FA),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: const Color(0xFFE9ECEF),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (p.discountAmount > 0) ...[
//                         _buildPricingRow(
//                           'Discount Applied',
//                           '-OMR ${p.discountAmount.toStringAsFixed(2)}',
//                           const Color(0xFFDC3545),
//                           Icons.local_offer_outlined,
//                         ),
//                         const SizedBox(height: 12),
//                       ],
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF198754).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.local_offer_rounded,
//                               size: 18,
//                               color: Color(0xFF198754),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           const Expanded(
//                             child: Text(
//                               'Apply Discount',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF212529),
//                               ),
//                             ),
//                           ),
//                           if (p.discountAmount > 0)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF198754),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 'OMR ${p.discountAmount.toStringAsFixed(2)} OFF',
//                                 style: const TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: discountController,
//                               decoration: InputDecoration(
//                                 hintText: 'Enter discount amount',
//                                 hintStyle: TextStyle(
//                                   color: Colors.grey.shade500,
//                                   fontSize: 14,
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.percent_sharp,
//                                   size: 20,
//                                   color: Color(0xFF6C757D),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: const BorderSide(
//                                     color: Color(0xFFDEE2E6),
//                                   ),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: const BorderSide(
//                                     color: Color(0xFFDEE2E6),
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: const BorderSide(
//                                     color: Color(0xFF198754),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 12,
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                               ),
//                               keyboardType: TextInputType.number,
//                               // onChanged: (value) {
//                               //   final discount = double.tryParse(value) ?? 0;
//                               //   // apply discount
//                               //   p.setDiscountPercent(discount);
//                               // },
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Container(
//                             height: 48,
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF198754),
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color:
//                                       const Color(0xFF198754).withOpacity(0.2),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: TextButton(
//                               onPressed: () {
//                                 final discount =
//                                     double.tryParse(discountController.text) ??
//                                         0;
//                                 //   // apply discount
//                                 p.setDiscountPercent(discount);
//                               },
//                               style: TextButton.styleFrom(
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.zero,
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.check_rounded,
//                                     size: 18,
//                                   ),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     'Apply',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (p.discountAmount > 0) ...[
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.info_outline_rounded,
//                               size: 16,
//                               color: Color(0xFF198754),
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Discount of OMR ${p.discountAmount.toStringAsFixed(2)} applied successfully',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF198754),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Total Section
//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xFF1A1D29),
//                         Color(0xFF2C3142),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF1A1D29).withOpacity(0.3),
//                         blurRadius: 16,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.account_balance_wallet_outlined,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'GRAND TOTAL',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                                 letterSpacing: 1.0,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Inclusive of all charges',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.white.withOpacity(0.7),
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'OMR ${total.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white,
//                               letterSpacing: -0.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 // Action Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 60,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLoadingDiscounts = true;
//                       });
//                       // if (p.createBookingKey.currentState?.validate() != true)
//                       //   return;
//                       double d = double.tryParse(discountController.text) ?? 0;
//                       // Prepare services data for saving
//                       final servicesData = serviceRows.map((row) {
//                         return {
//                           'serviceId': row.service?.id,
//                           'serviceName': row.service?.name,
//                           'price': row.selectedPrice,
//                           'quantity': row.quantity,
//                           'discount': row.discount,
//                           'applyVat': row.applyVat,
//                           'subtotal': row.subtotal,
//                           'vatAmount': row.vatAmount,
//                           'total': row.total,
//                         };
//                       }).toList();
//                       final productsData = productRows.map((row) {
//                         return {
//                           'productId': row.product?.id,
//                           'productName': row.product?.productName,
//                           'sellingPrice': row.sellingPrice,
//                           'margin': row.margin,
//                           'quantity': row.quantity,
//                           'discount': row.discount,
//                           'applyVat': row.applyVat,
//                           'subtotal': row.subtotal,
//                           'vatAmount': row.vatAmount,
//                           'total': row.total,
//                           'profit': row.profit,
//                         };
//                       }).toList();
//                       p.saveBooking(
//                           //servicesData: servicesData,
//                           productsData: productsData,
//                           context: context,
//                           onBack: widget.onBack,
//                           isEdit: widget.bookingModel != null,
//                           totalRevenue: total,
//                           discount: d,
//                           taxAmount: taxAmount);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0D6EFD),
//                       foregroundColor: Colors.white,
//                       elevation: 8,
//                       shadowColor: const Color(0xFF0D6EFD).withOpacity(0.3),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: p.loading.value
//                         ? const SizedBox(
//                             width: 28,
//                             height: 28,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 3,
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 widget.bookingModel != null
//                                     ? Icons.update_rounded
//                                     : Icons.add_circle_outline_rounded,
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 widget.bookingModel != null
//                                     ? 'Update Booking'
//                                     : 'Create Booking',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: -0.3,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItem(
//       String title, double amount, IconData icon, Color color) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             size: 18,
//             color: color,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF495057),
//             ),
//           ),
//         ),
//         Text(
//           'OMR ${amount.toStringAsFixed(2)}',
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF212529),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPricingRow(
//       String title, String amount, Color color, IconData icon) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: color,
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: color,
//             ),
//           ),
//         ),
//         Text(
//           amount,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }
// }

// Widget _buildDiscountSection(
//     BuildContext context, MaintenanceBookingProvider p, double subtotal) {
//   return Container(
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: const Color(0xFFF8F9FA),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(
//         color: const Color(0xFFE9ECEF),
//         width: 1,
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (p.discountAmount > 0) ...[
//           _buildPricingRow(
//             'Discount Applied',
//             '-OMR ${p.discountAmount.toStringAsFixed(2)}',
//             const Color(0xFFDC3545),
//             Icons.local_offer_outlined,
//           ),
//           const SizedBox(height: 12),
//         ],
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF198754).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.local_offer_rounded,
//                 size: 18,
//                 color: Color(0xFF198754),
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 'Apply Discount',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF212529),
//                 ),
//               ),
//             ),
//             if (p.discountAmount > 0)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF198754),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   'OMR ${p.discountAmount.toStringAsFixed(2)} OFF',
//                   style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   hintText: 'Enter discount amount',
//                   hintStyle: TextStyle(
//                     color: Colors.grey.shade500,
//                     fontSize: 14,
//                   ),
//                   prefixIcon: const Icon(
//                     Icons.percent_sharp,
//                     size: 20,
//                     color: Color(0xFF6C757D),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(
//                       color: Color(0xFFDEE2E6),
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(
//                       color: Color(0xFFDEE2E6),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(
//                       color: Color(0xFF198754),
//                       width: 2,
//                     ),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   final discount = double.tryParse(value) ?? 0;
//                   // apply discount
//                   p.setDiscountPercent(discount);
//                 },
//               ),
//             ),
//             const SizedBox(width: 12),
//             Container(
//               height: 48,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF198754),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF198754).withOpacity(0.2),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextButton(
//                 onPressed: () {
//                   // Apply discount logic
//                 },
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.zero,
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.check_rounded,
//                       size: 18,
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       'Apply',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (p.discountAmount > 0) ...[
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               const Icon(
//                 Icons.info_outline_rounded,
//                 size: 16,
//                 color: Color(0xFF198754),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Discount of OMR ${p.discountAmount.toStringAsFixed(2)} applied successfully',
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF198754),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ],
//     ),
//   );
// }

// Widget _buildOrderItem(
//     String title, double amount, IconData icon, Color color) {
//   return Row(
//     children: [
//       Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           icon,
//           size: 18,
//           color: color,
//         ),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF495057),
//           ),
//         ),
//       ),
//       Text(
//         'OMR ${amount.toStringAsFixed(2)}',
//         style: const TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w600,
//           color: Color(0xFF212529),
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildPricingRow(
//     String title, String amount, Color color, IconData icon) {
//   return Row(
//     children: [
//       Icon(
//         icon,
//         size: 16,
//         color: color,
//       ),
//       const SizedBox(width: 8),
//       Expanded(
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: color,
//           ),
//         ),
//       ),
//       Text(
//         amount,
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: color,
//         ),
//       ),
//     ],
//   );
// }

// // Helper method for summary items
// Widget _buildSummaryItem(String label, double amount,
//     {bool isBold = false, bool isNegative = false}) {
//   final Color amountColor =
//       isNegative ? Colors.red : (isBold ? AppTheme.primaryColor : Colors.black);

//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             color: Colors.grey[700],
//           ),
//         ),
//         Text(
//           'OMR ${amount.toStringAsFixed(2)}',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             color: amountColor,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class ServiceRowWidget extends StatefulWidget {
//   final ServiceRow serviceRow;
//   final List<ServiceTypeModel> allServices;
//   final int index;
//   final Function(ServiceRow) onUpdate;
//   final VoidCallback onRemove;
//   final bool showRemoveButton;

//   const ServiceRowWidget({
//     super.key,
//     required this.serviceRow,
//     required this.allServices,
//     required this.index,
//     required this.onUpdate,
//     required this.onRemove,
//     required this.showRemoveButton,
//   });

//   @override
//   State<ServiceRowWidget> createState() => _ServiceRowWidgetState();
// }

// class _ServiceRowWidgetState extends State<ServiceRowWidget> {
//   final List<double> discountOptions = [
//     0,
//     1,
//     2,
//     3,
//     4,
//     5,
//     6,
//     7,
//     8,
//     9,
//     10,
//     11,
//     12,
//     13,
//     14,
//     15,
//     16,
//     17,
//     18,
//     19,
//     20,
//     25,
//     30,
//     35,
//     40,
//   ];
//   final List<int> quantityOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

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
//           // Service Dropdown
//           Expanded(
//             flex: 2,
//             child: _buildServiceDropdown(),
//           ),
//           const SizedBox(width: 8),

//           // Price Dropdown
//           Expanded(
//             flex: 2,
//             child: _buildPriceDropdown(),
//           ),
//           const SizedBox(width: 8),

//           // Quantity Dropdown
//           Expanded(
//             flex: 1,
//             child: _buildQuantityDropdown(),
//           ),
//           const SizedBox(width: 8),

//           // Discount Dropdown
//           Expanded(
//             flex: 1,
//             child: _buildDiscountDropdown(),
//           ),
//           const SizedBox(width: 8),

//           // Subtotal
//           Expanded(
//             flex: 1,
//             child: _buildAmountDisplay(
//                 'OMR ${widget.serviceRow.subtotal.toStringAsFixed(2)}'),
//           ),
//           const SizedBox(width: 8),

//           // VAT Toggle
//           // Expanded(
//           //   flex: 1,
//           //   child: _buildVatToggle(),
//           // ),
//           // const SizedBox(width: 8),

//           // Total
//           Expanded(
//             flex: 1,
//             child: _buildAmountDisplay(
//                 'OMR ${widget.serviceRow.total.toStringAsFixed(2)}',
//                 isTotal: true),
//           ),
//           const SizedBox(width: 8),

//           // Remove Button
//           if (widget.showRemoveButton)
//             IconButton(
//               icon:
//                   const Icon(Icons.remove_circle, color: Colors.red, size: 20),
//               onPressed: widget.onRemove,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildServiceDropdown() {
//     // Convert services to a map for the dropdown
//     final Map<String, String> serviceMap = {
//       for (var service in widget.allServices)
//         service.id ?? service.name: service.name
//     };

//     return CustomSearchableDropdown(
//       hintText: 'Select Service',
//       items: serviceMap,
//       value: widget.serviceRow.service?.id ?? widget.serviceRow.service?.name,
//       onChanged: (value) {
//         final selected = widget.allServices.firstWhere(
//           (service) => service.id == value || service.name == value,
//           orElse: () => ServiceTypeModel(name: ''),
//         );

//         if (selected.name.isNotEmpty) {
//           setState(() {
//             widget.serviceRow.service = selected;
//             widget.serviceRow.selectedPrice = null;
//             widget.serviceRow.calculateTotals();
//             widget.onUpdate(widget.serviceRow);
//           });
//         }
//       },
//     );
//   }

//   Widget _buildPriceDropdown() {
//     // Get available prices for selected service
//     final prices = widget.serviceRow.service?.prices ?? [];

//     // If no service selected or no prices, show disabled dropdown
//     if (widget.serviceRow.service == null || prices.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(4),
//           color: Colors.grey[100],
//         ),
//         child: const Text(
//           'Select service',
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       );
//     }

//     // Create price options map
//     final Map<String, String> priceOptions = {};
//     for (var price in prices) {
//       if (price is num) {
//         final priceValue = price.toDouble();
//         priceOptions[priceValue.toString()] =
//             'OMR ${priceValue.toStringAsFixed(2)}';
//       }
//     }

//     return CustomSearchableDropdown(
//       hintText: 'Select Price',
//       items: priceOptions,
//       value: widget.serviceRow.selectedPrice?.toString(),
//       onChanged: (value) {
//         if (value != null) {
//           setState(() {
//             widget.serviceRow.selectedPrice = double.parse(value);
//             widget.serviceRow.calculateTotals();
//             widget.onUpdate(widget.serviceRow);
//           });
//         }
//       },
//     );
//   }

//   Widget _buildQuantityDropdown() {
//     // Create quantity options map
//     final Map<String, String> quantityOptionsMap = {};
//     for (var quantity in quantityOptions) {
//       quantityOptionsMap[quantity.toString()] = quantity.toString();
//     }

//     return CustomSearchableDropdown(
//       hintText: 'Qty',
//       items: quantityOptionsMap,
//       value: widget.serviceRow.quantity.toString(),
//       onChanged: (value) {
//         if (value != null) {
//           setState(() {
//             widget.serviceRow.quantity = int.parse(value);
//             widget.serviceRow.calculateTotals();
//             widget.onUpdate(widget.serviceRow);
//           });
//         }
//       },
//     );
//   }

//   Widget _buildDiscountDropdown() {
//     // Create discount options map
//     final Map<String, String> discountOptionsMap = {};
//     for (var discount in discountOptions) {
//       discountOptionsMap[discount.toString()] = '$discount%';
//     }

//     return CustomSearchableDropdown(
//       hintText: 'Discount',
//       items: discountOptionsMap,
//       value: widget.serviceRow.discount.toString(),
//       onChanged: (value) {
//         if (value != null) {
//           setState(() {
//             widget.serviceRow.discount = double.parse(value);
//             widget.serviceRow.calculateTotals();
//             widget.onUpdate(widget.serviceRow);
//           });
//         }
//       },
//     );
//   }

//   Widget _buildVatToggle() {
//     return Row(
//       children: [
//         Checkbox(
//           value: widget.serviceRow.applyVat,
//           onChanged: (value) {
//             setState(() {
//               widget.serviceRow.applyVat = value ?? false;
//               widget.serviceRow.calculateTotals();
//               widget.onUpdate(widget.serviceRow);
//             });
//           },
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
//         const Text('VAT', style: TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildAmountDisplay(String amount, {bool isTotal = false}) {
//     return Text(
//       amount,
//       style: TextStyle(
//         fontSize: 12,
//         fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//         color: isTotal ? AppTheme.primaryColor : Colors.black,
//       ),
//     );
//   }
// }

// class ProductRowWidget extends StatefulWidget {
//   final ProductRow productRow;
//   final List<ProductModel> allProducts;
//   final int index;
//   final Function(ProductRow) onUpdate;
//   final VoidCallback onRemove;
//   final bool showRemoveButton;

//   const ProductRowWidget({
//     super.key,
//     required this.productRow,
//     required this.allProducts,
//     required this.index,
//     required this.onUpdate,
//     required this.onRemove,
//     required this.showRemoveButton,
//   });

//   @override
//   State<ProductRowWidget> createState() => _ProductRowWidgetState();
// }

// class _ProductRowWidgetState extends State<ProductRowWidget> {
//   final List<double> discountOptions = [
//     0,
//     1,
//     2,
//     3,
//     4,
//     5,
//     6,
//     7,
//     8,
//     9,
//     10,
//     15,
//     20,
//     25
//   ];
//   final List<int> quantityOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _marginController = TextEditingController();
//   final FocusNode _priceFocusNode = FocusNode();
//   final FocusNode _marginFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _updateControllers();
//     _priceFocusNode.addListener(_onPriceFocusChange);
//     _marginFocusNode.addListener(_onMarginFocusChange);
//   }

//   @override
//   void dispose() {
//     _priceFocusNode.removeListener(_onPriceFocusChange);
//     _marginFocusNode.dispose();
//     _marginFocusNode.removeListener(_onMarginFocusChange);
//     _marginFocusNode.dispose();
//     _priceController.dispose();
//     _marginController.dispose();
//     _priceController.dispose();
//     _marginController.dispose();
//     super.dispose();
//   }

//   void _onPriceFocusChange() {
//     if (!_priceFocusNode.hasFocus) {
//       // Lost focus (Tab pressed or clicked elsewhere)
//       _updatePriceFromField();
//     }
//   }

//   void _onMarginFocusChange() {
//     if (!_marginFocusNode.hasFocus) {
//       // Lost focus (Tab pressed or clicked elsewhere)
//       _updateMarginFromField();
//     }
//   }

//   void _updatePriceFromField() {
//     if (_priceController.text.isNotEmpty) {
//       final newPrice = double.tryParse(_priceController.text) ?? 0;
//       widget.productRow.sellingPrice = newPrice;

//       final cost = widget.productRow.product?.minimumPrice ?? 0;
//       if (cost > 0) {
//         widget.productRow.margin = ((newPrice - cost) / cost) * 100;
//         _marginController.text = widget.productRow.margin.toStringAsFixed(2);
//       }

//       widget.productRow.calculateTotals();
//       widget.onUpdate(widget.productRow);
//     }
//   }

//   void _updateMarginFromField() {
//     if (_marginController.text.isNotEmpty) {
//       final newMargin = double.tryParse(_marginController.text) ?? 0;
//       widget.productRow.margin = newMargin;

//       final cost = widget.productRow.product?.minimumPrice ?? 0;
//       widget.productRow.sellingPrice = cost * (1 + newMargin / 100);
//       _priceController.text =
//           widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '0.00';

//       widget.productRow.calculateTotals();
//       widget.onUpdate(widget.productRow);
//     }
//   }

//   @override
//   void didUpdateWidget(ProductRowWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _updateControllers();
//   }

//   void _updateControllers() {
//     _priceController.text =
//         widget.productRow.sellingPrice?.toStringAsFixed(2) ?? '';
//     _marginController.text = widget.productRow.margin.toStringAsFixed(2);
//   }

//   Widget _buildPriceInput() {
//     return TextFormField(
//       controller: _priceController,
//       focusNode: _priceFocusNode,
//       decoration: const InputDecoration(
//         labelText: 'Price (OMR)',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       textInputAction: TextInputAction.next, // Shows "Next" button on keyboard
//       onEditingComplete: () {
//         // This triggers when user presses "Next" or "Done"
//         _updatePriceFromField();
//         // Move focus to next field (margin field)
//         FocusScope.of(context).requestFocus(_marginFocusNode);
//       },
//     );
//   }

//   Widget _buildMarginInput() {
//     return TextFormField(
//       controller: _marginController,
//       focusNode: _marginFocusNode,
//       decoration: const InputDecoration(
//         labelText: 'Margin %',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         suffixText: '%',
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       textInputAction:
//           TextInputAction.next, // Or TextInputAction.done for last field
//       onEditingComplete: () {
//         // This triggers when user presses "Next" or "Done"
//         _updateMarginFromField();
//         // Move focus to next field (quantity dropdown)
//         // You'll need to add focus nodes to other fields too
//         FocusScope.of(context).nextFocus();
//       },
//     );
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
//           // Product Dropdown
//           Expanded(
//             flex: 2,
//             child: _buildProductDropdown(),
//           ),
//           const SizedBox(width: 8),

//           // Price Input
//           Expanded(
//             flex: 1,
//             child: _buildPriceInput(),
//           ),
//           const SizedBox(width: 8),

//           // Margin Input
//           Expanded(
//             flex: 1,
//             child: _buildMarginInput(),
//           ),
//           const SizedBox(width: 8),

//           // Quantity Dropdown
//           Expanded(
//             flex: 1,
//             child: _buildQuantityDropdown(),
//           ),
//           const SizedBox(width: 8),

//           // Discount Dropdown
//           Expanded(
//             flex: 1,
//             child: _buildDiscountDropdown(),
//           ),
//           const SizedBox(width: 8),

//           // Subtotal
//           Expanded(
//             flex: 1,
//             child: _buildAmountDisplay(
//                 'OMR ${widget.productRow.subtotal.toStringAsFixed(2)}'),
//           ),
//           const SizedBox(width: 8),

//           // VAT Toggle
//           // Expanded(
//           //   flex: 1,
//           //   child: _buildVatToggle(),
//           // ),
//           // const SizedBox(width: 8),

//           // Total
//           Expanded(
//             flex: 1,
//             child: _buildAmountDisplay(
//                 'OMR ${widget.productRow.total.toStringAsFixed(2)}',
//                 isTotal: true),
//           ),
//           const SizedBox(width: 8),

//           // Remove Button
//           if (widget.showRemoveButton)
//             IconButton(
//               icon:
//                   const Icon(Icons.remove_circle, color: Colors.red, size: 20),
//               onPressed: widget.onRemove,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductDropdown() {
//     // Convert products to a map for the dropdown
//     final Map<String, String> productMap = {
//       for (var product in widget.allProducts)
//         product.id ?? product.productName!: product.productName!
//     };

//     return CustomSearchableDropdown(
//       hintText: 'Select Product',
//       items: productMap,
//       value: widget.productRow.product?.id ??
//           widget.productRow.product?.productName,
//       onChanged: (value) {
//         if (value != null) {
//           final selected = widget.allProducts.firstWhere(
//             (product) => product.id == value || product.productName == value,
//             orElse: () => ProductModel(productName: ''),
//           );

//           if (selected.productName!.isNotEmpty) {
//             setState(() {
//               widget.productRow.product = selected;
//               // Set initial selling price to average cost
//               widget.productRow.sellingPrice = selected.minimumPrice;
//               widget.productRow.margin = 0;
//               _updateControllers();
//               widget.productRow.calculateTotals();
//               widget.onUpdate(widget.productRow);
//             });
//           }
//         }
//       },
//     );
//   }

//   // Widget _buildPriceInput() {
//   //   return TextFormField(
//   //     controller: _priceController,
//   //     decoration: const InputDecoration(
//   //       labelText: 'Price (OMR)',
//   //       border: OutlineInputBorder(),
//   //       contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//   //     ),
//   //     keyboardType: TextInputType.number,
//   //     onChanged: (value) {
//   //       if (value.isNotEmpty) {
//   //         //setState(() {
//   //         widget.productRow.sellingPrice = double.tryParse(value) ?? 0;
//   //         // Calculate margin based on cost and selling price
//   //         final cost = widget.productRow.product?.minimumPrice ?? 0;
//   //         if (cost > 0) {
//   //           widget.productRow.margin =
//   //               ((widget.productRow.sellingPrice! - cost) / cost) * 100;
//   //           _marginController.text =
//   //               widget.productRow.margin.toStringAsFixed(2);
//   //         }
//   //         widget.productRow.calculateTotals();
//   //         widget.onUpdate(widget.productRow);
//   //         // });
//   //       }
//   //     },
//   //   );
//   // }

//   Widget _buildQuantityDropdown() {
//     // Create quantity options map
//     final Map<String, String> quantityOptionsMap = {};
//     for (var quantity in quantityOptions) {
//       quantityOptionsMap[quantity.toString()] = quantity.toString();
//     }

//     return CustomSearchableDropdown(
//       hintText: 'Qty',
//       items: quantityOptionsMap,
//       value: widget.productRow.quantity.toString(),
//       onChanged: (value) {
//         if (value != null) {
//           setState(() {
//             widget.productRow.quantity = int.parse(value);
//             widget.productRow.calculateTotals();
//             widget.onUpdate(widget.productRow);
//           });
//         }
//       },
//     );
//   }

//   Widget _buildDiscountDropdown() {
//     // Create discount options map
//     final Map<String, String> discountOptionsMap = {};
//     for (var discount in discountOptions) {
//       discountOptionsMap[discount.toString()] = '$discount%';
//     }

//     return CustomSearchableDropdown(
//       hintText: 'Discount',
//       items: discountOptionsMap,
//       value: widget.productRow.discount.toString(),
//       onChanged: (value) {
//         if (value != null) {
//           setState(() {
//             widget.productRow.discount = double.parse(value);
//             widget.productRow.calculateTotals();
//             widget.onUpdate(widget.productRow);
//           });
//         }
//       },
//     );
//   }

//   Widget _buildVatToggle() {
//     return Row(
//       children: [
//         Checkbox(
//           value: widget.productRow.applyVat,
//           onChanged: (value) {
//             setState(() {
//               widget.productRow.applyVat = value ?? false;
//               widget.productRow.calculateTotals();
//               widget.onUpdate(widget.productRow);
//             });
//           },
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
//         const Text('VAT', style: TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildAmountDisplay(String amount, {bool isTotal = false}) {
//     return Text(
//       amount,
//       style: TextStyle(
//         fontSize: 12,
//         fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//         color: isTotal ? AppTheme.primaryColor : Colors.black,
//       ),
//     );
//   }
// }
