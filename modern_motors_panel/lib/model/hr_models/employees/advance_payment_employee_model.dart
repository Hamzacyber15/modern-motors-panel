import 'package:cloud_firestore/cloud_firestore.dart';

class AdvanceEmployeePaymentModel {
  String? id;
  double amount;
  String referenceNo;
  String employeeId;
  String branchId;
  String code;
  DateTime date;
  List<String> attachments;
  String status;
  Timestamp createdAt;
  String createdBy;

  AdvanceEmployeePaymentModel({
    this.id,
    required this.amount,
    required this.referenceNo,
    required this.employeeId,
    required this.branchId,
    required this.date,
    required this.code,
    this.attachments = const [], // ✅ Safe default (no nulls)
    required this.status,
    required this.createdAt,
    required this.createdBy,
  });

  /// ✅ Firestore → Model
  factory AdvanceEmployeePaymentModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return AdvanceEmployeePaymentModel(
      id: doc.id,
      amount: (data['amount'] ?? 0).toDouble(),
      referenceNo: data['referenceNo'] ?? '',
      employeeId: data['employeeId'] ?? '',
      branchId: data['branchId'] ?? '',
      code: data['code'] ?? '',
      date: (data['date'] is Timestamp)
          ? (data['date'] as Timestamp).toDate()
          : DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      attachments: (data['attachments'] != null)
          ? List<String>.from(data['attachments'])
          : [],
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  /// ✅ Model → Firestore
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'referenceNo': referenceNo,
      'employeeId': employeeId,
      'branchId': branchId,
      'date': Timestamp.fromDate(date),
      'attachments': attachments,
      'status': status,
      'code': code,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }

  /// ✅ Copy method
  AdvanceEmployeePaymentModel copyWith({
    String? id,
    double? amount,
    String? referenceNo,
    String? employeeId,
    String? branchId,
    DateTime? date,
    List<String>? attachments,
    String? status,
    Timestamp? createdAt,
    String? createdBy,
    String? code,
  }) {
    return AdvanceEmployeePaymentModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      referenceNo: referenceNo ?? this.referenceNo,
      employeeId: employeeId ?? this.employeeId,
      branchId: branchId ?? this.branchId,
      date: date ?? this.date,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      code: code ?? this.code,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
