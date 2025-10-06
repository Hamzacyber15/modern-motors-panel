// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/estimates_models/estimates_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/modern_motors/products/build_product_list_screen.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/discounts/discount_selector.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/inventory_selection_bridge.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/selected_items_page.dart';
import 'package:modern_motors_panel/provider/estimation_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

class MakeEstimation extends StatefulWidget {
  final VoidCallback? onBack;
  final EstimationModel? estimationModel;
  final List<ProductModel>? products;
  final List<InventoryModel>? selectedInventory;

  const MakeEstimation({
    super.key,
    this.onBack,
    this.estimationModel,
    this.products,
    this.selectedInventory,
  });

  @override
  State<MakeEstimation> createState() => _MakeEstimationState();
}

class _MakeEstimationState extends State<MakeEstimation> {
  final customerNameController = TextEditingController();

  // Data
  List<CustomerModel> allCustomers = [];
  List<CustomerModel> filteredCustomers = [];
  List<ServiceTypeModel> allServices = [];
  List<DiscountModel> allDiscounts = [];

  bool _isLoadingDiscounts = true;

  @override
  void initState() {
    DateTime t = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<EstimationProvider>();
      p.clearData();
      context.read<EstimationProvider>().setVisitingTime(t);
      if (widget.selectedInventory != null &&
          widget.selectedInventory!.isNotEmpty) {
        p.addAllInventory(widget.selectedInventory!, widget.products!);
      }
    });

    _loadInitialData();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoadingDiscounts = true);
    try {
      final results = await Future.wait([
        // DataFetchService.fetchDiscount(),
        // DataFetchService.fetchCustomers(),
        // DataFetchService.fetchServiceTypes(),
        // DataFetchService.fetchInventory(),
        DataFetchService.fetchDiscount(),
        DataFetchService.fetchCustomers(),
        DataFetchService.fetchServiceTypes(),
        DataFetchService.fetchInventory(),
      ]);

      allDiscounts = results[0] as List<DiscountModel>;
      allCustomers = results[1] as List<CustomerModel>;
      allServices = results[2] as List<ServiceTypeModel>;
      final allInvs = results[3] as List<InventoryModel>;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget.estimationModel != null) {
          final p = context.read<EstimationProvider>();

          final svcMap = {for (var s in allServices) s.id!: s.name};

          p.setFromEstimation(
            widget.estimationModel!,
            servicesIdToName: svcMap,
          );
          final selectedInvs = <InventoryModel>[];
          final ids = (widget.estimationModel!.items ?? [])
              .map((e) => e.productId)
              .toSet();
          for (final inv in allInvs) {
            if (inv.id != null && ids.contains(inv.id)) selectedInvs.add(inv);
          }
          p.setSelectedInventoryFromItems(selectedInvs);

          if (widget.estimationModel!.customerId != null) {
            final cust = allCustomers.firstWhere(
              (c) => c.id == widget.estimationModel!.customerId,
              orElse: () => CustomerModel(
                customerName: '',
                customerType: '',
                contactNumber: '',
                telePhoneNumber: '',
                streetAddress1: '',
                streetAddress2: '',
                city: '',
                state: '',
                postalCode: '',
                countryId: '',
                accountNumber: '',
                currencyId: '',
                emailAddress: '',
                bankName: '',
                notes: '',
                status: '',
                addedBy: '',
                codeNumber: '',
              ),
            );
            customerNameController.text = cust.customerName;
            p.setCustomer(id: cust.id!);
          }

          p.advancePaymentController.text = widget
              .estimationModel!
              .advancePercentage
              .toString();

          if ((widget.estimationModel!.isDiscountApplied ?? false) &&
              (widget.estimationModel!.discountId?.isNotEmpty ?? false)) {
            final found = allDiscounts.firstWhere(
              (d) => d.id == widget.estimationModel!.discountId,
              orElse: () => DiscountModel.getDiscount(), // safe
            );
            p.setDiscount(
              true,
              found.id == null ? null : found,
              percent: (widget.estimationModel!.discountPercent ?? 0)
                  .toDouble(),
              isEdit: true,
            );
          }
        }
      });
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

  Future<void> _pickBookingDate(EstimationProvider p) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: p.visitingDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      if (!mounted) return;
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(p.visitingDate),
      );
      final finalDt = (t == null)
          ? DateTime(picked.year, picked.month, picked.day)
          : DateTime(picked.year, picked.month, picked.day, t.hour, t.minute);

      p.setVisitingTime(finalDt);
    }
  }

  Future<void> _pickPriceForService({
    required EstimationProvider p,
    required String serviceId,
  }) async {
    final svc = allServices.firstWhere((s) => s.id == serviceId);
    final prices = (svc.prices ?? [])
        .whereType<num>()
        .map((e) => e.toDouble())
        .toList();
    if (prices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No prices defined for this service')),
      );
      return;
    }

    final chosen = await showModalBottomSheet<double>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, i) {
              final price = prices[i];
              final isSel = p.selectedServicesWithPrice[serviceId] == price;
              return ListTile(
                title: Text(price.toStringAsFixed(2)),
                trailing: isSel
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () => Navigator.pop(context, price),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: prices.length,
          ),
        );
      },
    );

    if (chosen != null) {
      p.setServicePrice(serviceId, chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundGreyColor,
      child: Consumer<EstimationProvider>(
        builder: (context, p, _) {
          return p.isItemsSelection
              ? SelectItemsPage(bridge: bridgeFromEstimation(p))
              : SingleChildScrollView(
                  child: Form(
                    key: p.makeEstimateKey,
                    child: OverlayLoader(
                      loader: _isLoadingDiscounts,
                      child: Column(
                        children: [
                          PageHeaderWidget(
                            title: 'Create Estimate',
                            buttonText: 'Back to Estimates',
                            subTitle: 'Create New Estimate',
                            onCreateIcon: 'assets/back.png',
                            selectedItems: [],
                            buttonWidth: 0.4,
                            onCreate: widget.onBack!.call,
                            onDelete: () async {},
                          ),
                          20.h,
                          _topCard(context, p),
                          12.h,
                          _middleRow(context, p),
                          // 20.h,
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _topCard(BuildContext context, EstimationProvider p) {
    final serviceItems = {for (var s in allServices) s.id!: s.name};
    final customerList = {
      for (var c in filteredCustomers) c.id!: c.customerName,
    };
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
            if (p.selectedServiceNamePairs.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: p.selectedServiceNamePairs.map((entry) {
                  final id = entry.key;
                  final name = entry.value;
                  final chosen = p.selectedServicesWithPrice[id];
                  return InputChip(
                    label: Text(
                      chosen == null
                          ? name
                          : '$name — ${chosen.toStringAsFixed(2)}',
                    ),
                    onPressed: () => _pickPriceForService(p: p, serviceId: id),
                    onDeleted: () => p.removeService(id),
                  );
                }).toList(),
              ),
              12.h,
            ],
            CustomSearchableDropdown(
              // loading: _isLoadingDiscounts,
              isMultiSelect: true,
              key: const ValueKey('services_dropdown'),
              hintText: 'Choose Services',
              items: serviceItems,
              value: null,
              selectedValues: p.selectedServiceNamePairs
                  .map((e) => e.key)
                  .toList(),
              onMultiChanged: (List<MapEntry<String, String>> items) =>
                  p.setSelectedServices(items),
              onChanged: (_) {},
            ),
            10.h,
            Row(
              children: [
                // Expanded(
                //   child: CustomMmTextField(
                //     labelText: 'Customer Number',
                //     hintText: 'Customer Number',
                //     controller: p.generateCustomerNumberController,
                //     icon: Icons.generating_tokens,
                //     readOnly: true,
                //     autovalidateMode: _isLoadingDiscounts
                //         ? AutovalidateMode.disabled
                //         : AutovalidateMode.onUserInteraction,
                //     validator: (v) => (v == null || v.isEmpty)
                //         ? 'Please generate booking number'
                //         : null,
                //     onIcon: p.generateRandomEstimationNumber,
                //   ),
                // ),
                // CustomSearchableDropdown(
                //   // loading: _isLoadingDiscounts,
                //   isMultiSelect: false,
                //   key: const ValueKey('customer_dropdown'),
                //   hintText: 'Choose Customer',
                //   items: customerList,
                //   value: null,
                //   selectedValues:
                //       p.selectedServiceNamePairs.map((e) => e.key).toList(),
                //   onMultiChanged: (List<MapEntry<String, String>> items) =>
                //       p.setSelectedServices(items),
                //   onChanged: (_) {},
                // ),
                // 12.w,
              ],
            ),
            10.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                    (c) => c!.customerName
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
                      // Customer overlay (unchanged)
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
                                border: Border.all(color: Colors.grey.shade300),
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
                                      if (index != filteredCustomers.length - 1)
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
                Expanded(
                  child: CustomMmTextField(
                    onTap: () => _pickBookingDate(p),
                    readOnly: true,
                    labelText: 'Estimate Date',
                    hintText: 'Estimate Date',
                    controller: p.visitingDateController,
                    autovalidateMode: _isLoadingDiscounts
                        ? AutovalidateMode.disabled
                        : AutovalidateMode.onUserInteraction,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Select Estimate date'
                        : null,
                  ),
                ),
                // Expanded(
                //   child: CustomMmTextField(
                //     labelText: 'Advance Payment Percentage',
                //     hintText: 'Advance Payment',
                //     controller: p.advancePaymentController,
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     validator: ValidationUtils.advancePaymentPercentage,
                //     onChanged: (value) {
                //       setState(() {
                //         if (value.isNotEmpty) {
                //           filteredCustomers = allCustomers
                //               .where(
                //                 (c) => c.customerName
                //                     .toLowerCase()
                //                     .contains(value.toLowerCase()),
                //               )
                //               .toList();
                //         } else {
                //           filteredCustomers = [];
                //         }
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _middleRow(BuildContext context, EstimationProvider p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: SelectedItemsList(
              contextHeight: context.height,
              selectedInventory: p.getSelectedInventory,
              selectedProducts: p.productsList,
              lines: p.items,
              itemsTotal: p.itemsTotal,
              onAddItems: () => p.setIsSelection(true),
              onIncreaseQty: (index, inv) => p.increaseQuantity(
                index: index,
                context: context,
                inventory: inv,
              ),
              onDecreaseQty: (index) =>
                  p.decreaseQuantity(index: index, context: context),
              onRemoveItem: (index) => p.removeInventory(
                p.getSelectedInventory[index],
                p.productsList[index],
              ),
            ),
          ),
          10.w,
          Expanded(flex: 2, child: _buildBookingSummarySection(context, p)),
        ],
      ),
    );
  }

  // Widget _buildBookingSummarySection(
  //   BuildContext context,
  //   EstimationProvider p,
  // ) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: AppTheme.whiteColor,
  //       border: Border.all(color: AppTheme.borderColor),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Order Summary:',
  //           style: Theme.of(context).textTheme.titleMedium,
  //         ),
  //         const SizedBox(height: 10),

  //         twoCol('Items Total', p.itemsTotal.toStringAsFixed(2)),
  //         twoCol('Services Total', p.servicesTotal.toStringAsFixed(2)),
  //         twoCol('Discount', '-${p.discountAmount.toStringAsFixed(2)}'),
  //         twoCol('Tax', p.taxAmount.toStringAsFixed(2)),
  //         const Divider(),

  //         // Discount toggle
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text('Apply Discount'),
  //             Switch(
  //               value: p.getIsDiscountApply,
  //               onChanged: (v) => p.setDiscount(v, null),
  //             ),
  //           ],
  //         ),

  //         if (p.getIsDiscountApply)
  //           DiscountSelector(
  //             applyDiscount: p.getIsDiscountApply,
  //             isLoadingDiscounts: _isLoadingDiscounts,
  //             discounts: allDiscounts,
  //             selectedDiscount: p.selectedDiscount,
  //             onDiscountSelected: (d) {
  //               p.setDiscount(
  //                 d.status == "inactive" ? false : true,
  //                 d,
  //                 percent: (d.discount ?? 0).toDouble(),
  //               );
  //             },
  //           ),

  //         // Tax toggle
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text('Apply Tax ?'),
  //             Switch(
  //               value: p.getIsTaxApply,
  //               onChanged: (v) => p.setTax(v, p.taxPercent),
  //             ),
  //           ],
  //         ),

  //         const Divider(),
  //         twoCol('Total', p.total.toStringAsFixed(2)),
  //         const SizedBox(height: 12),
  //         SizedBox(
  //           height: 44,
  //           width: 180,
  //           child: CustomButton(
  //             loadingNotifier: p.loading,
  //             text: widget.estimationModel != null
  //                 ? 'Update Estimate'
  //                 : 'Create Estimate',
  //             onPressed: () {
  //               if (p.makeEstimateKey.currentState?.validate() != true) return;
  //               p.saveEstimation(
  //                 context: context,
  //                 onBack: widget.onBack,
  //                 isEdit: widget.estimationModel != null,
  //               );
  //             },
  //             buttonType: ButtonType.Filled,
  //             backgroundColor: AppTheme.primaryColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildBookingSummarySection(
    BuildContext context,
    EstimationProvider p,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          _buildSummaryHeader(context),

          // Content Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                // Cost Breakdown
                _buildCostBreakdown(p),

                const SizedBox(height: 20),

                // Discount Section
                _buildDiscountSection(context, p),

                const SizedBox(height: 16),

                // Tax Section
                _buildTaxSection(context, p),

                // Discount Selector (if applicable)
                if (p.getIsDiscountApply) ...[
                  const SizedBox(height: 16),
                  _buildDiscountSelector(p),
                ],

                const SizedBox(height: 20),

                // Total Section
                _buildTotalSection(context, p),

                const SizedBox(height: 24),

                // Action Button
                _buildActionButton(context, p),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     AppTheme.primaryColor.withOpacity(0.08),
        //     AppTheme.primaryColor.withOpacity(0.03),
        //   ],
        // ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              //color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Review your order details below',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown(EstimationProvider p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildCostRow(
            'Items Total',
            p.itemsTotal.toStringAsFixed(2),
            icon: Icons.shopping_cart_outlined,
            iconColor: Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildCostRow(
            'Services Total',
            p.servicesTotal.toStringAsFixed(2),
            icon: Icons.handyman_outlined,
            iconColor: Colors.green,
          ),
          if (p.discountAmount > 0) ...[
            const SizedBox(height: 12),
            _buildCostRow(
              'Discount Applied',
              '-${p.discountAmount.toStringAsFixed(2)}',
              icon: Icons.local_offer_outlined,
              iconColor: Colors.orange,
              isDiscount: true,
            ),
          ],
          if (p.getIsTaxApply) ...[
            const SizedBox(height: 12),
            _buildCostRow(
              'Tax',
              p.taxAmount.toStringAsFixed(2),
              icon: Icons.account_balance_outlined,
              iconColor: Colors.purple,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCostRow(
    String label,
    String amount, {
    IconData? icon,
    Color? iconColor,
    bool isDiscount = false,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: iconColor ?? AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor.withOpacity(0.8),
            ),
          ),
        ),
        Text(
          'OMR $amount',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection(BuildContext context, EstimationProvider p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.08),
            Colors.orange.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.local_offer_outlined,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apply Discount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.getIsDiscountApply
                      ? 'Discount will be applied to your order'
                      : 'Save money with available discounts',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.primaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.1,
            child: Switch.adaptive(
              value: p.getIsDiscountApply,
              onChanged: (v) => p.setDiscount(v, null),
              activeColor: Colors.orange,
              activeTrackColor: Colors.orange.withOpacity(0.3),
              inactiveThumbColor: AppTheme.borderColor,
              inactiveTrackColor: AppTheme.borderColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxSection(BuildContext context, EstimationProvider p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.08),
            Colors.purple.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.account_balance_outlined,
              color: Colors.purple,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apply Tax',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.getIsTaxApply
                      ? 'Tax will be calculated on your order'
                      : 'Toggle to include tax in calculation',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.primaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.1,
            child: Switch.adaptive(
              value: p.getIsTaxApply,
              onChanged: (v) => p.setTax(v, p.taxPercent),
              activeColor: Colors.purple,
              activeTrackColor: Colors.purple.withOpacity(0.3),
              inactiveThumbColor: AppTheme.borderColor,
              inactiveTrackColor: AppTheme.borderColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSelector(EstimationProvider p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2), width: 1),
      ),
      child: DiscountSelector(
        applyDiscount: p.getIsDiscountApply,
        isLoadingDiscounts: _isLoadingDiscounts,
        discounts: allDiscounts,
        selectedDiscount: p.selectedDiscount,
        onDiscountSelected: (d) {
          p.setDiscount(
            d.status == "inactive" ? false : true,
            d,
            percent: (d.discount ?? 0).toDouble(),
          );
        },
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context, EstimationProvider p) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Final amount to pay',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.primaryColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    'OMR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    p.total.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              if (p.discountAmount > 0)
                Text(
                  'You saved OMR ${p.discountAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, EstimationProvider p) {
    final isEdit = widget.estimationModel != null;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          //  if (p.makeEstimateKey.currentState?.validate() != true) return;
          p.saveEstimation(
            context: context,
            onBack: widget.onBack,
            isEdit: isEdit,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.whiteColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: p.loading.value
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppTheme.whiteColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEdit
                        ? Icons.edit_outlined
                        : Icons.add_circle_outline_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEdit ? 'Update Estimate' : 'Create Estimate',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
