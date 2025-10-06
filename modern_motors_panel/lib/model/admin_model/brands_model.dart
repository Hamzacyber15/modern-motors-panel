import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String? id;
  final String name;
  final String status;
  final Timestamp? timestamp;

  const BrandModel({
    this.id,
    required this.name,
    this.status = 'active',
    this.timestamp,
  });

  factory BrandModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BrandModel(
      id: doc.id,
      name: data['name'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: data['status'] ?? 'inactive',
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
