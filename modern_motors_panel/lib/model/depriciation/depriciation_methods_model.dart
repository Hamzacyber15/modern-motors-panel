import 'package:cloud_firestore/cloud_firestore.dart';

class DepreciationMethodsModel {
  String? id;
  String name;
  String status;
  Timestamp? timestamp;

  DepreciationMethodsModel({
    this.id,
    required this.name,
    required this.status,
    this.timestamp,
  });

  factory DepreciationMethodsModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return DepreciationMethodsModel(
      id: doc.id,
      name: data['name'] ?? '',
      status: data['status'] ?? 'active',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'status': status};
  }
}
