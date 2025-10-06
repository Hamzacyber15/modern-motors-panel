import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';

class DiscountSelector extends StatelessWidget {
  final bool applyDiscount;
  final bool isLoadingDiscounts;
  final List<DiscountModel> discounts;
  final DiscountModel? selectedDiscount;
  final Function(DiscountModel) onDiscountSelected;

  const DiscountSelector({
    super.key,
    required this.applyDiscount,
    required this.isLoadingDiscounts,
    required this.discounts,
    required this.selectedDiscount,
    required this.onDiscountSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!applyDiscount) return const SizedBox.shrink();

    if (isLoadingDiscounts) {
      return const Center(child: LinearProgressIndicator());
    }

    if (discounts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No discounts available.'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: discounts.map((discount) {
          final isSelected = selectedDiscount?.id == discount.id;
          return GestureDetector(
            onTap: () => onDiscountSelected(discount),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.greyColor,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discount.title ?? 'No Title',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${discount.discount.toStringAsFixed(0)}% OFF',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
