import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active' || 'sent' || 'approved' || 'paid':
      return AppTheme.primaryColor;
    case 'inactive':
      return AppTheme.greyColor;
    case 'pending' || 'ordered' || 'overdue':
      return Colors.orange;
    case 'accepted':
      return Colors.green;
    case 'canceled':
    case 'rejected':
    case 'unpaid':
      return Colors.red;
    case 'draft':
      return Colors.purple;
    default:
      return Colors.blueGrey;
  }
}

String getDropDownDisplayText({
  required bool isMultiSelect,
  List<String>? selectedValues,
  required Map<String, String> items,
  required String hintText,
  String? value,
}) {
  switch (isMultiSelect) {
    case true:
      return ((selectedValues == null || selectedValues.isEmpty)
          ? hintText
          : selectedValues
                .map((key) => items[key])
                .whereType<String>()
                .join(', '));
    case false:
      return (items[value] ?? hintText);
  }
}

String getTruncatedText(
  String text, {
  int maxLength = 5,
  int proposedLength = 9,
}) {
  if (text.length <= maxLength) return text;
  return text.length > proposedLength
      ? '${text.substring(0, maxLength)}...'
      : text;
}

int getDaysInMonth(int year, int month) {
  final firstDayNextMonth = (month < 12)
      ? DateTime(year, month + 1, 1)
      : DateTime(year + 1, 1, 1);
  return firstDayNextMonth.subtract(Duration(days: 1)).day;
}

int getStartWeekday(int year, int month) {
  // Monday = 1, Sunday = 7
  return DateTime(year, month, 1).weekday;
}
