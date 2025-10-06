import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/drop_down_menu_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

// class AddProductPage extends StatefulWidget {
//   final VoidCallback? onBack;
//   final ProductCategoryModel? productModel;
//   final bool isEdit;

//   const AddProductPage({
//     super.key,
//     this.onBack,
//     this.productModel,
//     required this.isEdit,
//   });

//   @override
//   State<AddProductPage> createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddProductPage> {
//   final TextEditingController _productNameController = TextEditingController();

//   // final TextEditingController _thresholdController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   GlobalKey<FormState> addCreateProductKey = GlobalKey<FormState>();
//   ValueNotifier<bool> loading = ValueNotifier(false);
//   ValueNotifier<bool> catLoader = ValueNotifier(false);
//   bool status = true;
//   List<AttachmentModel> attachments = [];
//   User? user = FirebaseAuth.instance.currentUser;

//   List<UnitModel> _units = [];
//   String? _selectedUnit;
//   String? _selectedUnitId;
//   String selectedJobTitle = 'Select Job Title';
//   DropDownMenuDataModel jobTitle = Constants.jobTitles[0];

//   @override
//   void initState() {
//     super.initState();

//     _loadDataAndInit();
//   }

//   Future<void> _loadDataAndInit() async {
//     if (catLoader.value) {
//       return;
//     }
//     catLoader.value = true;
//     // final brands = await DataFetchService.fetchBrands();
//     final units = await DataFetchService.fetchUnits();
//     // final categories = await DataFetchService.fetchCategories();
//     catLoader.value = false;
//     setState(() {
//       // _brands = brands;
//       _units = units;
//       // _categories = categories;

//       if (widget.isEdit && widget.productModel != null) {
//         final product = widget.productModel!;
//         _productNameController.text = product.productName;
//         _descriptionController.text = product.description ?? '';
//         status = product.status == 'active' ? true : false;
//         _selectedUnitId = product.unitId ?? '';

//         if (_units.any((u) => u.id == product.unitId)) {
//           _selectedUnitId = product.unitId;
//         } else {
//           _selectedUnitId = null;
//         }

//         // if (missingData) {
//         //   WidgetsBinding.instance.addPostFrameCallback((_) {
//         //     Constants.showMessage(
//         //       context,
//         //       'One or more selected category/brand/unit has been deleted. Please update.',
//         //     );
//         //   });
//         // }
//       }
//     });
//   }

//   void _submitProduct() async {
//     if (loading.value) {
//       return;
//     }
//     loading.value = true;
//     try {
//       final productData = ProductCategoryModel(
//         productName: _productNameController.text.trim(),
//         createdBy: user!.uid,
//         image: '',
//         description: _descriptionController.text,
//         unitId: _selectedUnitId,
//         status: 'pending',
//       );
//       if (widget.isEdit && widget.productModel?.id != null) {
//         await DataUploadService.updateProductCategory(
//           widget.productModel!.id!,
//           productData,
//         ).then((_) {
//           if (!mounted) return;
//           SnackbarUtils.showSnackbar(
//             context,
//             'Product updated successfully',
//           );
//           widget.onBack?.call();
//         }).catchError((error) {
//           if (!mounted) return;
//           SnackbarUtils.showSnackbar(
//             context,
//             'Failed to update product: $error',
//           );
//         });
//       } else {
//         await DataUploadService.addProductCategory(productData).then((_) {
//           if (!mounted) return;
//           SnackbarUtils.showSnackbar(
//             context,
//             'Product added successfully'.tr(),
//           );
//           widget.onBack?.call();
//         }).catchError((error) {
//           if (!mounted) return;
//           SnackbarUtils.showSnackbar(
//             context,
//             'Failed to add product: $error',
//           );
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         Constants.showMessage(context, 'Something went wrong');
//         debugPrint('something went wrong: $e');
//       }
//     } finally {
//       loading.value = false;
//     }
//   }

//   void toggleSwitch(bool value) {
//     setState(() {
//       status = value;
//     });
//   }

//   void onFilesPicked(List<AttachmentModel> files) {
//     setState(() {
//       attachments = files;
//     });
//   }

//   void getJobTitle(String type, String value, String id) {
//     setState(() {
//       selectedJobTitle = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ConnectivityResult connectionStatus =
//         context.watch<ConnectivityProvider>().connectionStatus;
//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: PageHeaderWidget(
//             title: 'Create Product Category'.tr(),
//             buttonText: 'Back to Products Category'.tr(),
//             subTitle: 'Create New Product Category'.tr(),
//             onCreateIcon: 'assets/images/back.png',
//             selectedItems: [],
//             buttonWidth: 0.4,
//             onCreate: widget.onBack!.call,
//             onDelete: () async {},
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: OverlayLoader(
//             loader: catLoader.value,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: AppTheme.whiteColor,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: AppTheme.borderColor, width: 0.6),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16, top: 10),
//                       child: Text(
//                         'Product Category Information'.tr(),
//                         style: AppTheme.getCurrentTheme(false, connectionStatus)
//                             .textTheme
//                             .bodyMedium!
//                             .copyWith(fontSize: 16),
//                       ),
//                     ),
//                     Divider(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       child: Form(
//                         key: addCreateProductKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Enter Product Name'.tr(),
//                                     hintText: 'Enter Product Name'.tr(),
//                                     controller: _productNameController,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.productName,
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomSearchableDropdown(
//                                     key: const ValueKey('unit_dropdown'),
//                                     hintText: 'Choose Unit'.tr(),
//                                     value: _selectedUnitId,
//                                     items: {for (var u in _units) u.id: u.name},
//                                     onChanged: (val) => setState(() {
//                                       _selectedUnitId = val;
//                                       _selectedUnit = _units
//                                           .firstWhere(
//                                             (u) => u.id == val,
//                                           )
//                                           .name;
//                                     }),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             CustomMmTextField(
//                               labelText: 'Description'.tr(),
//                               hintText: 'Description'.tr(),
//                               controller: _descriptionController,
//                               maxLines: 4,
//                               topPadding: 20,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: ValidationUtils.productDescription,
//                             ),
//                             // if (widget.isEdit) ...[
//                             //   16.h,
//                             //   StatusSwitchWidget(
//                             //     isSwitched: status,
//                             //     onChanged: toggleSwitch,
//                             //   ),
//                             // ],
//                             14.h,
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 8,
//                               ),
//                               child: Row(
//                                 children: [
//                                   PickerWidget(
//                                     multipleAllowed: true,
//                                     attachments: attachments,
//                                     galleryAllowed: true,
//                                     onFilesPicked: onFilesPicked,
//                                     memoAllowed: false,
//                                     //ft: FileType.image,
//                                     filesAllowed: false,
//                                     //captionAllowed: false,
//                                     videoAllowed: false,
//                                     cameraAllowed: true,
//                                     child: Container(
//                                       height: context.height * 0.2,
//                                       width: context.width * 0.1,
//                                       decoration: BoxDecoration(
//                                         color: Colors.transparent,
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(
//                                           color: AppTheme.borderColor,
//                                         ),
//                                       ),
//                                       child: attachments.isNotEmpty
//                                           ? kIsWeb
//                                               ? Image.memory(
//                                                   attachments.last.bytes!,
//                                                   fit: BoxFit.cover,
//                                                 )
//                                               : Image.file(
//                                                   File(attachments.last.url),
//                                                   fit: BoxFit.cover,
//                                                 )
//                                           : Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons
//                                                       .add_circle_outline_rounded,
//                                                 ),
//                                                 Text('Add Image'.tr()),
//                                               ],
//                                             ),
//                                     ),
//                                   ),
//                                   12.w,
//                                   Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           SizedBox(
//                                             height: context.height * 0.06,
//                                             width: context.height * 0.22,
//                                             child: CustomButton(
//                                               text: 'Upload Image'.tr(),
//                                               onPressed: () {},
//                                               fontSize: 14,
//                                               buttonType: ButtonType.Filled,
//                                               backgroundColor:
//                                                   AppTheme.primaryColor,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       8.h,
//                                       Text(
//                                         'JPEG, PNG up to 2 MB'.tr(),
//                                         style: AppTheme.getCurrentTheme(
//                                                 false, connectionStatus)
//                                             .textTheme
//                                             .bodyMedium!
//                                             .copyWith(fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             AlertDialogBottomWidget(
//                               title: widget.isEdit
//                                   ? 'Update Product'.tr()
//                                   : 'Create Product'.tr(),
//                               onCreate: () {
//                                 if (addCreateProductKey.currentState!
//                                     .validate()) {
//                                   _submitProduct();
//                                 }
//                               },
//                               onCancel: widget.onBack!.call,
//                               loadingNotifier: loading,
//                             ),
//                             22.h,
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class AddProductPage extends StatefulWidget {
  final VoidCallback? onBack;
  final ProductCategoryModel? productModel;
  final bool isEdit;

  const AddProductPage({
    super.key,
    this.onBack,
    this.productModel,
    required this.isEdit,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();

  // final TextEditingController _thresholdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  GlobalKey<FormState> addCreateProductKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  List<AttachmentModel> attachments = [];
  String? userId = FirebaseAuth.instance.currentUser!.uid;

  List<UnitModel> _units = [];
  String? _selectedUnitId;
  String selectedJobTitle = 'Select Job Title';
  DropDownMenuDataModel jobTitle = Constants.jobTitles[0];

  @override
  void initState() {
    super.initState();

    _loadDataAndInit();
  }

  Future<void> _loadDataAndInit() async {
    if (catLoader.value) {
      return;
    }
    catLoader.value = true;
    final provider = context.read<MmResourceProvider>();
    final units = provider.unitList;
    catLoader.value = false;
    setState(() {
      _units = units;

      if (widget.isEdit && widget.productModel != null) {
        final product = widget.productModel!;
        _productNameController.text = product.productName;
        _descriptionController.text = product.description ?? '';
        status = product.status == 'active' ? true : false;
        _selectedUnitId = product.unitId ?? '';

        if (_units.any((u) => u.id == product.unitId)) {
          _selectedUnitId = product.unitId;
        } else {
          _selectedUnitId = null;
        }
      }
    });
  }

  void _submitProduct() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final provider = context.read<MmResourceProvider>();
      List<String> urls = [];
      if (attachments.isNotEmpty) {
        for (AttachmentModel attachment in attachments) {
          String url = await Constants.uploadAttachment(attachment);
          urls.add(url);
        }
      } else {
        urls.add(widget.productModel?.image ?? '');
      }
      String code;

      if (widget.isEdit && widget.productModel != null) {
        code = widget.productModel!.code ?? '';
        userId = widget.productModel?.createdBy ?? userId;
      } else {
        code = await Constants.getUniqueNumber("PC");
        if (code.isEmpty) {
          code = await Constants.getUniqueNumber("PC");
        }
      }

      final productData = ProductCategoryModel(
        productName: _productNameController.text.trim(),
        createdBy: userId,
        image: urls.first,
        code: code,
        description: _descriptionController.text,
        unitId: _selectedUnitId,
        status: 'pending',
      );
      if (widget.isEdit && widget.productModel?.id != null) {
        await DataUploadService.updateProductCategory(
              widget.productModel!.id!,
              productData,
            )
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Product updated successfully');
              provider.updateCategory(
                model: productData,
                id: widget.productModel?.id ?? '',
              );
              widget.onBack?.call();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(
                context,
                'Failed to update product: $error',
              );
            });
      } else {
        String catDocId = FirebaseFirestore.instance
            .collection('productsCategory')
            .doc()
            .id;
        productData.id = catDocId;
        await DataUploadService.addProductCategory(productData, catDocId)
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Product added successfully'.tr());
              provider.updateCategory(model: productData);
              widget.onBack?.call();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add product: $error');
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong');
        debugPrint('something went wrong: $e');
      }
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

  void getJobTitle(String type, String value, String id) {
    setState(() {
      selectedJobTitle = value;
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
            title: 'Create Product Category'.tr(),
            buttonText: 'Back to Products Category'.tr(),
            subTitle: 'Create New Product Category'.tr(),
            onCreateIcon: 'assets/icons/back.png',
            selectedItems: [],
            buttonWidth: 0.4,
            onCreate: widget.onBack!.call,
            onDelete: () async {},
          ),
        ),
        SliverToBoxAdapter(
          child: OverlayLoader(
            loader: catLoader.value,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor, width: 0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 10),
                      child: Text(
                        'Product Category Information'.tr(),
                        style: AppTheme.getCurrentTheme(
                          false,
                          connectionStatus,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Form(
                        key: addCreateProductKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Product Name'.tr(),
                                    hintText: 'Enter Product Name'.tr(),
                                    controller: _productNameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.productName,
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomSearchableDropdown(
                                    key: const ValueKey('unit_dropdown'),
                                    hintText: 'Choose Unit'.tr(),
                                    value: _selectedUnitId,
                                    items: {for (var u in _units) u.id: u.name},
                                    onChanged: (val) => setState(() {
                                      _selectedUnitId = val;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomMmTextField(
                              labelText: 'Description'.tr(),
                              hintText: 'Description'.tr(),
                              controller: _descriptionController,
                              maxLines: 4,
                              topPadding: 20,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ValidationUtils.productDescription,
                            ),
                            // if (widget.isEdit) ...[
                            //   16.h,
                            //   StatusSwitchWidget(
                            //     isSwitched: status,
                            //     onChanged: toggleSwitch,
                            //   ),
                            // ],
                            14.h,
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
                                                  Icons
                                                      .add_circle_outline_rounded,
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
                            AlertDialogBottomWidget(
                              title: widget.isEdit
                                  ? 'Update Product'.tr()
                                  : 'Create Product'.tr(),
                              onCreate: () {
                                if (addCreateProductKey.currentState!
                                    .validate()) {
                                  _submitProduct();
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
