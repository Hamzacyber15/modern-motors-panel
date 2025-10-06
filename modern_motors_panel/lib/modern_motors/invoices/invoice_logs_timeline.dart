// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/mm_employee_info_tile.dart';

class InvoiceLogsTimeline extends StatefulWidget {
  final String saleId;

  const InvoiceLogsTimeline({super.key, required this.saleId});

  @override
  State<InvoiceLogsTimeline> createState() => _InvoiceLogsTimelineState();
}

class _InvoiceLogsTimelineState extends State<InvoiceLogsTimeline> {
  bool _isLoading = true;
  List<InvoiceLogModel> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mmInvoiceLogs')
          .doc(widget.saleId)
          .collection('invoiceLogs')
          .orderBy('timestamp', descending: true)
          .get();

      final logs = snapshot.docs
          .map((doc) => InvoiceLogModel.fromFirestore(doc))
          .toList();

      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading logs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade800,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Timeline History',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadLogs,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadLogs,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  final isFirst = index == 0;
                  final isLast = index == _logs.length - 1;
                  return TimelineLogCard(
                    log: log,
                    isFirst: isFirst,
                    isLast: isLast,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Activity Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No invoice logs available yet',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class TimelineLogCard extends StatelessWidget {
  final InvoiceLogModel log;
  final bool isFirst;
  final bool isLast;

  const TimelineLogCard({
    super.key,
    required this.log,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final eventConfig = _getEventConfig(log.event);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Column
        Column(
          children: [
            // Top line
            if (!isFirst)
              Container(width: 2, height: 20, color: Colors.grey.shade300),

            // Icon Circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: eventConfig.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: eventConfig.color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(eventConfig.icon, color: Colors.white, size: 24),
            ),

            // Bottom line
            if (!isLast)
              Container(width: 2, height: 80, color: Colors.grey.shade300),
          ],
        ),

        const SizedBox(width: 16),

        // Content Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: eventConfig.color, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            eventConfig.title,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(log.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(log.status),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            log.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(log.status),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimestamp(log.timestamp),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Details Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            'Total',
                            'OMR ${log.total.toStringAsFixed(2)}',
                            Icons.payments,
                            Colors.blue,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            'Quantity',
                            log.qty.toString(),
                            Icons.shopping_cart,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),

                    if (log.refund > 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.money_off,
                              size: 18,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Refund: OMR ${log.refund.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // User Info
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User ID',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // Text(
                                //   log.userID,
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.grey.shade800,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                                MmEmployeeInfoTile(employeeId: log.userID),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  EventConfig _getEventConfig(String event) {
    switch (event.toLowerCase()) {
      case 'created':
        return EventConfig(
          title: 'Invoice Created',
          icon: Icons.add_circle,
          color: Colors.green.shade600,
        );
      case 'updated':
        return EventConfig(
          title: 'Invoice Updated',
          icon: Icons.edit,
          color: Colors.blue.shade600,
        );
      case 'cancelled':
        return EventConfig(
          title: 'Invoice Cancelled',
          icon: Icons.cancel,
          color: Colors.red.shade600,
        );
      case 'completed':
        return EventConfig(
          title: 'Invoice Completed',
          icon: Icons.check_circle,
          color: Colors.teal.shade600,
        );
      case 'refunded':
        return EventConfig(
          title: 'Invoice Refunded',
          icon: Icons.money_off,
          color: Colors.orange.shade600,
        );
      default:
        return EventConfig(
          title: event,
          icon: Icons.info,
          color: Colors.grey.shade600,
        );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade700;
      case 'completed':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      case 'processing':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM dd, yyyy • HH:mm').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago • ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago • ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// Models
class InvoiceLogModel {
  final String customerName;
  final String event;
  final int qty;
  final double refund;
  final String saleID;
  final String status;
  final DateTime timestamp;
  final double total;
  final String userID;

  InvoiceLogModel({
    required this.customerName,
    required this.event,
    required this.qty,
    required this.refund,
    required this.saleID,
    required this.status,
    required this.timestamp,
    required this.total,
    required this.userID,
  });

  factory InvoiceLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InvoiceLogModel(
      customerName: data['customerName'] ?? '',
      event: data['event'] ?? '',
      qty: data['qty'] ?? 0,
      refund: (data['refund'] ?? 0).toDouble(),
      saleID: data['saleID'] ?? '',
      status: data['status'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      total: (data['total'] ?? 0).toDouble(),
      userID: data['userID'] ?? '',
    );
  }
}

class EventConfig {
  final String title;
  final IconData icon;
  final Color color;

  EventConfig({required this.title, required this.icon, required this.color});
}

// Usage Example
class InvoiceLogsDemo extends StatelessWidget {
  final String saleId;

  const InvoiceLogsDemo({Key? key, required this.saleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceLogsTimeline(saleId: saleId),
          ),
        );
      },
      icon: const Icon(Icons.history),
      label: const Text('View Invoice History'),
    );
  }
}
