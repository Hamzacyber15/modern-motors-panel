import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:modern_motors_panel/constants.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadFile(String url, String filename) async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    try {
      String downloadPath = await Constants.getDownloadPath();

      String savePath = '$downloadPath/$filename';
      debugPrint('Saving file to: $savePath');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        debugPrint('File saved successfully to: $savePath');
      } else {
        debugPrint('Failed to download file on mobile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during file download/save on mobile: $e');
    }
  } else {
    debugPrint('Storage permission denied on mobile.');
  }
}
