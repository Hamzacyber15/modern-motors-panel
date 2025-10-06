import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/corner_borders_box.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/estimation_template_widget.dart';

class MaintenanceTemplate1Body extends StatelessWidget {
  final VoidCallback onHeaderLogoTap;
  final VoidCallback onBottomAddress;
  final VoidCallback onTaxCardTap;
  final VoidCallback onBranchTap;
  final EstimationTemplatePreviewModel estimationTemplatePreviewModel;

  const MaintenanceTemplate1Body({
    super.key,
    required this.onBottomAddress,
    required this.estimationTemplatePreviewModel,
    required this.onHeaderLogoTap,
    required this.onTaxCardTap,
    required this.onBranchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        InkWell(
          onTap: onHeaderLogoTap,
          child:
              estimationTemplatePreviewModel.headerLogo == null ||
                  estimationTemplatePreviewModel.headerLogo!.isEmpty
              ? Column(
                  children: [
                    Image.asset(
                      'assets/images/logo1.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 4),
                    Image.asset(
                      'assets/images/logo2.png',
                      width: 150,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ],
                )
              : Image.network(
                  estimationTemplatePreviewModel.headerLogo!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txt('Invoice', fw: FontWeight.w400, fontSize: 16),
              txt('فاتورة', fw: FontWeight.w400, fontSize: 16),
            ],
          ),
        ),
        10.h,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: onBranchTap,
                child: FlutterCornerBorderBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(
                        '${estimationTemplatePreviewModel.companyDetails.branchLine1 ?? 'Parts Cash Sales - Sohar Truck Branch - IHE'}\n${estimationTemplatePreviewModel.companyDetails.branchLine2 ?? 'NTERNATIONAL SILVER'}\nMr.MUNEER ALI',
                        fw: FontWeight.w700,
                      ),
                      const SizedBox(height: 4),
                      txt(
                        'Ph: ${estimationTemplatePreviewModel.companyDetails.companyContact1 ?? 3131212121}',
                        fw: FontWeight.bold,
                      ),
                      txt(
                        'VIN: ${estimationTemplatePreviewModel.companyDetails.vinNumber ?? 'L0014157'}',
                        fw: FontWeight.bold,
                        fontSize: 10,
                      ),
                      const SizedBox(height: 4),
                      kvRow(
                        'Acct.No:',
                        estimationTemplatePreviewModel
                                .bank1Details
                                .accountNumber ??
                            '0M1100023614',
                        ar: 'رقم الحساب',
                      ),
                      kvRow(
                        'Customer VATIN:',
                        '',
                        ar: 'رقم ضريبة القيمة المضافة للعميل',
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kvRow('Invoice#:', '100234', ar: 'رقم الفاتورة'),
                    kvRow('Business Name:', 'ABC Industries', ar: 'اسم العمل'),
                    kvRow('Customer Name:', 'John Doe', ar: 'اسم العميل'),
                    kvRow('Vehicle Number:', 'OM-1234', ar: 'رقم المركبة'),
                    kvRow('Vehicle Model:', '2022', ar: 'طراز السيارة'),
                    kvRow('Vehicle Color:', 'White', ar: 'لون المركبة'),
                    kvRow('Reg In:', 'Oman', ar: 'بلد التسجيل'),
                    kvRow(
                      'Date & Time:',
                      '2025-09-09 10:30:00',
                      ar: 'التاريخ والوقت',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        kvRow(
          'Manufacturer:',
          '',
          ar: 'الشركة المصنعة',
          fontWeight: FontWeight.w700,
        ),
        InspectionTable(),
        (context.height * 0.3).dh,
        ContentFooter(
          estimationTemplatePreviewModel: estimationTemplatePreviewModel,
          onTaxCardTap: onTaxCardTap,
          onBottomAddress: onBottomAddress,
          onBottomLeftLogo: onHeaderLogoTap,
          onBottomRightLogo: onHeaderLogoTap,
        ),
      ],
    );
  }
}

class InspectionTable extends StatelessWidget {
  const InspectionTable({super.key});

  @override
  Widget build(BuildContext context) {
    final headers = const [
      'رقم سري\nSrL.',
      'أغراض\nItems',
      'وصف\nDescription',
      'كمية\nQty',
      'سعر الوحدة\nUnit Price',
      'المجموع\nSubtotal',
    ];

    final rows = const [
      ["1", "Shoes - Test 5", "sheossss", "1", "50.00", "50.00"],
      [
        "2",
        "Watches - Test 1",
        "This category is for watches",
        "19",
        "16.00",
        "304.00",
      ],
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1), // SrL.
          1: FlexColumnWidth(1.6), // Items
          2: FlexColumnWidth(2.0), // Description
          3: FlexColumnWidth(1.2), // Qty
          4: FlexColumnWidth(1.8), // Unit Price
          5: FlexColumnWidth(1.8), // Subtotal
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          /// Header Row
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: const Border(
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            children: headers.asMap().entries.map((entry) {
              final index = entry.key;
              final text = entry.value;

              TextAlign align;
              if (index == 0 || index == 3 || index == 4 || index == 5) {
                align = TextAlign.center;
              } else {
                align = TextAlign.left;
              }

              return Container(
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Text(
                  text,
                  textAlign: align,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),

          /// Data Rows
          ...rows.map((row) {
            return TableRow(
              children: row.asMap().entries.map((entry) {
                final index = entry.key;
                final cell = entry.value;

                TextAlign align;
                if (index == 0 || index == 3 || index == 4 || index == 5) {
                  align = TextAlign.center;
                } else {
                  align = TextAlign.left;
                }

                return Container(
                  padding: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  child: Text(
                    cell,
                    textAlign: align,
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class ContentFooter extends StatelessWidget {
  final EstimationTemplatePreviewModel estimationTemplatePreviewModel;
  final VoidCallback onBottomAddress;
  final VoidCallback onBottomLeftLogo;
  final VoidCallback onBottomRightLogo;
  final VoidCallback onTaxCardTap;

  const ContentFooter({
    super.key,
    required this.estimationTemplatePreviewModel,
    required this.onBottomAddress,
    required this.onBottomLeftLogo,
    required this.onBottomRightLogo,
    required this.onTaxCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Services + Totals
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Left: Services
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  _RowText(text1: "Service", text2: "Price", bold: true),
                  _RowText(text1: "Repair", text2: "25.00"),
                  _RowText(text1: "Washing", text2: "15.00"),
                ],
              ),

              /// Right: Totals
              SizedBox(
                width: context.width * 0.22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    _TripleRowText(
                      text1: "Services Total",
                      text2: "إجمالي الخدمات",
                      text3: "+40.00",
                    ),
                    _TripleRowText(
                      text1: "Items Total",
                      text2: "إجمالي العناصر",
                      text3: "+80.00",
                    ),
                    _TripleRowText(
                      text1: "Discount",
                      text2: "تخفيض",
                      text3: "-10.00",
                    ),
                    _TripleRowText(
                      text1: "Tax",
                      text2: "ضريبة",
                      text3: "+5.00",
                    ),
                    _TripleRowText(
                      text1: "Sub-Total",
                      text2: "المجموع الفرعي",
                      text3: "115.00",
                    ),
                    _TripleRowText(
                      text1: "Total",
                      text2: "المجموع",
                      text3: "115.00",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        /// Customer & Supervisor confirmation
        SizedBox(
          height: 90,
          child: Row(
            children: [
              /// Left Side
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'I hereby confirm receipt of all items refereed to above in good sound and serviceable condition and agree to all the terms printed on the rear of the invoice',
                      style: TextStyle(fontSize: 10),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('توقيع العميل', style: TextStyle(fontSize: 10)),
                        Text(
                          'Signature of Customer',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              /// Right Side
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'أؤكد بموجب هذا استلام جميع العناصر المشار إليها أعلاه في حالة جيدة وسليمة وقابلة للخدمة وأوافق على جميع الشروط المطبوعة على ظهر الفاتورة',
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: const [
                            Text('شكرًا لك', style: TextStyle(fontSize: 10)),
                            Text('Thank you', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text('مشرف المبيعات', style: TextStyle(fontSize: 10)),
                        Text(
                          'Sales Supervisor',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, color: Colors.black),

        /// Logos & Company Info
        Row(
          children: [
            InkWell(
              onTap: onBottomLeftLogo,
              child:
                  estimationTemplatePreviewModel.headerLogo == null ||
                      estimationTemplatePreviewModel.headerLogo!.isEmpty
                  ? Image.asset(
                      'assets/images/logo1.png',
                      width: 34,
                      height: 34,
                    )
                  : Image.network(
                      estimationTemplatePreviewModel.headerLogo!,
                      width: 34,
                      height: 34,
                      // fit: BoxFit.contain,
                    ),
            ),
            Expanded(
              child: InkWell(
                onTap: onBottomAddress,
                child: Column(
                  children: [
                    Text(
                      "${estimationTemplatePreviewModel.companyDetails.companyNameAr ?? 'شركة المعدات الثقيلة الدولية ذ.م.م،'} "
                      "هاتف: ${Constants.translateToArabic(estimationTemplatePreviewModel.companyDetails.companyContact2 ?? '٢٤٥٢٧٦٠٠')}, "
                      "فاكس: ${Constants.translateToArabic(estimationTemplatePreviewModel.companyDetails.faxNumber ?? '٢٤٥٢٧٦٤١')}, "
                      "السجل التجاري رقم:${Constants.translateToArabic(estimationTemplatePreviewModel.companyDetails.crNumber ?? '١/٧٣٤٩٣/٨')}, ",
                      style: const TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      "${estimationTemplatePreviewModel.companyDetails.companyName ?? 'International Heavy Equipment LLC P.O, BOX 800, Muscat 111, Sultanate of Oman,'}Tel ${estimationTemplatePreviewModel.companyDetails.companyContact2 ?? '24 527 600'}, Fax: ${estimationTemplatePreviewModel.companyDetails.faxNumber ?? '24 527 641'} , C.R. No. ${estimationTemplatePreviewModel.companyDetails.crNumber ?? '1/73493/8'} e-mail: ${estimationTemplatePreviewModel.companyDetails.email ?? 'Ihe@Ihe-oman.com'}, ${estimationTemplatePreviewModel.companyDetails.website ?? 'www.Ihe-oman.com'}",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: onBottomRightLogo,
              child:
                  estimationTemplatePreviewModel.headerLogo == null ||
                      estimationTemplatePreviewModel.headerLogo!.isEmpty
                  ? Image.asset(
                      'assets/images/logo1.png',
                      width: 34,
                      height: 34,
                    )
                  : Image.network(
                      estimationTemplatePreviewModel.headerLogo!,
                      width: 34,
                      height: 34,
                      // fit: BoxFit.contain,
                    ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        /// Red Box
        Container(
          width: double.infinity,
          height: 20,
          color: Colors.red.shade700,
        ),
        const SizedBox(height: 4),

        /// VAT Info
        InkWell(
          onTap: onTaxCardTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'VATIN: ${estimationTemplatePreviewModel.companyDetails.vatNo ?? 'OM1200094685'} | Tax Card No: ${estimationTemplatePreviewModel.companyDetails.taxCardNumber ?? '9308980'}',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
              Text(
                'رقم الشهادة: ${estimationTemplatePreviewModel.companyDetails.taxCardNumber ?? '9308980'}  | ${estimationTemplatePreviewModel.companyDetails.vatNo ?? 'OM1200094685'}  : رقم تسجيل ضريبة القيمة المضافة',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        /// Bank & Page Info
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.blue.shade50,
              ),
              child: Text(
                'Bank Details: ${estimationTemplatePreviewModel.bank1Details.bankName ?? 'Sohar International Bank'}, A/C No: ${estimationTemplatePreviewModel.bank1Details.accountNumber ?? 00103002714}',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'For terms & conditions, please refer overleaf/T&C page',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Text('Page: 1', style: TextStyle(fontSize: 9)),
          ],
        ),
      ],
    );
  }
}

/// Helper Widgets
class _RowText extends StatelessWidget {
  final String text1, text2;
  final bool bold;

  const _RowText({required this.text1, required this.text2, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        txt(text1, fw: bold ? FontWeight.w700 : FontWeight.w400),
        50.w,
        txt(text2, fw: bold ? FontWeight.w700 : FontWeight.w400),
      ],
    );
  }
}

class _TripleRowText extends StatelessWidget {
  final String text1, text2, text3;

  const _TripleRowText({
    required this.text1,
    required this.text2,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        txt(text1, fontSize: 12, fw: FontWeight.w400),
        txt(text2, fontSize: 12, fw: FontWeight.w400, align: TextAlign.end),
        txt(text3, fontSize: 12, fw: FontWeight.w400),
      ],
    );
  }
}
