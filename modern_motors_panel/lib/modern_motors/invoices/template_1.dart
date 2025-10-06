// import 'package:app/models/template_model/template1_model.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/models/product_category_model.dart';
// import 'package:app/modern_motors/services/data_fetch_service.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/pdf_text_in_row_widget.dart';
// import 'package:app/modern_motors/widgets/pdf_text_widget.dart';
// import 'package:app/modern_motors/widgets/pdf_widget.dart/pdf_amount_widget.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class Template1 extends StatefulWidget {
//   final Template1Model template1Model;

//   const Template1({required this.template1Model, super.key});

//   @override
//   State<Template1> createState() => _Template1State();
// }

// class _Template1State extends State<Template1> {
//   bool loading = false;
//   List<ProductCategoryModel> productsCategories = [];
//   List<ProductModel> productList = [];

//   double vatCharge = 0;
//   double discountAmount = 0;
//   double total = 0;
//   double subTotal = 0;
//   double itemTotal = 0;

//   @override
//   void initState() {
//     _loadCats();
//     super.initState();
//   }

//   void calculateAmounts() {
//     vatCharge = widget.template1Model.invoiceModel!.taxAmount ?? 0;
//     total = widget.template1Model.invoiceModel!.total ?? 0;
//     subTotal = widget.template1Model.invoiceModel!.subtotal ?? 0;
//     itemTotal = widget.template1Model.invoiceModel!.itemsTotal ?? 0;
//     discountAmount = widget.template1Model.invoiceModel!.discountedAmount ?? 0;
//   }

//   Future<void> _loadCats() async {
//     setState(() {
//       loading = true;
//     });
//     debugPrint('Loads::::::::::::::');
//     Future.wait([
//       DataFetchService.fetchProducts(),
//       DataFetchService.fetchProducts(),
//     ]).then((results) {
//       debugPrint('Loads then::::::::::::::');
//       setState(() {
//         productsCategories = results[0] as List<ProductCategoryModel>;
//         debugPrint('categories: $productsCategories');
//         productList = results[1] as List<ProductModel>;
//         debugPrint('products: $productList');
//         calculateAmounts();
//         loading = false;
//       });
//     });
//   }

//   Future<Uint8List> createPDF() async {
//     pw.TextDirection textDirection = context.locale.languageCode == 'ar'
//         ? pw.TextDirection.rtl
//         : pw.TextDirection.ltr;

//     final img = await rootBundle.load('assets/images/logo.png');

//     // final pw.Font regular = await PdfGoogleFonts.nunitoRegular();
//     final pw.Font regular = await PdfGoogleFonts.nunitoMedium();
//     // final pw.Font regular = await PdfGoogleFonts.nunitoSemiBold();
//     final pw.Font bold = await PdfGoogleFonts.nunitoBold();

//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.MultiPage(
//         textDirection: textDirection,
//         // theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         theme: pw.ThemeData.withFont(
//           base: regular,
//           bold: bold,
//         ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 0)),
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(20),
//         header: contentHeader,
//         build: (pw.Context ctx) => [contentBody(ctx, img)],
//       ),
//     );
//     return pdf.save();
//   }

//   pw.Widget contentBody(pw.Context ctx, qrCode) {
//     final imageBytes = qrCode.buffer.asUint8List();
//     final image = pw.MemoryImage(imageBytes);
//     return pw.Column(
//       children: [
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(10),
//           child: pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Row(
//                 children: [
//                   pw.Image(image, width: 120, height: 120),
//                   pw.SizedBox(width: context.width * 0.03),
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     mainAxisAlignment: pw.MainAxisAlignment.start,
//                     children: [
//                       pdfTextWidget(
//                         text: 'Your Company Name',
//                         fontSize: 18,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                       pdfTextWidget(text: 'Street Address', fontSize: 14),
//                       pdfTextWidget(text: 'City: Lahore', fontSize: 14),
//                       pdfTextWidget(
//                         text: 'Phone Number: Web Address etc',
//                         fontSize: 14,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               pdfTextWidget(
//                 text: 'Tax Invoice',
//                 fontSize: 24,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ],
//           ),
//         ),
//         pw.Divider(),
//         pw.SizedBox(height: 20),
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pdfTextWidget(
//                   text: 'Bill To:',
//                   fontSize: 12,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//                 pw.SizedBox(width: context.width * 0.005),
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     if (widget.template1Model.customerModel!.customerType ==
//                         'business')
//                       pdfTextWidget(
//                         text:
//                             widget.template1Model.customerModel!.businessName ??
//                                 'No Business',
//                         fontSize: 12,
//                       ),
//                     pdfTextWidget(
//                       text: widget.template1Model.customerModel?.customerName ??
//                           'No Customer',
//                       fontSize: 12,
//                     ),
//                     pdfTextWidget(
//                       text:
//                           widget.template1Model.customerModel?.contactNumber ??
//                               'NILL',
//                       fontSize: 12,
//                     ),
//                     pdfTextWidget(
//                       text:
//                           "${widget.template1Model.customerModel!.streetAddress1.trim()}, ${widget.template1Model.customerModel!.streetAddress2},",
//                       fontSize: 12,
//                     ),
//                     pdfTextWidget(
//                       text:
//                           "${widget.template1Model.customerModel!.city.trim()},  ${widget.template1Model.customerModel!.state},  ${widget.template1Model.customerModel!.postalCode}",
//                       fontSize: 12,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             // pw.SizedBox(width: context.width * 0.07),
//             pw.Column(
//               mainAxisAlignment: pw.MainAxisAlignment.start,
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pdfTextInRowWidget(
//                   context: context,
//                   text1: 'Invoice #        ',
//                   text2: widget.template1Model.invoiceModel?.invoiceNumber
//                           .toString() ??
//                       'NIL',
//                 ),
//                 pdfTextInRowWidget(
//                   context: context,
//                   text1: 'Invoice Date',
//                   text2: widget.template1Model.invoiceModel?.invoiceDate!
//                           .toDate()
//                           .formattedWithDayMonthYear ??
//                       "NIL",
//                 ),
//                 pdfTextInRowWidget(
//                   context: context,
//                   text1: 'Issue Date     ',
//                   text2: widget.template1Model.invoiceModel?.issueDate!
//                           .toDate()
//                           .formattedWithDayMonthYear ??
//                       'NIL',
//                 ),
//                 pdfTextInRowWidget(
//                   context: context,
//                   text1: 'Due Date        ',
//                   text2: widget.template1Model.invoiceModel?.paymentDate!
//                           .toDate()
//                           .formattedWithDayMonthYear ??
//                       'NIL',
//                 ),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 30),
//         pw.Row(children: [pw.Expanded(child: getInspection())]),
//         pw.SizedBox(height: 30),
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.SizedBox(
//             width: context.width * 0.16,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.SizedBox(height: 10),
//                 pdfAmountTextWidget(
//                   context: context,
//                   text1: 'Items Total'.tr(),
//                   text2: "${itemTotal.toStringAsFixed(2).tr()} ${"OMR".tr()}",
//                 ),
//                 pdfAmountTextWidget(
//                   context: context,
//                   text1: "Discount".tr(),
//                   text2:
//                       "${discountAmount.toStringAsFixed(2).tr()} ${"OMR".tr()}",
//                 ),
//                 pdfAmountTextWidget(
//                   context: context,
//                   text1: "SubTotal".tr(),
//                   text2: "${subTotal.toStringAsFixed(2).tr()} ${"OMR".tr()}",
//                 ),
//                 pdfAmountTextWidget(
//                   context: context,
//                   text1: "Tax".tr(),
//                   text2: "${vatCharge.toStringAsFixed(2).tr()} ${"OMR".tr()}",
//                 ),
//                 pdfAmountTextWidget(
//                   context: context,
//                   text1: "Total".tr(),
//                   text2: "${total.toStringAsFixed(2).tr()} ${"OMR".tr()}",
//                 ),
//               ],
//             ),
//           ),
//         ),
//         pw.SizedBox(height: 24),
//         pw.RichText(
//           text: pw.TextSpan(
//             text: 'Please be advised  ',
//             style: pw.TextStyle(
//               fontSize: 12,
//               fontBoldItalic: pw.Font.timesBold(),
//               fontWeight: pw.FontWeight.bold,
//             ),
//             children: [
//               pw.TextSpan(
//                 text:
//                     "So strange. I copied and pasted your example and it worked. But when I go back to my files and add the in the header it didn't work. I compared my files to your example. ",
//                 style: pw.TextStyle(
//                   fontSize: 12,
//                   fontWeight: pw.FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   List<List<String>> getInspectionTableData() {
//     List<List<String>> itemsForTable = [];
//     final invoiceItems = widget.template1Model.invoiceModel?.items ?? [];
//     final inventories = widget.template1Model.inventoryModelList ?? [];
//     for (var item in invoiceItems) {
//       // Find matching inventory using productId
//       final inventory = inventories.firstWhere(
//         (inv) => inv.id == item.productId,
//       );

//       // Find product category/description from productsCategories
//       final product = productList.firstWhere(
//         (prod) => prod.id == inventory.productId,
//       );
//       final category = productsCategories.firstWhere(
//         (cat) => cat.id == product.categoryId,
//       );
//       itemsForTable.add([
//         product.productName ?? 'NIL', // Category
//         category.description ?? 'NIL', // Description
//         item.quantity.toString(), // Qty
//         item.perItemPrice.toStringAsFixed(2), // Unit Price
//         item.totalPrice.toStringAsFixed(2), // Total Price
//       ]);
//     }

//     return itemsForTable;
//   }

//   pw.Table getInspection() {
//     const tableHeaders = [
//       'Items',
//       'Description',
//       'Qty',
//       'Unit Price',
//       "Subtotal",
//     ];
//     return pw.TableHelper.fromTextArray(
//       columnWidths: const {
//         0: pw.FlexColumnWidth(1),
//         1: pw.FlexColumnWidth(3),
//         2: pw.FlexColumnWidth(1),
//         3: pw.FlexColumnWidth(1),
//         4: pw.FlexColumnWidth(1),
//       },
//       border: null,
//       cellAlignment: pw.Alignment.centerLeft,
//       headerHeight: 0,
//       headerDecoration: pw.BoxDecoration(
//         color: PdfColors.grey300,
//         border: pw.Border.all(color: PdfColors.grey400, width: 1),
//       ),
//       headerStyle: pw.TextStyle(
//         color: PdfColors.black,
//         fontSize: 12,
//         fontWeight: pw.FontWeight.bold,
//       ),
//       cellAlignments: {
//         0: pw.Alignment.centerLeft,
//         1: pw.Alignment.centerLeft,
//         2: pw.Alignment.centerLeft,
//         3: pw.Alignment.centerLeft,
//       },
//       cellDecoration: (index, data, rowNum) {
//         return pw.BoxDecoration(
//           color: PdfColors.white,
//           border: pw.Border.all(color: PdfColors.grey400, width: 1),
//         );
//       },
//       cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 12),
//       rowDecoration: const pw.BoxDecoration(
//         border: pw.Border(
//           bottom: pw.BorderSide(color: PdfColors.grey, width: .1),
//         ),
//       ),
//       headers: List<String>.generate(
//         tableHeaders.length,
//         (col) => tableHeaders[col],
//       ),
//       data: getInspectionTableData(),
//     );
//   }

//   pw.Widget contentHeader(pw.Context ctx) {
//     return pw.Column(
//       children: [
//         pw.Row(
//           children: [
//             pw.Text(
//               'Page ${ctx.pageNumber}/${ctx.pagesCount}',
//               style: const pw.TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//         pw.Divider(),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? const Center(child: CircularProgressIndicator())
//         : InteractiveViewer(
//             panEnabled: true,
//             scaleEnabled: true,
//             minScale: 0.5,
//             maxScale: 4.0,
//             child: Center(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width / 2,
//                 child: PdfPreview(
//                   loadingWidget: const CircularProgressIndicator(),
//                   canChangeOrientation: false,
//                   canChangePageFormat: false,
//                   canDebug: false,
//                   allowSharing: true,
//                   build: (format) => createPDF(),
//                 ),
//               ),
//             ),
//           );
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_in_row_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_amount_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../../provider/resource_provider.dart';

class Template1 extends StatefulWidget {
  final Template1Model template1Model;

  const Template1({required this.template1Model, super.key});

  @override
  State<Template1> createState() => _Template1State();
}

class _Template1State extends State<Template1> {
  bool loading = false;
  late Future<void> _initializationFuture;
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;

  late double vatCharge;
  late double discountAmount;
  late double total;
  late double subTotal;
  late double itemTotal;

  late CustomerModel customer;

  @override
  void initState() {
    _initializationFuture = _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    if (mounted) setState(() => loading = true);

    try {
      await _loadAndCalculateData();
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _loadAndCalculateData() async {
    final provider = context.read<MmResourceProvider>();
    _calculateAmounts();

    customer = provider.customersList.firstWhere(
      (item) => item.id == widget.template1Model.salesDetails!.customerName,
    );

    estimationTemplatePreviewModel = provider.estimationTemplatePreviewModel
        .firstWhere((tem) => tem.type == 'Template 1');
  }

  void _calculateAmounts() {
    final sale = widget.template1Model.salesDetails;
    vatCharge = sale!.taxAmount;
    total = sale.total ?? 0;
    subTotal = sale.totalRevenue - sale.taxAmount;
    itemTotal = sale.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    discountAmount = sale.discount;
    subTotal = itemTotal - discountAmount;
  }

  Future<Uint8List> createPDF() async {
    pw.TextDirection textDirection = context.locale.languageCode == 'ar'
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;

    final img = await rootBundle.load('assets/images/mm_logo.png');

    // final pw.Font regular = await PdfGoogleFonts.nunitoRegular();
    final pw.Font regular = await PdfGoogleFonts.nunitoMedium();
    // final pw.Font regular = await PdfGoogleFonts.nunitoSemiBold();
    final pw.Font bold = await PdfGoogleFonts.nunitoBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        textDirection: textDirection,
        // theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        theme: pw.ThemeData.withFont(
          base: regular,
          bold: bold,
        ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 0)),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: contentHeader,
        build: (pw.Context ctx) => [contentBody(ctx, img)],
      ),
    );
    return pdf.save();
  }

  pw.Widget contentBody(pw.Context ctx, qrCode) {
    final imageBytes = qrCode.buffer.asUint8List();
    final image = pw.MemoryImage(imageBytes);
    return pw.Column(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Image(image, width: 120, height: 120),
                  pw.SizedBox(width: context.width * 0.03),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pdfTextWidget(
                        text:
                            estimationTemplatePreviewModel
                                ?.companyDetails
                                .companyName ??
                            'Your Company Name',
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      pdfTextWidget(
                        text:
                            estimationTemplatePreviewModel
                                ?.companyDetails
                                .streetAddress ??
                            'Street Address',
                        fontSize: 14,
                      ),
                      pdfTextWidget(
                        text:
                            'City: ${estimationTemplatePreviewModel?.companyDetails.city ?? 'Lahore'}',
                        fontSize: 14,
                      ),
                      pdfTextWidget(
                        text:
                            'Phone Number: ${estimationTemplatePreviewModel?.companyDetails.companyContact1 ?? '03001234567'}',
                        fontSize: 14,
                      ),
                    ],
                  ),
                ],
              ),
              pdfTextWidget(
                text: 'Tax Invoice',
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ],
          ),
        ),
        pw.Divider(),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pdfTextWidget(
                  text: 'Bill To:',
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                pw.SizedBox(width: context.width * 0.005),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (customer.customerType == 'business')
                      pdfTextWidget(
                        text: customer.businessName ?? 'No Business',
                        fontSize: 12,
                      ),
                    pdfTextWidget(text: customer.customerName, fontSize: 12),
                    pdfTextWidget(text: customer.contactNumber, fontSize: 12),
                    pdfTextWidget(
                      text:
                          "${customer.streetAddress1.trim()}, ${customer.streetAddress2},",
                      fontSize: 12,
                    ),
                    pdfTextWidget(
                      text:
                          "${customer.city.trim()},  ${customer.state},  ${customer.postalCode}",
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
            // pw.SizedBox(width: context.width * 0.07),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pdfTextInRowWidget(
                  context: context,
                  text1: 'Invoice #        ',
                  text2: widget.template1Model.salesDetails!.invoice.toString(),
                ),
                pdfTextInRowWidget(
                  context: context,
                  text1: 'Invoice Date',
                  text2: widget
                      .template1Model
                      .salesDetails!
                      .createdAt
                      .formattedWithDayMonthYear,
                ),
                pdfTextInRowWidget(
                  context: context,
                  text1: 'Issue Date     ',
                  text2: widget
                      .template1Model
                      .salesDetails!
                      .createdAt
                      .formattedWithDayMonthYear,
                ),
                pdfTextInRowWidget(
                  context: context,
                  text1: 'Due Date        ',
                  text2: widget
                      .template1Model
                      .salesDetails!
                      .createdAt
                      .formattedWithDayMonthYear,
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 30),
        pw.Row(children: [pw.Expanded(child: getInspection())]),
        pw.SizedBox(height: 30),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.SizedBox(
            width: context.width * 0.16,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.SizedBox(height: 10),
                pdfAmountTextWidget(
                  context: context,
                  text1: 'Items Total'.tr(),
                  text2: "${itemTotal.toStringAsFixed(2).tr()} ${"OMR".tr()}",
                ),
                pdfAmountTextWidget(
                  context: context,
                  text1: "Discount".tr(),
                  text2:
                      "${discountAmount.toStringAsFixed(2).tr()} ${"OMR".tr()}",
                ),
                pdfAmountTextWidget(
                  context: context,
                  text1: "SubTotal".tr(),
                  text2: "${subTotal.toStringAsFixed(2).tr()} ${"OMR".tr()}",
                ),
                pdfAmountTextWidget(
                  context: context,
                  text1: "Tax".tr(),
                  text2: "${vatCharge.toStringAsFixed(2).tr()} ${"OMR".tr()}",
                ),
                pdfAmountTextWidget(
                  context: context,
                  text1: "Total".tr(),
                  text2: "${total.toStringAsFixed(2).tr()} ${"OMR".tr()}",
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 24),
        // pw.RichText(
        //   text: pw.TextSpan(
        //     text: 'Please be advised  ',
        //     style: pw.TextStyle(
        //       fontSize: 12,
        //       fontBoldItalic: pw.Font.timesBold(),
        //       fontWeight: pw.FontWeight.bold,
        //     ),
        //     children: [
        //       pw.TextSpan(
        //         text:
        //             "So strange. I copied and pasted your example and it worked. But when I go back to my files and add the in the header it didn't work. I compared my files to your example. ",
        //         style: pw.TextStyle(
        //           fontSize: 12,
        //           fontWeight: pw.FontWeight.normal,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  List<List<String>> getInspectionTableData() {
    final provider = context.read<MmResourceProvider>();
    List<List<String>> itemsForTable = [];
    final saleModel = widget.template1Model.salesDetails;

    for (var item in saleModel!.items) {
      String description = "Description";

      if (item.type == "product") {
        final product = provider.productsList.firstWhere(
          (p) => p.id == item.productId,
          orElse: () =>
              ProductModel(id: '', categoryId: '', productName: 'Unknown'),
        );

        final category = provider.productCategoryList.firstWhere(
          (c) => c.id == product.categoryId,
          orElse: () => ProductCategoryModel(productName: ''),
        );

        description = category.description ?? "No Description";
      }

      itemsForTable.add([
        item.productName,
        description,
        item.quantity.toString(),
        item.unitPrice.toStringAsFixed(2),
        item.totalPrice.toStringAsFixed(2),
      ]);
    }

    return itemsForTable;
  }

  pw.Table getInspection() {
    const tableHeaders = [
      'Items',
      'Description',
      'Qty',
      'Unit Price',
      "Subtotal",
    ];
    return pw.TableHelper.fromTextArray(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(1),
      },
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerHeight: 0,
      headerDecoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        border: pw.Border.all(color: PdfColors.grey400, width: 1),
      ),
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
      },
      cellDecoration: (index, data, rowNum) {
        return pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColors.grey400, width: 1),
        );
      },
      cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 12),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey, width: .1),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: getInspectionTableData(),
    );
  }

  pw.Widget contentHeader(pw.Context ctx) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Text(
              'Page ${ctx.pageNumber}/${ctx.pagesCount}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Divider(),
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
          panEnabled: true,
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: PdfPreview(
                loadingWidget: const CircularProgressIndicator(),
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                allowSharing: true,
                build: (format) => createPDF(),
              ),
            ),
          ),
        );
      },
    );
  }
}
