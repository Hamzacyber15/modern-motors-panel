import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
