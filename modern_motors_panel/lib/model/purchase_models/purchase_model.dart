import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  String? id;
  String? product;
  String? brand;
  String? brandId;
  String? urgency;
  double? targetPrice;
  int? quantity;
  String? orderStatus;
  DateTime? timestamp;

  PurchaseModel({
    this.id,
    this.quantity,
    this.urgency,
    this.product,
    this.brand,
    this.brandId,
    this.targetPrice,
    this.orderStatus,
    this.timestamp,
  });

  factory PurchaseModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return PurchaseModel(
      id: doc.id,
      quantity: map['quantity'] ?? 0,
      urgency: map['urgency'] ?? '',
      product: map['product'] ?? '',
      brand: map['brand'] ?? '',
      brandId: map['brandId'] ?? '',
      targetPrice: (map['targetPrice'] ?? 0).toDouble(),
      orderStatus: map['orderStatus'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'urgency': urgency,
      'product': product,
      'brand': brand,
      'brandId': brandId,
      'targetPrice': targetPrice,
      'orderStatus': orderStatus,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
    };
  }
}
