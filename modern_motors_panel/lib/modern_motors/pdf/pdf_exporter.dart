import 'package:flutter/foundation.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

class PdfExporter {
  static Future<void> exportToPdf({
    required List<String> headers,
    required List<List<dynamic>> rows,
    String? fileNamePrefix,
  }) async {
    final pdf = pw.Document();

    // Create a base style with smaller font
    final baseTextStyle = pw.TextStyle(fontSize: 8);

    // Create a flexible table
    final table = pw.Table.fromTextArray(
      headers: headers,
      data: rows,
      cellAlignment: pw.Alignment.centerLeft,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: baseTextStyle,
      border: pw.TableBorder.all(width: 0.5),
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 25,
      columnWidths: {
        // Fit text dynamically per column
        for (var i = 0; i < headers.length; i++) i: const pw.FlexColumnWidth(),
      },
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape, // landscape orientation
        build: (context) =>
            pw.Padding(padding: const pw.EdgeInsets.all(20), child: table),
      ),
    );

    final bytes = await pdf.save();
    final fileName =
        '${fileNamePrefix ?? "export"}_${DateTime.now().formattedWithYMDHMS}.pdf';

    if (kIsWeb) {
      final blob = html.Blob([Uint8List.fromList(bytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..style.display = 'none';
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    } else {
      throw UnimplementedError("PDF export only supported on web for now.");
    }
  }
}
