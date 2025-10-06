// import 'package:app/app_theme.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/provider/mm_resource_provider.dart';
// import 'package:app/modern_motors/sales/sales_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// /// Ultra-compact widget for DataTable cells - optimized for dense information display
// class DataTableProductCell extends StatelessWidget {
//   final String productId;
//   final SaleModel saleDetails;
//   final SaleItem saleItem;
//   final VoidCallback? onTap;
//   final bool showTooltip;

//   const DataTableProductCell({
//     super.key,
//     required this.productId,
//     required this.saleDetails,
//     required this.saleItem,
//     this.onTap,
//     this.showTooltip = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MmResourceProvider>(
//       builder: (context, provider, child) {
//         final product = provider.getProductByID(productId);

//         if (product == null) {
//           return _buildLoadingState();
//         }

//         Widget cell = _buildCompactCell(context, product);

//         // Wrap with tooltip for detailed info on hover/tap
//         if (showTooltip) {
//           return Tooltip(
//             message: _buildTooltipMessage(product),
//             preferBelow: false,
//             padding: const EdgeInsets.all(8),
//             textStyle: const TextStyle(fontSize: 14, color: Colors.white),
//             decoration: BoxDecoration(
//               color: Colors.black87,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: cell,
//           );
//         }

//         return cell;
//       },
//     );
//   }

//   Widget _buildLoadingState() {
//     return Container(
//       height: 32,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Row(
//         children: [
//           Container(
//             width: 60,
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//           const Spacer(),
//           Container(
//             width: 40,
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompactCell(BuildContext context, ProductModel product) {
//     final hasDiscount = saleItem.discount > 0;
//     final hasMargin = saleItem.margin > 0;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(4),
//         child: Container(
//           height: 40,
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           child: Row(
//             children: [
//               // Product info (left side)
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Product code (compact)
//                     Text(
//                       "P-${product.code ?? 'N/A'}",
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey.shade500,
//                         height: 1.0,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     // Product name
//                     Text(
//                       product.productName ?? 'Unknown',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1F2937),
//                         height: 1.1,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 4),

//               // Financial indicators (center)
//               if (hasMargin || hasDiscount) ...[
//                 _buildIndicatorChips(hasMargin, hasDiscount),
//                 const SizedBox(width: 4),
//               ],

//               // Price and quantity (right side)
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Total price (primary)
//                     Text(
//                       "${saleItem.totalPrice.toStringAsFixed(2)} OMR",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         color: AppTheme.greenColor,
//                         height: 1.0,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     // Unit price + quantity (secondary)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             saleItem.sellingPrice.toStringAsFixed(2),
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey.shade600,
//                               height: 1.0,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 4, vertical: 1),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF3B82F6),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             '×${saleItem.quantity}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                               height: 1.0,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIndicatorChips(bool hasMargin, bool hasDiscount) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (hasMargin)
//           Container(
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.green.shade400,
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//         if (hasMargin && hasDiscount) const SizedBox(width: 2),
//         if (hasDiscount)
//           Container(
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.orange.shade400,
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//       ],
//     );
//   }

//   String _buildTooltipMessage(ProductModel product) {
//     final buffer = StringBuffer();
//     buffer.writeln('${product.productName}');
//     buffer.writeln('Code: P-${product.code}');
//     buffer.writeln('---');
//     buffer
//         .writeln('Unit Price: ${saleItem.sellingPrice.toStringAsFixed(2)} OMR');
//     buffer.writeln('Quantity: ${saleItem.quantity}');
//     buffer.writeln('Total: ${saleItem.totalPrice.toStringAsFixed(2)} OMR');

//     if (saleItem.margin > 0) {
//       buffer.writeln('Margin: ${saleItem.margin.toStringAsFixed(1)}%');
//     }

//     if (saleItem.discount > 0) {
//       buffer.writeln('Discount: ${saleItem.discount.toStringAsFixed(1)}%');
//     }

//     return buffer.toString().trim();
//   }
// }

// /// Alternative ultra-minimal version for extremely tight spaces
// class DataTableProductCellMini extends StatelessWidget {
//   final String productId;
//   final SaleItem saleItem;
//   final VoidCallback? onTap;

//   const DataTableProductCellMini({
//     super.key,
//     required this.productId,
//     required this.saleItem,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MmResourceProvider>(
//       builder: (context, provider, child) {
//         final product = provider.getProductByID(productId);

//         if (product == null) return const SizedBox.shrink();

//         return InkWell(
//           onTap: onTap,
//           child: Container(
//             height: 24,
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     "${product.productName}",
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1F2937),
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   saleItem.totalPrice.toStringAsFixed(2),
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: AppTheme.greenColor,
//                   ),
//                 ),
//                 const SizedBox(width: 2),
//                 if (saleItem.quantity > 1)
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF3B82F6),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       '×${saleItem.quantity}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class DataTableProductCell extends StatelessWidget {
  final String productId;
  final SaleItem saleItem;
  final VoidCallback? onTap;

  const DataTableProductCell({
    super.key,
    required this.productId,
    required this.saleItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, provider, child) {
        String name = "";
        if (saleItem.type == 'service') {
          final service = provider.getServiceById(saleItem.productId);
          name = service.name;
        } else {
          final product = provider.getProductByID(saleItem.productId);
          name = product.productName!;
        }
        //final product = provider.getProductByID(productId);

        return Container(
          height: 28, // Ultra compact height
          margin: const EdgeInsets.symmetric(vertical: 1),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Type indicator icon
                    _buildTypeIndicator(saleItem.type),
                    const SizedBox(width: 6),

                    // Item name (extremely compact)
                    Expanded(
                      child: Text(
                        _getDisplayName(name),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Financial indicators (compact)
                    _buildFinancialIndicators(),

                    // Quantity
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        'QTY: ${saleItem.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),

                    // Total price
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      constraints: const BoxConstraints(minWidth: 40),
                      child: Text(
                        'OMR ${saleItem.totalPrice.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.greenColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeIndicator(String type) {
    return Icon(
      type == 'service'
          ? Icons.build_circle_outlined
          : Icons.inventory_2_outlined,
      size: 14,
      color: type == 'service' ? Colors.blue.shade600 : Colors.grey.shade600,
    );
  }

  Widget _buildFinancialIndicators() {
    final hasDiscount = saleItem.discount > 0;
    final hasMargin = saleItem.margin > 0;

    if (!hasDiscount && !hasMargin) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasDiscount)
          Container(
            //margin: const EdgeInsets.only(right: 2),
            padding: const EdgeInsets.all(2),
            // decoration: BoxDecoration(
            //   color: Colors.orange.shade100,
            //   shape: BoxShape.circle,
            // ),
            child: Text(
              'D: ${saleItem.discount.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.orange.shade800,
                height: 0.8,
              ),
            ),
          ),
        // if (hasMargin)
        //   Container(
        //     margin: const EdgeInsets.only(right: 4),
        //     padding: const EdgeInsets.all(2),
        //     decoration: BoxDecoration(
        //       color: Colors.green.shade100,
        //       shape: BoxShape.circle,
        //     ),
        //     child: Text(
        //       'M',
        //       style: TextStyle(
        //         fontSize: 8,
        //         fontWeight: FontWeight.w900,
        //         color: Colors.green.shade800,
        //         height: 0.8,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  String _getDisplayName(String? productName) {
    final name = productName ?? 'Unknown Item';
    if (name.length <= 20) return name;
    return '${name.substring(0, 18)}..';
  }
}

// Grid-style display for multiple items
class ProductItemsGrid extends StatelessWidget {
  final List<SaleItem> saleItems;
  final Map<String, SaleItem> productIdToSaleItem;

  const ProductItemsGrid({
    super.key,
    required this.saleItems,
    required this.productIdToSaleItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 2,
          childAspectRatio: 4,
        ),
        itemCount: saleItems.length,
        itemBuilder: (context, index) {
          final saleItem = saleItems[index];
          return DataTableProductCell(
            productId: saleItem.productId,
            saleItem: saleItem,
          );
        },
      ),
    );
  }
}

// Vertical list with minimal separation
class ProductItemsList extends StatelessWidget {
  final List<SaleItem> saleItems;
  final Map<String, SaleItem> productIdToSaleItem;

  const ProductItemsList({
    super.key,
    required this.saleItems,
    required this.productIdToSaleItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: saleItems.length,
        itemBuilder: (context, index) {
          final saleItem = saleItems[index];
          return DataTableProductCell(
            productId: saleItem.productId,
            saleItem: saleItem,
          );
        },
      ),
    );
  }
}

// Chip-style display for extremely dense layouts
class ProductItemsChips extends StatelessWidget {
  final List<SaleItem> saleItems;
  final Map<String, SaleItem> productIdToSaleItem;

  const ProductItemsChips({
    super.key,
    required this.saleItems,
    required this.productIdToSaleItem,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: saleItems.map((saleItem) {
        return Consumer<MmResourceProvider>(
          builder: (context, provider, child) {
            final product = provider.getProductByID(saleItem.productId);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: saleItem.type == 'service'
                    ? Colors.blue.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: saleItem.type == 'service'
                      ? Colors.blue.shade200
                      : Colors.grey.shade300,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getShortName(product?.productName),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '×${saleItem.quantity}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    saleItem.totalPrice.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.greenColor,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  String _getShortName(String? productName) {
    final name = productName ?? 'Item';
    if (name.length <= 12) return name;
    return '${name.substring(0, 10)}..';
  }
}
