import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String? code;
  final String? productName;
  final String? image;
  final String? categoryId;
  final double? threshold;
  final String? subCategoryId;
  final String? brandId;
  final String? status;
  final Timestamp? createAt;
  final double? fifoValue;
  final double? lastCost;
  final Timestamp? lastUpdated;
  final double? totalStockOnHand;
  final double? averageCost;
  final String? createdBy;
  final double? minimumPrice;
  final String? description;
  final double? sellingPrice;
  final String? sku;
  final bool? includeInInventory;
  ProductModel({
    this.id,
    this.productName,
    this.code,
    this.categoryId,
    this.image,
    this.subCategoryId,
    this.threshold,
    this.status,
    this.createAt,
    this.brandId,
    this.fifoValue,
    this.lastCost,
    this.lastUpdated,
    this.totalStockOnHand,
    this.averageCost,
    this.createdBy,
    this.minimumPrice,
    this.description,
    this.sellingPrice,
    this.sku,
    this.includeInInventory,
  });

  factory ProductModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return ProductModel(
      id: doc.id,
      code: map['code'],
      productName: map['productName'],
      categoryId: map['categoryId'],
      image: map['image'] ?? '',
      subCategoryId: map['subCategoryId'] ?? '',
      status: map['status'] ?? 'pending',
      threshold: map['threshold'] ?? 0.0,
      brandId: map['brandId'] ?? '',
      createAt: map['createAt'] ?? Timestamp.now(),
      fifoValue: double.tryParse(map['fifoValue'].toString()) ?? 0,
      lastCost: double.tryParse(map['lastCost'].toString()) ?? 0,
      sellingPrice: double.tryParse(map['sellingPrice'].toString()) ?? 0,
      lastUpdated: map['lastUpdated'] ?? Timestamp.now(),
      totalStockOnHand:
          double.tryParse(map['totalStockOnHand'].toString()) ?? 0,
      averageCost: double.tryParse(map['averageCost'].toString()) ?? 0,
      createdBy: map['createdBy'] ?? "",
      minimumPrice: double.tryParse(map['minimumPrice'].toString()) ?? 0,
      sku: map['sku'] ?? "",
      description: map['description'] ?? "",
      includeInInventory: map['includeInInventory'] ?? false,
    );
  }

  factory ProductModel.fromMap1(Map<String, dynamic> map, {String? id}) {
    return ProductModel(
      id: id,
      code: map['code'],
      productName: map['productName'],
      categoryId: map['categoryId'],
      subCategoryId: map['subCategoryId'] ?? '',
      image: map['image'] ?? '',
      status: map['status'] ?? 'pending',
      threshold: (map['threshold'] ?? 0).toDouble(),
      includeInInventory: (map['includeInInventory'] ?? false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'code': code,
      'categoryId': categoryId,
      'image': image,
      'brandId': brandId,
      'subCategoryId': subCategoryId,
      'status': status,
      'threshold': threshold,
      'createdBy': createdBy,
      'minimumPrice': minimumPrice,
      'sellingPrice': sellingPrice,
      'sku': sku,
      'description': description,
      'includeInInventory': includeInInventory,
    };
  }

  ProductModel copyWith({
    String? id,
    String? productName,
    double? totalStockOnHand,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      totalStockOnHand: totalStockOnHand ?? this.totalStockOnHand,
    );
  }
}
