import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

/// Ultra-compact widget for DataTable cells - optimized for dense information display
class DataTableServiceCell extends StatelessWidget {
  final String serviceId;
  final SaleModel saleDetails;
  final ServiceItem serviceItem;
  final VoidCallback? onTap;
  final bool showTooltip;

  const DataTableServiceCell({
    super.key,
    required this.serviceId,
    required this.saleDetails,
    required this.serviceItem,
    this.onTap,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, provider, child) {
        final service = provider.getServiceById(serviceId);

        if (service.id!.isEmpty) {
          return _buildLoadingState();
        }

        Widget cell = _buildCompactCell(context, serviceItem, service);

        // Wrap with tooltip for detailed info on hover/tap
        if (showTooltip) {
          return Tooltip(
            message: _buildTooltipMessage(serviceItem, service),
            preferBelow: false,
            padding: const EdgeInsets.all(8),
            textStyle: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: cell,
          );
        }

        return cell;
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCell(
    BuildContext context,
    ServiceItem serviceItem,
    ServiceTypeModel service,
  ) {
    final hasDiscount = serviceItem.discount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              // Product info (left side)
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Product code (compact)
                    // Text(
                    //   service.name,
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.grey.shade500,
                    //     height: 1.0,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // Product name
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              // Financial indicators (center)
              if (hasDiscount) ...[
                _buildIndicatorChips(hasDiscount),
                const SizedBox(width: 4),
              ],

              // Price and quantity (right side)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Total price (primary)
                    Text(
                      "${serviceItem.totalPrice.toStringAsFixed(2)} OMR",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.greenColor,
                        height: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Unit price + quantity (secondary)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            serviceItem.sellingPrice.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                              height: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '×${serviceItem.quantity}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorChips(bool hasDiscount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasDiscount)
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }

  String _buildTooltipMessage(
    ServiceItem servicetem,
    ServiceTypeModel service,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(service.name);
    //buffer.writeln('Code: P-${product.code}');
    buffer.writeln('---');
    buffer.writeln(
      'Unit Price: ${servicetem.sellingPrice.toStringAsFixed(2)} OMR',
    );
    buffer.writeln('Quantity: ${servicetem.quantity}');
    buffer.writeln('Total: ${servicetem.totalPrice.toStringAsFixed(2)} OMR');

    if (servicetem.discount > 0) {
      buffer.writeln('Discount: ${servicetem.discount.toStringAsFixed(1)}%');
    }

    return buffer.toString().trim();
  }
}

/// Alternative ultra-minimal version for extremely tight spaces
class DataTableServiceCellMini extends StatelessWidget {
  final String productId;
  final SaleItem saleItem;
  final VoidCallback? onTap;

  const DataTableServiceCellMini({
    super.key,
    required this.productId,
    required this.saleItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, provider, child) {
        final product = provider.getProductByID(productId);

        if (product == null) return const SizedBox.shrink();

        return InkWell(
          onTap: onTap,
          child: Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${product.productName}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  saleItem.totalPrice.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.greenColor,
                  ),
                ),
                const SizedBox(width: 2),
                if (saleItem.quantity > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '×${saleItem.quantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
