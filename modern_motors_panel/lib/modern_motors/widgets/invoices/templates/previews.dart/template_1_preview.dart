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
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/template_1_preview_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class Template1Preview extends StatefulWidget {
  const Template1Preview({super.key});

  @override
  State<Template1Preview> createState() => _Template1PreviewState();
}

class _Template1PreviewState extends State<Template1Preview> {
  String type = 'logo';
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  DefaultAddressModel? defaultAddressModel;
  BankDetails? bankDetails;
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final companyNameController = TextEditingController();
  final streetController = TextEditingController(text: 'Street Address');
  final cityController = TextEditingController(text: 'City: Lahore');
  final phoneWebController = TextEditingController(
    text: 'Phone Number: Web Address etc',
  );
  bool isLoading = false;

  // logo picking
  List<AttachmentModel> attachments = [];

  final invoiceNumber = 'INV-000987';
  final invoiceDate = '2025-09-09';
  final issueDate = '2025-09-10';
  final dueDate = '2025-09-15';

  final companyName = 'Your Company Name';
  final streetAddress = 'Street Address';
  final city = 'Lahore';
  final phone = '+32323232323';
  final billToBusiness = 'Acme LLC';
  final billToCustomer = 'Jane Doe';
  final billToPhone = '00971-555-123456';
  final billToAddr1 = 'Main Street 12, Suite 4';
  final billToAddr2 = 'Dubai';
  final billToStateZip = 'DXB, UAE 00000';

  final _rows = const [
    T1Row(
      item: 'Item A',
      desc: 'Nice quality, size M',
      qty: 2,
      unit: 12.50,
      subtotal: 25.00,
    ),
    T1Row(
      item: 'Item B',
      desc: 'Extra feature',
      qty: 1,
      unit: 40.00,
      subtotal: 40.00,
    ),
    T1Row(
      item: 'Item C',
      desc: 'Limited edition',
      qty: 3,
      unit: 10.00,
      subtotal: 30.00,
    ),
  ];

  final double itemsTotal = 95.00;
  final double discount = 5.00;
  final double subTotal = 90.00;
  final double tax = 4.50;
  final double total = 94.50;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    streetController.dispose();
    cityController.dispose();
    phoneWebController.dispose();
    super.dispose();
  }

  void setControllers() {
    companyNameController.text =
        estimationTemplatePreviewModel?.companyDetails.companyName ??
        companyName;
    streetController.text =
        estimationTemplatePreviewModel?.companyDetails.streetAddress ??
        streetAddress;
    cityController.text =
        estimationTemplatePreviewModel?.companyDetails.city ?? city;
    phoneWebController.text =
        estimationTemplatePreviewModel?.companyDetails.companyContact1 ?? phone;
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() => attachments = files);
  }

  Future<void> loadData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final results = await Future.wait([
        DataFetchService.fetchEstimationTemplateData('Template 1'),
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
          'type': 'Template 1',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'headerLogo': urls.isNotEmpty ? urls.first : null,
        };
      } else if (type == 'company details') {
        data = {
          'type': 'Template 1',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {
            'companyName': companyNameController.text,
            'streetAddress': streetController.text,
            'city': cityController.text,
            'companyContact1': phoneWebController.text,
          },
        };
      }
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .where('type', isEqualTo: 'Template 1')
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
      debugPrint('Error while changing value in template 1 template: $e');
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
    if (type == 'company details' && address != null) {
      companyNameController.text = address.companyName ?? '';
      streetController.text = address.streetAddress ?? '';
      phoneWebController.text = address.companyContact1 ?? '';
      cityController.text = address.city ?? '';
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

    // A4ish width
    const double pageWidth = 800;

    return Directionality(
      textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Template1 Preview'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  // LEFT PANEL
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
                                        : Image.asset(
                                            'assets/images/logo1.png',
                                          ),
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
                          ],
                          if (type == 'company details') ...[
                            12.h,
                            CustomMmTextField(
                              controller: companyNameController,
                              hintText: 'Company Name',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: streetController,
                              hintText: 'Street Address',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: cityController,
                              hintText: 'City line',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: phoneWebController,
                              hintText: 'Phone/Web',
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
                  ),

                  SizedBox(width: context.width * 0.08),

                  // RIGHT: PREVIEW (PDF → FLUTTER)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: pageWidth,
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: Column(
                            children: [
                              // Header
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // logo + company block
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                setState(() => type = 'logo'),
                                            child:
                                                estimationTemplatePreviewModel
                                                        ?.headerLogo ==
                                                    null
                                                ? Image.asset(
                                                    'assets/images/logo.png',
                                                    width: 150,
                                                    height: 90,
                                                  )
                                                : Image.network(
                                                    estimationTemplatePreviewModel!
                                                        .headerLogo!,
                                                    //'assets/images/logo.png',
                                                    width: 150,
                                                    height: 90,
                                                  ),
                                          ),
                                          SizedBox(width: context.width * 0.03),
                                          InkWell(
                                            onTap: () => setState(() {
                                              setControllers();
                                              type = 'company details';
                                            }),
                                            // () => setState(
                                            //   () => type = 'company details',
                                            // ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  estimationTemplatePreviewModel
                                                          ?.companyDetails
                                                          .companyName ??
                                                      companyName,
                                                  style: bold.copyWith(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                4.h,
                                                Text(
                                                  estimationTemplatePreviewModel
                                                          ?.companyDetails
                                                          .streetAddress ??
                                                      streetAddress,
                                                  style: regular.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                2.h,
                                                Text(
                                                  estimationTemplatePreviewModel
                                                          ?.companyDetails
                                                          .city ??
                                                      city,
                                                  style: regular.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                2.h,
                                                Text(
                                                  estimationTemplatePreviewModel
                                                          ?.companyDetails
                                                          .companyContact1 ??
                                                      phone,
                                                  style: regular.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Tax Invoice',
                                      style: bold.copyWith(fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              20.h,

                              // Bill To + Meta
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Bill To
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bill To:',
                                          style: bold.copyWith(fontSize: 12),
                                        ),
                                        8.w,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              billToBusiness,
                                              style: regular,
                                            ),
                                            Text(
                                              billToCustomer,
                                              style: regular,
                                            ),
                                            Text(billToPhone, style: regular),
                                            Text(billToAddr1, style: regular),
                                            Text(
                                              '$billToAddr2, $billToStateZip',
                                              style: regular,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Invoice meta
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MetaRow(
                                          label: 'Invoice #',
                                          value: invoiceNumber,
                                          regular: regular,
                                          bold: bold,
                                        ),
                                        MetaRow(
                                          label: 'Invoice Date',
                                          value: invoiceDate,
                                          regular: regular,
                                          bold: bold,
                                        ),
                                        MetaRow(
                                          label: 'Issue Date',
                                          value: issueDate,
                                          regular: regular,
                                          bold: bold,
                                        ),
                                        MetaRow(
                                          label: 'Due Date',
                                          value: dueDate,
                                          regular: regular,
                                          bold: bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              30.h,

                              // Items table (same columns as PDF)
                              TableHeader(bold: bold),
                              ..._rows.map(
                                (r) => TableRowItem(row: r, regular: regular),
                              ),

                              30.h,

                              // Totals (right aligned)
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 260,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      10.h,
                                      AmountRow(
                                        label: 'Items Total'.tr(),
                                        value:
                                            '${itemsTotal.toStringAsFixed(2)} ${"OMR".tr()}',
                                        regular: regular,
                                        bold: bold,
                                      ),
                                      AmountRow(
                                        label: 'Discount'.tr(),
                                        value:
                                            '${discount.toStringAsFixed(2)} ${"OMR".tr()}',
                                        regular: regular,
                                        bold: bold,
                                      ),
                                      AmountRow(
                                        label: 'SubTotal'.tr(),
                                        value:
                                            '${subTotal.toStringAsFixed(2)} ${"OMR".tr()}',
                                        regular: regular,
                                        bold: bold,
                                      ),
                                      AmountRow(
                                        label: 'Tax'.tr(),
                                        value:
                                            '${tax.toStringAsFixed(2)} ${"OMR".tr()}',
                                        regular: regular,
                                        bold: bold,
                                      ),
                                      AmountRow(
                                        label: 'Total'.tr(),
                                        value:
                                            '${total.toStringAsFixed(2)} ${"OMR".tr()}',
                                        regular: regular,
                                        bold: bold,
                                        emphasize: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              24.h,

                              // Rich text
                              Text.rich(
                                TextSpan(
                                  text: 'Please be advised  ',
                                  style: bold.copyWith(fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text:
                                          "So strange. I copied and pasted your example and it worked. But when I go back to my files and add the in the header it didn't work. I compared my files to your example. ",
                                      style: regular,
                                    ),
                                  ],
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
}
