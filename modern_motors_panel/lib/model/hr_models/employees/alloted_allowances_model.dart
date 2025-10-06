import 'package:cloud_firestore/cloud_firestore.dart';

class AllotedAllowancesModel {
  final String allowance;
  final String allowanceId;
  final double amount;
  final String arabicAllowance;
  final String arabicCategory;
  final String category;

  AllotedAllowancesModel({
    required this.allowance,
    required this.allowanceId,
    required this.amount,
    required this.arabicAllowance,
    required this.arabicCategory,
    required this.category,
  });

  factory AllotedAllowancesModel.fromMap(Map<String, dynamic> map) {
    double a = double.tryParse(map['amount'].toString()) ?? 0.0;
    return AllotedAllowancesModel(
      allowance: map['allowance'],
      allowanceId: map['allowanceId'],
      amount: a,
      arabicAllowance: map['arabicAllowance'] ?? '',
      arabicCategory: map['arabicCategory'] ?? "",
      category: map['category'] ?? "",
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'allowance': allowance,
      'amount': amount,
      'arabicAllowance': arabicAllowance,
      'arabicCategory': arabicCategory,
      'category': category,
      'createdAt': Timestamp.now(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {
      'allowance': allowance,
      'amount': amount,
      'arabicAllowance': arabicAllowance,
      'arabicCategory': arabicCategory,
      'category': category,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
