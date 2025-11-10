import 'package:cloud_firestore/cloud_firestore.dart';

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
