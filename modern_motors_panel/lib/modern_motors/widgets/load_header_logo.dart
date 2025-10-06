import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

Future<Uint8List> loadHeaderLogo(dynamic tLogo) async {
  if (tLogo is String) {
    if (tLogo.startsWith('http')) {
      // URL se load
      final response = await http.get(Uri.parse(tLogo));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load logo from URL');
      }
    } else {
      // Asset se load
      final data = await rootBundle.load(tLogo);
      return data.buffer.asUint8List();
    }
  } else if (tLogo is Uint8List) {
    // Agar already bytes diye hue hain
    return tLogo;
  } else {
    throw Exception('Unsupported logo type');
  }
}
