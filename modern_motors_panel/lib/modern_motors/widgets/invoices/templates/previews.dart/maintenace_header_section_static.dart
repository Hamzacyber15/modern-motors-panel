import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/estimation_template_widget.dart';

class MaintenanceHeaderSectionStatic extends StatelessWidget {
  final VoidCallback onCompanyTapEn;
  final VoidCallback onCompanyTapAr;
  final VoidCallback onLogoTap;
  final VoidCallback onWebsiteTap;
  final EstimationTemplatePreviewModel? template;

  const MaintenanceHeaderSectionStatic({
    super.key,
    required this.onLogoTap,
    required this.onCompanyTapAr,
    required this.onCompanyTapEn,
    required this.onWebsiteTap,
    required this.template,
  });

  static const _topLogo = 'assets/images/logo1.png';
  static const _bottomLogo = 'assets/images/logo2.png';

  static const _tel1 = '00988-24287805';
  static const _addr1 = 'P.O. BOX: 1109, Postal Code 111';
  static const _addr2 = 'Ghala Ind, Area';
  static const _addr3 = 'Muscat - Sultanate of Oman';
  static const _email1 = 'E-mail: oman@ihthiyati.com';
  static const _add2L1 = 'Br. Sohat-Sultanate of Oman';
  static const _add2L2 = 'Al Ouhi Ind, Area 2';
  static const _tel2 = 'Tel: +968 26647875';
  static const _email2 = 'E-mail: sohar@ihthiyati.com';

  static const _tagline = '(ALL KINDS OF HEAVY VEHICLE PARTS)';
  static const _website = 'Website: www.ihthiyati.com';

  static const _accNo = '22-10-0005';
  static const _term = 'Credit';
  static const _custName = 'INTERNATIONAL SILVER HANDS LLC';
  static const _custAddress = '';
  static const _telNo = '+926464334';
  static const _faxNo = '+923213232323';
  static const _salesman = 'Ahmed Ali';

  static const _date = '2025-01-10 10:30:00';
  static const _invoice = '100234';
  static const _businessName = 'ABC INDUSTRIES';
  static const _customerName = 'John Doe';
  static const _vehicleNumber = 'OM-1234';
  static const _vehicleModel = '2022';
  static const _vehicleColor = 'White';
  static const _vatin = 'OM-VAT-778899';

  static const _rows = <List<String>>[
    ['1', 'Brake Pad', 'BOSCH', 'Front axle', '2', '25.00', '50.00'],
    ['2', 'Oil Filter', 'MANN', 'Engine filter', '1', '15.00', '15.00'],
    ['3', 'Coolant', 'TOTAL', '1L x 3', '3', '4.00', '12.00'],
  ];

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left (EN)
        Expanded(
          child: InkWell(
            onTap: onCompanyTapEn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(
                  'Tel: ${template?.companyDetails.companyContact1 ?? _tel1}',
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                txt(
                  '${template?.companyDetails.addressLine1 ?? _addr1}\n${template?.companyDetails.addressLine2 ?? _addr2}\n${template?.companyDetails.addressLine3 ?? _addr3}',
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                txt(
                  template?.companyDetails.email ?? _email1,
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                Divider(height: 1.2, color: const Color(0xFF186078)),
                txt(
                  '${template?.companyDetails.addressLine2 ?? _add2L1}\n${template?.companyDetails.address2Line2 ?? _add2L2}',
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                txt(
                  template?.companyDetails.companyContact2 ?? _tel2,
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                txt(
                  template?.companyDetails.email2 ?? _email1,
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        InkWell(
          onTap: onLogoTap,
          child: template!.headerLogo == null || template!.headerLogo!.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      _topLogo,
                      width: 76,
                      height: 76,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 4),
                    Image.asset(
                      _bottomLogo,
                      width: 200,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    txt(_tagline, color: Colors.red, fontSize: 12),
                    InkWell(
                      onTap: onWebsiteTap,
                      child: txt(
                        template?.companyDetails.website ?? _website,
                        color: const Color(0xFF186078),
                        fw: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              : Image.network(
                  template!.headerLogo!,
                  width: 76,
                  height: 76,
                  fit: BoxFit.contain,
                ),
        ),
        20.h,
        Expanded(
          child: InkWell(
            onTap: onCompanyTapAr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                txt(
                  Constants.translateToArabic(
                    'Tel: ${template?.companyDetails.companyContact1 ?? 00988 - 24287805}',
                  ),
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                txt(
                  Constants.translateToArabic(
                    '(${template?.companyDetails.addressLine1Ar ?? _addr1})\n(${template?.companyDetails.addressLine2Ar ?? _addr2})\n(${template?.companyDetails.addressLine3Ar ?? _addr3}))',
                  ),
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(
                      template?.companyDetails.email ?? 'oman@ihthiyati.com',
                      color: const Color(0xFF186078),
                      fw: FontWeight.w400,
                    ),
                    const SizedBox(width: 4),
                    txt(
                      Constants.translateToArabic('E-mail:'),
                      color: const Color(0xFF186078),
                      fw: FontWeight.w400,
                    ),
                  ],
                ),
                Divider(height: 1.2, color: const Color(0xFF186078)),
                txt(
                  Constants.translateToArabic(
                    '${template?.companyDetails.addressLine2 ?? _add2L1}\n${template?.companyDetails.address2Line2 ?? _add2L2}',
                  ),
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                txt(
                  Constants.translateToArabic(
                    'Tel: ${template?.companyDetails.companyContact1 ?? '+968 26647875'}',
                  ),
                  color: const Color(0xFF186078),
                  fw: FontWeight.w400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(
                      template?.companyDetails.email2 ?? 'oman@ihthiyati.com',
                      color: const Color(0xFF186078),
                      fw: FontWeight.w400,
                    ),
                    const SizedBox(width: 4),
                    txt(
                      Constants.translateToArabic('E-mail:'),
                      fw: FontWeight.w400,
                      color: const Color(0xFF186078),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _metaBox() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  kv('Acc.No', ': $_accNo', gap: 12, fixedKeyWidth: 50),
                  const SizedBox(width: 12),
                  kv('Term', ': $_term', gap: 12, fixedKeyWidth: 30),
                ],
              ),
              4.h,
              kv('Name', ': $_custName', gap: 12, fixedKeyWidth: 50),
              4.h,
              kv('Address', ': $_custAddress', gap: 12, fixedKeyWidth: 50),
              4.h,
              kv('Tel.No.', ': $_telNo', gap: 12, fixedKeyWidth: 50),
              4.h,
              kv('Fax No.', ': $_faxNo', gap: 12, fixedKeyWidth: 50),
              4.h,
              kv('Salesman', ': $_salesman', gap: 12, fixedKeyWidth: 50),
            ],
          ),

          const SizedBox(width: 16),

          // Right column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  txt('التاريخ', fw: FontWeight.bold, fontSize: 12),
                  6.h,
                  kv(' / Date', ': $_date', fontSize: 12, fixedKeyWidth: 110),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  txt('فاتورة', fw: FontWeight.bold, fontSize: 12),
                  const SizedBox(width: 6),
                  kv(
                    ' / Invoice#',
                    ': $_invoice',
                    fontSize: 12,
                    fixedKeyWidth: 115,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  txt('عمل', fw: FontWeight.bold, fontSize: 12),
                  const SizedBox(width: 6),
                  kv(
                    ' / Business',
                    ': $_businessName',
                    gap: 12,
                    fixedKeyWidth: 110,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  txt('اسم العميل', fw: FontWeight.bold, fontSize: 12),
                  const SizedBox(width: 6),
                  kv(
                    ' / Customer Name',
                    ': $_customerName',
                    fontSize: 12,
                    fixedKeyWidth: 90,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  txt('رقم المركبة', fw: FontWeight.bold, fontSize: 12),
                  const SizedBox(width: 6),
                  kv(
                    ' / Vehicle Number',
                    ': $_vehicleNumber',
                    fontSize: 12,
                    fixedKeyWidth: 90,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  txt('طراز السيارة', fw: FontWeight.bold, fontSize: 12),
                  const SizedBox(width: 6),
                  kv(
                    ' / Vehicle Model',
                    ': $_vehicleModel',
                    gap: 12,
                    fixedKeyWidth: 85,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  txt('لون المركبة', fw: FontWeight.bold, fontSize: 12),
                  const SizedBox(width: 6),
                  kv(
                    ' / Vehicle Color',
                    ': $_vehicleColor',
                    fontSize: 12,
                    fixedKeyWidth: 93,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  txt(
                    'ضريبة القيمة المضافة للعملاء',
                    fw: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(width: 6),
                  kv(
                    ' / Customer VATIN',
                    ': $_vatin',
                    fontSize: 12,
                    fixedKeyWidth: 120,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemsTable() {
    const headers = [
      'Srl.No\nرقم سري',
      'Items\nأغراض',
      'Brand\nماركة',
      'Description\nوصف',
      'Qty\nكمية',
      'Unit Price\nسعر الوحدة',
      'Subtotal\nالمجموع',
    ];

    return Column(
      children: [
        // header
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black)),
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {0: IntrinsicColumnWidth()},
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black)),
                ),
                children: headers
                    .map(
                      (h) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 6,
                        ),
                        child: Text(
                          h,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        // rows
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {0: IntrinsicColumnWidth()},
          children: _rows
              .map(
                (r) => TableRow(
                  children: r
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          child: Text(c, style: const TextStyle(fontSize: 12)),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        _header(),
        const SizedBox(height: 26),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              _metaBox(),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: _itemsTable())]),
            ],
          ),
        ),
      ],
    );
  }
}

class MaintenanceFooterSectionStatic extends StatelessWidget {
  final VoidCallback onCompanyTap;
  final EstimationTemplatePreviewModel? template;

  const MaintenanceFooterSectionStatic({
    super.key,
    required this.onCompanyTap,
    this.template,
  });

  // ---- Static demo data ----
  static const _itemsTotal = 77.00;
  static const _servicesTotal = 35.00;
  static const _discount = 5.00;
  static const _tax = 4.50;
  static const _subTotal = 111.50;
  static const _grandTotal = 116.00;

  static const _services = <Map<String, String>>[
    {'name': 'Inspection', 'price': '15.00'},
    {'name': 'Oil Change', 'price': '20.00'},
  ];

  static const _logoStrip = <String>[
    'assets/images/1 (1).jpeg',
    'assets/images/1 (1).png',
    'assets/images/1 (2).png',
    'assets/images/1 (3).png',
  ];

  static const _branches = <String>[
    'Sohar (Al Ouhi Ind. Area 2)',
    'Muscat (Ghala Ind. Area)',
    'Barka (Main Road)',
  ];

  Widget _kvRight(String k, String v, {bool boldBoth = false, double gap = 6}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        txt(k, fw: boldBoth ? FontWeight.bold : FontWeight.w400),
        SizedBox(width: gap),
        txt(v, fw: boldBoth ? FontWeight.bold : FontWeight.w400),
      ],
    );
  }

  // Simple dashed line
  Widget _dashedLine({
    double width = 100,
    double dashWidth = 6,
    double dashGap = 4,
  }) {
    final dashes = <Widget>[];
    double current = 0;
    while (current + dashWidth <= width) {
      dashes.add(Container(width: dashWidth, height: 1, color: Colors.black));
      current += dashWidth;
      if (current + dashGap <= width) {
        dashes.add(SizedBox(width: dashGap));
        current += dashGap;
      } else {
        break;
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: dashes);
  }

  Widget _logoStripRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: _logoStrip
          .map(
            (p) => Image.asset(
              p,
              width: 64,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(width: 64, height: 40),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF186078);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 2, color: Colors.black),
        // Total after discount row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                txt(
                  'Total after discount :  ',
                  fw: FontWeight.bold,
                  fontSize: 10,
                ),
                txt('المجموع بعد الخصم', fw: FontWeight.bold, fontSize: 10),
              ],
            ),
            txt(
              _grandTotal.toStringAsFixed(2),
              fw: FontWeight.bold,
              fontSize: 10,
            ),
          ],
        ),
        const Divider(height: 2, color: Colors.black),
        const SizedBox(height: 4),

        // Services + Totals columns
        Container(
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Service/Price list
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kvRight('Service', 'Price', boldBoth: true),
                  const SizedBox(height: 4),
                  ..._services.map(
                    (s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.5),
                      child: _kvRight(s['name']!, s['price']!),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              // Right: Totals
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 2),
                  _kvRight(
                    'إجمالي العناصر / Items Total : OMR',
                    '+${_itemsTotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 2),
                  _kvRight(
                    'إجمالي الخدمات / Services Total : OMR',
                    '+${_servicesTotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 2),
                  _kvRight(
                    'تخفيض / Discount : OMR',
                    '-${_discount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 2),
                  _kvRight('ضريبة / Tax : OMR', '+${_tax.toStringAsFixed(2)}'),
                  const SizedBox(height: 2),
                  _kvRight(
                    'المجموع الفرعي / Sub-Total : OMR',
                    _subTotal.toStringAsFixed(2),
                  ),
                  const SizedBox(height: 2),
                  _kvRight(
                    'المجموع / Total : OMR',
                    _grandTotal.toStringAsFixed(2),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Remarks + Signature + Company right
        SizedBox(
          height: 70,
          child: Row(
            children: [
              // Remarks + signature
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt('Remarks : ', fw: FontWeight.bold, fontSize: 10),
                        txt(
                          'تم استلام البضائع المذكورة أعلاه بحالة جيدة',
                          fontSize: 8,
                        ),
                        txt(
                          'Received above goods in good order and Condition',
                          fontSize: 8,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        txt("Receiver's Signature : ", fontSize: 10),
                        _dashedLine(width: 100),
                        const SizedBox(width: 6),
                        txt('توقيع المستلم ', fontSize: 10),
                      ],
                    ),
                  ],
                ),
              ),

              // Company confirmation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(
                      'شركة الإحتياطي لقطع الغيار ذ.م.م',
                      fw: FontWeight.bold,
                      fontSize: 10,
                      color: blue,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        txt('For ', fontSize: 10, color: blue),
                        InkWell(
                          onTap: onCompanyTap,
                          child: txt(
                            template?.companyDetails.companyName ??
                                'AL IHTHIYATI SPARE PARTS LLC',
                            fw: FontWeight.bold,
                            fontSize: 10,
                            color: blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(color: Colors.red, thickness: 1, height: 1),
        const SizedBox(height: 6),

        // Logos strip
        _logoStripRow(),
        const SizedBox(height: 6),

        // Branches line
        Row(
          children: [
            txt('Branches :- ', fontSize: 10, color: Colors.black),
            Expanded(
              child: txt(
                _branches.join(', '),
                fontSize: 9,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
