import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceMmModel {
  String? id;
  String? invoiceNumber;
  List<ItemsModel>? items;
  String? customerId;
  String? salesPersonId;
  Timestamp? invoiceDate;
  Timestamp? issueDate;
  Timestamp? paymentDate;
  Timestamp? createdAt;
  int? paymentTermsInDays;
  double? subtotal;
  double? itemsTotal;
  double? total;
  double? discountPercent = 0;
  double? discountedAmount = 0;
  String? discountId;
  double? taxPercent = 0;
  double? taxAmount = 0;
  bool? isTaxApplied = false;
  bool? isDiscountApplied = false;
  String? status;

  InvoiceMmModel({
    this.id,
    this.invoiceNumber,
    this.customerId,
    this.items,
    this.invoiceDate,
    this.issueDate,
    this.paymentDate,
    this.paymentTermsInDays,
    this.salesPersonId,
    this.itemsTotal,
    this.total,
    this.discountPercent,
    this.discountedAmount,
    this.isTaxApplied,
    this.subtotal,
    this.taxAmount,
    this.discountId,
    this.taxPercent,
    this.isDiscountApplied,
    this.status,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'customerId': customerId,
      'salesPersonId': salesPersonId,
      'invoiceDate': invoiceDate,
      'issueDate': issueDate,
      'paymentDate': paymentDate,
      'paymentTermsInDays': paymentTermsInDays,
      'subtotal': subtotal,
      'total': total,
      'discountPercent': discountPercent,
      'discountedAmount': discountedAmount,
      'taxPercent': taxPercent,
      'taxAmount': taxAmount,
      'isTaxApplied': isTaxApplied,
      'discountId': discountId,
      'isDiscountApplied': isDiscountApplied,
      'itemsTotal': itemsTotal,
      'status': status,
      'items': items?.map((item) => item.toMap()).toList(),
    };
  }

  factory InvoiceMmModel.from(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return InvoiceMmModel(
      id: doc.id,
      items: (data['items'] as List<dynamic>?)
          ?.map((e) => ItemsModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      customerId: data['customerId'] ?? '',
      discountId: data['discountId'] ?? '',
      salesPersonId: data['salesPersonId'] ?? '',
      issueDate: data['issueDate'] != null
          ? (data['issueDate'] as Timestamp)
          : null,
      invoiceDate: data['invoiceDate'] != null
          ? (data['invoiceDate'] as Timestamp)
          : null,
      paymentDate: data['paymentDate'] != null
          ? (data['paymentDate'] as Timestamp)
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp)
          : null,
      taxPercent: data['taxPercent'] ?? 0.0,
      itemsTotal: data['itemsTotal'] ?? 0.0,
      invoiceNumber: data['invoiceNumber'] ?? '',
      status: data['status'] ?? '',
      isTaxApplied: data['isTaxApplied'] ?? false,
      isDiscountApplied: data['isDiscountApplied'] ?? false,
      paymentTermsInDays: data['paymentTermsInDays'] ?? 0,
      subtotal: data['subtotal'] ?? 0.0,
      total: data['total'] ?? 0.0,
      discountedAmount: (data['discountedAmount'] ?? 0).toDouble(),
      taxAmount: data['taxAmount'] ?? 0.0,
      discountPercent: data['discountPercent'] ?? 0,
    );
  }
}

class ItemsModel {
  String productId;
  int quantity;
  double perItemPrice;
  double totalPrice;

  ItemsModel({
    required this.productId,
    required this.quantity,
    required this.perItemPrice,
    required this.totalPrice,
  });

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
      productId: map['productId'] ?? '',
      perItemPrice: map['perItemPrice'] ?? 0.0,
      quantity: map['quantity'] ?? 0,
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'perItemPrice': perItemPrice,
      'totalPrice': totalPrice,
    };
  }

  factory ItemsModel.clone(ItemsModel item) {
    return ItemsModel(
      productId: item.productId,
      quantity: item.quantity,
      perItemPrice: item.perItemPrice,
      totalPrice: item.totalPrice,
    );
  }
}
