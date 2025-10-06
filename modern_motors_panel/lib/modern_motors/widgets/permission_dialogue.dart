import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget permissionDialog(
  BuildContext context,
  List permissions, {
  String title = 'Access Permissions',
}) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: permissions.map((perm) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(
                    perm,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    },
    child: const Text(
      "More...",
      style: TextStyle(fontSize: 10, color: CupertinoColors.activeBlue),
    ),
  );
}
