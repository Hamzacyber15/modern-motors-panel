import 'package:flutter/material.dart';

class DropdownItem {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  DropdownItem({required this.label, required this.icon, this.onTap});
}
