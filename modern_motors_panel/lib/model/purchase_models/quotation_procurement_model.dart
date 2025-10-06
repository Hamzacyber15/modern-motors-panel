import 'package:cloud_firestore/cloud_firestore.dart';

class QuotationProcurementModel {
  String id;
  String userId;
  List<Quotation> quotationList;
  String requisitionIds;
  String purchaseId;
  Timestamp? timestamp;
  String productCategoryId;
  String productSubcategoryId;
  String status;
  String requisitionSerial;
  String productId;

  QuotationProcurementModel({
    required this.id,
    required this.quotationList,
    required this.timestamp,
    required this.userId,
    required this.requisitionIds,
    required this.purchaseId,
    required this.productCategoryId,
    required this.productSubcategoryId,
    required this.status,
    required this.requisitionSerial,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'quotationList': quotationList.map((m) => m.toMap()).toList() ?? [],
      'requisitionIds': requisitionIds,
      'timestamp': timestamp ?? Timestamp.now(),
      'purchaseId': purchaseId,
      'productSubcategoryId': productSubcategoryId,
      'productCategoryId': productCategoryId,
      'status': status,
      'requisitionSerial': requisitionSerial,
      'productId': productId,
    };
  }

  factory QuotationProcurementModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return QuotationProcurementModel(
      id: doc.id,
      userId: map['userId'] ?? '',
      requisitionIds: map['requisitionIds'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      quotationList: (map['quotationList'] as List<dynamic>?)!
          .map((m) => Quotation.fromMap(m as Map<String, dynamic>))
          .toList(),
      purchaseId: map['purchaseId'] ?? "",
      productCategoryId: map['productCategoryId'],
      productSubcategoryId: map['productSubcategoryId'],
      status: map['status'],
      productId: map['productId'],
      requisitionSerial: map['requisitionSerial'] ?? "",
    );
  }
}

class Quotation {
  final String? imageURL;
  String? vendorId;
  String? vendorName;
  int? quantity;
  double? perItem;
  double? totalPrice;
  String? status;
  double? discount;
  String? productCategoryId;
  String? productSubcategoryId;

  Quotation({
    required this.imageURL,
    this.vendorId,
    this.vendorName,
    this.quantity,
    this.perItem,
    this.totalPrice,
    this.status,
    this.discount,
    this.productSubcategoryId,
    this.productCategoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageURL': imageURL,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'quantity': quantity,
      'perItem': perItem,
      'totalPrice': totalPrice,
      'status': status,
      'discount': discount,
      'productCategoryId': productCategoryId,
      'productSubcategoryId': productSubcategoryId,
    };
  }

  factory Quotation.fromMap(Map<String, dynamic> map) {
    return Quotation(
      imageURL: map['imageURL'] ?? '',
      vendorId: map['vendorId'] ?? '',
      vendorName: map['vendorName'] ?? '',
      quantity: map['quantity'] is int
          ? map['quantity']
          : int.tryParse(map['quantity'].toString()),
      perItem: map['perItem'] is int
          ? map['perItem']
          : int.tryParse(map['perItem'].toString()),
      totalPrice: map['totalPrice'] is int
          ? map['totalPrice']
          : int.tryParse(map['totalPrice'].toString()),
      status: map['status'] ?? '',
      productCategoryId: map['productCategoryId'],
      discount: map['discount'],
      productSubcategoryId: map['productSubcategoryId'],
    );
  }
}
