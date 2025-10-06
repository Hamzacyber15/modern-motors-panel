import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_amount_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_dotted_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class Template5 extends StatefulWidget {
  final Template1Model template1Model;

  const Template5({required this.template1Model, super.key});

  @override
  State<Template5> createState() => _Template5State();
}

class _Template5State extends State<Template5> {
  bool loading = false;
  late Future<void> _initializationFuture;
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;

  late double vatCharge;
  late double discountAmount;
  late double total;
  late double subTotal;
  late double itemTotal;
  late double paid;
  late double remaningAmount;

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
        .firstWhere((tem) => tem.type == 'Template 5');
  }

  void _calculateAmounts() {
    final sale = widget.template1Model.salesDetails;
    vatCharge = sale!.taxAmount;
    total = sale.total ?? 0;

    itemTotal = sale.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    discountAmount = sale.discount;
    subTotal = itemTotal - discountAmount;
    paid = widget.template1Model.salesDetails!.paymentData.totalPaid ?? 0;
    remaningAmount =
        widget.template1Model.salesDetails!.paymentData.remainingAmount ?? 0;
  }

  Future<Uint8List> createPDF() async {
    pw.TextDirection textDirection = context.locale.languageCode == 'ar'
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;

    final img = await rootBundle.load('assets/images/mm_logo.png');

    final pw.Font regular = await PdfGoogleFonts.nunitoMedium();
    final pw.Font bold = await PdfGoogleFonts.nunitoBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        textDirection: textDirection,
        theme: pw.ThemeData.withFont(
          base: regular,
          bold: bold,
        ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 1)),
        pageFormat: PdfPageFormat.a4,
        // margin: pw.EdgeInsets.zero,
        margin: const pw.EdgeInsets.all(20),
        header: contentHeader,

        build: (pw.Context ctx) => [contentBody(ctx, img)],
        // build:
        //     (pw.Context ctx) => [
        //       pw.Padding(
        //         padding: const pw.EdgeInsets.all(20),
        //         child: contentBody(ctx, img),
        //       ),
        //     ],
      ),
    );
    return pdf.save();
  }

  pw.Widget contentBody(pw.Context ctx, qrCode) {
    final imageBytes = qrCode.buffer.asUint8List();
    final image = pw.MemoryImage(imageBytes);
    return pw.Column(
      children: [
        pw.SizedBox(height: 10),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pdfDottedWidget(
                    alignment: pw.Alignment.centerLeft,
                    child: pdfTextWidget(
                      text: 'Invoice',
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pdfTextWidget(
                    text: '#${widget.template1Model.salesDetails!.invoice}',
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ],
              ),
              pw.Image(image, width: 150, height: 150),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pdfTextWidget(
                    text:
                        estimationTemplatePreviewModel
                            ?.companyDetails
                            .companyName ??
                        'MODERN HANDS\nSILVER',
                    fontSize: 14,
                    textAlign: pw.TextAlign.end,
                    color: PdfColor.fromInt(0xFF44B1D9),
                  ),
                  pw.SizedBox(height: 6),
                  pdfTextWidget(
                    text:
                        estimationTemplatePreviewModel
                            ?.companyDetails
                            .companyAddress ??
                        'BARKA SULTANTE OF OMAN',
                    fontSize: 10,
                    color: PdfColor.fromInt(0xFF44B1D9),
                  ),
                  pdfTextWidget(
                    text:
                        'VAT NO. ${estimationTemplatePreviewModel?.companyDetails.vatNo ?? 'OM1100306983'}',
                    fontSize: 10,
                    color: PdfColor.fromInt(0xFF44B1D9),
                  ),
                  pdfTextWidget(
                    text:
                        estimationTemplatePreviewModel
                            ?.companyDetails
                            .companyContact1 ??
                        '92478551',
                    fontSize: 10,
                    color: PdfColor.fromInt(0xFF44B1D9),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
        // pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pdfDottedWidget(
                    alignment: pw.Alignment.centerLeft,
                    child: pdfTextWidget(
                      text: 'Invoice Date',
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFF44B1D9),
                    ),
                  ),
                  pdfTextWidget(
                    text: widget
                        .template1Model
                        .salesDetails!
                        .createdAt
                        .formattedWithDayMonthYear,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  //pdfTextWidget(text: 'Add Field', fontSize: 12),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      pdfTextWidget(
                        text: 'Paid',
                        fontSize: 12,
                        color: PdfColor.fromInt(0xFF44B1D9),
                      ),
                      pw.SizedBox(width: 10),
                      pdfTextWidget(
                        text:
                            widget
                                .template1Model
                                .salesDetails!
                                .paymentData!
                                .totalPaid!
                                .toStringAsFixed(2) ??
                            "",
                        fontSize: 12,
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    children: [
                      pdfTextWidget(
                        text: 'Balance Due',
                        fontSize: 12,
                        color: PdfColor.fromInt(0xFF44B1D9),
                      ),
                      pw.SizedBox(width: 10),
                      pdfTextWidget(
                        text:
                            "${remaningAmount.toStringAsFixed(2)} ${"OMR".tr()}",
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 2),
            pw.Expanded(
              child: pdfDottedWidget(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pdfDottedWidget(
                      alignment: pw.Alignment.centerRight,
                      child: pdfTextWidget(
                        text: 'Bill To:',
                        fontSize: 12,
                        // fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF44B1D9),
                      ),
                    ),
                    if (customer.customerType == 'business')
                      pdfTextWidget(
                        text: customer.businessName!,
                        fontSize: 12,
                        color: PdfColor.fromInt(0xFF44B1D9),
                      ),
                    pdfTextWidget(
                      text: customer.customerName,
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFF44B1D9),
                    ),
                    pdfTextWidget(
                      text: customer.contactNumber,
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFF44B1D9),
                    ),
                    pdfTextWidget(
                      text: customer.telePhoneNumber,
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFF44B1D9),
                    ),
                    if (customer.customerType == 'business')
                      pdfTextWidget(
                        text: customer.businessName!.trim(),
                        fontSize: 12,
                        color: PdfColor.fromInt(0xFF44B1D9),
                      ),
                    pdfTextWidget(
                      text:
                          "${customer.streetAddress1.trim()}, ${customer.streetAddress2},",
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFF44B1D9),
                    ),
                    pdfTextWidget(
                      text:
                          "${customer.city.trim()},  ${customer.state},  ${customer.postalCode}",
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFF44B1D9),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Row(children: [pw.Expanded(child: getInspection())]),
        pw.SizedBox(height: 20),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.SizedBox(
            width: context.width * 0.16,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.SizedBox(height: 10),
                pdfTextInRowWidgetTem5(
                  context: context,
                  text1: "Total".tr(),
                  text2: "${total.toStringAsFixed(2).tr()} ${"OMR".tr()}",
                ),
                pw.SizedBox(height: 10),
                pdfTextInRowWidgetTem5(
                  context: context,
                  text1: "Paid".tr(),
                  text2: "${paid.toStringAsFixed(2)} ${"OMR".tr()}",
                ),
                pw.SizedBox(height: 10),
                pdfTextInRowWidgetTem5(
                  context: context,
                  text1: "Balance Due".tr(),
                  text2:
                      "${widget.template1Model.salesDetails!.paymentData.remainingAmount.toStringAsFixed(2)} ${"OMR".tr()}",
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 40),
        pdfDottedWidget(
          alignment: pw.Alignment.centerLeft,
          child: pw.RichText(
            text: pw.TextSpan(
              text: 'Please be advised  ',
              style: pw.TextStyle(
                fontSize: 12,
                fontBoldItalic: pw.Font.timesBold(),
                fontWeight: pw.FontWeight.bold,
              ),
              children: [
                // pw.TextSpan(
                //   text:
                //       "So strange. I copied and pasted your example and it worked. But when I go back to my files and add the in the header it didn't work. I compared my files to your example. ",
                //   style: pw.TextStyle(
                //     fontSize: 12,
                //     fontWeight: pw.FontWeight.normal,
                //   ),
                // ),
              ],
            ),
          ),
        ),
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
        // border: pw.Border.all(color: PdfColors.grey400, width: 1),
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
          // border: pw.Border(color: PdfColors.grey400, width: 1),
        );
      },
      cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 12),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 1),
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
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Page ${ctx.pageNumber}/${ctx.pagesCount}',
          style: const pw.TextStyle(fontSize: 12),
        ),
        // pw.Divider(),
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
              width: context.width * 0.5,
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
