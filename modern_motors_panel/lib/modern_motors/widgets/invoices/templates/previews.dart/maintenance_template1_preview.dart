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
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/mainenance_template_1_preview_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class MaintenanceTemplate1Preview extends StatefulWidget {
  const MaintenanceTemplate1Preview({super.key});

  @override
  State<MaintenanceTemplate1Preview> createState() =>
      _MaintenanceTemplate1PreviewState();
}

class _MaintenanceTemplate1PreviewState
    extends State<MaintenanceTemplate1Preview> {
  String type = 'logo';
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  DefaultAddressModel? defaultAddressModel;
  BankDetails? bankDetails;
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<bool> saving = ValueNotifier(false);
  final vatInController = TextEditingController();
  final taxCardNumberController = TextEditingController();
  final vinNumberController = TextEditingController();

  final branchControllerL1 = TextEditingController();
  final branchControllerL2 = TextEditingController();
  final faxNumberController = TextEditingController();

  final bankNameController = TextEditingController();
  final emailController = TextEditingController();
  final crNumberController = TextEditingController();
  final faxController = TextEditingController();

  final phoneWebController = TextEditingController();
  final accountNumberController = TextEditingController();
  final websiteController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyNameControllerAr = TextEditingController();

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
    vatInController.dispose();
    taxCardNumberController.dispose();
    vinNumberController.dispose();

    branchControllerL1.dispose();
    branchControllerL2.dispose();
    faxNumberController.dispose();

    bankNameController.dispose();
    emailController.dispose();

    phoneWebController.dispose();
    accountNumberController.dispose();
    websiteController.dispose();
    companyNameController.dispose();

    super.dispose();
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() => attachments = files);
  }

  // Future<void> loadData() async {
  //   if (isLoading) return;
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final estimationTemplate =
  //         await DataFetchService.fetchEstimationTemplateData(
  //           'Maintenance Template 1',
  //         );
  //     estimationTemplatePreviewModel = estimationTemplate!;
  //
  //     setControllers();
  //   } catch (e) {
  //     debugPrint('Error fetching template data: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> loadData() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final results = await Future.wait([
        DataFetchService.fetchEstimationTemplateData('Maintenance Template 1'),
        DataFetchService.fetchDefaultAddress(),
        DataFetchService.fetchDefaultBank(),
      ]);

      estimationTemplatePreviewModel =
          results[0] as EstimationTemplatePreviewModel?;
      defaultAddressModel = results[1] as DefaultAddressModel?;
      bankDetails = results[2] as BankDetails?;
      setControllers();
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void setDefaultControllers({
    required String type,
    DefaultAddressModel? address,
    BankDetails? bank,
  }) {
    if (address != null) {
      if (type == 'branch details') {
        phoneWebController.text = address.companyContact1 ?? '';
        branchControllerL1.text = address.branchLine1 ?? '';
        branchControllerL2.text = address.branchLine2 ?? '';
        vinNumberController.text = address.addressLine1 ?? '';
      }

      if (type == 'bottomAddress') {
        companyNameController.text = address.companyAddress ?? '';
        companyNameControllerAr.text = address.addressLine1Ar ?? '';
        phoneWebController.text = address.companyContact1 ?? '';
        emailController.text = address.email ?? '';
        websiteController.text = address.website ?? '';
      }
    }

    if (bank != null) {
      if (type == 'branch details') {
        bankNameController.text = bank.bankName ?? '';
        accountNumberController.text = bank.accountNumber ?? '';
      }
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
          'type': 'Maintenance Template 1',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'headerLogo': urls.isNotEmpty ? urls.first : null,
        };
      }
      // if (type == 'bottomRightLogo') {
      //   for (final a in attachments) {
      //     final url = await Constants.uploadAttachment(a);
      //     urls.add(url);
      //   }
      //   data = {
      //     'type': 'Maintenance Template 1',
      //     'timestamp': estimationTemplatePreviewModel?.timestamp ??
      //         FieldValue.serverTimestamp(),
      //     'bottomRightLogo': urls.isNotEmpty ? urls.first : null,
      //   };
      // }
      // if (type == 'bottomLeftLogo') {
      //   for (final a in attachments) {
      //     final url = await Constants.uploadAttachment(a);
      //     urls.add(url);
      //   }
      //   data = {
      //     'type': 'Maintenance Template 1',
      //     'timestamp': estimationTemplatePreviewModel?.timestamp ??
      //         FieldValue.serverTimestamp(),
      //     'bottomLeftLogo': urls.isNotEmpty ? urls.first : null,
      //   };
      // }
      else if (type == 'branch details') {
        data = {
          'type': 'Maintenance Template 1',
          'timestamp':
              estimationTemplatePreviewModel?.timestamp ??
              FieldValue.serverTimestamp(),
          'companyDetails': {
            'companyContact1': phoneWebController.text,
            'branchLine1': branchControllerL1.text,
            'branchLine2': branchControllerL2.text,
            // 'faxNumber': vinNumberController.text,
            'vinNumber': vinNumberController.text,
          },
          'bank1Details': {
            'bankName': bankNameController.text,
            'accountNumber': accountNumberController.text,
          },
        };
      } else if (type == 'onTaxCardTap') {
        data = {
          'type': 'Maintenance Template 1',
          'companyDetails': {
            'vatNo': vatInController.text,
            'taxCardNumber': taxCardNumberController.text,
          },
        };
      } else if (type == 'bottomAddress') {
        data = {
          'type': 'Maintenance Template 1',
          'companyDetails': {
            'website': websiteController.text,
            'companyName': companyNameController.text,
            'companyNameAr': companyNameControllerAr.text,
            'faxNumber': faxController.text,
            'companyContact2': phoneWebController.text,
            'email': emailController.text,
            'crNumber': crNumberController.text,
          },
        };
      }

      final query = await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .where('type', isEqualTo: 'Maintenance Template 1')
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

  void setControllers() {
    final cd = estimationTemplatePreviewModel?.companyDetails;
    final bd = estimationTemplatePreviewModel?.bank1Details;

    websiteController.text = cd?.website ?? websiteController.text;

    // EN secondary/branch block (right column in EN section)
    accountNumberController.text =
        bd?.accountNumber ?? accountNumberController.text;
    branchControllerL1.text = cd?.branchLine1 ?? branchControllerL1.text;
    branchControllerL2.text = cd?.branchLine2 ?? branchControllerL2.text;
    vinNumberController.text = cd?.vinNumber ?? vinNumberController.text;
    phoneWebController.text = type == 'bottomAddress'
        ? cd?.companyContact1 ?? phoneWebController.text
        : cd?.companyContact2 ?? phoneWebController.text;
    bankNameController.text = bd?.bankName ?? bankNameController.text;
    vatInController.text = cd?.vatNo ?? vatInController.text;
    taxCardNumberController.text =
        cd?.taxCardNumber ?? taxCardNumberController.text;

    emailController.text = cd?.email ?? emailController.text;
    faxController.text = cd?.faxNumber ?? faxController.text;
    companyNameControllerAr.text =
        cd?.companyNameAr ?? companyNameControllerAr.text;
    companyNameController.text = cd?.companyName ?? companyNameController.text;
    crNumberController.text = cd?.crNumber ?? crNumberController.text;
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
                          if (type == 'logo' ||
                              type == 'bottomRightLogo' ||
                              type == 'bottomLeftLogo') ...[
                            Text(
                              type == 'logo'
                                  ? 'Header Logo'
                                  : type == 'bottomRightLogo'
                                  ? 'Bottom Right Logo'
                                  : 'Bottom Left Logo',
                            ),
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
                          if (type == 'branch details') ...[
                            12.h,
                            CustomMmTextField(
                              controller: phoneWebController,
                              hintText: 'Phone Number',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: branchControllerL1,
                              hintText: 'Branch Address Line 1',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: branchControllerL2,
                              hintText: 'Branch Address Line 2',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: vinNumberController,
                              hintText: 'Enter VIN Number',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: bankNameController,
                              hintText: 'Bank Name',
                            ),
                            12.h,
                            CustomMmTextField(
                              controller: accountNumberController,
                              hintText: 'Account Number',
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
                                  type: 'branch details',
                                  address: defaultAddressModel,
                                  bank: bankDetails,
                                );
                              },
                              text: 'Set Default Values',
                            ),
                          ],
                          if (type == 'onTaxCardTap') ...[
                            CustomMmTextField(
                              controller: vatInController,
                              hintText: 'VATIN Number',
                            ),
                            8.h,
                            CustomMmTextField(
                              controller: taxCardNumberController,
                              hintText: 'Tax Card Number',
                            ),
                            12.h,
                            CustomButton(
                              loadingNotifier: loading,
                              onPressed: add,
                              text: 'Save Changes',
                            ),
                          ],
                          if (type == 'bottomAddress') ...[
                            12.h,
                            CustomMmTextField(
                              controller: companyNameController,
                              hintText: 'Enter Company Name',
                            ),
                            12.h,
                            CustomMmTextField(
                              controller: companyNameControllerAr,
                              hintText: 'Enter Company Name in arabic',
                            ),
                            12.h,
                            CustomMmTextField(
                              controller: phoneWebController,
                              hintText: 'Enter Tel Number',
                            ),
                            12.h,
                            CustomMmTextField(
                              controller: faxNumberController,
                              hintText: 'Enter Fax Number',
                            ),
                            12.h,
                            CustomMmTextField(
                              controller: crNumberController,
                              hintText: 'Enter Cr Number',
                            ),
                            12.h,
                            CustomMmTextField(
                              controller: emailController,
                              hintText: 'Enter Email Address',
                            ),
                            12.h,
                            CustomMmTextField(
                              controller: websiteController,
                              hintText: 'Enter website URL',
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
                                  type: 'bottomAddress',
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
                          MaintenanceTemplate1Body(
                            onHeaderLogoTap: () {
                              setState(() {
                                type = 'logo';
                              });
                              debugPrint('type: $type');
                            },
                            onBottomAddress: () {
                              setState(() {
                                type = 'bottomAddress';
                              });
                              setControllers();
                            },
                            onBranchTap: () {
                              setState(() {
                                type = 'branch details';
                              });
                              setControllers();
                            },
                            onTaxCardTap: () {
                              setState(() {
                                type = 'onTaxCardTap';
                              });
                            },
                            estimationTemplatePreviewModel:
                                estimationTemplatePreviewModel!,
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
