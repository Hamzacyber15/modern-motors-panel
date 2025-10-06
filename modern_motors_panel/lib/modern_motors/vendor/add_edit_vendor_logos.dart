import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/vendor/ventor_logos_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dynamic_data_table_buttons.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';

class AddEditVendorLogos extends StatefulWidget {
  final VoidCallback? onBack;
  final String? docId;
  final VendorLogosModel? termsModel;
  final List<VendorLogosModel> termsList;
  final bool isEdit;

  const AddEditVendorLogos({
    super.key,
    this.onBack,
    this.termsModel,
    this.docId,
    required this.termsList,
    required this.isEdit,
  });

  @override
  State<AddEditVendorLogos> createState() => _AddEditVendorLogosState();
}

class _AddEditVendorLogosState extends State<AddEditVendorLogos> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController indexController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> addTermsKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  bool status = true;
  List<AttachmentModel> attachments = [];
  final List<VendorLogosModel> addVendorsList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.termsModel != null) {
      // final terms = widget.termsModel!;
      // titleController.text = terms.title;
      // descriptionController.text = terms.description;
      // indexController.text = terms.index.toString();
      // status = terms.status == 'active' ? true : false;
      // addVendorsList.remove(widget.termsModel);
    } else {
      addVendorsList.addAll(widget.termsList);
    }
  }

  void _submitVendorLogos() async {
    if (loading.value) return;

    loading.value = true;

    try {
      final uploadedUrls = await Future.wait(
        attachments.map((a) async => await Constants.uploadAttachment(a)),
      );

      final newLogos = uploadedUrls.map((url) {
        return VendorLogosModel(
          imgUrl: url,
          status: 'inactive',
          createdAt: Timestamp.now(),
        );
      }).toList();

      final allLogos = [...addVendorsList, ...newLogos];

      final vendorLogosList = VendorLogosListModel(logos: allLogos);
      if (widget.docId != null) {
        await FirebaseFirestore.instance
            .collection('vendorLogos')
            .doc(widget.docId)
            .update(vendorLogosList.toMap());
        if (mounted) {
          Constants.showMessage(context, 'Logos updated successfully');
        }
      } else {
        await FirebaseFirestore.instance.collection('vendorLogos').add({
          ...vendorLogosList.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (mounted) Constants.showMessage(context, 'Logos added successfully');
      }

      widget.onBack?.call();
    } catch (e) {
      debugPrint("Error saving vendor logos: $e");
      if (mounted) Constants.showMessage(context, 'Error: $e');
    } finally {
      loading.value = false;
    }
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
      debugPrint('attachments length: ${attachments.length}');
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
      debugPrint('status $status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeaderWidget(
            title: 'Add/Remove LOGOS'.tr(),
            buttonText: 'Back to LOGOS'.tr(),
            subTitle: 'You can add and remove logos from here'.tr(),
            onCreateIcon: 'assets/icons/back.png',
            selectedItems: [],
            buttonWidth: 0.4,
            onCreate: widget.onBack!.call,
            onDelete: () async {},
          ),
        ),
        SliverToBoxAdapter(
          child: OverlayLoader(
            loader: false,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor, width: 0.6),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                    minWidth: 500,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.h,

                      // AlertDialogHeader(
                      //   title: widget.isEdit ? 'Update Terms' : 'New Terms',
                      // ),
                      // Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: addTermsKey,
                          child: PickerWidget(
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
                                  : Image.asset('assets/images/logo1.png'),
                            ),
                          ),
                        ),
                      ),
                      16.h,
                      // if (!widget.isEdit)
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16),
                      //     child: AddTerms(
                      //       onAdd: () {
                      //         if (addTermsKey.currentState!.validate()) {
                      //           // addTerms();
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // if (widget.isEdit) ...[
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16),
                      //     child: StatusSwitchWidget(
                      //       isSwitched: status,
                      //       onChanged: toggleSwitch,
                      //     ),
                      //   ),
                      // ],
                      // 12.h,
                      if ((addVendorsList.isNotEmpty ||
                              attachments.isNotEmpty) &&
                          !widget.isEdit) ...[
                        Text(
                          'Logos to be added:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: addVendorsList.length + attachments.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6, // columns
                                crossAxisSpacing: 26,
                                mainAxisSpacing: 26,
                                childAspectRatio: 1.3,
                              ),
                          itemBuilder: (context, index) {
                            Widget imageWidget;
                            if (index < addVendorsList.length) {
                              final logo = addVendorsList[index];
                              imageWidget = buildImageWidget(logo);
                            } else {
                              final attachment =
                                  attachments[index - addVendorsList.length];
                              imageWidget = buildAttachmentWidget(attachment);
                            }

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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
                                        if (index < addVendorsList.length) {
                                          addVendorsList.removeAt(index);
                                        } else {
                                          attachments.removeAt(
                                            index - addVendorsList.length,
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
                      ],

                      22.h,
                      AlertDialogBottomWidget(
                        title: widget.isEdit ? 'Update' : 'New',
                        onCreate: () {
                          _submitVendorLogos();
                          if (addVendorsList.isNotEmpty && !widget.isEdit) {
                            _submitVendorLogos();
                          } else if (widget.isEdit) {
                            _submitVendorLogos();
                          } else {
                            Constants.showMessage(
                              context,
                              'Please Add The Terms',
                            );
                          }
                        },
                        onCancel: widget.onBack!.call,
                        loadingNotifier: loading,
                      ),
                      22.h,
                    ],
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

Widget buildImageWidget(VendorLogosModel logo) {
  if (logo.imgUrl.isNotEmpty) {
    return Image.network(
      logo.imgUrl,
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
