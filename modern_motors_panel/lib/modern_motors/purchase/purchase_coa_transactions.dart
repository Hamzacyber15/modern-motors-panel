import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PurchaseCOAStatement extends StatefulWidget {
  final String purchaseId;
  final String branchId;

  const PurchaseCOAStatement({
    Key? key,
    required this.purchaseId,
    required this.branchId,
  }) : super(key: key);

  @override
  State<PurchaseCOAStatement> createState() => _PurchaseCOAStatementState();
}

class _PurchaseCOAStatementState extends State<PurchaseCOAStatement> {
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

      // Fetch COA transactions for this purchase
      final transactionsQuery = await FirebaseFirestore.instance
          .collection('coaTransactions')
          .where('refID', isEqualTo: widget.purchaseId)
          .get();

      List<COATransactionWithAccount> transactions = [];

      for (var doc in transactionsQuery.docs) {
        final transaction = COATransaction.fromFirestore(doc, null, null);

        // Fetch account details
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

  List<COATransactionWithAccount> get _debitTransactions =>
      _transactions.where((t) => t.transaction.amount > 0).toList();

  List<COATransactionWithAccount> get _creditTransactions =>
      _transactions.where((t) => t.transaction.amount < 0).toList();

  double get _totalDebit => _debitTransactions.fold(
    0,
    (sum, transaction) => sum + transaction.transaction.amount,
  );

  double get _totalCredit => _creditTransactions.fold(
    0,
    (sum, transaction) => sum + (transaction.transaction.amount * -1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COA Statement - Purchase ${widget.purchaseId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
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
                  Text('Error loading transactions'),
                  Text(_error!),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCOATransactions,
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : _transactions.isEmpty
          ? Center(child: Text('No COA transactions found for this purchase'))
          : _buildStatement(),
    );
  }

  Widget _buildStatement() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            SizedBox(height: 24),

            // Transaction Table
            _buildTransactionTable(),
            SizedBox(height: 24),

            // Totals
            _buildTotalsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chart of Accounts Statement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 8),
            Text('Purchase ID: ${widget.purchaseId}'),
            Text('Branch ID: ${widget.branchId}'),
            Text('Generated on: ${DateTime.now().toString().split(' ')[0]}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Table Header
            _buildTableHeader(),
            SizedBox(height: 8),

            // Debit Transactions
            if (_debitTransactions.isNotEmpty) ...[
              Text(
                'Debit Side',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 8),
              ..._debitTransactions.map(_buildTransactionRow).toList(),
              SizedBox(height: 16),
            ],

            // Credit Transactions
            if (_creditTransactions.isNotEmpty) ...[
              Text(
                'Credit Side',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
              SizedBox(height: 8),
              ..._creditTransactions.map(_buildTransactionRow).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('Memo', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(
    COATransactionWithAccount transactionWithAccount,
  ) {
    final transaction = transactionWithAccount.transaction;
    final account = transactionWithAccount.account;
    final isDebit = transaction.amount > 0;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              account?.accountName ?? 'Account Not Found',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(flex: 1, child: Text(account?.accountCode ?? 'N/A')),
          Expanded(
            flex: 1,
            child: Text(
              '\$${transaction.amount.abs().toStringAsFixed(2)}',
              style: TextStyle(
                color: isDebit ? Colors.green.shade800 : Colors.red.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(transaction.memo, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 1,
            child: Text(
              _formatDate(transaction.date),
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTotalCard(
              'Total Debit',
              _totalDebit,
              Colors.green.shade800,
              Icons.arrow_downward,
            ),
            _buildTotalCard(
              'Total Credit',
              _totalCredit,
              Colors.red.shade800,
              Icons.arrow_upward,
            ),
            _buildTotalCard(
              'Balance',
              (_totalDebit - _totalCredit).abs(),
              _totalDebit > _totalCredit
                  ? Colors.blue.shade800
                  : Colors.orange.shade800,
              Icons.balance,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
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
