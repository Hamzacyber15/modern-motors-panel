import 'package:cloud_firestore/cloud_firestore.dart';

class AllowanceModel {
  String docId;
  String arabicCategoryHeading;
  String categoryHeading;
  String status;
  String headingId;
  String arabicNarration;
  String narration;
  String notes;
  double amount;
  Timestamp timestamp;
  Timestamp bonusDate;
  // New fields
  Timestamp allowanceDate;
  String employeeId;
  String employeeUserId;
  String generatedBy;
  String incentiveType;
  String repeat;
  String role;
  String type;
  int units;
  String addedby;
  String allowanceId;
  bool? fixed;
  AllowanceModel({
    required this.docId,
    required this.arabicCategoryHeading,
    required this.categoryHeading,
    required this.status,
    required this.headingId,
    required this.arabicNarration,
    required this.narration,
    required this.notes,
    required this.amount,
    required this.timestamp,
    required this.bonusDate,
    required this.allowanceDate,
    required this.employeeId,
    required this.employeeUserId,
    required this.generatedBy,
    required this.incentiveType,
    required this.repeat,
    required this.role,
    required this.type,
    required this.units,
    required this.addedby,
    required this.allowanceId,
    this.fixed,
  });

  factory AllowanceModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return AllowanceModel(
      docId: snapshot.id,
      arabicCategoryHeading: data['arabicCategoryHeading'] ?? '',
      categoryHeading: data['categoryHeading'] ?? '',
      status: data['status'] ?? '',
      headingId: data['headingId'] ?? '',
      arabicNarration: data['arabicNarration'] ?? '',
      narration: data['narration'] ?? '',
      notes: data['notes'] == '' ? 'N/A' : data['notes'] ?? '',
      amount: (data['amount'] is int)
          ? (data['amount'] as int).toDouble()
          : (data['amount'] ?? 0.0),
      timestamp: data['timestamp'] ?? Timestamp.now(),
      bonusDate: data['timestamp'] ?? Timestamp.now(),
      allowanceDate: data['allowanceDate'] ?? Timestamp.now(),
      employeeId: data['employeeId'] ?? '',
      employeeUserId: data['employeeUserId'] ?? '',
      generatedBy: data['generatedBy'] ?? '',
      incentiveType: data['incentiveType'] ?? '',
      repeat: data['repeat'] ?? '',
      role: data['role'] ?? '',
      type: data['type'] ?? '',
      units: (data['units'] is int) ? data['units'] : 0,
      addedby: data['addedby'] ?? "",
      allowanceId: data['allowanceId'] ?? "",
      fixed: data['fixed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryHeading': categoryHeading,
      'arabicCategoryHeading': arabicCategoryHeading,
      'headingId': headingId,
      'narration': narration,
      'arabicNarration': arabicNarration,
      'allowanceId': docId,
      'amount': amount,
    };
  }

  factory AllowanceModel.fromMap(Map<String, dynamic> map) {
    return AllowanceModel(
      docId: map['allowanceId'],
      arabicCategoryHeading: map['arabicCategoryHeading'] ?? '',
      categoryHeading: map['categoryHeading'] ?? '',
      status: map['status'] ?? '',
      headingId: map['headingId'] ?? '',
      arabicNarration: map['arabicNarration'] ?? '',
      narration: map['narration'] ?? '',
      notes: map['notes'] == '' ? 'N/A' : map['notes'] ?? '',
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : (map['amount'] ?? 0.0),
      timestamp: map['timestamp'] ?? Timestamp.now(),
      bonusDate: map['timestamp'] ?? Timestamp.now(),
      allowanceDate: map['allowanceDate'] ?? Timestamp.now(),
      employeeId: map['employeeId'] ?? '',
      employeeUserId: map['employeeUserId'] ?? '',
      generatedBy: map['generatedBy'] ?? '',
      incentiveType: map['incentiveType'] ?? '',
      repeat: map['repeat'] ?? '',
      role: map['role'] ?? '',
      type: map['type'] ?? '',
      units: (map['units'] is int) ? map['units'] : 0,
      addedby: map['addedby'] ?? "",
      fixed: map['fixed'] ?? false,
      allowanceId: map['allowanceId'] ?? "",
    );
  }
}
