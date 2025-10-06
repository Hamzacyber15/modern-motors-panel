import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PDFViewer extends StatefulWidget {
  final AttachmentModel attachment;
  const PDFViewer({required this.attachment, super.key});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  Future<Uint8List> generatePdf(PdfPageFormat format) async {
    return widget.attachment.bytes!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: PdfPreview(build: (format) => generatePdf(format)),
    );
  }
}
