// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MmInventoryBatchesModel {
//   final String? id;
//   final String batchReference;
//   final Timestamp createdAt;
//   final String grnId;
//   final bool isActive;
//   final String poId;
//   final String productId;
//   final String purchaseId;
//   final int quantityReceived;
//   final int quantityRemaining;
//   final Timestamp receivedDate;
//   final double totalValue;
//   final double unitCost;
//   final Timestamp updatedAt;

//   MmInventoryBatchesModel({
//     this.id,
//     required this.batchReference,
//     required this.createdAt,
//     required this.grnId,
//     required this.isActive,
//     required this.poId,
//     required this.productId,
//     required this.purchaseId,
//     required this.quantityReceived,
//     required this.quantityRemaining,
//     required this.receivedDate,
//     required this.totalValue,
//     required this.unitCost,
//     required this.updatedAt,
//   });

//   // Convert model to Firestore document
//   Map<String, dynamic> toJson() {
//     return {
//       'batchReference': batchReference,
//       'createdAt': createdAt,
//       'grnId': grnId,
//       'isActive': isActive,
//       'poId': poId,
//       'productId': productId,
//       'purchaseId': purchaseId,
//       'quantityReceived': quantityReceived,
//       'quantityRemaining': quantityRemaining,
//       'receivedDate': receivedDate,
//       'totalValue': totalValue,
//       'unitCost': unitCost,
//       'updatedAt': updatedAt,
//     };
//   }

//   // Create model from Firestore document
//   factory MmInventoryBatchesModel.fromJson(
//       Map<String, dynamic> json, String id) {
//     return MmInventoryBatchesModel(
//       id: id,
//       batchReference: json['batchReference'] as String? ?? '',
//       createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
//       grnId: json['grnId'] as String? ?? '',
//       isActive: json['isActive'] as bool? ?? true,
//       poId: json['poId'] as String? ?? '',
//       productId: json['productId'] as String? ?? '',
//       purchaseId: json['purchaseId'] as String? ?? '',
//       quantityReceived: (json['quantityReceived'] as num?)?.toInt() ?? 0,
//       quantityRemaining: (json['quantityRemaining'] as num?)?.toInt() ?? 0,
//       receivedDate: json['receivedDate'] as Timestamp? ?? Timestamp.now(),
//       totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
//       unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0.0,
//       updatedAt: json['updatedAt'] as Timestamp? ?? Timestamp.now(),
//     );
//   }

//   // Create a copy of the model with updated fields
//   MmInventoryBatchesModel copyWith({
//     String? batchReference,
//     Timestamp? createdAt,
//     String? grnId,
//     bool? isActive,
//     String? poId,
//     String? productId,
//     String? purchaseId,
//     int? quantityReceived,
//     int? quantityRemaining,
//     Timestamp? receivedDate,
//     double? totalValue,
//     double? unitCost,
//     Timestamp? updatedAt,
//   }) {
//     return MmInventoryBatchesModel(
//       id: id,
//       batchReference: batchReference ?? this.batchReference,
//       createdAt: createdAt ?? this.createdAt,
//       grnId: grnId ?? this.grnId,
//       isActive: isActive ?? this.isActive,
//       poId: poId ?? this.poId,
//       productId: productId ?? this.productId,
//       purchaseId: purchaseId ?? this.purchaseId,
//       quantityReceived: quantityReceived ?? this.quantityReceived,
//       quantityRemaining: quantityRemaining ?? this.quantityRemaining,
//       receivedDate: receivedDate ?? this.receivedDate,
//       totalValue: totalValue ?? this.totalValue,
//       unitCost: unitCost ?? this.unitCost,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   // Helper methods
//   double get remainingValue => quantityRemaining * unitCost;

//   bool get isFullyConsumed => quantityRemaining == 0;

//   bool get isPartiallyConsumed =>
//       quantityRemaining > 0 && quantityRemaining < quantityReceived;

//   int get consumedQuantity => quantityReceived - quantityRemaining;

//   double get consumedValue => consumedQuantity * unitCost;

//   @override
//   String toString() {
//     return 'MmInventoryBatchesModel{'
//         'id: $id, '
//         'batchReference: $batchReference, '
//         'createdAt: $createdAt, '
//         'grnId: $grnId, '
//         'isActive: $isActive, '
//         'poId: $poId, '
//         'productId: $productId, '
//         'purchaseId: $purchaseId, '
//         'quantityReceived: $quantityReceived, '
//         'quantityRemaining: $quantityRemaining, '
//         'receivedDate: $receivedDate, '
//         'totalValue: $totalValue, '
//         'unitCost: $unitCost, '
//         'updatedAt: $updatedAt'
//         '}';
//   }

//   // Equality check
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MmInventoryBatchesModel &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           batchReference == other.batchReference &&
//           grnId == other.grnId;

//   @override
//   int get hashCode => id.hashCode ^ batchReference.hashCode ^ grnId.hashCode;
// }

// // Add these to your existing MmInventoryBatchesModel class
// extension MmInventoryBatchesExtension on MmInventoryBatchesModel {
//   String get status {
//     if (quantityRemaining == 0) return 'Fully Consumed';
//     if (quantityRemaining < quantityReceived) return 'Partially Consumed';
//     return 'Fully Available';
//   }

//   double get remainingValue => quantityRemaining * unitCost;

//   String get formattedUnitCost => '\$${unitCost.toStringAsFixed(2)}';

//   String get formattedTotalValue => '\$${totalValue.toStringAsFixed(2)}';

//   String get formattedRemainingValue =>
//       '\$${remainingValue.toStringAsFixed(2)}';

//   String get formattedReceivedDate =>
//       receivedDate.toDate().formattedWithDayMonthYear;

//   String get formattedCreatedAt => createdAt.toDate().formattedWithDayMonthYear;
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/extensions.dart';

class MmInventoryBatchesModel {
  final String? id;
  final String batchReference;
  final Timestamp createdAt;
  final String grnId;
  final bool isActive;
  final String poId;
  final String productId;
  final String purchaseId;
  final int quantityReceived;
  final int quantityRemaining;
  final Timestamp receivedDate;
  final double totalValue;
  final double unitCost;
  final Timestamp updatedAt;
  final String? adjustmentId;
  final String? adjustmentType;
  final String? reason;
  final bool? isManualAdjustment;

  MmInventoryBatchesModel({
    this.id,
    required this.batchReference,
    required this.createdAt,
    required this.grnId,
    required this.isActive,
    required this.poId,
    required this.productId,
    required this.purchaseId,
    required this.quantityReceived,
    required this.quantityRemaining,
    required this.receivedDate,
    required this.totalValue,
    required this.unitCost,
    required this.updatedAt,
    this.adjustmentId,
    this.adjustmentType,
    this.reason,
    this.isManualAdjustment,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'batchReference': batchReference,
      'createdAt': createdAt,
      'grnId': grnId,
      'isActive': isActive,
      'poId': poId,
      'productId': productId,
      'purchaseId': purchaseId,
      'quantityReceived': quantityReceived,
      'quantityRemaining': quantityRemaining,
      'receivedDate': receivedDate,
      'totalValue': totalValue,
      'unitCost': unitCost,
      'updatedAt': updatedAt,
      'adjustmentId': adjustmentId,
      'adjustmentType': adjustmentType,
      'reason': reason,
      'isManualAdjustment': isManualAdjustment,
    };
  }

  // Create model from Firestore document
  factory MmInventoryBatchesModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return MmInventoryBatchesModel(
      id: id,
      batchReference: json['batchReference'] as String? ?? '',
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
      grnId: json['grnId'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      poId: json['poId'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      purchaseId: json['purchaseId'] as String? ?? '',
      quantityReceived: (json['quantityReceived'] as num?)?.toInt() ?? 0,
      quantityRemaining: (json['quantityRemaining'] as num?)?.toInt() ?? 0,
      receivedDate: json['receivedDate'] as Timestamp? ?? Timestamp.now(),
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0.0,
      updatedAt: json['updatedAt'] as Timestamp? ?? Timestamp.now(),
      adjustmentId: json['adjustmentId'] as String?,
      adjustmentType: json['adjustmentType'] as String?,
      reason: json['reason'] as String?,
      isManualAdjustment: json['isManualAdjustment'] as bool? ?? false,
    );
  }

  // Create a copy of the model with updated fields
  MmInventoryBatchesModel copyWith({
    String? batchReference,
    Timestamp? createdAt,
    String? grnId,
    bool? isActive,
    String? poId,
    String? productId,
    String? purchaseId,
    int? quantityReceived,
    int? quantityRemaining,
    Timestamp? receivedDate,
    double? totalValue,
    double? unitCost,
    Timestamp? updatedAt,
    String? adjustmentId,
    String? adjustmentType,
    String? reason,
    bool? isManualAdjustment,
  }) {
    return MmInventoryBatchesModel(
      id: id,
      batchReference: batchReference ?? this.batchReference,
      createdAt: createdAt ?? this.createdAt,
      grnId: grnId ?? this.grnId,
      isActive: isActive ?? this.isActive,
      poId: poId ?? this.poId,
      productId: productId ?? this.productId,
      purchaseId: purchaseId ?? this.purchaseId,
      quantityReceived: quantityReceived ?? this.quantityReceived,
      quantityRemaining: quantityRemaining ?? this.quantityRemaining,
      receivedDate: receivedDate ?? this.receivedDate,
      totalValue: totalValue ?? this.totalValue,
      unitCost: unitCost ?? this.unitCost,
      updatedAt: updatedAt ?? this.updatedAt,
      adjustmentId: adjustmentId ?? this.adjustmentId,
      adjustmentType: adjustmentType ?? this.adjustmentType,
      reason: reason ?? this.reason,
      isManualAdjustment: isManualAdjustment ?? this.isManualAdjustment,
    );
  }

  // Helper methods
  double get remainingValue => quantityRemaining * unitCost;

  bool get isFullyConsumed => quantityRemaining == 0;

  bool get isPartiallyConsumed =>
      quantityRemaining > 0 && quantityRemaining < quantityReceived;

  int get consumedQuantity => quantityReceived - quantityRemaining;

  double get consumedValue => consumedQuantity * unitCost;

  // Enhanced status method to handle manual adjustments
  String get status {
    if (isManualAdjustment == true) {
      if (quantityRemaining == 0) return 'Fully Consumed (Manual)';
      if (quantityRemaining < quantityReceived)
        return 'Partially Consumed (Manual)';
      return 'Fully Available (Manual)';
    }

    if (quantityRemaining == 0) return 'Fully Consumed';
    if (quantityRemaining < quantityReceived) return 'Partially Consumed';
    return 'Fully Available';
  }

  String get sourceType =>
      isManualAdjustment == true ? 'Manual Adjustment' : 'GRN';

  @override
  String toString() {
    return 'MmInventoryBatchesModel{'
        'id: $id, '
        'batchReference: $batchReference, '
        'createdAt: $createdAt, '
        'grnId: $grnId, '
        'isActive: $isActive, '
        'poId: $poId, '
        'productId: $productId, '
        'purchaseId: $purchaseId, '
        'quantityReceived: $quantityReceived, '
        'quantityRemaining: $quantityRemaining, '
        'receivedDate: $receivedDate, '
        'totalValue: $totalValue, '
        'unitCost: $unitCost, '
        'updatedAt: $updatedAt, '
        'adjustmentId: $adjustmentId, '
        'adjustmentType: $adjustmentType, '
        'reason: $reason, '
        'isManualAdjustment: $isManualAdjustment'
        '}';
  }

  // Equality check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MmInventoryBatchesModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          batchReference == other.batchReference &&
          grnId == other.grnId;

  @override
  int get hashCode => id.hashCode ^ batchReference.hashCode ^ grnId.hashCode;
}

// Extension with formatting methods
extension MmInventoryBatchesExtension on MmInventoryBatchesModel {
  String get formattedUnitCost => 'OMR ${unitCost.toStringAsFixed(2)}';

  String get formattedTotalValue => 'OMR ${totalValue.toStringAsFixed(2)}';

  String get formattedRemainingValue =>
      'OMR ${remainingValue.toStringAsFixed(2)}';

  String get formattedReceivedDate =>
      receivedDate.toDate().formattedWithDayMonthYear;

  String get formattedCreatedAt => createdAt.toDate().formattedWithDayMonthYear;

  String get shortGrnId => grnId.isNotEmpty
      ? grnId.substring(0, grnId.length > 8 ? 8 : grnId.length)
      : 'N/A';

  String get shortPoId => poId.isNotEmpty
      ? poId.substring(0, poId.length > 8 ? 8 : poId.length)
      : 'N/A';

  String get shortAdjustmentId => adjustmentId?.isNotEmpty == true
      ? adjustmentId!.substring(
          0,
          adjustmentId!.length > 8 ? 8 : adjustmentId!.length,
        )
      : 'N/A';
}
