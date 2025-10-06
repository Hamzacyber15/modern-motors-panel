import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/summary_row.dart';

class OrderSummaryDetails extends StatelessWidget {
  final double subTotal;
  final bool applyDiscount;
  final DiscountModel? selectedDiscount;
  final double discountAmount;
  final double taxAmount;

  const OrderSummaryDetails({
    super.key,
    required this.subTotal,
    required this.applyDiscount,
    this.selectedDiscount,
    required this.discountAmount,
    required this.taxAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (applyDiscount && selectedDiscount != null)
          SummaryRow(
            label:
                'Discount (${selectedDiscount!.discount.toStringAsFixed(0)}%)',
            value: -discountAmount,
            isDiscount: true,
            color: AppTheme.greenColor,
            fontSize: 12,
          ),
        SummaryRow(label: 'Sub total', value: subTotal),
        SummaryRow(
          label: 'Tax (5%)',
          value: taxAmount,
          color: AppTheme.redColor,
          fontSize: 12,
        ),
      ],
    );
  }
}
