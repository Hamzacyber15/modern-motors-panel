// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

Widget buildFilterChip(
  BuildContext context,
  String label,
  VoidCallback onRemove, {
  bool isClearAll = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isClearAll
          ? Colors.red.shade50
          : Theme.of(context).primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isClearAll
            ? Colors.red.shade300
            : Theme.of(context).primaryColor.withOpacity(0.3),
      ),
    ),
    child: InkWell(
      onTap: onRemove,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isClearAll
                    ? Colors.red.shade700
                    : Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.close,
              size: 14,
              color: isClearAll
                  ? Colors.red.shade700
                  : Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    ),
  );
}
