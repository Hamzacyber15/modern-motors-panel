import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseCategoryModel {
  String? id;
  String name;
  String? code;
  Timestamp? timestamp;
  String status;
  String? createdBy;

  ExpenseCategoryModel({
    this.id,
    required this.name,
    this.code,
    this.timestamp,
    this.createdBy,
    this.status = 'active',
  });

  factory ExpenseCategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ExpenseCategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      createdBy: data['createdBy'] ?? '',
      status: data['status'] ?? 'active',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'name': name,
      'status': status,
      'code': code,
      'createdBy': createdBy,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {'name': name, 'status': status};
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'status': status, 'timestamp': timestamp};
  }
}
