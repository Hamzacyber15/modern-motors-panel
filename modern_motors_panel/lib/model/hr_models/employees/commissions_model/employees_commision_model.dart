import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeCommissionModel {
  String? id;
  final String employeeId;
  String? bookingId;
  final bool isAmount;
  final double value;
  final String userId;
  final Timestamp createdAt;

  EmployeeCommissionModel({
    this.id,
    required this.employeeId,
    this.bookingId,
    required this.isAmount,
    required this.value,
    required this.userId,
    required this.createdAt,
  });

  // helpful getters
  bool get isPercentage => !isAmount;

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'bookingId': bookingId,
      'isAmount': isAmount,
      'value': value,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  factory EmployeeCommissionModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return EmployeeCommissionModel(
      id: doc.id,
      employeeId: (map['employeeId'] ?? '') as String,
      bookingId: (map['bookingId'] ?? '') as String,
      isAmount: (map['isAmount'] as bool?) ?? true,
      value: (map['value'] is num) ? (map['value'] as num).toDouble() : 0.0,
      userId: (map['userId'] ?? '') as String,
      createdAt: (map['createdAt'] is Timestamp)
          ? map['createdAt'] as Timestamp
          : Timestamp.now(),
    );
  }

  DateTime get createdAtDateTime => createdAt.toDate();

  EmployeeCommissionModel copyWith({
    String? employeeId,
    String? bookingId,
    bool? isAmount,
    double? value,
    String? userId,
    Timestamp? createdAt,
  }) {
    return EmployeeCommissionModel(
      employeeId: employeeId ?? this.employeeId,
      bookingId: bookingId ?? this.bookingId,
      isAmount: isAmount ?? this.isAmount,
      value: value ?? this.value,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
