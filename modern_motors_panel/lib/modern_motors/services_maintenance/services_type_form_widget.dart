// import 'package:app/app_theme.dart';
// import 'package:app/constants.dart';
// import 'package:app/modern_motors/models/services/service_type_model.dart';
// import 'package:app/modern_motors/widgets/buttons/custom_button.dart';
// import 'package:app/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:app/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
// import 'package:app/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/form_validation.dart';
// import 'package:app/modern_motors/widgets/status_switch_button.dart';
// import 'package:app/widgets/overlayloader.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ServiceTypeFormWidget extends StatefulWidget {
//   final VoidCallback? onBack;
//   final ServiceTypeModel? serviceTypeModel;
//   final bool isEdit;

//   const ServiceTypeFormWidget({
//     super.key,
//     this.onBack,
//     this.serviceTypeModel,
//     required this.isEdit,
//   });

//   @override
//   State<ServiceTypeFormWidget> createState() => _ServiceTypeFormWidgetState();
// }

// class _ServiceTypeFormWidgetState extends State<ServiceTypeFormWidget> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   GlobalKey<FormState> addServiceTypeKey = GlobalKey<FormState>();
//   List prices = [];
//   ValueNotifier<bool> loading = ValueNotifier(false);
//   ValueNotifier<bool> catLoader = ValueNotifier(false);
//   bool status = true;

//   @override
//   void initState() {
//     super.initState();
//     initializeData();
//   }

//   void initializeData() async {
//     if (catLoader.value) {
//       return;
//     }

//     catLoader.value = true;
//     setState(() {
//       if (widget.isEdit && widget.serviceTypeModel != null) {
//         final category = widget.serviceTypeModel!;
//         nameController.text = category.name;
//         status = category.status == 'active';
//         prices = category.prices ?? [];
//       }
//     });
//     catLoader.value = false;
//   }

//   void _addServiveType() async {
//     if (loading.value) {
//       return;
//     }
//     loading.value = true;
//     try {
//       final country = ServiceTypeModel(
//         name: nameController.text,
//         prices: prices,
//         status: status ? 'active' : 'inactive',
//       );

//       if (widget.isEdit && widget.serviceTypeModel?.id != null) {
//         await FirebaseFirestore.instance
//             .collection('serviceTypes')
//             .doc(widget.serviceTypeModel!.id)
//             .update(country.toMapForUpdate())
//             .then((_) {
//           if (!mounted) return;
//           Constants.showMessage(
//             context,
//             'Service Type updated successfully',
//           );
//           widget.onBack?.call();
//           Navigator.of(context).pop();
//         });
//       } else {
//         await FirebaseFirestore.instance
//             .collection('serviceTypes')
//             .add(country.toMapForAdd())
//             .then((value) {
//           if (!mounted) return;
//           Constants.showMessage(context, 'Service Type added successfully');
//           widget.onBack?.call();
//           Navigator.of(context).pop();
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         Constants.showMessage(context, 'Something went wrong');
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

//   @override
//   Widget build(BuildContext context) {
//     return OverlayLoader(
//       loader: catLoader.value,
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: AppTheme.whiteColor,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 600, minWidth: 500),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               16.h,
//               AlertDialogHeader(
//                 title: widget.isEdit ? 'Update Service' : 'New Service',
//               ),
//               22.h,
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Form(
//                   key: addServiceTypeKey,
//                   child: Column(
//                     children: [
//                       8.h,
//                       CustomMmTextField(
//                         labelText: 'Enter Name',
//                         hintText: 'Enter Name',
//                         controller: nameController,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: ValidationUtils.serviceName,
//                       ),
//                       10.h,
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomMmTextField(
//                               labelText: 'Enter Price',
//                               hintText: 'Enter Price',
//                               controller: priceController,
//                               keyboardType: TextInputType.number,
//                               inputFormatter: [
//                                 FilteringTextInputFormatter.allow(
//                                   RegExp(r'^\d*\.?\d{0,2}'),
//                                 ),
//                               ],
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: (_) =>
//                                   ValidationUtils.priceListValidation(
//                                 prices,
//                               ),
//                             ),
//                           ),
//                           10.w,
//                           SizedBox(
//                             height: context.height * 0.064,
//                             width: context.height * 0.067,
//                             child: CustomButton(
//                               onPressed: () {
//                                 final txt = priceController.text.trim();
//                                 final val = double.tryParse(txt);

//                                 if (val == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('Enter a valid price'),
//                                     ),
//                                   );
//                                   return;
//                                 }
//                                 prices.add(val);
//                                 priceController.clear();
//                                 setState(() {});
//                               },
//                               iconAsset: 'assets/icons/add_icon.png',
//                               buttonType: ButtonType.IconOnly,
//                               iconColor: AppTheme.whiteColor,
//                               backgroundColor: AppTheme.primaryColor,
//                               iconSize: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                       10.h,
//                       if (prices.isNotEmpty) ...[
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: prices
//                               .map(
//                                 (entry) => Chip(
//                                   label: Text(entry.toString()),
//                                   onDeleted: () {
//                                     setState(() {
//                                       prices.remove(entry);
//                                     });
//                                   },
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               16.h,
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: StatusSwitchWidget(
//                   isSwitched: status,
//                   onChanged: toggleSwitch,
//                 ),
//               ),
//               22.h,
//               AlertDialogBottomWidget(
//                 buttonWidget: 0.26,
//                 title: widget.isEdit ? 'Update Service' : 'New Service',
//                 onCreate: () {
//                   if (addServiceTypeKey.currentState!.validate()) {
//                     _addServiveType();
//                   }
//                 },
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

// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';

class ServiceTypeFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final ServiceTypeModel? serviceTypeModel;
  final bool isEdit;

  const ServiceTypeFormWidget({
    super.key,
    this.onBack,
    this.serviceTypeModel,
    required this.isEdit,
  });

  @override
  State<ServiceTypeFormWidget> createState() => _ServiceTypeFormWidgetState();
}

class _ServiceTypeFormWidgetState extends State<ServiceTypeFormWidget>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController minimumPriceController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();

  GlobalKey<FormState> addServiceTypeKey = GlobalKey<FormState>();
  List<double> prices = [];
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    initializeData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  void initializeData() async {
    if (catLoader.value) return;

    catLoader.value = true;

    if (widget.isEdit && widget.serviceTypeModel != null) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Smooth transition

      final category = widget.serviceTypeModel!;
      nameController.text = category.name;
      status = category.status == 'active';
      prices = List<double>.from(
        category.prices?.map((p) => p.toDouble()) ?? [],
      );

      if (mounted) setState(() {});
    }

    catLoader.value = false;
  }

  void _addServiveType() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      String code = await Constants.getUniqueNumber("SER");
      User? user = FirebaseAuth.instance.currentUser;
      final country = ServiceTypeModel(
        name: nameController.text,
        prices: prices,
        status: status ? 'active' : 'inactive',
        createdBy: user!.uid,
        code: code,
        minimumPrice: double.tryParse(minimumPriceController.text),
      );

      if (widget.isEdit && widget.serviceTypeModel?.id != null) {
        await FirebaseFirestore.instance
            .collection('serviceTypes')
            .doc(widget.serviceTypeModel!.id)
            .update(country.toMapForUpdate())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(
                context,
                'Service Type updated successfully',
              );
              widget.onBack?.call();
              Navigator.of(context).pop();
            });
      } else {
        await FirebaseFirestore.instance
            .collection('serviceTypes')
            .add(country.toMapForAdd())
            .then((value) {
              if (!mounted) return;
              Constants.showMessage(context, 'Service Type added successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
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

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            8.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            8.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _addPrice() {
    final txt = priceController.text.trim();
    final val = double.tryParse(txt);

    if (val == null || val <= 0) {
      _showErrorMessage('Please enter a valid price greater than 0');
      return;
    }

    if (prices.contains(val)) {
      _showErrorMessage('This price is already added');
      return;
    }

    if (prices.length >= 10) {
      _showErrorMessage('Maximum 10 price options allowed');
      return;
    }

    setState(() {
      prices.add(val);
      prices.sort(); // Keep prices sorted
    });

    priceController.clear();
    priceFocusNode.requestFocus(); // Keep focus for easy multiple additions

    // Haptic feedback
    HapticFeedback.selectionClick();
  }

  void _removePrice(double price) {
    HapticFeedback.lightImpact();
    setState(() {
      prices.remove(price);
    });
  }

  void toggleSwitch(bool value) {
    HapticFeedback.selectionClick();
    setState(() {
      status = value;
    });
  }

  Widget _buildPriceChip(double price) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Chip(
        label: Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        deleteIcon: Icon(Icons.close, size: 18, color: Colors.red.shade400),
        onDeleted: () => _removePrice(price),
        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        deleteIconColor: Colors.red.shade400,
        side: BorderSide(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildPricesSection() {
    if (prices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade400, size: 20),
            12.w,
            Text(
              'Add price options for this service',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: AppTheme.primaryColor, size: 18),
              8.w,
              Text(
                'Price Options (${prices.length})',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          12.h,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: prices.map(_buildPriceChip).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    nameController.dispose();
    priceController.dispose();
    nameFocusNode.dispose();
    priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoader(
      loader: catLoader.value,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 500,
                maxHeight: 700,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    20.h,
                    AlertDialogHeader(
                      title: widget.isEdit
                          ? '✏️ Update Service Type'
                          : '✨ Create New Service Type',
                    ),
                    24.h,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: addServiceTypeKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Service Name Section
                            Text(
                              'Service Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            12.h,
                            CustomMmTextField(
                              labelText: 'Service Name',
                              hintText: 'Enter service name (e.g., Oil Change)',
                              controller: nameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ValidationUtils.serviceName,
                            ),
                            20.h,

                            // Price Section
                            Text(
                              'Pricing Options',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            8.h,
                            Text(
                              'Add different price tiers for this service',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            12.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Price Amount',
                                    hintText: 'Enter price (e.g., 29.99)',
                                    controller: priceController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    //onChanged: (_) => _addPrice(),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (_) =>
                                        ValidationUtils.priceListValidation(
                                          prices,
                                        ),
                                  ),
                                ),
                                12.w,
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 48,
                                  width: 48,
                                  child: CustomButton(
                                    onPressed: _addPrice,
                                    iconAsset: 'assets/images/add_icon.png',
                                    buttonType: ButtonType.IconOnly,
                                    iconColor: AppTheme.whiteColor,
                                    backgroundColor: AppTheme.primaryColor,
                                    iconSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Minimum Price',
                                    hintText: 'Enter Minimum Price',
                                    controller: minimumPriceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.minimumPrice,
                                  ),
                                ),
                              ],
                            ),

                            16.h,
                            _buildPricesSection(),
                            24.h,

                            // Status Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: status
                                    ? Colors.green.withOpacity(0.05)
                                    : Colors.orange.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: status
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.orange.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    status ? Icons.toggle_on : Icons.toggle_off,
                                    color: status
                                        ? Colors.green
                                        : Colors.orange,
                                    size: 24,
                                  ),
                                  12.w,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Service Status',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: status
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                          ),
                                        ),
                                        2.h,
                                        Text(
                                          status
                                              ? 'Active - Available for booking'
                                              : 'Inactive - Hidden from customers',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StatusSwitchWidget(
                                    isSwitched: status,
                                    onChanged: toggleSwitch,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    28.h,
                    AlertDialogBottomWidget(
                      buttonWidget: 0.26,
                      title: widget.isEdit
                          ? 'Update Service'
                          : 'Create Service',
                      onCreate: () {
                        if (addServiceTypeKey.currentState!.validate()) {
                          _addServiveType();
                        } else {
                          // Scroll to top to show validation errors
                          Scrollable.ensureVisible(
                            addServiceTypeKey.currentContext!,
                            duration: const Duration(milliseconds: 300),
                          );
                        }
                      },
                      loadingNotifier: loading,
                    ),
                    24.h,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
