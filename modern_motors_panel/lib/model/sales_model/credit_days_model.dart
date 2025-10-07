// credit_days_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CreditDaysModel {
  final String id;
  final List<int> creditDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String updatedBy;

  CreditDaysModel({
    required this.id,
    required this.creditDays,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory CreditDaysModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return CreditDaysModel(
      id: documentId,
      creditDays: List<int>.from(data['creditDays'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      updatedBy: data['updatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'creditDays': creditDays,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'updatedBy': updatedBy,
    };
  }

  CreditDaysModel copyWith({
    List<int>? creditDays,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return CreditDaysModel(
      id: id,
      creditDays: creditDays ?? this.creditDays,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
