import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/new_custom_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class BranchFormWidget extends StatefulWidget {
  final BranchModel? branchModel;
  final VoidCallback? onBack;
  final bool isEdit;

  const BranchFormWidget({
    super.key,
    this.branchModel,
    this.onBack,
    required this.isEdit,
  });

  @override
  State<BranchFormWidget> createState() => _BranchFormWidgetState();
}

class _BranchFormWidgetState extends State<BranchFormWidget> {
  final _branchNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  // final _contactNumberController = TextEditingController();
  List<AttachmentModel> attachments = [];
  List<PublicProfileModel> profile = [];

  String? _selectedStoreManagerId;

  bool status = true;
  ValueNotifier<bool> loading = ValueNotifier(false);
  GlobalKey<FormState> addBranchKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.branchModel != null) {
      final branch = widget.branchModel!;
      _branchNameController.text = branch.branchName;
      _descriptionController.text = branch.description ?? '';
      _addressController.text = branch.address ?? '';
      // _contactNumberController.text = branch.storeManager ?? '';
      _selectedStoreManagerId = branch.storeManager;
      status = branch.status == 'inactive' ? false : true;
    }
    //fetchProfiles();
  }

  @override
  void dispose() {
    _branchNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    // _contactNumberController.dispose();
    super.dispose();
  }

  void fetchProfiles() {
    final provider = context.read<MmResourceProvider>();
    final storeManagerId = provider.designationsList
        .firstWhere((role) => role.name == 'Store Manager')
        .id;
    // profile = provider.profiles.where((profile) {
    //   return profile.roleId == storeManagerId;
    // }).toList();
  }

  void _submitBranch() async {
    if (loading.value) return;

    loading.value = true;
    try {
      List<String> urls = [];
      if (attachments.isNotEmpty) {
        for (AttachmentModel attachment in attachments) {
          String url = await Constants.uploadAttachment(attachment);
          urls.add(url);
        }
      } else {
        urls.add(widget.branchModel?.imageUrl ?? '');
      }

      String code;

      if (widget.isEdit && widget.branchModel != null) {
        code = widget.branchModel!.code ?? await Constants.getUniqueNumber("B");
      } else {
        code = await Constants.getUniqueNumber("B");
        if (code.isEmpty) {
          code = await Constants.getUniqueNumber("B");
        }
      }

      final branch = BranchModel(
        branchName: _branchNameController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        storeManager: _selectedStoreManagerId,
        imageUrl: urls.first,
        status: status ? 'active' : 'inactive',
        code: code,
        timestamp: widget.branchModel?.timestamp ?? Timestamp.now(),
      );

      final branchesRef = FirebaseFirestore.instance.collection('branches');

      if (widget.isEdit) {
        await branchesRef
            .doc(widget.branchModel!.id)
            .update(branch.toMap())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(
                context,
                'Branch updated successfully'.tr(),
              );
              widget.onBack?.call();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to update Branch: $error');
            });
      } else {
        await branchesRef
            .add({...branch.toMap(), 'timestamp': FieldValue.serverTimestamp()})
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Branch added successfully'.tr());
              widget.onBack?.call();
              //context.pop();
              Navigator.of(context).pop();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add Branch: $error');
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong'.tr());
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
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              16.h,
              AlertDialogHeader(
                title: widget.isEdit ? 'Update Branch'.tr() : 'Add Branch'.tr(),
              ),
              const Divider(),
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
                  key: addBranchKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomMmTextField(
                              hintText: 'Enter Branch Name'.tr(),
                              labelText: 'Enter Branch Name'.tr(),
                              controller: _branchNameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ValidationUtils.validateCompanyName,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomMmTextField(
                              hintText: 'Enter Address'.tr(),
                              labelText: 'Enter Address'.tr(),
                              controller: _addressController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ValidationUtils.validateAddress,
                            ),
                          ),
                        ],
                      ),
                      6.h,
                      Row(
                        children: [
                          Expanded(
                            child: CustomMmTextField(
                              hintText: 'Enter Description'.tr(),
                              labelText: 'Enter description'.tr(),
                              maxLines: 2,
                              controller: _descriptionController,
                              inputFormatter: [
                                LengthLimitingTextInputFormatter(180),
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ValidationUtils.validateCrNumber,
                            ),
                          ),
                        ],
                      ),
                      6.h,
                      const SizedBox(height: 16),
                      Text(
                        'Select Store Managers'.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      // NewCustomDropDown(
                      //   hintText: 'Choose store manager'.tr(),
                      //   value:
                      //       (profile.any(
                      //         (p) => p.id == _selectedStoreManagerId,
                      //       ))
                      //       ? _selectedStoreManagerId
                      //       : null,
                      //   items: {for (var p in profile) p.id: p.userName},
                      //   onChanged: (val) {
                      //     setState(() {
                      //       _selectedStoreManagerId = val;
                      //       // _selectedStoreManagerName =
                      //       //     profile.firstWhere((c) => c.id == val).userName;
                      //     });
                      //   },
                      // ),
                      const SizedBox(height: 20),
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
                title: widget.isEdit
                    ? 'Update Branch'.tr()
                    : 'Create Branch'.tr(),
                onCreate: _submitBranch,
                loadingNotifier: loading,
              ),
              22.h,
            ],
          ),
        ),
      ),
    );
  }
}

// class BranchFormWidget extends StatefulWidget {
//   final BranchModel? branchModel;
//   final VoidCallback? onBack;
//   final bool isEdit;

//   const BranchFormWidget({
//     super.key,
//     this.branchModel,
//     this.onBack,
//     required this.isEdit,
//   });

//   @override
//   State<BranchFormWidget> createState() => _BranchFormWidgetState();
// }

// class _BranchFormWidgetState extends State<BranchFormWidget> {
//   final _branchNameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _contactNumberController = TextEditingController();
//   List<AttachmentModel> attachments = [];
//   List<PublicProfileModel> profile = [];

//   String? _selectedStoreManagerId;
//   String? _selectedStoreManagerName;

//   bool status = true;
//   ValueNotifier<bool> loading = ValueNotifier(false);
//   GlobalKey<FormState> addBranchKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEdit && widget.branchModel != null) {
//       final branch = widget.branchModel!;
//       _branchNameController.text = branch.branchName;
//       _descriptionController.text = branch.description ?? '';
//       _addressController.text = branch.address ?? '';
//       _contactNumberController.text = branch.storeManager ?? '';
//       status = branch.status == 'pending' ? false : true;
//     }
//     fetchProfiles();
//   }

//   @override
//   void dispose() {
//     _branchNameController.dispose();
//     _descriptionController.dispose();
//     _addressController.dispose();
//     _contactNumberController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchProfiles() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('profile')
//         .where('jobTitle', isEqualTo: 'Store Manager')
//         .get();

//     final data = snapshot.docs
//         .map((doc) => PublicProfileModel.fromFirestore(doc))
//         .toList();
//     // Debug log
//     for (var p in data) {
//       debugPrint('Fetched: ${p.userName}, Job Title: ${p.role}');
//     }

//     setState(() {
//       profile = data;
//     });
//   }

//   void _submitBranch() async {
//     if (loading.value) return;

//     loading.value = true;
//     try {
//       final branch = BranchModel(
//         branchName: _branchNameController.text.trim(),
//         description: _descriptionController.text.trim(),
//         address: _addressController.text.trim(),
//         storeManager: _selectedStoreManagerName,
//         imageUrl: '',
//         status: status ? 'pending' : 'active',
//       );

//       final branchesRef = FirebaseFirestore.instance.collection('branches');

//       if (widget.isEdit) {
//         await branchesRef
//             .doc(widget.branchModel!.id)
//             .update(branch.toMap())
//             .then((_) {
//               if (!mounted) return;
//               Constants.showMessage(
//                 context,
//                 'Branch updated successfully'.tr(),
//               );
//               widget.onBack?.call();
//               Navigator.of(context).pop();
//             })
//             .catchError((error) {
//               if (!mounted) return;
//               Constants.showMessage(context, 'Failed to update Branch: $error');
//             });
//       } else {
//         await branchesRef
//             .add({...branch.toMap(), 'timestamp': FieldValue.serverTimestamp()})
//             .then((_) {
//               if (!mounted) return;
//               Constants.showMessage(context, 'Branch added successfully'.tr());
//               widget.onBack?.call();
//               Navigator.of(context).pop();
//             })
//             .catchError((error) {
//               if (!mounted) return;
//               Constants.showMessage(context, 'Failed to add Branch: $error');
//             });
//       }
//     } catch (e) {
//       if (mounted) {
//         Constants.showMessage(context, 'Something went wrong'.tr());
//       }
//     } finally {
//       loading.value = false;
//     }
//   }

//   void onFilesPicked(List<AttachmentModel> files) {
//     setState(() {
//       attachments = files;
//     });
//   }

//   void toggleSwitch(bool value) {
//     setState(() {
//       status = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ConnectivityResult connectionStatus = context
//         .watch<ConnectivityProvider>()
//         .connectionStatus;
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppTheme.whiteColor,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: SingleChildScrollView(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 600),
//           child: Column(
//             children: [
//               16.h,
//               AlertDialogHeader(
//                 title: widget.isEdit ? 'Update Branch'.tr() : 'Add Branch'.tr(),
//               ),
//               const Divider(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   children: [
//                     PickerWidget(
//                       multipleAllowed: true,
//                       attachments: attachments,
//                       galleryAllowed: true,
//                       onFilesPicked: onFilesPicked,
//                       memoAllowed: false,
//                       //ft: FileType.image,
//                       filesAllowed: false,
//                       // captionAllowed: false,
//                       videoAllowed: false,
//                       cameraAllowed: true,
//                       child: Container(
//                         height: context.height * 0.2,
//                         width: context.width * 0.1,
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: AppTheme.borderColor),
//                         ),
//                         child: attachments.isNotEmpty
//                             ? kIsWeb
//                                   ? Image.memory(
//                                       attachments.last.bytes!,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Image.file(
//                                       File(attachments.last.url),
//                                       fit: BoxFit.cover,
//                                     )
//                             : Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.add_circle_outline_rounded),
//                                   Text('Add Image'.tr()),
//                                 ],
//                               ),
//                       ),
//                     ),
//                     12.w,
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               height: context.height * 0.06,
//                               width: context.height * 0.22,
//                               child: CustomButton(
//                                 text: 'Upload Image'.tr(),
//                                 onPressed: () {},
//                                 fontSize: 14,
//                                 buttonType: ButtonType.Filled,
//                                 backgroundColor: AppTheme.primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                         8.h,
//                         Text(
//                           'JPEG, PNG up to 2 MB'.tr(),
//                           style: AppTheme.getCurrentTheme(
//                             false,
//                             connectionStatus,
//                           ).textTheme.bodyMedium!.copyWith(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Form(
//                   key: addBranchKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomMmTextField(
//                               hintText: 'Enter Branch Name'.tr(),
//                               labelText: 'Enter Branch Name'.tr(),
//                               controller: _branchNameController,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: ValidationUtils.validateCompanyName,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: CustomMmTextField(
//                               hintText: 'Enter Address'.tr(),
//                               labelText: 'Enter Address'.tr(),
//                               controller: _addressController,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: ValidationUtils.validateAddress,
//                             ),
//                           ),
//                         ],
//                       ),
//                       6.h,
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomMmTextField(
//                               hintText: 'Enter Description'.tr(),
//                               labelText: 'Enter description'.tr(),
//                               maxLines: 2,
//                               controller: _descriptionController,
//                               inputFormatter: [
//                                 LengthLimitingTextInputFormatter(180),
//                               ],
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: ValidationUtils.validateCrNumber,
//                             ),
//                           ),
//                         ],
//                       ),
//                       6.h,
//                       const SizedBox(height: 16),
//                       Text(
//                         'Select Store Managers'.tr(),
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       const SizedBox(height: 10),
//                       NewCustomDropDown(
//                         hintText: 'Choose store manager'.tr(),
//                         value: _selectedStoreManagerId,
//                         items: Map.fromEntries(
//                           profile.map((c) => MapEntry(c.id, c.userName)),
//                         ),
//                         onChanged: (val) {
//                           setState(() {
//                             _selectedStoreManagerId = val;
//                             _selectedStoreManagerName = profile
//                                 .firstWhere((c) => c.id == val)
//                                 .userName;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       StatusSwitchWidget(
//                         isSwitched: status,
//                         onChanged: toggleSwitch,
//                       ),
//                       16.h,
//                     ],
//                   ),
//                 ),
//               ),
//               AlertDialogBottomWidget(
//                 title: widget.isEdit
//                     ? 'Update Branch'.tr()
//                     : 'Create Branch'.tr(),
//                 onCreate: _submitBranch,
//                 loadingNotifier: loading,
//               ),
//               22.h,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
