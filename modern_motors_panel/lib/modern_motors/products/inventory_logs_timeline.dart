// // ignore_for_file: deprecated_member_use

// import 'package:app/modern_motors/models/inventory/mm_inventory_log.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';

// // Enhanced Inventory Log Timeline Widget
// class InventoryLogsTimeline extends StatelessWidget {
//   final List<MmInventoryLog> inventoryLogs;
//   final bool isLoading;
//   final VoidCallback? onRefresh;

//   const InventoryLogsTimeline({
//     super.key,
//     required this.inventoryLogs,
//     this.isLoading = false,
//     this.onRefresh,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (inventoryLogs.isEmpty) {
//       return _buildEmptyState(context);
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: inventoryLogs.length,
//       itemBuilder: (context, index) {
//         final log = inventoryLogs[index];
//         final isLast = index == inventoryLogs.length - 1;

//         return InventoryLogTimelineItem(
//           log: log,
//           isLast: isLast,
//         );
//       },
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.timeline,
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Inventory Timeline',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF0F172A),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${inventoryLogs.length} transactions',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF64748B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (onRefresh != null)
//             IconButton(
//               onPressed: onRefresh,
//               icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(
//               Icons.timeline_outlined,
//               size: 48,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No inventory transactions',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Transactions will appear here once inventory changes',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF64748B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class InventoryLogTimelineItem extends StatelessWidget {
//   final MmInventoryLog log;
//   final bool isLast;

//   const InventoryLogTimelineItem({
//     super.key,
//     required this.log,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Timeline indicator
//           Column(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   gradient: _getTypeGradient(),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _getTypeColor().withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   _getTypeIcon(),
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               if (!isLast)
//                 Container(
//                   width: 2,
//                   height: 40,
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         _getTypeColor().withOpacity(0.3),
//                         Colors.grey.withOpacity(0.1),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),
//             ],
//           ),

//           const SizedBox(width: 16),

//           // Content
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: _getTypeColor().withOpacity(0.1),
//                   width: 1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header row
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               _getTypeColor().withOpacity(0.1),
//                               _getTypeColor().withOpacity(0.05)
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                               color: _getTypeColor().withOpacity(0.2)),
//                         ),
//                         child: Text(
//                           log.type.capitalizeFirst,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: _getTypeColor(),
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         DateFormat('MMM dd, yyyy • HH:mm')
//                             .format(log.timestamp.toDate()),
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF64748B),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 12),

//                   // Document info
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF8FAFC),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Icon(
//                           Icons.description_outlined,
//                           size: 16,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '${log.documentType.toUpperCase()}-${log.documentId.substring(0, 8)}',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 12),

//                   // Stock changes
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF8FAFC),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildMetricColumn(
//                             'Stock Change',
//                             log.change > 0
//                                 ? '+${log.change}'
//                                 : log.change.toString(),
//                             log.change > 0 ? Colors.green : Colors.red,
//                             Icons.trending_up,
//                           ),
//                         ),
//                         Container(
//                           width: 1,
//                           height: 40,
//                           color: Colors.grey.shade300,
//                         ),
//                         Expanded(
//                           child: _buildMetricColumn(
//                             'Previous',
//                             log.previousStock.toString(),
//                             const Color(0xFF64748B),
//                             Icons.inventory_2_outlined,
//                           ),
//                         ),
//                         Container(
//                           width: 1,
//                           height: 40,
//                           color: Colors.grey.shade300,
//                         ),
//                         Expanded(
//                           child: _buildMetricColumn(
//                             'New Stock',
//                             log.newStock.toString(),
//                             const Color(0xFF059669),
//                             Icons.inventory,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // Financial impact
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildFinancialMetric(
//                           'Avg Cost',
//                           'OMR ${log.previousAverageCost.toStringAsFixed(2)} → OMR ${log.newAverageCost.toStringAsFixed(2)}',
//                           Icons.attach_money,
//                           const Color(0xFF3B82F6),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildFinancialMetric(
//                           'Value Impact',
//                           'OMR ${log.valueImpact.toStringAsFixed(2)}',
//                           Icons.account_balance_wallet,
//                           log.valueImpact >= 0 ? Colors.green : Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Note if exists
//                   if (log.note.isNotEmpty) ...[
//                     const SizedBox(height: 12),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.amber.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(8),
//                         border:
//                             Border.all(color: Colors.amber.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.note_outlined,
//                             size: 16,
//                             color: Colors.amber.shade700,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               log.note,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.amber.shade800,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricColumn(
//       String label, String value, Color color, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, size: 16, color: color),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w700,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFinancialMetric(
//       String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: color.withOpacity(0.8),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   IconData _getTypeIcon() {
//     switch (log.type.toLowerCase()) {
//       case 'sale':
//       case 'sales':
//         return Icons.point_of_sale;
//       case 'purchase':
//       case 'buying':
//         return Icons.shopping_cart;
//       case 'return':
//       case 'sales_return':
//         return Icons.keyboard_return;
//       case 'purchase_return':
//         return Icons.undo;
//       case 'adjustment':
//       case 'stock_adjustment':
//         return Icons.tune;
//       case 'transfer':
//         return Icons.swap_horiz;
//       case 'production':
//         return Icons.precision_manufacturing;
//       case 'damage':
//       case 'wastage':
//         return Icons.report_problem;
//       default:
//         return Icons.inventory_2;
//     }
//   }

//   Color _getTypeColor() {
//     switch (log.type.toLowerCase()) {
//       case 'sale':
//       case 'sales':
//         return const Color(0xFF059669); // Green for sales
//       case 'purchase':
//       case 'buying':
//         return const Color(0xFF3B82F6); // Blue for purchases
//       case 'return':
//       case 'sales_return':
//         return const Color(0xFFEF4444); // Red for returns
//       case 'purchase_return':
//         return const Color(0xFFF59E0B); // Orange for purchase returns
//       case 'adjustment':
//       case 'stock_adjustment':
//         return const Color(0xFF8B5CF6); // Purple for adjustments
//       case 'transfer':
//         return const Color(0xFF06B6D4); // Cyan for transfers
//       case 'production':
//         return const Color(0xFF10B981); // Emerald for production
//       case 'damage':
//       case 'wastage':
//         return const Color(0xFFDC2626); // Dark red for damage
//       default:
//         return const Color(0xFF64748B); // Gray for unknown
//     }
//   }

//   LinearGradient _getTypeGradient() {
//     final color = _getTypeColor();
//     return LinearGradient(
//       colors: [color, color.withOpacity(0.8)],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     );
//   }
// }

// // Extension to capitalize first letter
// extension StringExtension on String {
//   String get capitalizeFirst {
//     if (isEmpty) return this;
//     return this[0].toUpperCase() + substring(1).toLowerCase();
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modern_motors_panel/model/inventory_models/modern_motors.dart/mminventory_logs.dart';

// Enhanced Inventory Log Timeline Widget
class InventoryLogsTimeline extends StatelessWidget {
  final List<MmInventoryLog> inventoryLogs;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const InventoryLogsTimeline({
    super.key,
    required this.inventoryLogs,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (inventoryLogs.isEmpty) {
      return _buildEmptyState(context);
    }

    // _buildHeader(context),
    // const SizedBox(height: 16),
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: inventoryLogs.length,
      itemBuilder: (context, index) {
        final log = inventoryLogs[index];
        final isLast = index == inventoryLogs.length - 1;

        return InventoryLogTimelineItem(log: log, isLast: isLast);
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.timeline, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inventory Timeline',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${inventoryLogs.length} transactions',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (onRefresh != null)
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.timeline_outlined,
              size: 48,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No inventory transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Transactions will appear here once inventory changes',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class InventoryLogTimelineItem extends StatelessWidget {
  final MmInventoryLog log;
  final bool isLast;

  const InventoryLogTimelineItem({
    super.key,
    required this.log,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Fixed height like ProductCard
      margin: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: _getTypeGradient(),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _getTypeColor().withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(_getTypeIcon(), color: Colors.white, size: 20),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 66,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getTypeColor().withOpacity(0.3),
                        Colors.grey.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Container(
              height: 110,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getTypeColor().withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getTypeColor(),
                              _getTypeColor().withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.type.capitalizeFirst,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Expanded(
                      //   child: Text(
                      //     '${log.documentType.toUpperCase()}-${log.documentId.substring(0, 6)}',
                      //     style: const TextStyle(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w600,
                      //       color: Color(0xFF1E293B),
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                      Text(
                        DateFormat('MMM dd').format(log.timestamp.toDate()),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Stock and financial info in compact rows
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactMetric(
                          'Change',
                          log.change > 0
                              ? '+${log.change}'
                              : log.change.toString(),
                          log.change > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      Expanded(
                        child: _buildCompactMetric(
                          'Unit Cost',
                          'OMR ${log.unitCost.toStringAsFixed(2)}',
                          const Color(0xFF3B82F6),
                        ),
                      ),
                      Expanded(
                        child: _buildCompactMetric(
                          'Previous',
                          log.previousStock.toString(),
                          const Color(0xFF64748B),
                        ),
                      ),
                      Expanded(
                        child: _buildCompactMetric(
                          'New Stock',
                          log.newStock.toString(),
                          const Color(0xFF059669),
                        ),
                      ),
                      Expanded(
                        child: _buildCompactMetric(
                          'Value Impact',
                          'OMR ${log.valueImpact.toStringAsFixed(2)}',
                          log.valueImpact >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Financial metrics
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _buildCompactMetric(
                  //         'Unit Cost',
                  //         'OMR ${log.unitCost.toStringAsFixed(2)}',
                  //         const Color(0xFF3B82F6),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: _buildCompactMetric(
                  //         'Value Impact',
                  //         'OMR ${log.valueImpact.toStringAsFixed(2)}',
                  //         log.valueImpact >= 0 ? Colors.green : Colors.red,
                  //       ),
                  //     ),
                  //     // Note indicator if exists
                  //     if (log.note.isNotEmpty)
                  //       Container(
                  //         padding: const EdgeInsets.all(4),
                  //         decoration: BoxDecoration(
                  //           color: Colors.amber.withOpacity(0.1),
                  //           borderRadius: BorderRadius.circular(4),
                  //         ),
                  //         child: Icon(
                  //           Icons.sticky_note_2,
                  //           size: 12,
                  //           color: Colors.amber.shade700,
                  //         ),
                  //       ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  IconData _getTypeIcon() {
    switch (log.type.toLowerCase()) {
      case 'sale':
      case 'sales':
        return Icons.point_of_sale;
      case 'purchase':
      case 'buying':
        return Icons.shopping_cart;
      case 'return':
      case 'sales_return':
        return Icons.keyboard_return;
      case 'purchase_return':
        return Icons.undo;
      case 'adjustment':
      case 'stock_adjustment':
        return Icons.tune;
      case 'transfer':
        return Icons.swap_horiz;
      case 'production':
        return Icons.precision_manufacturing;
      case 'damage':
      case 'wastage':
        return Icons.report_problem;
      default:
        return Icons.inventory_2;
    }
  }

  Color _getTypeColor() {
    switch (log.type.toLowerCase()) {
      case 'sale':
      case 'sales':
        return const Color(0xFF059669); // Green for sales
      case 'purchase':
      case 'buying':
        return const Color(0xFF3B82F6); // Blue for purchases
      case 'return':
      case 'sales_return':
        return const Color(0xFFEF4444); // Red for returns
      case 'purchase_return':
        return const Color(0xFFF59E0B); // Orange for purchase returns
      case 'adjustment':
      case 'stock_adjustment':
        return const Color(0xFF8B5CF6); // Purple for adjustments
      case 'transfer':
        return const Color(0xFF06B6D4); // Cyan for transfers
      case 'production':
        return const Color(0xFF10B981); // Emerald for production
      case 'damage':
      case 'wastage':
        return const Color(0xFFDC2626); // Dark red for damage
      default:
        return const Color(0xFF64748B); // Gray for unknown
    }
  }

  LinearGradient _getTypeGradient() {
    final color = _getTypeColor();
    return LinearGradient(
      colors: [color, color.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
