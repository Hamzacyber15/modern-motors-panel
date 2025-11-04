// invoice_history_models.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum TransactionType { created, payment, refund, adjustment, cancelled }

class TransactionTypeConfig {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color iconBgColor;
  final Color borderColor;

  const TransactionTypeConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.iconBgColor,
    required this.borderColor,
  });

  static TransactionTypeConfig getConfig(TransactionType type) {
    switch (type) {
      case TransactionType.created:
        return const TransactionTypeConfig(
          label: 'Invoice Created',
          icon: Icons.description,
          color: Colors.blue,
          bgColor: Color(0xFFEFF6FF),
          iconBgColor: Color(0xFF3B82F6),
          borderColor: Color(0xFFBFDBFE),
        );
      case TransactionType.payment:
        return const TransactionTypeConfig(
          label: 'Payment Received',
          icon: Icons.credit_card,
          color: Colors.green,
          bgColor: Color(0xFFF0FDF4),
          iconBgColor: Color(0xFF22C55E),
          borderColor: Color(0xFFBBF7D0),
        );
      case TransactionType.refund:
        return const TransactionTypeConfig(
          label: 'Refund Issued',
          icon: Icons.refresh,
          color: Colors.orange,
          bgColor: Color(0xFFFFF7ED),
          iconBgColor: Color(0xFFF97316),
          borderColor: Color(0xFFFED7AA),
        );
      case TransactionType.adjustment:
        return const TransactionTypeConfig(
          label: 'Balance Adjustment',
          icon: Icons.attach_money,
          color: Colors.purple,
          bgColor: Color(0xFFFAF5FF),
          iconBgColor: Color(0xFFA855F7),
          borderColor: Color(0xFFE9D5FF),
        );
      case TransactionType.cancelled:
        return const TransactionTypeConfig(
          label: 'Invoice Cancelled',
          icon: Icons.cancel,
          color: Colors.red,
          bgColor: Color(0xFFFEF2F2),
          iconBgColor: Color(0xFFEF4444),
          borderColor: Color(0xFFFECACA),
        );
    }
  }
}

class TransactionDetails {
  final double? amount;
  final String? method;
  final String? reference;
  final int? id;
  final String? reason;
  final String? note;

  TransactionDetails({
    this.amount,
    this.method,
    this.reference,
    this.id,
    this.reason,
    this.note,
  });

  factory TransactionDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return TransactionDetails();
    return TransactionDetails(
      amount: (map['amount'] as num?)?.toDouble(),
      method: map['method'] as String?,
      reference: map['reference'] as String?,
      id: map['id'] as int?,
      reason: map['reason'] as String?,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (amount != null) 'amount': amount,
      if (method != null) 'method': method,
      if (reference != null) 'reference': reference,
      if (id != null) 'id': id,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
    };
  }
}

class InvoiceHistoryEntry {
  final String id;
  final TransactionType type;
  final DateTime timestamp;
  final double newBalance;
  final double prevBalance;
  final TransactionDetails? details;

  InvoiceHistoryEntry({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.newBalance,
    required this.prevBalance,
    this.details,
  });

  factory InvoiceHistoryEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InvoiceHistoryEntry(
      id: doc.id,
      type: TransactionType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => TransactionType.adjustment,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      newBalance: (data['newBalance'] as num).toDouble(),
      prevBalance: (data['prevBalance'] as num).toDouble(),
      details: TransactionDetails.fromMap(
        data['details'] as Map<String, dynamic>?,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'newBalance': newBalance,
      'prevBalance': prevBalance,
      if (details != null) 'details': details!.toMap(),
    };
  }

  double get balanceChange => newBalance - prevBalance;
  bool get hasBalanceChange => balanceChange != 0;
  bool get isBalanceIncrease => balanceChange > 0;
}

// invoice_history_service.dart
class InvoiceHistoryService {
  final FirebaseFirestore _firestore;

  InvoiceHistoryService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetch all history logs for a sale
  Future<List<InvoiceHistoryEntry>> getHistory(String saleId) async {
    try {
      final snapshot = await _firestore
          .collection('sales')
          .doc(saleId)
          .collection('history')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => InvoiceHistoryEntry.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  /// Add a new history entry
  Future<void> addHistoryEntry({
    required String saleId,
    required TransactionType type,
    required double newBalance,
    required double prevBalance,
    TransactionDetails? details,
  }) async {
    try {
      await _firestore
          .collection('sales')
          .doc(saleId)
          .collection('history')
          .add({
            'type': type.name,
            'timestamp': FieldValue.serverTimestamp(),
            'newBalance': newBalance,
            'prevBalance': prevBalance,
            if (details != null) 'details': details.toMap(),
          });
    } catch (e) {
      print('Error adding history entry: $e');
      rethrow;
    }
  }
}

// class SalesLogsTimeline extends StatefulWidget {
//   final String saleId;

//   const SalesLogsTimeline({super.key, required this.saleId});

//   @override
//   State<SalesLogsTimeline> createState() => _SalesLogsTimelineState();
// }

// class _SalesLogsTimelineState extends State<SalesLogsTimeline> {
//   late final InvoiceHistoryService _historyService;
//   List<InvoiceHistoryEntry> _history = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _historyService = InvoiceHistoryService();
//     _loadHistory();
//   }

//   Future<void> _loadHistory() async {
//     setState(() => _isLoading = true);
//     final history = await _historyService.getHistory(widget.saleId);
//     setState(() {
//       _history = history;
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         title: const Text('Invoice History'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHistory),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Invoice History',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Sale ID: ${widget.saleId}',
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _history.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: _history.length,
//                     itemBuilder: (context, index) {
//                       final entry = _history[index];
//                       final isLast = index == _history.length - 1;
//                       return TimelineEntry(entry: entry, isLast: isLast);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.description, size: 64, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           const Text(
//             'No History Available',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Invoice history will appear here once transactions occur.',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TimelineEntry extends StatelessWidget {
//   final InvoiceHistoryEntry entry;
//   final bool isLast;

//   const TimelineEntry({Key? key, required this.entry, required this.isLast})
//     : super(key: key);

//   String formatCurrency(double amount) {
//     return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(amount);
//   }

//   String formatTimestamp(DateTime timestamp) {
//     return DateFormat('MMM d, yyyy • h:mm a').format(timestamp);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = TransactionTypeConfig.getConfig(entry.type);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 24),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Timeline indicator
//           Column(
//             children: [
//               Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: config.iconBgColor,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: config.iconBgColor.withOpacity(0.4),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(config.icon, size: 14, color: Colors.white),
//               ),
//               if (!isLast)
//                 Container(
//                   width: 2,
//                   height: 100,
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   decoration: BoxDecoration(color: Colors.grey[300]),
//                 ),
//             ],
//           ),
//           const SizedBox(width: 16),
//           // Content card
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border(
//                   left: BorderSide(color: config.borderColor, width: 4),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: config.bgColor,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(12),
//                         topRight: Radius.circular(12),
//                       ),
//                       border: Border(
//                         bottom: BorderSide(color: Colors.grey[200]!),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           config.label,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.access_time,
//                               size: 14,
//                               color: Colors.grey[600],
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               formatTimestamp(entry.timestamp),
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Body
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Balance information
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildBalanceInfo(
//                                 'Previous Balance',
//                                 entry.prevBalance,
//                                 Colors.grey[700]!,
//                               ),
//                             ),
//                             Expanded(
//                               child: _buildBalanceInfo(
//                                 'New Balance',
//                                 entry.newBalance,
//                                 Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                         // Balance change indicator
//                         if (entry.hasBalanceChange) ...[
//                           const SizedBox(height: 12),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: entry.isBalanceIncrease
//                                   ? const Color(0xFFFEE2E2)
//                                   : const Color(0xFFDCFCE7),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               '${entry.isBalanceIncrease ? '+' : '-'} ${formatCurrency(entry.balanceChange.abs())}',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: entry.isBalanceIncrease
//                                     ? const Color(0xFFB91C1C)
//                                     : const Color(0xFF15803D),
//                               ),
//                             ),
//                           ),
//                         ],
//                         // Transaction details
//                         if (entry.details != null) ...[
//                           const SizedBox(height: 16),
//                           Container(
//                             padding: const EdgeInsets.only(top: 16),
//                             decoration: BoxDecoration(
//                               border: Border(
//                                 top: BorderSide(color: Colors.grey[200]!),
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Transaction Details',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 _buildDetailsGrid(entry.details!),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBalanceInfo(String label, double amount, Color textColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label.toUpperCase(),
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey[600],
//             letterSpacing: 0.5,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           formatCurrency(amount),
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: textColor,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailsGrid(TransactionDetails details) {
//     final items = <Widget>[];

//     if (details.amount != null) {
//       items.add(_buildDetailItem('Amount', formatCurrency(details.amount!)));
//     }
//     if (details.method != null) {
//       items.add(_buildDetailItem('Method', details.method!));
//     }
//     if (details.reference != null) {
//       items.add(_buildDetailItem('Reference', details.reference!));
//     }
//     if (details.id != null) {
//       items.add(_buildDetailItem('Transaction ID', '#${details.id}'));
//     }
//     if (details.reason != null) {
//       items.add(_buildDetailItem('Reason', details.reason!, fullWidth: true));
//     }
//     if (details.note != null) {
//       items.add(_buildDetailItem('Note', details.note!, fullWidth: true));
//     }

//     return Wrap(spacing: 16, runSpacing: 12, children: items);
//   }

//   Widget _buildDetailItem(
//     String label,
//     String value, {
//     bool fullWidth = false,
//   }) {
//     return SizedBox(
//       width: fullWidth ? double.infinity : null,
//       child: Row(
//         mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
//         children: [
//           Text(
//             '$label:',
//             style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//           ),
//           const SizedBox(width: 8),
//           Flexible(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SalesLogsTimeline extends StatefulWidget {
  final String saleId;

  const SalesLogsTimeline({super.key, required this.saleId});

  @override
  State<SalesLogsTimeline> createState() => _SalesLogsTimelineState();
}

class _SalesLogsTimelineState extends State<SalesLogsTimeline> {
  final InvoiceHistoryService _historyService = InvoiceHistoryService();
  List<InvoiceHistoryEntry> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await _historyService.getHistory(widget.saleId);
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading history: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Invoice History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Compact header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Invoice History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sale ID: ${widget.saleId}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final entry = _history[index];
                      final isLast = index == _history.length - 1;
                      return TimelineEntry(entry: entry, isLast: isLast);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          const Text(
            'No History Available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Invoice history will appear here once transactions occur.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineEntry extends StatelessWidget {
  final InvoiceHistoryEntry entry;
  final bool isLast;

  const TimelineEntry({Key? key, required this.entry, required this.isLast})
    : super(key: key);

  String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(amount);
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM d, yyyy • h:mm a').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final config = TransactionTypeConfig.getConfig(entry.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact timeline indicator
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: config.iconBgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: config.iconBgColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(config.icon, size: 12, color: Colors.white),
              ),
              if (!isLast)
                Container(
                  width: 1.5,
                  height: 60, // Reduced connector height
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(color: Colors.grey[300]),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Compact content card
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  left: BorderSide(color: config.borderColor, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Compact header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: config.bgColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                config.label,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formatTimestamp(entry.timestamp),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Balance change indicator moved to header for space saving
                        if (entry.hasBalanceChange)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: entry.isBalanceIncrease
                                  ? const Color(0xFFFEE2E2)
                                  : const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${entry.isBalanceIncrease ? '+' : '-'}${formatCurrency(entry.balanceChange.abs())}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: entry.isBalanceIncrease
                                    ? const Color(0xFFB91C1C)
                                    : const Color(0xFF15803D),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Compact body
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Compact balance information
                        Row(
                          children: [
                            Expanded(
                              child: _buildBalanceInfo(
                                'Previous',
                                entry.prevBalance,
                                Colors.grey[700]!,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey[200],
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            Expanded(
                              child: _buildBalanceInfo(
                                'Current',
                                entry.newBalance,
                                Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        // Transaction details - only show if exists
                        if (entry.details != null &&
                            entry.details!.amount != null &&
                            entry.details!.amount! > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey[200]!),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildCompactDetails(entry.details!),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(String label, double amount, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatCurrency(amount),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactDetails(TransactionDetails details) {
    final items = <Widget>[];

    if (details.amount != null) {
      items.add(
        _buildCompactDetailItem('Amount', formatCurrency(details.amount!)),
      );
    }
    if (details.method != null) {
      items.add(_buildCompactDetailItem('Method', details.method!));
    }
    if (details.reference != null && details.reference!.isNotEmpty) {
      items.add(_buildCompactDetailItem('Ref', details.reference!));
    }
    if (details.id != null) {
      items.add(_buildCompactDetailItem('ID', '#${details.id}'));
    }
    if (details.reason != null && details.reason!.isNotEmpty) {
      items.add(
        _buildCompactDetailItem('Reason', details.reason!, isImportant: true),
      );
    }
    if (details.note != null && details.note!.isNotEmpty) {
      items.add(
        _buildCompactDetailItem('Note', details.note!, isImportant: true),
      );
    }

    return Wrap(spacing: 8, runSpacing: 6, children: items);
  }

  Widget _buildCompactDetailItem(
    String label,
    String value, {
    bool isImportant = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isImportant ? Colors.grey[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isImportant ? Border.all(color: Colors.grey[300]!) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
