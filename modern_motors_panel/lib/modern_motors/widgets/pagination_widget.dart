import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onItemsPerPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    this.itemsPerPageOptions = const [10, 20, 50, 100],
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
  });

  int get totalPages => (totalItems / itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    if (totalItems <= 9) {
      return const SizedBox.shrink();
    }
    int start = currentPage * itemsPerPage + 1;
    int end = ((currentPage + 1) * itemsPerPage);
    if (end > totalItems) end = totalItems;

    return Container(
      color: AppTheme.whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DropdownButton<int>(
            value: itemsPerPage,
            items: itemsPerPageOptions
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      '$e',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onItemsPerPageChanged(value);
              }
            },
          ),
          SizedBox(width: 20),
          Text(
            '$start - $itemsPerPage of $totalItems',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: currentPage > 0
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages - 1
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
