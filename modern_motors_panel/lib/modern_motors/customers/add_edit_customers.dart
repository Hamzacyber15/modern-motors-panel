import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/contact_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/modern_motors/customers/multiple_contact_widget.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/radio_button_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/requiredText.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

// class AddEditCustomer extends StatefulWidget {
//   final VoidCallback? onBack;
//   final CustomerModel? customerModel;
//   final bool isEdit;

//   const AddEditCustomer({
//     super.key,
//     this.onBack,
//     this.customerModel,
//     required this.isEdit,
//   });

//   @override
//   State<AddEditCustomer> createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddEditCustomer> {
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController businessNameController = TextEditingController();
//   final TextEditingController bankNameController = TextEditingController();
//   final TextEditingController crNumberController = TextEditingController();
//   final TextEditingController telephoneController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController streetAddress1Controller =
//       TextEditingController();
//   final TextEditingController streetAddress2Controller =
//       TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController postalCodeController = TextEditingController();
//   final TextEditingController codeNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController vatNumberController = TextEditingController();

//   GlobalKey<FormState> addCreateProductKey = GlobalKey<FormState>();
//   ValueNotifier<bool> loading = ValueNotifier(false);
//   ValueNotifier<bool> catLoader = ValueNotifier(false);
//   bool status = true;
//   List<AttachmentModel> attachments = [];
//   User? user = FirebaseAuth.instance.currentUser;
//   CustomerType selectedType = CustomerType.individual;
//   String selectedCustomerType = CustomerType.individual.name;

//   List<CurrencyModel> currencies = [];
//   String? selectedCurrency;
//   String? selectedCurrencyId;
//   List<CountryModel> countries = [];
//   String? selectedCountry;
//   String? selectedCountryId;

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
//     final country = await DataFetchService.fetchCountries();
//     final currency = await DataFetchService.fetchCurrencies();

//     catLoader.value = false;
//     setState(() {
//       currencies = currency;
//       countries = country;

//       if (widget.isEdit && widget.customerModel != null) {
//         final customer = widget.customerModel!;
//         selectedType = customer.customerType == 'business'
//             ? CustomerType.business
//             : CustomerType.individual;
//         fullNameController.text = customer.customerName;
//         businessNameController.text = customer.businessName!;
//         telephoneController.text = customer.telePhoneNumber;
//         mobileController.text = customer.contactNumber;
//         crNumberController.text = customer.crNumber!;
//         streetAddress1Controller.text = customer.streetAddress1;
//         streetAddress2Controller.text = customer.streetAddress2;
//         cityController.text = customer.city;
//         stateController.text = customer.state;
//         postalCodeController.text = customer.postalCode;
//         bankNameController.text = customer.bankName;
//         vatNumberController.text = customer.vatNumber!;
//         codeNumberController.text = customer.codeNumber;
//         accountNumberController.text = customer.accountNumber;
//         emailController.text = customer.emailAddress;
//         notesController.text = customer.notes;
//         status = customer.status == 'active' ? true : false;
//         selectedCurrency = customer.crNumber ?? '';
//         selectedCurrencyId = customer.crNumber ?? '';

//         if (currencies.any((u) => u.id == customer.currencyId)) {
//           selectedCurrencyId = customer.currencyId;
//         } else {
//           selectedCurrencyId = null;
//         }
//         if (countries.any((u) => u.id == customer.countryId)) {
//           selectedCountryId = customer.countryId;
//         } else {
//           selectedCountryId = null;
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
//       final customerData = CustomerModel(
//         customerName: fullNameController.text.trim(),
//         businessName: businessNameController.text.trim(),
//         bankName: bankNameController.text.trim(),
//         addedBy: FirebaseAuth.instance.currentUser!.uid,
//         city: cityController.text.trim(),
//         codeNumber: codeNumberController.text.trim(),
//         notes: notesController.text.trim(),
//         streetAddress1: streetAddress1Controller.text.trim(),
//         streetAddress2: streetAddress2Controller.text.trim(),
//         customerType: selectedCustomerType,
//         contactNumber: mobileController.text.trim(),
//         countryId: selectedCountryId!,
//         currencyId: selectedCurrencyId!,
//         postalCode: postalCodeController.text.trim(),
//         state: stateController.text.trim(),
//         telePhoneNumber: telephoneController.text.trim(),
//         imageUrl: '',
//         crNumber: crNumberController.text.trim(),
//         files: '',
//         vatNumber: vatNumberController.text.trim(),
//         accountNumber: accountNumberController.text.trim(),
//         emailAddress: emailController.text.trim(),
//         status: status ? 'active' : 'inactive',
//       );
//       if (widget.isEdit && widget.customerModel?.id != null) {
//         await DataUploadService.updateCustomer(
//               widget.customerModel!.id!,
//               customerData,
//               selectedCustomerType,
//             )
//             .then((_) {
//               if (!mounted) return;
//               SnackbarUtils.showSnackbar(
//                 context,
//                 'Product updated successfully',
//               );
//               widget.onBack?.call();
//             })
//             .catchError((error) {
//               if (!mounted) return;
//               SnackbarUtils.showSnackbar(
//                 context,
//                 'Failed to update customer: $error',
//               );
//             });
//       } else {
//         await DataUploadService.addCustomer(customerData, selectedCustomerType)
//             .then((_) {
//               if (!mounted) return;
//               SnackbarUtils.showSnackbar(
//                 context,
//                 'Product added successfully'.tr(),
//               );
//               widget.onBack?.call();
//             })
//             .catchError((error) {
//               if (!mounted) return;
//               SnackbarUtils.showSnackbar(
//                 context,
//                 'Failed to add customer: $error',
//               );
//             });
//       }
//     } catch (e) {
//       if (mounted) {
//         Constants.showMessage(context, 'Something went wrong'.tr());
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

//   @override
//   Widget build(BuildContext context) {
//     ConnectivityResult connectionStatus = context
//         .watch<ConnectivityProvider>()
//         .connectionStatus;
//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: PageHeaderWidget(
//             title: 'Create Customer'.tr(),
//             buttonText: 'Back to Manage Customer'.tr(),
//             subTitle: 'Add New Customer'.tr(),
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
//                         'Customer Information'.tr(),
//                         style: AppTheme.getCurrentTheme(
//                           false,
//                           connectionStatus,
//                         ).textTheme.bodyMedium!.copyWith(fontSize: 16),
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
//                             RadioButtonWidget(
//                               selectedType: selectedType,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedType = value!;
//                                   selectedCustomerType = selectedType.name;
//                                 });
//                                 debugPrint('value: ${selectedType.name}');
//                               },
//                             ),
//                             10.h,
//                             // if (selectedCustomerType == 'business')
//                             Visibility(
//                               maintainState: false,
//                               visible: selectedCustomerType == 'business',
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: CustomMmTextField(
//                                       labelText: 'Business Name'.tr(),
//                                       hintText: 'Enter Business Name'.tr(),
//                                       controller: businessNameController,
//                                       autovalidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                       validator: (val) =>
//                                           ValidationUtils.businessName(
//                                             val,
//                                             selectedType: selectedCustomerType,
//                                           ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: CustomMmTextField(
//                                       labelText: 'CR Number'.tr(),
//                                       hintText: 'Enter CR Number'.tr(),
//                                       controller: crNumberController,
//                                       autovalidateMode:
//                                           AutovalidateMode.onUserInteraction,
//                                       validator: (val) =>
//                                           ValidationUtils.validateCustomerCrNumber(
//                                             val,
//                                             selectedType: selectedCustomerType,
//                                           ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             10.h,
//                             CustomMmTextField(
//                               labelText: 'Full Name'.tr(),
//                               hintText: 'Enter Full Name'.tr(),
//                               controller: fullNameController,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: ValidationUtils.validateName,
//                             ),
//                             10.h,
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Telephone'.tr(),
//                                     hintText: 'Enter Telephone number'.tr(),
//                                     controller: telephoneController,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator:
//                                         ValidationUtils.validatePhoneNumber,
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Mobile'.tr(),
//                                     hintText: 'Enter Mobile number'.tr(),
//                                     controller: mobileController,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator:
//                                         ValidationUtils.validatePhoneNumber,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             10.h,
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Street Address 1'.tr(),
//                                     hintText: 'Enter Street Address 1'.tr(),
//                                     controller: streetAddress1Controller,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.validateAddress,
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Street Address 2'.tr(),
//                                     hintText: 'Enter Street Address 2'.tr(),
//                                     controller: streetAddress2Controller,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.validateAddress,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             10.h,
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'City'.tr(),
//                                     hintText: 'Enter City'.tr(),
//                                     controller: cityController,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.validateAddress,
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'State'.tr(),
//                                     hintText: 'Enter State'.tr(),
//                                     controller: stateController,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.validateAddress,
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Postal Code'.tr(),
//                                     hintText: 'Enter Postal Code'.tr(),
//                                     controller: postalCodeController,
//                                     inputFormatter: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       LengthLimitingTextInputFormatter(6),
//                                     ],
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator:
//                                         ValidationUtils.validatePostalCode,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             10.h,
//                             CustomSearchableDropdown(
//                               key: const ValueKey('country_dropdown'),
//                               hintText: 'Choose Country'.tr(),
//                               value: selectedCountryId,
//                               items: {
//                                 for (var u in countries) u.id!: u.country,
//                               },
//                               onChanged: (val) => setState(() {
//                                 selectedCountryId = val;
//                                 selectedCountry = countries
//                                     .firstWhere((u) => u.id == val)
//                                     .country;
//                               }),
//                             ),
//                             10.h,
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Bank Name'.tr(),
//                                     hintText: 'Enter Bank Name'.tr(),
//                                     controller: bankNameController,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.bankName,
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Vat Number'.tr(),
//                                     hintText: 'Enter Vat Name'.tr(),
//                                     controller: vatNumberController,
//                                     inputFormatter: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                     ],
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.vatNumber,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             10.h,
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Code Number'.tr(),
//                                     hintText: 'Enter Code Number'.tr(),
//                                     controller: codeNumberController,
//                                     inputFormatter: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       LengthLimitingTextInputFormatter(6),
//                                     ],
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator:
//                                         ValidationUtils.validateCodeNumber,
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Account Number'.tr(),
//                                     hintText: 'Enter Account Number'.tr(),
//                                     controller: accountNumberController,
//                                     inputFormatter: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       LengthLimitingTextInputFormatter(20),
//                                     ],
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator:
//                                         ValidationUtils.validateAccountNumber,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             10.h,
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomSearchableDropdown(
//                                     key: const ValueKey('currency_dropdown'),
//                                     hintText: 'Choose Currency'.tr(),
//                                     value: selectedCurrencyId,
//                                     items: {
//                                       for (var u in currencies)
//                                         u.id!: u.currency,
//                                     },
//                                     onChanged: (val) => setState(() {
//                                       selectedCurrencyId = val;
//                                       selectedCurrency = currencies
//                                           .firstWhere((u) => u.id == val)
//                                           .currency;
//                                     }),
//                                   ),
//                                 ),
//                                 10.w,
//                                 Expanded(
//                                   child: CustomMmTextField(
//                                     labelText: 'Email'.tr(),
//                                     hintText: 'Enter email address'.tr(),
//                                     controller: emailController,
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     validator: ValidationUtils.validateEmail,
//                                   ),
//                                 ),
//                                 10.w,
//                               ],
//                             ),
//                             10.h,
//                             CustomMmTextField(
//                               labelText: 'Notes'.tr(),
//                               hintText: 'Add a note'.tr(),
//                               controller: notesController,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: ValidationUtils.productDescription,
//                             ),
//                             14.h,
//                             StatusSwitchWidget(
//                               isSwitched: status,
//                               onChanged: toggleSwitch,
//                             ),
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
//                                                 ? Image.memory(
//                                                     attachments.last.bytes!,
//                                                     fit: BoxFit.cover,
//                                                   )
//                                                 : Image.file(
//                                                     File(attachments.last.url),
//                                                     fit: BoxFit.cover,
//                                                   )
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
//                                         style:
//                                             AppTheme.getCurrentTheme(
//                                               false,
//                                               connectionStatus,
//                                             ).textTheme.bodyMedium!.copyWith(
//                                               fontSize: 12,
//                                             ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             AlertDialogBottomWidget(
//                               title: widget.isEdit
//                                   ? 'Update Customer'.tr()
//                                   : 'Create Customer'.tr(),
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

class AddEditCustomer extends StatefulWidget {
  final VoidCallback? onBack;
  final CustomerModel? customerModel;
  final bool isEdit;
  final bool isClone;
  final String from;

  const AddEditCustomer({
    super.key,
    this.onBack,
    this.customerModel,
    required this.isEdit,
    this.isClone = false,
    this.from = 'main',
  });

  @override
  State<AddEditCustomer> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddEditCustomer> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController crNumberController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController streetAddress1Controller =
      TextEditingController();
  final TextEditingController streetAddress2Controller =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController codeNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController vatNumberController = TextEditingController();

  GlobalKey<FormState> addCreateProductKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  List<AttachmentModel> attachments = [];
  List<ContactModel> contacts = [];
  User? user = FirebaseAuth.instance.currentUser;
  CustomerType selectedType = CustomerType.individual;
  String selectedCustomerType = CustomerType.individual.name;
  String? customerCode;
  List<CurrencyModel> currencies = [];
  String? selectedCurrency;
  String? selectedCurrencyId;
  List<CountryModel> countries = [];
  String? selectedCountry;
  String? selectedCountryId;

  @override
  void initState() {
    super.initState();
    _loadDataAndInit();
  }

  Future<String> getCustomerCode() async {
    var value = await Constants.getUniqueNumberValue('CL');
    if (value != null) {
      return ((value as int) + 1).toString();
    } else {
      return '1';
    }
  }

  Future<void> _loadDataAndInit() async {
    if (catLoader.value) {
      return;
    }
    catLoader.value = true;
    final country = await DataFetchService.fetchCountries();
    final currency = await DataFetchService.fetchCurrencies();
    customerCode = await getCustomerCode();

    catLoader.value = false;
    setState(() {
      currencies = currency;
      countries = country;

      if (widget.isEdit && widget.customerModel != null) {
        final customer = widget.customerModel!;
        selectedType = customer.customerType == 'business'
            ? CustomerType.business
            : CustomerType.individual;
        fullNameController.text = customer.customerName;
        businessNameController.text = customer.businessName!;
        telephoneController.text = customer.telePhoneNumber;
        mobileController.text = customer.contactNumber;
        crNumberController.text = customer.crNumber!;
        streetAddress1Controller.text = customer.streetAddress1;
        streetAddress2Controller.text = customer.streetAddress2;
        cityController.text = customer.city;
        stateController.text = customer.state;
        postalCodeController.text = customer.postalCode;
        bankNameController.text = customer.bankName;
        vatNumberController.text = customer.vatNumber!;
        if (!widget.isClone) {
          customerCode = customer.codeNumber;
        }
        accountNumberController.text = customer.accountNumber;
        emailController.text = customer.emailAddress;
        notesController.text = customer.notes;
        status = customer.status == 'active' ? true : false;
        selectedCurrency = customer.crNumber ?? '';
        selectedCurrencyId = customer.crNumber ?? '';
        for (var c in contacts) {
          try {
            c.dispose();
          } catch (_) {}
        }
        if (customer.contacts.isNotEmpty) {
          contacts = customer.contacts.map((c) {
            return c;
          }).toList();
        }

        if (currencies.any((u) => u.id == customer.currencyId)) {
          selectedCurrencyId = customer.currencyId;
        } else {
          selectedCurrencyId = null;
        }
        if (countries.any((u) => u.id == customer.countryId)) {
          selectedCountryId = customer.countryId;
        } else {
          selectedCountryId = null;
        }
      }
    });
  }

  void _addClient() async {
    if (loading.value) {
      return;
    }
    loading.value = true;

    if (widget.isEdit && widget.customerModel != null && !widget.isClone) {
      customerCode = widget.customerModel?.codeNumber ?? '';
      // = await Constants.getUniqueNumber("CL");
    } else {
      customerCode = await Constants.getUniqueNumber("CL");
    }

    try {
      contacts.removeWhere((c) {
        final f = c.firstNameController.text.trim();
        final l = c.lastNameController.text.trim();
        final e = c.emailController.text.trim();
        final t = c.telephoneController.text.trim();
        final m = c.mobileController.text.trim();

        return f.isEmpty && l.isEmpty && e.isEmpty && t.isEmpty && m.isEmpty;
      });

      final customerData = CustomerModel(
        customerName: fullNameController.text.trim(),
        businessName: businessNameController.text.trim(),
        bankName: bankNameController.text.trim(),
        addedBy: FirebaseAuth.instance.currentUser!.uid,
        city: cityController.text.trim(),
        codeNumber: customerCode!,
        notes: notesController.text.trim(),
        streetAddress1: streetAddress1Controller.text.trim(),
        streetAddress2: streetAddress2Controller.text.trim(),
        customerType: selectedCustomerType,
        contactNumber: mobileController.text.trim(),
        countryId: selectedCountryId ?? '',
        currencyId: selectedCurrencyId ?? '',
        postalCode: postalCodeController.text.trim(),
        state: stateController.text.trim(),
        telePhoneNumber: telephoneController.text.trim(),
        imageUrl: '',
        crNumber: crNumberController.text.trim(),
        files: '',
        vatNumber: vatNumberController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        emailAddress: emailController.text.trim(),
        status: status ? 'active' : 'inactive',
        contacts: contacts,
      );
      if (widget.isEdit &&
          widget.customerModel?.id != null &&
          !widget.isClone) {
        await DataUploadService.updateCustomer(
              widget.customerModel!.id!,
              customerData,
              selectedCustomerType,
            )
            .then((_) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Product updated successfully',
              );
              widget.from == 'main'
                  ? widget.onBack?.call()
                  : Navigator.pop(context, 'customer_added');
            })
            .catchError((error) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Failed to update customer: $error',
              );
            });
      } else {
        await DataUploadService.addCustomer(customerData, selectedCustomerType)
            .then((_) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Product added successfully'.tr(),
              );
              widget.from == 'main'
                  ? widget.onBack?.call()
                  : Navigator.pop(context, 'customer_added');
            })
            .catchError((error) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Failed to add customer: $error',
              );
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong'.tr());
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

  @override
  Widget build(BuildContext context) {
    debugPrint('widget.isClone: ${widget.isClone}');
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Scaffold(
      body: OverlayLoader(
        loader: catLoader.value,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PageHeaderWidget(
                title: 'Create Client'.tr(),
                buttonText: 'Back to Manage Client'.tr(),
                subTitle: 'Add New Client'.tr(),
                onCreateIcon: 'assets/icons/back.png',
                selectedItems: [],
                buttonWidth: 0.4,
                onCreate: widget.onBack!.call,
                onDelete: () async {},
              ),
            ),
            SliverToBoxAdapter(
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
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 10,
                          right: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Client Information'.tr(),
                              style: AppTheme.getCurrentTheme(
                                false,
                                connectionStatus,
                              ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                            ),
                            Text(
                              customerCode ?? '',
                              style: AppTheme.getCurrentTheme(
                                false,
                                connectionStatus,
                              ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                            ),
                          ],
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
                              RadioButtonWidget(
                                selectedType: selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedType = value!;
                                    selectedCustomerType = selectedType.name;
                                  });
                                  debugPrint('value: ${selectedType.name}');
                                },
                              ),
                              10.h,
                              // if (selectedCustomerType == 'business')
                              Visibility(
                                maintainState: false,
                                visible: selectedCustomerType == 'business',
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomMmTextField(
                                            labelText: 'Business Name'.tr(),
                                            hintText: 'Enter Business Name'
                                                .tr(),
                                            controller: businessNameController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (val) =>
                                                ValidationUtils.businessName(
                                                  val,
                                                  selectedType:
                                                      selectedCustomerType,
                                                ),
                                          ),
                                          2.h,
                                          requiredText(),
                                        ],
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomMmTextField(
                                            labelText: 'CR Number'.tr(),
                                            hintText: 'Enter CR Number'.tr(),
                                            controller: crNumberController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (val) =>
                                                ValidationUtils.validateCustomerCrNumber(
                                                  val,
                                                  selectedType:
                                                      selectedCustomerType,
                                                ),
                                          ),
                                          2.h,
                                          requiredText(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              10.h,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomMmTextField(
                                    labelText: 'Full Name'.tr(),
                                    hintText: 'Enter Full Name'.tr(),
                                    controller: fullNameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.validateName,
                                  ),
                                  2.h,
                                  requiredText(),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Telephone'.tr(),
                                      hintText: 'Enter Telephone number'.tr(),
                                      controller: telephoneController,
                                    ),
                                  ),

                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Mobile'.tr(),
                                      hintText: 'Enter Mobile number'.tr(),
                                      controller: mobileController,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Street Address 1'.tr(),
                                      hintText: 'Enter Street Address 1'.tr(),
                                      controller: streetAddress1Controller,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Street Address 2'.tr(),
                                      hintText: 'Enter Street Address 2'.tr(),
                                      controller: streetAddress2Controller,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'City'.tr(),
                                      hintText: 'Enter City'.tr(),
                                      controller: cityController,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'State'.tr(),
                                      hintText: 'Enter State'.tr(),
                                      controller: stateController,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Postal Code'.tr(),
                                      hintText: 'Enter Postal Code'.tr(),
                                      controller: postalCodeController,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      key: const ValueKey('country_dropdown'),
                                      hintText: 'Choose Country'.tr(),
                                      value: selectedCountryId,
                                      isRequired: false,
                                      items: {
                                        for (var u in countries)
                                          u.id!: u.country,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedCountryId = val;
                                        selectedCountry = countries
                                            .firstWhere((u) => u.id == val)
                                            .country;
                                      }),
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      key: const ValueKey('currency_dropdown'),
                                      hintText: 'Choose Currency'.tr(),
                                      value: selectedCurrencyId,
                                      isRequired: false,
                                      items: {
                                        for (var u in currencies)
                                          u.id!: u.currency,
                                      },
                                      onChanged: (val) => setState(() {
                                        selectedCurrencyId = val;
                                        selectedCurrency = currencies
                                            .firstWhere((u) => u.id == val)
                                            .currency;
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Bank Name'.tr(),
                                      hintText: 'Enter Bank Name'.tr(),
                                      controller: bankNameController,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Vat Number'.tr(),
                                      hintText: 'Enter Vat Name'.tr(),
                                      controller: vatNumberController,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              10.h,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Account Number'.tr(),
                                      hintText: 'Enter Account Number'.tr(),
                                      controller: accountNumberController,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(20),
                                      ],
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Email'.tr(),
                                      hintText: 'Enter email address'.tr(),
                                      controller: emailController,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              CustomMmTextField(
                                labelText: 'Notes'.tr(),
                                hintText: 'Add a note'.tr(),
                                controller: notesController,
                              ),
                              14.h,
                              MultipleContactsWidget(
                                contacts: contacts,
                                onChanged: (list) {
                                  setState(() {
                                    contacts = list;
                                  });
                                },
                              ),
                              14.h,
                              StatusSwitchWidget(
                                isSwitched: status,
                                onChanged: toggleSwitch,
                              ),
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
                                      // captionAllowed: false,
                                      videoAllowed: false,
                                      cameraAllowed: true,
                                      child: Container(
                                        height: context.height * 0.2,
                                        width: context.width * 0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                                      File(
                                                        attachments.last.url,
                                                      ),
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
                                title: widget.isEdit && !widget.isClone
                                    ? 'Update Customer'.tr()
                                    : widget.isClone
                                    ? 'Clone Customer'
                                    : 'Create Customer'.tr(),
                                onCreate: () {
                                  if (addCreateProductKey.currentState!
                                      .validate()) {
                                    _addClient();
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
          ],
        ),
      ),
    );
  }
}
