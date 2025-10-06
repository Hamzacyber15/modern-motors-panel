import 'package:flutter/material.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Column pdfTermsWidget({
  required BuildContext context,
  required String text1,
  required String text2,
  double width = 0.03,
  bool isDivider = true,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pdfTextWidget(text: text1, fontSize: 11, fontWeight: pw.FontWeight.bold),
      // pdfTextWidget(text: text2, fontSize: 10),
      pw.Paragraph(
        text: text2,
        style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
      ),
    ],
  );
}
