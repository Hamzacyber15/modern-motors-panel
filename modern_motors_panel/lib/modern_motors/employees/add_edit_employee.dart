import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/hr_info_model.dart';
import 'package:modern_motors_panel/model/hr_models/nationality_model.dart';
import 'package:modern_motors_panel/model/hr_models/role_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/custom_expansion_tile.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

// class AddEditEmployee extends StatefulWidget {
//   final VoidCallback? onBack;
//   final EmployeeModel? employeeModel;
//   final bool isEdit;

//   const AddEditEmployee({
//     super.key,
//     this.onBack,
//     this.employeeModel,
//     required this.isEdit,
//   });

//   @override
//   State<AddEditEmployee> createState() => _AddEditEmployeeState();
// }

// class _AddEditEmployeeState extends State<AddEditEmployee> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emergencyNameController = TextEditingController();
//   // final TextEditingController nationalityController = TextEditingController();
//   final TextEditingController emergencyContactContoller =
//       TextEditingController();
//   final TextEditingController contactNumberController = TextEditingController();
//   final TextEditingController streetAddress1Controller =
//       TextEditingController();
//   final TextEditingController streetAddress2Controller =
//       TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController postalCodeController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController idCardNumberController = TextEditingController();
//   GlobalKey<FormState> addCreateProductKey = GlobalKey<FormState>();
//   ValueNotifier<bool> loading = ValueNotifier(false);
//   ValueNotifier<bool> catLoader = ValueNotifier(false);
//   bool status = true;
//   List<AttachmentModel> attachments = [];
//   List<BranchModel> branches = [];
//   List<CountryModel> countries = [];
//   List<NationalityModel> nationalities = [];
//   List<String> gender = ['male', 'female'];
//   List<RoleModel> role = [];
//   User? user = FirebaseAuth.instance.currentUser;
//   String? selectedCountry;
//   String? selectBranchId;
//   String? selectedCountryId;
//   String? selectedRoleId;
//   String? selectedGender;
//   String? selectedNationalityId;

//   DateTime? selectedDob;

//   @override
//   void initState() {
//     super.initState();
//     _loadDataAndInit();
//   }

//   Future<void> pickDate({
//     required BuildContext context,
//     required TextEditingController controller,
//   }) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       selectedDob = picked;
//       controller.text = DateFormat('yyyy-MM-dd').format(picked);
//     }
//   }

//   Future<void> _loadDataAndInit() async {
//     if (catLoader.value) {
//       return;
//     }
//     catLoader.value = true;
//     final country = await DataFetchService.fetchCountries();
//     final roleList = await DataFetchService.fetchRoles();
//     final branchList = await DataFetchService.fetchBranches();
//     final natianalityList = await DataFetchService.fetchNationalities();

//     catLoader.value = false;
//     setState(() {
//       role = roleList;
//       countries = country;
//       branches = branchList;
//       nationalities = natianalityList;

//       if (widget.isEdit && widget.employeeModel != null) {
//         final employee = widget.employeeModel!;
//         nameController.text = employee.name;
//         // emergencyNameController.text = employee.emergencyName;
//         idCardNumberController.text = employee.idCardNumber;
//         //  emergencyContactContoller.text = employee.emergencyContact;
//         contactNumberController.text = employee.contactNumber;
//         // streetAddress1Controller.text = employee.streetAddress1;
//         // streetAddress2Controller.text = employee.streetAddress2;
//         // cityController.text = employee.city;
//         // stateController.text = employee.state;
//         // postalCodeController.text = employee.postalCode;
//         emailController.text = employee.email;
//         status = employee.status == 'active' ? true : false;
//         //   selectedDob = employee.dob;
//         dobController.text = DateFormat('yyyy-MM-dd').format(selectedDob!);

//         // if (gender.contains(employee.gender.toLowerCase())) {
//         //   selectedGender = employee.gender.toLowerCase();
//         // }

//         // if (roleList.any((u) => u.id == employee.roleId)) {
//         //   selectedRoleId = employee.roleId;
//         // } else {
//         //   selectedRoleId = null;
//         // }
//         // if (branchList.any((u) => u.id == employee.branchId)) {
//         //   selectBranchId = employee.branchId;
//         // } else {
//         //   selectBranchId = null;
//         // }
//         if (natianalityList.any((u) => u.id == employee.nationalityId)) {
//           selectedNationalityId = employee.nationalityId;
//         } else {
//           selectedNationalityId = null;
//         }
//         // if (countries.any((u) => u.id == employee.countryId)) {
//         //   selectedCountryId = employee.countryId;
//         // } else {
//         //   selectedCountryId = null;
//         // }
//       }
//     });
//   }

//   Future<String> getNextEmployeeNumber() async {
//     final counterRef = FirebaseFirestore.instance
//         .collection('counters')
//         .doc('employeeCounter');

//     return FirebaseFirestore.instance.runTransaction((transaction) async {
//       final snapshot = await transaction.get(counterRef);

//       int currentNumber = 0;
//       if (snapshot.exists &&
//           snapshot.data()!.containsKey('lastEmployeeNumber')) {
//         currentNumber = snapshot['lastEmployeeNumber'] as int;
//       }

//       int newNumber = currentNumber + 1;
//       transaction.set(counterRef, {'lastEmployeeNumber': newNumber});
//       return "E${newNumber.toString().padLeft(4, '0')}";
//     });
//   }

//   Future<String> createUser() async {
//     String userId = "";
//     HttpsCallable callable =
//         FirebaseFunctions.instance.httpsCallable('createUser');
//     final results = await callable(
//         {"email": emailController.text.trim(), 'password': "123456"});
//     dynamic result = results.data;
//     if (result != null) {
//       userId = result;
//     }
//     return userId;
//   }

//   Future<void> saveEmployeeWithBatch(
//     EmployeeModel employee,
//     BuildContext context,
//   ) async {
//     WriteBatch batch = FirebaseFirestore.instance.batch();
//     try {
//       String id = await createUser();
//       if (id == "error") {
//         if (context.mounted) {
//           Constants.showMessage(context, "error ????");
//         }
//         return;
//       }
//       String employeeNumber = await Constants.getUniqueNumber("E");
//       // String employeeId =
//       //     FirebaseFirestore.instance.collection('mmEmployees').doc().id;

//       //User? currentUser = FirebaseAuth.instance.currentUser;
//       List<String> urls = await Future.wait(
//         attachments.map((attachment) async {
//           return await Constants.uploadAttachment(attachment);
//         }),
//       );
//       employee.userId = id;
//       employee.profileUrl = urls.first;
//       batch.set(
//         FirebaseFirestore.instance.collection('mmEmployees').doc(id),
//         {...employee.toMap(), "employeeId": employeeNumber, "id": id},
//         SetOptions(merge: true),
//       );

//       batch.set(
//         FirebaseFirestore.instance.collection('mmProfile').doc(id),
//         {
//           "employeeNumber": employeeNumber,
//           "userId": id,
//           "userName": employee.name,
//           "emergencyName": employee.emergencyName,
//           "nationalityId": employee.nationalityId,
//           "city": employee.city,
//           "streetAddress1": employee.streetAddress1,
//           "streetAddress2": employee.streetAddress2,
//           "userMobile": employee.contactNumber,
//           "countryId": employee.countryId,
//           "roleId": employee.roleId,
//           "dob": employee.dob,
//           "postalCode": employee.postalCode,
//           "emergencyContact": employee.emergencyContact,
//           "profileUrl": urls.first,
//           "idCard": employee.idCardNumber,
//           "userEmail": employee.email,
//           // "branchId": employee.branchId,
//           // "gender": employee.gender,
//           "timestamp": employee.timestamp,
//         },
//         SetOptions(merge: true),
//       );

//       await batch.commit();

//       if (context.mounted) {
//         SnackbarUtils.showSnackbar(context, "Employee saved successfully");
//       }
//     } catch (e) {
//       debugPrint("Error saving employee: $e");
//       if (context.mounted) {
//         SnackbarUtils.showSnackbar(context, "Failed to save employee: $e");
//       }
//     }
//   }

//   void _submitProduct() async {
//     if (loading.value) return;
//     loading.value = true;

//     try {
//       final employeeData = EmployeeModel(
//         gender: "",
//         branchId: "",
//         equipments: [],
//         id: '',
//         attachments: [],
//         designation: '',
//         globalEmployee: false,
//         otherCompany: '',
//         name: nameController.text.trim(),
//         emergencyName: emergencyNameController.text.trim(),
//         nationalityId: selectedNationalityId!,
//         userId: FirebaseAuth.instance.currentUser!.uid,
//         city: cityController.text.trim(),
//         streetAddress1: streetAddress1Controller.text.trim(),
//         streetAddress2: streetAddress2Controller.text.trim(),
//         contactNumber: contactNumberController.text.trim(),
//         countryId: selectedCountryId!,
//         roleId: selectedRoleId!,
//         dob: selectedDob!,
//         postalCode: postalCodeController.text.trim(),
//         emergencyContact: emergencyContactContoller.text.trim(),
//         profileUrl: attachments.isNotEmpty ? attachments.first.url : "",
//         idCardNumber: idCardNumberController.text.trim(),
//         email: emailController.text.trim(),
//         // branchId: selectBranchId!,
//         // gender: selectedGender ?? '',
//         state: stateController.text.trim(),
//         status: status ? 'active' : 'inactive',
//         timestamp: Timestamp.now(),
//       );

//       await saveEmployeeWithBatch(employeeData, context);

//       widget.onBack?.call();
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
//     ConnectivityResult connectionStatus =
//         context.watch<ConnectivityProvider>().connectionStatus;
//     return CustomScrollView(
//       slivers: [
//         SliverToBoxAdapter(
//           child: PageHeaderWidget(
//             title: 'Create Employees'.tr(),
//             buttonText: 'Back to Manage Employees'.tr(),
//             subTitle: 'Add New Employees'.tr(),
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
//               child: Column(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: AppTheme.whiteColor,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: AppTheme.borderColor,
//                         width: 0.6,
//                       ),
//                     ),
//                     child: Form(
//                       key: addCreateProductKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomExpansionTile(
//                             title: 'Employee Information'.tr(),
//                             icon: Icons.people,
//                             // or Icons.edit_note, or use custom image
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 8,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       PickerWidget(
//                                         multipleAllowed: true,
//                                         attachments: attachments,
//                                         galleryAllowed: true,
//                                         onFilesPicked: onFilesPicked,
//                                         memoAllowed: false,
//                                         // ft: FileType.image,
//                                         filesAllowed: false,
//                                         // captionAllowed: false,
//                                         videoAllowed: false,
//                                         cameraAllowed: true,
//                                         child: Container(
//                                           height: context.height * 0.2,
//                                           width: context.width * 0.1,
//                                           decoration: BoxDecoration(
//                                             color: Colors.transparent,
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                             border: Border.all(
//                                               color: AppTheme.borderColor,
//                                             ),
//                                           ),
//                                           child: attachments.isNotEmpty
//                                               ? kIsWeb
//                                                   ? Image.memory(
//                                                       attachments.last.bytes!,
//                                                       fit: BoxFit.cover,
//                                                     )
//                                                   : Image.file(
//                                                       File(
//                                                         attachments.last.url,
//                                                       ),
//                                                       fit: BoxFit.cover,
//                                                     )
//                                               : Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Icon(
//                                                       Icons
//                                                           .add_circle_outline_rounded,
//                                                     ),
//                                                     Text('Add Image'.tr()),
//                                                   ],
//                                                 ),
//                                         ),
//                                       ),
//                                       12.w,
//                                       Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               SizedBox(
//                                                 height: context.height * 0.06,
//                                                 width: context.height * 0.22,
//                                                 child: CustomButton(
//                                                   text: 'Upload Image'.tr(),
//                                                   onPressed: () {},
//                                                   fontSize: 14,
//                                                   buttonType: ButtonType.Filled,
//                                                   backgroundColor:
//                                                       AppTheme.primaryColor,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           8.h,
//                                           Text(
//                                             'JPEG, PNG up to 2 MB'.tr(),
//                                             style: AppTheme.getCurrentTheme(
//                                                     false, connectionStatus)
//                                                 .textTheme
//                                                 .bodyMedium!
//                                                 .copyWith(fontSize: 12),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 8.h,
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'Full Name'.tr(),
//                                         hintText: 'Enter Full Name'.tr(),
//                                         controller: nameController,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator: ValidationUtils.validateName,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomSearchableDropdown(
//                                         key: UniqueKey(),
//                                         hintText: 'Choose Nationality'.tr(),
//                                         value: selectedNationalityId,
//                                         items: {
//                                           for (var u in nationalities)
//                                             u.id!: u.nationality,
//                                         },
//                                         onChanged: (val) => setState(() {
//                                           selectedNationalityId = val;
//                                         }),
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'ID Card Number'.tr(),
//                                         hintText: 'Enter ID Card Number'.tr(),
//                                         controller: idCardNumberController,
//                                         inputFormatter: [
//                                           FilteringTextInputFormatter
//                                               .digitsOnly,
//                                         ],
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         // validator: ValidationUtils.idCardNumber(value),
//                                         validator: ValidationUtils.idCardNumber,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 6.h,
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'Mobile Number'.tr(),
//                                         hintText: 'Enter Mobile Number'.tr(),
//                                         controller: contactNumberController,
//                                         inputFormatter: [
//                                           FilteringTextInputFormatter
//                                               .digitsOnly,
//                                           LengthLimitingTextInputFormatter(8),
//                                         ],
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator: ValidationUtils.mobileNumber,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomSearchableDropdown(
//                                         key: UniqueKey(),
//                                         hintText: 'Choose Role'.tr(),
//                                         value: selectedRoleId,
//                                         items: {
//                                           for (var u in role) u.id!: u.name,
//                                         },
//                                         onChanged: (val) => setState(() {
//                                           selectedRoleId = val;
//                                         }),
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomSearchableDropdown(
//                                         key: UniqueKey(),
//                                         hintText: 'Choose Country'.tr(),
//                                         value: selectedCountryId,
//                                         items: {
//                                           for (var u in countries)
//                                             u.id!: u.country,
//                                         },
//                                         onChanged: (val) => setState(() {
//                                           selectedCountryId = val;
//                                           selectedCountry = countries
//                                               .firstWhere(
//                                                 (u) => u.id == val,
//                                               )
//                                               .country;
//                                         }),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 8.h,
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomSearchableDropdown(
//                                         hintText: 'Choose Gender'.tr(),
//                                         items: {
//                                           'male': 'Male'.tr(),
//                                           'female': 'Female'.tr(),
//                                         },
//                                         value: selectedGender,
//                                         onChanged: (val) {
//                                           setState(() {
//                                             selectedGender = val;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomSearchableDropdown(
//                                         key: UniqueKey(),
//                                         hintText: 'Choose Branch'.tr(),
//                                         value: selectBranchId,
//                                         items: {
//                                           for (var u in branches)
//                                             u.id!: u.branchName,
//                                         },
//                                         onChanged: (val) => setState(() {
//                                           selectBranchId = val;
//                                         }),
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         onTap: () {
//                                           pickDate(
//                                             context: context,
//                                             controller: dobController,
//                                           );
//                                         },
//                                         readOnly: true,
//                                         labelText: 'Date of Birth'.tr(),
//                                         hintText: 'Date of Birth'.tr(),
//                                         controller: dobController,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please select a date of birth'
//                                                 .tr();
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                     10.w,
//                                   ],
//                                 ),
//                                 8.h,
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'Email'.tr(),
//                                         hintText: 'Enter email address'.tr(),
//                                         controller: emailController,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator:
//                                             ValidationUtils.validateEmail,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 8.h,
//                               ],
//                             ),
//                           ),
//                           CustomExpansionTile(
//                             title: 'Address Information'.tr(),
//                             icon: Icons.edit_document,
//                             // or Icons.edit_note, or use custom image
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'Street Address 1'.tr(),
//                                         hintText: 'Enter Street Address 1'.tr(),
//                                         controller: streetAddress1Controller,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator:
//                                             ValidationUtils.validateAddress,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'Street Address 2'.tr(),
//                                         hintText: 'Enter Street Address 2'.tr(),
//                                         controller: streetAddress2Controller,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator:
//                                             ValidationUtils.validateAddress,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 10.h,
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'City'.tr(),
//                                         hintText: 'Enter City'.tr(),
//                                         controller: cityController,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator: ValidationUtils.validateCity,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'State'.tr(),
//                                         hintText: 'Enter State'.tr(),
//                                         controller: stateController,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator:
//                                             ValidationUtils.validateState,
//                                       ),
//                                     ),
//                                     10.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText: 'Postal Code'.tr(),
//                                         hintText: 'Enter Postal Code'.tr(),
//                                         controller: postalCodeController,
//                                         inputFormatter: [
//                                           FilteringTextInputFormatter
//                                               .digitsOnly,
//                                           LengthLimitingTextInputFormatter(6),
//                                         ],
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator:
//                                             ValidationUtils.validatePostalCode,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           CustomExpansionTile(
//                             title: 'Emergency Information'.tr(),
//                             icon: Icons.edit_document,
//                             // or Icons.edit_note, or use custom image
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText:
//                                             'Emergency Contact Name'.tr(),
//                                         hintText: 'Enter Emergency Name'.tr(),
//                                         controller: emergencyNameController,
//                                         autovalidateMode:
//                                             AutovalidateMode.onUserInteraction,
//                                         validator: ValidationUtils
//                                             .validateEmergencyName,
//                                       ),
//                                     ),
//                                     16.w,
//                                     Expanded(
//                                       child: CustomMmTextField(
//                                         labelText:
//                                             'Emergency Contact Number'.tr(),
//                                         hintText: 'Enter Emergency Number'.tr(),
//                                         controller: emergencyContactContoller,
//                                         inputFormatter: [
//                                           FilteringTextInputFormatter
//                                               .digitsOnly,
//                                           LengthLimitingTextInputFormatter(8),
//                                         ],
//                                         validator: ValidationUtils
//                                             .validateEmergencyContactNumber,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   18.h,
//                   AlertDialogBottomWidget(
//                     title: widget.isEdit
//                         ? 'Update employee'.tr()
//                         : 'Create employee'.tr(),
//                     onCreate: () {
//                       if (addCreateProductKey.currentState!.validate()) {
//                         _submitProduct();
//                       }
//                     },
//                     onCancel: widget.onBack!.call,
//                     loadingNotifier: loading,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddEditEmployee extends StatefulWidget {
  final VoidCallback? onBack;
  final EmployeeModel? employeeModel;
  final bool isEdit;

  const AddEditEmployee({
    super.key,
    this.onBack,
    this.employeeModel,
    required this.isEdit,
  });

  @override
  State<AddEditEmployee> createState() => _AddEditEmployeeState();
}

class _AddEditEmployeeState extends State<AddEditEmployee> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyContactContoller =
      TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController streetAddress1Controller =
      TextEditingController();
  final TextEditingController streetAddress2Controller =
      TextEditingController();
  List<MapEntry<String, String>> _selectedBranchesList = [];
  String? _selectedBranchId;
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController idCardNumberController = TextEditingController();
  GlobalKey<FormState> addCreateProductKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  List<AttachmentModel> attachments = [];
  List<BranchModel> branches = [];
  List<CountryModel> countries = [];
  List<NationalityModel> nationalities = [];
  List<String> gender = ['male', 'female'];
  List<RoleModel> roles = [];
  User? user = FirebaseAuth.instance.currentUser;
  String? selectedCountry;
  String? selectBranchId;
  String? selectedCountryId;
  String? selectedRoleId;
  String? selectedGender;
  String? selectedNationalityId;

  DateTime? selectedDob;

  @override
  void initState() {
    super.initState();
    _loadDataAndInit();
  }

  Future<void> pickDate({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    final now = DateTime.now();
    final minAgeDate = DateTime(
      now.year - 16,
      now.month,
      now.day,
    ); // 16 years ago

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minAgeDate,
      firstDate: DateTime(1900),
      lastDate: minAgeDate,
    );

    if (picked != null) {
      selectedDob = picked;
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _loadDataAndInit() async {
    if (catLoader.value) {
      return;
    }
    catLoader.value = true;
    final provider = context.read<MmResourceProvider>();

    catLoader.value = false;
    setState(() {
      roles = provider.designationsList;
      countries = provider.countryList;
      branches = provider.branchesList;
      nationalities = provider.nationalityList;

      if (widget.isEdit && widget.employeeModel != null) {
        _selectedBranchesList = [];
        final employee = widget.employeeModel!;
        nameController.text = employee.name;
        emergencyNameController.text = employee.emergencyName;
        idCardNumberController.text = employee.idCardNumber;
        emergencyContactContoller.text = employee.emergencyContact;
        contactNumberController.text = employee.contactNumber;
        streetAddress1Controller.text = employee.streetAddress1;
        streetAddress2Controller.text = employee.streetAddress2;
        cityController.text = employee.city;
        stateController.text = employee.state;
        postalCodeController.text = employee.postalCode;
        emailController.text = employee.email;
        status = employee.status == 'active' ? true : false;
        selectedDob = employee.dob;
        dobController.text = DateFormat('yyyy-MM-dd').format(selectedDob!);
        employee.profileAccessKey = employee.profileAccessKey ?? [];

        if (gender.contains(employee.gender.toLowerCase())) {
          selectedGender = employee.gender.toLowerCase();
        }

        if (roles.any((u) => u.id == employee.roleId)) {
          selectedRoleId = employee.roleId;
        } else {
          selectedRoleId = null;
        }
        if (branches.any((u) => u.id == employee.branchId)) {
          selectBranchId = employee.branchId;
        } else {
          selectBranchId = null;
        }
        if (nationalities.any((u) => u.id == employee.nationalityId)) {
          selectedNationalityId = employee.nationalityId;
        } else {
          selectedNationalityId = null;
        }
        if (countries.any((u) => u.id == employee.countryId)) {
          selectedCountryId = employee.countryId;
        } else {
          selectedCountryId = null;
        }
        if (employee.branches != null && employee.branches!.isNotEmpty) {
          for (final id in employee.branches!) {
            final matched = branches.firstWhere(
              (c) => c.id == id,
              orElse: () => BranchModel(branchName: ''),
            );
            if (matched.id != null && matched.branchName.isNotEmpty) {
              _selectedBranchesList.add(
                MapEntry(matched.id!, matched.branchName),
              );
            }
          }
        }
      }
    });
  }

  Future<String> getNextEmployeeNumber() async {
    final counterRef = FirebaseFirestore.instance
        .collection('counters')
        .doc('employeeCounter');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int currentNumber = 0;
      if (snapshot.exists &&
          snapshot.data()!.containsKey('lastEmployeeNumber')) {
        currentNumber = snapshot['lastEmployeeNumber'] as int;
      }

      int newNumber = currentNumber + 1;
      transaction.set(counterRef, {'lastEmployeeNumber': newNumber});
      return "E${newNumber.toString().padLeft(4, '0')}";
    });
  }

  Future<String> createUser() async {
    String userId = "";
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'createUser',
    );
    final results = await callable({
      "email": emailController.text.trim(),
      'password': "test1234",
    });
    dynamic result = results.data;
    if (result != null) {
      userId = result;
    }
    return userId;
  }

  Future<void> saveEmployeeWithBatch() async {
    if (loading.value) return;
    loading.value = true;

    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      String employeeId;
      String employeeNumber;

      if (widget.isEdit && widget.employeeModel != null) {
        employeeId = widget.employeeModel!.id;
        employeeNumber = widget.employeeModel!.employeeNumber ?? "";
      } else {
        // employeeNumber = await getNextEmployeeNumber();
        employeeNumber = await Constants.getUniqueNumber("mmE");
        if (employeeNumber.isEmpty) {
          employeeNumber = await Constants.getUniqueNumber("mmE");
        }
        employeeId = await createUser();
      }
      if (employeeId == "error") {
        if (mounted) {
          Constants.showMessage(context, "Error Creating user");
        }
        return;
      }

      final empRef = FirebaseFirestore.instance
          .collection('mmEmployees')
          .doc(employeeId);
      final empSnap = await empRef.get();

      // final existingEmpHrInfo = empSnap.data()?['hrInfo'] ?? {};
      final existingEmpHrInfoData = empSnap.data()?['hrInfo'];
      final existingEmpHrInfo = existingEmpHrInfoData != null
          ? HrInfoModel.fromMap(
              Map<String, dynamic>.from(existingEmpHrInfoData),
            )
          : null;
      // final existingAdminAccess = empSnap.data()?['adminAccess'] ?? {};

      final existingAdminAccessData = empSnap.data()?['adminAccess'];
      final existingAdminAccess = existingAdminAccessData != null
          ? List<String>.from(existingAdminAccessData)
          : <String>[];

      final selectedBranches = _selectedBranchesList.map((e) => e.key).toList();

      final employeeData = EmployeeModel(
        equipments: [],
        id: employeeId,
        attachments: [],
        designation: '',
        globalEmployee: false,
        otherCompany: '',
        branches: selectedBranches,
        name: nameController.text.trim(),
        emergencyName: emergencyNameController.text.trim(),
        nationalityId: selectedNationalityId!,
        userId: employeeId,
        city: cityController.text.trim(),
        streetAddress1: streetAddress1Controller.text.trim(),
        streetAddress2: streetAddress2Controller.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        countryId: "",
        roleId: selectedRoleId!,
        dob: selectedDob!,
        employeeCode: employeeNumber,
        employeeNumber: employeeNumber,
        postalCode: postalCodeController.text.trim(),
        emergencyContact: emergencyContactContoller.text.trim(),
        profileUrl: attachments.isNotEmpty ? attachments.first.url : "",
        idCardNumber: idCardNumberController.text.trim(),
        email: emailController.text.trim(),
        branchId: selectBranchId!,
        gender: selectedGender ?? '',
        state: stateController.text.trim(),
        status: status ? 'active' : 'inactive',
        timestamp: Timestamp.now(),
        hrInfo: existingEmpHrInfo,
        adminAccess: existingAdminAccess,
        profileAccessKey: widget.isEdit
            ? widget.employeeModel?.profileAccessKey ?? []
            : [],
      );

      batch.set(empRef, {...employeeData.toMap()}, SetOptions(merge: true));

      final profileRef = FirebaseFirestore.instance
          .collection('mmProfile')
          .doc(employeeId);
      final profileSnap = await profileRef.get();
      final existingProfileHrInfo = profileSnap.data()?['hrInfo'] ?? {};

      batch.set(profileRef, {
        "employeeNumber": employeeNumber,
        "userId": employeeId,
        "userName": employeeData.name,
        "emergencyName": employeeData.emergencyName,
        "nationalityId": employeeData.nationalityId,
        "city": employeeData.city,
        "streetAddress1": employeeData.streetAddress1,
        "streetAddress2": employeeData.streetAddress2,
        "userMobile": employeeData.contactNumber,
        "countryId": "",
        "roleId": employeeData.roleId,
        "dob": employeeData.dob,
        'branches': selectedBranches,
        "postalCode": employeeData.postalCode,
        "emergencyContact": employeeData.emergencyContact,
        "profileUrl": employeeData.profileUrl,
        "idCard": employeeData.idCardNumber,
        "userEmail": employeeData.email,
        "branchId": employeeData.branchId,
        "gender": employeeData.gender,
        "timestamp": employeeData.timestamp,
        "hrInfo": existingProfileHrInfo, // keep old hrInfo
      }, SetOptions(merge: true));

      await batch.commit().then((value) {
        widget.onBack?.call();
      });

      if (mounted) {
        Constants.showMessage(
          context,
          widget.isEdit
              ? "Employee updated successfully"
              : "Employee saved successfully",
        );
      }
    } catch (e) {
      debugPrint("Error saving employee: $e");
      if (mounted) {
        Constants.showMessage(context, "Failed to save employee: $e");
      }
    } finally {
      loading.value = false;
    }
  }

  // void _submitProduct() async {
  //   if (loading.value) return;
  //   loading.value = true;
  //
  //   try {
  //     final employeeData = EmployeeModel(
  //       equipments: [],
  //       id
  //       :,
  //       attachments: [],
  //       designation: '',
  //       globalEmployee: false,
  //       otherCompany: '',
  //       name: nameController.text.trim(),
  //       emergencyName: emergencyNameController.text.trim(),
  //       nationalityId: selectedNationalityId!,
  //       userId: FirebaseAuth.instance.currentUser!.uid,
  //       city: cityController.text.trim(),
  //       streetAddress1: streetAddress1Controller.text.trim(),
  //       streetAddress2: streetAddress2Controller.text.trim(),
  //       contactNumber: contactNumberController.text.trim(),
  //       countryId: selectedCountryId!,
  //       roleId: selectedRoleId!,
  //       dob: selectedDob!,
  //       postalCode: postalCodeController.text.trim(),
  //       emergencyContact: emergencyContactContoller.text.trim(),
  //       profileUrl: attachments.isNotEmpty ? attachments.first.url : "",
  //       idCardNumber: idCardNumberController.text.trim(),
  //       email: emailController.text.trim(),
  //       branchId: selectBranchId!,
  //       gender: selectedGender ?? '',
  //       state: stateController.text.trim(),
  //       status: status ? 'active' : 'inactive',
  //       timestamp: Timestamp.now(),
  //       profileAccessKey:
  //       widget.isEdit ? widget.employeeModel?.profileAccessKey ?? [] : [],
  //     );
  //
  //     await saveEmployeeWithBatch(employeeData, context);
  //   } finally {
  //     loading.value = false;
  //   }
  // }

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
            title: 'Create Employees'.tr(),
            buttonText: 'Back to Manage Employees'.tr(),
            subTitle: 'Add New Employees'.tr(),
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
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.borderColor,
                        width: 0.6,
                      ),
                    ),
                    child: Form(
                      key: addCreateProductKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomExpansionTile(
                            isExpend: widget.isEdit,
                            title: 'Employee Information'.tr(),
                            icon: Icons.people,
                            // or Icons.edit_note, or use custom image
                            child: Column(
                              children: [
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
                                                    ).textTheme.bodyMedium!
                                                    .copyWith(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                8.h,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Full Name'.tr(),
                                        hintText: 'Enter Full Name'.tr(),
                                        controller: nameController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: ValidationUtils.validateName,
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomSearchableDropdown(
                                        key: UniqueKey(),
                                        hintText: 'Choose Nationality'.tr(),
                                        value: selectedNationalityId,
                                        items: {
                                          for (var u in nationalities)
                                            u.id!: u.nationality,
                                        },
                                        onChanged: (val) => setState(() {
                                          selectedNationalityId = val;
                                        }),
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'ID Card Number'.tr(),
                                        hintText: 'Enter ID Card Number'.tr(),
                                        controller: idCardNumberController,
                                        inputFormatter: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: ValidationUtils.idCardNumber,
                                      ),
                                    ),
                                  ],
                                ),
                                6.h,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Mobile Number'.tr(),
                                        hintText: 'Enter Mobile Number'.tr(),
                                        controller: contactNumberController,
                                        inputFormatter: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(8),
                                        ],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: ValidationUtils.mobileNumber,
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomSearchableDropdown(
                                        key: UniqueKey(),
                                        hintText: 'Choose Designation'.tr(),
                                        value: selectedRoleId,
                                        items: {
                                          for (var u in roles) u.id!: u.name,
                                        },
                                        onChanged: (val) => setState(() {
                                          selectedRoleId = val;
                                        }),
                                      ),
                                    ),
                                    // 10.w,
                                    // Expanded(
                                    //   child: CustomSearchableDropdown(
                                    //     key: UniqueKey(),
                                    //     hintText: 'Choose Country'.tr(),
                                    //     value: selectedCountryId,
                                    //     items: {
                                    //       for (var u in countries)
                                    //         u.id!: u.country,
                                    //     },
                                    //     onChanged: (val) => setState(() {
                                    //       selectedCountryId = val;
                                    //       selectedCountry = countries
                                    //           .firstWhere(
                                    //             (u) => u.id == val,
                                    //           )
                                    //           .country;
                                    //     }),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                8.h,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomSearchableDropdown(
                                        hintText: 'Choose Gender'.tr(),
                                        items: {
                                          'male': 'Male'.tr(),
                                          'female': 'Female'.tr(),
                                        },
                                        value: selectedGender,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedGender = val;
                                          });
                                        },
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomSearchableDropdown(
                                        key: UniqueKey(),
                                        hintText: 'Choose Branch'.tr(),
                                        value: selectBranchId,
                                        items: {
                                          for (var u in branches)
                                            u.id!: u.branchName,
                                        },
                                        onChanged: (val) => setState(() {
                                          selectBranchId = val;
                                        }),
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomMmTextField(
                                        onTap: () {
                                          pickDate(
                                            context: context,
                                            controller: dobController,
                                          );
                                        },
                                        readOnly: true,
                                        labelText: 'Date of Birth'.tr(),
                                        hintText: 'Date of Birth'.tr(),
                                        controller: dobController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a date of birth'
                                                .tr();
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    10.w,
                                  ],
                                ),
                                8.h,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Email'.tr(),
                                        hintText: 'Enter email address'.tr(),
                                        controller: emailController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator:
                                            ValidationUtils.validateEmail,
                                      ),
                                    ),
                                  ],
                                ),
                                8.h,
                                CustomSearchableDropdown(
                                  isMultiSelect: true,
                                  selectedValues: _selectedBranchesList
                                      .map((e) => e.key)
                                      .toList(),
                                  key: const ValueKey('category_dropdown'),
                                  hintText: 'Choose Branches'.tr(),
                                  value: _selectedBranchId,
                                  items: {
                                    for (var c in branches) c.id!: c.branchName,
                                  },
                                  onMultiChanged: (selectedItems) {
                                    setState(() {
                                      _selectedBranchesList = selectedItems;
                                    });
                                  },
                                  onChanged: (_) {},
                                ),
                                8.h,
                              ],
                            ),
                          ),
                          CustomExpansionTile(
                            isExpend: widget.isEdit,
                            title: 'Address Information'.tr(),
                            icon: Icons.edit_document,
                            // or Icons.edit_note, or use custom image
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Street Address 1'.tr(),
                                        hintText: 'Enter Street Address 1'.tr(),
                                        controller: streetAddress1Controller,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator:
                                            ValidationUtils.validateAddress,
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Street Address 2'.tr(),
                                        hintText: 'Enter Street Address 2'.tr(),
                                        controller: streetAddress2Controller,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator:
                                            ValidationUtils.validateAddress,
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
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: ValidationUtils.validateCity,
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'State'.tr(),
                                        hintText: 'Enter State'.tr(),
                                        controller: stateController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator:
                                            ValidationUtils.validateState,
                                      ),
                                    ),
                                    10.w,
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Postal Code'.tr(),
                                        hintText: 'Enter Postal Code'.tr(),
                                        controller: postalCodeController,
                                        inputFormatter: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(6),
                                        ],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator:
                                            ValidationUtils.validatePostalCode,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomExpansionTile(
                            isExpend: widget.isEdit,
                            title: 'Emergency Information'.tr(),
                            icon: Icons.edit_document,
                            // or Icons.edit_note, or use custom image
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Emergency Contact Name'
                                            .tr(),
                                        hintText: 'Enter Emergency Name'.tr(),
                                        controller: emergencyNameController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: ValidationUtils
                                            .validateEmergencyName,
                                      ),
                                    ),
                                    16.w,
                                    Expanded(
                                      child: CustomMmTextField(
                                        labelText: 'Emergency Contact Number'
                                            .tr(),
                                        hintText: 'Enter Emergency Number'.tr(),
                                        controller: emergencyContactContoller,
                                        inputFormatter: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(8),
                                        ],
                                        validator: ValidationUtils
                                            .validateEmergencyContactNumber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  18.h,
                  AlertDialogBottomWidget(
                    title: widget.isEdit
                        ? 'Update employee'.tr()
                        : 'Create employee'.tr(),
                    onCreate: () async {
                      if (addCreateProductKey.currentState!.validate()) {
                        // _submitProduct();
                        saveEmployeeWithBatch();
                      }
                    },
                    onCancel: widget.onBack!.call,
                    loadingNotifier: loading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
