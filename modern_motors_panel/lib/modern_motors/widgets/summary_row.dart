import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? color;
  final bool isDiscount;
  final double fontSize;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.isDiscount = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Text(
          '${isDiscount ? '-' : ''}${value.abs().toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: fontSize,
            color: color ?? AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
