import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/invoices/maintanance_template2.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/corner_borders_box.dart';
import 'package:modern_motors_panel/modern_motors/widgets/load_header_logo.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_in_row_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/texts_in_row.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class MaintenanceTemplate1 extends StatefulWidget {
  final Template1Model template1Model;

  const MaintenanceTemplate1({required this.template1Model, super.key});

  @override
  State<MaintenanceTemplate1> createState() => _MaintenanceTemplate1State();
}

class _MaintenanceTemplate1State extends State<MaintenanceTemplate1> {
  bool loading = false;
  late Future<void> _initializationFuture;
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;

  late double vatCharge;
  late double discountAmount;
  late double total;
  late double subTotal;
  late double itemTotal;

  List<BookedServices> filteredServices = [];
  late EmployeeModel? salesPerson;
  late CustomerModel customer;
  MmtrucksModel? trucks;

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
    if (widget.template1Model.salesDetails!.createBy == Constants.adminId) {
      salesPerson = EmployeeModel.getEmptyEmployee();
      salesPerson!.name = "Admin";
    } else {
      salesPerson = provider.getEmployeeByID(
        widget.template1Model.salesDetails!.createBy,
      );
    }
    debugPrint('sales Person : ${salesPerson!.toMap()}');
    customer = provider.customersList.firstWhere(
      (item) => item.id == widget.template1Model.salesDetails!.customerName,
    );
    if (widget.template1Model.salesDetails!.truckId != null) {
      trucks = provider.getTruckByID(
        widget.template1Model.salesDetails!.truckId!,
      );
    }

    estimationTemplatePreviewModel = provider.estimationTemplatePreviewModel
        .firstWhere(
          (tem) => tem.type == 'Maintenance Template 1',
          orElse: () => EstimationTemplatePreviewModel(
            companyDetails: CompanyDetails(),
            bank1Details: BankDetails(),
            bank2Details: BankDetails(),
          ),
        );
    filteredServices = await _loadFilteredServices(provider);
  }

  void _calculateAmounts() {
    final sale = widget.template1Model.salesDetails;
    vatCharge = sale!.taxAmount;
    total = sale.totalRevenue;
    subTotal = sale.totalRevenue - sale.taxAmount;
    itemTotal = sale.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    discountAmount = sale.discount;
  }

  Future<List<BookedServices>> _loadFilteredServices(
    MmResourceProvider provider,
  ) async {
    final List<BookedServices> services = [];
    final serviceList = provider.serviceList;

    final serviceMap = {for (var service in serviceList) service.id: service};
    for (var item in widget.template1Model.salesDetails!.items) {
      if (item.type == "service") {
        final service = serviceMap[item.productId];
        if (service != null) {
          services.add(
            BookedServices(price: item.sellingPrice, serviceTypeModel: service),
          );
        }
      }
    }
    return services;
  }

  Future<Uint8List> createPDF() async {
    pw.TextDirection textDirection = context.locale.languageCode == 'ar'
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;

    // final topLogo = await rootBundle.load('assets/images/logo1.png');
    // final bottomLogo = await rootBundle.load('assets/images/logo2.png');
    // final footerLeftLogo = await rootBundle.load('assets/images/logo1.png');
    // final footerRightLogo = await rootBundle.load('assets/images/logo1.png');

    final topLogoBytes = await loadHeaderLogo(
      estimationTemplatePreviewModel?.headerLogo ?? 'assets/images/mm_logo.png',
    );
    final topLogoImage = pw.MemoryImage(topLogoBytes);

    final pw.Font regular = await PdfGoogleFonts.iBMPlexSansArabicRegular();
    final pw.Font bold = await PdfGoogleFonts.iBMPlexSansArabicBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        textDirection: textDirection,
        // textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: regular,
          bold: bold,
        ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 1)),
        pageFormat: PdfPageFormat.a3,
        // margin: pw.EdgeInsets.zero,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context ctx) => [contentBody(ctx, topLogoImage)],
        footer: (ctx) => contentFooter(ctx, topLogoImage, topLogoImage),
      ),
    );
    return pdf.save();
  }

  pw.Widget contentBody(pw.Context ctx, tLogo) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 10),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [pw.Image(tLogo, width: 60, height: 60)],
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Column(
            children: [
              pdfTextWidget(text: 'Invoice'),
              pdfTextWidget(text: 'فاتورة'),
            ],
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  cornerBorderBox(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pdfTextWidget(
                          text:
                              '${estimationTemplatePreviewModel?.companyDetails.branchLine1 ?? 'Parts Cash Sales - Sohar Truck Branch - IHE'}\n${estimationTemplatePreviewModel?.companyDetails.branchLine2 ?? 'NTERNATIONAL SILVER'}\n${salesPerson?.name ?? 'Mr.MUNEER ALI'}',
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        pw.SizedBox(height: 4),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pdfTextWidget(
                              text:
                                  'Ph: ${estimationTemplatePreviewModel?.companyDetails.companyContact1 ?? 3131212121}',
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            pdfTextWidget(
                              text:
                                  'VIN: ${estimationTemplatePreviewModel?.companyDetails.vinNumber ?? 'L0014157'}',
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pdfTextWidget(text: 'Acct.No:', fontSize: 10),
                            pdfTextWidget(
                              text:
                                  estimationTemplatePreviewModel
                                      ?.bank1Details
                                      .accountNumber ??
                                  '0M1100023614',
                              fontSize: 10,
                            ),
                            pdfTextWidget(text: 'رقم الحساب', fontSize: 10),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pdfTextWidget(
                              text: 'Customer VATIN:',
                              fontSize: 10,
                            ),
                            pdfTextWidget(
                              text: 'رقم ضريبة القيمة المضافة للعميل',
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pdfTextInRowWidget(
                    context: context,
                    text1: 'Manufacturer:',
                    text2: 'الشركة المصنعة',
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    isBothBold: true,
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Expanded(
              child: pw.Container(
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    textsInRow(
                      context: context,
                      text1: 'Invoice#:',
                      text2:
                          widget.template1Model.salesDetails?.invoice ?? 'NIL',
                      text3: 'رقم الفاتورة',
                    ),
                    if (customer.customerType == 'business')
                      textsInRow(
                        context: context,
                        text1: 'Business Name:',
                        text2: customer.businessName ?? 'No Busines',
                        text3: 'اسم العمل',
                      ),
                    textsInRow(
                      context: context,
                      text1: 'Customer Name',
                      text2: customer.customerName,
                      text3: 'اسم العميل:',
                    ),
                    if (trucks != null)
                      pw.Column(
                        children: [
                          textsInRow(
                            context: context,
                            text1: 'Vehicle Number:',
                            text2: '${trucks!.code}-${trucks!.plateNumber}',
                            text3: 'رقم المركبة',
                          ),
                          textsInRow(
                            context: context,
                            text1: 'Vehicle Model:',
                            text2: '${trucks!.modelYear}',
                            text3: 'طراز السيارة',
                          ),
                          textsInRow(
                            context: context,
                            text1: 'Vehicle Color:',
                            text2: '${trucks!.color}',
                            text3: 'لون المركبة',
                          ),
                          textsInRow(
                            context: context,
                            text1: 'Reg In:',
                            text2: '${trucks!.country}',
                            text3: 'بلد التسجيل',
                          ),
                        ],
                      ),
                    textsInRow(
                      context: context,
                      text1: 'Date & Time:',
                      text2:
                          (widget.template1Model.salesDetails?.createdAt ??
                                  DateTime.now())
                              .formattedWithYMDHMS,
                      text3: 'التاريخ والوقت',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(children: [pw.Expanded(child: getInspection())]),

        // pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget contentFooter(pw.Context ctx, leftLogo, rightLogo) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: pw.EdgeInsets.all(2),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: context.width * 0.12,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pdfTextInRowWidget(
                      context: context,
                      text1: 'Service',
                      text2: 'Price',
                      isBothBold: true,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    if (filteredServices.isNotEmpty) ...[
                      ...List.generate(
                        filteredServices.length,
                        (index) => pdfTextInRowWidget(
                          context: context,
                          text1: filteredServices[index].serviceTypeModel.name,
                          text2: filteredServices[index].price.toStringAsFixed(
                            2,
                          ),
                          fixedWidth: 100,
                          fontSize: 10,
                        ),
                      ),
                    ],
                    pw.SizedBox(height: 10),
                  ],
                ),
              ),
              pw.SizedBox(
                width: context.width * 0.16,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    // pw.SizedBox(height: 10),
                    // textsInRowWithArabicInMiddle(
                    //   context: context,
                    //   text2: 'إجمالي الخدمات',
                    //   text1: 'Services Total',
                    //   text3:
                    //       '+${widget.template1Model.bookingModel!.servicesTotal!.toStringAsFixed(2)}',
                    //   fontSize: 10,
                    // ),
                    textsInRowWithArabicInMiddle(
                      context: context,
                      text2: 'إجمالي العناصر',
                      text1: 'Items Total',
                      text3: '+${itemTotal.toStringAsFixed(2)}',
                      fontSize: 10,
                    ),
                    textsInRowWithArabicInMiddle(
                      context: context,
                      text2: 'تخفيض',
                      text1: 'Discount',
                      text3: '-${discountAmount.toStringAsFixed(2)}',
                      fontSize: 10,
                    ),
                    textsInRowWithArabicInMiddle(
                      context: context,
                      text2: 'ضريبة',
                      text1: 'Tax',
                      text3: '+${vatCharge.toStringAsFixed(2)}',
                      fontSize: 10,
                    ),
                    textsInRowWithArabicInMiddle(
                      context: context,
                      text2: 'المجموع الفرعي',
                      text1: 'Sub-Total',
                      text3: subTotal.toStringAsFixed(2),
                      fontSize: 10,
                    ),
                    textsInRowWithArabicInMiddle(
                      context: context,
                      text3: total.toStringAsFixed(2),
                      text2: 'المجموع',
                      text1: 'Total',
                      fontSize: 10,
                    ),
                    // pw.SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 4),
        pw.SizedBox(
          height: 90,
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfTextWidget(
                      text:
                          'I hereby confirm receipt of all items refereed to above in good sound and serviceable condition and agree to all the terms printed on the rear of the invoice',
                      fontSize: 10,
                    ),
                    // pw.SizedBox(height: 14),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pdfTextWidget(text: 'توقيع العميل', fontSize: 10),
                        pdfTextWidget(
                          text: 'Signature of Customer',
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 18),
              pw.Expanded(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pdfTextWidget(
                            textAlign: pw.TextAlign.end,
                            text:
                                'أؤكد بموجب هذا استلام جميع العناصر المشار إليها أعلاه في حالة جيدة وسليمة وقابلة للخدمة وأوافق على جميع الشروط المطبوعة على ظهر الفاتورة',
                            fontSize: 10,
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Column(
                          children: [
                            pdfTextWidget(text: 'شكرًا لك', fontSize: 10),
                            pdfTextWidget(text: 'Thank you', fontSize: 10),
                          ],
                        ),
                      ],
                    ),
                    // pw.SizedBox(height: 14),
                    pw.Column(
                      children: [
                        pdfTextWidget(text: 'مشرف المبيعات', fontSize: 10),
                        pdfTextWidget(text: 'Sales Supervisor', fontSize: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 16),
          child: pw.Divider(color: PdfColors.black, thickness: 1),
        ),
        pw.Row(
          children: [
            pw.Image(leftLogo, width: 34, height: 34),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pdfTextWidget(
                    textAlign: pw.TextAlign.center,
                    fontSize: 8,
                    text:
                        "${estimationTemplatePreviewModel?.companyDetails.companyNameAr ?? 'شركة المعدات الثقيلة الدولية ذ.م.م،'} "
                        "هاتف: ${Constants.translateToArabic(estimationTemplatePreviewModel?.companyDetails.companyContact2 ?? '٢٤٥٢٧٦٠٠')}, "
                        "فاكس: ${Constants.translateToArabic(estimationTemplatePreviewModel?.companyDetails.faxNumber ?? '٢٤٥٢٧٦٤١')}, "
                        "السجل التجاري رقم:${Constants.translateToArabic(estimationTemplatePreviewModel?.companyDetails.crNumber ?? '١/٧٣٤٩٣/٨')}, ",
                  ),
                  pw.RichText(
                    textAlign: pw.TextAlign.center,
                    text: pw.TextSpan(
                      text:
                          estimationTemplatePreviewModel
                                  ?.companyDetails
                                  .companyName !=
                              null
                          ? ''
                          : 'International Heavy Equipment LLC',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      children: [
                        pw.TextSpan(
                          text:
                              "${estimationTemplatePreviewModel?.companyDetails.companyName ?? 'BOX 800, Muscat 111, Sultanate of Oman,'}Tel ${estimationTemplatePreviewModel?.companyDetails.companyContact2 ?? '24 527 600'}, Fax: ${estimationTemplatePreviewModel?.companyDetails.faxNumber ?? '24 527 641'} , C.R. No. ${estimationTemplatePreviewModel?.companyDetails.crNumber ?? '1/73493/8'} e-mail: ${estimationTemplatePreviewModel?.companyDetails.email ?? 'Ihe@Ihe-oman.com'}, ${estimationTemplatePreviewModel?.companyDetails.website ?? 'www.Ihe-oman.com'}",
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.Image(rightLogo, width: 34, height: 34),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Container(
          width: double.infinity,
          height: 20,
          decoration: pw.BoxDecoration(
            color: PdfColors.red700,
            border: pw.Border.all(color: PdfColors.red, width: 0.5),
          ),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pdfTextWidget(
              text:
                  'VATIN: ${estimationTemplatePreviewModel?.companyDetails.vatNo ?? '0000000'} | Tax Card No: ${estimationTemplatePreviewModel?.companyDetails.taxCardNumber ?? 0000}',
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
            pdfTextWidget(
              text:
                  'رقم الشهادة: ${estimationTemplatePreviewModel?.companyDetails.taxCardNumber ?? 0000} | ${estimationTemplatePreviewModel?.companyDetails.vatNo ?? '0000000'} : رقم تسجيل ضريبة القيمة المضافة',
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          children: [
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 0.5),
                color: PdfColors.blue50,
              ),
              child: pdfTextWidget(
                text:
                    'Bank Details: ${estimationTemplatePreviewModel?.bank1Details.bankName ?? 'Sohar International Bank'}, A/C No: ${estimationTemplatePreviewModel?.bank1Details.accountNumber ?? '00103002714'}',
                fontSize: 9,
                color: PdfColors.green,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(width: 4),
            pdfTextWidget(
              text: 'For terms & conditions, please refer overleaf/T&C page',
              fontSize: 9,
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
            ),
            pw.Spacer(),
            pdfTextWidget(
              text: 'Page: ${ctx.pagesCount}',
              fontSize: 9,
              color: PdfColors.black,
            ),
          ],
        ),
      ],
    );
  }

  List<List<String>> getInspectionTableData() {
    final provider = context.read<MmResourceProvider>();

    List<List<String>> itemsForTable = [];
    final saleModel = widget.template1Model.salesDetails;
    int index = 1;
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
        index.toString(),
        item.productName,
        'description',
        item.quantity.toString(),
        item.unitPrice.toStringAsFixed(2),
        item.totalPrice.toStringAsFixed(2),
      ]);
      index++;
    }
    return itemsForTable;
  }

  pw.Table getInspection() {
    const tableHeaders = [
      'رقم سري\nSrl.',
      'أغراض\nItems',
      'وصف\nDescription',
      'كمية\nQty',
      'سعر الوحدة\nUnit Price',
      "المجموع\nSubtotal",
    ];
    return pw.TableHelper.fromTextArray(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(1),
        5: pw.FlexColumnWidth(1),
      },
      border: pw.TableBorder(
        left: pw.BorderSide(color: PdfColors.black, width: 1),
        right: pw.BorderSide(color: PdfColors.black, width: 1),
        top: pw.BorderSide(color: PdfColors.black, width: 1),
        bottom: pw.BorderSide(color: PdfColors.black, width: 1),
      ),
      cellAlignment: pw.Alignment.center,
      headerHeight: 0,
      headerDecoration: pw.BoxDecoration(
        // color: PdfColors.grey300,
        border: pw.Border.all(
          color: PdfColors.black,
          width: 1,
          // bottom: pw.BorderSide(color: PdfColors.black, width: 1),
        ),
      ),
      headerDirection: pw.TextDirection.rtl,
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
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
          // border: pw.Border.all(color: PdfColors.grey400, width: 1),
        );
      },
      cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 10),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(color: PdfColors.black, width: 1),
          right: pw.BorderSide(color: PdfColors.black, width: 1),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: getInspectionTableData(),
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
          return Center(child: Text('Error ++: ${snapshot.error}'));
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
