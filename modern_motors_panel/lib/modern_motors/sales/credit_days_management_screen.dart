// main_screen.dart
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/modern_motors/sales/credit_days_manager.dart';

class CreditDaysManagementScreen extends StatefulWidget {
  const CreditDaysManagementScreen({super.key});

  @override
  CreditDaysManagementScreenState createState() =>
      CreditDaysManagementScreenState();
}

class CreditDaysManagementScreenState
    extends State<CreditDaysManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text('Credit Terms Management'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Terms Configuration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage credit periods and payment terms for your invoices',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            Expanded(child: CreditDaysManager(enableEditing: true)),
          ],
        ),
      ),
    );
  }
}
