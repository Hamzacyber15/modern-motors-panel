import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';

Widget txt(
  String text, {
  double fontSize = 12,
  FontWeight? fw,
  Color? color,
  TextAlign? align,
  double? height,
  TextOverflow? overflow,
  int? maxLines,
}) {
  return Text(
    text,
    textAlign: align,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fw,
      fontFamily: 'IBM Plex Sans Arabic',
      color: color,
      height: height,
    ),
  );
}

Widget kvRow(
  String k,
  String v, {
  String? ar,
  FontWeight fontWeight = FontWeight.w400,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      txt(k, fontSize: 12, fw: fontWeight),
      txt(v, fontSize: 12, fw: fontWeight),
      if (ar != null) txt(ar, fontSize: 12, fw: fontWeight),
    ],
  );
}

Widget kv(
  String k,
  String v, {
  double fontSize = 12,
  FontWeight? fw1,
  FontWeight? fw2,
  double gap = 8,
  double? fixedKeyWidth,
}) {
  final key = txt(k, fontSize: fontSize, fw: fw1 ?? FontWeight.w400);
  final val = txt(v, fontSize: fontSize, fw: fw2 ?? FontWeight.w400);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (fixedKeyWidth != null)
        SizedBox(width: fixedKeyWidth, child: key)
      else
        key,
      SizedBox(width: gap),
      Flexible(child: val),
    ],
  );
}

Widget divider([double thickness = 1.0]) =>
    Divider(thickness: thickness, height: thickness + 8, color: Colors.black);

Widget header(
  BuildContext context, {
  required VoidCallback onLogoTap,
  required VoidCallback onCompanyDetailsTap,
  required String companyName,
  companyAddress,
  companyContact1,
  companyContact2,
  required EstimationTemplatePreviewModel model,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
        onTap: onLogoTap,
        child: model.headerLogo == null || model.headerLogo!.isEmpty
            ? Image.asset(
                'assets/images/logo1.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              )
            : Image.network(
                model.headerLogo!,
                //'https://firebasestorage.googleapis.com/v0/b/erptest-466fd.firebasestorage.app/o/attachments%2F1757499275678H9Px7blvMsVp0XEsilPV9S1VzeT2.webp?alt=media&token=bf6ff576-def1-4115-917e-6546d403445d',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
      ),
      InkWell(
        onTap: onCompanyDetailsTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txt(companyName, fontSize: 12, fw: FontWeight.w700),
            txt(
              companyAddress,
              fontSize: 12,
              color: Colors.grey[700],
              fw: FontWeight.w400,
            ),
            txt(
              'Tel: $companyContact1 | Tel: $companyContact2',
              fontSize: 12,
              color: Colors.grey[700],
              fw: FontWeight.w400,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget metaTop(String companyName, String address) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txt(companyName, fontSize: 16, fw: FontWeight.bold),
            const SizedBox(height: 2),
            txt(address, fontSize: 12),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kv('DATE', '01/01/2025'),
          kv('Customer', 'Zahra'),
          kv('Cust Contact', '+9223231312'),
          kv('Salesman', 'Hamza'),
          kv('Estimate #', '12345'),
        ],
      ),
    ],
  );
}

List<List<String>> getInspectionTableData() {
  List<List<String>> data = [
    ['1', 'Product A', 'Brand X', 'Category 1', '2', '10.00', '20.00'],
    ['2', 'Product B', 'Brand Y', 'Category 2', '3', '15.00', '45.00'],
  ];
  return data;
}

List<List<String>> getServicesTableData() {
  List<List<String>> data = [
    ['1', 'Service A', 'Description A', '1', '30.00', '30.00'],
    ['2', 'Service B', 'Description B', '2', '20.00', '40.00'],
  ];
  return data;
}

Widget table(
  List<String> headers,
  List<List<String>> rows, {
  EdgeInsets padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
}) {
  final borderSide = BorderSide(color: Colors.black, width: 1.2);
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    columnWidths: {
      0: const IntrinsicColumnWidth(), // Srl
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          border: Border(top: borderSide, bottom: borderSide),
        ),
        children: [
          for (final h in headers)
            Padding(
              padding: padding.copyWith(top: 8, bottom: 8),
              child: txt(h, fontSize: 12, fw: FontWeight.w700),
            ),
        ],
      ),
      // body
      ...List.generate(rows.length, (r) {
        final row = rows[r];
        return TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: [
            for (final cell in row)
              Padding(
                padding: padding,
                child: txt(cell, fontSize: 12, fw: FontWeight.w400),
              ),
          ],
        );
      }),
    ],
  );
}

Widget totals() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          txt('Total amount', fontSize: 12, fw: FontWeight.w400),
          const SizedBox(width: 10),
          txt('4000', fontSize: 12, fw: FontWeight.w400),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              kv('Items', '+OMR343', fixedKeyWidth: 80),
              kv('Services', '+OMR50', fixedKeyWidth: 90),
              kv('Tax', '+OMR40', fixedKeyWidth: 90),
              kv('Sub-Total', '500', fixedKeyWidth: 90),
              kv('Total', '500', fixedKeyWidth: 90),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                kv(
                  'Service',
                  'Price',
                  fixedKeyWidth: 80,
                  fw1: FontWeight.bold,
                  fw2: FontWeight.bold,
                ),
                ...List.generate(2, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: kv(
                      'Service ${i + 1}',
                      '30.00',
                      fontSize: 12,
                      fixedKeyWidth: 100,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget terms() {
  Widget para(String t1, String t2) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          txt(t1, fontSize: 14, fw: FontWeight.w700),
          const SizedBox(height: 2),
          txt(t2, fontSize: 14, height: 1.25, fw: FontWeight.w400),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      txt(
        'TERMS AND CONDITIONS OF SALE',
        align: TextAlign.center,
        fontSize: 16,
        fw: FontWeight.w700,
      ),
      para('1. Term 1', 'Description for term 1'),
      para('2. Term 2', 'Description for term 2'),
      SizedBox(height: 2),
    ],
  );
}

final logoPaths = const [
  'assets/images/1 (1).jpeg',
  'assets/images/1 (1).png',
  'assets/images/1 (2).png',
  'assets/images/1 (3).png',
];

Widget logoStrip() {
  return Wrap(
    spacing: 12,
    runSpacing: 8,
    children: [
      for (final p in logoPaths)
        Image.asset(
          p,
          width: 64,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return const SizedBox(width: 64, height: 40);
          },
        ),
    ],
  );
}

Widget footer(
  VoidCallback onBank1,
  VoidCallback onBank2,
  EstimationTemplatePreviewModel model,
) {
  Widget bankCol(String title, List<String> lines, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          txt('Banks', fontSize: 12, fw: FontWeight.w400),
          txt(title, fontSize: 12, fw: FontWeight.w400),
          for (final l in lines) txt(l, fontSize: 12, fw: FontWeight.w400),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          bankCol(model.bank1Details.bankName ?? 'EMLAK KATILIM BANKASI', [
            'A/C-No:${model.bank1Details.accountNumber ?? 540733 - 101}\nIBAN : ${model.bank1Details.ibanNumber ?? ' TR70 0021 1000 0005 4073 3001 01'}',
            (model.bank1Details.swiftNumber ?? 'SWIFT KODU: EMLATRISXXX'),
          ], onBank1),
          bankCol(model.bank2Details.bankName ?? 'EMLAK KATILIM BANKASI', [
            'A/C-No:${model.bank2Details.accountNumber ?? 540733 - 101}\nIBAN: ${model.bank2Details.ibanNumber ?? ' TR70 0021 1000 0005 4073 3001 01'}',
            (model.bank2Details.swiftNumber ?? 'SWIFT KODU: EMLATRISXXX'),
          ], onBank2),
        ],
      ),
      const SizedBox(height: 4),
      logoStrip(),
    ],
  );
}
