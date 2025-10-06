import 'package:flutter/material.dart';

enum RowAction { view, email, edit, delete }

Widget buildActionButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
  required String tooltip,
}) {
  return Tooltip(
    message: tooltip,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    ),
  );
}

DataCell buildDataCellButton({
  required String title,
  required VoidCallback onPress,
}) {
  return DataCell(
    Container(
      width: 150,
      padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.attach_money, size: 16),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: const Color(0xFF059669).withValues(alpha: 0.1),
          foregroundColor: const Color(0xFF059669),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPress,
      ),
    ),
  );
}

Widget menuItem(IconData icon, Color color, String label) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 8),
      Text(label),
    ],
  );
}
