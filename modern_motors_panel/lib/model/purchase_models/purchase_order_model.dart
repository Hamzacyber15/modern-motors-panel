import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseOrderModel {
  String? id;
  String? vendorId;
  String? vendorName;
  double? shipping;
  double? discount;
  String? status;
  double? orderTax;
  double? taxAmount;
  double? subTotal;
  String? referenceNo;
  String? createdBy;
  int? quantity;
  String? productId;
  String? productName;
  String? subCatId;
  String? subCatName;
  String? branchId;
  double? perItem;
  double? totalCost;
  String? requisitionId;
  String? quotationId;
  String? purchaseId;
  String? poNumber;
  String? requisitionNumber;
  String? productCategoryId;

  PurchaseOrderModel({
    this.id,
    this.discount,
    this.shipping,
    this.vendorId,
    this.vendorName,
    this.status = 'pending',
    this.orderTax,
    this.taxAmount,
    this.subTotal,
    this.referenceNo,
    this.createdBy,
    this.quantity,
    this.productId,
    this.productName,
    this.subCatId,
    this.subCatName,
    this.branchId,
    this.perItem,
    this.totalCost,
    this.requisitionId,
    this.quotationId,
    this.purchaseId,
    this.poNumber,
    this.requisitionNumber,
    this.productCategoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'vendorName': vendorName,
      'discount': discount,
      'shipping': shipping,
      'status': status,
      'referenceNo': referenceNo,
      'orderTax': orderTax,
      'taxAmount': taxAmount,
      'subTotal': subTotal,
      'productId': productId,
      'productName': productName,
      'subCatId': subCatId,
      'subCatName': subCatName,
      'createdBy': createdBy,
      'quantity': quantity,
      'branchId': branchId,
      'perItem': perItem,
      'totalCost': totalCost,
      'timestamp': FieldValue.serverTimestamp(),
      'requisitionId': requisitionId,
      'quotationId': quotationId,
      'purchaseId': purchaseId,
      'poNumber': poNumber,
      'requisitionNumber': requisitionNumber,
      'productCategoryId': productCategoryId,
    };
  }

  factory PurchaseOrderModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return PurchaseOrderModel(
      id: doc.id,
      vendorId: map['vendorId']?.toString(),
      vendorName: map['vendorName']?.toString(),
      shipping: _parseDouble(map['shipping']),
      discount: _parseDouble(map['discount']),
      orderTax: _parseDouble(map['orderTax']),
      taxAmount: _parseDouble(map['taxAmount']),
      subTotal: _parseDouble(map['subTotal']),
      referenceNo: map['referenceNo']?.toString(),
      status: map['status']?.toString() ?? 'Pending',
      productId: map['productId']?.toString(),
      productName: map['productName']?.toString(),
      createdBy: map['createdBy']?.toString(),
      quantity: _parseInt(map['quantity']),
      perItem: _parseDouble(map['perItem']),
      totalCost: _parseDouble(map['totalCost']),
      subCatId: map['subCatId']?.toString(),
      subCatName: map['subCatName']?.toString(),
      branchId: map['branchId']?.toString(),
      requisitionId: map['requisitionId']?.toString(),
      purchaseId: map['purchaseId']?.toString(),
      poNumber: map['poNumber']?.toString(),
      requisitionNumber: map['requisitionNumber']?.toString(),
      productCategoryId: map['productCategoryId']?.toString(),
    );
  }
}

// Helper to safely parse int from string or number
int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

double? _parseDouble(dynamic value) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value);
  return null;
}
