import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/retail_layout_preview_widgets.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/fancy_tight_divider.dart';

class RetailLayoutPreview extends StatefulWidget {
  const RetailLayoutPreview({super.key});

  static const double receiptWidth = 320;

  @override
  State<RetailLayoutPreview> createState() => _RetailLayoutPreviewState();
}

class _RetailLayoutPreviewState extends State<RetailLayoutPreview> {
  String type = 'logo';
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  DefaultAddressModel? defaultAddressModel;
  BankDetails? bankDetails;
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final taxIdController = TextEditingController();
  final vatNoController = TextEditingController();
  final companyPhoneController = TextEditingController();
  final ValueNotifier<bool> loading = ValueNotifier(false);
  List<AttachmentModel> attachments = [];
  final String companyName = 'MODERN HANDS SILVER';
  final String companyTaxId = '123456789';
  final String companyAddressLine1 = 'BARKA SULTANTE OF OMAN';
  final String companyVat = 'VAT NO. OM1100306983';
  final String companyPhone = '92478551';
  final String invoiceNumber = 'INV-000123';
  final String invoiceDate = '2025-09-09';
  final String invoiceTime = '14:35';
  final String cashierName = 'Ahmed Ali';
  final String customerName = 'John Doe';
  final String customerType = 'individual';
  final String customerBusinessName = 'FinnTech';
  final String customerPhone = '00988-123456789';
  final String customerAddr1 = 'Street 1, Area 2';
  final String customerAddr2 = 'Near Central Park';
  final String customerCity = 'Muscat';
  final String customerState = 'OM';
  final String customerZip = '111';
  final double total = 128.50;
  final double paid = 0.00;
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
        DataFetchService.fetchEstimationTemplateData('Retail'),
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
      companyAddressController.text =
          estimationTemplatePreviewModel?.companyDetails.companyAddress ??
          companyAddressLine1;
      companyNameController.text =
          estimationTemplatePreviewModel?.companyDetails.companyName ??
          companyName;
      taxIdController.text =
          estimationTemplatePreviewModel?.companyDetails.taxId ?? companyTaxId;
      vatNoController.text =
          estimationTemplatePreviewModel?.companyDetails.vatNo ?? companyVat;
      companyPhoneController.text =
          estimationTemplatePreviewModel?.companyDetails.companyContact1 ??
          companyPhone;
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
          'type': 'Retail',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'headerLogo': urls.isNotEmpty ? urls.first : null,
        };
      } else if (type == 'company details') {
        data = {
          'type': 'Retail',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {
            'companyName': companyNameController.text,
            'companyAddress': companyAddressController.text,
            'companyContact1': companyPhoneController.text,
            'taxId': taxIdController.text,
            'vatNo': vatNoController.text,
          },
        };
      }
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .where('type', isEqualTo: 'Retail')
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

  void setDefaultControllers({
    required String type,
    DefaultAddressModel? address,
    BankDetails? bank,
  }) {
    debugPrint('address $address');
    debugPrint('bank $bank');
    if (type == 'company details' && address != null) {
      debugPrint('setting default company details1');
      companyNameController.text = address.companyName ?? '';
      companyAddressController.text = address.companyAddress ?? '';
      companyPhoneController.text = address.companyContact1 ?? '';
      debugPrint('setting default company details2');
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    final regular = const TextStyle(
      fontFamily: 'Nunito',
      fontSize: 12,
      height: 1.0,
      fontWeight: FontWeight.w400,
    );

    final bold = const TextStyle(
      fontFamily: 'Nunito',
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1.0,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Preview Retail Invoice'),
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
                          controller: taxIdController,
                          hintText: 'Enter Tax ID',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: vatNoController,
                          hintText: 'Enter VAT No',
                        ),
                        const SizedBox(height: 8),
                        CustomMmTextField(
                          controller: companyPhoneController,
                          hintText: 'Enter Phone Number',
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
                    ],
                  ),
                ),
                SizedBox(width: context.width * 0.1),
                SingleChildScrollView(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 3,
                    child: Center(
                      child: Container(
                        width: RetailLayoutPreview.receiptWidth,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    type = 'logo';
                                    setState(() {});
                                  },
                                  child:
                                      estimationTemplatePreviewModel
                                              ?.headerLogo ==
                                          null
                                      ? Image.asset(
                                          'assets/images/logo.png',
                                          width: 150,
                                          height: 60,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          estimationTemplatePreviewModel
                                                  ?.headerLogo ??
                                              '',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Invoice',
                                      style: bold.copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(height: 2),
                                    Text('#$invoiceNumber', style: bold),
                                  ],
                                ),
                              ],
                            ),
                            20.h,
                            InkWell(
                              onTap: () {
                                setState(() {
                                  type = 'company details';
                                  setControllers();
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    estimationTemplatePreviewModel
                                            ?.companyDetails
                                            .companyName ??
                                        companyName,
                                    style: bold.copyWith(fontSize: 14),
                                  ),
                                  6.h,
                                  Text(
                                    'TAX ID: ${estimationTemplatePreviewModel?.companyDetails.taxId ?? companyTaxId}',
                                    style: regular,
                                  ),
                                  6.h,
                                  Text(
                                    estimationTemplatePreviewModel
                                            ?.companyDetails
                                            .companyAddress ??
                                        companyAddressLine1,
                                    style: regular,
                                  ),
                                  6.h,
                                  Text(
                                    estimationTemplatePreviewModel
                                            ?.companyDetails
                                            .vatNo ??
                                        companyVat,
                                    style: regular,
                                  ),
                                  6.h,
                                  Text(
                                    estimationTemplatePreviewModel
                                            ?.companyDetails
                                            .companyContact1 ??
                                        companyPhone,
                                    style: regular,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Divider(height: 16, color: Colors.black),
                            const SizedBox(height: 6),

                            Text(
                              'Date & Time: $invoiceDate - $invoiceTime',
                              style: regular,
                            ),
                            6.h,
                            Text('Cashier: $cashierName', style: regular),
                            6.h,
                            Text('Bill To: $customerName', style: regular),
                            6.h,
                            Text(customerBusinessName, style: regular),
                            6.h,
                            Text(customerPhone, style: regular),
                            6.h,
                            Text(
                              '$customerAddr1, $customerAddr2',
                              style: regular,
                            ),
                            6.h,
                            Text(
                              '$customerCity, $customerState, $customerZip',
                              style: regular,
                            ),

                            14.h,
                            // fancyTightDivider(),
                            16.h,
                            // totals (first block)
                            KeyValueRow(
                              k: 'Total',
                              v: '${total.toStringAsFixed(2)} OMR',
                              emphasize: true,
                              regular: regular,
                              bold: bold.copyWith(fontSize: 16),
                            ),
                            6.h,
                            KeyValueRow(
                              k: 'Paid',
                              v: '${paid.toStringAsFixed(2)} OMR',
                              regular: regular,
                              bold: bold,
                            ),
                            10.h,
                            const Divider(height: 12, color: Colors.black),
                            6.h,
                            KeyValueRow(
                              k: 'Total',
                              v: '{%invoice_total%}',
                              emphasize: true,
                              regular: regular,
                              bold: bold.copyWith(fontSize: 16),
                            ),
                            6.h,
                            Text('{%invoice_payment_table%}', style: regular),
                            20.h,
                            Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                child: Image.asset('assets/images/qr-code.png'),
                              ),
                            ),
                            10.h,
                            Center(
                              child: Text(
                                '******** THANKS FOR YOUR VISIT! ********',
                                style: regular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.width * 0.05),
              ],
            ),
    );
  }
}
