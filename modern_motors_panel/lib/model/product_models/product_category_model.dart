import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  String? id;
  String? createdBy;
  String productName;
  String? code;
  String? image;
  String? description;
  String? unitId;
  String? status;
  List? subCategories;
  Timestamp? timestamp;

  ProductCategoryModel({
    this.id,
    this.createdBy,
    required this.productName,
    this.code,
    this.image,
    this.description,
    this.unitId,
    this.subCategories,
    this.timestamp,
    this.status = 'active',
  });

  factory ProductCategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ProductCategoryModel(
      id: doc.id,
      createdBy: data['createdBy']?.toString(),
      productName: data['productName']?.toString() ?? '',
      code: data['code']?.toString(),
      image: data['image']?.toString(),
      description: data['description']?.toString(),
      unitId: data['unitId']?.toString(),
      status: data['status'] ?? 'Pending',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'createdBy': createdBy,
      'image': image,
      'description': description,
      'unitId': unitId,
      'code': code,
      'status': status,
    };
  }
}
