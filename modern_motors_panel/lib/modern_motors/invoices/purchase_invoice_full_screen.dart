import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
import 'package:modern_motors_panel/modern_motors/invoices/purchase_invoice_pdf.dart';
import 'package:printing/printing.dart';

class PurchaseInvoiceFullScreen extends StatefulWidget {
  final NewPurchaseModel purchase;

  const PurchaseInvoiceFullScreen({super.key, required this.purchase});

  @override
  State<PurchaseInvoiceFullScreen> createState() =>
      _PurchaseInvoiceFullScreenState();
}

class _PurchaseInvoiceFullScreenState extends State<PurchaseInvoiceFullScreen> {
  bool _isGenerating = false;
  bool _isPrinting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Invoice - ${widget.purchase.invoice}'),
        // backgroundColor: Colors.blue[800],
        // foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isGenerating && !_isPrinting)
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: _printInvoice,
              tooltip: 'Print Invoice',
            ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _saveInvoice,
            tooltip: 'Save PDF',
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              // Status indicators
              if (_isGenerating || _isPrinting)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isGenerating) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(width: 12),
                        const Text('Generating PDF...'),
                      ] else if (_isPrinting) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(width: 12),
                        const Text('Printing...'),
                      ],
                    ],
                  ),
                ),

              // PDF Preview - Takes full space
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: PdfPreview(
                    build: (format) =>
                        PurchaseInvoicePDF.generate(widget.purchase),
                    loadingWidget: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading PDF Preview...'),
                        ],
                      ),
                    ),
                    pdfFileName:
                        'purchase_invoice_${widget.purchase.invoice}.pdf',
                  ),
                ),
              ),

              // Print Button Section
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[50],
              //     border: Border(top: BorderSide(color: Colors.grey[300]!)),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       // Left side - Invoice info
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Invoice #${widget.purchase.invoice}',
              //             style: const TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 16,
              //             ),
              //           ),
              //           Text(
              //             'Supplier: ${widget.purchase.supplierId}',
              //             style: TextStyle(
              //               fontSize: 14,
              //               color: Colors.grey[600],
              //             ),
              //           ),
              //           Text(
              //             'Total: OMR ${widget.purchase.totals.total.toStringAsFixed(2)}',
              //             style: const TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ],
              //       ),

              //       // Right side - Action buttons
              //       // Row(
              //       //   children: [
              //       //     ElevatedButton.icon(
              //       //       onPressed: _printInvoice,
              //       //       icon: const Icon(Icons.print),
              //       //       label: const Text('Print Invoice'),
              //       //       style: ElevatedButton.styleFrom(
              //       //         backgroundColor: Colors.blue[700],
              //       //         foregroundColor: Colors.white,
              //       //         padding: const EdgeInsets.symmetric(
              //       //           horizontal: 20,
              //       //           vertical: 12,
              //       //         ),
              //       //       ),
              //       //     ),
              //       //     const SizedBox(width: 12),
              //       //     OutlinedButton.icon(
              //       //       onPressed: _saveInvoice,
              //       //       icon: const Icon(Icons.download),
              //       //       label: const Text('Save PDF'),
              //       //       style: OutlinedButton.styleFrom(
              //       //         padding: const EdgeInsets.symmetric(
              //       //           horizontal: 20,
              //       //           vertical: 12,
              //       //         ),
              //       //       ),
              //       //     ),
              //       //   ],
              //       // ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _printInvoice() async {
    setState(() {
      _isPrinting = true;
    });

    try {
      final pdfBytes = await PurchaseInvoicePDF.generate(widget.purchase);
      await Printing.layoutPdf(onLayout: (format) => pdfBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invoice sent to printer successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Printing failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPrinting = false;
      });
    }
  }

  Future<void> _saveInvoice() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdfBytes = await PurchaseInvoicePDF.generate(widget.purchase);

      // For saving - you can use file_saver or share_plus package
      // Example with share_plus:
      // await Share.shareXFiles([XFile.fromData(pdfBytes, mimeType: 'application/pdf', name: 'invoice_${widget.purchase.invoice}.pdf')]);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }
}

// Utility function to open the invoice
void openPurchaseInvoice(BuildContext context, NewPurchaseModel purchase) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PurchaseInvoiceFullScreen(purchase: purchase),
    ),
  );
}
