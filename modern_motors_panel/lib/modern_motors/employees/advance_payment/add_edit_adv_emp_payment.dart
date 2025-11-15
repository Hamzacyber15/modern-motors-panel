import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/advance_payment_employee_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dynamic_data_table_buttons.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';
import '../../../model/attachment_model.dart';
import '../../../provider/resource_provider.dart';

class AddEditAdvEmpPay extends StatefulWidget {
  final AdvanceEmployeePaymentModel? paymentModel;

  const AddEditAdvEmpPay({super.key, this.paymentModel});

  @override
  State<AddEditAdvEmpPay> createState() => _AddEditAdvEmpPayState();
}

class _AddEditAdvEmpPayState extends State<AddEditAdvEmpPay> {
  final GlobalKey<FormState> _addOpeningKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController referenceNoController = TextEditingController();
  TextEditingController date = TextEditingController();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  List<AttachmentModel> attachments = [];
  AdvanceEmployeePaymentModel? advancePayment;
  List<EmployeeModel> employees = [];
  List<BranchModel> branches = [];
  String? selectedEmployeeId;
  String? selectedBranchId;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  void initializeData() async {
    if (catLoader.value) return;
    catLoader.value = true;
    final provider = context.read<MmResourceProvider>();
    employees = provider.employees;
    branches = provider.branchesList;
    setState(() {
      if (widget.paymentModel != null) {
        advancePayment = widget.paymentModel;
        amountController.text = advancePayment?.amount.toString() ?? '';
        referenceNoController.text = advancePayment?.referenceNo ?? '';
        date.text = advancePayment != null
            ? advancePayment!.date.toString()
            : '';
        selectedEmployeeId = advancePayment?.employeeId;
        selectedBranchId = advancePayment?.branchId;
      }
    });
    catLoader.value = false;
  }

  // void _submitAdvancePayment() async {
  //   if (loading.value) return;
  //   final provider = context.read<MmResourceProvider>();
  //   if (!_addOpeningKey.currentState!.validate()) return;

  //   if (selectedEmployeeId == null || selectedBranchId == null) {
  //     Constants.showMessage(context, 'Please select employee and branch');
  //     return;
  //   }

  //   loading.value = true;

  //   try {
  //     String code;
  //     final uploadedUrls = await Future.wait(
  //       attachments.map((a) async => await Constants.uploadAttachment(a)),
  //     );

  //     final List<String> uploadedStringUrls = uploadedUrls
  //         .map((e) => e.toString())
  //         .toList();

  //     final List<String> allAttachments = [
  //       ...(advancePayment?.attachments ?? []),
  //       ...uploadedStringUrls,
  //     ];

  //     if (widget.paymentModel != null) {
  //       code = widget.paymentModel!.code;
  //     } else {
  //       code = await Constants.getUniqueNumber("EAP");
  //       if (code.isEmpty) {
  //         code = await Constants.getUniqueNumber("EAP");
  //       }
  //     }
  //     final model = AdvanceEmployeePaymentModel(
  //       id: advancePayment?.id,
  //       amount: double.tryParse(amountController.text.trim()) ?? 0.0,
  //       referenceNo: referenceNoController.text.trim(),
  //       employeeId: selectedEmployeeId!,
  //       branchId: selectedBranchId!,
  //       date: DateTime.parse(date.text),
  //       code: code,
  //       attachments: allAttachments,
  //       status: advancePayment?.status ?? 'active',
  //       createdAt: advancePayment?.createdAt ?? Timestamp.now(),
  //       createdBy:
  //           advancePayment?.createdBy ?? FirebaseAuth.instance.currentUser!.uid,
  //     );

  //     final colRef = FirebaseFirestore.instance.collection('purEmpAdvances');

  //     if (widget.paymentModel != null) {
  //       await colRef.doc(advancePayment!.id).update(model.toMap());
  //       if (mounted) {
  //         Constants.showMessage(context, 'Payment updated successfully');
  //         provider.updateEmployeeAdvancePayment(
  //           id: widget.paymentModel!.id,
  //           model: model,
  //         );
  //       }
  //     } else {
  //       await colRef.add({
  //         ...model.toMap(),
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });
  //       if (mounted) {
  //         Constants.showMessage(context, 'Payment added successfully');
  //         provider.updateEmployeeAdvancePayment(model: model);
  //       }
  //     }
  //     if (mounted) {
  //       Navigator.pop(context);
  //     }
  //   } catch (e) {
  //     debugPrint('Error saving advance payment: $e');
  //     if (mounted) Constants.showMessage(context, 'Error: $e');
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  void _submitAdvancePayment() async {
    if (loading.value) return;

    if (!_addOpeningKey.currentState!.validate()) return;

    if (selectedEmployeeId == null || selectedBranchId == null) {
      Constants.showMessage(context, 'Please select employee and branch');
      return;
    }

    loading.value = true;

    try {
      // Upload attachments first
      final uploadedUrls = await Future.wait(
        attachments.map((a) async => await Constants.uploadAttachment(a)),
      );

      final List<String> uploadedStringUrls = uploadedUrls
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();

      final List<String> allAttachments = [
        ...(advancePayment?.attachments ?? []),
        ...uploadedStringUrls,
      ];

      // Generate code for new payments
      String code;
      if (widget.paymentModel != null) {
        code = widget.paymentModel!.code;
      } else {
        code = await Constants.getUniqueNumber("EAP");
        if (code.isEmpty) {
          code = await Constants.getUniqueNumber("EAP");
        }
      }

      // Call Firebase Cloud Function
      final result = await FirebaseFunctions.instance
          .httpsCallable('makeAdvancePaymentToEmployee')
          .call({
            'empId': selectedEmployeeId,
            'amount': double.tryParse(amountController.text.trim()) ?? 0.0,
            'branchId': selectedBranchId,
            'date': date.text.isEmpty
                ? DateTime.now().toIso8601String()
                : date.text,
            // Include additional data for update scenarios
            // 'paymentId': widget.paymentModel?.id,
            // 'referenceNo': referenceNoController.text.trim(),
            // 'code': code,
            // 'attachments': allAttachments,
            // 'isUpdate': widget.paymentModel != null,
          });

      if (result.data['success'] == true) {
        if (mounted) {
          Constants.showMessage(
            context,
            widget.paymentModel != null
                ? 'Payment updated successfully'
                : 'Payment added successfully',
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          Constants.showMessage(
            context,
            result.data['error'] ?? 'Operation failed',
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving advance payment: $e');
      if (mounted) {
        Constants.showMessage(context, 'Error: ${e.toString()}');
      }
    } finally {
      loading.value = false;
    }
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

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
      debugPrint('attachments length: ${attachments.length}');
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    referenceNoController.dispose();
    date.dispose();
    loading.dispose();
    catLoader.dispose();

    super.dispose();
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
                title:
                    '${widget.paymentModel == null ? 'Add New' : 'Update'} Employee Advance Payment'
                        .tr(),
                buttonText: 'Back to Employee Advance'.tr(),
                subTitle:
                    '${widget.paymentModel == null ? 'Add New' : 'Update'}  Employee Advance Payments'
                        .tr(),
                onCreateIcon: 'assets/icons/back.png',
                selectedItems: [],
                buttonWidth: 0.44,
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
                          'Employee Advance Payment Info'.tr(),
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
                                      key: const ValueKey('employee'),
                                      hintText: 'Choose Employee'.tr(),
                                      value: selectedEmployeeId,
                                      verticalPadding: 7,
                                      items: {
                                        for (var u in employees) u.id: u.name,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedEmployeeId = val;
                                      }),
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      key: const ValueKey('branch'),
                                      hintText: 'Choose Branch'.tr(),
                                      value: selectedBranchId,
                                      verticalPadding: 7,
                                      items: {
                                        for (var u in branches)
                                          u.id!: u.branchName,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedBranchId = val;
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Reference No',
                                      hintText: 'Reference No',
                                      controller: referenceNoController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please  add the reference no';
                                        }
                                        return null;
                                      },
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
                              10.h,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: PickerWidget(
                                  multipleAllowed: true,
                                  attachments: attachments,
                                  galleryAllowed: true,
                                  onFilesPicked: onFilesPicked,
                                  memoAllowed: false,
                                  //ft: FileType.image,
                                  filesAllowed: false,
                                  // captionAllowed: false,
                                  videoAllowed: false,
                                  cameraAllowed: true,
                                  child: Container(
                                    height: context.height * 0.2,
                                    width: context.width * 0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
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
                                                  File(attachments.last.url),
                                                  fit: BoxFit.cover,
                                                )
                                        : Image.asset(
                                            'assets/images/logo1.png',
                                          ),
                                  ),
                                ),
                              ),
                              if (attachments.isNotEmpty ||
                                  (advancePayment?.attachments ?? [])
                                      .isNotEmpty)
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  itemCount:
                                      (advancePayment?.attachments ?? [])
                                          .length +
                                      attachments.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        crossAxisSpacing: 26,
                                        mainAxisSpacing: 26,
                                        childAspectRatio: 1.3,
                                      ),
                                  itemBuilder: (context, index) {
                                    Widget imageWidget;
                                    if (index <
                                            (advancePayment?.attachments ?? [])
                                                .length &&
                                        advancePayment!
                                            .attachments
                                            .isNotEmpty) {
                                      debugPrint('if $index');
                                      final attachment =
                                          advancePayment?.attachments[index] ??
                                          '';
                                      imageWidget = buildImageWidget(
                                        attachment,
                                      );
                                    } else {
                                      final size =
                                          advancePayment?.attachments ?? [];
                                      final attachment =
                                          attachments[index - size.length];
                                      imageWidget = buildAttachmentWidget(
                                        attachment,
                                      );
                                    }

                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Container(
                                            color: Colors.grey.shade100,
                                            child: imageWidget,
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: buildActionButton(
                                            icon: Icons.delete_outline,
                                            color: Colors.red,
                                            tooltip: 'Remove',
                                            onTap: () {
                                              setState(() {
                                                final size =
                                                    advancePayment
                                                        ?.attachments ??
                                                    [];
                                                if (index < size.length) {
                                                  advancePayment!.attachments
                                                      .removeAt(index);
                                                } else {
                                                  final size =
                                                      advancePayment
                                                          ?.attachments ??
                                                      [];

                                                  attachments.removeAt(
                                                    index - size.length,
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              18.h,
                              AlertDialogBottomWidget(
                                title: widget.paymentModel == null
                                    ? 'Add Payment'
                                    : 'Update Payment',
                                onCreate: loading.value
                                    ? () {}
                                    : _submitAdvancePayment,
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

Widget buildImageWidget(String attachment) {
  if (attachment.isNotEmpty) {
    return Image.network(
      attachment,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Image.asset('assets/icons/broken image.png', fit: BoxFit.cover),
    );
  }
  return Image.asset('assets/images/logo1.png', fit: BoxFit.cover);
}

Widget buildAttachmentWidget(AttachmentModel attachment) {
  if (kIsWeb && attachment.bytes != null) {
    return Image.memory(attachment.bytes!, fit: BoxFit.cover);
  } else if (attachment.url.isNotEmpty) {
    return Image.file(File(attachment.url), fit: BoxFit.cover);
  }
  return Image.asset('assets/images/logo1.png', fit: BoxFit.cover);
}
