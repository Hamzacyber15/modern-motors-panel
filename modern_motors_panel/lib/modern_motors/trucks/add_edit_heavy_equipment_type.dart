import 'dart:io';
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
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/heavy_equipment_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class AddEditHeavyEquipmentType extends StatefulWidget {
  final VoidCallback? onBack;
  final HeavyEquipmentTypeModel? heavyEquipment;
  final bool isEdit;

  const AddEditHeavyEquipmentType({
    super.key,
    this.onBack,
    this.heavyEquipment,
    required this.isEdit,
  });

  @override
  State<AddEditHeavyEquipmentType> createState() =>
      _AddEditHeavyEquipmentTypeState();
}

class _AddEditHeavyEquipmentTypeState extends State<AddEditHeavyEquipmentType> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameArabicController = TextEditingController();
  final TextEditingController descriptionArabicController =
      TextEditingController();

  ValueNotifier<bool> loading = ValueNotifier(false);
  List<AttachmentModel> attachments = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool status = true; // <-- Add this (default active)

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.heavyEquipment != null) {
      final data = widget.heavyEquipment!;
      nameController.text = data.name;
      descriptionController.text = data.description;
      nameArabicController.text = data.nameArabic;
      descriptionArabicController.text = data.descriptionArabic;

      /// <-- set status from existing data
      status = data.status == "active";
      if (data.image != null && data.image!.isNotEmpty) {}
    }
  }

  Future<void> submitHeavyEquipment() async {
    if (loading.value) return;
    loading.value = true;

    try {
      final model = HeavyEquipmentTypeModel(
        id: widget.heavyEquipment?.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        nameArabic: nameArabicController.text.trim(),
        descriptionArabic: descriptionArabicController.text.trim(),
        image: attachments.isNotEmpty ? attachments.last.url : null,
        status: status ? 'active' : 'inactive', // <-- use status here
        timestamp: Timestamp.now(),
      );

      if (widget.isEdit && widget.heavyEquipment?.id != null) {
        await FirebaseFirestore.instance
            .collection('heavyEquipmentType')
            .doc(widget.heavyEquipment!.id)
            .update(model.toMapForUpdate())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(
                context,
                'Equipment updated successfully'.tr(),
              );
              widget.onBack?.call();
            })
            .catchError((e) {
              Constants.showMessage(context, 'Failed to update: $e');
            });
      } else {
        await FirebaseFirestore.instance
            .collection('heavyEquipmentType')
            .add(model.toMapForAdd())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(
                context,
                'Equipment added successfully'.tr(),
              );
              widget.onBack?.call();
            })
            .catchError((e) {
              Constants.showMessage(context, 'Failed to add: $e');
            });
      }
    } catch (e) {
      Constants.showMessage(context, 'Something went wrong: $e');
    } finally {
      loading.value = false;
    }
  }

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
    });
  }

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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeaderWidget(
            title: widget.isEdit ? 'Edit Equipment'.tr() : 'Add Equipment'.tr(),
            buttonText: 'Back'.tr(),
            subTitle: widget.isEdit
                ? 'Update Existing Equipment'.tr()
                : 'Create New Equipment'.tr(),
            onCreateIcon: 'assets/icons/back.png',
            selectedItems: [],
            buttonWidth: 0.4,
            onCreate: widget.onBack?.call,
            onDelete: () async {},
          ),
        ),
        SliverToBoxAdapter(
          child: OverlayLoader(
            loader: loading.value,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor, width: 0.6),
                ),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        /// --- Fields
                        Row(
                          children: [
                            Expanded(
                              child: CustomMmTextField(
                                labelText: 'Name (English)'.tr(),
                                hintText: 'Enter Name'.tr(),
                                controller: nameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.heavyEquipmentName,
                              ),
                            ),
                            10.w,
                            Expanded(
                              child: CustomMmTextField(
                                labelText: 'Name (Arabic)'.tr(),
                                hintText: 'Enter Name in Arabic'.tr(),
                                controller: nameArabicController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator:
                                    ValidationUtils.heavyEquipmentArabicName,
                              ),
                            ),
                          ],
                        ),
                        14.h,
                        Row(
                          children: [
                            Expanded(
                              child: CustomMmTextField(
                                labelText: 'Description (English)'.tr(),
                                hintText: 'Enter Description'.tr(),
                                controller: descriptionController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator:
                                    ValidationUtils.heavyEquipmentDescription,
                                maxLines: 3,
                              ),
                            ),
                            10.w,
                            Expanded(
                              child: CustomMmTextField(
                                labelText: 'Description (Arabic)'.tr(),
                                hintText: 'Enter Description in Arabic'.tr(),
                                controller: descriptionArabicController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils
                                    .heavyEquipmentArabicDescription,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),

                        12.h,

                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 20,
                                ),
                                child: StatusSwitchWidget(
                                  title: 'Status'.tr(),
                                  isSwitched: status,
                                  onChanged: toggleSwitch,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                        20.h,
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
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_circle_outline_rounded,
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

                        20.h,
                        AlertDialogBottomWidget(
                          title: widget.isEdit
                              ? 'Update Equipment'.tr()
                              : 'Create Equipment'.tr(),
                          onCreate: () {
                            if (formKey.currentState!.validate()) {
                              submitHeavyEquipment();
                            }
                          },
                          onCancel: widget.onBack?.call,
                          loadingNotifier: loading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
