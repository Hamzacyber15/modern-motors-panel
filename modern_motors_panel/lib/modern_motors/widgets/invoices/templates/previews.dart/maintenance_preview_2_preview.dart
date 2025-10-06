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
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/maintenace_header_section_static.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class MaintenanceTemplate2Preview extends StatefulWidget {
  const MaintenanceTemplate2Preview({super.key});

  @override
  State<MaintenanceTemplate2Preview> createState() =>
      _MaintenanceTemplate1PreviewState();
}

class _MaintenanceTemplate1PreviewState
    extends State<MaintenanceTemplate2Preview> {
  String type = 'logo';
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  DefaultAddressModel? defaultAddressModel;
  BankDetails? bankDetails;
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<bool> saving = ValueNotifier(false);
  final streetController1L1 = TextEditingController();
  final streetController1L2 = TextEditingController();
  final streetController1L3 = TextEditingController();

  final streetController2L1 = TextEditingController();
  final streetController2L2 = TextEditingController();
  final streetController2L3 = TextEditingController();

  final email1 = TextEditingController(text: 'oman@ihthiyati.com');
  final email2 = TextEditingController(text: 'sohar@ihthiyati.com');

  final phoneWebController = TextEditingController();
  final phoneWebController2 = TextEditingController();
  final websiteController = TextEditingController();
  final companyNameController = TextEditingController();

  bool isLoading = false;

  // logo picking
  List<AttachmentModel> attachments = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    streetController1L1.dispose();
    streetController1L2.dispose();
    streetController1L3.dispose();

    streetController2L1.dispose();
    streetController2L2.dispose();
    streetController2L3.dispose();

    email1.dispose();
    email2.dispose();

    phoneWebController.dispose();
    phoneWebController2.dispose();
    websiteController.dispose();
    companyNameController.dispose();

    super.dispose();
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
        DataFetchService.fetchEstimationTemplateData('Maintenance Template 2'),
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

  Future<void> add() async {
    if (loading.value) return;
    loading.value = true;

    List<String> urls = [];
    try {
      Map<String, dynamic> data = {};
      String? docId;

      if (type == 'logo') {
        for (final a in attachments) {
          final url = await Constants.uploadAttachment(a);
          urls.add(url);
        }
        data = {
          'type': 'Maintenance Template 2',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'headerLogo': urls.isNotEmpty ? urls.first : null,
        };
      } else if (type == 'company details') {
        data = {
          'type': 'Maintenance Template 2',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {
            'companyContact1': phoneWebController.text,
            'addressLine1': streetController1L1.text,
            'addressLine2': streetController1L2.text,
            'addressLine3': streetController1L3.text,
            'email': email1.text,

            // EN second block / branch (contact + 3 address lines + email2)
            'companyContact2': phoneWebController2.text,
            'address2Line1': streetController2L1.text,
            'address2Line2': streetController2L2.text,
            'address2Line3': streetController2L3.text,
            'email2': email2.text,
          },
        };
      } else if (type == 'company details ar') {
        data = {
          'type': 'Maintenance Template 2',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {
            'companyContact1Ar': phoneWebController.text,
            'addressLine1Ar': streetController1L1.text,
            'addressLine2Ar': streetController1L2.text,
            'addressLine3Ar': streetController1L3.text,
            'emailAr': email1.text,
            'companyContact2Ar': phoneWebController2.text,
            'address2Line1Ar': streetController2L1.text,
            'address2Line2Ar': streetController2L2.text,
            'address2Line3Ar': streetController2L3.text,
            'email2Ar': email2.text,
          },
        };
      } else if (type == 'website') {
        data = {
          'type': 'Maintenance Template 2',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {'website': websiteController.text},
        };
      } else if (type == 'company Name') {
        data = {
          'type': 'Maintenance Template 2',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {'companyName': companyNameController.text},
        };
      }

      final query = await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .where('type', isEqualTo: 'Maintenance Template 2')
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
      await loadData();
    } catch (e) {
      debugPrint('Error while changing value in Maintenance Template 1: $e');
      if (!mounted) return;
      Constants.showMessage(context, 'Error: $e');
    } finally {
      loading.value = false;
    }
  }

  void setDefaultControllers({
    required String type,
    DefaultAddressModel? address,
    BankDetails? bank,
  }) {
    debugPrint('Setting default controllers for type: $type');
    if ((type == 'company details' || type == 'company details ar') &&
        address != null) {
      phoneWebController.text = address.companyContact1 ?? '';
      streetController1L1.text = type == 'company details'
          ? address.addressLine1 ?? ''
          : address.addressLine1Ar ?? '';
      streetController1L2.text = type == 'company details'
          ? address.addressLine2 ?? ''
          : address.addressLine2Ar ?? '';
      streetController1L3.text = type == 'company details'
          ? address.addressLine3 ?? ''
          : address.addressLine3Ar ?? '';
      email1.text = address.email ?? '';

      phoneWebController2.text = address.companyContact2 ?? '';
      streetController2L1.text = type == 'company details'
          ? address.address2Line1 ?? ''
          : address.address2Line1Ar ?? '';
      streetController2L2.text = type == 'company details'
          ? address.address2Line2 ?? ''
          : address.address2Line2Ar ?? '';
      email2.text = address.email2 ?? '';
    }

    if (type == 'website' && address != null) {
      websiteController.text = address.website ?? '';
    }

    if (type == 'company Name' && address != null) {
      companyNameController.text = address.companyAddress ?? '';
    }
  }

  void setControllers() {
    final cd = estimationTemplatePreviewModel?.companyDetails;
    companyNameController.text = cd?.companyName ?? companyNameController.text;
    phoneWebController.text = cd?.companyContact1 ?? phoneWebController.text;
    streetController1L1.text = type == 'company details'
        ? cd?.addressLine1 ?? streetController1L1.text
        : cd?.addressLine1Ar ?? streetController1L1.text;
    streetController1L2.text = type == 'company details'
        ? cd?.addressLine2 ?? streetController1L2.text
        : cd?.addressLine2Ar ?? streetController1L2.text;
    streetController1L3.text = type == 'company details'
        ? cd?.addressLine3 ?? streetController1L3.text
        : cd?.addressLine3Ar ?? streetController1L3.text;
    email1.text = cd?.email ?? email1.text;

    websiteController.text = cd?.website ?? websiteController.text;
    phoneWebController2.text = cd?.companyContact2 ?? phoneWebController2.text;
    streetController2L1.text = type == 'company details'
        ? cd?.address2Line1 ?? streetController2L1.text
        : cd?.address2Line1Ar ?? streetController2L1.text;
    streetController2L2.text = type == 'company details'
        ? cd?.address2Line2 ?? streetController2L2.text
        : cd?.address2Line2Ar ?? streetController2L2.text;
    streetController2L3.text = type == 'company details'
        ? cd?.address2Line3 ?? streetController2L3.text
        : cd?.address2Line3Ar ?? streetController2L3.text;
    email2.text = cd?.email2 ?? email2.text;
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    final isRtl = context.locale.languageCode == 'ar';
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
                          if (type == 'company details' ||
                              type == 'company details ar') ...[
                            Text('Detail 1'),
                            12.h,
                            CustomMmTextField(
                              controller: phoneWebController,
                              hintText: 'Contact Number',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: streetController1L1,
                              hintText: 'Street Address Line 1',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: streetController1L2,
                              hintText: 'Street Address Line 2',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: streetController1L3,
                              hintText: 'Street Address Line 3',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: email1,
                              hintText: 'Email 1',
                            ),
                            12.h,
                            Text('Detail 1'),
                            CustomMmTextField(
                              controller: phoneWebController2,
                              hintText: 'Contact Number',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: streetController2L1,
                              hintText: 'Street Address Line 1',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: streetController2L2,
                              hintText: 'Street Address Line 2',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: email2,
                              hintText: 'Email 1',
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
                          if (type == 'website') ...[
                            12.h,
                            CustomMmTextField(
                              controller: websiteController,
                              hintText: 'Enter website',
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
                          if (type == 'company Name') ...[
                            12.h,
                            CustomMmTextField(
                              controller: companyNameController,
                              hintText: 'Enter Company Name',
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
                      child: Column(
                        children: [
                          MaintenanceHeaderSectionStatic(
                            onCompanyTapAr: () {
                              setState(() {
                                type = 'company details ar';
                                setControllers();
                              });
                            },
                            onCompanyTapEn: () {
                              setState(() {
                                type = 'company details';
                                setControllers();
                              });
                            },
                            onLogoTap: () {
                              setState(() => type = 'logo');
                            },
                            onWebsiteTap: () {
                              setState(() => type = 'website');
                            },
                            template: estimationTemplatePreviewModel,
                          ),
                          (context.height * 0.1).dh,
                          MaintenanceFooterSectionStatic(
                            onCompanyTap: () {
                              setState(() {
                                type = 'company Name';
                                setControllers();
                              });
                            },
                            template: estimationTemplatePreviewModel,
                          ),
                        ],
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
