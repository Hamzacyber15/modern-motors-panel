import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

class AddOpeningBalance extends StatefulWidget {
  final CustomerModel customer;
  const AddOpeningBalance({required this.customer, super.key});

  @override
  State<AddOpeningBalance> createState() => _AddOpeningBalanceState();
}

class _AddOpeningBalanceState extends State<AddOpeningBalance> {
  final GlobalKey<FormState> _addOpeningKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController date = TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  List<CurrencyModel> currencyList = [];
  String? selectedCurrencyId;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  void initializeData() async {
    if (catLoader.value) return;
    catLoader.value = true;
    currencyList = await DataFetchService.fetchCurrencies();
    setState(() {});
    catLoader.value = false;
  }

  Future<DateTime?> showDateOnlyPicker({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    return selectedDate;
  }

  Future<void> addBalance() async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'setCustomerInitialBalance',
      );
      double d = double.tryParse(amountController.text) ?? 0;
      final results = await callable({
        'customerID': widget.customer.id,
        "balance": d,
        "initialDate": "2025-09-01",
      });
      debugPrint(results.toString());
      // if (results.data.sta = '-1') {
      // } else {
      //   debugPrint("please try again later");
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Scaffold(
      body: OverlayLoader(
        loader: catLoader.value,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PageHeaderWidget(
                title: 'Add Opening Balance'.tr(),
                buttonText: 'Back to Customer Page'.tr(),
                subTitle: 'Add New Opening Balance'.tr(),
                onCreateIcon: 'assets/images/back.png',
                selectedItems: [],
                buttonWidth: 0.4,
                onCreate: () {
                  Navigator.pop(context);
                },
                isHide: false,
                onDelete: () async {},
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderColor, width: 0.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10),
                        child: Text(
                          'Opening Balance Info'.tr(),
                          style: AppTheme.getCurrentTheme(
                            false,
                            connectionStatus,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Form(
                          key: _addOpeningKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Amount',
                                      hintText: '0,0',
                                      controller: amountController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please  add the amount';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      key: const ValueKey('currency'),
                                      hintText: 'Currency'.tr(),
                                      value: selectedCurrencyId,
                                      verticalPadding: 7,
                                      items: {
                                        for (var u in currencyList)
                                          u.id!: u.currency,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedCurrencyId = val;
                                      }),
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      onTap: () async {
                                        final selectedDate =
                                            await showDateOnlyPicker(
                                              firstDate: DateTime.now(),
                                              initialDate: date.text.isNotEmpty
                                                  ? DateTime.tryParse(date.text)
                                                  : DateTime.now(),
                                              lastDate: DateTime(2050),
                                            );

                                        if (selectedDate != null) {
                                          date.text =
                                              "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                        }
                                      },
                                      readOnly: true,
                                      labelText: 'Date',
                                      hintText: 'Pick Date',
                                      controller: date,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a booking date';
                                        }

                                        final selectedDate = DateTime.tryParse(
                                          value,
                                        );
                                        final now = DateTime.now();
                                        final today = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                        );

                                        if (selectedDate == null) {
                                          return 'Invalid date format';
                                        }

                                        final dateOnly = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                        );

                                        if (dateOnly.isBefore(today)) {
                                          return 'Booking date should be today or later';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              18.h,
                              AlertDialogBottomWidget(
                                title: 'Add balance',
                                onCreate: addBalance,
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                loadingNotifier: loading,
                              ),
                              22.h,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
