// import 'package:cloud_firestore/cloud_firestore.dart';

// class NewPurchaseModel {
//   final String id;
//   final String branchId;
//   final String supplierId;
//   final String paymentMethod;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime dueDate;
//   final List<PurchaseItem> items;
//   final List<ExpenseItem> expenseData;
//   final String status;
//   final String createdBy;
//   final String createBy;
//   final String invoice;
//   final double taxAmount;
//   final double discount;
//   final String discountType;
//   final PurchaseDeposit deposit;
//   final PaymentData paymentData;
//   final double? total;
//   final double refund;
//   final String purchaseId;
//   final Totals totals;

//   NewPurchaseModel({
//     required this.id,
//     required this.branchId,
//     required this.supplierId,
//     required this.paymentMethod,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.dueDate,
//     required this.items,
//     required this.expenseData,
//     required this.status,
//     required this.createdBy,
//     required this.createBy,
//     required this.invoice,
//     required this.taxAmount,
//     required this.discount,
//     required this.discountType,
//     required this.deposit,
//     required this.paymentData,
//     this.total,
//     required this.refund,
//     required this.purchaseId,
//     required this.totals,
//   });

//   // factory NewPurchaseModel.fromFirestore(
//   //   DocumentSnapshot<Map<String, dynamic>> doc,
//   // ) {
//   //   final data = doc.data() ?? {};

//   //   // Parse deposit data
//   //   final depositData = data['deposit'] as Map<String, dynamic>? ?? {};
//   //   final deposit = PurchaseDeposit.fromMap(depositData);

//   //   // Parse payment data
//   //   final paymentDataMap = data['paymentData'] as Map<String, dynamic>? ?? {};
//   //   final paymentData = PaymentData.fromMap(paymentDataMap);

//   //   // Parse expense data
//   //   final expenseDataList = data['expenseData'] as List<dynamic>? ?? [];
//   //   final expenseData = expenseDataList
//   //       .map((x) => ExpenseItem.fromMap(x as Map<String, dynamic>))
//   //       .toList();

//   //   // Parse items data
//   //   final itemsList = data['items'] as List<dynamic>? ?? [];
//   //   final items = itemsList
//   //       .map((x) => PurchaseItem.fromMap(x as Map<String, dynamic>))
//   //       .toList();

//   //   // Parse totals data
//   //   final totalsData = data['totals'] as Map<String, dynamic>? ?? {};
//   //   final totals = Totals.fromMap(totalsData);

//   //   return NewPurchaseModel(
//   //     id: doc.id,
//   //     branchId: data['branchId'] ?? "",
//   //     supplierId: data['supplierId'] ?? "",
//   //     paymentMethod: data['paymentMethod'] ?? "",
//   //     createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//   //     updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//   //     dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
//   //     items: items,
//   //     expenseData: expenseData,
//   //     status: data['status'] ?? "",
//   //     createdBy: data['createdBy'] ?? "",
//   //     createBy: data['createBy'] ?? "",
//   //     invoice: data['invoice'] ?? "",
//   //     taxAmount: (data['taxAmount'] ?? 0).toDouble(),
//   //     discount: (data['discount'] ?? 0).toDouble(),
//   //     discountType: data['discountType'] ?? "",
//   //     deposit: deposit,
//   //     paymentData: paymentData,
//   //     total: (data['total'] ?? 0).toDouble(),
//   //     refund: (data['refund'] ?? 0).toDouble(),
//   //     purchaseId: data['purchaseId'] ?? "",
//   //     totals: totals,
//   //   );
//   // }

//   factory NewPurchaseModel.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final data = doc.data() ?? {};

//     // Handle deposit data - can be Map or number
//     PurchaseDeposit deposit;
//     final depositData = data['deposit'];
//     if (depositData is Map<String, dynamic>) {
//       deposit = PurchaseDeposit.fromMap(depositData);
//     } else {
//       // If it's a number or other type, create empty deposit
//       deposit = PurchaseDeposit(
//         depositAlreadyPaid: null,
//         depositAmount: 0.0,
//         depositPercentage: 0.0,
//         depositType: 'percentage',
//         nextPaymentAmount: 0.0,
//         requireDeposit: false,
//       );
//     }

//     // Handle payment data - safely parse
//     PaymentData paymentData;
//     final paymentDataMap = data['paymentData'];
//     if (paymentDataMap is Map<String, dynamic>) {
//       paymentData = PaymentData.fromMap(paymentDataMap);
//     } else {
//       paymentData = PaymentData(
//         isAlreadyPaid: false,
//         paymentMethods: [],
//         remainingAmount: 0.0,
//         totalPaid: 0.0,
//       );
//     }

//     // Handle expense data - can be List or null
//     List<ExpenseItem> expenseData = [];
//     final expenseDataRaw = data['expenseData'];
//     if (expenseDataRaw is List<dynamic>) {
//       expenseData = expenseDataRaw.map((x) {
//         if (x is Map<String, dynamic>) {
//           return ExpenseItem.fromMap(x);
//         } else {
//           // Handle case where array element is not a map
//           return ExpenseItem(
//             type: "",
//             typeName: "",
//             amount: 0.0,
//             description: "",
//             supplierId: "",
//             vatType: "none",
//             vatAmount: 0.0,
//             includeInProductCost: true,
//           );
//         }
//       }).toList();
//     }

//     // Handle items data - can be List or null
//     List<PurchaseItem> items = [];
//     final itemsRaw = data['items'];
//     if (itemsRaw is List<dynamic>) {
//       items = itemsRaw.map((x) {
//         if (x is Map<String, dynamic>) {
//           return PurchaseItem.fromMap(x);
//         } else {
//           // Handle case where array element is not a map
//           return PurchaseItem(
//             productId: "",
//             productName: "",
//             type: "product",
//             quantity: 0,
//             unitPrice: 0.0,
//             buyingPrice: 0.0,
//             discount: 0.0,
//             discountType: "percentage",
//             subtotal: 0.0,
//             amountAfterDiscount: 0.0,
//             totalPrice: 0.0,
//             total: 0.0,
//             vatType: "none",
//             vatAmount: 0.0,
//             addToPurchaseCost: false,
//             directExpense: DirectExpense.empty(),
//           );
//         }
//       }).toList();
//     }

//     // Handle totals data - safely parse
//     Totals totals;
//     final totalsData = data['totals'];
//     if (totalsData is Map<String, dynamic>) {
//       totals = Totals.fromMap(totalsData);
//     } else {
//       // If totals is a number, extract the value
//       final totalValue = (totalsData ?? 0).toDouble();
//       totals = Totals(
//         discount: 0.0,
//         discountType: "",
//         expensesSubtotal: 0.0,
//         expensesVatTotal: 0.0,
//         grandSubtotal: totalValue,
//         grandTotal: totalValue,
//         grandVatTotal: 0.0,
//         itemsSubtotal: totalValue,
//         taxAmount: 0.0,
//         total: totalValue,
//       );
//     }

//     return NewPurchaseModel(
//       id: doc.id,
//       branchId: data['branchId']?.toString() ?? "",
//       supplierId: data['supplierId']?.toString() ?? "",
//       paymentMethod: data['paymentMethod']?.toString() ?? "",
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       items: items,
//       expenseData: expenseData,
//       status: data['status']?.toString() ?? "",
//       createdBy: data['createdBy']?.toString() ?? "",
//       createBy: data['createBy']?.toString() ?? "",
//       invoice: data['invoice']?.toString() ?? "",
//       taxAmount: (data['taxAmount'] ?? 0).toDouble(),
//       discount: (data['discount'] ?? 0).toDouble(),
//       discountType: data['discountType']?.toString() ?? "",
//       deposit: deposit,
//       paymentData: paymentData,
//       total: (data['total'] ?? 0).toDouble(),
//       refund: (data['refund'] ?? 0).toDouble(),
//       purchaseId: data['purchaseId']?.toString() ?? "",
//       totals: totals,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'branchId': branchId,
//       'supplierId': supplierId,
//       'paymentMethod': paymentMethod,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'updatedAt': Timestamp.fromDate(updatedAt),
//       'dueDate': Timestamp.fromDate(dueDate),
//       'items': items.map((x) => x.toMap()).toList(),
//       'expenseData': expenseData.map((x) => x.toMap()).toList(),
//       'status': status,
//       'createdBy': createdBy,
//       'createBy': createBy,
//       'invoice': invoice,
//       'taxAmount': taxAmount,
//       'discount': discount,
//       'discountType': discountType,
//       'deposit': deposit.toMap(), // Always convert to map
//       'paymentData': paymentData.toMap(), // Always convert to map
//       'total': total,
//       'refund': refund,
//       'purchaseId': purchaseId,
//       'totals': totals.toMap(), // Always convert to map
//     };
//   }

//   // Map<String, dynamic> toMap() {
//   //   return {
//   //     'branchId': branchId,
//   //     'supplierId': supplierId,
//   //     'paymentMethod': paymentMethod,
//   //     'createdAt': Timestamp.fromDate(createdAt),
//   //     'updatedAt': Timestamp.fromDate(updatedAt),
//   //     'dueDate': Timestamp.fromDate(dueDate),
//   //     'items': items.map((x) => x.toMap()).toList(),
//   //     'expenseData': expenseData.map((x) => x.toMap()).toList(),
//   //     'status': status,
//   //     'createdBy': createdBy,
//   //     'createBy': createBy,
//   //     'invoice': invoice,
//   //     'taxAmount': taxAmount,
//   //     'discount': discount,
//   //     'discountType': discountType,
//   //     'deposit': deposit.toMap(),
//   //     'paymentData': paymentData.toMap(),
//   //     'total': total,
//   //     'refund': refund,
//   //     'purchaseId': purchaseId,
//   //     'totals': totals.toMap(),
//   //   };
//   // }
// }

// // Payment Data Classes
// class PaymentData {
//   final bool isAlreadyPaid;
//   final List<PaymentMethod> paymentMethods;
//   final double remainingAmount;
//   final double totalPaid;

//   PaymentData({
//     required this.isAlreadyPaid,
//     required this.paymentMethods,
//     required this.remainingAmount,
//     required this.totalPaid,
//   });

//   factory PaymentData.fromMap(Map<String, dynamic> map) {
//     final paymentMethodsList = map['paymentMethods'] as List<dynamic>? ?? [];
//     final paymentMethods = paymentMethodsList
//         .map((x) => PaymentMethod.fromMap(x as Map<String, dynamic>))
//         .toList();

//     return PaymentData(
//       isAlreadyPaid: map['isAlreadyPaid'] ?? false,
//       paymentMethods: paymentMethods,
//       remainingAmount: (map['remainingAmount'] ?? 0).toDouble(),
//       totalPaid: (map['totalPaid'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'isAlreadyPaid': isAlreadyPaid,
//       'paymentMethods': paymentMethods.map((x) => x.toMap()).toList(),
//       'remainingAmount': remainingAmount,
//       'totalPaid': totalPaid,
//     };
//   }
// }

// class PaymentMethod {
//   final String method;
//   final String methodName;
//   final String reference;
//   final double amount;

//   PaymentMethod({
//     required this.method,
//     required this.methodName,
//     required this.reference,
//     required this.amount,
//   });

//   factory PaymentMethod.fromMap(Map<String, dynamic> map) {
//     return PaymentMethod(
//       method: map['method'] ?? "",
//       methodName: map['methodName'] ?? "",
//       reference: map['reference'] ?? "",
//       amount: (map['amount'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'method': method,
//       'methodName': methodName,
//       'reference': reference,
//       'amount': amount,
//     };
//   }
// }

// // Expense Item Class
// class ExpenseItem {
//   final String type;
//   final String typeName;
//   final double amount;
//   final String description;
//   final String supplierId;
//   final String vatType;
//   final double vatAmount;
//   final bool includeInProductCost;

//   ExpenseItem({
//     required this.type,
//     required this.typeName,
//     required this.amount,
//     required this.description,
//     required this.supplierId,
//     required this.vatType,
//     required this.vatAmount,
//     required this.includeInProductCost,
//   });

//   factory ExpenseItem.fromMap(Map<String, dynamic> map) {
//     return ExpenseItem(
//       type: map['type'] ?? "",
//       typeName: map['typeName'] ?? "",
//       amount: (map['amount'] ?? 0).toDouble(),
//       description: map['description'] ?? "",
//       supplierId: map['supplierId'] ?? "",
//       vatType: map['vatType'] ?? "none",
//       vatAmount: (map['vatAmount'] ?? 0).toDouble(),
//       includeInProductCost: map['includeInProductCost'] ?? true,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'type': type,
//       'typeName': typeName,
//       'amount': amount,
//       'description': description,
//       'supplierId': supplierId,
//       'vatType': vatType,
//       'vatAmount': vatAmount,
//       'includeInProductCost': includeInProductCost,
//     };
//   }
// }

// // PurchaseItem Class
// class PurchaseItem {
//   final String productId;
//   final String productName;
//   final String type;
//   final int quantity;
//   final double unitPrice;
//   final double buyingPrice;
//   final double discount;
//   final String discountType;
//   final double subtotal;
//   final double amountAfterDiscount;
//   final double totalPrice;
//   final double total;
//   final String vatType;
//   final double vatAmount;
//   final bool addToPurchaseCost;
//   final DirectExpense directExpense;

//   PurchaseItem({
//     required this.productId,
//     required this.productName,
//     required this.type,
//     required this.quantity,
//     required this.unitPrice,
//     required this.buyingPrice,
//     required this.discount,
//     required this.discountType,
//     required this.subtotal,
//     required this.amountAfterDiscount,
//     required this.totalPrice,
//     required this.total,
//     required this.vatType,
//     required this.vatAmount,
//     required this.addToPurchaseCost,
//     required this.directExpense,
//   });

//   // Clone method
//   factory PurchaseItem.clone(PurchaseItem item) {
//     return PurchaseItem(
//       productId: item.productId,
//       productName: item.productName,
//       type: item.type,
//       quantity: item.quantity,
//       unitPrice: item.unitPrice,
//       buyingPrice: item.buyingPrice,
//       discount: item.discount,
//       discountType: item.discountType,
//       subtotal: item.subtotal,
//       amountAfterDiscount: item.amountAfterDiscount,
//       totalPrice: item.totalPrice,
//       total: item.total,
//       vatType: item.vatType,
//       vatAmount: item.vatAmount,
//       addToPurchaseCost: item.addToPurchaseCost,
//       directExpense: DirectExpense(
//         amount: item.directExpense.amount,
//         includeInCost: item.directExpense.includeInCost,
//         supplierId: item.directExpense.supplierId,
//         type: item.directExpense.type,
//         vatAmount: item.directExpense.vatAmount,
//         vatType: item.directExpense.vatType,
//       ),
//     );
//   }

//   factory PurchaseItem.fromMap(Map<String, dynamic> map) {
//     final directExpenseData =
//         map['directExpense'] as Map<String, dynamic>? ?? {};

//     return PurchaseItem(
//       productId: map['productId'] ?? "",
//       productName: map['productName'] ?? "",
//       type: map['type'] ?? "product",
//       quantity: (map['quantity'] ?? 0).toInt(),
//       unitPrice: (map['unitPrice'] ?? 0).toDouble(),
//       buyingPrice: (map['buyingPrice'] ?? 0).toDouble(),
//       discount: (map['discount'] ?? 0).toDouble(),
//       discountType: map['discountType'] ?? "percentage",
//       subtotal: (map['subtotal'] ?? 0).toDouble(),
//       amountAfterDiscount: (map['amountAfterDiscount'] ?? 0).toDouble(),
//       totalPrice: (map['totalPrice'] ?? 0).toDouble(),
//       total: (map['total'] ?? 0).toDouble(),
//       vatType: map['vatType'] ?? "none",
//       vatAmount: (map['vatAmount'] ?? 0).toDouble(),
//       addToPurchaseCost: map['addToPurchaseCost'] ?? false,
//       directExpense: DirectExpense.fromMap(directExpenseData),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'productId': productId,
//       'productName': productName,
//       'type': type,
//       'quantity': quantity,
//       'unitPrice': unitPrice,
//       'buyingPrice': buyingPrice,
//       'discount': discount,
//       'discountType': discountType,
//       'subtotal': subtotal,
//       'amountAfterDiscount': amountAfterDiscount,
//       'totalPrice': totalPrice,
//       'total': total,
//       'vatType': vatType,
//       'vatAmount': vatAmount,
//       'addToPurchaseCost': addToPurchaseCost,
//       'directExpense': directExpense.toMap(),
//     };
//   }

//   // Optional: You can also add a copyWith method for convenience
//   PurchaseItem copyWith({
//     String? productId,
//     String? productName,
//     String? type,
//     int? quantity,
//     double? unitPrice,
//     double? buyingPrice,
//     double? discount,
//     String? discountType,
//     double? subtotal,
//     double? amountAfterDiscount,
//     double? totalPrice,
//     double? total,
//     String? vatType,
//     double? vatAmount,
//     bool? addToPurchaseCost,
//     DirectExpense? directExpense,
//   }) {
//     return PurchaseItem(
//       productId: productId ?? this.productId,
//       productName: productName ?? this.productName,
//       type: type ?? this.type,
//       quantity: quantity ?? this.quantity,
//       unitPrice: unitPrice ?? this.unitPrice,
//       buyingPrice: buyingPrice ?? this.buyingPrice,
//       discount: discount ?? this.discount,
//       discountType: discountType ?? this.discountType,
//       subtotal: subtotal ?? this.subtotal,
//       amountAfterDiscount: amountAfterDiscount ?? this.amountAfterDiscount,
//       totalPrice: totalPrice ?? this.totalPrice,
//       total: total ?? this.total,
//       vatType: vatType ?? this.vatType,
//       vatAmount: vatAmount ?? this.vatAmount,
//       addToPurchaseCost: addToPurchaseCost ?? this.addToPurchaseCost,
//       directExpense: directExpense ?? this.directExpense,
//     );
//   }
// }

// // Direct Expense Class
// class DirectExpense {
//   final double amount;
//   final bool includeInCost;
//   final String supplierId;
//   final String type;
//   final double vatAmount;
//   final String vatType;

//   DirectExpense({
//     required this.amount,
//     required this.includeInCost,
//     required this.supplierId,
//     required this.type,
//     required this.vatAmount,
//     required this.vatType,
//   });

//   DirectExpense.empty()
//     : amount = 0.0,
//       includeInCost = false,
//       supplierId = "",
//       type = "",
//       vatAmount = 0.0,
//       vatType = "none";

//   factory DirectExpense.fromMap(Map<String, dynamic> map) {
//     return DirectExpense(
//       amount: (map['amount'] ?? 0).toDouble(),
//       includeInCost: map['includeInCost'] ?? false,
//       supplierId: map['supplierId'] ?? "",
//       type: map['type'] ?? "",
//       vatAmount: (map['vatAmount'] ?? 0).toDouble(),
//       vatType: map['vatType'] ?? "none",
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'amount': amount,
//       'includeInCost': includeInCost,
//       'supplierId': supplierId,
//       'type': type,
//       'vatAmount': vatAmount,
//       'vatType': vatType,
//     };
//   }
// }

// // Totals Class
// class Totals {
//   final double discount;
//   final String discountType;
//   final double expensesSubtotal;
//   final double expensesVatTotal;
//   final double grandSubtotal;
//   final double grandTotal;
//   final double grandVatTotal;
//   final double itemsSubtotal;
//   final double taxAmount;
//   final double total;

//   Totals({
//     required this.discount,
//     required this.discountType,
//     required this.expensesSubtotal,
//     required this.expensesVatTotal,
//     required this.grandSubtotal,
//     required this.grandTotal,
//     required this.grandVatTotal,
//     required this.itemsSubtotal,
//     required this.taxAmount,
//     required this.total,
//   });

//   factory Totals.fromMap(Map<String, dynamic> map) {
//     return Totals(
//       discount: (map['discount'] ?? 0).toDouble(),
//       discountType: map['discountType'] ?? "",
//       expensesSubtotal: (map['expensesSubtotal'] ?? 0).toDouble(),
//       expensesVatTotal: (map['expensesVatTotal'] ?? 0).toDouble(),
//       grandSubtotal: (map['grandSubtotal'] ?? 0).toDouble(),
//       grandTotal: (map['grandTotal'] ?? 0).toDouble(),
//       grandVatTotal: (map['grandVatTotal'] ?? 0).toDouble(),
//       itemsSubtotal: (map['itemsSubtotal'] ?? 0).toDouble(),
//       taxAmount: (map['taxAmount'] ?? 0).toDouble(),
//       total: (map['total'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'discount': discount,
//       'discountType': discountType,
//       'expensesSubtotal': expensesSubtotal,
//       'expensesVatTotal': expensesVatTotal,
//       'grandSubtotal': grandSubtotal,
//       'grandTotal': grandTotal,
//       'grandVatTotal': grandVatTotal,
//       'itemsSubtotal': itemsSubtotal,
//       'taxAmount': taxAmount,
//       'total': total,
//     };
//   }
// }

// // Deposit Class
// class PurchaseDeposit {
//   final bool? depositAlreadyPaid;
//   final double depositAmount;
//   final double depositPercentage;
//   final String depositType;
//   final double nextPaymentAmount;
//   final bool requireDeposit;

//   PurchaseDeposit({
//     this.depositAlreadyPaid,
//     required this.depositAmount,
//     required this.depositPercentage,
//     required this.depositType,
//     required this.nextPaymentAmount,
//     required this.requireDeposit,
//   });

//   factory PurchaseDeposit.fromMap(Map<String, dynamic> map) {
//     return PurchaseDeposit(
//       depositAlreadyPaid: map['depositAlreadyPaid'],
//       depositAmount: (map['depositAmount'] ?? 0).toDouble(),
//       depositPercentage: (map['depositPercentage'] ?? 0).toDouble(),
//       depositType: map['depositType'] ?? 'percentage',
//       nextPaymentAmount: (map['nextPaymentAmount'] ?? 0).toDouble(),
//       requireDeposit: map['requireDeposit'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'depositAlreadyPaid': depositAlreadyPaid,
//       'depositAmount': depositAmount,
//       'depositPercentage': depositPercentage,
//       'depositType': depositType,
//       'nextPaymentAmount': nextPaymentAmount,
//       'requireDeposit': requireDeposit,
//     };
//   }
// }

// // Batch Allocation Classes (if you need them)
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

class NewPurchaseModel {
  final String id;
  final String branchId;
  final String supplierId;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueDate;
  final List<PurchaseItem> items;
  final List<ExpenseItem> expenseData;
  String status;
  final String createdBy;
  final String createBy;
  final String invoice;
  final double taxAmount;
  final double discount;
  final String discountType;
  final PurchaseDeposit deposit;
  final PaymentData paymentData;
  final double? total;
  final double refund;
  final String purchaseId;
  final Totals totals;
  final List<SubInvoice> subInvoices;
  final double subInvoicesTotal;
  final double mainInvoiceTotal;

  NewPurchaseModel({
    required this.id,
    required this.branchId,
    required this.supplierId,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    required this.dueDate,
    required this.items,
    required this.expenseData,
    required this.status,
    required this.createdBy,
    required this.createBy,
    required this.invoice,
    required this.taxAmount,
    required this.discount,
    required this.discountType,
    required this.deposit,
    required this.paymentData,
    this.total,
    required this.refund,
    required this.purchaseId,
    required this.totals,
    required this.subInvoices,
    required this.subInvoicesTotal,
    required this.mainInvoiceTotal,
  });

  factory NewPurchaseModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    // Handle deposit data - can be Map or number
    PurchaseDeposit deposit;
    final depositData = data['deposit'];
    if (depositData is Map<String, dynamic>) {
      deposit = PurchaseDeposit.fromMap(depositData);
    } else {
      // If it's a number or other type, create empty deposit
      deposit = PurchaseDeposit(
        depositAlreadyPaid: null,
        depositAmount: 0.0,
        depositPercentage: 0.0,
        depositType: 'percentage',
        nextPaymentAmount: 0.0,
        requireDeposit: false,
      );
    }

    // Handle payment data - safely parse
    PaymentData paymentData;
    final paymentDataMap = data['paymentData'];
    if (paymentDataMap is Map<String, dynamic>) {
      paymentData = PaymentData.fromMap(paymentDataMap);
    } else {
      paymentData = PaymentData(
        isAlreadyPaid: false,
        paymentMethods: [],
        remainingAmount: 0.0,
        totalPaid: 0.0,
      );
    }

    // Handle expense data - can be List or null
    List<ExpenseItem> expenseData = [];
    final expenseDataRaw = data['expenseData'];
    if (expenseDataRaw is List<dynamic>) {
      expenseData = expenseDataRaw.map((x) {
        if (x is Map<String, dynamic>) {
          return ExpenseItem.fromMap(x);
        } else {
          // Handle case where array element is not a map
          return ExpenseItem(
            type: "",
            typeName: "",
            amount: 0.0,
            description: "",
            supplierId: "",
            vatType: "none",
            vatAmount: 0.0,
            includeInProductCost: true,
          );
        }
      }).toList();
    }

    // Handle items data - can be List or null
    List<PurchaseItem> items = [];
    final itemsRaw = data['items'];
    if (itemsRaw is List<dynamic>) {
      items = itemsRaw.map((x) {
        if (x is Map<String, dynamic>) {
          return PurchaseItem.fromMap(x);
        } else {
          // Handle case where array element is not a map
          return PurchaseItem(
            productId: "",
            productName: "",
            type: "product",
            quantity: 0,
            unitPrice: 0.0,
            buyingPrice: 0.0,
            discount: 0.0,
            discountType: "percentage",
            subtotal: 0.0,
            amountAfterDiscount: 0.0,
            totalPrice: 0.0,
            total: 0.0,
            vatType: "none",
            vatAmount: 0.0,
            addToPurchaseCost: false,
            directExpense: DirectExpense.empty(),
          );
        }
      }).toList();
    }

    // Handle subInvoices data - can be List or null
    List<SubInvoice> subInvoices = [];
    final subInvoicesRaw = data['subInvoices'];
    if (subInvoicesRaw is List<dynamic>) {
      subInvoices = subInvoicesRaw.map((x) {
        if (x is Map<String, dynamic>) {
          return SubInvoice.fromMap(x);
        } else {
          // Handle case where array element is not a map
          return SubInvoice(invoice: "", supplierId: "", total: 0.0);
        }
      }).toList();
    }

    // Handle totals data - safely parse
    Totals totals;
    final totalsData = data['totals'];
    if (totalsData is Map<String, dynamic>) {
      totals = Totals.fromMap(totalsData);
    } else {
      // If totals is a number, extract the value
      final totalValue = (totalsData ?? 0).toDouble();
      totals = Totals(
        discount: 0.0,
        discountType: "",
        expensesSubtotal: 0.0,
        expensesVatTotal: 0.0,
        grandSubtotal: totalValue,
        grandTotal: totalValue,
        grandVatTotal: 0.0,
        itemsSubtotal: totalValue,
        taxAmount: 0.0,
        total: totalValue,
      );
    }

    return NewPurchaseModel(
      id: doc.id,
      branchId: data['branchId']?.toString() ?? "",
      supplierId: data['supplierId']?.toString() ?? "",
      paymentMethod: data['paymentMethod']?.toString() ?? "",
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: items,
      expenseData: expenseData,
      status: data['status']?.toString() ?? "",
      createdBy: data['createdBy']?.toString() ?? "",
      createBy: data['createBy']?.toString() ?? "",
      invoice: data['invoice']?.toString() ?? "",
      taxAmount: (data['taxAmount'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      discountType: data['discountType']?.toString() ?? "",
      deposit: deposit,
      paymentData: paymentData,
      total: (data['total'] ?? 0).toDouble(),
      refund: (data['refund'] ?? 0).toDouble(),
      purchaseId: data['purchaseId']?.toString() ?? "",
      totals: totals,
      subInvoices: subInvoices,
      subInvoicesTotal: (data['subInvoicesTotal'] ?? 0).toDouble(),
      mainInvoiceTotal: (data['mainInvoiceTotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'branchId': branchId,
      'supplierId': supplierId,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'dueDate': Timestamp.fromDate(dueDate),
      'items': items.map((x) => x.toMap()).toList(),
      'expenseData': expenseData.map((x) => x.toMap()).toList(),
      'status': status,
      'createdBy': createdBy,
      'createBy': createBy,
      'invoice': invoice,
      'taxAmount': taxAmount,
      'discount': discount,
      'discountType': discountType,
      'deposit': deposit.toMap(),
      'paymentData': paymentData.toMap(),
      'total': total,
      'refund': refund,
      'purchaseId': purchaseId,
      'totals': totals.toMap(),
      'subInvoices': subInvoices.map((x) => x.toMap()).toList(),
      'subInvoicesTotal': subInvoicesTotal,
      'mainInvoiceTotal': mainInvoiceTotal,
    };
  }
}

// SubInvoice class
class SubInvoice {
  final String invoice;
  final String supplierId;
  final double total;

  SubInvoice({
    required this.invoice,
    required this.supplierId,
    required this.total,
  });

  factory SubInvoice.fromMap(Map<String, dynamic> map) {
    return SubInvoice(
      invoice: map['invoice']?.toString() ?? "",
      supplierId: map['supplierId']?.toString() ?? "",
      total: (map['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'invoice': invoice, 'supplierId': supplierId, 'total': total};
  }
}

// Payment Data Classes
// class PaymentData {
//   final bool isAlreadyPaid;
//   final List<PaymentMethod> paymentMethods;
//   final double remainingAmount;
//   final double totalPaid;

//   PaymentData({
//     required this.isAlreadyPaid,
//     required this.paymentMethods,
//     required this.remainingAmount,
//     required this.totalPaid,
//   });

//   factory PaymentData.fromMap(Map<String, dynamic> map) {
//     final paymentMethodsList = map['paymentMethods'] as List<dynamic>? ?? [];
//     final paymentMethods = paymentMethodsList
//         .map((x) => PaymentMethod.fromMap(x as Map<String, dynamic>))
//         .toList();

//     return PaymentData(
//       isAlreadyPaid: map['isAlreadyPaid'] ?? false,
//       paymentMethods: paymentMethods,
//       remainingAmount: (map['remainingAmount'] ?? 0).toDouble(),
//       totalPaid: (map['totalPaid'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'isAlreadyPaid': isAlreadyPaid,
//       'paymentMethods': paymentMethods.map((x) => x.toMap()).toList(),
//       'remainingAmount': remainingAmount,
//       'totalPaid': totalPaid,
//     };
//   }
// }

// class PaymentMethod {
//   final String method;
//   final String methodName;
//   final String reference;
//   final double amount;

//   PaymentMethod({
//     required this.method,
//     required this.methodName,
//     required this.reference,
//     required this.amount,
//   });

//   factory PaymentMethod.fromMap(Map<String, dynamic> map) {
//     return PaymentMethod(
//       method: map['method'] ?? "",
//       methodName: map['methodName'] ?? "",
//       reference: map['reference'] ?? "",
//       amount: (map['amount'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'method': method,
//       'methodName': methodName,
//       'reference': reference,
//       'amount': amount,
//     };
//   }
// }

// Expense Item Class
class ExpenseItem {
  final String type;
  final String typeName;
  final double amount;
  final String description;
  final String supplierId;
  final String vatType;
  final double vatAmount;
  final bool includeInProductCost;

  ExpenseItem({
    required this.type,
    required this.typeName,
    required this.amount,
    required this.description,
    required this.supplierId,
    required this.vatType,
    required this.vatAmount,
    required this.includeInProductCost,
  });

  factory ExpenseItem.fromMap(Map<String, dynamic> map) {
    return ExpenseItem(
      type: map['type'] ?? "",
      typeName: map['typeName'] ?? "",
      amount: (map['amount'] ?? 0).toDouble(),
      description: map['description'] ?? "",
      supplierId: map['supplierId'] ?? "",
      vatType: map['vatType'] ?? "none",
      vatAmount: (map['vatAmount'] ?? 0).toDouble(),
      includeInProductCost: map['includeInProductCost'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'typeName': typeName,
      'amount': amount,
      'description': description,
      'supplierId': supplierId,
      'vatType': vatType,
      'vatAmount': vatAmount,
      'includeInProductCost': includeInProductCost,
    };
  }
}

// PurchaseItem Class
class PurchaseItem {
  final String productId;
  final String productName;
  final String type;
  final int quantity;
  final double unitPrice;
  final double buyingPrice;
  final double discount;
  final String discountType;
  final double subtotal;
  final double amountAfterDiscount;
  final double totalPrice;
  final double total;
  final String vatType;
  final double vatAmount;
  final bool addToPurchaseCost;
  final DirectExpense directExpense;

  PurchaseItem({
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.unitPrice,
    required this.buyingPrice,
    required this.discount,
    required this.discountType,
    required this.subtotal,
    required this.amountAfterDiscount,
    required this.totalPrice,
    required this.total,
    required this.vatType,
    required this.vatAmount,
    required this.addToPurchaseCost,
    required this.directExpense,
  });

  // Clone method
  factory PurchaseItem.clone(PurchaseItem item) {
    return PurchaseItem(
      productId: item.productId,
      productName: item.productName,
      type: item.type,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      buyingPrice: item.buyingPrice,
      discount: item.discount,
      discountType: item.discountType,
      subtotal: item.subtotal,
      amountAfterDiscount: item.amountAfterDiscount,
      totalPrice: item.totalPrice,
      total: item.total,
      vatType: item.vatType,
      vatAmount: item.vatAmount,
      addToPurchaseCost: item.addToPurchaseCost,
      directExpense: DirectExpense(
        amount: item.directExpense.amount,
        includeInCost: item.directExpense.includeInCost,
        supplierId: item.directExpense.supplierId,
        type: item.directExpense.type,
        vatAmount: item.directExpense.vatAmount,
        vatType: item.directExpense.vatType,
      ),
    );
  }

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    final directExpenseData =
        map['directExpense'] as Map<String, dynamic>? ?? {};

    return PurchaseItem(
      productId: map['productId'] ?? "",
      productName: map['productName'] ?? "",
      type: map['type'] ?? "product",
      quantity: (map['quantity'] ?? 0).toInt(),
      unitPrice: (map['unitPrice'] ?? 0).toDouble(),
      buyingPrice: (map['buyingPrice'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      discountType: map['discountType'] ?? "percentage",
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      amountAfterDiscount: (map['amountAfterDiscount'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      vatType: map['vatType'] ?? "none",
      vatAmount: (map['vatAmount'] ?? 0).toDouble(),
      addToPurchaseCost: map['addToPurchaseCost'] ?? false,
      directExpense: DirectExpense.fromMap(directExpenseData),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'type': type,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'buyingPrice': buyingPrice,
      'discount': discount,
      'discountType': discountType,
      'subtotal': subtotal,
      'amountAfterDiscount': amountAfterDiscount,
      'totalPrice': totalPrice,
      'total': total,
      'vatType': vatType,
      'vatAmount': vatAmount,
      'addToPurchaseCost': addToPurchaseCost,
      'directExpense': directExpense.toMap(),
    };
  }

  // Optional: You can also add a copyWith method for convenience
  PurchaseItem copyWith({
    String? productId,
    String? productName,
    String? type,
    int? quantity,
    double? unitPrice,
    double? buyingPrice,
    double? discount,
    String? discountType,
    double? subtotal,
    double? amountAfterDiscount,
    double? totalPrice,
    double? total,
    String? vatType,
    double? vatAmount,
    bool? addToPurchaseCost,
    DirectExpense? directExpense,
  }) {
    return PurchaseItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      subtotal: subtotal ?? this.subtotal,
      amountAfterDiscount: amountAfterDiscount ?? this.amountAfterDiscount,
      totalPrice: totalPrice ?? this.totalPrice,
      total: total ?? this.total,
      vatType: vatType ?? this.vatType,
      vatAmount: vatAmount ?? this.vatAmount,
      addToPurchaseCost: addToPurchaseCost ?? this.addToPurchaseCost,
      directExpense: directExpense ?? this.directExpense,
    );
  }
}

// Direct Expense Class
class DirectExpense {
  final double amount;
  final bool includeInCost;
  final String supplierId;
  final String type;
  final double vatAmount;
  final String vatType;

  DirectExpense({
    required this.amount,
    required this.includeInCost,
    required this.supplierId,
    required this.type,
    required this.vatAmount,
    required this.vatType,
  });

  DirectExpense.empty()
    : amount = 0.0,
      includeInCost = false,
      supplierId = "",
      type = "",
      vatAmount = 0.0,
      vatType = "none";

  factory DirectExpense.fromMap(Map<String, dynamic> map) {
    return DirectExpense(
      amount: (map['amount'] ?? 0).toDouble(),
      includeInCost: map['includeInCost'] ?? false,
      supplierId: map['supplierId'] ?? "",
      type: map['type'] ?? "",
      vatAmount: (map['vatAmount'] ?? 0).toDouble(),
      vatType: map['vatType'] ?? "none",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'includeInCost': includeInCost,
      'supplierId': supplierId,
      'type': type,
      'vatAmount': vatAmount,
      'vatType': vatType,
    };
  }
}

// Totals Class
class Totals {
  final double discount;
  final String discountType;
  final double expensesSubtotal;
  final double expensesVatTotal;
  final double grandSubtotal;
  final double grandTotal;
  final double grandVatTotal;
  final double itemsSubtotal;
  final double taxAmount;
  final double total;

  Totals({
    required this.discount,
    required this.discountType,
    required this.expensesSubtotal,
    required this.expensesVatTotal,
    required this.grandSubtotal,
    required this.grandTotal,
    required this.grandVatTotal,
    required this.itemsSubtotal,
    required this.taxAmount,
    required this.total,
  });

  factory Totals.fromMap(Map<String, dynamic> map) {
    return Totals(
      discount: (map['discount'] ?? 0).toDouble(),
      discountType: map['discountType'] ?? "",
      expensesSubtotal: (map['expensesSubtotal'] ?? 0).toDouble(),
      expensesVatTotal: (map['expensesVatTotal'] ?? 0).toDouble(),
      grandSubtotal: (map['grandSubtotal'] ?? 0).toDouble(),
      grandTotal: (map['grandTotal'] ?? 0).toDouble(),
      grandVatTotal: (map['grandVatTotal'] ?? 0).toDouble(),
      itemsSubtotal: (map['itemsSubtotal'] ?? 0).toDouble(),
      taxAmount: (map['taxAmount'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discount': discount,
      'discountType': discountType,
      'expensesSubtotal': expensesSubtotal,
      'expensesVatTotal': expensesVatTotal,
      'grandSubtotal': grandSubtotal,
      'grandTotal': grandTotal,
      'grandVatTotal': grandVatTotal,
      'itemsSubtotal': itemsSubtotal,
      'taxAmount': taxAmount,
      'total': total,
    };
  }
}

// Deposit Class
class PurchaseDeposit {
  final bool? depositAlreadyPaid;
  final double depositAmount;
  final double depositPercentage;
  final String depositType;
  final double nextPaymentAmount;
  final bool requireDeposit;

  PurchaseDeposit({
    this.depositAlreadyPaid,
    required this.depositAmount,
    required this.depositPercentage,
    required this.depositType,
    required this.nextPaymentAmount,
    required this.requireDeposit,
  });

  factory PurchaseDeposit.fromMap(Map<String, dynamic> map) {
    return PurchaseDeposit(
      depositAlreadyPaid: map['depositAlreadyPaid'],
      depositAmount: (map['depositAmount'] ?? 0).toDouble(),
      depositPercentage: (map['depositPercentage'] ?? 0).toDouble(),
      depositType: map['depositType'] ?? 'percentage',
      nextPaymentAmount: (map['nextPaymentAmount'] ?? 0).toDouble(),
      requireDeposit: map['requireDeposit'] ?? false,
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
    };
  }
}

// Batch Allocation Classes
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
