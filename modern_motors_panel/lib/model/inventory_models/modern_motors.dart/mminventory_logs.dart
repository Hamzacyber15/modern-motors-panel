import 'package:cloud_firestore/cloud_firestore.dart';

class MmInventoryLog {
  final String? id;
  final String brandId;
  final double change;
  final Timestamp createdAt;
  final String documentId;
  final String documentType;
  final double newAverageCost;
  final double newStock;
  final String note;
  final double previousAverageCost;
  final double previousStock;
  final String productCategoryId;
  final String productId;
  final String productName;
  final String productSubCategoryId;
  final Timestamp timestamp;
  final String type;
  final double valueImpact;
  final double unitCost;

  MmInventoryLog({
    this.id,
    required this.brandId,
    required this.change,
    required this.createdAt,
    required this.documentId,
    required this.documentType,
    required this.newAverageCost,
    required this.newStock,
    required this.note,
    required this.previousAverageCost,
    required this.previousStock,
    required this.productCategoryId,
    required this.productId,
    required this.productName,
    required this.productSubCategoryId,
    required this.timestamp,
    required this.type,
    required this.valueImpact,
    required this.unitCost,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'change': change,
      'createdAt': createdAt,
      'documentId': documentId,
      'documentType': documentType,
      'newAverageCost': newAverageCost,
      'newStock': newStock,
      'note': note,
      'previousAverageCost': previousAverageCost,
      'previousStock': previousStock,
      'productCategoryId': productCategoryId,
      'productId': productId,
      'productName': productName,
      'productSubCategoryId': productSubCategoryId,
      'timestamp': timestamp,
      'type': type,
      'valueImpact': valueImpact,
      'unitCost': unitCost,
    };
  }

  // Create model from Firestore document
  factory MmInventoryLog.fromJson(Map<String, dynamic> json, String id) {
    return MmInventoryLog(
      id: id,
      brandId: json['brandId'] as String? ?? '',
      change: (json['change'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
      documentId: json['documentId'] as String? ?? '',
      documentType: json['documentType'] as String? ?? '',
      newAverageCost: (json['newAverageCost'] as num?)?.toDouble() ?? 0.0,
      newStock: (json['newStock'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String? ?? '',
      previousAverageCost:
          (json['previousAverageCost'] as num?)?.toDouble() ?? 0.0,
      previousStock: (json['previousStock'] as num?)?.toDouble() ?? 0.0,
      productCategoryId: json['productCategoryId'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      productSubCategoryId: json['productSubCategoryId'] as String? ?? '',
      timestamp: json['timestamp'] as Timestamp? ?? Timestamp.now(),
      type: json['type'] as String? ?? '',
      valueImpact: (json['valueImpact'] as num?)?.toDouble() ?? 0.0,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Create a copy of the model with updated fields
  MmInventoryLog copyWith({
    String? brandId,
    double? change,
    Timestamp? createdAt,
    String? documentId,
    String? documentType,
    double? newAverageCost,
    double? newStock,
    String? note,
    double? previousAverageCost,
    double? previousStock,
    String? productCategoryId,
    String? productId,
    String? productName,
    String? productSubCategoryId,
    Timestamp? timestamp,
    String? type,
    double? valueImpact,
  }) {
    return MmInventoryLog(
      id: id,
      brandId: brandId ?? this.brandId,
      change: change ?? this.change,
      createdAt: createdAt ?? this.createdAt,
      documentId: documentId ?? this.documentId,
      documentType: documentType ?? this.documentType,
      newAverageCost: newAverageCost ?? this.newAverageCost,
      newStock: newStock ?? this.newStock,
      note: note ?? this.note,
      previousAverageCost: previousAverageCost ?? this.previousAverageCost,
      previousStock: previousStock ?? this.previousStock,
      productCategoryId: productCategoryId ?? this.productCategoryId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productSubCategoryId: productSubCategoryId ?? this.productSubCategoryId,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      valueImpact: valueImpact ?? this.valueImpact,
      unitCost: unitCost,
    );
  }

  @override
  String toString() {
    return 'MmInventoryLog{'
        'id: $id, '
        'brandId: $brandId, '
        'change: $change, '
        'createdAt: $createdAt, '
        'documentId: $documentId, '
        'documentType: $documentType, '
        'newAverageCost: $newAverageCost, '
        'newStock: $newStock, '
        'note: $note, '
        'previousAverageCost: $previousAverageCost, '
        'previousStock: $previousStock, '
        'productCategoryId: $productCategoryId, '
        'productId: $productId, '
        'productName: $productName, '
        'productSubCategoryId: $productSubCategoryId, '
        'timestamp: $timestamp, '
        'type: $type, '
        'valueImpact: $valueImpact'
        '}';
  }
}
