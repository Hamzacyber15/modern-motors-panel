import 'package:pdf/widgets.dart' as pw;

pw.Container pdfDottedWidget({
  double? height,
  double? width,
  required pw.Widget child,
  pw.Alignment alignment = pw.Alignment.center,
}) {
  return pw.Container(
    height: height,
    width: width,
    // decoration: pw.BoxDecoration(
    //   border: pw.Border.all(
    //     color: PdfColors.grey400,
    //     // color: PdfColors.grey400,
    //     width: 1.3,
    //     style: pw.BorderStyle.dotted,
    //   ),
    // ),
    alignment: alignment,
    child: child,
  );
}
