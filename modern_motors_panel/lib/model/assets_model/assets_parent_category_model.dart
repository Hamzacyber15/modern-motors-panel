import 'package:cloud_firestore/cloud_firestore.dart';

class AssetsParentCategoryModel {
  String? id;
  String name;
  String status;
  Timestamp? timestamp;

  AssetsParentCategoryModel({
    this.id,
    required this.name,
    required this.status,
    this.timestamp,
  });

  factory AssetsParentCategoryModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AssetsParentCategoryModel(
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
