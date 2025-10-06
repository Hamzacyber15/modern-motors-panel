import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<Uint8List> generateQrCodeBytes(String data) async {
  final qrValidationResult = QrValidator.validate(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
  );

  final qrCode = qrValidationResult.qrCode;

  final painter = QrPainter.withQr(
    qr: qrCode!,
    color: const Color(0xFF000000),
    emptyColor: const Color(0xFFFFFFFF),
    gapless: true,
  );

  final picData = await painter.toImageData(200); // size
  return picData!.buffer.asUint8List();
}
