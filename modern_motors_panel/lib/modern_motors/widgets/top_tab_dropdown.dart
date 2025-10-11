import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/supplier/supplier_page.dart';

Widget topTabDropdown({
  required String title,
  required List<DropdownItem> items,
  required DropdownItem? selectedValue,
  required ValueChanged<DropdownItem?> onChanged,
  Color? color,
}) {
  return Container(
    height: color == null ? 28 : 33,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      border: Border.all(
        color: color == null ? AppTheme.borderColor : Colors.transparent,
      ),
      color: color ?? Colors.white,
    ),
    child: Row(
      children: [
        if (color != null) ...[
          Icon(Icons.downloading_rounded, color: Colors.white, size: 16),
          2.w,
        ],
        DropdownButton<DropdownItem>(
          value: selectedValue,
          hint: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: color == null ? Colors.black : Colors.white,
            ),
          ),
          underline: const SizedBox(),
          isDense: true,
          isExpanded: false,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: color == null ? Colors.black : Colors.white,
          ),
          dropdownColor: Colors.white,
          style: TextStyle(
            color: color == null ? Colors.black : Colors.white,
            fontSize: 13,
          ),
          items: items.map((DropdownItem item) {
            return DropdownMenuItem<DropdownItem>(
              value: item,
              child: Row(
                children: [
                  Icon(item.icon, size: 14, color: Colors.black),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}
