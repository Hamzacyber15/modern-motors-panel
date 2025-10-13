import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/payment_data.dart';

class NewPurchaseModel {
  final String id;
  final String branchId;
  final String supplierId;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime processedAt;
  //final List<BatchAllocation> batchAllocations;
  //final List<BatchUsed> batchesUsed;
  final List<PurchaseItem> items;
  final int quantity;
  final double purchasePrice;
  final String status;
  final double totalCost;
  final int totalQuantityProcessed;
  final DateTime updatedAt;
  final String createdBy;
  final String invoice;
  final String createBy;
  final double taxAmount;
  final int previousStock;
  final String productId;
  final String productName;
  final Deposit deposit;
  final double discount;
  final String discountType;
  final PaymentData paymentData;
  final double remaining;
  final String? draft;
  final double? total;
  NewPurchaseModel({
    required this.id,
    required this.branchId,
    required this.supplierId,
    required this.paymentMethod,
    required this.createdAt,
    required this.processedAt,
    //required this.batchAllocations,
    //required this.batchesUsed,
    required this.items,
    required this.purchasePrice,
    //required this.profit,
    required this.quantity,
    required this.status,
    required this.totalCost,
    required this.totalQuantityProcessed,
    required this.updatedAt,
    required this.createdBy,
    required this.invoice,
    required this.createBy,
    required this.taxAmount,
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

  factory NewPurchaseModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
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

    return NewPurchaseModel(
      id: doc.id,
      branchId: data['branchId'] ?? "",
      supplierId: data['supplierId'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      processedAt:
          (data['processedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // batchAllocations: (data['batchAllocations'] as List<dynamic>? ?? [])
      //     .map((x) => BatchAllocation.fromMap(x as Map<String, dynamic>))
      //     .toList(),
      // batchesUsed: (data['batchesUsed'] as List<dynamic>? ?? [])
      //     .map((x) => BatchUsed.fromMap(x as Map<String, dynamic>))
      //     .toList(),
      items: (data['items'] as List<dynamic>? ?? [])
          .map((x) => PurchaseItem.fromMap(x as Map<String, dynamic>))
          .toList(),
      // serviceItems: (data['serviceItems'] as List<dynamic>? ?? [])
      //     .map((x) => ServiceItem.fromMap(x as Map<String, dynamic>))
      //     .toList(),
      // productsUpdated: (data['productsUpdated'] as List<dynamic>? ?? [])
      //     .map((x) => ProductUpdated.fromMap(x as Map<String, dynamic>))
      //     .toList(),
      // profit: (data['profit'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      purchasePrice: (data['sellingPrice'] ?? 0).toDouble(),
      status: data['status'] ?? '',
      totalCost: (data['totalCost'] ?? 0).toDouble(),
      totalQuantityProcessed: data['totalQuantityProcessed'] ?? 0,
      taxAmount: (data['taxAmount'] ?? 0).toDouble(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? "",
      invoice: data['invoice'] ?? "",
      createBy: data['createBy'] ?? "",
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
      'supplierId': supplierId,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'processedAt': Timestamp.fromDate(processedAt),
      //'batchAllocations': batchAllocations.map((x) => x.toMap()).toList(),
      //'batchesUsed': batchesUsed.map((x) => x.toMap()).toList(),
      'items': items.map((x) => x.toMap()).toList(),
      //'serviceItems': serviceItems.map((x) => x.toMap()).toList(),
      //'productsUpdated': productsUpdated.map((x) => x.toMap()).toList(),
      //'profit': profit,
      'quantity': quantity,
      'purchasePrice': purchasePrice,
      'status': status,
      'totalCost': totalCost,
      'totalQuantityProcessed': totalQuantityProcessed,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'invoice': invoice,
      'createBy': createBy,
      'taxAmount': taxAmount,
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

  factory NewPurchaseModel.clone(NewPurchaseModel purchase) {
    return NewPurchaseModel(
      id: purchase.id,
      branchId: purchase.id,
      supplierId: purchase.supplierId,
      paymentMethod: purchase.paymentMethod,
      createdAt: purchase.createdAt,
      processedAt: purchase.processedAt,

      // batchesUsed: purchase.batchesUsed
      //     .map(
      //       (x) => BatchUsed(
      //         batchId: x.batchId,
      //         productId: x.productId,
      //         quantityUsed: x.quantityUsed,
      //         remainingAfterSale: x.remainingAfterSale,
      //       ),
      //     )
      //     .toList(),
      items: purchase.items
          .map(
            (x) => PurchaseItem(
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
      // productsUpdated: purchase.productsUpdated
      //     .map(
      //       (x) => ProductUpdated(
      //         productId: x.productId,
      //         quantityDeducted: x.quantityDeducted,
      //         stockAfter: x.stockAfter,
      //         stockBefore: x.stockBefore,
      //       ),
      //     )
      //     .toList(),
      // profit: purchase.profit,
      quantity: purchase.quantity,
      status: purchase.status,
      totalCost: purchase.totalCost,
      totalQuantityProcessed: purchase.totalQuantityProcessed,
      updatedAt: purchase.updatedAt,
      createdBy: purchase.createdBy,
      purchasePrice: purchase.purchasePrice,
      invoice: purchase.invoice,
      createBy: purchase.createBy,
      taxAmount: purchase.taxAmount,
      previousStock: purchase.previousStock,
      productId: purchase.productId,
      productName: purchase.productName,
      deposit: Deposit(
        depositAlreadyPaid: purchase.deposit.depositAlreadyPaid,
        depositAmount: purchase.deposit.depositAmount,
        depositPercentage: purchase.deposit.depositPercentage,
        depositType: purchase.deposit.depositType,
        nextPaymentAmount: purchase.deposit.nextPaymentAmount,
        requireDeposit: purchase.deposit.requireDeposit,
        depositA: purchase.deposit.depositA,
      ),
      discount: purchase.discount,
      discountType: purchase.discountType,
      paymentData: PaymentData(
        isAlreadyPaid: purchase.paymentData.isAlreadyPaid,
        paymentMethods: purchase.paymentData.paymentMethods
            .map(
              (x) => PaymentMethod(
                amount: x.amount,
                method: x.method,
                methodName: x.methodName,
                reference: x.reference,
              ),
            )
            .toList(),
        remainingAmount: purchase.paymentData.remainingAmount,
        totalPaid: purchase.paymentData.totalPaid,
      ),
      remaining: purchase.remaining,
      draft: purchase.draft,
    );
  }
}

// NEW CLASSES for the additional data structures

class Deposit {
  final bool depositAlreadyPaid;
  final double depositAmount;
  final double depositPercentage;
  final String depositType;
  final double nextPaymentAmount;
  final bool requireDeposit;
  final double depositA;

  Deposit({
    required this.depositAlreadyPaid,
    required this.depositAmount,
    required this.depositPercentage,
    required this.depositType,
    required this.nextPaymentAmount,
    required this.requireDeposit,
    required this.depositA,
  });

  factory Deposit.fromMap(Map<String, dynamic> map) {
    return Deposit(
      depositAlreadyPaid: map['depositAlreadyPaid'] ?? false,
      depositAmount: (map['depositAmount'] ?? 0).toDouble(),
      depositPercentage: (map['depositPercentage'] ?? 0).toDouble(),
      depositType: map['depositType'] ?? 'percentage',
      nextPaymentAmount: (map['nextPaymentAmount'] ?? 0).toDouble(),
      requireDeposit: map['requireDeposit'] ?? false,
      depositA: (map['depositA'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'depositAlreadyPaid': depositAlreadyPaid,
      'depositAmount': depositAmount,
      'depositPercentage': depositPercentage,
      'depositType': depositType,
      'nextPaymentAmount': nextPaymentAmount,
      'requireDeposit': requireDeposit,
      'depositA': depositA,
    };
  }
}

// Existing classes remain the same...

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

class PurchaseItem {
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

  PurchaseItem({
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

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    return PurchaseItem(
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

  factory PurchaseItem.clone(PurchaseItem item) {
    return PurchaseItem(
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

class ProductUpdated {
  final String productId;
  final int quantityDeducted;
  final int stockAfter;
  final int stockBefore;

  ProductUpdated({
    required this.productId,
    required this.quantityDeducted,
    required this.stockAfter,
    required this.stockBefore,
  });

  factory ProductUpdated.fromMap(Map<String, dynamic> map) {
    return ProductUpdated(
      productId: map['productId'] ?? '',
      quantityDeducted: map['quantityDeducted'] ?? 0,
      stockAfter: map['stockAfter'] ?? 0,
      stockBefore: map['stockBefore'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantityDeducted': quantityDeducted,
      'stockAfter': stockAfter,
      'stockBefore': stockBefore,
    };
  }
}
