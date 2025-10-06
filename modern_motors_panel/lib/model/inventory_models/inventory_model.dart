import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryModel {
  final String? id;
  final String name;
  final String image;
  final String? productId;
  final double costPrice;
  final double totalCostPrice;
  final double salePrice;
  final int totalItem;
  final int? threshold;
  final String? subCategoryId;
  final String? brandId;
  final String? branchId;
  final String? vendorId;
  final String? status;
  final Timestamp? timestamp;

  InventoryModel({
    this.id,
    this.productId,
    required this.name,
    required this.image,
    required this.totalCostPrice,
    required this.costPrice,
    required this.salePrice,
    // required this.totalSalePrice,
    required this.totalItem,
    this.subCategoryId,
    this.threshold,
    this.status,
    this.timestamp,
    this.branchId,
    this.vendorId,
    this.brandId,
  });

  factory InventoryModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return InventoryModel(
      id: doc.id,
      productId: map['productId'],
      image: map['image'] ?? '',
      name: map['name'],
      subCategoryId: map['subCategoryId'] ?? '',
      status: map['status'] ?? 'pending',
      costPrice: (map['costPrice'] ?? 0).toDouble(),
      totalCostPrice: (map['totalCostPrice'] ?? 0).toDouble(),
      salePrice: (map['salePrice'] ?? 0).toDouble(),
      // totalSalePrice: (map['totalSalePrice'] ?? 0).toDouble(),
      totalItem: map['totalItem'] ?? 0,
      threshold: map['threshold'] ?? 0,
      branchId: map['branchId'] ?? '',
      brandId: map['brandId'] ?? '',
      vendorId: map['vendorId'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'brandId': brandId,
      'branchId': branchId,
      'subCategoryId': subCategoryId,
      'status': status,
      'vendorId': vendorId,
      'salePrice': salePrice,
      // 'totalSalePrice': totalSalePrice,
      'threshold': threshold,
      'costPrice': costPrice,
      'totalCostPrice': totalCostPrice,
      'totalItem': totalItem,
    };
  }
}
