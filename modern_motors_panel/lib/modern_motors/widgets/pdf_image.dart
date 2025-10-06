import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

bool _hasArabic(String s) => RegExp(r'[\u0600-\u06FF]').hasMatch(s);

pw.Text pdfImage({
  required String text,
  double fontSize = 16,
  PdfColor color = PdfColors.black,
  pw.TextAlign? textAlign,
  pw.FontWeight fontWeight = pw.FontWeight.normal,
  bool isUnderline = false,
}) {
  final isAr = _hasArabic(text);

  return pw.Text(
    textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
    textAlign: textAlign ?? (isAr ? pw.TextAlign.right : pw.TextAlign.left),
    text,
    style: pw.TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      lineSpacing: 0,
      height: 0,
      decoration:
          isUnderline ? pw.TextDecoration.underline : pw.TextDecoration.none,
    ),
  );
}
