import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/model/terms/terms_of_sale_model.dart';
import 'package:modern_motors_panel/model/vendor/ventor_logos_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/load_header_logo.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_terms_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_in_row_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_logo_strip_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class EstimationInvoice extends StatefulWidget {
  final Template1Model template1Model;

  const EstimationInvoice({required this.template1Model, super.key});

  @override
  State<EstimationInvoice> createState() => _MaintenanceTemplate2State();
}

class _MaintenanceTemplate2State extends State<EstimationInvoice> {
  bool loading = false;
  late Future<void> _initializationFuture;
  List<VendorLogosModel> allLogos = [];
  EstimationTemplatePreviewModel? estimationTemplatePreviewModel;
  List<ProductCategoryModel> productsCategories = [];
  List<ServiceTypeModel> services = [];
  List<TermsAndConditionsOfSalesModel> allTermAndConditions = [];
  late double vatCharge;
  late double discountAmount;
  late double total;
  late double subTotal;
  late double itemTotal;

  late List<BookedServices> filteredServices;
  //late EmployeeModel? salesPerson;
  late CustomerModel customer;
  //MmtrucksModel? trucks;

  List<dynamic> imagesData = [];

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
    final termsAndConditions = await DataFetchService.fetchTerms();
    allTermAndConditions = termsAndConditions.terms;
    final provider = context.read<MmResourceProvider>();
    _calculateAmounts();
    // salesPerson =
    // widget.template1Model.salesDetails!.createBy == Constants.adminId ?
    // "Admin" :
    // provider.getEmployeeByID(
    //   widget.template1Model.salesDetails!.createBy,
    // );
    // debugPrint('salesPerson: ${salesPerson?.email ?? 'fgdg'}');
    customer = provider.customersList.firstWhere(
      (item) => item.id == widget.template1Model.salesDetails!.customerName,
    );
    debugPrint(
      'customer name=: ${widget.template1Model.salesDetails!.customerName}',
    );

    debugPrint('customer List: ${provider.customersList}');
    // trucks = provider.getTruckByID(
    //   widget.template1Model.salesDetails!.truckId!,
    // );

    filteredServices = await _loadFilteredServices(provider);

    if (provider.termsOfSalesModel != null) {
      //termsAndConditions = await DataFetchService.fetchTerms();

      // provider.termsOfSalesModel?.terms
      //         .where((terms) => terms.status == 'active')
      //         .toList() ??
      [];
    }

    if (provider.logosList != null) {
      allLogos =
          provider.logosList?.logos
              .where((logo) => logo.status == 'active')
              .toList() ??
          [];
    }

    // final vendorLogos = VendorLogosListModel(
    //   logos: [
    //     VendorLogosModel(
    //       imgUrl:
    //           "https://images.unsplash.com/photo-1620288627223-53302f4e8c74?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    //       status: "active",
    //       createdAt: Timestamp.now(),
    //     ),
    //     VendorLogosModel(
    //       imgUrl:
    //           "https://images.unsplash.com/photo-1620288627223-53302f4e8c74?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    //       status: "active",
    //       createdAt: Timestamp.now(),
    //     ),
    //     VendorLogosModel(
    //       imgUrl:
    //           "https://images.unsplash.com/photo-1620288627223-53302f4e8c74?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    //       status: "active",
    //       createdAt: Timestamp.now(),
    //     ),
    //   ],
    // );

    // allLogos.addAll(vendorLogos.logos);

    debugPrint('provider.logosList ${provider.logosList!.toMap()}');
    debugPrint('provider.logosList ${provider.logosList!.logos}');

    estimationTemplatePreviewModel = provider.estimationTemplatePreviewModel
        .firstWhere((tem) => tem.type == 'Estimation');
    debugPrint("${"Estimate"} : ${estimationTemplatePreviewModel!.toMap()}");
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
    //final topLogo = await rootBundle.load('assets/images/logo1.png');
    final pw.Font regular = await PdfGoogleFonts.iBMPlexSansArabicRegular();
    final pw.Font bold = await PdfGoogleFonts.iBMPlexSansArabicBold();
    // final logos = await loadLogos(logoPaths);
    final topLogoBytes = await loadHeaderLogo(
      estimationTemplatePreviewModel?.headerLogo ?? 'assets/images/mm_logo.png',
    );
    final topLogoImage = pw.MemoryImage(topLogoBytes);
    final logos = await convertVendorLogos(allLogos);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        //maxPages: 100,
        textDirection: textDirection,
        // textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: regular,
          bold: bold,
        ).copyWith(defaultTextStyle: pw.TextStyle(lineSpacing: 0, height: 1)),
        pageFormat: PdfPageFormat.a3,
        margin: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        // pageTheme: pageTheme(topLogo, regular, bold, textDirection),
        build: (pw.Context ctx) => [contentBody(ctx), addTerms()],
        header: (ctx) => contentHeader(ctx, topLogoImage),
        footer: (ctx) => contentFooter(ctx, logos),
      ),
    );
    return pdf.save();
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

  pw.Widget contentBody(pw.Context ctx) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 20),
        pw.Padding(
          padding: pw.EdgeInsets.only(left: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pdfTextWidget(
                        text: 'Modern Motors',
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      pw.SizedBox(height: 2),
                      pdfTextWidget(text: 'Oman - Barka', fontSize: 10),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 2),
                      pdfTextInRowWidget(
                        context: context,
                        text1: 'DATE',
                        text2: widget
                            .template1Model
                            .salesDetails!
                            .createdAt
                            .formattedWithYMDHMS,
                        fontSize: 10,
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pdfTextInRowWidget(
                            context: context,
                            text1: 'Customer',
                            text2: customer.customerName,
                            fontSize: 10,
                          ),
                          pdfTextInRowWidget(
                            context: context,
                            text1: 'Cust Contact',
                            text2: customer.contactNumber,
                            fontSize: 10,
                            fixedWidth: 80,
                          ),
                        ],
                      ),
                      // pdfTextInRowWidget(
                      //   context: context,
                      //   text1: 'Salesman',
                      //   text2: salesPerson?.emergencyName ?? 'N/A',
                      //   fontSize: 10,
                      // ),
                      // pdfTextInRowWidget(
                      //   context: context,
                      //   text1: 'Email',
                      //   text2: salesPerson?.email ?? 'N/A',
                      //   fontSize: 10,
                      // ),
                      pw.SizedBox(height: 16),
                      pdfTextInRowWidget(
                        context: context,
                        text1:
                            widget.template1Model.salesDetails!.status ==
                                "estimate"
                            ? 'Estimate #'
                            : widget.template1Model.salesDetails!.status ==
                                  "draft"
                            ? 'Draft #'
                            : 'Invoice #',
                        text2: widget.template1Model.salesDetails!.invoice
                            .toString(),
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(children: [pw.Expanded(child: getInspection())]),
              pw.Divider(thickness: 1),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pdfTextWidget(text: 'Items Total', fontSize: 12),
                  pw.SizedBox(width: 10),
                  pdfTextWidget(
                    text: itemTotal.toStringAsFixed(2),
                    fontSize: 10,
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: pw.EdgeInsets.all(2),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          // pw.SizedBox(height: 10),
                          pw.SizedBox(height: 2),
                          pdfTextInRowWidget(
                            // fixedWidth: 90,
                            context: context,
                            text1: 'Items',
                            text2: '+${itemTotal.toStringAsFixed(2)}',
                          ),
                          pw.SizedBox(height: 2),
                          pdfTextInRowWidget(
                            fixedWidth: 90,
                            context: context,
                            text1: 'Discount',
                            text2: '+${discountAmount.toStringAsFixed(2)}',
                          ),
                          pw.SizedBox(height: 2),
                          pdfTextInRowWidget(
                            fixedWidth: 90,
                            context: context,
                            text1: 'Tax',
                            text2: '+${vatCharge.toStringAsFixed(2)}',
                          ),
                          pw.SizedBox(height: 2),
                          pdfTextInRowWidget(
                            fixedWidth: 90,
                            context: context,
                            text1: 'Sub-Total',
                            text2: subTotal.toStringAsFixed(2),
                          ),
                          pw.SizedBox(height: 2),
                          pdfTextInRowWidget(
                            fixedWidth: 90,
                            context: context,
                            text1: 'Total',
                            text2: total.toStringAsFixed(2),
                          ),
                          pw.SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget addTerms() {
    return pw.ListView(
      children: [
        pw.Container(
          width: context.width,
          child: pdfTextWidget(
            textAlign: pw.TextAlign.center,
            text: 'TERMS AND CONDITIONS OF SALE',
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        ...List.generate(
          allTermAndConditions.length,
          (index) => pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pdfTermsWidget(
              context: context,
              text1: '${index + 1}. ${allTermAndConditions[index].title}',
              text2: allTermAndConditions[index].description,
            ),
          ),
        ),
        pw.SizedBox(height: 2),
      ],
    );
  }

  pw.Widget contentHeader(pw.Context ctx, pw.MemoryImage topLogoImage) {
    // final topLogoImage = tLogo.buffer.asUint8List();
    //final top = pw.MemoryImage(topLogoImage);

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Image(topLogoImage, width: 100, height: 100),
            pw.SizedBox(height: 4),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pdfTextWidget(
              text:
                  estimationTemplatePreviewModel?.companyDetails.companyName ??
                  'Sohat-Sultanate of Oman Al Ouhi Ind, Area 2',
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            pdfTextWidget(
              text:
                  estimationTemplatePreviewModel
                      ?.companyDetails
                      .companyAddress ??
                  'P.O. BOX: 1109, Postal Code 111 Ghala Ind, Area\nMuscat - Sultanate of Oman',
              fontSize: 10,
              color: PdfColors.grey600,
            ),
            pdfTextWidget(
              text:
                  'Tel: ${estimationTemplatePreviewModel?.companyDetails.companyContact1 ?? 00988 - 24287805} | Tel: ${estimationTemplatePreviewModel?.companyDetails.companyContact1 ?? 968 - 26647875}',
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget contentFooter(pw.Context ctx, logos) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pdfTextWidget(text: 'Banks', fontSize: 10),
                pdfTextWidget(
                  text:
                      estimationTemplatePreviewModel?.bank1Details.bankName ??
                      'EMLAK KATILIM BANKASI ',
                  fontSize: 10,
                ),
                pdfTextWidget(
                  text:
                      'A/C-No (OMR) :${estimationTemplatePreviewModel?.bank1Details.accountNumber ?? 540733 - 101}\nIBAN (OMR) : ${estimationTemplatePreviewModel?.bank1Details.ibanNumber ?? 'TR70 0021 1000 0005 4073 3001 01'} ',
                  fontSize: 10,
                ),
                pdfTextWidget(
                  text:
                      'SWIFT KODU: ${estimationTemplatePreviewModel?.bank1Details.swiftNumber ?? 'EMLATRISXXX'} ',
                  fontSize: 10,
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pdfTextWidget(text: 'Banks', fontSize: 10),
                pdfTextWidget(
                  text:
                      estimationTemplatePreviewModel?.bank2Details.bankName ??
                      'KUVEYT TÜRK KATILIM BANKASI ',
                  fontSize: 10,
                ),
                pdfTextWidget(
                  text:
                      "A/C-No (OMR): ${estimationTemplatePreviewModel?.bank2Details.accountNumber ?? 519671 - 111}\nIBAN (OMR) : ${estimationTemplatePreviewModel?.bank2Details.ibanNumber ?? 'TR07 0020 5000 0005 1967 1001 11'}",
                  fontSize: 10,
                ),
                pdfTextWidget(
                  text:
                      'SWIFT KODU: ${estimationTemplatePreviewModel?.bank2Details.swiftNumber ?? 'KTEFTRISXXX'}',
                  fontSize: 10,
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pdfLogoStripWidget(logos),
      ],
    );
  }

  List<List<String>> getInspectionTableData() {
    List<List<String>> itemsForTable = [];

    final provider = context.read<MmResourceProvider>();

    final saleModel = widget.template1Model.salesDetails;
    int index = 1;

    for (var item in saleModel!.items) {
      String description = "Description";
      String brand = 'Brand';

      if (item.type == 'product') {
        final product = provider.productsList.firstWhere(
          (p) => p.id == item.productId,
          orElse: () =>
              ProductModel(id: '', categoryId: '', productName: 'Unknown'),
        );

        debugPrint('Matched Product JSON from items: ${product.toJson()}');

        debugPrint('item.productId: ${item.productName}');

        debugPrint('productid ${product.id}');
        debugPrint('product ${product.categoryId}');
        debugPrint('brandID::: ${product.brandId}');

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
        // product.image ?? '',
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

  pw.Table getInspection() {
    const tableHeaders = [
      'Srl.No',
      'Items',
      'Brand',
      //'Image',
      'Description',
      'Qty',
      'Unit Price',
      'Subtotal',
    ];

    return pw.TableHelper.fromTextArray(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(1),
        5: pw.FlexColumnWidth(1),
      },
      border: pw.TableBorder(
        // bottom: pw.BorderSide(color: PdfColors.black, width: 1),
      ),
      cellAlignment: pw.Alignment.center,
      headerHeight: 0,
      headerDecoration: pw.BoxDecoration(
        // color: PdfColors.grey300,
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 1),
          top: pw.BorderSide(color: PdfColors.black, width: 1),
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
        // border: pw.Border(
        //   left: pw.BorderSide(color: PdfColors.black, width: 1),
        //   right: pw.BorderSide(color: PdfColors.black, width: 1),
        // ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: getInspectionTableData(),
      // cellBuilder: (index, data, rowNum) {
      //   if (index == 2) {
      //     return pw.Image(
      //       imagesData.elementAt(rowNum - 1),
      //       width: 50,
      //       height: 50,
      //     );
      //   }
      //   return pw.Text(data);
      // },
      // TODO:
      // cellBuilder: (index, data, rowNum) {
      //   // productNetworkImages
      //   // pw.ImageProvider image = productNetworkImages[data] as pw.ImageProvider;
      //   // return pw.Image(image);
      //   // if (index == 3) {
      //   //   if (data != null) {
      //   //     return data;
      //   //   } else {
      //   //     //return pw.Text("n/a");
      //   //   }
      //   // }
      // },
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
          debugPrint('===Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1,
          maxScale: 2.5,
          child: Center(
            child: SizedBox(
              width: context.width * 0.8,
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
