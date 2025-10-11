// chart_account_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/ChartOfAccountsScreen.dart';

class ChartAccountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDefaultChartOfAccounts({
    required String branchId,
    bool isMainBranch = true,
  }) async {
    try {
      print('🚀 Starting default accounts creation for branch: $branchId');
      print('📝 Is Main Branch: $isMainBranch');

      final batch = _firestore.batch();
      final accountsMap = <String, Map<String, dynamic>>{};
      final childAccountsMap = <String, List<String>>{};

      // Create all accounts first
      for (final entry in DefaultAccountsConfig.defaultAccounts.entries) {
        final accountType = entry.key;
        final accounts = entry.value;

        print(
          '📊 Processing account type: $accountType with ${accounts.length} accounts',
        );

        for (final accountData in accounts) {
          // Correct document path: chartOfAccounts/{branchId}/chartOfAccounts/{accountId}
          final accountDocRef = _firestore
              .collection('chartOfAccounts')
              .doc(branchId)
              .collection('chartOfAccounts')
              .doc();

          final accountId = accountDocRef.id;
          final refId = isMainBranch ? "NRHLuRZIA2AMZXjW4TDI" : branchId;

          final account = ChartAccount(
            id: accountId,
            accountCode: accountData['code'] as String,
            accountName: accountData['name'] as String,
            accountSubType: accountData['sub_type'] as String,
            accountType: accountType,
            childAccountIds: [],
            createdAt: DateTime.now(),
            currentBalance: 0,
            description: 'Default ${accountData['name']} account',
            isActive: true,
            isDefault: true,
            level: accountData['level'] as int,
            refId: refId,
            parentAccountId: null,
            branchId: branchId,
          );

          accountsMap[accountData['code'] as String] = {
            'id': accountId,
            'account': account,
            'parent': accountData['parent'],
            'docRef': accountDocRef, // Store the document reference
          };

          batch.set(accountDocRef, account.toFirestore());

          print(
            '✅ Created account: ${accountData['code']} - ${accountData['name']}',
          );
          print('   🔑 Document ID: $accountId');
          print('   📍 Branch ID: $branchId');
          print('   📁 Full Path: ${accountDocRef.path}');
        }
      }

      print('📋 Total accounts to create: ${accountsMap.length}');

      // Update parent-child relationships
      for (final entry in accountsMap.entries) {
        final code = entry.key;
        final accountInfo = entry.value;
        final parentCode = accountInfo['parent'] as String?;

        if (parentCode != null && accountsMap.containsKey(parentCode)) {
          final parentAccount = accountsMap[parentCode]!;
          final childAccountId = accountInfo['id'] as String;
          final childAccountDocRef = accountInfo['docRef'] as DocumentReference;

          print('🔗 Setting parent-child relationship:');
          print('   Parent: $parentCode -> Child: $code');
          print(
            '   Parent ID: ${parentAccount['id']} -> Child ID: $childAccountId',
          );

          // Update child account with parent ID - Use the correct document reference
          final childAccount = accountInfo['account'] as ChartAccount;
          batch.update(childAccountDocRef, {
            'parent_account_id': parentAccount['id'] as String,
            'level': childAccount.level,
          });

          // Track child IDs for parent
          if (!childAccountsMap.containsKey(parentCode)) {
            childAccountsMap[parentCode] = [];
          }
          childAccountsMap[parentCode]!.add(childAccountId);
        }
      }

      // Update parent accounts with child_account_ids
      for (final entry in childAccountsMap.entries) {
        final parentCode = entry.key;
        final childIds = entry.value;
        final parentAccount = accountsMap[parentCode]!;
        final parentAccountDocRef =
            parentAccount['docRef'] as DocumentReference;

        print('👨‍👧‍👦 Updating parent $parentCode with children: $childIds');

        batch.update(parentAccountDocRef, {'child_account_ids': childIds});
      }

      print('🔥 Committing batch write...');
      await batch.commit();
      print('🎉 Default chart of accounts created for branch: $branchId');
      print('📊 Total documents created: ${accountsMap.length}');

      // Verify the documents were created
      await _verifyDocumentsCreated(branchId, accountsMap.length);
    } catch (e) {
      print('❌ Error creating default accounts: $e');
      print('📋 Stack trace: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _verifyDocumentsCreated(
    String branchId,
    int expectedCount,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('chartOfAccounts')
          .doc(branchId)
          .collection('chartOfAccounts')
          .get();

      print(
        '🔍 Verification: Found ${snapshot.docs.length} documents in chartOfAccounts/$branchId/chartOfAccounts collection',
      );

      for (final doc in snapshot.docs) {
        final data = doc.data();
        print('   📄 Document: ${doc.id}');
        print('   📊 Data: ${data['account_code']} - ${data['account_name']}');
      }

      if (snapshot.docs.length >= expectedCount) {
        print('✅ SUCCESS: Documents created successfully!');
      } else {
        print(
          '⚠️ WARNING: Expected $expectedCount documents but found ${snapshot.docs.length}',
        );
      }
    } catch (e) {
      print('❌ Error verifying documents: $e');
    }
  }

  // Future<String> addSubAccount({
  //   required String parentAccountId,
  //   required ChartAccount accountData,
  //   required String branchId,
  // }) async {
  //   try {
  //     // Correct path for parent account
  //     final parentAccountRef = _firestore
  //         .collection('chartOfAccounts')
  //         .doc(branchId)
  //         .collection('chartOfAccounts')
  //         .doc(parentAccountId);

  //     final parentDoc = await parentAccountRef.get();

  //     if (!parentDoc.exists) {
  //       throw Exception('Parent account not found');
  //     }

  //     final parentAccount = ChartAccount.fromFirestore(parentDoc);

  //     // Create new sub-account with correct path
  //     final newAccountDocRef = _firestore
  //         .collection('chartOfAccounts')
  //         .doc(branchId)
  //         .collection('chartOfAccounts')
  //         .doc();

  //     final newAccountId = newAccountDocRef.id;
  //     User? user = FirebaseAuth.instance.currentUser;

  //     final subAccount = ChartAccount(
  //       id: newAccountId,
  //       accountCode: accountData.accountCode,
  //       accountName: accountData.accountName,
  //       accountSubType: accountData.accountSubType,
  //       accountType: accountData.accountType,
  //       childAccountIds: [],
  //       createdAt: DateTime.now(),
  //       currentBalance: 0,
  //       description: accountData.description,
  //       isActive: true,
  //       isDefault: false,
  //       level: parentAccount.level + 1,
  //       refId: parentAccount.refId,
  //       parentAccountId: parentAccountId,
  //       branchId: branchId,
  //       createdBy: user!.uid,
  //     );

  //     // Update parent account with new child ID
  //     final updatedChildIds = [...parentAccount.childAccountIds, newAccountId];

  //     final batch = _firestore.batch();
  //     batch.set(newAccountDocRef, subAccount.toFirestore());
  //     batch.update(parentAccountRef, {'child_account_ids': updatedChildIds});

  //     await batch.commit();
  //     return newAccountId;
  //   } catch (e) {
  //     print('Error adding sub-account: $e');
  //     rethrow;
  //   }
  // }

  Future<String> addSubAccount({
    required String parentAccountId,
    required ChartAccount accountData,
    required String branchId,
  }) async {
    try {
      debugPrint('Adding sub-account in branch: $branchId');
      debugPrint('Parent Account ID: $parentAccountId');
      debugPrint(
        'NewAccount: ${accountData.accountCode} - ${accountData.accountName}',
      );
      // Get the parent account from the SAME BRANCH
      final parentAccountRef = _firestore
          .collection('chartOfAccounts')
          .doc(branchId)
          .collection('chartOfAccounts')
          .doc(parentAccountId);
      final parentDoc = await parentAccountRef.get();
      if (!parentDoc.exists) {
        throw Exception('Parent account not found in branch $branchId');
      }
      final parentAccount = ChartAccount.fromFirestore(parentDoc);
      debugPrint(
        '👨‍👦 Parent found: ${parentAccount.accountName} (Level: ${parentAccount.level})',
      );
      if (parentAccount.level >= 5) {
        throw Exception('Cannot create sub-accounts beyond level 5');
      }
      // Create new sub-account in the SAME BRANCH
      final newAccountDocRef = _firestore
          .collection('chartOfAccounts')
          .doc(branchId)
          .collection('chartOfAccounts')
          .doc();

      final newAccountId = newAccountDocRef.id;
      final user = FirebaseAuth.instance.currentUser;
      final subAccount = ChartAccount(
        id: newAccountId,
        accountCode: accountData.accountCode,
        accountName: accountData.accountName,
        accountSubType: accountData.accountSubType,
        accountType: accountData.accountType,
        childAccountIds: [], // New account starts with no children
        createdAt: DateTime.now(),
        currentBalance: 0,
        description: accountData.description,
        isActive: true,
        isDefault: false, // Manually created accounts are not default
        level: parentAccount.level + 1, // Increment level from parent
        refId: branchId,
        parentAccountId: parentAccountId, // Link to parent in same branch
        branchId: branchId, // Same branch as parent
        createdBy: user?.uid,
      );
      final updatedChildIds = List<String>.from(parentAccount.childAccountIds)
        ..add(newAccountId);
      debugPrint('Updating parent with new child: $newAccountId');
      debugPrint('Parent now has ${updatedChildIds.length} children');
      debugPrint('New account level: ${subAccount.level}');
      final batch = _firestore.batch();
      batch.set(newAccountDocRef, subAccount.toFirestore());
      batch.update(parentAccountRef, {'child_account_ids': updatedChildIds});
      await batch.commit();
      debugPrint('Successfully added sub-account: $newAccountId');
      debugPrint('Parent: ${parentAccount.accountName}');
      debugPrint('Branch: $branchId');
      debugPrint('Level: ${subAccount.level}');

      return newAccountId;
    } catch (e) {
      debugPrint('Error adding sub-account: $e');
      rethrow;
    }
  }

  Stream<Map<String, List<AccountTreeNode>>> watchAllAccounts() {
    return _firestore.collection('branches').snapshots().asyncMap((
      branchesSnapshot,
    ) async {
      debugPrint('${branchesSnapshot.docs.length} branches');
      final accountsData = <String, List<ChartAccount>>{};
      for (final branchDoc in branchesSnapshot.docs) {
        final branchId = branchDoc.id;
        final branchData = branchDoc.data();
        debugPrint(
          'DEBUG: Processing branch: ${branchData['branchName']} ($branchId)',
        );
        try {
          // Get accounts for this branch from chartOfAccounts/{branchId}/chartOfAccounts
          final accountsSnapshot = await _firestore
              .collection('chartOfAccounts')
              .doc(branchId)
              .collection('chartOfAccounts')
              .orderBy('account_code')
              .get();

          debugPrint(
            'DEBUG: Branch $branchId has ${accountsSnapshot.docs.length} accounts',
          );
          accountsData[branchId] = accountsSnapshot.docs
              .map((doc) => ChartAccount.fromFirestore(doc))
              .toList();
        } catch (e) {
          debugPrint('DEBUG: Error fetching accounts for branch $branchId: $e');
          accountsData[branchId] = [];
        }
      }
      final mainBranchId = 'NRHLuRZIA2AMZXjW4TDI';
      if (!accountsData.containsKey(mainBranchId)) {
        try {
          final mainAccountsSnapshot = await _firestore
              .collection('chartOfAccounts')
              .doc(mainBranchId)
              .collection('chartOfAccounts')
              .orderBy('account_code')
              .get();

          accountsData[mainBranchId] = mainAccountsSnapshot.docs
              .map((doc) => ChartAccount.fromFirestore(doc))
              .toList();
          debugPrint('branch ${accountsData[mainBranchId]!.length} accounts');
        } catch (e) {
          debugPrint('Error: $e');
        }
      }

      // Build hierarchy for each branch
      final result = <String, List<AccountTreeNode>>{};
      for (final entry in accountsData.entries) {
        result[entry.key] = _buildHierarchy(entry.value);
        print(
          '🌳 DEBUG: Branch ${entry.key} has ${result[entry.key]!.length} root nodes',
        );
      }

      return result;
    });
  }

  List<AccountTreeNode> _buildHierarchy(List<ChartAccount> accounts) {
    _debugAccounts(accounts);
    try {
      final accountMap = <String, AccountTreeNode>{};
      final roots = <AccountTreeNode>[];

      print('🔨 Building hierarchy for ${accounts.length} accounts');

      // Create all nodes first
      for (final account in accounts) {
        accountMap[account.id!] = AccountTreeNode(
          account: account,
          children: <AccountTreeNode>[], // Explicitly create mutable list
        );
      }

      // Build tree structure
      for (final account in accounts) {
        final node = accountMap[account.id!]!;
        final parentId = account.parentAccountId;

        if (parentId != null && accountMap.containsKey(parentId)) {
          // Create a new mutable list if needed and add the child
          final parentNode = accountMap[parentId]!;
          parentNode.children = List<AccountTreeNode>.from(parentNode.children)
            ..add(node);
        } else {
          roots.add(node);
        }
      }

      print('🌳 Hierarchy built with ${roots.length} root nodes');
      return roots;
    } catch (e) {
      print('❌ Error building hierarchy: $e');
      return [];
    }
  }

  void _debugAccounts(List<ChartAccount> accounts) {
    print('🐛 DEBUG: Accounts list details:');
    print('   List type: ${accounts.runtimeType}');
    print('   List length: ${accounts.length}');
    print('   Is list mutable: ${accounts is List<ChartAccount>}');

    for (final account in accounts.take(3)) {
      // Show first 3 accounts
      print('   Account: ${account.id} - ${account.accountName}');
      print('   Parent: ${account.parentAccountId}');
      print('   Children: ${account.childAccountIds}');
    }
  }

  // Get account by ID
  Future<ChartAccount?> getAccount(String accountId) async {
    final doc = await _firestore
        .collection('chartOfAccounts')
        .doc(accountId)
        .get();
    return doc.exists ? ChartAccount.fromFirestore(doc) : null;
  }
}
