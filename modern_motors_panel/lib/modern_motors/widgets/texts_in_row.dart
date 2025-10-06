import 'package:flutter/cupertino.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_in_row_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pdf_text_widget.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Column textsInRow({
  required BuildContext context,
  required String text1,
  required String text2,
  required String text3,
  double width = 0.008,
  bool isLeftRow = true,
  double fontSize = 9,
}) {
  return pw.Column(
    children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          if (isLeftRow)
            pdfTextInRowWidget(
              context: context,
              text1: text1,
              text2: text2,
              fontSize: fontSize,
              width: width,
            ),
          pdfTextWidget(text: text3, fontSize: fontSize),
          if (!isLeftRow)
            pdfTextInRowWidget(
              context: context,
              text1: text1,
              text2: text2,
              fontSize: fontSize,
              width: width,
            ),
        ],
      ),
      pw.SizedBox(height: 1),
    ],
  );
}

pw.Row textsInRowWithArabicInStart({
  required String text1,
  required String text2,
  required String text3,
  pw.FontWeight fontWeight = pw.FontWeight.bold,
  double fontSize = 10,
  bool isTotal = false,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Row(
        children: [
          pdfTextWidget(
            text: text1,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          pdfTextWidget(
            text: text2,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ],
      ),
      pw.SizedBox(width: 8),
      pdfTextWidget(
        text: text3,
        fontSize: 10,
        fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ],
  );
}

pw.Column textsInRowWithArabicInMiddle({
  required BuildContext context,
  required String text1,
  required String text2,
  required String text3,
  double width = 0.008,
  double fontSize = 9,
}) {
  return pw.Column(
    children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.SizedBox(
            width: 70,
            child: pdfTextWidget(text: text1, fontSize: fontSize),
          ),
          // pw.SizedBox(width: context.width * width),
          pdfTextWidget(text: text2, fontSize: fontSize),
          pdfTextWidget(text: text3, fontSize: fontSize),
        ],
      ),
      pw.SizedBox(height: 1),
    ],
  );
}

// pw.Row textsInRowWithArabicInStart({
//   required BuildContext context,
//   required String text1,
//   required String text2,
//   required String text3,
//   bool isTotal = false,
// }) {
//   return pw.Row(
//     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//     children: [
//       pw.Row(
//         children: [
//           pdfTextWidget(
//             text: text1,
//             fontSize: 10,
//             fontWeight: pw.FontWeight.bold,
//           ),
//           pdfTextWidget(
//             text: text2,
//             fontSize: 10,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ],
//       ),
//       pw.SizedBox(width: 8),
//       pdfTextWidget(
//         text: text3,
//         fontSize: 10,
//         fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
//       ),
//     ],
//   );
// }
