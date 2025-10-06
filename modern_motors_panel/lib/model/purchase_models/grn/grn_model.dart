import 'package:cloud_firestore/cloud_firestore.dart';

class GrnModel {
  String id;
  String purchaseId;
  String requisitionId;
  String poId; // Reference to the Purchase Order
  String productId;
  String productSubId;
  String productCode;
  double orderedQuantity; // From PO
  double receivedQuantity; // Actual received (can be different)
  double rejectedQuantity; // Damaged/Rejected items
  Timestamp timestamp;
  String receivedBy; // Who physically received the goods
  String createdBy; // Who created the GRN in system
  String status; // received, partial, completed, etc.
  String? notes;
  String grnNumber;
  String vendorId;
  String poNumber;
  String requisitionNumber;
  String productCategoryId;

  GrnModel({
    required this.id,
    required this.purchaseId,
    required this.requisitionId,
    required this.poId,
    required this.productId,
    required this.productSubId,
    required this.productCode,
    required this.orderedQuantity,
    required this.receivedQuantity,
    this.rejectedQuantity = 0,
    required this.timestamp,
    required this.receivedBy,
    required this.createdBy,
    required this.status,
    this.notes,
    required this.grnNumber,
    required this.vendorId,
    required this.poNumber,
    required this.requisitionNumber,
    required this.productCategoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'poId': poId,
      'productId': productId,
      'productCode': productCode,
      'orderedQuantity': orderedQuantity,
      'receivedQuantity': receivedQuantity,
      'rejectedQuantity': rejectedQuantity,
      'timestamp': timestamp,
      'receivedBy': receivedBy,
      'createdBy': createdBy,
      'status': status,
      "notes": notes,
      'grnNumber': grnNumber,
      'purchaseId': purchaseId,
      'requisitionId': requisitionId,
      'vendorId': vendorId,
      'poNumber': poNumber,
      'requisitionNumber': requisitionNumber,
      'productSubId': productSubId,
      'productCategoryId': productCategoryId,
    };
  }

  factory GrnModel.fromDoc(DocumentSnapshot doc) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;
    }

    final map = doc.data() as Map<String, dynamic>? ?? {};
    return GrnModel(
      id: doc.id,
      purchaseId: map['purchaseId'] ?? "",
      requisitionId: map['requisitions'] ?? "",
      poId: map['poId'] ?? '',
      productId: map['productId'] ?? '',
      productCode: map['productCode'] ?? '',
      orderedQuantity: parseDouble(map['orderedQuantity']),
      receivedQuantity: parseDouble(map['receivedQuantity'] ?? 0).toDouble(),
      rejectedQuantity: parseDouble(map['rejectedQuantity'] ?? 0).toDouble(),
      timestamp: map['timestamp'] ?? Timestamp.now(),
      receivedBy: map['receivedBy'] ?? '',
      createdBy: map['createdBy'] ?? '',
      status: map['status'] ?? 'received',
      notes: map['notes'] ?? "",
      vendorId: map['vendorId'] ?? "",
      grnNumber: map['grnNumber'] ?? "",
      poNumber: map['poNumber'] ?? "",
      requisitionNumber: map['requisitionNumber'] ?? "",
      productSubId: map['productSubId'] ?? "",
      productCategoryId: map['productCategoryId'] ?? "",
    );
  }
}
