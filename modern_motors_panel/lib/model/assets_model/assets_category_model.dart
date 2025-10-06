import 'package:cloud_firestore/cloud_firestore.dart';

class AssetsCategoryModel {
  final String? id;
  final String? parentId;
  final String name;
  final bool? isDepreciable;
  final String? status;
  final String? taxCategoryCode;
  final List? defaultAccount;
  final Timestamp? timestamp;

  AssetsCategoryModel({
    this.id,
    this.parentId,
    required this.name,
    this.isDepreciable,
    this.defaultAccount,
    this.taxCategoryCode,
    this.status = 'active',
    this.timestamp,
  });

  factory AssetsCategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return AssetsCategoryModel(
      id: doc.id,
      parentId: data['parentId']?.toString(),
      name: data['name']?.toString() ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      defaultAccount: data['defaultAccount'] ?? [],
      isDepreciable: data['isDepreciable'] ?? false,
      status: data['status'] ?? 'Pending',
      taxCategoryCode: data['taxCategoryCode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'name': name,
      'isDepreciable': isDepreciable,
      'defaultAccount': defaultAccount,
      'taxCategoryCode': taxCategoryCode,
      'status': status,
    };
  }
}
