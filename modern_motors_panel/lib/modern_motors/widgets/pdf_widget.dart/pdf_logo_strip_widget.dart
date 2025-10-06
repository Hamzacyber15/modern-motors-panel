import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget pdfLogoStripWidget(List<pw.MemoryImage> logos) {
  const double logoHeight = 40;
  const double gap = 8;

  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Wrap(
      spacing: gap,
      runSpacing: gap,
      alignment: pw.WrapAlignment.start,
      crossAxisAlignment: pw.WrapCrossAlignment.center,
      children: logos.map((img) {
        return pw.Container(
          width: 70,
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          child: pw.SizedBox(
            height: logoHeight,
            width: 70,
            child: pw.Image(
              img,
              width: 70,
              height: logoHeight,
              fit: pw.BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// pw.Widget pdfLogoStripWidget(List<pw.MemoryImage> logos) {
//   // tweak these to match your visual density
//   const double logoHeight = 100; // each badge height
//   const double gap = 6; // horizontal/vertical spacing

//   return pw.Container(
//     padding: const pw.EdgeInsets.symmetric(vertical: 6),
//     // decoration: const pw.BoxDecoration(
//     //   border: pw.Border(top: pw.BorderSide(width: 0.5, color: PdfColors.black)),
//     // ),
//     child: pw.Wrap(
//       spacing: gap,
//       runSpacing: gap,
//       alignment: pw.WrapAlignment.start,
//       crossAxisAlignment: pw.WrapCrossAlignment.center,
//       children: logos.map((img) {
//         return pw.Container(
//           padding: const pw.EdgeInsets.symmetric(
//             horizontal: 6,
//             vertical: 2,
//           ),
//           decoration: pw.BoxDecoration(
//             border: pw.Border.all(color: PdfColors.blue800, width: 0.5),
//             color: const PdfColor.fromInt(0xFFEFF3F8),
//             borderRadius: pw.BorderRadius.circular(2),
//           ),
//           child: pw.SizedBox(
//             height: logoHeight,
//             child: pw.Image(img, fit: pw.BoxFit.contain),
//           ),
//         );
//       }).toList(),
//     ),
//   );
// }
