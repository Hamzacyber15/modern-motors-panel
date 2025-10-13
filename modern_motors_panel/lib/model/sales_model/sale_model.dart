// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class SaleModel {
// //   final String id;
// //   final String customerName;
// //   final String paymentMethod;
// //   final DateTime createdAt;
// //   final DateTime processedAt;
// //   final List<BatchAllocation> batchAllocations;
// //   final List<BatchUsed> batchesUsed;
// //   final List<SaleItem> items;
// //   final List<ProductUpdated> productsUpdated;
// //   final double profit;
// //   final int quantity;
// //   final String saleId;
// //   final double sellingPrice;
// //   final String status;
// //   final double totalCost;
// //   final int totalQuantityProcessed;
// //   final double totalRevenue;
// //   final DateTime updatedAt;
// //   final String createdBy;
// //   final String invoice;
// //   final String createBy;
// //   final double taxAmount;
// //   final String? truckId;
// //   SaleModel({
// //     required this.id,
// //     required this.customerName,
// //     required this.paymentMethod,
// //     required this.createdAt,
// //     required this.processedAt,
// //     required this.batchAllocations,
// //     required this.batchesUsed,
// //     required this.items,
// //     required this.productsUpdated,
// //     required this.profit,
// //     required this.quantity,
// //     required this.saleId,
// //     required this.sellingPrice,
// //     required this.status,
// //     required this.totalCost,
// //     required this.totalQuantityProcessed,
// //     required this.totalRevenue,
// //     required this.updatedAt,
// //     required this.createdBy,
// //     //     final String invoice;
// //     // final String createBy;
// //     // final double taxAmount;
// //     // final double totalCost;
// //     // final double totalRevenue;
// //     // final String? truckId;
// //     required this.invoice,
// //     required this.createBy,
// //     required this.taxAmount,
// //     this.truckId,
// //   });

// //   factory SaleModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
// //     final data = doc.data() ?? {};

// //     return SaleModel(
// //         id: doc.id,
// //         customerName: data['customerName'] ?? '',
// //         paymentMethod: data['paymentMethod'] ?? '',
// //         createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
// //             DateTime
// //                 .now(), //(data['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
// //         processedAt:
// //             (data['processedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
// //         batchAllocations: (data['batchAllocations'] as List<dynamic>? ?? [])
// //             .map((x) => BatchAllocation.fromMap(x as Map<String, dynamic>))
// //             .toList(),
// //         batchesUsed: (data['batchesUsed'] as List<dynamic>? ?? [])
// //             .map((x) => BatchUsed.fromMap(x as Map<String, dynamic>))
// //             .toList(),
// //         items: (data['items'] as List<dynamic>? ?? [])
// //             .map((x) => SaleItem.fromMap(x as Map<String, dynamic>))
// //             .toList(),
// //         productsUpdated: (data['productsUpdated'] as List<dynamic>? ?? [])
// //             .map((x) => ProductUpdated.fromMap(x as Map<String, dynamic>))
// //             .toList(),
// //         profit: (data['profit'] ?? 0).toDouble(),
// //         quantity: data['quantity'] ?? 0,
// //         saleId: data['saleId'] ?? '',
// //         sellingPrice: (data['sellingPrice'] ?? 0).toDouble(),
// //         status: data['status'] ?? '',
// //         totalCost: (data['totalCost'] ?? 0).toDouble(),
// //         totalQuantityProcessed: data['totalQuantityProcessed'] ?? 0,
// //         totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
// //         taxAmount: (data['taxAmount'] ?? 0).toDouble(),
// //         updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ??
// //             DateTime.now(), //(data['updatedAt'] as Timestamp).toDate() ?? ,
// //         createdBy: data['createdBy'] ?? "",
// //         invoice: data['invoice'] ?? "",
// //         createBy: data['createBy'] ?? "",
// //         truckId: data['truckId'] ?? "");
// //   }
// // }

// // class BatchAllocation {
// //   final String batchId;
// //   final int batchQuantityRemaining;
// //   final String batchReference;
// //   final int quantity;
// //   final double totalCost;
// //   final double unitCost;

// //   BatchAllocation({
// //     required this.batchId,
// //     required this.batchQuantityRemaining,
// //     required this.batchReference,
// //     required this.quantity,
// //     required this.totalCost,
// //     required this.unitCost,
// //   });

// //   factory BatchAllocation.fromMap(Map<String, dynamic> map) {
// //     return BatchAllocation(
// //       batchId: map['batchId'] ?? '',
// //       batchQuantityRemaining: map['batchQuantityRemaining'] ?? 0,
// //       batchReference: map['batchReference'] ?? '',
// //       quantity: map['quantity'] ?? 0,
// //       totalCost: (map['totalCost'] ?? 0).toDouble(),
// //       unitCost: (map['unitCost'] ?? 0).toDouble(),
// //     );
// //   }
// // }

// // class BatchUsed {
// //   final String batchId;
// //   final String productId;
// //   final int quantityUsed;
// //   final int remainingAfterSale;

// //   BatchUsed({
// //     required this.batchId,
// //     required this.productId,
// //     required this.quantityUsed,
// //     required this.remainingAfterSale,
// //   });

// //   factory BatchUsed.fromMap(Map<String, dynamic> map) {
// //     return BatchUsed(
// //       batchId: map['batchId'] ?? '',
// //       productId: map['productId'] ?? '',
// //       quantityUsed: map['quantityUsed'] ?? 0,
// //       remainingAfterSale: map['remainingAfterSale'] ?? 0,
// //     );
// //   }
// // }

// // class SaleItem {
// //   final double discount;
// //   final double margin;
// //   final String productId;
// //   final String productName;
// //   final int quantity;
// //   final double sellingPrice;
// //   final double totalPrice;
// //   final double unitPrice;

// //   SaleItem({
// //     required this.discount,
// //     required this.margin,
// //     required this.productId,
// //     required this.productName,
// //     required this.quantity,
// //     required this.sellingPrice,
// //     required this.totalPrice,
// //     required this.unitPrice,
// //   });

// //   factory SaleItem.fromMap(Map<String, dynamic> map) {
// //     return SaleItem(
// //       discount:  (map['discount'] ?? 0).toDouble(),
// //       margin: (map['margin'] ?? 0).toDouble(),
// //       productId: map['productId'] ?? '',
// //       productName: map['productName'] ?? '',
// //       quantity: map['quantity'] ?? 0,
// //       sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
// //       totalPrice: (map['totalPrice'] ?? 0).toDouble(),
// //       unitPrice: (map['unitPrice'] ?? 0).toDouble(),
// //     );
// //   }
// // }

// // class ProductUpdated {
// //   final String productId;
// //   final int quantityDeducted;
// //   final int stockAfter;
// //   final int stockBefore;

// //   ProductUpdated({
// //     required this.productId,
// //     required this.quantityDeducted,
// //     required this.stockAfter,
// //     required this.stockBefore,
// //   });

// //   factory ProductUpdated.fromMap(Map<String, dynamic> map) {
// //     return ProductUpdated(
// //       productId: map['productId'] ?? '',
// //       quantityDeducted: map['quantityDeducted'] ?? 0,
// //       stockAfter: map['stockAfter'] ?? 0,
// //       stockBefore: map['stockBefore'] ?? 0,
// //     );
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';

// class SaleModel {
//   final String id;
//   final String customerName;
//   final String paymentMethod;
//   final DateTime createdAt;
//   final DateTime processedAt;
//   final List<BatchAllocation> batchAllocations;
//   final List<BatchUsed> batchesUsed;
//   final List<SaleItem> items;
//   final List<ServiceItem> serviceItems; // Missing from original model
//   final List<ProductUpdated> productsUpdated;
//   final double profit;
//   final int quantity;
//   final String saleId;
//   final double sellingPrice;
//   final String status;
//   final double totalCost;
//   final int totalQuantityProcessed;
//   final double totalRevenue;
//   final DateTime updatedAt;
//   final String createdBy;
//   final String invoice;
//   final String createBy;
//   final double taxAmount;
//   final String? truckId;
//   final int previousStock; // Missing from original model
//   final String productId; // Missing from original model
//   final String productName; // Missing from original model

//   SaleModel({
//     required this.id,
//     required this.customerName,
//     required this.paymentMethod,
//     required this.createdAt,
//     required this.processedAt,
//     required this.batchAllocations,
//     required this.batchesUsed,
//     required this.items,
//     required this.serviceItems,
//     required this.productsUpdated,
//     required this.profit,
//     required this.quantity,
//     required this.saleId,
//     required this.sellingPrice,
//     required this.status,
//     required this.totalCost,
//     required this.totalQuantityProcessed,
//     required this.totalRevenue,
//     required this.updatedAt,
//     required this.createdBy,
//     required this.invoice,
//     required this.createBy,
//     required this.taxAmount,
//     this.truckId,
//     required this.previousStock,
//     required this.productId,
//     required this.productName,
//   });

//   factory SaleModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data() ?? {};

//     return SaleModel(
//       id: doc.id,
//       customerName: data['customerName'] ?? '',
//       paymentMethod: data['paymentMethod'] ?? '',
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       processedAt:
//           (data['processedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       batchAllocations: (data['batchAllocations'] as List<dynamic>? ?? [])
//           .map((x) => BatchAllocation.fromMap(x as Map<String, dynamic>))
//           .toList(),
//       batchesUsed: (data['batchesUsed'] as List<dynamic>? ?? [])
//           .map((x) => BatchUsed.fromMap(x as Map<String, dynamic>))
//           .toList(),
//       items: (data['items'] as List<dynamic>? ?? [])
//           .map((x) => SaleItem.fromMap(x as Map<String, dynamic>))
//           .toList(),
//       serviceItems: (data['serviceItems'] as List<dynamic>? ?? [])
//           .map((x) => ServiceItem.fromMap(x as Map<String, dynamic>))
//           .toList(),
//       productsUpdated: (data['productsUpdated'] as List<dynamic>? ?? [])
//           .map((x) => ProductUpdated.fromMap(x as Map<String, dynamic>))
//           .toList(),
//       profit: (data['profit'] ?? 0).toDouble(),
//       quantity: data['quantity'] ?? 0,
//       saleId: data['saleId'] ?? '',
//       sellingPrice: (data['sellingPrice'] ?? 0).toDouble(),
//       status: data['status'] ?? '',
//       totalCost: (data['totalCost'] ?? 0).toDouble(),
//       totalQuantityProcessed: data['totalQuantityProcessed'] ?? 0,
//       totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
//       taxAmount: (data['taxAmount'] ?? 0).toDouble(),
//       updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       createdBy: data['createdBy'] ?? "",
//       invoice: data['invoice'] ?? "",
//       createBy: data['createBy'] ?? "",
//       truckId: data['truckId'],
//       previousStock: data['previousStock'] ?? 0,
//       productId: data['productId'] ?? "",
//       productName: data['productName'] ?? "",
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'customerName': customerName,
//       'paymentMethod': paymentMethod,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'processedAt': Timestamp.fromDate(processedAt),
//       'batchAllocations': batchAllocations.map((x) => x.toMap()).toList(),
//       'batchesUsed': batchesUsed.map((x) => x.toMap()).toList(),
//       'items': items.map((x) => x.toMap()).toList(),
//       'serviceItems': serviceItems.map((x) => x.toMap()).toList(),
//       'productsUpdated': productsUpdated.map((x) => x.toMap()).toList(),
//       'profit': profit,
//       'quantity': quantity,
//       'saleId': saleId,
//       'sellingPrice': sellingPrice,
//       'status': status,
//       'totalCost': totalCost,
//       'totalQuantityProcessed': totalQuantityProcessed,
//       'totalRevenue': totalRevenue,
//       'updatedAt': Timestamp.fromDate(updatedAt),
//       'createdBy': createdBy,
//       'invoice': invoice,
//       'createBy': createBy,
//       'taxAmount': taxAmount,
//       'truckId': truckId,
//       'previousStock': previousStock,
//       'productId': productId,
//       'productName': productName,
//     };
//   }
// }

// class BatchAllocation {
//   final String batchId;
//   final int batchQuantityRemaining;
//   final String batchReference;
//   final int quantity;
//   final double totalCost;
//   final double unitCost;

//   BatchAllocation({
//     required this.batchId,
//     required this.batchQuantityRemaining,
//     required this.batchReference,
//     required this.quantity,
//     required this.totalCost,
//     required this.unitCost,
//   });

//   factory BatchAllocation.fromMap(Map<String, dynamic> map) {
//     return BatchAllocation(
//       batchId: map['batchId'] ?? '',
//       batchQuantityRemaining: map['batchQuantityRemaining'] ?? 0,
//       batchReference: map['batchReference'] ?? '',
//       quantity: map['quantity'] ?? 0,
//       totalCost: (map['totalCost'] ?? 0).toDouble(),
//       unitCost: (map['unitCost'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'batchId': batchId,
//       'batchQuantityRemaining': batchQuantityRemaining,
//       'batchReference': batchReference,
//       'quantity': quantity,
//       'totalCost': totalCost,
//       'unitCost': unitCost,
//     };
//   }
// }

// class BatchUsed {
//   final String batchId;
//   final String productId;
//   final int quantityUsed;
//   final int remainingAfterSale;

//   BatchUsed({
//     required this.batchId,
//     required this.productId,
//     required this.quantityUsed,
//     required this.remainingAfterSale,
//   });

//   factory BatchUsed.fromMap(Map<String, dynamic> map) {
//     return BatchUsed(
//       batchId: map['batchId'] ?? '',
//       productId: map['productId'] ?? '',
//       quantityUsed: map['quantityUsed'] ?? 0,
//       remainingAfterSale: map['remainingAfterSale'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'batchId': batchId,
//       'productId': productId,
//       'quantityUsed': quantityUsed,
//       'remainingAfterSale': remainingAfterSale,
//     };
//   }
// }

// class SaleItem {
//   final double discount;
//   final double margin;
//   final String productId;
//   final String productName;
//   final int quantity;
//   final double sellingPrice;
//   final double totalPrice;
//   final double unitPrice;
//   final String type;
//   final double cost;

//   SaleItem({
//     required this.discount,
//     required this.margin,
//     required this.productId,
//     required this.productName,
//     required this.quantity,
//     required this.sellingPrice,
//     required this.totalPrice,
//     required this.unitPrice,
//     required this.type,
//     required this.cost,
//   });

//   factory SaleItem.fromMap(Map<String, dynamic> map) {
//     return SaleItem(
//       discount: (map['discount'] ?? 0).toDouble(),
//       margin: (map['margin'] ?? 0).toDouble(),
//       productId: map['productId'] ?? '',
//       productName: map['productName'] ?? '',
//       quantity: map['quantity'] ?? 0,
//       sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
//       totalPrice: (map['totalPrice'] ?? 0).toDouble(),
//       unitPrice: (map['unitPrice'] ?? 0).toDouble(),
//       type: map['type'] ?? '',
//       cost: (map['cost'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'discount': discount,
//       'margin': margin,
//       'productId': productId,
//       'productName': productName,
//       'quantity': quantity,
//       'sellingPrice': sellingPrice,
//       'totalPrice': totalPrice,
//       'unitPrice': unitPrice,
//     };
//   }
// }

// class ServiceItem {
//   final double discount;
//   final String productName;
//   final int quantity;
//   final double sellingPrice;
//   final String serviceId;
//   final double totalPrice;

//   ServiceItem({
//     required this.discount,
//     required this.productName,
//     required this.quantity,
//     required this.sellingPrice,
//     required this.serviceId,
//     required this.totalPrice,
//   });

//   factory ServiceItem.fromMap(Map<String, dynamic> map) {
//     return ServiceItem(
//       discount: (map['discount'] ?? 0).toDouble(),
//       productName: map['productName'] ?? '',
//       quantity: map['quantity'] ?? 0,
//       sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
//       serviceId: map['serviceId'] ?? '',
//       totalPrice: (map['totalPrice'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'discount': discount,
//       'productName': productName,
//       'quantity': quantity,
//       'sellingPrice': sellingPrice,
//       'serviceId': serviceId,
//       'totalPrice': totalPrice,
//     };
//   }
// }

// class ProductUpdated {
//   final String productId;
//   final int quantityDeducted;
//   final int stockAfter;
//   final int stockBefore;

//   ProductUpdated({
//     required this.productId,
//     required this.quantityDeducted,
//     required this.stockAfter,
//     required this.stockBefore,
//   });

//   factory ProductUpdated.fromMap(Map<String, dynamic> map) {
//     return ProductUpdated(
//       productId: map['productId'] ?? '',
//       quantityDeducted: map['quantityDeducted'] ?? 0,
//       stockAfter: map['stockAfter'] ?? 0,
//       stockBefore: map['stockBefore'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'productId': productId,
//       'quantityDeducted': quantityDeducted,
//       'stockAfter': stockAfter,
//       'stockBefore': stockBefore,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/payment_data.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';

class SaleModel {
  final String id;
  final String customerName;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime processedAt;
  final List<BatchAllocation> batchAllocations;
  final List<BatchUsed> batchesUsed;
  final List<SaleItem> items;
  final List<ServiceItem> serviceItems;
  final List<ProductUpdated> productsUpdated;
  final double profit;
  final int quantity;
  final String saleId;
  final double sellingPrice;
  final String status;
  final double totalCost;
  final int totalQuantityProcessed;
  final double totalRevenue;
  final DateTime updatedAt;
  final String createdBy;
  final String invoice;
  final String createBy;
  final double taxAmount;
  final String? truckId;
  final int previousStock;
  final String productId;
  final String productName;

  // NEW FIELDS from your Firebase data
  final Deposit deposit;
  final double discount;
  final String discountType;
  final PaymentData paymentData;
  final double remaining;
  final String? draft;
  final double? total;
  SaleModel({
    required this.id,
    required this.customerName,
    required this.paymentMethod,
    required this.createdAt,
    required this.processedAt,
    required this.batchAllocations,
    required this.batchesUsed,
    required this.items,
    required this.serviceItems,
    required this.productsUpdated,
    required this.profit,
    required this.quantity,
    required this.saleId,
    required this.sellingPrice,
    required this.status,
    required this.totalCost,
    required this.totalQuantityProcessed,
    required this.totalRevenue,
    required this.updatedAt,
    required this.createdBy,
    required this.invoice,
    required this.createBy,
    required this.taxAmount,
    this.truckId,
    required this.previousStock,
    required this.productId,
    required this.productName,
    // New fields
    required this.deposit,
    required this.discount,
    required this.discountType,
    required this.paymentData,
    required this.remaining,
    this.total,
    this.draft,
  });

  factory SaleModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    // Parse deposit data
    final depositData = data['deposit'] as Map<String, dynamic>? ?? {};
    final deposit = Deposit(
      depositAlreadyPaid: depositData['depositAlreadyPaid'] ?? false,
      depositAmount: (depositData['depositAmount'] ?? 0).toDouble(),
      depositPercentage: (depositData['depositPercentage'] ?? 0).toDouble(),
      depositType: depositData['depositType'] ?? 'percentage',
      nextPaymentAmount: (depositData['nextPaymentAmount'] ?? 0).toDouble(),
      requireDeposit: depositData['requireDeposit'] ?? false,
      depositA: (depositData['depositA'] ?? 0).toDouble(),
    );

    // Parse payment data
    final paymentDataMap = data['paymentData'] as Map<String, dynamic>? ?? {};
    final paymentMethods =
        (paymentDataMap['paymentMethods'] as List<dynamic>? ?? [])
            .map((x) => PaymentMethod.fromMap(x as Map<String, dynamic>))
            .toList();

    final paymentData = PaymentData(
      isAlreadyPaid: paymentDataMap['isAlreadyPaid'] ?? false,
      paymentMethods: paymentMethods,
      remainingAmount: (paymentDataMap['remainingAmount'] ?? 0).toDouble(),
      totalPaid: (paymentDataMap['totalPaid'] ?? 0).toDouble(),
    );

    return SaleModel(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      processedAt:
          (data['processedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      batchAllocations: (data['batchAllocations'] as List<dynamic>? ?? [])
          .map((x) => BatchAllocation.fromMap(x as Map<String, dynamic>))
          .toList(),
      batchesUsed: (data['batchesUsed'] as List<dynamic>? ?? [])
          .map((x) => BatchUsed.fromMap(x as Map<String, dynamic>))
          .toList(),
      items: (data['items'] as List<dynamic>? ?? [])
          .map((x) => SaleItem.fromMap(x as Map<String, dynamic>))
          .toList(),
      serviceItems: (data['serviceItems'] as List<dynamic>? ?? [])
          .map((x) => ServiceItem.fromMap(x as Map<String, dynamic>))
          .toList(),
      productsUpdated: (data['productsUpdated'] as List<dynamic>? ?? [])
          .map((x) => ProductUpdated.fromMap(x as Map<String, dynamic>))
          .toList(),
      profit: (data['profit'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      saleId: data['saleId'] ?? '',
      sellingPrice: (data['sellingPrice'] ?? 0).toDouble(),
      status: data['status'] ?? '',
      totalCost: (data['totalCost'] ?? 0).toDouble(),
      totalQuantityProcessed: data['totalQuantityProcessed'] ?? 0,
      totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
      taxAmount: (data['taxAmount'] ?? 0).toDouble(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? "",
      invoice: data['invoice'] ?? "",
      createBy: data['createBy'] ?? "",
      truckId: data['truckId'],
      previousStock: data['previousStock'] ?? 0,
      productId: data['productId'] ?? "",
      productName: data['productName'] ?? "",
      // New fields
      deposit: deposit,
      discount: (data['discount'] ?? 0).toDouble(),
      discountType: data['discountType'] ?? 'percentage',
      paymentData: paymentData,
      total: (data['total'] ?? 0).toDouble(),
      remaining: (data['remaining'] ?? 0).toDouble(),
      draft: (data['draft'] ?? ""),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'processedAt': Timestamp.fromDate(processedAt),
      'batchAllocations': batchAllocations.map((x) => x.toMap()).toList(),
      'batchesUsed': batchesUsed.map((x) => x.toMap()).toList(),
      'items': items.map((x) => x.toMap()).toList(),
      'serviceItems': serviceItems.map((x) => x.toMap()).toList(),
      'productsUpdated': productsUpdated.map((x) => x.toMap()).toList(),
      'profit': profit,
      'quantity': quantity,
      'saleId': saleId,
      'sellingPrice': sellingPrice,
      'status': status,
      'totalCost': totalCost,
      'totalQuantityProcessed': totalQuantityProcessed,
      'totalRevenue': totalRevenue,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'invoice': invoice,
      'createBy': createBy,
      'taxAmount': taxAmount,
      'truckId': truckId,
      'previousStock': previousStock,
      'productId': productId,
      'productName': productName,
      // New fields
      'deposit': deposit.toMap(),
      'discount': discount,
      'discountType': discountType,
      'paymentData': paymentData.toMap(),
      'remaining': remaining,
    };
  }

  factory SaleModel.clone(SaleModel sale) {
    return SaleModel(
      id: sale.id,
      customerName: sale.customerName,
      paymentMethod: sale.paymentMethod,
      createdAt: sale.createdAt,
      processedAt: sale.processedAt,
      batchAllocations: sale.batchAllocations
          .map(
            (x) => BatchAllocation(
              batchId: x.batchId,
              batchQuantityRemaining: x.batchQuantityRemaining,
              batchReference: x.batchReference,
              quantity: x.quantity,
              totalCost: x.totalCost,
              unitCost: x.unitCost,
            ),
          )
          .toList(),
      batchesUsed: sale.batchesUsed
          .map(
            (x) => BatchUsed(
              batchId: x.batchId,
              productId: x.productId,
              quantityUsed: x.quantityUsed,
              remainingAfterSale: x.remainingAfterSale,
            ),
          )
          .toList(),
      items: sale.items
          .map(
            (x) => SaleItem(
              minimumPrice: x.minimumPrice,
              discount: x.discount,
              margin: x.margin,
              productId: x.productId,
              productName: x.productName,
              quantity: x.quantity,
              sellingPrice: x.sellingPrice,
              totalPrice: x.totalPrice,
              unitPrice: x.unitPrice,
              type: x.type,
              cost: x.cost,
            ),
          )
          .toList(),
      serviceItems: sale.serviceItems
          .map(
            (x) => ServiceItem(
              discount: x.discount,
              productName: x.productName,
              quantity: x.quantity,
              sellingPrice: x.sellingPrice,
              serviceId: x.serviceId,
              totalPrice: x.totalPrice,
            ),
          )
          .toList(),
      productsUpdated: sale.productsUpdated
          .map(
            (x) => ProductUpdated(
              productId: x.productId,
              quantityDeducted: x.quantityDeducted,
              stockAfter: x.stockAfter,
              stockBefore: x.stockBefore,
            ),
          )
          .toList(),
      profit: sale.profit,
      quantity: sale.quantity,
      saleId: sale.saleId,
      sellingPrice: sale.sellingPrice,
      status: sale.status,
      totalCost: sale.totalCost,
      totalQuantityProcessed: sale.totalQuantityProcessed,
      totalRevenue: sale.totalRevenue,
      updatedAt: sale.updatedAt,
      createdBy: sale.createdBy,
      invoice: sale.invoice,
      createBy: sale.createBy,
      taxAmount: sale.taxAmount,
      truckId: sale.truckId,
      previousStock: sale.previousStock,
      productId: sale.productId,
      productName: sale.productName,
      deposit: Deposit(
        depositAlreadyPaid: sale.deposit.depositAlreadyPaid,
        depositAmount: sale.deposit.depositAmount,
        depositPercentage: sale.deposit.depositPercentage,
        depositType: sale.deposit.depositType,
        nextPaymentAmount: sale.deposit.nextPaymentAmount,
        requireDeposit: sale.deposit.requireDeposit,
        depositA: sale.deposit.depositA,
      ),
      discount: sale.discount,
      discountType: sale.discountType,
      paymentData: PaymentData(
        isAlreadyPaid: sale.paymentData.isAlreadyPaid,
        paymentMethods: sale.paymentData.paymentMethods
            .map(
              (x) => PaymentMethod(
                amount: x.amount,
                method: x.method,
                methodName: x.methodName,
                reference: x.reference,
              ),
            )
            .toList(),
        remainingAmount: sale.paymentData.remainingAmount,
        totalPaid: sale.paymentData.totalPaid,
      ),
      remaining: sale.remaining,
      draft: sale.draft,
    );
  }
}

class BatchAllocation {
  final String batchId;
  final int batchQuantityRemaining;
  final String batchReference;
  final int quantity;
  final double totalCost;
  final double unitCost;

  BatchAllocation({
    required this.batchId,
    required this.batchQuantityRemaining,
    required this.batchReference,
    required this.quantity,
    required this.totalCost,
    required this.unitCost,
  });

  factory BatchAllocation.fromMap(Map<String, dynamic> map) {
    return BatchAllocation(
      batchId: map['batchId'] ?? '',
      batchQuantityRemaining: map['batchQuantityRemaining'] ?? 0,
      batchReference: map['batchReference'] ?? '',
      quantity: map['quantity'] ?? 0,
      totalCost: (map['totalCost'] ?? 0).toDouble(),
      unitCost: (map['unitCost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'batchId': batchId,
      'batchQuantityRemaining': batchQuantityRemaining,
      'batchReference': batchReference,
      'quantity': quantity,
      'totalCost': totalCost,
      'unitCost': unitCost,
    };
  }
}

class BatchUsed {
  final String batchId;
  final String productId;
  final int quantityUsed;
  final int remainingAfterSale;

  BatchUsed({
    required this.batchId,
    required this.productId,
    required this.quantityUsed,
    required this.remainingAfterSale,
  });

  factory BatchUsed.fromMap(Map<String, dynamic> map) {
    return BatchUsed(
      batchId: map['batchId'] ?? '',
      productId: map['productId'] ?? '',
      quantityUsed: map['quantityUsed'] ?? 0,
      remainingAfterSale: map['remainingAfterSale'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'batchId': batchId,
      'productId': productId,
      'quantityUsed': quantityUsed,
      'remainingAfterSale': remainingAfterSale,
    };
  }
}

class SaleItem {
  final double discount;
  final double margin;
  final String productId;
  final String productName;
  final int quantity;
  final double sellingPrice;
  final double totalPrice;
  final double unitPrice;
  final String type;
  final double cost;
  final double minimumPrice;

  SaleItem({
    required this.discount,
    required this.margin,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.sellingPrice,
    required this.totalPrice,
    required this.unitPrice,
    required this.type,
    required this.cost,
    required this.minimumPrice,
  });

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      minimumPrice: (map['minimumPrice'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      margin: (map['margin'] ?? 0).toDouble(),
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      unitPrice: (map['unitPrice'] ?? 0).toDouble(),
      type: map['type'] ?? '',
      cost: (map['cost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discount': discount,
      'margin': margin,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'totalPrice': totalPrice,
      'unitPrice': unitPrice,
    };
  }

  factory SaleItem.clone(SaleItem item) {
    return SaleItem(
      minimumPrice: item.minimumPrice,
      discount: item.discount,
      margin: item.margin,
      productId: item.productId,
      productName: item.productName,
      quantity: item.quantity,
      sellingPrice: item.sellingPrice,
      totalPrice: item.totalPrice,
      unitPrice: item.unitPrice,
      type: item.type,
      cost: item.cost,
    );
  }
}

class ServiceItem {
  final double discount;
  final String productName;
  final int quantity;
  final double sellingPrice;
  final String serviceId;
  final double totalPrice;

  ServiceItem({
    required this.discount,
    required this.productName,
    required this.quantity,
    required this.sellingPrice,
    required this.serviceId,
    required this.totalPrice,
  });

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      discount: (map['discount'] ?? 0).toDouble(),
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
      serviceId: map['serviceId'] ?? '',
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discount': discount,
      'productName': productName,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'serviceId': serviceId,
      'totalPrice': totalPrice,
    };
  }
}
