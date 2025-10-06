import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/fancy_tight_divider.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_amount_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_dotted_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class RetailLayout extends StatefulWidget {
  final Template1Model template1Model;

  const RetailLayout({required this.template1Model, super.key});

  @override
  State<RetailLayout> createState() => _RetailLayoutState();
}

class _RetailLayoutState extends State<RetailLayout> {
  bool loading = false;
  late Future<void> _initializationFuture;
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  late EmployeeModel? salesPerson;
  late double vatCharge;
  late double discountAmount;
  late double total;
  late double subTotal;
  late double itemTotal;
  late double paid;
  late CustomerModel customer;

  @override
  void initState() {
    _initializationFuture = _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    try {
      await _loadAndCalculateData();
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  Future<void> _loadAndCalculateData() async {
    final provider = context.read<MmResourceProvider>();
    _calculateAmounts();
    if (widget.template1Model.salesDetails!.createBy == Constants.adminId) {
      salesPerson = EmployeeModel.getEmptyEmployee();
      salesPerson!.name = "Admin";
    } else {
      salesPerson = provider.getEmployeeByID(
        widget.template1Model.salesDetails!.createBy,
      );
    }

    customer = provider.customersList.firstWhere(
      (item) => item.id == widget.template1Model.salesDetails!.customerName,
    );

    estimationTemplatePreviewModel = provider.estimationTemplatePreviewModel
        .firstWhere((tem) => tem.type == 'Retail');
  }

  void _calculateAmounts() {
    final sale = widget.template1Model.salesDetails;
    vatCharge = sale!.taxAmount;
    total = sale.total ?? 0;
    subTotal = sale.totalRevenue - sale.taxAmount;
    paid = widget.template1Model.salesDetails!.remaining - total;
    itemTotal = sale.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    discountAmount = sale.discount;
  }

  Future<Uint8List> createPDF() async {
    final pw.Font regular = await PdfGoogleFonts.nunitoMedium();
    final pw.Font bold = await PdfGoogleFonts.nunitoBold();

    final img = await rootBundle.load('assets/images/mm_logo.png');

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        // theme: pw.ThemeData.withFont(base: testFont, bold: testFont),
        theme: pw.ThemeData.withFont(
          base: regular,
          bold: bold,
        ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 1)),
        margin: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        build: (ctx) => contentBody(ctx, img),

        // build: (ctx) => pw.Transform.scale(
        //   scale: 0.85, // Smaller = zoom out (default is 1.0)
        //   child: contentBody(ctx, img),
        // ),
      ),
    );

    return pdf.save();
  }

  pw.Widget contentHeader(pw.Context ctx) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Text(
              'Page ${ctx.pageNumber}/${ctx.pagesCount}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.Divider(),
      ],
    );
  }

  pw.Widget contentBody(pw.Context ctx, ByteData logoBytes) {
    final image = pw.MemoryImage(logoBytes.buffer.asUint8List());
    // final invoice = widget.template1Model.invoiceModel!;
    // final customer = widget.template1Model.customerModel!;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pdfDottedWidget(
              height: 80,
              width: 120,
              child: pw.Image(image, width: 100, height: 100),
            ),
            pw.Column(
              children: [
                pdfTextWidget(
                  text: 'Invoice',
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                pdfTextWidget(
                  text: '#${widget.template1Model.salesDetails!.invoice}',
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 6),

        /// Company Info
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pdfTextWidget(
              text:
                  estimationTemplatePreviewModel?.companyDetails.companyName ??
                  'MODERN HANDS SILVER',
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            pdfTextWidget(
              text:
                  'TAX ID: ${estimationTemplatePreviewModel?.companyDetails.taxId ?? "NILL"}',
              fontSize: 10,
            ),
            pdfTextWidget(
              text:
                  estimationTemplatePreviewModel
                      ?.companyDetails
                      .companyAddress ??
                  'BARKA SULTANTE OF OMAN',
              fontSize: 10,
            ),
            pdfTextWidget(
              text:
                  'VAT NO. ${estimationTemplatePreviewModel?.companyDetails.vatNo ?? 'OM1100306983'}',
              fontSize: 10,
            ),
            pdfTextWidget(
              text:
                  estimationTemplatePreviewModel
                      ?.companyDetails
                      .companyContact1 ??
                  '92478551',
              fontSize: 10,
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Divider(),
        pw.SizedBox(height: 6),
        pdfTextWidget(
          text:
              "Date & Time: ${widget.template1Model.salesDetails!.createdAt.formattedWithDayMonthYear} - ${widget.template1Model.salesDetails!.createdAt.justTime}",
          fontSize: 10,
        ),
        pdfTextWidget(
          text: "Cashier: ${salesPerson?.emergencyName ?? 'N/A'}",
          fontSize: 10,
        ),
        pdfTextWidget(text: "Bill To: ${customer.customerName}", fontSize: 10),
        if (customer.customerType == 'business')
          pdfTextWidget(text: customer.businessName ?? '', fontSize: 10),
        pdfTextWidget(text: customer.contactNumber, fontSize: 10),
        pdfTextWidget(
          text: "${customer.streetAddress1}, ${customer.streetAddress2}",
          fontSize: 10,
        ),
        pdfTextWidget(
          text: "${customer.city}, ${customer.state}, ${customer.postalCode}",
          fontSize: 10,
        ),
        pw.SizedBox(height: 14),
        fancyTightDivider(),

        pw.SizedBox(height: 14),

        pdfTextInRowWidgetTem5(
          context: context,
          text1: "Total".tr(),
          text2: "${total.toStringAsFixed(2)} OMR",
          isFromRetailLayout: true,
        ),
        pw.SizedBox(height: 2),
        pdfTextInRowWidgetTem5(
          context: context,
          text1: "Paid".tr(),
          text2: paid.toStringAsFixed(2),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 6),
        pdfTextInRowWidgetTem5(
          context: context,
          text1: "Total".tr(),
          text2: total.toStringAsFixed(2),
          isFromRetailLayout: true,
        ),

        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Image(
            pw.MemoryImage(widget.template1Model.qrBytes!), // ✅ wrap it
            width: 60,
            height: 60,
          ),
        ),

        pw.SizedBox(height: 10),
        pw.Center(
          child: pdfTextWidget(
            text: "******** THANKS FOR YOUR VISIT! ********",
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return InteractiveViewer(
          scaleFactor: 0.3,
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1,
          maxScale: 3,
          child: SizedBox(
            height: double.infinity,
            width: PdfPageFormat.inch * 5,
            child: PdfPreview(
              loadingWidget: const CircularProgressIndicator(),
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowSharing: true,
              build: (format) => createPDF(),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:app/constants.dart';
// import 'package:app/models/employee_model.dart';
// import 'package:app/models/template_model/template1_model.dart';
// import 'package:app/modern_motors/models/bank_detail.dart';
// import 'package:app/modern_motors/models/customer/customer_model.dart';
// import 'package:app/modern_motors/provider/mm_resource_provider.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/pdf_text_widget.dart';
// import 'package:app/modern_motors/widgets/pdf_widget.dart/fancy_tight_divider.dart';
// import 'package:app/modern_motors/widgets/pdf_widget.dart/pdf_amount_widget.dart';
// import 'package:app/modern_motors/widgets/pdf_widget.dart/pdf_dotted_widget.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:provider/provider.dart';

// class RetailLayout extends StatefulWidget {
//   final Template1Model template1Model;

//   const RetailLayout({required this.template1Model, super.key});

//   @override
//   State<RetailLayout> createState() => _RetailLayoutState();
// }

// class _RetailLayoutState extends State<RetailLayout> {
//   bool loading = false;
//   late Future<void> _initializationFuture;
//   EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
//   late EmployeeModel? salesPerson;
//   late double vatCharge;
//   late double discountAmount;
//   late double total;
//   late double subTotal;
//   late double itemTotal;
//   late double paid;
//   late CustomerModel customer;

//   // Caching variables
//   Uint8List? _cachedPdfBytes;
//   Future<Uint8List>? _pdfFuture;
//   late Future<pw.Font> _regularFontFuture;
//   late Future<pw.Font> _boldFontFuture;
//   late Future<ByteData> _logoFuture;
//   Map<String, dynamic>? _calculatedData;

//   @override
//   void initState() {
//     // Pre-load assets
//     _regularFontFuture = PdfGoogleFonts.nunitoMedium();
//     _boldFontFuture = PdfGoogleFonts.nunitoBold();
//     _logoFuture = rootBundle.load('assets/images/mm_logo.png');

//     _initializationFuture = _initializeData();
//     super.initState();
//   }

//   Future<void> _initializeData() async {
//     try {
//       await _loadAndCalculateData();
//       // Pre-load PDF after data is ready
//       _pdfFuture = _createPDF();
//       _cachedPdfBytes = await _pdfFuture;
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//     }
//   }

//   Future<void> _loadAndCalculateData() async {
//     final provider = context.read<MmResourceProvider>();
//     _calculateAndCacheAmounts();
// c

//     customer = provider.customersList.firstWhere(
//       (item) => item.id == widget.template1Model.salesDetails!.customerName,
//     );

//     estimationTemplatePreviewModel = provider.estimationTemplatePreviewModel
//         .firstWhere((tem) => tem.type == 'Retail');
//   }

//   void _calculateAndCacheAmounts() {
//     if (_calculatedData != null) return;

//     final sale = widget.template1Model.salesDetails!;
//     _calculatedData = {
//       'vatCharge': sale.taxAmount,
//       'total': sale.total ?? 0,
//       'subTotal': sale.totalRevenue - sale.taxAmount,
//       'paid': widget.template1Model.salesDetails!.paymentData.totalPaid,
//       // sale.paymentData.totalPaid.toStringAsFixed(2),
//       // widget.template1Model.salesDetails!.remaining - (sale.total ?? 0),
//       'itemTotal':
//           sale.items.fold<double>(0, (sum, item) => sum + item.totalPrice),
//       'discountAmount': sale.discount,
//     };

//     vatCharge = _calculatedData!['vatCharge'];
//     total = _calculatedData!['total'];
//     subTotal = _calculatedData!['subTotal'];
//     paid = _calculatedData!['paid'];
//     itemTotal = _calculatedData!['itemTotal'];
//     discountAmount = _calculatedData!['discountAmount'];
//   }

//   Future<Uint8List> _createPDF() async {
//     final pw.Font regular = await _regularFontFuture;
//     final pw.Font bold = await _boldFontFuture;
//     final img = await _logoFuture;

//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.roll80,
//         theme: pw.ThemeData.withFont(
//           base: regular,
//           bold: bold,
//         ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 1)),
//         margin: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         build: (ctx) => contentBody(ctx, img),
//       ),
//     );

//     return pdf.save();
//   }

//   pw.Widget contentHeader(pw.Context ctx) {
//     return pw.Column(
//       children: [
//         pw.Row(
//           children: [
//             pw.Text(
//               'Page ${ctx.pageNumber}/${ctx.pagesCount}',
//               style: const pw.TextStyle(fontSize: 10),
//             ),
//           ],
//         ),
//         pw.Divider(),
//       ],
//     );
//   }

//   pw.Widget contentBody(pw.Context ctx, ByteData logoBytes) {
//     final image = pw.MemoryImage(logoBytes.buffer.asUint8List());

//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pdfDottedWidget(
//               height: 80,
//               width: 120,
//               child: pw.Image(image, width: 100, height: 100),
//             ),
//             pw.Column(
//               children: [
//                 pdfTextWidget(
//                   text: 'Invoice',
//                   fontSize: 12,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//                 pdfTextWidget(
//                   text: '#${widget.template1Model.salesDetails!.invoice}',
//                   fontSize: 10,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 6),

//         /// Company Info
//         pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pdfTextWidget(
//               text:
//                   estimationTemplatePreviewModel?.companyDetails.companyName ??
//                       'MODERN HANDS SILVER',
//               fontWeight: pw.FontWeight.bold,
//               fontSize: 12,
//             ),
//             pdfTextWidget(
//               text:
//                   'TAX ID: ${estimationTemplatePreviewModel?.companyDetails.taxId ?? "NILL"}',
//               fontSize: 10,
//             ),
//             pdfTextWidget(
//               text: estimationTemplatePreviewModel
//                       ?.companyDetails.companyAddress ??
//                   'BARKA SULTANTE OF OMAN',
//               fontSize: 10,
//             ),
//             pdfTextWidget(
//               text: 'VAT NO. ${'OM1100306983'}',
//               fontSize: 10,
//             ),
//             pdfTextWidget(
//               text: estimationTemplatePreviewModel
//                       ?.companyDetails.companyContact1 ??
//                   '92478551',
//               fontSize: 10,
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 6),
//         pw.Divider(),
//         pw.SizedBox(height: 6),
//         pdfTextWidget(
//           text:
//               "Date & Time: ${widget.template1Model.salesDetails!.createdAt.formattedWithDayMonthYear} - ${widget.template1Model.salesDetails!.createdAt.justTime}",
//           fontSize: 10,
//         ),
//         pdfTextWidget(
//           text: "Cashier: ${salesPerson?.name ?? 'N/A'}",
//           fontSize: 10,
//         ),
//         pdfTextWidget(text: "Bill To: ${customer.customerName}", fontSize: 10),
//         if (customer.customerType == 'business')
//           pdfTextWidget(text: customer.businessName ?? '', fontSize: 10),
//         pdfTextWidget(text: customer.contactNumber, fontSize: 10),
//         pdfTextWidget(
//           text: "${customer.streetAddress1}, ${customer.streetAddress2}",
//           fontSize: 10,
//         ),
//         pdfTextWidget(
//           text: "${customer.city}, ${customer.state}, ${customer.postalCode}",
//           fontSize: 10,
//         ),
//         pw.SizedBox(height: 14),
//         fancyTightDivider(),

//         pw.SizedBox(height: 14),

//         pdfTextInRowWidgetTem5(
//           context: context,
//           text1: "Total".tr(),
//           text2: "${total.toStringAsFixed(2)} OMR",
//           isFromRetailLayout: true,
//         ),
//         pw.SizedBox(height: 2),
//         pdfTextInRowWidgetTem5(
//           context: context,
//           text1: "Paid".tr(),
//           text2: paid.toStringAsFixed(2),
//         ),
//         pw.SizedBox(height: 10),
//         pw.Divider(),
//         pw.SizedBox(height: 6),
//         pdfTextInRowWidgetTem5(
//           context: context,
//           text1: "Total".tr(),
//           text2: total.toStringAsFixed(2),
//           isFromRetailLayout: true,
//         ),

//         pw.SizedBox(height: 20),
//         pw.Center(
//           child: pw.Image(
//             pw.MemoryImage(widget.template1Model.qrBytes!),
//             width: 60,
//             height: 60,
//           ),
//         ),

//         pw.SizedBox(height: 10),
//         pw.Center(
//           child: pdfTextWidget(
//             text: "******** THANKS FOR YOUR VISIT! ********",
//             fontSize: 10,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializationFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         return InteractiveViewer(
//           scaleFactor: 0.3,
//           panEnabled: true,
//           scaleEnabled: true,
//           minScale: 1,
//           maxScale: 3,
//           child: SizedBox(
//             height: double.infinity,
//             width: PdfPageFormat.inch * 5,
//             child: _cachedPdfBytes != null
//                 ? PdfPreview(
//                     loadingWidget: const CircularProgressIndicator(),
//                     canChangeOrientation: false,
//                     canChangePageFormat: false,
//                     canDebug: false,
//                     allowSharing: true,
//                     build: (format) => _cachedPdfBytes!,
//                   )
//                 : FutureBuilder<Uint8List>(
//                     future: _pdfFuture,
//                     builder: (context, pdfSnapshot) {
//                       if (pdfSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (pdfSnapshot.hasError) {
//                         return Center(
//                             child: Text('PDF Error: ${pdfSnapshot.error}'));
//                       }
//                       return PdfPreview(
//                         loadingWidget: const CircularProgressIndicator(),
//                         canChangeOrientation: false,
//                         canChangePageFormat: false,
//                         canDebug: false,
//                         allowSharing: true,
//                         build: (format) => pdfSnapshot.data!,
//                       );
//                     },
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
