// import 'package:cloud_firestore/cloud_firestore.dart';

// class PurchaseRequisitionModel {
//   final String? id;
//   final String? createdBy;
//   final String? subCategory;
//   final String? category;
//   final String? brand;
//   final int? quantity;
//   final String? productId;
//   final String? note;
//   final String? status;
//   final String? prioirty;
//   final String? subCatId;
//   final String? brandId;
//   final String? branchId;

//   PurchaseRequisitionModel({
//     this.id,
//     this.createdBy,
//     this.subCategory,
//     this.category,
//     this.brand,
//     this.quantity,
//     this.note,
//     this.productId,
//     this.status = 'pending',
//     this.prioirty,
//     this.brandId,
//     this.subCatId,
//     this.branchId,
//   });

//   factory PurchaseRequisitionModel.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>? ?? {};

//     return PurchaseRequisitionModel(
//       id: doc.id,
//       productId: data['productId'],
//       subCategory: data['subCategory'] ?? '',
//       createdBy: data['createdBy']?.toString(),
//       prioirty: data['prioirty'] ?? '',
//       category: data['category']?.toString(),
//       brand: data['brand']?.toString(),
//       quantity: data['quantity'] is int
//           ? data['quantity']
//           : int.tryParse(data['quantity'].toString()),
//       note: data['note']?.toString(),
//       status: data['status'] ?? 'Pending',
//       subCatId: data['subCatId']?.toString(),
//       brandId: data['brandId']?.toString(),
//       branchId: data['branchId']?.toString(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'productId': productId,
//       'subCategory': subCategory,
//       'createdBy': createdBy,
//       'category': category,
//       'prioirty': prioirty,
//       'brand': brand,
//       'quantity': quantity,
//       'note': note,
//       'status': status,
//       'subCatId': subCatId,
//       'brandId': brandId,
//       'branchId': branchId,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseRequisitionModel {
  final String? requisitionId; // requisition doc id
  final String? purchaseId; // parent purchase doc id
  final String? createdBy;
  final String? subCategory;
  final String? category;
  final String? brand;
  final int? quantity;
  final String? productId;
  final String? note;
  final String? status;
  final String? prioirty;
  final String? subCatId;
  final String? brandId;
  final String? branchId;
  final Timestamp? timestamp;
  final String? serialNumber;

  PurchaseRequisitionModel({
    this.requisitionId,
    this.purchaseId,
    this.createdBy,
    this.subCategory,
    this.category,
    this.brand,
    this.quantity,
    this.note,
    this.productId,
    this.status = 'pending',
    this.prioirty,
    this.brandId,
    this.subCatId,
    this.branchId,
    this.timestamp,
    this.serialNumber,
  });

  factory PurchaseRequisitionModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    String? purchaseId;
    if (doc.reference.parent.parent != null) {
      purchaseId = doc.reference.parent.parent!.id;
    }

    return PurchaseRequisitionModel(
      requisitionId: doc.id,
      purchaseId: purchaseId,
      productId: data['productId'],
      subCategory: data['subCategory'] ?? '',
      createdBy: data['createdBy']?.toString(),
      prioirty: data['prioirty'] ?? '',
      category: data['category']?.toString(),
      brand: data['brand']?.toString(),
      quantity: data['quantity'] is int
          ? data['quantity']
          : int.tryParse(data['quantity'].toString()),
      note: data['note']?.toString(),
      status: data['status'] ?? 'Pending',
      subCatId: data['subCatId']?.toString(),
      brandId: data['brandId']?.toString(),
      branchId: data['branchId']?.toString(),
      timestamp: data['timestamp'],
      serialNumber: data['serialNumber']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'subCategory': subCategory,
      'createdBy': createdBy,
      'category': category,
      'prioirty': prioirty,
      'brand': brand,
      'quantity': quantity,
      'note': note,
      'status': status,
      'subCatId': subCatId,
      'brandId': brandId,
      'branchId': branchId,
      'timestamp': timestamp,
      'serialNumber': serialNumber,
    };
  }
}
