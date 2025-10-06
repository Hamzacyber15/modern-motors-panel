import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/business_models/business_profile_model.dart';
import 'package:modern_motors_panel/model/equipment_models/equipment_model.dart';
import 'package:modern_motors_panel/model/equipment_models/equipment_type_model.dart';
import 'package:modern_motors_panel/model/handling_orders/order_model.dart';
import 'package:modern_motors_panel/model/invoices/invoice_model.dart';
import 'package:modern_motors_panel/model/lease_orders/lease_order_model.dart';
import 'package:modern_motors_panel/model/package_models/package_model.dart';
import 'package:modern_motors_panel/provider/order_provider.dart';
import 'package:modern_motors_panel/provider/resource_provider.dart';
import 'package:modern_motors_panel/provider/storage_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PaymentInvoice1 extends StatefulWidget {
  final InvoiceModel invoice;
  final String? equipmentId;
  const PaymentInvoice1({required this.invoice, this.equipmentId, super.key});

  @override
  State<PaymentInvoice1> createState() => _PaymentInvoice1State();
}

class _PaymentInvoice1State extends State<PaymentInvoice1> {
  bool loading = false;
  BusinessProfileModel? business;
  PackageModel? package;
  double amount = 0;
  double vatCharge = 0;
  OrderModel? orderDetails;
  EquipmentModel? equipment;
  EquipmentTypeModel? equipmentType;
  double total = 0;
  double subTotal = 0;
  double handlingFee = 0;

  @override
  void initState() {
    super.initState();
    if (widget.invoice.type == "order" ||
        widget.invoice.type == "depositOrder") {
      amount = (widget.invoice.amount / 1.05);
      vatCharge = amount * 0.05;
      total = amount + vatCharge;
      getOrderInfo();
    } else if (widget.invoice.type == "inspectionPayment") {
      double gateMoney = 0;
      if (widget.invoice.gateMoney != null) {
        gateMoney = widget.invoice.gateMoney!;
      }
      if (widget.invoice.handlingFee != null) {
        handlingFee = widget.invoice.handlingFee!;
      }
      amount = (handlingFee + gateMoney);
      vatCharge = amount * 0.05;
      total = amount + vatCharge;
      subTotal = handlingFee + gateMoney;
    } else if (widget.invoice.type == "deposit") {
      getBusinessData();
      amount = widget.invoice.amount;
      total = amount;
    } else if (widget.invoice.type == "lease") {
      amount = (widget.invoice.amount / 1.05);
      vatCharge = amount * 0.05;
      total = amount + vatCharge;
      getEquipment();
      //amount = widget.invoice.amount;
    } else if (widget.invoice.type == "gateEntry") {
      amount = (widget.invoice.amount / 1.05);
      vatCharge = amount * 0.05;
      total = amount + vatCharge;
    } else if (widget.invoice.type == "gateEntryExtension") {
      amount = (widget.invoice.amount / 1.05);
      vatCharge = amount * 0.05;
      total = amount + vatCharge;
    }

    getBusinessData();
  }

  void getEquipment() async {
    setState(() {
      loading = true;
    });
    LeaseOrderModel? om = await Provider.of<OrderProvider>(
      context,
      listen: false,
    ).getLeaseOrderDetails(widget.invoice.orderId);
    if (om != null && om.equipmentId.isNotEmpty) {
      if (mounted) {
        equipmentType = await Provider.of<StorageProvider>(
          context,
          listen: false,
        ).getEquipmentDetailsById(om.equipmentId);
      }
    }
    setState(() {
      loading = false;
    });
  }

  void getOrderInfo() async {
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });
    OrderModel? om = await Provider.of<OrderProvider>(
      context,
      listen: false,
    ).getOrderDetails(widget.invoice.orderId);
    if (om != null) {
      orderDetails = om;
    }
    if (orderDetails!.serviceType == "indoor" ||
        orderDetails!.serviceType == "outdoor") {
      await getEquipmentInfo(orderDetails!.equipmentId);
    } else if (orderDetails!.serviceType == "package") {
      await getPackageInfo(orderDetails!.packageId);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> getEquipmentInfo(String id) async {
    equipment = await Provider.of<StorageProvider>(
      context,
      listen: false,
    ).getEquipmentById(id);
  }

  Future<void> getPackageInfo(String id) async {
    package = await Provider.of<ResourceProvider>(
      context,
      listen: false,
    ).getPackageByID(id);
  }

  void getBusinessData() async {
    setState(() {
      loading = true;
    });
    business = await Provider.of<StorageProvider>(
      context,
      listen: false,
    ).getBusinessProfileById(widget.invoice.businessId);
    setState(() {
      loading = false;
    });
  }

  Future<Uint8List> createPDF() async {
    pw.TextDirection textDirection = context.locale.languageCode == 'ar'
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;

    final img = await rootBundle.load('assets/images/logo1.png');
    final pw.Font arabicFont = await PdfGoogleFonts.notoNaskhArabicRegular();
    final pw.Font arabicFontBold = await PdfGoogleFonts.notoNaskhArabicBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        textDirection: textDirection,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
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
          child: pw.Image(image, width: 120, height: 120),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Text(
              "Modern Hands Silver",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "CR : 1215337",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "VAT NO. OM 110017273",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "SILAL MARKET-BARKA",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "SULTANTE OF OMAN",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "91117172-92478551",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "${"invoiceNo".tr()} : ${"MHS"}-${widget.invoice.invoice}",
              style: pw.TextStyle(
                //font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
              textDirection: pw.TextDirection.rtl,
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "${"invoiceDate".tr()} : ${Constants.getFormattedDateTime(widget.invoice.timeStamp.toDate(), "full")}",
              style: pw.TextStyle(
                //font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            // filteredPaymentInvoices[i].type ==
            //                                     "gateEntry"
            //                                 ? filteredPaymentInvoices[i]
            //                                             .description ==
            //                                         "trailer/Offloading"
            //                                     ? Text(
            //                                         "${"type".tr()} : ${"Safety Inspection"}")
            //                                     : Text(
            //                                         "${"type".tr()} : ${"Gate Pass"}")
            //                                 : Text(
            //                                     "${"type".tr()} : ${filteredPaymentInvoices[i].type}"),
            widget.invoice.type == "gateEntry"
                ? widget.invoice.description != null &&
                          widget.invoice.description == "trailer/Offloading"
                      ? pw.Text(
                          "${"Service".tr()} : ${"Safety Inspection"}",
                          style: pw.TextStyle(
                            //font: arabicFont,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        )
                      : pw.SizedBox(height: 2)
                : pw.SizedBox(height: 2),
            pw.SizedBox(height: 10),
            if (business != null)
              pw.Column(
                children: [
                  pw.Text(
                    business!.nameEnglish,
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text(
                    business!.nameArabic,
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text(business!.phoneNumber),
                ],
              ),

            if (equipmentType != null)
              pw.Column(
                children: [
                  pw.SizedBox(height: 10),
                  pw.Text(equipmentType!.equipmentBrand),
                  pw.Text(
                    "${"Tuk Tuk #"} ${equipmentType!.equipmentNumber}",
                    textDirection: pw.TextDirection.rtl,
                  ),
                ],
              ),

            // pw.Row(
            //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //   children: [
            //     pw.Text("invoiceNo".tr(),
            //         style: pw.TextStyle(
            //             fontWeight: pw.FontWeight.bold, fontSize: 12)),
            //     pw.SizedBox(width: 10),
            //     pw.Text(
            //       "${"MHS"}-${widget.invoice.invoice}",
            //       style: pw.TextStyle(
            //           fontSize: 12, fontWeight: pw.FontWeight.bold),
            //     )
            //   ],
            // ),
            // pw.SizedBox(
            //   width: 60,
            //   child: pw.Row(
            //     //  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //     children: [
            //       pw.Text("invoiceDate".tr(),
            //           style: pw.TextStyle(
            //               fontWeight: pw.FontWeight.bold, fontSize: 12)),
            //       pw.SizedBox(width: 10),
            //       pw.Text(
            //         Constants.getFormattedDateTime(
            //             widget.invoice.timeStamp.toDate(), "full"),
            //         style: pw.TextStyle(
            //             fontSize: 12, fontWeight: pw.FontWeight.bold),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
        //pw.SizedBox(height: 20),
        // pw.Column(
        //   // mainAxisAlignment: pw.MainAxisAlignment.start,
        //   // crossAxisAlignment: pw.CrossAxisAlignment.start,
        //   children: [],
        // ),
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            // pw.Container(
            //   decoration: pw.BoxDecoration(
            //     border: pw.Border.all(
            //       width: 1,
            //       color: PdfColors.black,
            //     ),
            //     color: PdfColors.grey,
            //   ),
            //   width: 200,
            //   height: 37,
            //   child: pw.Padding(
            //     padding: const pw.EdgeInsets.all(10),
            //     child: pw.Center(
            //       child: pw.Text("Amount Breakdown"),
            //     ),
            //   ),
            // ),
            widget.invoice.type == "order"
                ? pw.Expanded(child: getTable3())
                : widget.invoice.type == "inspectionPayment"
                ? pw.Expanded(child: getInspection())
                : pw.Container(),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            widget.invoice.type == "lease"
                ? pw.Text(
                    "Lease Payment".tr(),
                    style: const pw.TextStyle(fontSize: 12),
                  )
                : pw.Text(
                    "itemsTotal".tr(),
                    style: const pw.TextStyle(fontSize: 12),
                  ),
            pw.Text("${amount.toStringAsFixed(2).tr()} ${"OMR".tr()}"),
          ],
        ),
        pw.Divider(thickness: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("${"standardVAT".tr()} ${Constants.vat}%"),
            pw.Text(
              "${vatCharge.toStringAsFixed(2)} ${"OMR".tr()}",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Divider(thickness: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("total".tr()),
            pw.Text(
              "${total.toStringAsFixed(2)} ${"OMR".tr()}",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Divider(thickness: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("paid".tr()),
            pw.Text(
              "${total.toStringAsFixed(2)} ${"OMR".tr()}",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Divider(thickness: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("balanceDue".tr()),
            pw.Text(
              "${0} ${"OMR".tr()}",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("term1".tr(), style: const pw.TextStyle(fontSize: 8)),
            pw.Text("term2".tr(), style: const pw.TextStyle(fontSize: 8)),
            pw.Text("term3".tr(), style: const pw.TextStyle(fontSize: 8)),
            pw.Text("term4".tr(), style: const pw.TextStyle(fontSize: 8)),
            pw.Text("term5".tr(), style: const pw.TextStyle(fontSize: 8)),
            pw.Text("term6".tr(), style: const pw.TextStyle(fontSize: 8)),
            pw.Text("term7".tr(), style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          "note1".tr(),
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(fontSize: 6),
        ),
      ],
    );
  }

  List<List<String>> getItemsForTable2() {
    List<List<String>> itemsForTable = [];
    itemsForTable.add([
      "1",
      "Community Service Fee For 1st Quarter",
      "",
      "",
      "",
      "",
      "",
    ]);
    itemsForTable.add([
      "1.1",
      "Capital Reserve Fund",
      "0.0034",
      "9.66",
      "5%",
      "0.48",
      "10.14",
    ]);
    itemsForTable.add([
      "1.2",
      "General Fund",
      "0.2901",
      "824.46",
      "5%",
      "41.22",
      "865.68",
    ]);
    itemsForTable.add([
      "1.3",
      "Master Community Levy",
      "0.1370",
      "389.35",
      "5%",
      "19.47",
      "408.82",
    ]);
    return itemsForTable;
  }

  pw.Table getTable2() {
    const tableHeaders = [
      'Sr. No.',
      'Description of charges',
      'Rate per quarter',
      'Amount (AED)',
      'VAT Rate',
      'Vat Amount (AED)',
      'Gross Amount (AED)',
    ];
    return pw.TableHelper.fromTextArray(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(4),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(1),
        5: pw.FlexColumnWidth(1),
        6: pw.FlexColumnWidth(1),
      },
      border: null,
      cellAlignment: pw.Alignment.center,
      headerHeight: 0,
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 6,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: pw.BoxDecoration(
        color: PdfColors.grey,
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.centerLeft,
        6: pw.Alignment.centerLeft,
      },
      cellDecoration: (index, data, rowNum) {
        return pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColors.black, width: 1),
        );
      },
      cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 8),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey, width: .1),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: getItemsForTable2(),
    );
  }

  List<List<String>> getItemsForTable3() {
    List<List<String>> itemsForTable = [];
    orderDetails!.serviceType == "order"
        ? itemsForTable.add([
            equipment!.equipmentTitle,
            "${equipment!.equipmentTitle} ${orderDetails!.duration}",
            "1",
            widget.invoice.amount.toString(),
            widget.invoice.amount.toString(),
          ])
        : orderDetails!.serviceType == "package"
        ? itemsForTable.add([
            package!.packageTitle,
            package!.description,
            "1",
            widget.invoice.amount.toString(),
            widget.invoice.amount.toString(),
          ])
        : null;
    return itemsForTable;
  }

  List<List<String>> getInspectionTableData() {
    List<List<String>> itemsForTable = [];
    itemsForTable.add([
      "Gate Inspection",
      "Gate Inspection",
      "1",
      handlingFee.toStringAsFixed(2),
      widget.invoice.gateMoney.toString(),
      subTotal.toStringAsFixed(2),
    ]);
    return itemsForTable;
  }

  pw.Table getTable3() {
    const tableHeaders = [
      'Item Name',
      'Description',
      'Qty',
      'Price',
      "Subtotal",
    ];
    return pw.TableHelper.fromTextArray(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(1),
      },
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerHeight: 0,
      headerDecoration: pw.BoxDecoration(
        color: PdfColors.grey400,
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 6,
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
          border: pw.Border.all(color: PdfColors.black, width: 1),
        );
      },
      cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 8),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey, width: .1),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: getItemsForTable3(),
    );
  }

  pw.Table getInspection() {
    const tableHeaders = [
      'Item Name',
      'Description',
      'Qty',
      'Inspection Fee',
      'Gate Pass Fee',
      "Subtotal",
    ];
    return pw.TableHelper.fromTextArray(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(1),
      },
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerHeight: 0,
      headerDecoration: pw.BoxDecoration(
        color: PdfColors.grey400,
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 6,
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
          border: pw.Border.all(color: PdfColors.black, width: 1),
        );
      },
      cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 8),
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
    return Scaffold(
      appBar: AppBar(title: Text("${"MHS"} - ${widget.invoice.invoice}")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : InteractiveViewer(
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
            ),
    );
  }
}
