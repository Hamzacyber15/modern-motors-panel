// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // =====================================================
// // MODELS
// // =====================================================

// enum AccountType {
//   asset('ASSET', 1),
//   liability('LIABILITY', 2),
//   equity('EQUITY', 3),
//   income('INCOME', 4),
//   expense('EXPENSE', 5);

//   const AccountType(this.displayName, this.order);
//   final String displayName;
//   final int order;
// }

// enum AccountSubType {
//   // Assets
//   currentAsset('Current Asset', AccountType.asset),
//   fixedAsset('Fixed Asset', AccountType.asset),

//   // Liabilities
//   currentLiability('Current Liability', AccountType.liability),
//   longTermLiability('Long Term Liability', AccountType.liability),

//   // Equity
//   capital('Capital', AccountType.equity),
//   retainedEarnings('Retained Earnings', AccountType.equity),

//   // Income
//   revenue('Revenue', AccountType.income),
//   otherIncome('Other Income', AccountType.income),

//   // Expenses
//   operatingExpense('Operating Expense', AccountType.expense),
//   costOfGoodsSold('Cost of Goods Sold', AccountType.expense);

//   const AccountSubType(this.displayName, this.parentType);
//   final String displayName;
//   final AccountType parentType;
// }

// class ChartOfAccount {
//   final String id;
//   final String accountCode;
//   final String accountName;
//   final AccountType accountType;
//   final AccountSubType accountSubType;
//   final String? parentAccountId;
//   final bool isDefault;
//   final bool isActive;
//   final double currentBalance;
//   final String? description;
//   final DateTime createdAt;
//   final String? createdBy;
//   final List<String> childAccountIds;
//   final int level; // 0 = main, 1 = sub, 2 = sub-sub

//   ChartOfAccount({
//     required this.id,
//     required this.accountCode,
//     required this.accountName,
//     required this.accountType,
//     required this.accountSubType,
//     this.parentAccountId,
//     required this.isDefault,
//     this.isActive = true,
//     this.currentBalance = 0.0,
//     this.description,
//     required this.createdAt,
//     this.createdBy,
//     this.childAccountIds = const [],
//     required this.level,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'account_code': accountCode,
//       'account_name': accountName,
//       'account_type': accountType.name,
//       'account_sub_type': accountSubType.name,
//       'parent_account_id': parentAccountId,
//       'is_default': isDefault,
//       'is_active': isActive,
//       'current_balance': currentBalance,
//       'description': description,
//       'created_at': createdAt,
//       'created_by': createdBy,
//       'child_account_ids': childAccountIds,
//       'level': level,
//     };
//   }

//   factory ChartOfAccount.fromMap(String id, Map<String, dynamic> map) {
//     return ChartOfAccount(
//       id: id,
//       accountCode: map['account_code'] ?? '',
//       accountName: map['account_name'] ?? '',
//       accountType: AccountType.values.firstWhere(
//         (e) => e.name == map['account_type'],
//         orElse: () => AccountType.asset,
//       ),
//       accountSubType: AccountSubType.values.firstWhere(
//         (e) => e.name == map['account_sub_type'],
//         orElse: () => AccountSubType.currentAsset,
//       ),
//       parentAccountId: map['parent_account_id'],
//       isDefault: map['is_default'] ?? false,
//       isActive: map['is_active'] ?? true,
//       currentBalance: (map['current_balance'] ?? 0).toDouble(),
//       description: map['description'],
//       createdAt: (map['created_at'] as Timestamp).toDate(),
//       createdBy: map['created_by'],
//       childAccountIds: List<String>.from(map['child_account_ids'] ?? []),
//       level: map['level'] ?? 0,
//     );
//   }

//   ChartOfAccount copyWith({
//     String? accountCode,
//     String? accountName,
//     AccountType? accountType,
//     AccountSubType? accountSubType,
//     String? parentAccountId,
//     bool? isDefault,
//     bool? isActive,
//     double? currentBalance,
//     String? description,
//     List<String>? childAccountIds,
//     int? level,
//   }) {
//     return ChartOfAccount(
//       id: id,
//       accountCode: accountCode ?? this.accountCode,
//       accountName: accountName ?? this.accountName,
//       accountType: accountType ?? this.accountType,
//       accountSubType: accountSubType ?? this.accountSubType,
//       parentAccountId: parentAccountId ?? this.parentAccountId,
//       isDefault: isDefault ?? this.isDefault,
//       isActive: isActive ?? this.isActive,
//       currentBalance: currentBalance ?? this.currentBalance,
//       description: description ?? this.description,
//       createdAt: createdAt,
//       createdBy: createdBy,
//       childAccountIds: childAccountIds ?? this.childAccountIds,
//       level: level ?? this.level,
//     );
//   }
// }

// // =====================================================
// // DEFAULT CHART OF ACCOUNTS DATA
// // =====================================================

// class DefaultChartOfAccounts {
//   static List<ChartOfAccount> getDefaultAccounts() {
//     final now = DateTime.now();

//     return [
//       // ==================== ASSETS ====================
//       // Current Assets
//       ChartOfAccount(
//         id: 'default_1101',
//         accountCode: '1101',
//         accountName: 'Cash and Bank',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1201',
//         accountCode: '1201',
//         accountName: 'Accounts Receivable',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1301',
//         accountCode: '1301',
//         accountName: 'Inventory - Raw Materials',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1302',
//         accountCode: '1302',
//         accountName: 'Inventory - Finished Goods',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1401',
//         accountCode: '1401',
//         accountName: 'Prepaid Expenses',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // Fixed Assets
//       ChartOfAccount(
//         id: 'default_1501',
//         accountCode: '1501',
//         accountName: 'Property, Plant & Equipment',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.fixedAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1601',
//         accountCode: '1601',
//         accountName: 'Accumulated Depreciation',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.fixedAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== LIABILITIES ====================
//       // Current Liabilities
//       ChartOfAccount(
//         id: 'default_2101',
//         accountCode: '2101',
//         accountName: 'Accounts Payable',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_2201',
//         accountCode: '2201',
//         accountName: 'GST/VAT Payable',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_2301',
//         accountCode: '2301',
//         accountName: 'Accrued Expenses',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_2401',
//         accountCode: '2401',
//         accountName: 'Short Term Loans',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // Long Term Liabilities
//       ChartOfAccount(
//         id: 'default_2501',
//         accountCode: '2501',
//         accountName: 'Long Term Debt',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.longTermLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== EQUITY ====================
//       ChartOfAccount(
//         id: 'default_3101',
//         accountCode: '3101',
//         accountName: 'Owner\'s Capital',
//         accountType: AccountType.equity,
//         accountSubType: AccountSubType.capital,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_3201',
//         accountCode: '3201',
//         accountName: 'Retained Earnings',
//         accountType: AccountType.equity,
//         accountSubType: AccountSubType.retainedEarnings,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== INCOME ====================
//       ChartOfAccount(
//         id: 'default_4101',
//         accountCode: '4101',
//         accountName: 'Sales Revenue',
//         accountType: AccountType.income,
//         accountSubType: AccountSubType.revenue,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_4201',
//         accountCode: '4201',
//         accountName: 'Other Income',
//         accountType: AccountType.income,
//         accountSubType: AccountSubType.otherIncome,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== EXPENSES ====================
//       // Cost of Goods Sold
//       ChartOfAccount(
//         id: 'default_5101',
//         accountCode: '5101',
//         accountName: 'Cost of Goods Sold',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.costOfGoodsSold,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // Operating Expenses
//       ChartOfAccount(
//         id: 'default_5201',
//         accountCode: '5201',
//         accountName: 'Purchase Expenses',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5301',
//         accountCode: '5301',
//         accountName: 'Salaries & Wages',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5401',
//         accountCode: '5401',
//         accountName: 'Rent Expense',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5501',
//         accountCode: '5501',
//         accountName: 'Utilities Expense',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5601',
//         accountCode: '5601',
//         accountName: 'Depreciation Expense',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//     ];
//   }
// }

// // =====================================================
// // SERVICES
// // =====================================================

// class ChartOfAccountsService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _collection = 'chart_of_accounts';

//   // Initialize default chart of accounts
//   Future<void> initializeDefaultAccounts({required String companyId}) async {
//     final batch = _firestore.batch();
//     final defaultAccounts = DefaultChartOfAccounts.getDefaultAccounts();

//     for (final account in defaultAccounts) {
//       final docRef = _firestore
//           .collection('companies')
//           .doc(companyId)
//           .collection(_collection)
//           .doc(account.id);

//       batch.set(docRef, account.toMap());
//     }

//     await batch.commit();
//   }

//   // Create new custom account
//   Future<String> createAccount({
//     required String companyId,
//     required ChartOfAccount account,
//     required String createdBy,
//   }) async {
//     // Generate next account code
//     final nextCode = await _generateNextAccountCode(
//       companyId: companyId,
//       accountType: account.accountType,
//       accountSubType: account.accountSubType,
//       parentAccountId: account.parentAccountId,
//     );

//     final newAccount = account.copyWith(
//       accountCode: nextCode,
//     );

//     final docRef = _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc();

//     await docRef.set(newAccount.toMap());

//     // Update parent account if exists
//     if (account.parentAccountId != null) {
//       await _addChildToParent(
//         companyId: companyId,
//         parentId: account.parentAccountId!,
//         childId: docRef.id,
//       );
//     }

//     return docRef.id;
//   }

//   // Get all accounts grouped by type
//   Future<Map<AccountType, List<ChartOfAccount>>> getAccountsGroupedByType({
//     required String companyId,
//   }) async {
//     final snapshot = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .where('is_active', isEqualTo: true)
//         .orderBy('account_code')
//         .get();

//     final accounts = snapshot.docs
//         .map((doc) => ChartOfAccount.fromMap(doc.id, doc.data()))
//         .toList();

//     final Map<AccountType, List<ChartOfAccount>> groupedAccounts = {};

//     for (final type in AccountType.values) {
//       groupedAccounts[type] = accounts
//           .where((account) => account.accountType == type)
//           .toList();
//     }

//     return groupedAccounts;
//   }

//   // Generate next account code
//   Future<String> _generateNextAccountCode({
//     required String companyId,
//     required AccountType accountType,
//     required AccountSubType accountSubType,
//     String? parentAccountId,
//   }) async {
//     if (parentAccountId != null) {
//       // For sub-accounts, use parent code + sequence
//       return await _generateSubAccountCode(companyId, parentAccountId);
//     }

//     // For main accounts, use type-based prefix + sequence
//     final prefix = _getAccountTypePrefix(accountType, accountSubType);

//     final snapshot = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .where('account_code', isGreaterThanOrEqualTo: prefix)
//         .where('account_code', isLessThan: '${prefix}Z')
//         .orderBy('account_code', descending: true)
//         .limit(1)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       return '${prefix}01';
//     }

//     final lastCode = snapshot.docs.first.data()['account_code'] as String;
//     final lastNumber = int.parse(lastCode.substring(prefix.length));
//     final nextNumber = lastNumber + 1;

//     return '$prefix${nextNumber.toString().padLeft(2, '0')}';
//   }

//   String _getAccountTypePrefix(AccountType type, AccountSubType subType) {
//     switch (type) {
//       case AccountType.asset:
//         return subType == AccountSubType.currentAsset ? '1' : '15';
//       case AccountType.liability:
//         return subType == AccountSubType.currentLiability ? '2' : '25';
//       case AccountType.equity:
//         return '3';
//       case AccountType.income:
//         return '4';
//       case AccountType.expense:
//         return '5';
//     }
//   }

//   Future<String> _generateSubAccountCode(String companyId, String parentId) async {
//     final parentDoc = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(parentId)
//         .get();

//     final parentCode = parentDoc.data()!['account_code'] as String;

//     final snapshot = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .where('parent_account_id', isEqualTo: parentId)
//         .orderBy('account_code', descending: true)
//         .limit(1)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       return '${parentCode}001';
//     }

//     final lastCode = snapshot.docs.first.data()['account_code'] as String;
//     final lastSequence = int.parse(lastCode.substring(parentCode.length));
//     final nextSequence = lastSequence + 1;

//     return '$parentCode${nextSequence.toString().padLeft(3, '0')}';
//   }

//   Future<void> _addChildToParent({
//     required String companyId,
//     required String parentId,
//     required String childId,
//   }) async {
//     await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(parentId)
//         .update({
//       'child_account_ids': FieldValue.arrayUnion([childId]),
//     });
//   }

//   // Update account (only for non-default accounts)
//   Future<void> updateAccount({
//     required String companyId,
//     required String accountId,
//     required Map<String, dynamic> updates,
//   }) async {
//     // Check if account is default
//     final doc = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .get();

//     if (doc.data()!['is_default'] == true) {
//       throw Exception('Cannot modify default accounts');
//     }

//     await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .update(updates);
//   }

//   // Soft delete account (only for non-default accounts)
//   Future<void> deactivateAccount({
//     required String companyId,
//     required String accountId,
//   }) async {
//     // Check if account is default
//     final doc = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .get();

//     if (doc.data()!['is_default'] == true) {
//       throw Exception('Cannot deactivate default accounts');
//     }

//     // Check if account has balance
//     final balance = (doc.data()!['current_balance'] ?? 0.0) as double;
//     if (balance != 0) {
//       throw Exception('Cannot deactivate account with non-zero balance');
//     }

//     await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .update({'is_active': false});
//   }
// }

// // =====================================================
// // BLOC STATE MANAGEMENT
// // =====================================================

// // Events
// abstract class ChartOfAccountsEvent {}

// class LoadAccountsEvent extends ChartOfAccountsEvent {
//   final String companyId;
//   LoadAccountsEvent(this.companyId);
// }

// class CreateAccountEvent extends ChartOfAccountsEvent {
//   final String companyId;
//   final ChartOfAccount account;
//   final String createdBy;

//   CreateAccountEvent({
//     required this.companyId,
//     required this.account,
//     required this.createdBy,
//   });
// }

// class UpdateAccountEvent extends ChartOfAccountsEvent {
//   final String companyId;
//   final String accountId;
//   final Map<String, dynamic> updates;

//   UpdateAccountEvent({
//     required this.companyId,
//     required this.accountId,
//     required this.updates,
//   });
// }

// class DeactivateAccountEvent extends ChartOfAccountsEvent {
//   final String companyId;
//   final String accountId;

//   DeactivateAccountEvent({
//     required this.companyId,
//     required this.accountId,
//   });
// }

// // States
// abstract class ChartOfAccountsState {}

// class ChartOfAccountsInitial extends ChartOfAccountsState {}

// class ChartOfAccountsLoading extends ChartOfAccountsState {}

// class ChartOfAccountsLoaded extends ChartOfAccountsState {
//   final Map<AccountType, List<ChartOfAccount>> groupedAccounts;

//   ChartOfAccountsLoaded(this.groupedAccounts);
// }

// class ChartOfAccountsError extends ChartOfAccountsState {
//   final String message;
//   ChartOfAccountsError(this.message);
// }

// class AccountCreated extends ChartOfAccountsState {
//   final String accountId;
//   AccountCreated(this.accountId);
// }

// class AccountUpdated extends ChartOfAccountsState {}

// class AccountDeactivated extends ChartOfAccountsState {}

// // BLoC
// class ChartOfAccountsBloc extends Bloc<ChartOfAccountsEvent, ChartOfAccountsState> {
//   final ChartOfAccountsService _service;

//   ChartOfAccountsBloc(this._service) : super(ChartOfAccountsInitial()) {
//     on<LoadAccountsEvent>(_onLoadAccounts);
//     on<CreateAccountEvent>(_onCreateAccount);
//     on<UpdateAccountEvent>(_onUpdateAccount);
//     on<DeactivateAccountEvent>(_onDeactivateAccount);
//   }

//   Future<void> _onLoadAccounts(
//     LoadAccountsEvent event,
//     Emitter<ChartOfAccountsState> emit,
//   ) async {
//     emit(ChartOfAccountsLoading());

//     try {
//       final accounts = await _service.getAccountsGroupedByType(
//         companyId: event.companyId,
//       );
//       emit(ChartOfAccountsLoaded(accounts));
//     } catch (e) {
//       emit(ChartOfAccountsError(e.toString()));
//     }
//   }

//   Future<void> _onCreateAccount(
//     CreateAccountEvent event,
//     Emitter<ChartOfAccountsState> emit,
//   ) async {
//     try {
//       final accountId = await _service.createAccount(
//         companyId: event.companyId,
//         account: event.account,
//         createdBy: event.createdBy,
//       );

//       emit(AccountCreated(accountId));

//       // Reload accounts
//       add(LoadAccountsEvent(event.companyId));
//     } catch (e) {
//       emit(ChartOfAccountsError(e.toString()));
//     }
//   }

//   Future<void> _onUpdateAccount(
//     UpdateAccountEvent event,
//     Emitter<ChartOfAccountsState> emit,
//   ) async {
//     try {
//       await _service.updateAccount(
//         companyId: event.companyId,
//         accountId: event.accountId,
//         updates: event.updates,
//       );

//       emit(AccountUpdated());

//       // Reload accounts
//       add(LoadAccountsEvent(event.companyId));
//     } catch (e) {
//       emit(ChartOfAccountsError(e.toString()));
//     }
//   }

//   Future<void> _onDeactivateAccount(
//     DeactivateAccountEvent event,
//     Emitter<ChartOfAccountsState> emit,
//   ) async {
//     try {
//       await _service.deactivateAccount(
//         companyId: event.companyId,
//         accountId: event.accountId,
//       );

//       emit(AccountDeactivated());

//       // Reload accounts
//       add(LoadAccountsEvent(event.companyId));
//     } catch (e) {
//       emit(ChartOfAccountsError(e.toString()));
//     }
//   }
// }

// // =====================================================
// // UI SCREENS
// // =====================================================

// class ChartOfAccountsScreen extends StatefulWidget {
//   final String companyId;

//   const ChartOfAccountsScreen({
//     super.key,
//     required this.companyId,
//   });

//   @override
//   State<ChartOfAccountsScreen> createState() => _ChartOfAccountsScreenState();
// }

// class _ChartOfAccountsScreenState extends State<ChartOfAccountsScreen> {
//   late ChartOfAccountsBloc _bloc;

//   @override
//   void initState() {
//     super.initState();
//     _bloc = ChartOfAccountsBloc(ChartOfAccountsService());
//     _bloc.add(LoadAccountsEvent(widget.companyId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _bloc,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           title: const Text(
//             'Chart of Accounts',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 20,
//             ),
//           ),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.grey[800],
//           elevation: 0,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(1),
//             child: Container(
//               height: 1,
//               color: Colors.grey[200],
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: () {
//                 _bloc.add(LoadAccountsEvent(widget.companyId));
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () => _showCreateAccountDialog(),
//             ),
//             const SizedBox(width: 8),
//           ],
//         ),
//         body: BlocConsumer<ChartOfAccountsBloc, ChartOfAccountsState>(
//           listener: (context, state) {
//             if (state is ChartOfAccountsError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             } else if (state is AccountCreated) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Account created successfully'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is ChartOfAccountsLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (state is ChartOfAccountsLoaded) {
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildSummaryCards(state.groupedAccounts),
//                     const SizedBox(height: 24),
//                     ...AccountType.values
//                         .map((type) => _buildAccountTypeSection(
//                               type,
//                               state.groupedAccounts[type] ?? [],
//                             ))
//                         .toList(),
//                   ],
//                 ),
//               );
//             }

//             return const Center(
//               child: Text('No data available'),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryCards(Map<AccountType, List<ChartOfAccount>> accounts) {
//     return Row(
//       children: AccountType.values.take(3).map((type) {
//         final typeAccounts = accounts[type] ?? [];
//         final totalBalance = typeAccounts
//             .fold<double>(0, (sum, account) => sum + account.currentBalance);

//         return Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(right: 8),
//             padding: const EdgeInsets.all(16),
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
//                 Text(
//                   type.displayName.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '\$${totalBalance.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${typeAccounts.length} accounts',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildAccountTypeSection(
//     AccountType type,
//     List<ChartOfAccount> accounts,
//   ) {
//     if (accounts.isEmpty) return const SizedBox();

//     // Group by sub-type
//     final Map<AccountSubType, List<ChartOfAccount>> groupedBySubType = {};
//     for (final account in accounts) {
//       if (!groupedBySubType.containsKey(account.accountSubType)) {
//         groupedBySubType[account.accountSubType] = [];
//       }
//       groupedBySubType[account.accountSubType]!.add(account);
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: _getTypeColor(type).withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: _getTypeColor(type),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     _getTypeIcon(type),
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         type.displayName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Text(
//                         '${accounts.length} accounts',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () => _showCreateAccountDialog(
//                     defaultType: type,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Sub-type sections
//           ...groupedBySubType.entries.map(
//             (entry) => _buildSubTypeSection(entry.key, entry.value),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubTypeSection(
//     AccountSubType subType,
//     List<ChartOfAccount> accounts,
//   ) {
//     return Column(
//       children: [
//         // Sub-type header
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           color: Colors.grey[50],
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   subType.displayName,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               Text(
//                 '${accounts.length} accounts',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[500],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Account list
//         ...accounts.asMap().entries.map((entry) {
//           final index = entry.key;
//           final account = entry.value;
//           final isLast = index == accounts.length - 1;

//           return _buildAccountRow(account, isLast);
//         }),
//       ],
//     );
//   }

//   Widget _buildAccountRow(ChartOfAccount account, bool isLast) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: isLast ? Colors.transparent : Colors.grey.withOpacity(0.1),
//             width: 1,
//           ),
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         leading: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: account.isDefault
//                 ? Colors.blue.withOpacity(0.1)
//                 : Colors.green.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Text(
//               account.accountCode,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 color: account.isDefault ? Colors.blue : Colors.green,
//               ),
//             ),
//           ),
//         ),
//         title: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 account.accountName,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             if (account.isDefault)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   'DEFAULT',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         subtitle: account.description != null
//             ? Text(
//                 account.description!,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               )
//             : null,
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: account.currentBalance >= 0
//                     ? Colors.green.withOpacity(0.1)
//                     : Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 '\${account.currentBalance.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: account.currentBalance >= 0
//                       ? Colors.green[700]
//                       : Colors.red[700],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             if (!account.isDefault)
//               PopupMenuButton<String>(
//                 icon: const Icon(Icons.more_vert, size: 18),
//                 onSelected: (value) {
//                   switch (value) {
//                     case 'edit':
//                       _showEditAccountDialog(account);
//                       break;
//                     case 'deactivate':
//                       _showDeactivateConfirmation(account);
//                       break;
//                   }
//                 },
//                 itemBuilder: (context) => [
//                   const PopupMenuItem(
//                     value: 'edit',
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit, size: 16),
//                         SizedBox(width: 8),
//                         Text('Edit'),
//                       ],
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'deactivate',
//                     child: Row(
//                       children: [
//                         Icon(Icons.remove_circle_outline, size: 16),
//                         SizedBox(width: 8),
//                         Text('Deactivate'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getTypeColor(AccountType type) {
//     switch (type) {
//       case AccountType.asset:
//         return Colors.blue;
//       case AccountType.liability:
//         return Colors.red;
//       case AccountType.equity:
//         return Colors.purple;
//       case AccountType.income:
//         return Colors.green;
//       case AccountType.expense:
//         return Colors.orange;
//     }
//   }

//   IconData _getTypeIcon(AccountType type) {
//     switch (type) {
//       case AccountType.asset:
//         return Icons.account_balance_wallet;
//       case AccountType.liability:
//         return Icons.credit_card;
//       case AccountType.equity:
//         return Icons.pie_chart;
//       case AccountType.income:
//         return Icons.trending_up;
//       case AccountType.expense:
//         return Icons.trending_down;
//     }
//   }

//   void _showCreateAccountDialog({AccountType? defaultType}) {
//     showDialog(
//       context: context,
//       builder: (context) => CreateAccountDialog(
//         companyId: widget.companyId,
//         defaultType: defaultType,
//         onAccountCreated: () {
//           _bloc.add(LoadAccountsEvent(widget.companyId));
//         },
//       ),
//     );
//   }

//   void _showEditAccountDialog(ChartOfAccount account) {
//     showDialog(
//       context: context,
//       builder: (context) => EditAccountDialog(
//         companyId: widget.companyId,
//         account: account,
//         onAccountUpdated: () {
//           _bloc.add(LoadAccountsEvent(widget.companyId));
//         },
//       ),
//     );
//   }

//   void _showDeactivateConfirmation(ChartOfAccount account) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Deactivate Account'),
//         content: Text('Are you sure you want to deactivate "${account.accountName}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _bloc.add(DeactivateAccountEvent(
//                 companyId: widget.companyId,
//                 accountId: account.id,
//               ));
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Deactivate'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================
// // CREATE ACCOUNT DIALOG
// // =====================================================

// class CreateAccountDialog extends StatefulWidget {
//   final String companyId;
//   final AccountType? defaultType;
//   final VoidCallback onAccountCreated;

//   const CreateAccountDialog({
//     super.key,
//     required this.companyId,
//     this.defaultType,
//     required this.onAccountCreated,
//   });

//   @override
//   State<CreateAccountDialog> createState() => _CreateAccountDialogState();
// }

// class _CreateAccountDialogState extends State<CreateAccountDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   AccountType? _selectedType;
//   AccountSubType? _selectedSubType;

//   @override
//   void initState() {
//     super.initState();
//     _selectedType = widget.defaultType;
//     if (_selectedType != null) {
//       _updateSubTypes();
//     }
//   }

//   void _updateSubTypes() {
//     _selectedSubType = AccountSubType.values
//         .where((subType) => subType.parentType == _selectedType)
//         .first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 500,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Create New Account',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Account Name *',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Account name is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<AccountType>(
//                     value: _selectedType,
//                     decoration: const InputDecoration(
//                       labelText: 'Account Type *',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: AccountType.values.map((type) {
//                       return DropdownMenuItem(
//                         value: type,
//                         child: Text(type.displayName),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedType = value;
//                         if (value != null) {
//                           _updateSubTypes();
//                         }
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Account type is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   if (_selectedType != null)
//                     DropdownButtonFormField<AccountSubType>(
//                       value: _selectedSubType,
//                       decoration: const InputDecoration(
//                         labelText: 'Account Sub-Type *',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: AccountSubType.values
//                           .where((subType) => subType.parentType == _selectedType)
//                           .map((subType) {
//                         return DropdownMenuItem(
//                           value: subType,
//                           child: Text(subType.displayName),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedSubType = value;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null) {
//                           return 'Account sub-type is required';
//                         }
//                         return null;
//                       },
//                     ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 3,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Cancel'),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: _createAccount,
//                   child: const Text('Create Account'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _createAccount() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final account = ChartOfAccount(
//       id: '',
//       accountCode: '', // Will be generated by service
//       accountName: _nameController.text.trim(),
//       accountType: _selectedType!,
//       accountSubType: _selectedSubType!,
//       isDefault: false,
//       description: _descriptionController.text.trim().isEmpty
//           ? null
//           : _descriptionController.text.trim(),
//       createdAt: DateTime.now(),
//       level: 0,
//     );

//     try {
//       final service = ChartOfAccountsService();
//       await service.createAccount(
//         companyId: widget.companyId,
//         account: account,
//         createdBy: 'current_user_id', // Replace with actual user ID
//       );

//       Navigator.of(context).pop();
//       widget.onAccountCreated();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Account created successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error creating account: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

// // =====================================================
// // EDIT ACCOUNT DIALOG
// // =====================================================

// class EditAccountDialog extends StatefulWidget {
//   final String companyId;
//   final ChartOfAccount account;
//   final VoidCallback onAccountUpdated;

//   const EditAccountDialog({
//     super.key,
//     required this.companyId,
//     required this.account,
//     required this.onAccountUpdated,
//   });

//   @override
//   State<EditAccountDialog> createState() => _EditAccountDialogState();
// }

// class _EditAccountDialogState extends State<EditAccountDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _descriptionController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.account.accountName);
//     _descriptionController = TextEditingController(
//       text: widget.account.description ?? '',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 500,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Edit Account - ${widget.account.accountCode}',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Account Name *',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Account name is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 16),
//                   // Display read-only information
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             const Text('Account Type: ', style: TextStyle(fontWeight: FontWeight.w500)),
//                             Text(widget.account.accountType.displayName),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Text('Sub-Type: ', style: TextStyle(fontWeight: FontWeight.w500)),
//                             Text(widget.account.accountSubType.displayName),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Text('Current Balance: ', style: TextStyle(fontWeight: FontWeight.w500)),
//                             Text('\${widget.account.currentBalance.toStringAsFixed(2)}'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Cancel'),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: _updateAccount,
//                   child: const Text('Update Account'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateAccount() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final updates = <String, dynamic>{
//       'account_name': _nameController.text.trim(),
//       'description': _descriptionController.text.trim().isEmpty
//           ? null
//           : _descriptionController.text.trim(),
//     };

//     try {
//       final service = ChartOfAccountsService();
//       await service.updateAccount(
//         companyId: widget.companyId,
//         accountId: widget.account.id,
//         updates: updates,
//       );

//       Navigator.of(context).pop();
//       widget.onAccountUpdated();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Account updated successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating account: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';

// // =====================================================
// // MODELS
// // =====================================================

// enum AccountType {
//   asset('ASSET', 1),
//   liability('LIABILITY', 2),
//   equity('EQUITY', 3),
//   income('INCOME', 4),
//   expense('EXPENSE', 5);

//   const AccountType(this.displayName, this.order);
//   final String displayName;
//   final int order;
// }

// enum AccountSubType {
//   // Assets
//   currentAsset('Current Asset', AccountType.asset),
//   fixedAsset('Fixed Asset', AccountType.asset),

//   // Liabilities
//   currentLiability('Current Liability', AccountType.liability),
//   longTermLiability('Long Term Liability', AccountType.liability),

//   // Equity
//   capital('Capital', AccountType.equity),
//   retainedEarnings('Retained Earnings', AccountType.equity),

//   // Income
//   revenue('Revenue', AccountType.income),
//   otherIncome('Other Income', AccountType.income),

//   // Expenses
//   operatingExpense('Operating Expense', AccountType.expense),
//   costOfGoodsSold('Cost of Goods Sold', AccountType.expense);

//   const AccountSubType(this.displayName, this.parentType);
//   final String displayName;
//   final AccountType parentType;
// }

// class ChartOfAccount {
//   final String id;
//   final String accountCode;
//   final String accountName;
//   final AccountType accountType;
//   final AccountSubType accountSubType;
//   final String? parentAccountId;
//   final bool isDefault;
//   final bool isActive;
//   final double currentBalance;
//   final String? description;
//   final DateTime createdAt;
//   final String? createdBy;
//   final List<String> childAccountIds;
//   final int level; // 0 = main, 1 = sub, 2 = sub-sub

//   ChartOfAccount({
//     required this.id,
//     required this.accountCode,
//     required this.accountName,
//     required this.accountType,
//     required this.accountSubType,
//     this.parentAccountId,
//     required this.isDefault,
//     this.isActive = true,
//     this.currentBalance = 0.0,
//     this.description,
//     required this.createdAt,
//     this.createdBy,
//     this.childAccountIds = const [],
//     required this.level,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'account_code': accountCode,
//       'account_name': accountName,
//       'account_type': accountType.name,
//       'account_sub_type': accountSubType.name,
//       'parent_account_id': parentAccountId,
//       'is_default': isDefault,
//       'is_active': isActive,
//       'current_balance': currentBalance,
//       'description': description,
//       'created_at': createdAt,
//       'created_by': createdBy,
//       'child_account_ids': childAccountIds,
//       'level': level,
//     };
//   }

//   factory ChartOfAccount.fromMap(String id, Map<String, dynamic> map) {
//     return ChartOfAccount(
//       id: id,
//       accountCode: map['account_code'] ?? '',
//       accountName: map['account_name'] ?? '',
//       accountType: AccountType.values.firstWhere(
//         (e) => e.name == map['account_type'],
//         orElse: () => AccountType.asset,
//       ),
//       accountSubType: AccountSubType.values.firstWhere(
//         (e) => e.name == map['account_sub_type'],
//         orElse: () => AccountSubType.currentAsset,
//       ),
//       parentAccountId: map['parent_account_id'],
//       isDefault: map['is_default'] ?? false,
//       isActive: map['is_active'] ?? true,
//       currentBalance: (map['current_balance'] ?? 0).toDouble(),
//       description: map['description'],
//       createdAt: (map['created_at'] as Timestamp).toDate(),
//       createdBy: map['created_by'],
//       childAccountIds: List<String>.from(map['child_account_ids'] ?? []),
//       level: map['level'] ?? 0,
//     );
//   }

//   ChartOfAccount copyWith({
//     String? accountCode,
//     String? accountName,
//     AccountType? accountType,
//     AccountSubType? accountSubType,
//     String? parentAccountId,
//     bool? isDefault,
//     bool? isActive,
//     double? currentBalance,
//     String? description,
//     List<String>? childAccountIds,
//     int? level,
//   }) {
//     return ChartOfAccount(
//       id: id,
//       accountCode: accountCode ?? this.accountCode,
//       accountName: accountName ?? this.accountName,
//       accountType: accountType ?? this.accountType,
//       accountSubType: accountSubType ?? this.accountSubType,
//       parentAccountId: parentAccountId ?? this.parentAccountId,
//       isDefault: isDefault ?? this.isDefault,
//       isActive: isActive ?? this.isActive,
//       currentBalance: currentBalance ?? this.currentBalance,
//       description: description ?? this.description,
//       createdAt: createdAt,
//       createdBy: createdBy,
//       childAccountIds: childAccountIds ?? this.childAccountIds,
//       level: level ?? this.level,
//     );
//   }
// }

// // =====================================================
// // DEFAULT CHART OF ACCOUNTS DATA
// // =====================================================

// class DefaultChartOfAccounts {
//   static List<ChartOfAccount> getDefaultAccounts() {
//     final now = DateTime.now();

//     return [
//       // ==================== ASSETS ====================
//       // Current Assets
//       ChartOfAccount(
//         id: 'default_1101',
//         accountCode: '1101',
//         accountName: 'Cash and Bank',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1201',
//         accountCode: '1201',
//         accountName: 'Accounts Receivable',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1301',
//         accountCode: '1301',
//         accountName: 'Inventory - Raw Materials',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1302',
//         accountCode: '1302',
//         accountName: 'Inventory - Finished Goods',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1401',
//         accountCode: '1401',
//         accountName: 'Prepaid Expenses',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.currentAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // Fixed Assets
//       ChartOfAccount(
//         id: 'default_1501',
//         accountCode: '1501',
//         accountName: 'Property, Plant & Equipment',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.fixedAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_1601',
//         accountCode: '1601',
//         accountName: 'Accumulated Depreciation',
//         accountType: AccountType.asset,
//         accountSubType: AccountSubType.fixedAsset,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== LIABILITIES ====================
//       // Current Liabilities
//       ChartOfAccount(
//         id: 'default_2101',
//         accountCode: '2101',
//         accountName: 'Accounts Payable',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_2201',
//         accountCode: '2201',
//         accountName: 'GST/VAT Payable',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_2301',
//         accountCode: '2301',
//         accountName: 'Accrued Expenses',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_2401',
//         accountCode: '2401',
//         accountName: 'Short Term Loans',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.currentLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // Long Term Liabilities
//       ChartOfAccount(
//         id: 'default_2501',
//         accountCode: '2501',
//         accountName: 'Long Term Debt',
//         accountType: AccountType.liability,
//         accountSubType: AccountSubType.longTermLiability,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== EQUITY ====================
//       ChartOfAccount(
//         id: 'default_3101',
//         accountCode: '3101',
//         accountName: 'Owner\'s Capital',
//         accountType: AccountType.equity,
//         accountSubType: AccountSubType.capital,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_3201',
//         accountCode: '3201',
//         accountName: 'Retained Earnings',
//         accountType: AccountType.equity,
//         accountSubType: AccountSubType.retainedEarnings,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== INCOME ====================
//       ChartOfAccount(
//         id: 'default_4101',
//         accountCode: '4101',
//         accountName: 'Sales Revenue',
//         accountType: AccountType.income,
//         accountSubType: AccountSubType.revenue,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_4201',
//         accountCode: '4201',
//         accountName: 'Other Income',
//         accountType: AccountType.income,
//         accountSubType: AccountSubType.otherIncome,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // ==================== EXPENSES ====================
//       // Cost of Goods Sold
//       ChartOfAccount(
//         id: 'default_5101',
//         accountCode: '5101',
//         accountName: 'Cost of Goods Sold',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.costOfGoodsSold,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),

//       // Operating Expenses
//       ChartOfAccount(
//         id: 'default_5201',
//         accountCode: '5201',
//         accountName: 'Purchase Expenses',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5301',
//         accountCode: '5301',
//         accountName: 'Salaries & Wages',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5401',
//         accountCode: '5401',
//         accountName: 'Rent Expense',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5501',
//         accountCode: '5501',
//         accountName: 'Utilities Expense',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//       ChartOfAccount(
//         id: 'default_5601',
//         accountCode: '5601',
//         accountName: 'Depreciation Expense',
//         accountType: AccountType.expense,
//         accountSubType: AccountSubType.operatingExpense,
//         isDefault: true,
//         createdAt: now,
//         level: 0,
//       ),
//     ];
//   }
// }

// // =====================================================
// // SERVICES
// // =====================================================

// class ChartOfAccountsService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _collection = 'chart_of_accounts';

//   // Initialize default chart of accounts
//   Future<void> initializeDefaultAccounts({required String companyId}) async {
//     final batch = _firestore.batch();
//     final defaultAccounts = DefaultChartOfAccounts.getDefaultAccounts();

//     for (final account in defaultAccounts) {
//       final docRef = _firestore
//           .collection('companies')
//           .doc(companyId)
//           .collection(_collection)
//           .doc(account.id);

//       batch.set(docRef, account.toMap());
//     }

//     await batch.commit();
//   }

//   // Create new custom account
//   Future<String> createAccount({
//     required String companyId,
//     required ChartOfAccount account,
//     required String createdBy,
//   }) async {
//     // Generate next account code
//     final nextCode = await _generateNextAccountCode(
//       companyId: companyId,
//       accountType: account.accountType,
//       accountSubType: account.accountSubType,
//       parentAccountId: account.parentAccountId,
//     );

//     final newAccount = account.copyWith(
//       accountCode: nextCode,
//     );

//     final docRef = _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc();

//     await docRef.set(newAccount.toMap());

//     // Update parent account if exists
//     if (account.parentAccountId != null) {
//       await _addChildToParent(
//         companyId: companyId,
//         parentId: account.parentAccountId!,
//         childId: docRef.id,
//       );
//     }

//     return docRef.id;
//   }

//   // Get all accounts grouped by type
//   Future<Map<AccountType, List<ChartOfAccount>>> getAccountsGroupedByType({
//     required String companyId,
//   }) async {
//     final snapshot = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .where('is_active', isEqualTo: true)
//         .orderBy('account_code')
//         .get();

//     final accounts = snapshot.docs
//         .map((doc) => ChartOfAccount.fromMap(doc.id, doc.data()))
//         .toList();

//     final Map<AccountType, List<ChartOfAccount>> groupedAccounts = {};

//     for (final type in AccountType.values) {
//       groupedAccounts[type] = accounts
//           .where((account) => account.accountType == type)
//           .toList();
//     }

//     return groupedAccounts;
//   }

//   // Generate next account code
//   Future<String> _generateNextAccountCode({
//     required String companyId,
//     required AccountType accountType,
//     required AccountSubType accountSubType,
//     String? parentAccountId,
//   }) async {
//     if (parentAccountId != null) {
//       // For sub-accounts, use parent code + sequence
//       return await _generateSubAccountCode(companyId, parentAccountId);
//     }

//     // For main accounts, use type-based prefix + sequence
//     final prefix = _getAccountTypePrefix(accountType, accountSubType);

//     final snapshot = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .where('account_code', isGreaterThanOrEqualTo: prefix)
//         .where('account_code', isLessThan: '${prefix}Z')
//         .orderBy('account_code', descending: true)
//         .limit(1)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       return '${prefix}01';
//     }

//     final lastCode = snapshot.docs.first.data()['account_code'] as String;
//     final lastNumber = int.parse(lastCode.substring(prefix.length));
//     final nextNumber = lastNumber + 1;

//     return '$prefix${nextNumber.toString().padLeft(2, '0')}';
//   }

//   String _getAccountTypePrefix(AccountType type, AccountSubType subType) {
//     switch (type) {
//       case AccountType.asset:
//         return subType == AccountSubType.currentAsset ? '1' : '15';
//       case AccountType.liability:
//         return subType == AccountSubType.currentLiability ? '2' : '25';
//       case AccountType.equity:
//         return '3';
//       case AccountType.income:
//         return '4';
//       case AccountType.expense:
//         return '5';
//     }
//   }

//   Future<String> _generateSubAccountCode(String companyId, String parentId) async {
//     final parentDoc = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(parentId)
//         .get();

//     final parentCode = parentDoc.data()!['account_code'] as String;

//     final snapshot = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .where('parent_account_id', isEqualTo: parentId)
//         .orderBy('account_code', descending: true)
//         .limit(1)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       return '${parentCode}001';
//     }

//     final lastCode = snapshot.docs.first.data()['account_code'] as String;
//     final lastSequence = int.parse(lastCode.substring(parentCode.length));
//     final nextSequence = lastSequence + 1;

//     return '$parentCode${nextSequence.toString().padLeft(3, '0')}';
//   }

//   Future<void> _addChildToParent({
//     required String companyId,
//     required String parentId,
//     required String childId,
//   }) async {
//     await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(parentId)
//         .update({
//       'child_account_ids': FieldValue.arrayUnion([childId]),
//     });
//   }

//   // Update account (only for non-default accounts)
//   Future<void> updateAccount({
//     required String companyId,
//     required String accountId,
//     required Map<String, dynamic> updates,
//   }) async {
//     // Check if account is default
//     final doc = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .get();

//     if (doc.data()!['is_default'] == true) {
//       throw Exception('Cannot modify default accounts');
//     }

//     await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .update(updates);
//   }

//   // Soft delete account (only for non-default accounts)
//   Future<void> deactivateAccount({
//     required String companyId,
//     required String accountId,
//   }) async {
//     // Check if account is default
//     final doc = await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .get();

//     if (doc.data()!['is_default'] == true) {
//       throw Exception('Cannot deactivate default accounts');
//     }

//     // Check if account has balance
//     final balance = (doc.data()!['current_balance'] ?? 0.0) as double;
//     if (balance != 0) {
//       throw Exception('Cannot deactivate account with non-zero balance');
//     }

//     await _firestore
//         .collection('companies')
//         .doc(companyId)
//         .collection(_collection)
//         .doc(accountId)
//         .update({'is_active': false});
//   }
// }

// // =====================================================
// // PROVIDER STATE MANAGEMENT
// // =====================================================

// class ChartOfAccountsProvider extends ChangeNotifier {
//   final ChartOfAccountsService _service = ChartOfAccountsService();

//   Map<AccountType, List<ChartOfAccount>> _groupedAccounts = {};
//   bool _isLoading = false;
//   String? _error;
//   String? _companyId;

//   Map<AccountType, List<ChartOfAccount>> get groupedAccounts => _groupedAccounts;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   void setCompanyId(String companyId) {
//     if (_companyId != companyId) {
//       _companyId = companyId;
//       loadAccounts();
//     }
//   }

//   Future<void> loadAccounts() async {
//     if (_companyId == null) return;

//     _setLoading(true);
//     _setError(null);

//     try {
//       final accounts = await _service.getAccountsGroupedByType(
//         companyId: _companyId!,
//       );
//       _groupedAccounts = accounts;
//       notifyListeners();
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<String> createAccount({
//     required ChartOfAccount account,
//     required String createdBy,
//   }) async {
//     if (_companyId == null) throw Exception('Company ID not set');

//     try {
//       final accountId = await _service.createAccount(
//         companyId: _companyId!,
//         account: account,
//         createdBy: createdBy,
//       );

//       // Reload accounts to reflect changes
//       await loadAccounts();

//       return accountId;
//     } catch (e) {
//       _setError(e.toString());
//       rethrow;
//     }
//   }

//   Future<void> updateAccount({
//     required String accountId,
//     required Map<String, dynamic> updates,
//   }) async {
//     if (_companyId == null) throw Exception('Company ID not set');

//     try {
//       await _service.updateAccount(
//         companyId: _companyId!,
//         accountId: accountId,
//         updates: updates,
//       );

//       // Reload accounts to reflect changes
//       await loadAccounts();
//     } catch (e) {
//       _setError(e.toString());
//       rethrow;
//     }
//   }

//   Future<void> deactivateAccount(String accountId) async {
//     if (_companyId == null) throw Exception('Company ID not set');

//     try {
//       await _service.deactivateAccount(
//         companyId: _companyId!,
//         accountId: accountId,
//       );

//       // Reload accounts to reflect changes
//       await loadAccounts();
//     } catch (e) {
//       _setError(e.toString());
//       rethrow;
//     }
//   }

//   Future<void> initializeDefaultAccounts() async {
//     if (_companyId == null) throw Exception('Company ID not set');

//     try {
//       await _service.initializeDefaultAccounts(companyId: _companyId!);
//       await loadAccounts();
//     } catch (e) {
//       _setError(e.toString());
//       rethrow;
//     }
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String? error) {
//     _error = error;
//     notifyListeners();
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }

// // =====================================================
// // UI SCREENS
// // =====================================================

// class ChartOfAccountsScreen extends StatefulWidget {
//   final String companyId;

//   const ChartOfAccountsScreen({
//     super.key,
//     required this.companyId,
//   });

//   @override
//   State<ChartOfAccountsScreen> createState() => _ChartOfAccountsScreenState();
// }

// class _ChartOfAccountsScreenState extends State<ChartOfAccountsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Initialize provider with company ID
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<ChartOfAccountsProvider>(context, listen: false);
//       provider.setCompanyId(widget.companyId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'Chart of Accounts',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.grey[800],
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             height: 1,
//             color: Colors.grey[200],
//           ),
//         ),
//         actions: [
//           Consumer<ChartOfAccountsProvider>(
//             builder: (context, provider, child) {
//               return IconButton(
//                 icon: const Icon(Icons.refresh),
//                 onPressed: provider.isLoading ? null : () {
//                   provider.loadAccounts();
//                 },
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showCreateAccountDialog(),
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: Consumer<ChartOfAccountsProvider>(
//         builder: (context, provider, child) {
//           // Header
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: _getTypeColor(type).withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: _getTypeColor(type),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     _getTypeIcon(type),
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         type.displayName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Text(
//                         '${accounts.length} accounts',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () => _showCreateAccountDialog(
//                     defaultType: type,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Sub-type sections
//           ...groupedBySubType.entries.map(
//             (entry) => _buildSubTypeSection(entry.key, entry.value),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubTypeSection(
//     AccountSubType subType,
//     List<ChartOfAccount> accounts,
//   ) {
//     return Column(
//       children: [
//         // Sub-type header
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           color: Colors.grey[50],
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   subType.displayName,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               Text(
//                 '${accounts.length} accounts',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[500],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Account list
//         ...accounts.asMap().entries.map((entry) {
//           final index = entry.key;
//           final account = entry.value;
//           final isLast = index == accounts.length - 1;

//           return _buildAccountRow(account, isLast);
//         }),
//       ],
//     );
//   }

//   Widget _buildAccountRow(ChartOfAccount account, bool isLast) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: isLast ? Colors.transparent : Colors.grey.withOpacity(0.1),
//             width: 1,
//           ),
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         leading: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: account.isDefault
//                 ? Colors.blue.withOpacity(0.1)
//                 : Colors.green.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Text(
//               account.accountCode,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 color: account.isDefault ? Colors.blue : Colors.green,
//               ),
//             ),
//           ),
//         ),
//         title: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 account.accountName,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             if (account.isDefault)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   'DEFAULT',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         subtitle: account.description != null
//             ? Text(
//                 account.description!,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               )
//             : null,
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: account.currentBalance >= 0
//                     ? Colors.green.withOpacity(0.1)
//                     : Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 '\${account.currentBalance.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: account.currentBalance >= 0
//                       ? Colors.green[700]
//                       : Colors.red[700],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             if (!account.isDefault)
//               PopupMenuButton<String>(
//                 icon: const Icon(Icons.more_vert, size: 18),
//                 onSelected: (value) {
//                   switch (value) {
//                     case 'edit':
//                       _showEditAccountDialog(account);
//                       break;
//                     case 'deactivate':
//                       _showDeactivateConfirmation(account);
//                       break;
//                   }
//                 },
//                 itemBuilder: (context) => [
//                   const PopupMenuItem(
//                     value: 'edit',
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit, size: 16),
//                         SizedBox(width: 8),
//                         Text('Edit'),
//                       ],
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'deactivate',
//                     child: Row(
//                       children: [
//                         Icon(Icons.remove_circle_outline, size: 16),
//                         SizedBox(width: 8),
//                         Text('Deactivate'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getTypeColor(AccountType type) {
//     switch (type) {
//       case AccountType.asset:
//         return Colors.blue;
//       case AccountType.liability:
//         return Colors.red;
//       case AccountType.equity:
//         return Colors.purple;
//       case AccountType.income:
//         return Colors.green;
//       case AccountType.expense:
//         return Colors.orange;
//     }
//   }

//   IconData _getTypeIcon(AccountType type) {
//     switch (type) {
//       case AccountType.asset:
//         return Icons.account_balance_wallet;
//       case AccountType.liability:
//         return Icons.credit_card;
//       case AccountType.equity:
//         return Icons.pie_chart;
//       case AccountType.income:
//         return Icons.trending_up;
//       case AccountType.expense:
//         return Icons.trending_down;
//     }
//   }

//   void _showCreateAccountDialog({AccountType? defaultType}) {
//     showDialog(
//       context: context,
//       builder: (context) => CreateAccountDialog(
//         companyId: widget.companyId,
//         defaultType: defaultType,
//         onAccountCreated: () {
//           final provider = Provider.of<ChartOfAccountsProvider>(context, listen: false);
//           provider.loadAccounts();
//         },
//       ),
//     );
//   }

//   void _showEditAccountDialog(ChartOfAccount account) {
//     showDialog(
//       context: context,
//       builder: (context) => EditAccountDialog(
//         companyId: widget.companyId,
//         account: account,
//         onAccountUpdated: () {
//           final provider = Provider.of<ChartOfAccountsProvider>(context, listen: false);
//           provider.loadAccounts();
//         },
//       ),
//     );
//   }

//   void _showDeactivateConfirmation(ChartOfAccount account) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Deactivate Account'),
//         content: Text('Are you sure you want to deactivate "${account.accountName}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               final provider = Provider.of<ChartOfAccountsProvider>(context, listen: false);
//               provider.deactivateAccount(account.id).catchError((error) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Error deactivating account: $error'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               });
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Deactivate'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================
// // CREATE ACCOUNT DIALOG
// // =====================================================

// class CreateAccountDialog extends StatefulWidget {
//   final String companyId;
//   final AccountType? defaultType;
//   final VoidCallback onAccountCreated;

//   const CreateAccountDialog({
//     super.key,
//     required this.companyId,
//     this.defaultType,
//     required this.onAccountCreated,
//   });

//   @override
//   State<CreateAccountDialog> createState() => _CreateAccountDialogState();
// }

// class _CreateAccountDialogState extends State<CreateAccountDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   AccountType? _selectedType;
//   AccountSubType? _selectedSubType;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _selectedType = widget.defaultType;
//     if (_selectedType != null) {
//       _updateSubTypes();
//     }
//   }

//   void _updateSubTypes() {
//     _selectedSubType = AccountSubType.values
//         .where((subType) => subType.parentType == _selectedType)
//         .first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 500,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Create New Account',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Account Name *',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Account name is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<AccountType>(
//                     value: _selectedType,
//                     decoration: const InputDecoration(
//                       labelText: 'Account Type *',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: AccountType.values.map((type) {
//                       return DropdownMenuItem(
//                         value: type,
//                         child: Text(type.displayName),
//                       );
//                     }).toList(),
//                     onChanged: _isLoading ? null : (value) {
//                       setState(() {
//                         _selectedType = value;
//                         if (value != null) {
//                           _updateSubTypes();
//                         }
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Account type is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   if (_selectedType != null)
//                     DropdownButtonFormField<AccountSubType>(
//                       value: _selectedSubType,
//                       decoration: const InputDecoration(
//                         labelText: 'Account Sub-Type *',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: AccountSubType.values
//                           .where((subType) => subType.parentType == _selectedType)
//                           .map((subType) {
//                         return DropdownMenuItem(
//                           value: subType,
//                           child: Text(subType.displayName),
//                         );
//                       }).toList(),
//                       onChanged: _isLoading ? null : (value) {
//                         setState(() {
//                           _selectedSubType = value;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null) {
//                           return 'Account sub-type is required';
//                         }
//                         return null;
//                       },
//                     ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 3,
//                     enabled: !_isLoading,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
//                   child: const Text('Cancel'),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _createAccount,
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 16,
//                           width: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Text('Create Account'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _createAccount() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final account = ChartOfAccount(
//       id: '',
//       accountCode: '', // Will be generated by service
//       accountName: _nameController.text.trim(),
//       accountType: _selectedType!,
//       accountSubType: _selectedSubType!,
//       isDefault: false,
//       description: _descriptionController.text.trim().isEmpty
//           ? null
//           : _descriptionController.text.trim(),
//       createdAt: DateTime.now(),
//       level: 0,
//     );

//     try {
//       final provider = Provider.of<ChartOfAccountsProvider>(context, listen: false);
//       await provider.createAccount(
//         account: account,
//         createdBy: 'current_user_id', // Replace with actual user ID
//       );

//       Navigator.of(context).pop();
//       widget.onAccountCreated();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Account created successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error creating account: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }

// // =====================================================
// // EDIT ACCOUNT DIALOG
// // =====================================================

// class EditAccountDialog extends StatefulWidget {
//   final String companyId;
//   final ChartOfAccount account;
//   final VoidCallback onAccountUpdated;

//   const EditAccountDialog({
//     super.key,
//     required this.companyId,
//     required this.account,
//     required this.onAccountUpdated,
//   });

//   @override
//   State<EditAccountDialog> createState() => _EditAccountDialogState();
// }

// class _EditAccountDialogState extends State<EditAccountDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _descriptionController;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.account.accountName);
//     _descriptionController = TextEditingController(
//       text: widget.account.description ?? '',
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 500,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Edit Account - ${widget.account.accountCode}',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Account Name *',
//                       border: OutlineInputBorder(),
//                     ),
//                     enabled: !_isLoading,
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Account name is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 3,
//                     enabled: !_isLoading,
//                   ),
//                   const SizedBox(height: 16),
//                   // Display read-only information
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             const Text('Account Type: ', style: TextStyle(fontWeight: FontWeight.w500)),
//                             Text(widget.account.accountType.displayName),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Text('Sub-Type: ', style: TextStyle(fontWeight: FontWeight.w500)),
//                             Text(widget.account.accountSubType.displayName),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Text('Current Balance: ', style: TextStyle(fontWeight: FontWeight.w500)),
//                             Text('\${widget.account.currentBalance.toStringAsFixed(2)}'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
//                   child: const Text('Cancel'),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _updateAccount,
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 16,
//                           width: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Text('Update Account'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateAccount() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final updates = <String, dynamic>{
//       'account_name': _nameController.text.trim(),
//       'description': _descriptionController.text.trim().isEmpty
//           ? null
//           : _descriptionController.text.trim(),
//     };

//     try {
//       final provider = Provider.of<ChartOfAccountsProvider>(context, listen: false);
//       await provider.updateAccount(
//         accountId: widget.account.id,
//         updates: updates,
//       );

//       Navigator.of(context).pop();
//       widget.onAccountUpdated();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Account updated successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating account: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }

// //Handle error state
//           if (provider.error != null) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(provider.error!),
//                   backgroundColor: Colors.red,
//                   action: SnackBarAction(
//                     label: 'Dismiss',
//                     onPressed: () => provider.clearError(),
//                   ),
//                 ),
//               );
//               provider.clearError();
//             });
//           }

//           // Handle loading state
//           if (provider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           // Handle loaded state
//           if (provider.groupedAccounts.isNotEmpty) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSummaryCards(provider.groupedAccounts),
//                   const SizedBox(height: 24),
//                   ...AccountType.values
//                       .map((type) => _buildAccountTypeSection(
//                             type,
//                             provider.groupedAccounts[type] ?? [],
//                           ))
//                       .toList(),
//                 ],
//               ),
//             );
//           }

//           // Handle empty state
//           return const Center(
//             child: Text('No data available'),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSummaryCards(Map<AccountType, List<ChartOfAccount>> accounts) {
//     return Row(
//       children: AccountType.values.take(3).map((type) {
//         final typeAccounts = accounts[type] ?? [];
//         final totalBalance = typeAccounts
//             .fold<double>(0, (sum, account) => sum + account.currentBalance);

//         return Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(right: 8),
//             padding: const EdgeInsets.all(16),
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
//                 Text(
//                   type.displayName.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '\$${totalBalance.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${typeAccounts.length} accounts',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildAccountTypeSection(
//     AccountType type,
//     List<ChartOfAccount> accounts,
//   ) {
//     if (accounts.isEmpty) return const SizedBox();

//     // Group by sub-type
//     final Map<AccountSubType, List<ChartOfAccount>> groupedBySubType = {};
//     for (final account in accounts) {
//       if (!groupedBySubType.containsKey(account.accountSubType)) {
//         groupedBySubType[account.accountSubType] = [];
//       }
//       groupedBySubType[account.accountSubType]!.add(account);
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           //

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/addsub_account_dialogue.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

// // =====================================================
// // MODELS
// // =====================================================

// enum AccountType {
//   asset('ASSET', 1),
//   liability('LIABILITY', 2),
//   equity('EQUITY', 3),
//   income('INCOME', 4),
//   expense('EXPENSE', 5);

//   const AccountType(this.displayName, this.order);
//   final String displayName;
//   final int order;
// }

// enum AccountSubType {
//   // Assets
//   currentAsset('Current Asset', AccountType.asset),
//   fixedAsset('Fixed Asset', AccountType.asset),

//   // Liabilities
//   currentLiability('Current Liability', AccountType.liability),
//   longTermLiability('Long Term Liability', AccountType.liability),

//   // Equity
//   capital('Capital', AccountType.equity),
//   retainedEarnings('Retained Earnings', AccountType.equity),

//   // Income
//   revenue('Revenue', AccountType.income),
//   otherIncome('Other Income', AccountType.income),

//   // Expenses
//   operatingExpense('Operating Expense', AccountType.expense),
//   costOfGoodsSold('Cost of Goods Sold', AccountType.expense);

//   const AccountSubType(this.displayName, this.parentType);
//   final String displayName;
//   final AccountType parentType;
// }

// class ChartOfAccount {
//   final String id;
//   final String accountCode;
//   final String accountName;
//   final AccountType accountType;
//   final AccountSubType accountSubType;
//   final String? parentAccountId;
//   final bool isDefault;
//   final bool isActive;
//   final double currentBalance;
//   final String? description;
//   final DateTime createdAt;
//   final String? createdBy;
//   final List<String> childAccountIds;
//   final int level; // 0 = main, 1 = sub, 2 = sub-sub

//   ChartOfAccount({
//     required this.id,
//     required this.accountCode,
//     required this.accountName,
//     required this.accountType,
//     required this.accountSubType,
//     this.parentAccountId,
//     required this.isDefault,
//     this.isActive = true,
//     this.currentBalance = 0.0,
//     this.description,
//     required this.createdAt,
//     this.createdBy,
//     this.childAccountIds = const [],
//     required this.level,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'account_code': accountCode,
//       'account_name': accountName,
//       'account_type': accountType.name,
//       'account_sub_type': accountSubType.name,
//       'parent_account_id': parentAccountId,
//       'is_default': isDefault,
//       'is_active': isActive,
//       'current_balance': currentBalance,
//       'description': description,
//       'created_at': createdAt,
//       'created_by': createdBy,
//       'child_account_ids': childAccountIds,
//       'level': level,
//     };
//   }

//   factory ChartOfAccount.fromMap(String id, Map<String, dynamic> map) {
//     return ChartOfAccount(
//       id: id,
//       accountCode: map['account_code'] ?? '',
//       accountName: map['account_name'] ?? '',
//       accountType: AccountType.values.firstWhere(
//         (e) => e.name == map['account_type'],
//         orElse: () => AccountType.asset,
//       ),
//       accountSubType: AccountSubType.values.firstWhere(
//         (e) => e.name == map['account_sub_type'],
//         orElse: () => AccountSubType.currentAsset,
//       ),
//       parentAccountId: map['parent_account_id'],
//       isDefault: map['is_default'] ?? false,
//       isActive: map['is_active'] ?? true,
//       currentBalance: (map['current_balance'] ?? 0).toDouble(),
//       description: map['description'],
//       createdAt: (map['created_at'] as Timestamp).toDate(),
//       createdBy: map['created_by'],
//       childAccountIds: List<String>.from(map['child_account_ids'] ?? []),
//       level: map['level'] ?? 0,
//     );
//   }

//   ChartOfAccount copyWith({
//     String? accountCode,
//     String? accountName,
//     AccountType? accountType,
//     AccountSubType? accountSubType,
//     String? parentAccountId,
//     bool? isDefault,
//     bool? isActive,
//     double? currentBalance,
//     String? description,
//     List<String>? childAccountIds,
//     int? level,
//   }) {
//     return ChartOfAccount(
//       id: id,
//       accountCode: accountCode ?? this.accountCode,
//       accountName: accountName ?? this.accountName,
//       accountType: accountType ?? this.accountType,
//       accountSubType: accountSubType ?? this.accountSubType,
//       parentAccountId: parentAccountId ?? this.parentAccountId,
//       isDefault: isDefault ?? this.isDefault,
//       isActive: isActive ?? this.isActive,
//       currentBalance: currentBalance ?? this.currentBalance,
//       description: description ?? this.description,
//       createdAt: createdAt,
//       createdBy: createdBy,
//       childAccountIds: childAccountIds ?? this.childAccountIds,
//       level: level ?? this.level,
//     );
//   }
// }

// // =====================================================
// // DEFAULT CHART OF ACCOUNTS DATA
// // =====================================================

// // default_accounts_config.dart
// class DefaultAccountsConfig {
//   static const Map<String, List<Map<String, dynamic>>> defaultAccounts = {
//     'asset': [
//       {
//         'code': '1000',
//         'name': 'Current Assets',
//         'sub_type': 'currentAssets',
//         'level': 0,
//       },
//       {
//         'code': '1100',
//         'name': 'Cash and Bank',
//         'sub_type': 'cashBank',
//         'level': 1,
//         'parent': '1000',
//       },
//       {
//         'code': '1200',
//         'name': 'Accounts Receivable',
//         'sub_type': 'accountsReceivable',
//         'level': 1,
//         'parent': '1000',
//       },
//     ],
//     'liability': [
//       {
//         'code': '2000',
//         'name': 'Current Liabilities',
//         'sub_type': 'currentLiabilities',
//         'level': 0,
//       },
//       {
//         'code': '2100',
//         'name': 'Accounts Payable',
//         'sub_type': 'accountsPayable',
//         'level': 1,
//         'parent': '2000',
//       },
//     ],
//     'equity': [
//       {'code': '3000', 'name': 'Equity', 'sub_type': 'equity', 'level': 0},
//     ],
//     'revenue': [
//       {'code': '4000', 'name': 'Revenue', 'sub_type': 'revenue', 'level': 0},
//       {
//         'code': '4100',
//         'name': 'Sales Revenue',
//         'sub_type': 'saleRevenue',
//         'level': 1,
//         'parent': "4000",
//       },
//     ],
//     'expense': [
//       {'code': '5000', 'name': 'Expenses', 'sub_type': 'expenses', 'level': 0},
//       {
//         'code': '5100',
//         'name': 'Cost of sale',
//         'sub_type': 'cos',
//         'level': 1,
//         'parent': '5000',
//       },
//       {
//         'code': '5200',
//         'name': 'General & Administrative Expenses',
//         'sub_type': 'ae',
//         'level': 1,
//         'parent': '5000',
//       },
//       {
//         'code': '5300',
//         'name': 'Depriciation',
//         'sub_type': 'dep',
//         'level': 1,
//         'parent': '5000',
//       },
//       {
//         'code': '5400',
//         'name': 'Other Expense',
//         'sub_type': 'ot',
//         'level': 1,
//         'parent': '5000',
//       },
//       {
//         'code': '5500',
//         'name': 'Operating Expense',
//         'sub_type': 'operExp',
//         'level': 1,
//         'parent': '5000',
//       },
//     ],
//   };
// }

// // =====================================================
// // SERVICES
// // =====================================================

// // chart_of_accounts_screen.dart
// class ChartOfAccountsScreen extends StatefulWidget {
//   const ChartOfAccountsScreen({super.key});

//   @override
//   ChartOfAccountsScreenState createState() => ChartOfAccountsScreenState();
// }

// class ChartOfAccountsScreenState extends State<ChartOfAccountsScreen> {
//   final ChartAccountService _accountService = ChartAccountService();
//   final Set<String> _expandedAccounts = {};
//   bool _isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chart of Accounts'),
//         actions: [
//           IconButton(icon: Icon(Icons.add), onPressed: _showCreateBranchDialog),
//         ],
//       ),
//       body: StreamBuilder<Map<String, List<AccountTreeNode>>>(
//         stream: _accountService.watchAllAccounts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             debugPrint('Error: ${snapshot.error}');
//             debugPrint('trace: ${snapshot.stackTrace}');
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error, size: 64, color: Colors.red),
//                   SizedBox(height: 16),
//                   Text(
//                     'Error loading accounts',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '${snapshot.error}',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No accounts found'));
//           }

//           final accountsData = snapshot.data!;

//           print('🎯 UI: Received ${accountsData.length} branches');

//           try {
//             final mainBranchAccounts =
//                 accountsData['NRHLuRZIA2AMZXjW4TDI'] ?? [];
//             final otherBranches = Map.from(accountsData)
//               ..remove('NRHLuRZIA2AMZXjW4TDI');

//             return ListView(
//               children: [
//                 if (mainBranchAccounts.isNotEmpty)
//                   _buildBranchSection(
//                     '🏢 Main Branch (Head Office)',
//                     mainBranchAccounts,
//                     'NRHLuRZIA2AMZXjW4TDI',
//                   ),

//                 for (final entry in otherBranches.entries)
//                   if (entry.value.isNotEmpty)
//                     _buildBranchSection(
//                       '🏬 ${_getBranchName(entry.key)}',
//                       entry.value,
//                       entry.key,
//                     ),
//               ],
//             );
//           } catch (e) {
//             print('❌ UI rendering error: $e');
//             return Center(child: Text('Error rendering accounts: $e'));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddAccountDialog,
//         child: Icon(Icons.add_chart),
//         tooltip: 'Add New Account',
//       ),
//     );
//   }

//   Widget _buildBranchSection(
//     String title,
//     List<AccountTreeNode> accounts,
//     String branchId,
//   ) {
//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(16.0),
//             color: Colors.blue[50],
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue[700],
//               ),
//             ),
//           ),
//           if (accounts.isEmpty)
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'No accounts found',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             )
//           else
//             ...accounts.map((node) => _buildAccountTree(node, 0)),
//         ],
//       ),
//     );
//   }

//   Widget _buildAccountTree(AccountTreeNode node, int level) {
//     final hasChildren = node.children.isNotEmpty;
//     final isExpanded = _expandedAccounts.contains(node.account.id);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: EdgeInsets.only(left: (level * 20.0)),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[300]!),
//             color: level == 0 ? Colors.grey[50] : Colors.white,
//           ),
//           child: ListTile(
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 4.0,
//             ),
//             leading: hasChildren
//                 ? IconButton(
//                     icon: Icon(
//                       isExpanded ? Icons.expand_more : Icons.chevron_right,
//                       color: Colors.blue,
//                     ),
//                     onPressed: () => _toggleAccount(node.account.id!),
//                   )
//                 : SizedBox(width: 40.0),
//             title: Row(
//               children: [
//                 // Level indicator
//                 Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: _getLevelColor(node.account.level),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${node.account.level}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     '${node.account.accountCode} - ${node.account.accountName}',
//                     style: TextStyle(
//                       fontWeight: level == 0
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                     ),
//                   ),
//                 ),
//                 if (node.account.isDefault) ...[
//                   SizedBox(width: 8),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 6.0,
//                       vertical: 2.0,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.green[50],
//                       borderRadius: BorderRadius.circular(4.0),
//                       border: Border.all(color: Colors.green),
//                     ),
//                     child: Text(
//                       'Default',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontSize: 10.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//             subtitle: Text(node.account.description),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'OMR ${node.account.currentBalance.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: node.account.currentBalance >= 0
//                         ? Colors.green
//                         : Colors.red,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 // Add sub-account button
//                 IconButton(
//                   icon: Icon(Icons.add, size: 18, color: Colors.blue),
//                   onPressed: () => _showAddSubAccountDialog(node.account),
//                   tooltip: 'Add Sub-Account',
//                 ),
//               ],
//             ),
//             onTap: hasChildren ? () => _toggleAccount(node.account.id!) : null,
//           ),
//         ),
//         if (isExpanded && hasChildren)
//           ...node.children.map((child) => _buildAccountTree(child, level + 1)),
//       ],
//     );
//   }

//   Color _getLevelColor(int level) {
//     switch (level) {
//       case 0:
//         return Colors.blue;
//       case 1:
//         return Colors.green;
//       case 2:
//         return Colors.orange;
//       case 3:
//         return Colors.purple;
//       default:
//         return Colors.red;
//     }
//   }

//   void _showAddSubAccountDialog(ChartAccount parentAccount) {
//     showDialog(
//       context: context,
//       builder: (context) => AddSubAccountDialog(
//         parentAccount: parentAccount,
//         accountService: _accountService,
//       ),
//     );
//   }

//   void _toggleAccount(String accountId) {
//     setState(() {
//       if (_expandedAccounts.contains(accountId)) {
//         _expandedAccounts.remove(accountId);
//       } else {
//         _expandedAccounts.add(accountId);
//       }
//     });
//   }

//   String _getBranchName(String branchId) {
//     BranchModel? b = context.read<MmResourceProvider>().getBranchByID(branchId);

//     return 'Branch ${b.branchName}';
//   }

//   void _showCreateBranchDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Create New Branch'),
//         content: Text(
//           'This will create a new branch with default chart of accounts.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final newBranchId = 'branch_$_getBranchName';
//               _accountService.createDefaultChartOfAccounts(
//                 branchId: "headOffice", //newBranchId,
//               );
//               Navigator.pop(context);
//             },
//             child: Text('Create Branch'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAddAccountDialog() {
//     // Implementation for adding new account
//     // You can create a form to collect account details
//     showDialog(
//       context: context,
//       builder: (context) => AddAccountDialog(accountService: _accountService),
//     );
//   }
// }

// // Add Account Dialog
// class AddAccountDialog extends StatefulWidget {
//   final ChartAccountService accountService;

//   const AddAccountDialog({required this.accountService});

//   @override
//   _AddAccountDialogState createState() => _AddAccountDialogState();
// }

// class _AddAccountDialogState extends State<AddAccountDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _codeController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String _selectedType = 'asset';
//   String _selectedSubType = 'currentAssets';
//   String? _selectedParentId;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add New Account'),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _codeController,
//                 decoration: InputDecoration(labelText: 'Account Code'),
//                 validator: (value) => value!.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Account Name'),
//                 validator: (value) => value!.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedType,
//                 items: ['asset', 'liability', 'equity', 'revenue', 'expense']
//                     .map((type) {
//                       return DropdownMenuItem(
//                         value: type,
//                         child: Text(type.toUpperCase()),
//                       );
//                     })
//                     .toList(),
//                 onChanged: (value) => setState(() => _selectedType = value!),
//                 decoration: InputDecoration(labelText: 'Account Type'),
//               ),
//               // Add more fields for sub-type, parent account selection, etc.
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(onPressed: _submitForm, child: Text('Add Account')),
//       ],
//     );
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Implementation to save the new account
//         // You'll need to determine if it's a parent or child account
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error creating account: $e')));
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _codeController.dispose();
//     _nameController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/addsub_account_dialogue.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

// =====================================================
// MODELS
// =====================================================

enum AccountType {
  asset('ASSET', 1),
  liability('LIABILITY', 2),
  equity('EQUITY', 3),
  income('INCOME', 4),
  expense('EXPENSE', 5);

  const AccountType(this.displayName, this.order);
  final String displayName;
  final int order;
}

enum AccountSubType {
  // Assets
  currentAsset('Current Asset', AccountType.asset),
  fixedAsset('Fixed Asset', AccountType.asset),

  // Liabilities
  currentLiability('Current Liability', AccountType.liability),
  longTermLiability('Long Term Liability', AccountType.liability),

  // Equity
  capital('Capital', AccountType.equity),
  retainedEarnings('Retained Earnings', AccountType.equity),

  // Income
  revenue('Revenue', AccountType.income),
  otherIncome('Other Income', AccountType.income),

  // Expenses
  operatingExpense('Operating Expense', AccountType.expense),
  costOfGoodsSold('Cost of Goods Sold', AccountType.expense);

  const AccountSubType(this.displayName, this.parentType);
  final String displayName;
  final AccountType parentType;
}

class ChartOfAccount {
  final String id;
  final String accountCode;
  final String accountName;
  final AccountType accountType;
  final AccountSubType accountSubType;
  final String? parentAccountId;
  final bool isDefault;
  final bool isActive;
  final double currentBalance;
  final String? description;
  final DateTime createdAt;
  final String? createdBy;
  final List<String> childAccountIds;
  final int level; // 0 = main, 1 = sub, 2 = sub-sub

  ChartOfAccount({
    required this.id,
    required this.accountCode,
    required this.accountName,
    required this.accountType,
    required this.accountSubType,
    this.parentAccountId,
    required this.isDefault,
    this.isActive = true,
    this.currentBalance = 0.0,
    this.description,
    required this.createdAt,
    this.createdBy,
    this.childAccountIds = const [],
    required this.level,
  });

  Map<String, dynamic> toMap() {
    return {
      'account_code': accountCode,
      'account_name': accountName,
      'account_type': accountType.name,
      'account_sub_type': accountSubType.name,
      'parent_account_id': parentAccountId,
      'is_default': isDefault,
      'is_active': isActive,
      'current_balance': currentBalance,
      'description': description,
      'created_at': createdAt,
      'created_by': createdBy,
      'child_account_ids': childAccountIds,
      'level': level,
    };
  }

  factory ChartOfAccount.fromMap(String id, Map<String, dynamic> map) {
    return ChartOfAccount(
      id: id,
      accountCode: map['account_code'] ?? '',
      accountName: map['account_name'] ?? '',
      accountType: AccountType.values.firstWhere(
        (e) => e.name == map['account_type'],
        orElse: () => AccountType.asset,
      ),
      accountSubType: AccountSubType.values.firstWhere(
        (e) => e.name == map['account_sub_type'],
        orElse: () => AccountSubType.currentAsset,
      ),
      parentAccountId: map['parent_account_id'],
      isDefault: map['is_default'] ?? false,
      isActive: map['is_active'] ?? true,
      currentBalance: (map['current_balance'] ?? 0).toDouble(),
      description: map['description'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
      createdBy: map['created_by'],
      childAccountIds: List<String>.from(map['child_account_ids'] ?? []),
      level: map['level'] ?? 0,
    );
  }

  ChartOfAccount copyWith({
    String? accountCode,
    String? accountName,
    AccountType? accountType,
    AccountSubType? accountSubType,
    String? parentAccountId,
    bool? isDefault,
    bool? isActive,
    double? currentBalance,
    String? description,
    List<String>? childAccountIds,
    int? level,
  }) {
    return ChartOfAccount(
      id: id,
      accountCode: accountCode ?? this.accountCode,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      accountSubType: accountSubType ?? this.accountSubType,
      parentAccountId: parentAccountId ?? this.parentAccountId,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      currentBalance: currentBalance ?? this.currentBalance,
      description: description ?? this.description,
      createdAt: createdAt,
      createdBy: createdBy,
      childAccountIds: childAccountIds ?? this.childAccountIds,
      level: level ?? this.level,
    );
  }
}

// =====================================================
// DEFAULT CHART OF ACCOUNTS DATA
// =====================================================

class DefaultAccountsConfig {
  static const Map<String, List<Map<String, dynamic>>> defaultAccounts = {
    'asset': [
      {
        'code': '1000',
        'name': 'Current Assets',
        'sub_type': 'currentAssets',
        'level': 0,
      },
      {
        'code': '1100',
        'name': 'Cash and Bank',
        'sub_type': 'cashBank',
        'level': 1,
        'parent': '1000',
      },
      {
        'code': '1200',
        'name': 'Accounts Receivable',
        'sub_type': 'accountsReceivable',
        'level': 1,
        'parent': '1000',
      },
    ],
    'liability': [
      {
        'code': '2000',
        'name': 'Current Liabilities',
        'sub_type': 'currentLiabilities',
        'level': 0,
      },
      {
        'code': '2100',
        'name': 'Accounts Payable',
        'sub_type': 'accountsPayable',
        'level': 1,
        'parent': '2000',
      },
    ],
    'equity': [
      {'code': '3000', 'name': 'Equity', 'sub_type': 'equity', 'level': 0},
    ],
    'revenue': [
      {'code': '4000', 'name': 'Revenue', 'sub_type': 'revenue', 'level': 0},
      {
        'code': '4100',
        'name': 'Sales Revenue',
        'sub_type': 'saleRevenue',
        'level': 1,
        'parent': "4000",
      },
    ],
    'expense': [
      {'code': '5000', 'name': 'Expenses', 'sub_type': 'expenses', 'level': 0},
      {
        'code': '5100',
        'name': 'Cost of sale',
        'sub_type': 'cos',
        'level': 1,
        'parent': '5000',
      },
      {
        'code': '5200',
        'name': 'General & Administrative Expenses',
        'sub_type': 'ae',
        'level': 1,
        'parent': '5000',
      },
      {
        'code': '5300',
        'name': 'Depriciation',
        'sub_type': 'dep',
        'level': 1,
        'parent': '5000',
      },
      {
        'code': '5400',
        'name': 'Other Expense',
        'sub_type': 'ot',
        'level': 1,
        'parent': '5000',
      },
      {
        'code': '5500',
        'name': 'Operating Expense',
        'sub_type': 'operExp',
        'level': 1,
        'parent': '5000',
      },
    ],
  };
}

// =====================================================
// CHART OF ACCOUNTS SCREEN WITH REAL-TIME UPDATES
// =====================================================

class ChartOfAccountsScreen extends StatefulWidget {
  const ChartOfAccountsScreen({super.key});

  @override
  ChartOfAccountsScreenState createState() => ChartOfAccountsScreenState();
}

class ChartOfAccountsScreenState extends State<ChartOfAccountsScreen> {
  final ChartAccountService _accountService = ChartAccountService();
  final Set<String> _expandedAccounts = {};
  StreamSubscription<Map<String, List<AccountTreeNode>>>? _streamSubscription;
  Map<String, List<AccountTreeNode>>? _accountsData;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _streamSubscription = _accountService.watchAllAccounts().listen(
      (accountsData) {
        if (mounted) {
          setState(() {
            _accountsData = accountsData;
            _isLoading = false;
            _hasError = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = error.toString();
          });
        }
      },
    );

    // Set a timeout to show data even if stream is slow
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Loading timeout. Please check your connection.';
        });
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    // The stream will automatically push new data when available
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart of Accounts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
          IconButton(icon: Icon(Icons.add), onPressed: _showCreateBranchDialog),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAccountDialog,
        child: Icon(Icons.add_chart),
        tooltip: 'Add New Account',
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_hasError) {
      return _buildErrorWidget();
    }

    if (_accountsData == null || _accountsData!.isEmpty) {
      return _buildEmptyWidget();
    }

    return _buildAccountsList(_accountsData!);
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading Chart of Accounts...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Error loading accounts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No Accounts Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first account to get started',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showAddAccountDialog,
            icon: Icon(Icons.add),
            label: Text('Create Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsList(Map<String, List<AccountTreeNode>> accountsData) {
    final mainBranchAccounts = accountsData['NRHLuRZIA2AMZXjW4TDI'] ?? [];
    final otherBranches = Map.from(accountsData)
      ..remove('NRHLuRZIA2AMZXjW4TDI');

    return ListView(
      children: [
        if (mainBranchAccounts.isNotEmpty)
          _buildBranchSection(
            '🏢 Main Branch (Head Office)',
            mainBranchAccounts,
            'NRHLuRZIA2AMZXjW4TDI',
          ),

        for (final entry in otherBranches.entries)
          if (entry.value.isNotEmpty)
            _buildBranchSection(
              '🏬 ${_getBranchName(entry.key)}',
              entry.value,
              entry.key,
            ),
      ],
    );
  }

  Widget _buildBranchSection(
    String title,
    List<AccountTreeNode> accounts,
    String branchId,
  ) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            color: Colors.blue[50],
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                Text(
                  '${accounts.length} accounts',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (accounts.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No accounts found',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...accounts.map((node) => _buildAccountTree(node, 0)),
        ],
      ),
    );
  }

  Widget _buildAccountTree(AccountTreeNode node, int level) {
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = _expandedAccounts.contains(node.account.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: (level * 20.0)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            color: level == 0 ? Colors.grey[50] : Colors.white,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            leading: hasChildren
                ? IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_more : Icons.chevron_right,
                      color: Colors.blue,
                      size: 20,
                    ),
                    onPressed: () => _toggleAccount(node.account.id!),
                  )
                : SizedBox(width: 40.0),
            title: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getLevelColor(node.account.level),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${node.account.level}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${node.account.accountCode} - ${node.account.accountName}',
                        style: TextStyle(
                          fontWeight: level == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      if (node.account.description != null &&
                          node.account.description!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            node.account.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (node.account.isDefault) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: node.account.currentBalance >= 0
                        ? Colors.green[50]
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: node.account.currentBalance >= 0
                          ? Colors.green
                          : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'OMR ${node.account.currentBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: node.account.currentBalance >= 0
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add, size: 18, color: Colors.blue),
                  onPressed: () => _showAddSubAccountDialog(node.account),
                  tooltip: 'Add Sub-Account',
                ),
              ],
            ),
            onTap: hasChildren ? () => _toggleAccount(node.account.id!) : null,
          ),
        ),
        if (isExpanded && hasChildren)
          ...node.children.map((child) => _buildAccountTree(child, level + 1)),
      ],
    );
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.purple;
      default:
        return Colors.red;
    }
  }

  void _toggleAccount(String accountId) {
    setState(() {
      if (_expandedAccounts.contains(accountId)) {
        _expandedAccounts.remove(accountId);
      } else {
        _expandedAccounts.add(accountId);
      }
    });
  }

  String _getBranchName(String branchId) {
    final provider = context.read<MmResourceProvider>();
    BranchModel? branch = provider.getBranchByID(branchId);
    return branch?.branchName ?? 'Branch $branchId';
  }

  void _showAddSubAccountDialog(ChartAccount parentAccount) {
    showDialog(
      context: context,
      builder: (context) => AddSubAccountDialog(
        parentAccount: parentAccount,
        accountService: _accountService,
        onAccountAdded: _refreshData, // Refresh when account is added
      ),
    );
  }

  void _showCreateBranchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Branch'),
        content: Text(
          'This will create a new branch with default chart of accounts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _accountService.createDefaultChartOfAccounts(
                branchId: "headOffice",
              );
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Default accounts created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Create Branch'),
          ),
        ],
      ),
    );
  }

  void _showAddAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAccountDialog(
        accountService: _accountService,
        onAccountAdded: _refreshData, // Refresh when account is added
      ),
    ).then((_) {
      // Refresh data when dialog closes
      _refreshData();
    });
  }
}

// =====================================================
// ADD ACCOUNT DIALOG WITH REFRESH CALLBACK
// =====================================================

class AddAccountDialog extends StatefulWidget {
  final ChartAccountService accountService;
  final VoidCallback? onAccountAdded;

  const AddAccountDialog({required this.accountService, this.onAccountAdded});

  @override
  _AddAccountDialogState createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'asset';
  String _selectedSubType = 'currentAssets';
  String? _selectedParentId;
  bool _isSubmitting = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // TODO: Implement account creation logic
        await Future.delayed(Duration(milliseconds: 500)); // Simulate API call

        if (mounted) {
          Navigator.pop(context);
          widget.onAccountAdded?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating account: $e'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Account'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Account Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['asset', 'liability', 'equity', 'revenue', 'expense']
                    .map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toUpperCase()),
                      );
                    })
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
                decoration: InputDecoration(
                  labelText: 'Account Type',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          child: _isSubmitting
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Add Account'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
