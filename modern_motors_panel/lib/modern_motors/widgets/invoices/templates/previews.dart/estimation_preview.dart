import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/default_address_preview.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/estimation_template_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class EstimationTemplatePreview extends StatefulWidget {
  const EstimationTemplatePreview({super.key});

  @override
  State<EstimationTemplatePreview> createState() =>
      _EstimationTemplatePreviewState();
}

class _EstimationTemplatePreviewState extends State<EstimationTemplatePreview>
    with WidgetsBindingObserver {
  String type = 'logo';
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  DefaultAddressModel? defaultAddressModel;
  BankDetails? bankDetails;
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyContact1Controller = TextEditingController();
  final companyContact2Controller = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ibanNumberController = TextEditingController();
  final swiftNumberController = TextEditingController();
  final ValueNotifier<bool> loading = ValueNotifier(false);

  List<AttachmentModel> attachments = [];

  final String companyName = 'Modern Motors';
  final String companyAddress = 'Sultanate of Oman Al Ouhi Ind, Area 2';
  final String companyContact1 = '00988-24287805';
  final String companyContact2 = '+968 26647875';
  final String estimateDate = '2025-09-09';
  final String customerName = 'John Doe';
  final String customerContact = '00988-123456789';
  final String salesman = 'Ahmed Ali';
  final String salesmanEmail = 'ahmed.ali@example.com';
  final String estimateNumber = '123456';
  bool isLoading = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });
    try {
      final results = await Future.wait([
        DataFetchService.fetchEstimationTemplateData('Estimation'),
        DataFetchService.fetchDefaultAddress(),
        DataFetchService.fetchDefaultBank(),
      ]);

      estimationTemplatePreviewModel =
          results[0] as EstimationTemplatePreviewModel?;
      defaultAddressModel = results[1] as DefaultAddressModel?;
      bankDetails = results[2] as BankDetails?;
    } catch (e) {
      debugPrint('Error fetching template data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setControllers() {
    if (type == 'company details') {
      companyNameController.text =
          estimationTemplatePreviewModel?.companyDetails.companyName ??
          companyName;
      companyAddressController.text =
          estimationTemplatePreviewModel?.companyDetails.companyAddress ??
          companyAddress;
      companyContact1Controller.text =
          estimationTemplatePreviewModel?.companyDetails.companyContact1 ??
          companyContact1;
      companyContact2Controller.text =
          estimationTemplatePreviewModel?.companyDetails.companyContact2 ??
          companyContact2;
    } else if (type == 'bank 1 details') {
      bankNameController.text =
          estimationTemplatePreviewModel?.bank1Details.bankName ?? 'NIL';
      accountNumberController.text =
          estimationTemplatePreviewModel?.bank1Details.accountNumber ?? 'NIL';
      ibanNumberController.text =
          estimationTemplatePreviewModel?.bank1Details.ibanNumber ?? 'NIL';
      swiftNumberController.text =
          estimationTemplatePreviewModel?.bank1Details.swiftNumber ?? 'NIL';
    } else {
      bankNameController.text =
          estimationTemplatePreviewModel?.bank2Details.bankName ?? 'NIL';
      accountNumberController.text =
          estimationTemplatePreviewModel?.bank2Details.accountNumber ?? 'NIL';
      ibanNumberController.text =
          estimationTemplatePreviewModel?.bank2Details.ibanNumber ?? 'NIL';
      swiftNumberController.text =
          estimationTemplatePreviewModel?.bank2Details.swiftNumber ?? 'NIL';
    }
  }

  void setDefaultControllers({
    required String type,
    DefaultAddressModel? address,
    BankDetails? bank,
  }) {
    if (type == 'company details' && address != null) {
      companyNameController.text = address.companyName ?? '';
      companyAddressController.text = address.companyAddress ?? '';
      companyContact1Controller.text = address.companyContact1 ?? '';
      companyContact2Controller.text = address.companyContact2 ?? '';
    }

    if ((type == 'bank 1 details' || type == 'bank 2 details') &&
        bank != null) {
      bankNameController.text = bank.bankName ?? '';
      accountNumberController.text = bank.accountNumber ?? '';
      ibanNumberController.text = bank.ibanNumber ?? '';
      swiftNumberController.text = bank.swiftNumber ?? '';
    }
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
    });
  }

  void add() async {
    if (loading.value) return;

    setState(() {
      loading.value = true;
    });
    List<String> urls = [];
    if (type == 'logo') {
      for (AttachmentModel attachment in attachments) {
        String url = await Constants.uploadAttachment(attachment);
        urls.add(url);
      }
    }
    try {
      Map<String, dynamic> data = {};
      String? docId;
      if (type == 'logo') {
        data = {
          'type': 'Estimation',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'headerLogo': urls.isNotEmpty ? urls.first : null,
        };
      } else if (type == 'company details') {
        data = {
          'type': 'Estimation',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {
            'companyName': companyNameController.text,
            'companyAddress': companyAddressController.text,
            'companyContact1': companyContact1Controller.text,
            'companyContact2': companyContact2Controller.text,
          },
        };
      } else if (type == 'bank 1 details') {
        data = {
          'type': 'Estimation',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'bank1Details': {
            'bankName': bankNameController.text,
            'accountNumber': accountNumberController.text,
            'ibanNumber': ibanNumberController.text,
            'swiftNumber': swiftNumberController.text,
          },
        };
      } else if (type == 'bank 2 details') {
        data = {
          'type': 'Estimation',
          'bank2Details': {
            'bankName': bankNameController.text,
            'accountNumber': accountNumberController.text,
            'ibanNumber': ibanNumberController.text,
            'swiftNumber': swiftNumberController.text,
          },
        };
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .where('type', isEqualTo: 'Estimation')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the document exists, fetch the docId and update it
        docId = querySnapshot.docs.first.id;
      } else {
        // If the document doesn't exist, create a new one
        docId = FirebaseFirestore.instance
            .collection('mminvoiceTemplates')
            .doc()
            .id;
      }

      // Save or update the document
      await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .doc(docId)
          .set(data, SetOptions(merge: true))
          .then((value) async {
            if (!mounted) return;
            Constants.showMessage(context, 'Added/Updated successfully');
            await loadData();
          });
    } catch (e) {
      debugPrint('Error while changing value in estimation template: $e');
      if (!mounted) return;
      Constants.showMessage(context, 'Error: $e');
    } finally {
      setState(() {
        loading.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    final isRtl = context.locale.languageCode == 'ar';

    final headersItems = const [
      'Srl.No',
      'Items',
      'Brand',
      'Description',
      'Qty',
      'Unit Price',
      'Subtotal',
    ];

    final headersServices = const [
      'Srl.No',
      'Service',
      'Description',
      'Qty',
      'Unit Price',
      'Subtotal',
    ];

    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 14),
      child: Directionality(
        textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1,
          maxScale: 2.0,
          child: Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1024,
                  minWidth: 512,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      header(
                        context,
                        onLogoTap: () {
                          type = 'logo';
                          setState(() {});
                        },
                        onCompanyDetailsTap: () {
                          setState(() {
                            type = 'company details';
                            setControllers();
                          });
                        },
                        companyName:
                            estimationTemplatePreviewModel
                                ?.companyDetails
                                .companyName ??
                            companyName,
                        companyAddress:
                            estimationTemplatePreviewModel
                                ?.companyDetails
                                .companyAddress ??
                            companyAddress,
                        companyContact1:
                            estimationTemplatePreviewModel
                                ?.companyDetails
                                .companyContact1 ??
                            companyContact1,
                        companyContact2:
                            estimationTemplatePreviewModel
                                ?.companyDetails
                                .companyContact2 ??
                            companyContact2,
                        model: estimationTemplatePreviewModel!,
                      ),
                      const SizedBox(height: 16),
                      metaTop(
                        estimationTemplatePreviewModel
                                ?.companyDetails
                                .companyName ??
                            'Modern Motors',
                        'Oman - Barka',
                      ),
                      const SizedBox(height: 10),
                      table(headersItems, getInspectionTableData()),
                      const SizedBox(height: 2),
                      table(headersServices, getServicesTableData()),
                      const SizedBox(height: 2),
                      divider(1.2),
                      totals(),
                      const SizedBox(height: 14),
                      terms(),
                      const SizedBox(height: 24),
                      footer(
                        () {
                          setState(() {
                            type = 'bank 1 details';
                            setControllers();
                          });
                        },
                        () {
                          setState(() {
                            type = 'bank 2 details';
                            setControllers();
                          });
                        },
                        estimationTemplatePreviewModel!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Preview Estimation Invoice'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Container(
                  height: context.height,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  width: context.width * 0.3,
                  child: Column(
                    children: [
                      if (type == 'logo') ...[
                        Row(
                          children: [
                            PickerWidget(
                              multipleAllowed: true,
                              attachments: attachments,
                              galleryAllowed: true,
                              onFilesPicked: onFilesPicked,
                              memoAllowed: false,
                              // ft: FileType.image,
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
                                    : Image.asset('assets/images/logo1.png'),
                              ),
                            ),
                            14.w,
                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: context.height * 0.06,
                                      width: context.height * 0.22,
                                      child: CustomButton(
                                        loadingNotifier: loading,
                                        text: 'Upload Logo'.tr(),
                                        onPressed: () {
                                          if (attachments.isNotEmpty) {
                                            add();
                                          } else {
                                            Constants.showMessage(
                                              context,
                                              "Please choose logo",
                                            );
                                          }
                                        },
                                        fontSize: 14,
                                        buttonType: ButtonType.Filled,
                                        backgroundColor: AppTheme.primaryColor,
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
                      ],
                      const SizedBox(height: 16),
                      if (type == 'company details') ...[
                        CustomMmTextField(
                          controller: companyNameController,
                          hintText: 'Company Name',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: companyAddressController,
                          hintText: 'Company Address',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: companyContact1Controller,
                          hintText: 'Company Contact 1',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: companyContact2Controller,
                          hintText: 'Company Contact 2',
                        ),
                        12.h,
                        CustomButton(
                          loadingNotifier: loading,
                          onPressed: add,
                          text: 'Save Changes',
                        ),
                        12.h,
                        CustomButton(
                          onPressed: () {
                            setDefaultControllers(
                              type: 'company details',
                              address: defaultAddressModel,
                              bank: bankDetails,
                            );
                          },
                          text: 'Set Default Values',
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (type == 'bank 1 details' ||
                          type == 'bank 2 details') ...[
                        CustomMmTextField(
                          controller: bankNameController,
                          hintText: 'Bank Name',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: accountNumberController,
                          hintText: 'Account Number',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: ibanNumberController,
                          hintText: 'IBAN Number',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: swiftNumberController,
                          hintText: 'Swift Number',
                        ),
                        12.h,
                        CustomButton(
                          loadingNotifier: loading,
                          onPressed: add,
                          text: 'Save Changes',
                        ),
                        12.h,
                        CustomButton(
                          onPressed: () {
                            setDefaultControllers(
                              type: type,
                              address: defaultAddressModel,
                              bank: bankDetails,
                            );
                          },
                          text: 'Set Default Values',
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: context.width * 0.1),
                Expanded(child: SingleChildScrollView(child: body)),
                SizedBox(width: context.width * 0.05),
              ],
            ),
    );
  }
}
