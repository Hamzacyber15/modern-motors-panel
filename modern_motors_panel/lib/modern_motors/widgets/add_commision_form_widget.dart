// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:practice_erp/model/employee_model.dart';
// // import 'package:practice_erp/services/data_fetch.dart';
// // import 'package:practice_erp/view/unit/extensions.dart';
// // import 'package:practice_erp/widgets/custom_searchable_drop_down.dart';
// // import 'package:practice_erp/widgets/custom_text_field.dart';
// // import 'package:practice_erp/widgets/overlay_laoder.dart';
// //
// // import '../../model/employee_commission_model.dart'; // <- model import
// // import '../form_widgets/alert_dialog_bottom_widget.dart';
// // import '../form_widgets/alert_dialog_header.dart';
// //
// // class AddCommissionFormWidget extends StatefulWidget {
// //   const AddCommissionFormWidget({super.key});
// //
// //   @override
// //   State<AddCommissionFormWidget> createState() =>
// //       _AddCommissionFormWidgetState();
// // }
// //
// // class _AddCommissionFormWidgetState extends State<AddCommissionFormWidget> {
// //   final _formKey = GlobalKey<FormState>();
// //
// //   bool _loading = true;
// //   List<EmployeeModel> _employees = [];
// //   String? _selectedEmployeeId;
// //
// //   bool _useAmount = true;
// //   final TextEditingController _valueCtrl = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadEmployees();
// //   }
// //
// //   Future<void> _loadEmployees() async {
// //     try {
// //       final list = await DataFetchService.fetchEmployees();
// //       setState(() {
// //         _employees = list;
// //         _loading = false;
// //       });
// //     } catch (_) {
// //       if (mounted) setState(() => _loading = false);
// //     }
// //   }
// //
// //   void _toggleAmount(bool v) {
// //     if (v) {
// //       setState(() => _useAmount = true);
// //     }
// //   }
// //
// //   void _togglePercent(bool v) {
// //     if (v) {
// //       setState(() => _useAmount = false);
// //     }
// //   }
// //
// //   String? _validateValue(String? v) {
// //     final txt = (v ?? '').trim();
// //     if (txt.isEmpty) return 'Required';
// //     final parsed = double.tryParse(txt);
// //     if (parsed == null || parsed <= 0) return 'Enter valid number';
// //     if (!_useAmount) {
// //       // percentage mode: 0 < x <= 100
// //       if (parsed > 100) return 'Percentage must be ≤ 100';
// //     }
// //     return null;
// //   }
// //
// //   void _onCancel() {
// //     Navigator.pop(context, null);
// //   }
// //
// //   void _onCreate() {
// //     if (!_formKey.currentState!.validate()) return;
// //     if (_selectedEmployeeId == null || _selectedEmployeeId!.isEmpty) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(const SnackBar(content: Text('Please select employee')));
// //       return;
// //     }
// //
// //     final val = double.parse(_valueCtrl.text.trim());
// //
// //     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
// //
// //     final model = EmployeeCommissionModel(
// //       employeeId: _selectedEmployeeId!,
// //       isAmount: _useAmount,
// //       value: val,
// //       userId: currentUserId,
// //       createdAt: Timestamp.now(),
// //     );
// //
// //     Navigator.pop(context, model);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _valueCtrl.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return OverlayLoader(
// //       loader: _loading,
// //       child: ConstrainedBox(
// //         constraints: const BoxConstraints(maxWidth: 560, minWidth: 480),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               16.h,
// //               const AlertDialogHeader(title: 'Add Commission'),
// //               const Divider(),
// //
// //               // Employee dropdown
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: CustomSearchableDropdown(
// //                   hintText: 'Choose Employee'.tr(),
// //                   value: _selectedEmployeeId,
// //                   items: {for (var e in _employees) e.id!: e.fullName},
// //                   onChanged: (val) => setState(() => _selectedEmployeeId = val),
// //                 ),
// //               ),
// //               12.h,
// //
// //               // Two checkboxes (mutually exclusive)
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: CheckboxListTile(
// //                         contentPadding: EdgeInsets.zero,
// //                         dense: true,
// //                         title: const Text('Amount'),
// //                         value: _useAmount,
// //                         onChanged: (v) {
// //                           if (v == true) _toggleAmount(true);
// //                         },
// //                       ),
// //                     ),
// //                     8.w,
// //                     Expanded(
// //                       child: CheckboxListTile(
// //                         contentPadding: EdgeInsets.zero,
// //                         dense: true,
// //                         title: const Text('Percentage'),
// //                         value: !_useAmount,
// //                         onChanged: (v) {
// //                           if (v == true) _togglePercent(true);
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               // Value field (amount OR percentage)
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: CustomTextField(
// //                   labelText: _useAmount ? 'Amount' : 'Percentage',
// //                   hintText: _useAmount ? 'Enter amount' : 'Enter percentage',
// //                   controller: _valueCtrl,
// //                   autovalidateMode: AutovalidateMode.onUserInteraction,
// //                   validator: _validateValue,
// //                   keyboardType: const TextInputType.numberWithOptions(
// //                     decimal: true,
// //                     signed: false,
// //                   ),
// //                   inputFormatter: [
// //                     FilteringTextInputFormatter.allow(
// //                       RegExp(r'^\d*\.?\d{0,2}'),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               22.h,
// //               AlertDialogBottomWidget(
// //                 title: 'Create',
// //                 onCancel: _onCancel,
// //                 onCreate: _onCreate,
// //                 loadingNotifier: null,
// //               ),
// //               22.h,
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:modern_motors_panel/extensions.dart';
// import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/employees_commision_model.dart';
// import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
// import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
// import 'package:modern_motors_panel/widgets/overlay_loader.dart';

// class AddCommissionFormWidget extends StatefulWidget {
//   final EmployeeCommissionModel? initial;

//   const AddCommissionFormWidget({super.key, this.initial});

//   @override
//   State<AddCommissionFormWidget> createState() =>
//       _AddCommissionFormWidgetState();
// }

// class _AddCommissionFormWidgetState extends State<AddCommissionFormWidget> {
//   final _formKey = GlobalKey<FormState>();

//   bool _loading = true;
//   List<EmployeeModel> _employees = [];
//   String? _selectedEmployeeId;

//   bool _useAmount = true;
//   final TextEditingController _valueCtrl = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadEmployees();
//   }

//   Future<void> _loadEmployees() async {
//     try {
//       final list = await DataFetchService.fetchEmployees();
//       // Prefill if editing
//       final init = widget.initial;
//       if (init != null) {
//         _selectedEmployeeId = init.employeeId;
//         _useAmount = init.isAmount;
//         _valueCtrl.text = init.value.toString();
//       }
//       setState(() {
//         _employees = list;
//         _loading = false;
//       });
//     } catch (_) {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _toggleAmount(bool v) {
//     if (v) setState(() => _useAmount = true);
//   }

//   void _togglePercent(bool v) {
//     if (v) setState(() => _useAmount = false);
//   }

//   String? _validateValue(String? v) {
//     final txt = (v ?? '').trim();
//     if (txt.isEmpty) return 'Required';
//     final parsed = double.tryParse(txt);
//     if (parsed == null || parsed <= 0) return 'Enter valid number';
//     if (!_useAmount && parsed > 100) return 'Percentage must be ≤ 100';
//     return null;
//   }

//   void _onCancel() => Navigator.pop(context, null);

//   void _onSave() {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedEmployeeId == null || _selectedEmployeeId!.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please select employee')));
//       return;
//     }

//     final val = double.parse(_valueCtrl.text.trim());
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     final existing = widget.initial;

//     final model = EmployeeCommissionModel(
//       id: existing?.id,
//       employeeId: _selectedEmployeeId!,
//       isAmount: _useAmount,
//       value: val,
//       userId: existing?.userId ?? currentUserId,
//       createdAt: existing?.createdAt ?? Timestamp.now(),
//       bookingId: existing?.bookingId,
//     );

//     Navigator.pop(context, model);
//   }

//   @override
//   void dispose() {
//     _valueCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.initial != null;

//     return OverlayLoader(
//       loader: _loading,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 560, minWidth: 480),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               16.h,
//               AlertDialogHeader(
//                 title: isEdit ? 'Edit Commission' : 'Add Commission',
//               ),
//               const Divider(),

//               // Employee dropdown
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: CustomSearchableDropdown(
//                   hintText: 'Choose Employee',
//                   value: _selectedEmployeeId,
//                   items: {for (var e in _employees) e.id!: e.name},
//                   onChanged: (val) => setState(() => _selectedEmployeeId = val),
//                 ),
//               ),
//               12.h,
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CheckboxListTile(
//                         contentPadding: EdgeInsets.zero,
//                         dense: true,
//                         title: const Text('Amount'),
//                         value: _useAmount,
//                         onChanged: (v) {
//                           if (v == true) _toggleAmount(true);
//                         },
//                       ),
//                     ),
//                     8.w,
//                     Expanded(
//                       child: CheckboxListTile(
//                         contentPadding: EdgeInsets.zero,
//                         dense: true,
//                         title: const Text('Percentage'),
//                         value: !_useAmount,
//                         onChanged: (v) {
//                           if (v == true) _togglePercent(true);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: CustomMmTextField(
//                   labelText: _useAmount ? 'Amount' : 'Percentage',
//                   hintText: _useAmount ? 'Enter amount' : 'Enter percentage',
//                   controller: _valueCtrl,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: _validateValue,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                     signed: false,
//                   ),
//                   inputFormatter: [
//                     FilteringTextInputFormatter.allow(
//                       RegExp(r'^\d*\.?\d{0,2}'),
//                     ),
//                   ],
//                 ),
//               ),

//               22.h,
//               AlertDialogBottomWidget(
//                 title: isEdit ? 'Save' : 'Create',
//                 onCancel: _onCancel,
//                 onCreate: _onSave,
//                 loadingNotifier: null,
//               ),
//               22.h,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
