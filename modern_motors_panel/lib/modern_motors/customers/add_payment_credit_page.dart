import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';
import '../../model/attachment_model.dart';

class AddPaymentCreditPage extends StatefulWidget {
  const AddPaymentCreditPage({super.key});

  @override
  State<AddPaymentCreditPage> createState() => _AddPaymentCreditPageState();
}

class _AddPaymentCreditPageState extends State<AddPaymentCreditPage> {
  final GlobalKey<FormState> _addPaymentKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController receiptController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController date = TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);

  List<CurrencyModel> currencyList = [];
  String? selectedCurrencyId;
  String? selectedTreasuryId;
  String? selectedPaymentId;
  String? selectedPaymentStatusId;
  String? collectedById;

  bool status = true;
  List<AttachmentModel> attachments = [];

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

  final List<Map<String, dynamic>> treasuryList = [
    {"id": '1', "treasury": "Main Treasury"},
    {"id": '2', "treasury": "Secondary Treasury"},
    {"id": '3', "treasury": "Overseas Treasury"},
  ];

  final List<Map<String, dynamic>> paymentMethodList = [
    {"id": '1', "method": "Cash"},
    {"id": '2', "method": "Credit Card"},
    {"id": '3', "method": "Bank Transfer"},
    {"id": '4', "method": "Cheque"},
  ];

  final List<Map<String, dynamic>> paymentStatusList = [
    {"id": '1', "status": "Pending"},
    {"id": '2', "status": "Completed"},
    {"id": '3', "status": "Failed"},
    {"id": '4', "status": "Refunded"},
  ];

  final List<Map<String, dynamic>> collectedByList = [
    {"id": '1', "collector": "Hamza Ali"},
    {"id": '2', "collector": "Ahmed Raza"},
    {"id": '3', "collector": "Sara Khan"},
    {"id": '4', "collector": "Usman Malik"},
  ];

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
    });
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
                title: 'Add Payment Credit'.tr(),
                buttonText: 'Back to Customer Page'.tr(),
                subTitle: 'Add New Payment Credit'.tr(),
                onCreateIcon: 'assets/icons/back.png',
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
                          'Payment Credit Info'.tr(),
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
                          key: _addPaymentKey,
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
                                ],
                              ),
                              14.h,
                              Row(
                                children: [
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
                                  10.w,
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Treasury',
                                      value: selectedTreasuryId,
                                      items: {
                                        for (var u in treasuryList)
                                          u['id']: u['treasury'],
                                      },
                                      onChanged: (val) => setState(
                                        () => selectedTreasuryId = val,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              14.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: '(Select Payment Method)',
                                      value: selectedPaymentId,
                                      items: {
                                        for (var u in paymentMethodList)
                                          u['id']: u['method'],
                                      },
                                      onChanged: (val) => setState(
                                        () => selectedPaymentId = val,
                                      ),
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Treasury',
                                      value: selectedPaymentStatusId,
                                      items: {
                                        for (var u in paymentStatusList)
                                          u['id']: u['status'],
                                      },
                                      onChanged: (val) => setState(
                                        () => selectedTreasuryId = val,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              14.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Collected By',
                                      value: collectedById,
                                      items: {
                                        for (var u in collectedByList)
                                          u['id']: u['collector'],
                                      },
                                      onChanged: (val) =>
                                          setState(() => collectedById = val),
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Ref No',
                                      hintText: 'Ref No',
                                      controller: refNoController,
                                    ),
                                  ),
                                ],
                              ),
                              14.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Payment Details',
                                      hintText: 'Payment Details',
                                      controller: detailsController,
                                      maxLines: 4,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Receipt Note',
                                      hintText: 'Receipt Note',
                                      controller: receiptController,
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                              14.h,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    PickerWidget(
                                      multipleAllowed: true,
                                      attachments: attachments,
                                      galleryAllowed: true,
                                      onFilesPicked: onFilesPicked,
                                      memoAllowed: false,
                                      //ft: FileType.image,
                                      filesAllowed: false,
                                      //captionAllowed: false,
                                      videoAllowed: false,
                                      cameraAllowed: true,
                                      child: Container(
                                        height: context.height * 0.2,
                                        width: context.width * 0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.borderColor,
                                          ),
                                        ),
                                        child: attachments.isNotEmpty
                                            ? kIsWeb
                                                  ? Image.memory(
                                                      attachments.last.bytes!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(
                                                        attachments.last.url,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .add_circle_outline_rounded,
                                                  ),
                                                  Text('Add Image'.tr()),
                                                ],
                                              ),
                                      ),
                                    ),
                                    12.w,
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: context.height * 0.06,
                                              width: context.height * 0.22,
                                              child: CustomButton(
                                                text: 'Upload Image'.tr(),
                                                onPressed: () {},
                                                fontSize: 14,
                                                buttonType: ButtonType.Filled,
                                                backgroundColor:
                                                    AppTheme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        8.h,
                                        Text(
                                          'JPEG, PNG up to 2 MB'.tr(),
                                          style:
                                              AppTheme.getCurrentTheme(
                                                false,
                                                connectionStatus,
                                              ).textTheme.bodyMedium!.copyWith(
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              18.h,
                              AlertDialogBottomWidget(
                                title: 'Add Payment',
                                onCreate: () {},
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
