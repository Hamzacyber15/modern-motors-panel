import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_in_row_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_widget.dart/pdf_dotted_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Column pdfAmountTextWidget({
  required BuildContext context,
  required String text1,
  required String text2,
  double width = 0.03,
  bool isDivider = true,
}) {
  return pw.Column(
    children: [
      pw.SizedBox(height: 4),
      pdfTextInRowWidget(
        context: context,
        text1: text1,
        text2: text2,
        width: width,
      ),
      if (isDivider) pw.Divider(height: 0.5),
    ],
  );
}

pw.Row pdfTextInRowWidgetTem5({
  required BuildContext context,
  required String text1,
  required String text2,
  double width = 0.03,
  bool isFromRetailLayout = false,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pdfDottedWidget(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
          text1,
          style: pw.TextStyle(
            fontWeight: !isFromRetailLayout
                ? pw.FontWeight.normal
                : pw.FontWeight.bold,
            fontSize: 12,
            color: text1 == 'Total' && !isFromRetailLayout
                ? PdfColor.fromInt(0xFF44B1D9)
                : PdfColors.black,
          ),
        ),
      ),
      pw.SizedBox(width: context.width * width),
      pw.Text(
        text2,
        style: pw.TextStyle(
          fontWeight: text1 == 'Total'
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
          fontSize: 12,
        ),
      ),
    ],
  );
}
