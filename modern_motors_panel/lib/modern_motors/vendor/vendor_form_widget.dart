import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class VerdorFormWidget extends StatefulWidget {
  final VendorModel? vendorModel;
  final VoidCallback? onBack;
  final bool isEdit;

  const VerdorFormWidget({
    super.key,
    this.vendorModel,
    this.onBack,
    required this.isEdit,
  });

  @override
  State<VerdorFormWidget> createState() => _VerdorFormWidgetState();
}

class _VerdorFormWidgetState extends State<VerdorFormWidget> {
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappNumberController = TextEditingController();
  final _crNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _tempManagerNameController = TextEditingController();
  final _tempManagerNumberController = TextEditingController();
  final _tempManagerNationalityController = TextEditingController();
  List<AttachmentModel> attachments = [];
  bool status = true;
  ValueNotifier<bool> loading = ValueNotifier(false);
  GlobalKey<FormState> addVendorKey = GlobalKey<FormState>();

  List<Manager> managerList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.vendorModel != null) {
      final vendor = widget.vendorModel!;
      _companyNameController.text = vendor.vendorName;
      _crNumberController.text = vendor.crNumber ?? '';
      _addressController.text = vendor.address ?? '';
      _contactNumberController.text = vendor.contactNumber ?? '';
      _emailController.text = vendor.emailAddress ?? '';
      _whatsappNumberController.text = vendor.whatsappNumber ?? '';
      status = vendor.status == 'active' ? true : false;
      managerList = vendor.managers ?? [];
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _crNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _whatsappNumberController.dispose();
    _contactNumberController.dispose();
    _tempManagerNameController.dispose();
    _tempManagerNumberController.dispose();
    _tempManagerNationalityController.dispose();
    super.dispose();
  }

  void _addManager() {
    final name = _tempManagerNameController.text.trim();
    final number = _tempManagerNumberController.text.trim();
    final nationality = _tempManagerNationalityController.text.trim();

    setState(() {
      managerList.add(
        Manager(name: name, number: number, nationality: nationality),
      );
      _tempManagerNameController.clear();
      _tempManagerNumberController.clear();
      _tempManagerNationalityController.clear();
    });
  }

  void _submitVendor() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final vendor = VendorModel(
        vendorName: _companyNameController.text.trim(),
        crNumber: _crNumberController.text.trim(),
        address: _addressController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        imageUrl: '',
        emailAddress: _emailController.text.trim(),
        whatsappNumber: _whatsappNumberController.text.trim(),
        managers: managerList,
        status: status ? 'active' : 'inactive',
      );

      final vendorsRef = FirebaseFirestore.instance.collection('vendors');

      if (widget.isEdit) {
        await vendorsRef
            .doc(widget.vendorModel!.id)
            .update(vendor.toMap())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Vendor updated successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to update vendor: $error');
            });
      } else {
        await vendorsRef
            .add({...vendor.toMap(), 'timestamp': FieldValue.serverTimestamp()})
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Vendor added successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add vendor: $error');
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong');
      }
    } finally {
      loading.value = false;
    }
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                16.h,
                AlertDialogHeader(
                  title: widget.isEdit ? 'Update Vendor' : 'Add Vendor',
                ),
                Divider(),
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
                            border: Border.all(color: AppTheme.borderColor),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle_outline_rounded),
                                    Text('Add Image'),
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
                                  text: 'Upload Image',
                                  onPressed: () {},
                                  fontSize: 14,
                                  buttonType: ButtonType.Filled,
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          8.h,
                          Text(
                            'JPEG, PNG up to 2 MB',
                            style: AppTheme.getCurrentTheme(
                              false,
                              connectionStatus,
                            ).textTheme.bodyMedium!.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Form(
                    key: addVendorKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomMmTextField(
                                hintText: 'Enter company name',
                                labelText: 'Enter company name',
                                controller: _companyNameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validateCompanyName,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomMmTextField(
                                hintText: 'Enter CR Number',
                                labelText: 'Enter CR Number',
                                controller: _crNumberController,
                                inputFormatter: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validateCrNumber,
                              ),
                            ),
                          ],
                        ),
                        6.h,
                        Row(
                          children: [
                            Expanded(
                              child: CustomMmTextField(
                                hintText: 'Enter Address',
                                labelText: 'Enter Address',
                                controller: _addressController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validateAddress,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomMmTextField(
                                hintText: 'Enter Email Address (Optional)',
                                labelText: 'Enter Email',
                                controller: _emailController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator:
                                    ValidationUtils.validateOptionalEmail,
                              ),
                            ),
                          ],
                        ),
                        6.h,
                        Row(
                          children: [
                            Expanded(
                              child: CustomMmTextField(
                                hintText: 'Enter Whatsapp number',
                                labelText: 'Whatsapp Number',
                                controller: _whatsappNumberController,
                                inputFormatter: [
                                  LengthLimitingTextInputFormatter(20),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\+?\d{0,15}$'),
                                  ),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validatePhoneNumber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomMmTextField(
                                hintText: 'Enter Contact Number',
                                labelText: 'Enter Contact Number',
                                controller: _contactNumberController,
                                keyboardType: TextInputType.phone,
                                inputFormatter: [
                                  LengthLimitingTextInputFormatter(20),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\+?\d{0,15}$'),
                                  ),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validatePhoneNumber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Managers',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomMmTextField(
                                hintText: 'Manager Name',
                                labelText: 'Manager Name',
                                controller: _tempManagerNameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validateManagerName,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: CustomMmTextField(
                                hintText: 'Number',
                                labelText: 'Number',
                                controller: _tempManagerNumberController,
                                keyboardType: TextInputType.phone,
                                inputFormatter: [
                                  LengthLimitingTextInputFormatter(20),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\+?\d{0,15}$'),
                                  ),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validatePhoneNumber,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: CustomMmTextField(
                                labelText: 'Nationality',
                                hintText: 'Nationality',
                                controller: _tempManagerNationalityController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidationUtils.validateNationality,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: context.height * 0.064,
                              width: context.height * 0.067,
                              child: CustomButton(
                                onPressed: () {
                                  if (addVendorKey.currentState!.validate()) {
                                    _addManager();
                                  }
                                },
                                iconAsset: 'assets/icons/add_icon.png',
                                buttonType: ButtonType.IconOnly,
                                iconColor: AppTheme.whiteColor,
                                backgroundColor: AppTheme.primaryColor,
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Show Added Managers
                        if (managerList.isNotEmpty) ...[
                          Text(
                            'Added Managers:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ...managerList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final m = entry.value;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        size: 28,
                                        color: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              m.name,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  size: 16,
                                                  color: AppTheme.greyColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  m.number,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                                const SizedBox(width: 12),
                                                Icon(
                                                  Icons.flag_outlined,
                                                  size: 16,
                                                  color: AppTheme.greyColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  m.nationality,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Edit button: load values and remove old entry
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: AppTheme.redColor,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          final manager = managerList[index];
                                          _tempManagerNameController.text =
                                              manager.name;
                                          _tempManagerNumberController.text =
                                              manager.number;
                                          _tempManagerNationalityController
                                                  .text =
                                              manager.nationality;

                                          setState(() {
                                            managerList.removeAt(index);
                                          });
                                        },
                                      ),

                                      // Delete button
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: AppTheme.redColor,
                                          size: 16,
                                        ),
                                        onPressed: () => setState(
                                          () => managerList.removeAt(index),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20, thickness: 0.8),
                                ],
                              ),
                            );
                          }),
                        ],

                        StatusSwitchWidget(
                          isSwitched: status,
                          onChanged: toggleSwitch,
                        ),
                        16.h,
                      ],
                    ),
                  ),
                ),
                AlertDialogBottomWidget(
                  title: widget.isEdit ? 'Update Vendor' : 'Create Vendor',
                  onCreate: () {
                    if (managerList.isEmpty) {
                      if (addVendorKey.currentState!.validate()) {
                        _submitVendor();
                      }
                    } else {
                      _submitVendor();
                    }
                  },
                  loadingNotifier: loading,
                ),
                22.h,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
