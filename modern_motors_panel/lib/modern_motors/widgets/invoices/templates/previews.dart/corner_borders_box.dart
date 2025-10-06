import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Draws L-shaped corners around [child] without forcing infinite height.
/// This is breakable on MultiPage because the container sizes to its content.
pw.Widget cornerBorderBox({
  required pw.Widget child,
  double strokeWidth = 2,
  double cornerLength = 15,
  PdfColor color = PdfColors.black,
  pw.EdgeInsets padding = const pw.EdgeInsets.all(0),
}) {
  return pw.Container(
    padding: padding,
    // The stack gets the child's natural size; the painter overlays the corners.
    child: pw.Stack(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: child,
        ),
        pw.Positioned.fill(
          child: pw.CustomPaint(
            painter: (canvas, size) {
              // size.x == width, size.y == height of the container
              void drawTL() {
                canvas
                  ..moveTo(0, size.y)
                  ..lineTo(0, size.y - cornerLength)
                  ..moveTo(0, size.y)
                  ..lineTo(cornerLength, size.y);
              }

              void drawTR() {
                canvas
                  ..moveTo(size.x, size.y)
                  ..lineTo(size.x, size.y - cornerLength)
                  ..moveTo(size.x, size.y)
                  ..lineTo(size.x - cornerLength, size.y);
              }

              void drawBL() {
                canvas
                  ..moveTo(0, 0)
                  ..lineTo(0, cornerLength)
                  ..moveTo(0, 0)
                  ..lineTo(cornerLength, 0);
              }

              void drawBR() {
                canvas
                  ..moveTo(size.x, 0)
                  ..lineTo(size.x, cornerLength)
                  ..moveTo(size.x, 0)
                  ..lineTo(size.x - cornerLength, 0);
              }

              canvas
                ..setStrokeColor(color)
                ..setLineWidth(strokeWidth);

              drawTL();
              drawTR();
              drawBL();
              drawBR();
              canvas.strokePath();
            },
          ),
        ),
      ],
    ),
  );
}

class FlutterCornerBorderBox extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final double cornerLength;
  final Color color;
  final EdgeInsets padding;

  const FlutterCornerBorderBox({
    super.key,
    required this.child,
    this.strokeWidth = 2,
    this.cornerLength = 15,
    this.color = Colors.black,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: child,
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _CornerBorderPainter(
                strokeWidth: strokeWidth,
                cornerLength: cornerLength,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBorderPainter extends CustomPainter {
  final double strokeWidth;
  final double cornerLength;
  final Color color;

  _CornerBorderPainter({
    required this.strokeWidth,
    required this.cornerLength,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Top-left
    path.moveTo(0, size.height);
    path.lineTo(0, size.height - cornerLength);
    path.moveTo(0, size.height);
    path.lineTo(cornerLength, size.height);

    // Top-right
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, size.height - cornerLength);
    path.moveTo(size.width, size.height);
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom-left
    path.moveTo(0, 0);
    path.lineTo(0, cornerLength);
    path.moveTo(0, 0);
    path.lineTo(cornerLength, 0);

    // Bottom-right
    path.moveTo(size.width, 0);
    path.lineTo(size.width, cornerLength);
    path.moveTo(size.width, 0);
    path.lineTo(size.width - cornerLength, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerBorderPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.color != color;
  }
}
