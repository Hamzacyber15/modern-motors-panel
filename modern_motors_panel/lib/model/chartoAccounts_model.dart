// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:modern_motors_panel/modern_motors/widgets/ChartOfAccountsScreen.dart';

// class ChartoaccountsModel {
//   final String id;
//   final String accountCode;
//   final String accountName;
//   final AccountType accountType;
//   final AccountSubType accountSubType;
//   final String? parentAccountId;
//   final String branchId; // Which branch this account belongs to
//   final String?
//   refId; // Reference to main branch account if this is a branch account
//   final bool isDefault;
//   final bool isActive;
//   final double currentBalance;
//   final String? description;
//   final DateTime createdAt;
//   final String? createdBy;
//   final List<String> childAccountIds;
//   final int level;

//   ChartoaccountsModel({
//     required this.id,
//     required this.accountCode,
//     required this.accountName,
//     required this.accountType,
//     required this.accountSubType,
//     this.parentAccountId,
//     required this.branchId,
//     this.refId,
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
//       'branch_id': branchId,
//       'ref_id': refId,
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

//   factory ChartoaccountsModel.fromMap(String id, Map<String, dynamic> map) {
//     return ChartoaccountsModel(
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
//       branchId: map['branch_id'] ?? '',
//       refId: map['ref_id'],
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

//   ChartoaccountsModel copyWith({
//     String? accountCode,
//     String? accountName,
//     AccountType? accountType,
//     AccountSubType? accountSubType,
//     String? parentAccountId,
//     String? branchId,
//     String? refId,
//     bool? isDefault,
//     bool? isActive,
//     double? currentBalance,
//     String? description,
//     List<String>? childAccountIds,
//     int? level,
//   }) {
//     return ChartoaccountsModel(
//       id: id,
//       accountCode: accountCode ?? this.accountCode,
//       accountName: accountName ?? this.accountName,
//       accountType: accountType ?? this.accountType,
//       accountSubType: accountSubType ?? this.accountSubType,
//       parentAccountId: parentAccountId ?? this.parentAccountId,
//       branchId: branchId ?? this.branchId,
//       refId: refId ?? this.refId,
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

// account_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartAccount {
  String? id;
  String accountCode;
  String accountName;
  String accountSubType;
  String accountType;
  List<String> childAccountIds;
  DateTime createdAt;
  String? createdBy;
  double currentBalance;
  String description;
  bool isActive;
  bool isDefault;
  int level;
  String refId;
  String? parentAccountId;
  String branchId;

  ChartAccount({
    this.id,
    required this.accountCode,
    required this.accountName,
    required this.accountSubType,
    required this.accountType,
    required this.childAccountIds,
    required this.createdAt,
    this.createdBy,
    required this.currentBalance,
    required this.description,
    required this.isActive,
    required this.isDefault,
    required this.level,
    required this.refId,
    this.parentAccountId,
    required this.branchId,
  });

  factory ChartAccount.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChartAccount(
      id: doc.id,
      accountCode: data['account_code'] ?? '',
      accountName: data['account_name'] ?? '',
      accountSubType: data['account_sub_type'] ?? '',
      accountType: data['account_type'] ?? '',
      childAccountIds: List<String>.from(data['child_account_ids'] ?? []),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'],
      currentBalance: (data['current_balance'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      isActive: data['is_active'] ?? true,
      isDefault: data['is_default'] ?? false,
      level: data['level'] ?? 0,
      refId: data['ref_id'] ?? '',
      parentAccountId: data['parent_account_id'],
      branchId: data['branch_id'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'account_code': accountCode,
      'account_name': accountName,
      'account_sub_type': accountSubType,
      'account_type': accountType,
      'child_account_ids': childAccountIds,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'current_balance': currentBalance,
      'description': description,
      'is_active': isActive,
      'is_default': isDefault,
      'level': level,
      'ref_id': refId,
      'parent_account_id': parentAccountId,
      'branch_id': branchId,
    };
  }
}

class AccountTreeNode {
  ChartAccount account;
  List<AccountTreeNode> children;

  AccountTreeNode({required this.account, List<AccountTreeNode>? children})
    : children = children ?? []; // Ensure mutable list
}
