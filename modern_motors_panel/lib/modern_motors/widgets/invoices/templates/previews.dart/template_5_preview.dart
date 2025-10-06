import 'dart:io';
import 'dart:ui' as ui;
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
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/template_5_preview_widgets.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class Template5Preview extends StatefulWidget {
  const Template5Preview({super.key});

  @override
  State<Template5Preview> createState() => _Template5PreviewState();
}

class _Template5PreviewState extends State<Template5Preview> {
  String type = 'logo';
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  DefaultAddressModel? defaultAddressModel;
  BankDetails? bankDetails;
  final ValueNotifier<bool> isSaving = ValueNotifier(false);
  bool isLoading = false;

  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final vatNoController = TextEditingController();
  final companyPhoneController = TextEditingController();

  List<AttachmentModel> attachments = [];

  final String invoiceNumber = 'INV-000123';
  final DateTime invoiceDate = DateTime(2025, 9, 9);
  final double total = 128.50;
  final double paid = 0.0;

  final String customerType = 'business';
  final String businessName = 'FinnTech';
  final String customerName = 'John Doe';
  final String contactNumber = '00988-123456789';
  final String telephoneNumber = '+968 24123456';
  final String street1 = 'Street 1';
  final String street2 = 'Area 2';
  final String city = 'Muscat';
  final String state = 'OM';
  final String postal = '111';

  final List<T5ROW> _rows = const [
    T5ROW(
      item: 'Product A',
      desc: 'Category X - great quality',
      qty: 2,
      unit: 12.50,
      subtotal: 25.00,
    ),
    T5ROW(
      item: 'Product B',
      desc: 'Category Y - feature pack',
      qty: 1,
      unit: 40.00,
      subtotal: 40.00,
    ),
    T5ROW(
      item: 'Product C',
      desc: 'Category Z - limited',
      qty: 3,
      unit: 10.00,
      subtotal: 30.00,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyAddressController.dispose();
    vatNoController.dispose();
    companyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadTemplate() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        DataFetchService.fetchEstimationTemplateData('Template 5'),
        DataFetchService.fetchDefaultAddress(),
        DataFetchService.fetchDefaultBank(),
      ]);

      estimationTemplatePreviewModel =
          results[0] as EstimationTemplatePreviewModel?;
      defaultAddressModel = results[1] as DefaultAddressModel?;
      bankDetails = results[2] as BankDetails?;
    } catch (e) {
      debugPrint('Error fetching "Template 5" template: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void setControllers() {
    final cd = estimationTemplatePreviewModel?.companyDetails;
    if (cd == null) return;

    if ((cd.companyName ?? '').trim().isNotEmpty) {
      companyNameController.text = cd.companyName!;
    }
    if ((cd.companyAddress ?? '').trim().isNotEmpty) {
      companyAddressController.text = cd.companyAddress!;
    }
    if ((cd.vatNo ?? '').trim().isNotEmpty) {
      vatNoController.text = cd.vatNo!;
    }
    if ((cd.companyContact1 ?? '').trim().isNotEmpty) {
      companyPhoneController.text = cd.companyContact1!;
    }
  }

  void _onFilesPicked(List<AttachmentModel> files) {
    setState(() => attachments = files);
  }

  Future<void> add() async {
    if (isSaving.value) return;
    isSaving.value = true;

    List<String> urls = [];
    try {
      Map<String, dynamic> data = {};
      String? docId;

      if (type == 'logo') {
        if (attachments.isEmpty) {
          Constants.showMessage(context, 'Please choose logo');
          isSaving.value = false;
          return;
        }
        for (final a in attachments) {
          final url = await Constants.uploadAttachment(a);
          urls.add(url);
        }
        data = {
          'type': 'Template 5',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'headerLogo': urls.isNotEmpty ? urls.first : null,
        };
      } else if (type == 'company details') {
        data = {
          'type': 'Template 5',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {
            'companyName': companyNameController.text,
            'companyAddress': companyAddressController.text,
            'vatNo': vatNoController.text,
            'companyContact1': companyPhoneController.text,
          },
        };
      }

      final query = await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .where('type', isEqualTo: 'Template 5')
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        docId = query.docs.first.id;
      } else {
        docId = FirebaseFirestore.instance
            .collection('mminvoiceTemplates')
            .doc()
            .id;
      }

      await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .doc(docId)
          .set(data, SetOptions(merge: true));
      if (!mounted) return;
      Constants.showMessage(context, 'Added/Updated successfully');
      await _loadTemplate();
    } catch (e) {
      debugPrint('Error saving "Template 5": $e');
      if (!mounted) return;
      Constants.showMessage(context, 'Error: $e');
    } finally {
      isSaving.value = false;
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
      companyPhoneController.text = address.companyContact1 ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    final isRtl = context.locale.languageCode == 'ar';
    final regular = const TextStyle(
      fontFamily: 'Nunito',
      fontSize: 12,
      height: 1.0,
      fontWeight: FontWeight.w400,
    );
    final bold = const TextStyle(
      fontFamily: 'Nunito',
      fontSize: 12,
      height: 1.0,
      fontWeight: FontWeight.w700,
    );

    const blue = Color(0xFF44B1D9);
    const double pageWidth = 800;

    return Directionality(
      textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Template5 Preview'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Container(
                    width: context.width * 0.3,
                    height: context.height,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (type == 'logo') ...[
                            Row(
                              children: [
                                PickerWidget(
                                  multipleAllowed: true,
                                  attachments: attachments,
                                  galleryAllowed: true,
                                  onFilesPicked: _onFilesPicked,
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
                                    child: _logoPickerPreview(),
                                  ),
                                ),
                                14.w,
                                SizedBox(
                                  height: context.height * 0.06,
                                  width: context.height * 0.22,
                                  child: CustomButton(
                                    loadingNotifier: isSaving,
                                    text: 'Upload Logo'.tr(),
                                    onPressed: add,
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
                              style: AppTheme.getCurrentTheme(
                                false,
                                connectionStatus,
                              ).textTheme.bodyMedium!.copyWith(fontSize: 12),
                            ),
                          ],
                          if (type == 'company details') ...[
                            12.h,
                            CustomMmTextField(
                              controller: companyNameController,
                              hintText: 'Company Name',
                              maxLines: 2,
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: companyAddressController,
                              hintText: 'Company Address',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: vatNoController,
                              hintText: 'VAT No',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: companyPhoneController,
                              hintText: 'Phone Number',
                            ),
                            12.h,
                            CustomButton(
                              loadingNotifier: isSaving,
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
                  ),

                  SizedBox(width: context.width * 0.08),

                  // RIGHT: PREVIEW
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: pageWidth,
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: Column(
                            children: [
                              10.h,

                              // — Header area (row of 3 zones) —
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Left: "Invoice" tag + #number
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Invoice',
                                          style: bold.copyWith(fontSize: 18),
                                        ),
                                        8.h,
                                        Text(
                                          '#$invoiceNumber',
                                          style: bold.copyWith(fontSize: 14),
                                        ),
                                      ],
                                    ),

                                    // Center: Logo (150 x 150)
                                    InkWell(
                                      onTap: () =>
                                          setState(() => type = 'logo'),
                                      child: _headerLogo(
                                        url: estimationTemplatePreviewModel
                                            ?.headerLogo,
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          type = 'company details';
                                          setControllers();
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            estimationTemplatePreviewModel
                                                    ?.companyDetails
                                                    .companyName ??
                                                'ABC LIMITED',
                                            textAlign: TextAlign.end,
                                            style: bold.copyWith(
                                              fontSize: 14,
                                              color: blue,
                                            ),
                                          ),
                                          6.h,
                                          Text(
                                            estimationTemplatePreviewModel
                                                    ?.companyDetails
                                                    .companyAddress ??
                                                'DHA PHASE 2, Q Block',
                                            style: regular.copyWith(
                                              fontSize: 10,
                                              color: blue,
                                            ),
                                          ),
                                          Text(
                                            estimationTemplatePreviewModel
                                                    ?.companyDetails
                                                    .vatNo ??
                                                'OM3232323',
                                            style: regular.copyWith(
                                              fontSize: 10,
                                              color: blue,
                                            ),
                                          ),
                                          Text(
                                            estimationTemplatePreviewModel
                                                    ?.companyDetails
                                                    .companyContact1 ??
                                                '+924334343434',
                                            style: regular.copyWith(
                                              fontSize: 10,
                                              color: blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              10.h,

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left side column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Invoice Date',
                                          style: regular.copyWith(
                                            fontSize: 12,
                                            color: blue,
                                          ),
                                        ),
                                        6.h,
                                        Text(
                                          invoiceDate.formattedWithDayMonthYear,
                                          style: bold.copyWith(fontSize: 14),
                                        ),
                                        6.h,
                                        Text(
                                          'Add Field',
                                          style: regular.copyWith(fontSize: 12),
                                        ),
                                        10.h,
                                        Row(
                                          children: [
                                            Text(
                                              'Paid',
                                              style: regular.copyWith(
                                                fontSize: 12,
                                                color: blue,
                                              ),
                                            ),
                                            10.w,
                                            Text(
                                              '${paid.toStringAsFixed(1)} OMR',
                                              style: regular,
                                            ),
                                          ],
                                        ),
                                        4.h,
                                        Row(
                                          children: [
                                            Text(
                                              'Balance Due',
                                              style: regular.copyWith(
                                                fontSize: 12,
                                                color: blue,
                                              ),
                                            ),
                                            10.w,
                                            Text(
                                              '${(total - paid).toStringAsFixed(2)} OMR',
                                              style: regular,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.w,
                                  // Right side: Bill To (blue, right aligned)
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Bill To:',
                                            style: regular.copyWith(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                          2.h,
                                          Text(
                                            businessName,
                                            style: regular.copyWith(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                          2.h,
                                          Text(
                                            customerName,
                                            style: regular.copyWith(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                          2.h,
                                          Text(
                                            contactNumber,
                                            style: regular.copyWith(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                          2.h,
                                          Text(
                                            telephoneNumber,
                                            style: regular.copyWith(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                          2.h,
                                          Text(
                                            '$street1, $street2,',
                                            style: regular.copyWith(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                          2.h,
                                          Text(
                                            '$city, $state, $postal',
                                            style: regular.copyWith(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              20.h,
                              ItemsTableT5(
                                rows: _rows,
                                regular: regular,
                                bold: bold,
                              ),
                              20.h,
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 260,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      10.h,
                                      KV(
                                        bold: bold,
                                        regular: regular,
                                        k: 'Total'.tr(),
                                        v: '${total.toStringAsFixed(2)} ${"OMR".tr()}',
                                        isTotal: true,
                                      ),
                                      10.h,
                                      KV(
                                        bold: bold,
                                        regular: regular,
                                        k: 'Paid'.tr(),
                                        v: '${paid.toStringAsFixed(1)} ${"OMR".tr()}',
                                      ),
                                      10.h,
                                      KV(
                                        bold: bold,
                                        regular: regular,
                                        k: 'Balance Due'.tr(),
                                        v: '${(total - paid).toStringAsFixed(2)} ${"OMR".tr()}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              40.h,

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Please be advised  ',
                                    style: bold.copyWith(fontSize: 12),
                                    children: [
                                      TextSpan(
                                        text:
                                            "So strange. I copied and pasted your example and it worked. But when I go back to my files and add the in the header it didn't work. I compared my files to your example. ",
                                        style: regular.copyWith(fontSize: 12),
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }

  Widget _logoPickerPreview() {
    if (attachments.isNotEmpty) {
      final last = attachments.last;
      if (kIsWeb && last.bytes != null) {
        return Image.memory(last.bytes!, fit: BoxFit.cover);
      } else if ((last.url).isNotEmpty) {
        return Image.file(File(last.url), fit: BoxFit.cover);
      } else if (last.bytes != null) {
        return Image.memory(last.bytes!, fit: BoxFit.cover);
      }
    }
    return Image.asset('assets/images/logo1.png', fit: BoxFit.contain);
  }

  Widget _headerLogo({String? url}) {
    final w = 150.0, h = 70.0;
    if (url != null && url.isNotEmpty) {
      return Image.network(url, width: w, height: h, fit: BoxFit.contain);
    }
    return Image.asset(
      'assets/images/logo.png',
      width: w,
      height: h,
      fit: BoxFit.contain,
    );
  }
}
