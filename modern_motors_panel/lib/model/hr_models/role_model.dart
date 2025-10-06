import 'package:cloud_firestore/cloud_firestore.dart';

class RoleModel {
  final String? id;
  final String name;
  final String status;
  final Timestamp? timestamp;

  const RoleModel({
    this.id,
    required this.name,
    this.status = 'inactive',
    this.timestamp,
  });

  factory RoleModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return RoleModel(
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
