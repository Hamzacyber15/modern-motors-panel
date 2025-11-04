import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? id;
  double? amount;
  String? currencyId;
  String? code;
  Timestamp? date;
  String? unitId;
  String? vendorId;
  String? categoryId;
  String? treasuryId;
  String? journalId;
  String? supplierId;
  String? description;
  String? createdBy;
  String? status;

  bool? isTaxable;
  String? vat1Id;
  double? vat1Percentage;
  double? vat1Amount;

  String? vat2Id;
  double? vat2Percentage;
  double? vat2Amount;

  String? attachments;
  Timestamp? createdAt;

  ExpenseModel({
    this.id,
    this.amount,
    this.currencyId,
    this.code,
    this.date,
    this.unitId,
    this.vendorId,
    this.categoryId,
    this.treasuryId,
    this.journalId,
    this.supplierId,
    this.description,
    this.createdBy,
    this.isTaxable,
    this.vat1Id,
    this.vat1Percentage,
    this.vat1Amount,
    this.vat2Id,
    this.vat2Percentage,
    this.vat2Amount,
    this.attachments,
    this.createdAt,
    this.status,
  });

  /// ✅ Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currencyId': currencyId,
      'code': code,
      'date': date,
      'unitId': unitId,
      'vendorId': vendorId,
      'categoryId': categoryId,
      'treasuryId': treasuryId,
      'journalId': journalId,
      'createdBy': createdBy,
      'supplierId': supplierId,
      'description': description,
      'isTaxable': isTaxable,
      'vat1Id': vat1Id,
      'vat1Percentage': vat1Percentage,
      'vat1Amount': vat1Amount,
      'vat2Id': vat2Id,
      'vat2Percentage': vat2Percentage,
      'vat2Amount': vat2Amount,
      'attachments': attachments ?? '',
      'status': status ?? 'active',
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }

  /// ✅ Create from Firestore Document
  factory ExpenseModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};

    return ExpenseModel(
      id: doc.id,
      amount: (map['amount'] ?? 0).toDouble(),
      currencyId: map['currencyId'],
      code: map['code'],
      date: map['date'] ?? Timestamp.now(),
      unitId: map['unitId'],
      vendorId: map['vendorId'],
      categoryId: map['categoryId'],
      createdBy: map['createdBy'],
      treasuryId: map['treasuryId'],
      journalId: map['journalId'],
      supplierId: map['supplierId'],
      status: map['status'] ?? 'Active',
      description: map['description'],
      isTaxable: map['isTaxable'],
      vat1Id: map['vat1Id'],
      vat1Percentage: map['vat1Percentage']?.toDouble(),
      vat1Amount: map['vat1Amount']?.toDouble(),
      vat2Id: map['vat2Id'],
      vat2Percentage: map['vat2Percentage']?.toDouble(),
      vat2Amount: map['vat2Amount']?.toDouble(),
      attachments: map['attachments'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}
