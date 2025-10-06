import 'package:cloud_firestore/cloud_firestore.dart';

class UnitModel {
  final String id;
  final String name;
  final String status;
  final Timestamp? timestamp;
  UnitModel({
    required this.id,
    required this.name,
    this.status = 'inactive',
    this.timestamp,
  });
  factory UnitModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UnitModel(
      id: doc.id,
      name: data['name'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: data['status'] ?? 'inactive',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
