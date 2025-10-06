import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;
import 'dart:js_interop';

Future<void> downloadFile(String url, String filename) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final blob = web.Blob([response.bodyBytes.toJS].toJS);

      final urlBlob = web.URL.createObjectURL(blob);
      final _ = web.HTMLAnchorElement()
        ..href = urlBlob
        ..download = filename
        ..click();
      web.URL.revokeObjectURL(urlBlob);
      debugPrint('File download initiated for web using package:web.');
    } else {
      debugPrint('Failed to download file on web: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error during file download on web: $e');
  }
}
