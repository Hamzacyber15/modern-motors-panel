import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/model/vendor/ventor_logos_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/load_header_logo.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_logo_strip_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/texts_in_row.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../widgets/pdf_text_widget.dart';

class MaintenanceTemplate2 extends StatefulWidget {
  final Template1Model template1Model;

  const MaintenanceTemplate2({required this.template1Model, super.key});

  @override
  State<MaintenanceTemplate2> createState() => _MaintenanceTemplate2State();
}

class _MaintenanceTemplate2State extends State<MaintenanceTemplate2> {
  bool loading = false;
  late Future<void> _initializationFuture;
  Completer<Uint8List>? _pdfCompleter;
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  List<VendorLogosModel> allLogos = [];
  late double vatCharge;
  late double discountAmount;
  late double total;
  late double subTotal;
  late double itemTotal;
  late List<BookedServices> filteredServices;
  // late EmployeeModel? salesPerson;
  late CustomerModel customer;

  static const _addr1 = 'P.O. BOX: 1109, Postal Code 111';
  static const _addr2 = 'Ghala Ind, Area';
  static const _addr3 = 'Muscat - Sultanate of Oman';

  static const _add2L1 = 'Br. Sohat-Sultanate of Oman';
  static const _add2L2 = 'Al Ouhi Ind, Area 2';

  static Future<Map<String, Uint8List>> _preloadResources() async {
    final resources = <String, Uint8List>{};

    try {
      resources['mm_logo'] = (await rootBundle.load(
        'assets/images/logo1.png',
      )).buffer.asUint8List();

      final logoPaths = [
        'assets/images/1 (1).jpeg',
        'assets/images/1 (1).png',
        'assets/images/1 (2).png',
        'assets/images/1 (3).png',
      ];

      for (final path in logoPaths) {
        try {
          resources[path] = (await rootBundle.load(path)).buffer.asUint8List();
        } catch (e) {
          debugPrint('Failed to preload logo: $path');
        }
      }
    } catch (e) {
      debugPrint('Failed to preload resources: $e');
    }

    return resources;
  }

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeData();
  }

  @override
  void dispose() {
    _pdfCompleter?.completeError('Cancelled');
    super.dispose();
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
    filteredServices = await _loadFilteredServices(provider);
    // salesPerson = provider.getEmployeeByID(
    //   widget.template1Model.salesDetails!.createBy,
    // );
    customer = provider.customersList.firstWhere(
      (item) => item.id == widget.template1Model.salesDetails!.customerName,
    );
    estimationTemplatePreviewModel = provider.estimationTemplatePreviewModel
        .firstWhere(
          (tem) => tem.type == 'Maintenance Template 2',
          orElse: () => EstimationTemplatePreviewModel(
            companyDetails: CompanyDetails(),
            bank1Details: BankDetails(),
            bank2Details: BankDetails(),
          ),
        );

    if (provider.logosList != null) {
      allLogos =
          provider.logosList?.logos
              .where((logo) => logo.status == 'active')
              .toList() ??
          [];
    }
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

  Future<List<pw.MemoryImage>> convertVendorLogos(
    List<VendorLogosModel> logos,
  ) async {
    final images = <pw.MemoryImage>[];
    for (final logo in logos) {
      try {
        final response = await http.get(Uri.parse(logo.imgUrl));
        if (response.statusCode == 200) {
          images.add(pw.MemoryImage(response.bodyBytes));
        }
      } catch (e) {
        debugPrint("Error loading logo ${logo.imgUrl}: $e");
      }
    }
    return images;
  }

  Future<Uint8List> createPDF() async {
    _pdfCompleter?.completeError('Cancelled');
    _pdfCompleter = Completer<Uint8List>();

    final logos = await convertVendorLogos(allLogos);
    final provider = context.read<MmResourceProvider>();
    final topLogoBytes = await loadHeaderLogo(
      estimationTemplatePreviewModel?.headerLogo ?? 'assets/images/mm_logo.png',
    );

    final resources = await _preloadResources();
    try {
      final pdfBytes = await compute(_generatePDFInIsolate, {
        'template': widget.template1Model,
        'templateData': estimationTemplatePreviewModel,
        'customer': customer,
        //'salesPerson': salesPerson,
        'filteredServices': filteredServices,
        'vatCharge': vatCharge,
        'total': total,
        'subTotal': subTotal,
        'itemTotal': itemTotal,
        'resources': resources,
        'locale': context.locale.languageCode,
        'vendorLogos': logos,
        'discountAmount': discountAmount,
        'provider': provider,
      });
      _pdfCompleter?.complete(pdfBytes);
      return pdfBytes;
    } catch (e) {
      _pdfCompleter?.completeError(e);
      rethrow;
    }
  }

  static Future<Uint8List> _generatePDFInIsolate(
    Map<String, dynamic> params,
  ) async {
    final template = params['template'] as Template1Model;
    final templateData =
        params['templateData'] as EstimationTemplatePreviewModel;
    final customer = params['customer'] as CustomerModel;
    final salesPerson = params['salesPerson'] as EmployeeModel?;
    final filteredServices = params['filteredServices'] as List<BookedServices>;
    final vatCharge = params['vatCharge'] as double;
    final total = params['total'] as double;
    final subTotal = params['subTotal'] as double;
    final itemTotal = params['itemTotal'] as double;
    final discountAmount = params['discountAmount'] as double;
    final resources = params['resources'] as Map<String, Uint8List>;
    final locale = params['locale'] as String;
    final logos = params['vendorLogos'] as List<pw.MemoryImage>;
    final provider = params['provider'] as MmResourceProvider;

    final textDirection = locale == 'ar'
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;

    final regular = await PdfGoogleFonts.iBMPlexSansArabicRegular();
    final bold = await PdfGoogleFonts.iBMPlexSansArabicBold();

    final topLogoBytes = await loadHeaderLogo(
      templateData.headerLogo ?? 'assets/images/mm_logo.png',
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: _createPageTheme(
          // resources['mm_logo'],
          topLogoBytes,
          regular,
          bold,
          textDirection,
        ),
        build: (pw.Context ctx) => [
          _createContentBody(
            ctx,
            topLogoBytes,
            template,
            customer,
            salesPerson,
            templateData,
            provider,
          ),
        ],
        footer: (ctx) => _createContentFooter(
          ctx,
          // _loadLogosFromResources(resources),
          logos,
          template,
          templateData,
          filteredServices,
          vatCharge,
          total,
          subTotal,
          itemTotal,
          discountAmount,
          provider,
        ),
      ),
    );

    return pdf.save();
  }

  static List<pw.MemoryImage> _loadLogosFromResources(
    Map<String, Uint8List> resources,
  ) {
    final images = <pw.MemoryImage>[];
    final logoPaths = [
      'assets/images/1 (1).jpeg',
      'assets/images/1 (1).png',
      'assets/images/1 (2).png',
      'assets/images/1 (3).png',
    ];

    for (final path in logoPaths) {
      final bytes = resources[path];
      if (bytes != null) {
        images.add(pw.MemoryImage(bytes));
      }
    }
    return images;
  }

  static pw.PageTheme _createPageTheme(
    Uint8List? topLogoBytes,
    pw.Font regular,
    pw.Font bold,
    pw.TextDirection textDirection,
  ) {
    if (topLogoBytes == null) {
      return pw.PageTheme(
        margin: const pw.EdgeInsets.all(20),
        textDirection: textDirection,
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: regular,
          bold: bold,
        ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 1)),
      );
    }

    final top = pw.MemoryImage(topLogoBytes);
    return pw.PageTheme(
      margin: const pw.EdgeInsets.all(20),
      textDirection: textDirection,
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: regular,
        bold: bold,
      ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 1)),
      buildForeground: (context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Center(
            child: pw.Opacity(
              opacity: 0.1,
              child: pw.Image(top, fit: pw.BoxFit.contain, width: 200),
            ),
          ),
        );
      },
    );
  }

  static pw.Widget _createContentBody(
    pw.Context ctx,
    Uint8List topLogoBytes,
    Template1Model template,
    CustomerModel customer,
    EmployeeModel? salesPerson,
    EstimationTemplatePreviewModel model,
    MmResourceProvider provider,
  ) {
    final topLogoImage = pw.MemoryImage(topLogoBytes);
    // final top = pw.MemoryImage(topLogoBytes);

    return pw.Column(
      children: [
        pw.SizedBox(height: 4),
        _createHeaderSection(topLogoImage, model),
        pw.SizedBox(height: 26),
        _createCustomerDetailsSection(
          template,
          customer,
          salesPerson,
          provider,
        ),
      ],
    );
  }

  static pw.Widget _createHeaderSection(
    pw.MemoryImage top,
    EstimationTemplatePreviewModel model,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _createLeftHeaderSection(model),
        pw.SizedBox(width: 20),
        _createCenterHeaderSection(top, model),
        pw.SizedBox(width: 20),
        _createRightHeaderSection(model),
      ],
    );
  }

  static pw.Widget _createLeftHeaderSection(
    EstimationTemplatePreviewModel modelPreviewData,
  ) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildAddressInfo(
            'Tel: ${modelPreviewData.companyDetails.companyContact1 ?? 00988 - 24287805}',
          ),
          _buildAddressInfo(
            '${modelPreviewData.companyDetails.addressLine1 ?? _addr1}\n${modelPreviewData.companyDetails.addressLine2 ?? _addr2}\n${modelPreviewData.companyDetails.addressLine3 ?? _addr3}',
          ),
          _buildAddressInfo(
            'E-mail: ${modelPreviewData.companyDetails.companyContact1 ?? 'oman@ihthiyati.com'}',
          ),
          pw.Divider(height: 1, color: PdfColor.fromInt(0xFF186078)),
          _buildAddressInfo(
            '${modelPreviewData.companyDetails.addressLine2 ?? _add2L1}\n${modelPreviewData.companyDetails.address2Line2 ?? _add2L2}',
          ),
          _buildAddressInfo(
            'Tel: ${modelPreviewData.companyDetails.companyContact2 ?? '+968 26647875'}',
          ),
          _buildAddressInfo(
            'E-mail: ${modelPreviewData.companyDetails.email2 ?? 'sohar@ihthiyati.com'}',
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAddressInfo(String text) {
    return pdfTextWidget(
      text: text,
      fontSize: 10,
      color: PdfColor.fromInt(0xFF186078),
    );
  }

  static pw.Widget _createCenterHeaderSection(
    pw.MemoryImage top,
    EstimationTemplatePreviewModel estimationTemplatePreviewModel,
  ) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Image(top, width: 76, height: 76),
        pw.SizedBox(height: 4),
        pdfTextWidget(
          text: '(ALL KINDS OF HEAVY VEHICLE PARTS)',
          color: PdfColors.red,
          fontSize: 12,
        ),
        pdfTextWidget(
          text:
              'Website: ${estimationTemplatePreviewModel.companyDetails.website ?? 'NIL'}',
          color: PdfColor.fromInt(0xFF186078),
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
      ],
    );
  }

  static pw.Widget _createRightHeaderSection(
    EstimationTemplatePreviewModel estimationTemplatePreviewModel,
  ) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pdfTextWidget(
            text: Constants.translateToArabic(
              'Tel: ${estimationTemplatePreviewModel.companyDetails.companyContact1 ?? '00988-24287805'}',
            ),
            fontSize: 10,
            color: PdfColor.fromInt(0xFF186078),
          ),
          pdfTextWidget(
            text: Constants.translateToArabic(
              '(${estimationTemplatePreviewModel.companyDetails.addressLine1Ar ?? _addr1})\n(${estimationTemplatePreviewModel.companyDetails.addressLine2Ar ?? _addr2})\n(${estimationTemplatePreviewModel.companyDetails.addressLine3Ar ?? _addr3}))',
            ),
            color: PdfColor.fromInt(0xFF186078),
            fontSize: 10,
          ),
          pw.Row(
            children: [
              pdfTextWidget(
                text:
                    estimationTemplatePreviewModel.companyDetails.email ??
                    'oman@ihthiyati.com',
                fontSize: 10,
                color: PdfColor.fromInt(0xFF186078),
              ),
              pw.SizedBox(width: 4),
              pdfTextWidget(
                text: Constants.translateToArabic('E-mail:'),
                fontSize: 10,
                color: PdfColor.fromInt(0xFF186078),
              ),
            ],
          ),
          pw.Divider(height: 1, color: PdfColor.fromInt(0xFF186078)),
          pdfTextWidget(
            text: Constants.translateToArabic(
              '${estimationTemplatePreviewModel.companyDetails.addressLine2Ar ?? _add2L1}\n${estimationTemplatePreviewModel.companyDetails.address2Line2Ar ?? _add2L2}',
            ),
            color: PdfColor.fromInt(0xFF186078),
            fontSize: 10,
          ),
          pdfTextWidget(
            text: Constants.translateToArabic(
              'Tel: ${estimationTemplatePreviewModel.companyDetails.companyContact1 ?? '+968 26647875'}',
            ),
            fontSize: 10,
            color: PdfColor.fromInt(0xFF186078),
          ),
          pw.Row(
            children: [
              pdfTextWidget(
                text:
                    estimationTemplatePreviewModel.companyDetails.email2 ??
                    'oman@ihthiyati.com',
                fontSize: 10,
                color: PdfColor.fromInt(0xFF186078),
              ),
              pw.SizedBox(width: 4),
              pdfTextWidget(
                text: Constants.translateToArabic('E-mail:'),
                fontSize: 10,
                color: PdfColor.fromInt(0xFF186078),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _createCustomerDetailsSection(
    Template1Model template,
    CustomerModel customer,
    EmployeeModel? salesPerson,
    MmResourceProvider provider,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 10),
      child: pw.Column(
        children: [
          pw.Container(
            padding: pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _createCustomerInfoLeftSection(salesPerson),
                _createCustomerInfoRightSection(template, customer),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [pw.Expanded(child: _getInspection(template, provider))],
          ),
        ],
      ),
    );
  }

  static pw.Widget _createCustomerInfoLeftSection(EmployeeModel? salesPerson) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            _buildPdfTextInRowWidget(
              text1: 'Acc.No',
              text2: ': 22-10-0005',
              fontSize: 10,
              fixedWidth: 50,
              fontWeight: pw.FontWeight.bold,
            ),
            pw.SizedBox(width: 10),
            _buildPdfTextInRowWidget(
              text1: 'Term',
              text2: ': Cash',
              fontSize: 10,
              fixedWidth: 30,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
        _buildPdfTextInRowWidget(
          text1: 'Name',
          text2: ': Modern Hands Silver',
          fontSize: 10,
          fixedWidth: 50,
          fontWeight: pw.FontWeight.bold,
        ),
        _buildPdfTextInRowWidget(
          text1: 'Address',
          text2: ': ',
          fontSize: 10,
          fixedWidth: 50,
          fontWeight: pw.FontWeight.bold,
        ),
        _buildPdfTextInRowWidget(
          text1: 'Tel.No.',
          text2: ': +926464334',
          fontSize: 10,
          fixedWidth: 50,
          fontWeight: pw.FontWeight.bold,
        ),
        _buildPdfTextInRowWidget(
          text1: 'Fax No.',
          text2: ': +923213232323',
          fontSize: 10,
          fixedWidth: 50,
          fontWeight: pw.FontWeight.bold,
        ),
        _buildPdfTextInRowWidget(
          text1: 'Salesman',
          text2: ': ${salesPerson?.name ?? 'N/A'}',
          fontSize: 10,
          fixedWidth: 50,
          fontWeight: pw.FontWeight.bold,
        ),
      ],
    );
  }

  static pw.Widget _createCustomerInfoRightSection(
    Template1Model template,
    CustomerModel customer,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pdfTextWidget(
              text: 'التاريخ',
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            _buildPdfTextInRowWidget(
              text1: ' / Date',
              text2:
                  ': ${(template.salesDetails?.createdAt ?? DateTime.now()).formattedWithYMDHMS}',
              fontSize: 10,
              fixedWidth: 105,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
        pw.Row(
          children: [
            pdfTextWidget(
              text: 'فاتورة',
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            _buildPdfTextInRowWidget(
              text1: ' / Invoice #',
              text2: 'MM-${template.salesDetails?.invoice ?? 'NIL'}',
              fontSize: 10,
              fixedWidth: 105,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
        pw.Row(
          children: [
            pdfTextWidget(
              text: 'عمل',
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            _buildPdfTextInRowWidget(
              text1: ' / Business',
              text2: ': ${customer.businessName}',
              fontSize: 10,
              fixedWidth: 84,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
        pw.Row(
          children: [
            pdfTextWidget(
              text: 'اسم العميل',
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            _buildPdfTextInRowWidget(
              text1: ' / Customer Name',
              text2: ': ${customer.customerName}',
              fontSize: 10,
              fixedWidth: 84,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
        pw.Row(
          children: [
            pdfTextWidget(
              text: 'ضريبة القيمة المضافة للعملاء',
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            _buildPdfTextInRowWidget(
              text1: ' / Customer VATIN',
              text2: ': ${customer.vatNumber}',
              fontSize: 10,
              fixedWidth: 90,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _createContentFooter(
    pw.Context ctx,
    List<pw.MemoryImage> logos,
    Template1Model template,
    EstimationTemplatePreviewModel templateModel,
    List<BookedServices> filteredServices,
    double vatCharge,
    double total,
    double subTotal,
    double itemTotal,
    double discount,
    MmResourceProvider provider,
  ) {
    double itemsTotal = template.salesDetails!.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    double serviceTotal = template.salesDetails!.items.fold<double>(
      0,
      (sum, item) => item.type == "service" ? sum + item.totalPrice : sum,
    );

    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(height: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                pdfTextWidget(
                  text: 'Total after discount :  ',
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                pdfTextWidget(
                  text: 'المجموع بعد الخصم',
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ],
            ),
            pdfTextWidget(
              text: total.toStringAsFixed(2),
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ],
        ),
        pw.Divider(height: 2),
        pw.SizedBox(height: 4),
        pw.Container(
          padding: pw.EdgeInsets.all(2),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.SizedBox(height: 2),
                  textsInRowWithArabicInStart(
                    text1: 'إجمالي العناصر',
                    text2: ' / Items Total : OMR',
                    text3: '+${itemsTotal.toStringAsFixed(2)}',
                  ),
                  textsInRowWithArabicInStart(
                    text1: 'إجمالي الخدمات',
                    text2: ' / Services Total : OMR',
                    text3: '+${serviceTotal.toStringAsFixed(2)}',
                  ),
                  pw.SizedBox(height: 2),
                  textsInRowWithArabicInStart(
                    text1: 'تخفيض',
                    text2: ' / Discount : OMR',
                    text3: '-${discount.toStringAsFixed(2)}',
                  ),
                  pw.SizedBox(height: 2),
                  textsInRowWithArabicInStart(
                    text1: 'ضريبة',
                    text2: ' / Tax : OMR',
                    text3: '+${vatCharge.toStringAsFixed(2)}',
                  ),
                  pw.SizedBox(height: 2),
                  textsInRowWithArabicInStart(
                    text1: 'المجموع الفرعي',
                    text2: ' / Sub-Total : OMR',
                    text3: subTotal.toStringAsFixed(2),
                  ),
                  pw.SizedBox(height: 2),
                  textsInRowWithArabicInStart(
                    text1: 'المجموع',
                    text2: ' / Total : OMR',
                    text3: total.toStringAsFixed(2),
                    isTotal: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 4),
        pw.SizedBox(
          height: 70,
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      children: [
                        pdfTextWidget(
                          text: 'Remarks : ',
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        pdfTextWidget(
                          text: 'تم استلام البضائع المذكورة أعلاه بحالة جيدة',
                          fontSize: 8,
                        ),
                        pdfTextWidget(
                          text:
                              'Received above goods in good order and Condition',
                          fontSize: 8,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 14),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pdfTextWidget(
                          text: 'Receiver\'s Signature : ',
                          fontSize: 10,
                        ),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Divider(
                            borderStyle: pw.BorderStyle.dashed,
                            height: 4,
                          ),
                        ),
                        pdfTextWidget(text: 'توقيع المستلم ', fontSize: 10),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pdfTextWidget(
                      text: 'شركة الإحتياطي لقطع الغيار ذ.م.م',
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF186078),
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pdfTextWidget(
                          text: 'For ',
                          fontSize: 10,
                          color: PdfColor.fromInt(0xFF186078),
                        ),
                        pdfTextWidget(
                          text:
                              templateModel.companyDetails.companyName ??
                              'AL IHTHIYATI SPARE PARTS LLC',
                          fontSize: 10,
                          color: PdfColor.fromInt(0xFF186078),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.Divider(color: PdfColors.red, thickness: 1, height: 1),
        pw.SizedBox(height: 6),
        pdfLogoStripWidget(logos),
        pw.SizedBox(height: 6),
        pw.Row(
          children: [
            pdfTextWidget(
              text: 'Branches :- ',
              fontSize: 10,
              color: PdfColors.black,
            ),
            pdfTextWidget(
              text: provider.branchesList
                  .map((b) => "${b.branchName} (${b.address})")
                  .join(", ")
                  .capitalizeFirst,
              fontSize: 9,
              color: PdfColors.black,
            ),
            // pdfTextWidget(
            //   text: 'Muscat, Sohar',
            //   fontSize: 9,
            //   color: PdfColors.black,
            // ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPdfTextInRowWidget({
    required String text1,
    required String text2,
    double? fixedWidth,
    double fontSize = 10,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    bool isBothBold = false,
  }) {
    return pw.Row(
      children: [
        if (fixedWidth != null)
          pw.SizedBox(
            width: fixedWidth,
            child: pw.Text(
              text1,
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: isBothBold ? pw.FontWeight.bold : fontWeight,
              ),
            ),
          )
        else
          pw.Text(
            text1,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: isBothBold ? pw.FontWeight.bold : fontWeight,
            ),
          ),
        pw.Text(
          text2,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: isBothBold ? pw.FontWeight.bold : fontWeight,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPdfTextWidget({
    required String text,
    double fontSize = 10,
    PdfColor? color,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
  }) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  static pw.Widget _buildAmountRow(
    String arabicText,
    String englishText,
    String amount, {
    bool isTotal = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          arabicText,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Row(
          children: [
            pw.Text(
              englishText,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              amount,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static List<List<String>> _getInspectionTableData(
    Template1Model template,
    MmResourceProvider provider,
  ) {
    // Simplified for example - you'll need to implement the actual data fetching
    List<List<String>> itemsForTable = [];

    final saleModel = template.salesDetails!;
    int index = 1;

    for (var item in saleModel.items) {
      String description = "Description";
      String brand = 'Brand';

      if (item.type == 'product') {
        final product = provider.productsList.firstWhere(
          (p) => p.id == item.productId,
          orElse: () =>
              ProductModel(id: '', categoryId: '', productName: 'Unknown'),
        );

        final category = provider.productCategoryList.firstWhere(
          (c) => c.id == product.categoryId,
          orElse: () => ProductCategoryModel(productName: ''),
        );

        final brands = provider.brandsList.firstWhere(
          (c) => c.id == product.brandId,
          orElse: () => BrandModel(name: 'No Brand'),
        );

        description = category.description ?? "No Description";
        brand = brands.name;
      }

      itemsForTable.add([
        index.toString(),
        item.productName,
        brand,
        description,
        item.quantity.toString(),
        item.unitPrice.toStringAsFixed(2),
        item.totalPrice.toStringAsFixed(2),
      ]);
      index++;
    }

    return itemsForTable;
  }

  static pw.Table _getInspection(
    Template1Model template,
    MmResourceProvider provider,
  ) {
    const tableHeaders = [
      'Srl.No\nرقم سري',
      'Items\nأغراض',
      'Brand\nماركة',
      'Description\nوصف',
      'Qty\nكمية',
      'Unit Price\nسعر الوحدة',
      'Subtotal\nالمجموع',
    ];

    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder(),
      cellAlignment: pw.Alignment.center,
      headerHeight: 0,
      headerDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 1),
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
        return pw.BoxDecoration(color: PdfColors.white);
      },
      cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 10),
      rowDecoration: const pw.BoxDecoration(),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: _getInspectionTableData(template, provider),
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
          maxScale: 2.0,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: FutureBuilder<Uint8List>(
                future: () async {
                  try {
                    return await createPDF();
                  } catch (e) {
                    rethrow;
                  }
                }(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('PDF Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    return PdfPreview(
                      loadingWidget: const CircularProgressIndicator(),
                      canChangeOrientation: false,
                      canChangePageFormat: false,
                      canDebug: false,
                      allowSharing: true,
                      build: (format) => snapshot.data!,
                    );
                  }

                  return const Center(child: Text('No PDF data'));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class BookedServices {
  final double price;
  final ServiceTypeModel serviceTypeModel;

  BookedServices({required this.price, required this.serviceTypeModel});
}
