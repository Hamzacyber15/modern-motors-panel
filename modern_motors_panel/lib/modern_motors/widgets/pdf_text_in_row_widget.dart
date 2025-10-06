import 'package:flutter/cupertino.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Row pdfTextInRowWidget({
  required BuildContext context,
  required String text1,
  required String text2,
  double width = 0.005,
  double fontSize = 12,
  double fixedWidth = 80,
  pw.FontWeight fontWeight = pw.FontWeight.bold,
  bool isBothBold = false,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.SizedBox(
        width: fixedWidth,
        child: pdfTextWidget(
          text: text1,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      pw.SizedBox(width: context.width * width),
      pdfTextWidget(
        text: text2,
        fontSize: fontSize,
        fontWeight: isBothBold ? fontWeight : pw.FontWeight.normal,
      ),
    ],
  );
}
