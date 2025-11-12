import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modern_motors_panel/app_theme.dart';

class SaleCoaTransactions extends StatefulWidget {
  final String saleId;
  final String branchId;

  const SaleCoaTransactions({
    Key? key,
    required this.saleId,
    required this.branchId,
  }) : super(key: key);

  @override
  State<SaleCoaTransactions> createState() => _SaleCoaTransactionsState();
}

class _SaleCoaTransactionsState extends State<SaleCoaTransactions> {
  List<COATransactionWithAccount> _transactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCOATransactions();
  }

  Future<void> _loadCOATransactions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final transactionsQuery = await FirebaseFirestore.instance
          .collection('coaTransactions')
          .where('refID', isEqualTo: widget.saleId)
          .where('branchId', isEqualTo: widget.branchId)
          .get();

      List<COATransactionWithAccount> transactions = [];

      for (var doc in transactionsQuery.docs) {
        final transaction = COATransaction.fromFirestore(doc, null, null);

        final accountDoc = await FirebaseFirestore.instance
            .collection('chartOfAccounts')
            .doc(widget.branchId)
            .collection('chartOfAccounts')
            .doc(transaction.accountID)
            .get();

        if (accountDoc.exists) {
          final chartOfAccount = ChartOfAccount.fromFirestore(accountDoc);
          transactions.add(
            COATransactionWithAccount(
              transaction: transaction,
              account: chartOfAccount,
            ),
          );
        } else {
          transactions.add(
            COATransactionWithAccount(transaction: transaction, account: null),
          );
        }
      }

      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  double get _totalDebit => _transactions
      .where((t) => t.transaction.amount > 0)
      .fold(0, (sum, transaction) => sum + transaction.transaction.amount);

  double get _totalCredit => _transactions
      .where((t) => t.transaction.amount < 0)
      .fold(
        0,
        (sum, transaction) => sum + (transaction.transaction.amount * -1),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COA Statement - ${widget.saleId.substring(0, 8)}...'),
        //backgroundColor: Colors.blue.shade800,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppTheme.primaryColor),
            onPressed: _loadCOATransactions,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load transactions',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCOATransactions,
                    child: Text('Try Again'),
                  ),
                ],
              ),
            )
          : _transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No transactions found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'for this purchase in selected branch',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : _buildCompactStatement(),
    );
  }

  Widget _buildCompactStatement() {
    return Column(
      children: [
        // Summary Cards
        _buildSummaryCards(),
        SizedBox(height: 8),

        // Transactions List
        Expanded(child: _buildCompactTransactionList()),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          // Debit Card
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.green.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        size: 16,
                        color: Colors.green.shade800,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'DEBIT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'OMR ${_totalDebit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  Text(
                    '{"OMR"} ${_transactions.where((t) => t.transaction.amount > 0).length} entries',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),

          // Credit Card
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade50, Colors.red.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: Colors.red.shade800,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'CREDIT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'OMR ${_totalCredit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                  Text(
                    'OMR ${_transactions.where((t) => t.transaction.amount < 0).length} entries',
                    style: TextStyle(fontSize: 11, color: Colors.red.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTransactionList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // Table Header
          _buildCompactHeader(),
          SizedBox(height: 8),

          // Transactions
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                return _buildCompactTransactionRow(_transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Account
          Expanded(
            flex: 3,
            child: Text(
              'ACCOUNT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          // Vertical Line
          Container(
            width: 1,
            height: 20,
            color: Colors.grey.shade400,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          // Description
          Expanded(
            flex: 3,
            child: Text(
              'DESCRIPTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          // Vertical Line
          Container(
            width: 1,
            height: 20,
            color: Colors.grey.shade400,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          // Debit
          Expanded(
            flex: 2,
            child: Text(
              'DEBIT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // Vertical Line
          Container(
            width: 1,
            height: 20,
            color: Colors.grey.shade400,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          // Credit
          Expanded(
            flex: 2,
            child: Text(
              'CREDIT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTransactionRow(
    COATransactionWithAccount transactionWithAccount,
  ) {
    final transaction = transactionWithAccount.transaction;
    final account = transactionWithAccount.account;
    final isDebit = transaction.amount > 0;
    final debitAmount = isDebit ? transaction.amount : 0.0;
    final creditAmount = !isDebit ? (transaction.amount * -1) : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Information
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account?.accountName ?? 'Unknown Account',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        account?.accountCode ?? 'N/A',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getAccountTypeColor(account?.accountType),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getShortAccountType(account?.accountType),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Vertical Line between Account and Description
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),

          // Description
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.memo,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        transaction.refType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      _formatDateCompact(transaction.date),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                if (transaction.vat > 0) ...[
                  SizedBox(height: 2),
                  Text(
                    'VAT: \$${transaction.vat.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Vertical Line between Description and Debit
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),

          // Debit Amount
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (debitAmount > 0) ...[
                  Text(
                    '\$${debitAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 2,
                    color: Colors.green.shade300,
                    margin: EdgeInsets.only(top: 2),
                  ),
                ] else
                  Text(
                    '-',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
              ],
            ),
          ),

          // Vertical Line between Debit and Credit
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),

          // Credit Amount
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (creditAmount > 0) ...[
                  Text(
                    '\$${creditAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade800,
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 2,
                    color: Colors.red.shade300,
                    margin: EdgeInsets.only(top: 2),
                  ),
                ] else
                  Text(
                    '-',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAccountTypeColor(String? accountType) {
    switch (accountType?.toLowerCase()) {
      case 'asset':
        return Colors.blue.shade600;
      case 'liability':
        return Colors.red.shade600;
      case 'equity':
        return Colors.green.shade600;
      case 'revenue':
        return Colors.purple.shade600;
      case 'expense':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _getShortAccountType(String? accountType) {
    switch (accountType?.toLowerCase()) {
      case 'asset':
        return 'A';
      case 'liability':
        return 'L';
      case 'equity':
        return 'E';
      case 'revenue':
        return 'R';
      case 'expense':
        return 'X';
      default:
        return '?';
    }
  }

  String _formatDateCompact(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}';
  }
}

// Combined model to hold both transaction and account data
class COATransactionWithAccount {
  final COATransaction transaction;
  final ChartOfAccount? account;

  COATransactionWithAccount({required this.transaction, required this.account});
}

// Your existing models
class COATransaction {
  final String id;
  final String accountID;
  final double amount;
  final String branchId;
  final double cost;
  final Timestamp createdAt;
  final Timestamp date;
  final String memo;
  final String refID;
  final String refType;
  final double vat;
  final String? accountCode;
  final String? accountName;

  COATransaction({
    required this.id,
    required this.accountID,
    required this.amount,
    required this.branchId,
    required this.cost,
    required this.createdAt,
    required this.date,
    required this.memo,
    required this.refID,
    required this.refType,
    required this.vat,
    this.accountCode,
    this.accountName,
  });

  factory COATransaction.fromFirestore(
    DocumentSnapshot doc,
    String? accountCode,
    String? accountName,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return COATransaction(
      id: doc.id,
      accountID: data['accountID'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      branchId: data['branchId'] ?? '',
      cost: (data['cost'] ?? 0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      date: data['date'] ?? Timestamp.now(),
      memo: data['memo'] ?? '',
      refID: data['refID'] ?? '',
      refType: data['refType'] ?? '',
      vat: (data['vat'] ?? 0).toDouble(),
      accountCode: accountCode,
      accountName: accountName,
    );
  }
}

class ChartOfAccount {
  final String id;
  final String accountCode;
  final String accountName;
  final String accountSubType;
  final String accountType;
  final String branchId;
  final List<String> childAccountIds;
  final Timestamp createdAt;
  final double currentBalance;
  final List<String> defaultFor;
  final String description;
  final bool isActive;
  final bool isDefault;
  final int level;
  final String? parentAccountId;
  final String refId;

  ChartOfAccount({
    required this.id,
    required this.accountCode,
    required this.accountName,
    required this.accountSubType,
    required this.accountType,
    required this.branchId,
    required this.childAccountIds,
    required this.createdAt,
    required this.currentBalance,
    required this.defaultFor,
    required this.description,
    required this.isActive,
    required this.isDefault,
    required this.level,
    this.parentAccountId,
    required this.refId,
  });

  factory ChartOfAccount.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChartOfAccount(
      id: doc.id,
      accountCode: data['account_code'] ?? '',
      accountName: data['account_name'] ?? '',
      accountSubType: data['account_sub_type'] ?? '',
      accountType: data['account_type'] ?? '',
      branchId: data['branch_id'] ?? '',
      childAccountIds: List<String>.from(data['child_account_ids'] ?? []),
      createdAt: data['created_at'] ?? Timestamp.now(),
      currentBalance: (data['current_balance'] ?? 0).toDouble(),
      defaultFor: List<String>.from(data['default_for'] ?? []),
      description: data['description'] ?? '',
      isActive: data['is_active'] ?? false,
      isDefault: data['is_default'] ?? false,
      level: data['level'] ?? 0,
      parentAccountId: data['parent_account_id'],
      refId: data['ref_id'] ?? '',
    );
  }
}
