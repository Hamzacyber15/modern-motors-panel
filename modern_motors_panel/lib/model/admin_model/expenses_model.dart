import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesModel {
  final String? id;
  final String name;
  final Timestamp? timestamp;
  final String status;

  ExpensesModel({
    this.id,
    required this.name,
    this.timestamp,
    this.status = 'active',
  });

  factory ExpensesModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ExpensesModel(
      id: doc.id,
      name: data['name'] ?? '',
      status: data['status'] ?? 'inactive',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'name': name,
      'status': status,
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
