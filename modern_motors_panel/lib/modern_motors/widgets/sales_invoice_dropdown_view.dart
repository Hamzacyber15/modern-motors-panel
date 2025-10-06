// import 'dart:typed_data';

// import 'package:app/models/template_model/template1_model.dart';
// import 'package:app/models/template_model/template2_model.dart';
// import 'package:app/modern_motors/invoices/estimation_invoice.dart';
// import 'package:app/modern_motors/invoices/maintanance_template1.dart';
// import 'package:app/modern_motors/invoices/maintanance_template2.dart';

// import 'package:app/modern_motors/invoices/template_1.dart';
// import 'package:app/modern_motors/invoices/template_5.dart';
// import 'package:app/modern_motors/sales/sales_model.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/mmLoading_widget.dart';
// import 'package:app/modern_motors/widgets/qr_code_generator.dart';
// import 'package:app/modern_motors/widgets/retail_layout.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class SalesInvoiceDropdownView extends StatefulWidget {
//   final SaleModel sale;
//   const SalesInvoiceDropdownView({required this.sale, super.key});

//   @override
//   State<SalesInvoiceDropdownView> createState() =>
//       _SalesInvoiceDropdownViewState();
// }

// class _SalesInvoiceDropdownViewState extends State<SalesInvoiceDropdownView> {
//   int selectedTemplateIndex = 0;
//   Template2Model? template2Model;
//   Template1Model? template1Model;
//   bool loading = false;

//   @override
//   initState() {
//     super.initState();
//     getData();
//   }

//   void getData() async {
//     setState(() {
//       loading = true;
//     });
//     Uint8List qrBytes = await generateQrCodeBytes(
//       widget.sale.invoice.toString(),
//     );

//     //template2Model
//     template1Model = Template1Model(
//       salesDetails: widget.sale,
//       qrBytes: qrBytes,
//     );
//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: loading
//           ? MmloadingWidget()
//           : Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   //16.w,
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 16.0),
//                   //   child: SizedBox(
//                   //     height: context.height * 0.062,
//                   //     width: context.height * 0.065,
//                   //     child: CustomButton(
//                   //       onPressed: () async {
//                   //         await _loadBookings();
//                   //         setState(() {
//                   //           showMaintenanceList = true;
//                   //           bookingBeingEdited = null;
//                   //           template1Model = Template1Model();
//                   //           isPDfView = false;
//                   //         });
//                   //       },
//                   //       iconAsset: 'assets/icons/back.png',
//                   //       buttonType: ButtonType.iconOnly,
//                   //       borderColor: AppTheme.borderColor,
//                   //       backgroundColor: AppTheme.whiteColor,
//                   //       iconSize: 20,
//                   //     ),
//                   //   ),
//                   // ),
//                   // 20.w,
//                   SizedBox(
//                     width: 250,
//                     child:
//                         // DropdownButton<int>(
//                         //   value: selectedTemplateIndex,
//                         //   items: [
//                         //     DropdownMenuItem(
//                         //         value: 0, child: Text("Template 1".tr())),
//                         //     DropdownMenuItem(
//                         //         value: 1, child: Text("Template 2".tr())),
//                         //   ],
//                         //   onChanged: (int? value) {
//                         //     if (value != null) {
//                         //       setState(() {
//                         //         selectedTemplateIndex = value;
//                         //       });
//                         //     }
//                         //   },
//                         // ),
//                         DropdownButton<int>(
//                       value: selectedTemplateIndex,
//                       items: [
//                         DropdownMenuItem(
//                             value: 0, child: Text("Retail Layout".tr())),
//                         DropdownMenuItem(
//                             value: 1, child: Text("Template 1".tr())),
//                         DropdownMenuItem(
//                             value: 2, child: Text("Template 5".tr())),
//                         DropdownMenuItem(
//                           value: 3,
//                           child: Text("Maintenance Template 1".tr()),
//                         ),
//                         DropdownMenuItem(
//                           value: 4,
//                           child: Text("Maintenance Template 2".tr()),
//                         ),
//                         DropdownMenuItem(
//                             value: 5, child: Text("Estimation".tr())),
//                       ],
//                       onChanged: (int? value) {
//                         if (value != null) {
//                           setState(() {
//                             selectedTemplateIndex = value;
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                   16.w,

//                   if (selectedTemplateIndex == 0)
//                     RetailLayout(template1Model: template1Model!)
//                   else if (selectedTemplateIndex == 1)
//                     Template1(template1Model: template1Model!)
//                   else if (selectedTemplateIndex == 2)
//                     Template5(template1Model: template1Model!)
//                   else if (selectedTemplateIndex == 3)
//                     // MaintenanceTemplate1(template1Model: template1Model!)
//                     MaintenanceTemplate2(template1Model: template1Model!)
//                   else if (selectedTemplateIndex == 4)
//                     MaintenanceTemplate2(template1Model: template1Model!)
//                   else
//                     SizedBox(
//                       width: context.width * 0.5,
//                       child: EstimationInvoice(template1Model: template1Model!),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// class SalesInvoiceDropdownView extends StatefulWidget {
//   final SaleModel sale;
//   final String? type;
//   const SalesInvoiceDropdownView({required this.sale, this.type, super.key});

//   @override
//   State<SalesInvoiceDropdownView> createState() =>
//       _SalesInvoiceDropdownViewState();
// }

// class _SalesInvoiceDropdownViewState extends State<SalesInvoiceDropdownView> {
//   int selectedTemplateIndex = 0;
//   Template2Model? template2Model;
//   Template1Model? template1Model;
//   bool loading = false;

//   @override
//   initState() {
//     super.initState();
//     getData();
//   }

//   void getData() async {
//     setState(() {
//       loading = true;
//     });
//     Uint8List qrBytes = await generateQrCodeBytes(
//       widget.sale.invoice.toString(),
//     );

//     template1Model = Template1Model(
//       salesDetails: widget.sale,
//       qrBytes: qrBytes,
//     );
//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Invoice ${widget.sale.invoice}',
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1E293B),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: loading
//           ? const MmloadingWidget()
//           : Column(
//               children: [
//                 if (widget.type == "sale") _buildActionBar(),
//                 _buildTemplateSelector(),
//                 Expanded(child: _buildInvoiceContent()),
//               ],
//             ),
//     );
//   }

//   Widget _buildActionBar() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.receipt_long,
//             color: Color(0xFF475569),
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           const Text(
//             'Invoice Actions',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           const Spacer(),
//           Row(
//             children: [
//               _buildActionButton(
//                 icon: Icons.edit_outlined,
//                 label: 'Edit',
//                 color: const Color(0xFF3B82F6),
//                 onPressed: _onEditPressed,
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(
//                 icon: Icons.payment_outlined,
//                 label: 'Add Payment',
//                 color: const Color(0xFF059669),
//                 onPressed: _onAddPaymentPressed,
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(
//                 icon: Icons.money_off_outlined,
//                 label: 'Refund',
//                 color: const Color(0xFFDC2626),
//                 onPressed: _onRefundPressed,
//               ),
//               const SizedBox(width: 8),
//               _buildSendViaButton(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(8),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: color.withOpacity(0.2)),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 16, color: color),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSendViaButton() {
//     return PopupMenuButton<String>(
//       onSelected: _onSendViaSelected,
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           value: 'email',
//           child: Row(
//             children: [
//               const Icon(Icons.email_outlined,
//                   size: 16, color: Color(0xFF475569)),
//               const SizedBox(width: 8),
//               Text('Email'.tr()),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//           value: 'whatsapp',
//           child: Row(
//             children: [
//               const Icon(Icons.message_outlined,
//                   size: 16, color: Color(0xFF059669)),
//               const SizedBox(width: 8),
//               Text('WhatsApp'.tr()),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//           value: 'sms',
//           child: Row(
//             children: [
//               const Icon(Icons.sms_outlined,
//                   size: 16, color: Color(0xFF3B82F6)),
//               const SizedBox(width: 8),
//               Text('SMS'.tr()),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//           value: 'print',
//           child: Row(
//             children: [
//               const Icon(Icons.print_outlined,
//                   size: 16, color: Color(0xFF6B7280)),
//               const SizedBox(width: 8),
//               Text('Print'.tr()),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//           value: 'download',
//           child: Row(
//             children: [
//               const Icon(Icons.download_outlined,
//                   size: 16, color: Color(0xFF8B5CF6)),
//               const SizedBox(width: 8),
//               Text('Download PDF'.tr()),
//             ],
//           ),
//         ),
//       ],
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: const Color(0xFF8B5CF6).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.2)),
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.send_outlined, size: 16, color: Color(0xFF8B5CF6)),
//             SizedBox(width: 6),
//             Text(
//               'Send Via',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF8B5CF6),
//               ),
//             ),
//             SizedBox(width: 4),
//             Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF8B5CF6)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTemplateSelector() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.design_services_outlined,
//             color: Color(0xFF475569),
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           const Text(
//             'Template',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF1F5F9),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: const Color(0xFFE2E8F0)),
//               ),
//               child: DropdownButton<int>(
//                 value: selectedTemplateIndex,
//                 isExpanded: true,
//                 underline: const SizedBox(),
//                 items: [
//                   DropdownMenuItem(
//                     value: 0,
//                     child: Text("Retail Layout".tr()),
//                   ),
//                   DropdownMenuItem(
//                     value: 1,
//                     child: Text("Template 1".tr()),
//                   ),
//                   DropdownMenuItem(
//                     value: 2,
//                     child: Text("Template 5".tr()),
//                   ),
//                   DropdownMenuItem(
//                     value: 3,
//                     child: Text("Maintenance Template 1".tr()),
//                   ),
//                   DropdownMenuItem(
//                     value: 4,
//                     child: Text("Maintenance Template 2".tr()),
//                   ),
//                   DropdownMenuItem(
//                     value: 5,
//                     child: Text("Estimation".tr()),
//                   ),
//                 ],
//                 onChanged: (int? value) {
//                   if (value != null) {
//                     setState(() {
//                       selectedTemplateIndex = value;
//                     });
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInvoiceContent() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: _getSelectedTemplate(),
//       ),
//     );
//   }

//   Widget _getSelectedTemplate() {
//     if (template1Model == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     switch (selectedTemplateIndex) {
//       case 0:
//         return RetailLayout(template1Model: template1Model!);
//       case 1:
//         return Template1(template1Model: template1Model!);
//       case 2:
//         return Template5(template1Model: template1Model!);
//       case 3:
//         return MaintenanceTemplate1(template1Model: template1Model!);
//       case 4:
//         return MaintenanceTemplate2(template1Model: template1Model!);
//       case 5:
//         return SizedBox(
//           width: context.width * 0.5,
//           child: EstimationInvoice(template1Model: template1Model!),
//         );
//       default:
//         return RetailLayout(template1Model: template1Model!);
//     }
//   }

//   // Action handlers
//   void _onEditPressed() {
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
//       return CreateBookingMainPage(
//         sale: widget.sale,
//         tapped: () {},
//       );
//     }));
//   }

//   void _onAddPaymentPressed() {
//     // Show add payment dialog
//     _showAddPaymentDialog();
//   }

//   void _onRefundPressed() {
//     // Show refund dialog
//     _showRefundDialog();
//   }

//   void _onSendViaSelected(String option) {
//     switch (option) {
//       case 'email':
//         _sendViaEmail();
//         break;
//       case 'whatsapp':
//         _sendViaWhatsApp();
//         break;
//       case 'sms':
//         _sendViaSMS();
//         break;
//       case 'print':
//         _printInvoice();
//         break;
//       case 'download':
//         _downloadPDF();
//         break;
//     }
//   }

//   void _showAddPaymentDialog() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => PaymentPage(
//           sale: widget.sale,
//         ),
//       ),
//     );
//     // showDialog(
//     //   context: context,
//     //   builder: (context) => AlertDialog(
//     //     title: Text('Add Payment'.tr()),
//     //     content: Column(
//     //       mainAxisSize: MainAxisSize.min,
//     //       children: [
//     //         TextFormField(
//     //           decoration: InputDecoration(
//     //             labelText: 'Payment Amount'.tr(),
//     //             prefixText: 'OMR ',
//     //             border: const OutlineInputBorder(),
//     //           ),
//     //           keyboardType:
//     //               const TextInputType.numberWithOptions(decimal: true),
//     //         ),
//     //         const SizedBox(height: 16),
//     //         DropdownButtonFormField<String>(
//     //           decoration: InputDecoration(
//     //             labelText: 'Payment Method'.tr(),
//     //             border: const OutlineInputBorder(),
//     //           ),
//     //           items: [
//     //             DropdownMenuItem(value: 'cash', child: Text('Cash'.tr())),
//     //             DropdownMenuItem(value: 'card', child: Text('Card'.tr())),
//     //             DropdownMenuItem(
//     //                 value: 'bank', child: Text('Bank Transfer'.tr())),
//     //           ],
//     //           onChanged: (value) {},
//     //         ),
//     //       ],
//     //     ),
//     //     actions: [
//     //       TextButton(
//     //         onPressed: () => Navigator.pop(context),
//     //         child: Text('Cancel'.tr()),
//     //       ),
//     //       ElevatedButton(
//     //         onPressed: () {
//     //           Navigator.pop(context);
//     //           ScaffoldMessenger.of(context).showSnackBar(
//     //             SnackBar(
//     //               content: Text('Payment added successfully'.tr()),
//     //               backgroundColor: const Color(0xFF059669),
//     //               behavior: SnackBarBehavior.floating,
//     //             ),
//     //           );
//     //         },
//     //         child: Text('Add Payment'.tr()),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }

//   void _showRefundDialog() {
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//       return CreateBookingMainPage(
//         type: "refund",
//         sale: widget.sale,
//         tapped: () {},
//       );
//     }));
//   }

//   void _sendViaEmail() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Sending invoice via email...'.tr()),
//         backgroundColor: const Color(0xFF475569),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _sendViaWhatsApp() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Sending invoice via WhatsApp...'.tr()),
//         backgroundColor: const Color(0xFF059669),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _sendViaSMS() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Sending invoice via SMS...'.tr()),
//         backgroundColor: const Color(0xFF3B82F6),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _printInvoice() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Printing invoice...'.tr()),
//         backgroundColor: const Color(0xFF6B7280),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _downloadPDF() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Downloading PDF...'.tr()),
//         backgroundColor: const Color(0xFF8B5CF6),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/model/template_model/template2_model.dart';
import 'package:modern_motors_panel/modern_motors/invoices/estimation_invoice.dart';
import 'package:modern_motors_panel/modern_motors/invoices/maintanance_template1.dart';
import 'package:modern_motors_panel/modern_motors/invoices/maintanance_template2.dart';
import 'package:modern_motors_panel/modern_motors/invoices/template_1.dart';
import 'package:modern_motors_panel/modern_motors/invoices/template_5.dart';
import 'package:modern_motors_panel/modern_motors/sales/sale_payment_page.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/create_booking_main_page.dart';
import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/qr_code_generator.dart';
import 'package:modern_motors_panel/modern_motors/widgets/retail_layout.dart';

class SalesInvoiceDropdownView extends StatefulWidget {
  final SaleModel sale;
  final String? type;
  const SalesInvoiceDropdownView({required this.sale, this.type, super.key});

  @override
  State<SalesInvoiceDropdownView> createState() =>
      _SalesInvoiceDropdownViewState();
}

class _SalesInvoiceDropdownViewState extends State<SalesInvoiceDropdownView> {
  int selectedTemplateIndex = 0;
  Template2Model? template2Model;
  Template1Model? template1Model;
  bool loading = false;

  @override
  initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      loading = true;
    });
    Uint8List qrBytes = await generateQrCodeBytes(
      widget.sale.invoice.toString(),
    );

    template1Model = Template1Model(
      salesDetails: widget.sale,
      qrBytes: qrBytes,
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Invoice ${widget.sale.invoice}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.type == "sale"
            ? [_buildActionsDropdown(), const SizedBox(width: 16)]
            : null,
      ),
      body: loading
          ? const MmloadingWidget()
          : Column(
              children: [
                _buildTemplateSelector(),
                Expanded(child: _buildInvoiceContent()),
              ],
            ),
    );
  }

  Widget _buildActionsDropdown() {
    return PopupMenuButton<String>(
      onSelected: _onActionSelected,
      tooltip: 'Invoice Actions',
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_vert, size: 18, color: Color(0xFF3B82F6)),
            SizedBox(width: 4),
            Text(
              'Actions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: _buildPopupMenuItem(
            icon: Icons.edit_outlined,
            label: 'Edit'.tr(),
            color: const Color(0xFF3B82F6),
          ),
        ),
        PopupMenuItem(
          value: 'add_payment',
          child: _buildPopupMenuItem(
            icon: Icons.payment_outlined,
            label: 'Add Payment'.tr(),
            color: const Color(0xFF059669),
          ),
        ),
        PopupMenuItem(
          value: 'refund',
          child: _buildPopupMenuItem(
            icon: Icons.money_off_outlined,
            label: 'Refund'.tr(),
            color: const Color(0xFFDC2626),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'email',
          child: _buildPopupMenuItem(
            icon: Icons.email_outlined,
            label: 'Send via Email'.tr(),
            color: const Color(0xFF475569),
          ),
        ),
        PopupMenuItem(
          value: 'whatsapp',
          child: _buildPopupMenuItem(
            icon: Icons.message_outlined,
            label: 'Send via WhatsApp'.tr(),
            color: const Color(0xFF059669),
          ),
        ),
        PopupMenuItem(
          value: 'sms',
          child: _buildPopupMenuItem(
            icon: Icons.sms_outlined,
            label: 'Send via SMS'.tr(),
            color: const Color(0xFF3B82F6),
          ),
        ),
        PopupMenuItem(
          value: 'print',
          child: _buildPopupMenuItem(
            icon: Icons.print_outlined,
            label: 'Print'.tr(),
            color: const Color(0xFF6B7280),
          ),
        ),
        PopupMenuItem(
          value: 'download',
          child: _buildPopupMenuItem(
            icon: Icons.download_outlined,
            label: 'Download PDF'.tr(),
            color: const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenuItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.design_services_outlined,
            color: Color(0xFF475569),
            size: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            'Template',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButton<int>(
                value: selectedTemplateIndex,
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(value: 0, child: Text("Retail Layout".tr())),
                  DropdownMenuItem(value: 1, child: Text("Template 1".tr())),
                  DropdownMenuItem(value: 2, child: Text("Template 5".tr())),
                  DropdownMenuItem(
                    value: 3,
                    child: Text("Maintenance Template 1".tr()),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text("Maintenance Template 2".tr()),
                  ),
                  DropdownMenuItem(value: 5, child: Text("Estimation".tr())),
                ],
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      selectedTemplateIndex = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _getSelectedTemplate(),
      ),
    );
  }

  Widget _getSelectedTemplate() {
    if (template1Model == null) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (selectedTemplateIndex) {
      case 0:
        return RetailLayout(template1Model: template1Model!);
      case 1:
        return Template1(template1Model: template1Model!);
      case 2:
        return Template5(template1Model: template1Model!);
      case 3:
        return MaintenanceTemplate1(template1Model: template1Model!);
      case 4:
        return MaintenanceTemplate2(template1Model: template1Model!);
      case 5:
        return SizedBox(
          width: context.width * 0.5,
          child: EstimationInvoice(template1Model: template1Model!),
        );
      default:
        return RetailLayout(template1Model: template1Model!);
    }
  }

  // Action handlers
  void _onActionSelected(String action) {
    switch (action) {
      case 'edit':
        _onEditPressed();
        break;
      case 'add_payment':
        _onAddPaymentPressed();
        break;
      case 'refund':
        _onRefundPressed();
        break;
      case 'email':
        _sendViaEmail();
        break;
      case 'whatsapp':
        _sendViaWhatsApp();
        break;
      case 'sms':
        _sendViaSMS();
        break;
      case 'print':
        _printInvoice();
        break;
      case 'download':
        _downloadPDF();
        break;
    }
  }

  void _onEditPressed() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return CreateBookingMainPage(sale: widget.sale, tapped: () {});
        },
      ),
    );
  }

  void _onAddPaymentPressed() {
    _showAddPaymentDialog();
  }

  void _onRefundPressed() {
    _showRefundDialog();
  }

  void _showAddPaymentDialog() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PaymentPage(sale: widget.sale)),
    );
  }

  void _showRefundDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return CreateBookingMainPage(
            type: "refund",
            sale: widget.sale,
            tapped: () {},
          );
        },
      ),
    );
  }

  void _sendViaEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending invoice via email...'.tr()),
        backgroundColor: const Color(0xFF475569),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendViaWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending invoice via WhatsApp...'.tr()),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendViaSMS() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending invoice via SMS...'.tr()),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _printInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Printing invoice...'.tr()),
        backgroundColor: const Color(0xFF6B7280),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _downloadPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading PDF...'.tr()),
        backgroundColor: const Color(0xFF8B5CF6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
