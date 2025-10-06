import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget fancyTightDivider() {
  return pw.Column(
    children: [
      pw.Container(height: 0.5, color: PdfColors.black),
      pw.SizedBox(height: 1.4),
      pw.Container(height: 1.5, color: PdfColors.black),
      pw.SizedBox(height: 1.4),
      pw.Container(height: 0.5, color: PdfColors.black),
    ],
  );
}
