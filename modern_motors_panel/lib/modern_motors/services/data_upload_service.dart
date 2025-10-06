// import 'package:app/models/invoice/invoice_mm_model.dart';
// import 'package:app/modern_motors/models/admin/brand_model.dart';
// import 'package:app/modern_motors/models/admin/unit_model.dart';
// import 'package:app/modern_motors/models/assets/assets_category_model.dart';
// import 'package:app/modern_motors/models/assets/assets_model.dart';
// import 'package:app/modern_motors/models/customer/customer_model.dart';
// import 'package:app/modern_motors/models/inventory/inventory_model.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/models/product_category_model.dart';
// import 'package:app/modern_motors/models/purchases/grn_model/grn_model.dart';
// import 'package:app/modern_motors/models/purchases/purchase_order_model.dart';
// import 'package:app/modern_motors/models/purchases/purchase_requisition_model.dart';
// import 'package:app/modern_motors/models/purchases/purchases_model.dart';
// import 'package:app/modern_motors/models/trucks/mmtrucks_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class DataUploadService {
//   // PURCHASE ORDER
//   static Future<void> addPurchaseOrder(PurchaseModel model) async {
//     await FirebaseFirestore.instance.collection('purchaseOrder').add({
//       ...model.toMap(),
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> updatePurchaseOrder(
//     String id,
//     PurchaseModel model,
//   ) async {
//     await FirebaseFirestore.instance
//         .collection('purchaseOrder')
//         .doc(id)
//         .update(model.toMap());
//   }

//   // INVENTORY
//   static Future<void> addInventory(InventoryModel model) async {
//     await FirebaseFirestore.instance.collection('inventory').add({
//       ...model.toJson(),
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   // Add to your DataUploadService class
//   // In your DataUploadService class
//   static Future<void> processSale(Map<String, dynamic> saleData) async {
//     final batch = FirebaseFirestore.instance.batch();

//     try {
//       // 1. Create sale document
//       final saleRef = FirebaseFirestore.instance.collection('sales').doc();

//       // Get items safely
//       final items = saleData['items'] as List<dynamic>? ?? [];

//       // 2. Update batches and product inventory
//       final batchesCollection =
//           FirebaseFirestore.instance.collection('mmInventoryBatches');

//       double totalReduction = 0;
//       int totalQuantity = 0;

//       // Process each item in the sale
//       for (final item in items) {
//         final productId = item['productId'] as String?;
//         final quantity = (item['quantity'] as num?)?.toInt() ?? 0;

//         if (productId == null || quantity <= 0) continue;

//         // Fetch available batches for this product
//         final availableBatches = await FirebaseFirestore.instance
//             .collection('mmInventoryBatches')
//             .where('productId', isEqualTo: productId)
//             .where('quantityRemaining', isGreaterThan: 0)
//             .where('isActive', isEqualTo: true)
//             .orderBy('receivedDate', descending: false)
//             .get();

//         var remainingQty = quantity;
//         double itemCostReduction = 0;

//         // Allocate batches using FIFO
//         for (final batchDoc in availableBatches.docs) {
//           if (remainingQty <= 0) break;

//           final batchData = batchDoc.data();
//           final batchId = batchDoc.id;
//           final availableInBatch =
//               (batchData['quantityRemaining'] as num?)?.toInt() ?? 0;
//           final unitCost = (batchData['unitCost'] as num?)?.toDouble() ?? 0;

//           final quantityToTake =
//               remainingQty > availableInBatch ? availableInBatch : remainingQty;

//           if (quantityToTake > 0) {
//             final newQuantityRemaining = availableInBatch - quantityToTake;

//             batch.update(batchesCollection.doc(batchId), {
//               'quantityRemaining': newQuantityRemaining,
//               'isActive': newQuantityRemaining > 0,
//               'updatedAt': FieldValue.serverTimestamp(),
//             });

//             itemCostReduction += quantityToTake * unitCost;
//             remainingQty -= quantityToTake;
//           }
//         }

//         totalReduction += itemCostReduction;
//         totalQuantity += quantity;

//         // Update product stock
//         final productRef =
//             FirebaseFirestore.instance.collection('products').doc(productId);
//         batch.update(productRef, {
//           'totalStockOnHand': FieldValue.increment(-quantity),
//           'updatedAt': FieldValue.serverTimestamp(),
//         });
//       }

//       // 3. Create sale document with all data
//       batch.set(saleRef, {
//         ...saleData,
//         'status': 'completed',
//         'totalCost': totalReduction, // Actual FIFO cost
//         'totalProfit':
//             (saleData['totalRevenue'] as double? ?? 0) - totalReduction,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // 4. Create inventory logs for each product
//       final logsCollection =
//           FirebaseFirestore.instance.collection('mmInventoryLogs');

//       for (final item in items) {
//         final productId = item['productId'] as String?;
//         final quantity = (item['quantity'] as num?)?.toInt() ?? 0;

//         if (productId == null || quantity <= 0) continue;

//         // Fetch current product data for logging
//         final productDoc = await FirebaseFirestore.instance
//             .collection('products')
//             .doc(productId)
//             .get();

//         final productData = productDoc.data();
//         final previousStock =
//             (productData?['totalStockOnHand'] as num?)?.toInt() ?? 0;

//         final logRef = logsCollection.doc();
//         batch.set(logRef, {
//           'productId': productId,
//           'productName': productData?['productName'] ?? '',
//           'timestamp': FieldValue.serverTimestamp(),
//           'type': 'sale',
//           'change': -quantity,
//           'valueImpact': -totalReduction,
//           'documentId': saleRef.id,
//           'documentType': 'sale',
//           'previousStock': previousStock,
//           'newStock': previousStock - quantity,
//           'note':
//               'Sale to ${saleData['customerName']}. ${saleData['notes'] ?? ''}',
//           'createdAt': FieldValue.serverTimestamp(),
//           'saleId': saleRef.id,
//           'customerName': saleData['customerName'],
//           'quantity': quantity,
//           'unitPrice': item['unitPrice'],
//           'totalPrice': item['totalPrice'],
//         });
//       }

//       // 5. Commit all operations
//       await batch.commit();
//     } catch (e) {
//       print('Error processing sale: $e');
//       rethrow;
//     }
//   }

//   static Future<void> addProduct(ProductModel model) async {
//     await FirebaseFirestore.instance.collection('products').add({
//       ...model.toJson(),
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   // static Future<void> addPurchaseRequisition(
//   //   PurchaseRequisitionModel model,
//   // ) async {
//   //   await FirebaseFirestore.instance.collection('purchaseRequisitions').add({
//   //     ...model.toMap(),
//   //     'timestamp': FieldValue.serverTimestamp(),
//   //   });
//   // }

//   static Future<void> addPurchaseRequisition(
//     PurchaseRequisitionModel model,
//   ) async {
//     final dataToSave = {
//       'serialNumber': model.serialNumber,
//       'productId': model.productId,
//       'createdBy': model.createdBy,
//       'prioirty': model.prioirty,
//       'quantity': model.quantity,
//       'note': model.note,
//       'status': model.status ?? 'pending',
//       'subCatId': model.subCatId,
//       'brandId': model.brandId,
//       'branchId': model.branchId,
//       'category': model.category,
//       'timestamp': FieldValue.serverTimestamp(),
//     };
//     String id = FirebaseFirestore.instance.collection("purchase").doc().id;
//     await FirebaseFirestore.instance
//         .collection('purchase')
//         .doc(id)
//         .collection('purchaseRequisitions')
//         .add(dataToSave);
//   }

//   static Future<void> updateRequesition(
//     String id,
//     PurchaseRequisitionModel model,
//   ) async {
//     await FirebaseFirestore.instance
//         .collection('purchaseRequisitions')
//         .doc(id)
//         .update(model.toMap());
//   }

//   //  Order booking

//   // static Future<void> updateOrderBooking(
//   //   String id,
//   //   OrdersBookingModel model,
//   // ) async {
//   //   await FirebaseFirestore.instance
//   //       .collection('orderBookings')
//   //       .doc(id)
//   //       .update(model.toMap());
//   // }

//   // static Future<void> addOrderBooking(OrdersBookingModel model) async {
//   //   await FirebaseFirestore.instance.collection('orderBookings').add({
//   //     ...model.toMap(),
//   //     'createdAt': FieldValue.serverTimestamp(),
//   //   });
//   // }

//   // INVENTORY
//   static Future<void> updateInventory(String id, InventoryModel model) async {
//     await FirebaseFirestore.instance
//         .collection('inventory')
//         .doc(id)
//         .update(model.toJson());
//   }

//   // PRODUCTS
//   static Future<void> addProductCategory(
//     ProductCategoryModel model,
//     String docId,
//   ) async {
//     await FirebaseFirestore.instance
//         .collection('productsCategory')
//         .doc(docId)
//         .set({...model.toMap(), 'timestamp': FieldValue.serverTimestamp()});
//   }

//   static Future<void> updateProduct(String id, ProductModel model) async {
//     await FirebaseFirestore.instance
//         .collection('products')
//         .doc(id)
//         .update(model.toJson());
//   }

//   static Future<void> updateProductCategory(
//       String id, ProductCategoryModel model) async {
//     await FirebaseFirestore.instance
//         .collection('productsCategory')
//         .doc(id)
//         .update(model.toMap());
//   }

//   static Future<void> updateTruck(String id, MmtrucksModel model) async {
//     await FirebaseFirestore.instance
//         .collection('inventorytrucks')
//         .doc(id)
//         .update(model.toMap());
//   }

//   static Future<void> addTruck(MmtrucksModel model) async {
//     await FirebaseFirestore.instance.collection('mmTrucks').add({
//       ...model.toMap(),
//       'createAt': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> updateAssetsCategory(
//     String id,
//     AssetsCategoryModel model,
//   ) async {
//     await FirebaseFirestore.instance
//         .collection('assetsCategory')
//         .doc(id)
//         .update(model.toMap());
//   }

//   static Future<void> updateAssets(String id, AssetsModel model) async {
//     await FirebaseFirestore.instance
//         .collection('assets')
//         .doc(id)
//         .update(model.toMap());
//   }

//   static Future<void> addAssetsCategory(AssetsCategoryModel model) async {
//     await FirebaseFirestore.instance.collection('assetsCategory').add({
//       ...model.toMap(),
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> addAssets(AssetsModel model) async {
//     await FirebaseFirestore.instance.collection('assets').add({
//       ...model.toMap(),
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   //Employees

//   // static Future<void> updateEmployee(String id, EmployeeModel model) async {
//   //   await FirebaseFirestore.instance
//   //       .collection('employees')
//   //       .doc(id)
//   //       .update(model.toMap());
//   // }

//   // static Future<void> addEmployee(EmployeeModel model) async {
//   //   await FirebaseFirestore.instance.collection('employees').add({
//   //     ...model.toMap(),
//   //     'timestamp': FieldValue.serverTimestamp(),
//   //   });
//   // }

//   static Future<void> updateCustomer(
//     String id,
//     CustomerModel model,
//     String type,
//   ) async {
//     await FirebaseFirestore.instance.collection('customers').doc(id).update(
//           type == 'business' ? model.toBusinessMap() : model.toIndividualMap(),
//         );
//   }

//   static Future<void> addCustomer(CustomerModel model, String type) async {
//     final Map<String, dynamic> customerData =
//         type == 'business' ? model.toBusinessMap() : model.toIndividualMap();
//     await FirebaseFirestore.instance.collection('customers').add({
//       ...customerData,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   //invoice

//   static Future<void> createInvoice(InvoiceMmModel model) async {
//     await FirebaseFirestore.instance
//         .collection('mmInvoices')
//         .add(model.toMap());
//   }

//   static Future<void> updateInvoice(InvoiceMmModel model) async {
//     await FirebaseFirestore.instance
//         .collection('invoices')
//         .doc(model.id)
//         .update(model.toMap());
//   }

//   // BRANDS
//   static Future<void> addBrand(BrandModel model) async {
//     await FirebaseFirestore.instance.collection('brands').add({
//       ...model.toJson(),
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> updateBrand(String id, BrandModel model) async {
//     await FirebaseFirestore.instance
//         .collection('brands')
//         .doc(id)
//         .update(model.toJson());
//   }

//   // CATEGORIES
//   // static Future<void> addCategory(CategoryModel model) async {
//   //   await FirebaseFirestore.instance.collection('categories').add({
//   //     ...model.toJson(),
//   //     'timestamp': FieldValue.serverTimestamp(),
//   //   });
//   // }

//   // static Future<void> updateCategory(String id, CategoryModel model) async {
//   //   await FirebaseFirestore.instance
//   //       .collection('categories')
//   //       .doc(id)
//   //       .update(model.toJson());
//   // }

//   // UNITS
//   static Future<void> addUnit(UnitModel model) async {
//     await FirebaseFirestore.instance.collection('units').add({
//       ...model.toJson(),
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> updateUnit(String id, UnitModel model) async {
//     await FirebaseFirestore.instance
//         .collection('units')
//         .doc(id)
//         .update(model.toJson());
//   }

//   //Designation

//   // static Future<void> updateDesignation(
//   //   String id,
//   //   DesignationModel model,
//   // ) async {
//   //   await FirebaseFirestore.instance
//   //       .collection('designation')
//   //       .doc(id)
//   //       .update(model.toMap());
//   // }

//   // static Future<void> addDesignation(DesignationModel model) async {
//   //   await FirebaseFirestore.instance.collection('designation').add({
//   //     ...model.toMap(),
//   //     'createAt': FieldValue.serverTimestamp(),
//   //   });
//   // }

//   //SellOrder
//   // static Future<void> addSellOrder(SellOrderModel model) async {
//   //   await FirebaseFirestore.instance.collection('sellOrders').add({
//   //     ...model.toMap(),
//   //     'timestamp': FieldValue.serverTimestamp(),
//   //   });
//   // }

//   // static Future<void> updateSellOrder(String id, SellOrderModel model) async {
//   //   await FirebaseFirestore.instance
//   //       .collection('sellOrders')
//   //       .doc(id)
//   //       .update(model.toMap());
//   // }

//   //Purchase order Function
//   static Future<void> addPurchaseOrderFunction(
//     PurchaseOrderModel model,
//   ) async {
//     final dataToSave = {
//       'productId': model.productId,
//       'createdBy': model.createdBy,
//       'shipping': model.shipping,
//       'quantity': model.quantity,
//       'vendorId': model.vendorId,
//       'status': model.status ?? 'pending',
//       'subCatId': model.subCatId,
//       'branchId': model.branchId,
//       'discount': model.discount,
//       'perItem': model.perItem,
//       'subTotal': model.subTotal,
//       'totalCost': model.totalCost,
//       'orderTax': model.orderTax,
//       'referenceNo': model.referenceNo,
//       'timestamp': FieldValue.serverTimestamp(),
//       'quotationId': model.quotationId,
//       'purchaseId': model.purchaseId,
//       'poNumber': model.poNumber,
//       'requisitionNumber': model.requisitionNumber,
//       'requisitionId': model.requisitionId,
//       'productCategoryId': model.productCategoryId
//     };

//     await FirebaseFirestore.instance
//         .collection('purchase')
//         .doc(model.purchaseId)
//         .collection('purchaseOrder')
//         .add(dataToSave);
//   }

//   static Future<void> addGrn(GrnModel grn) async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception('User not authenticated');
//       }
//       String id = FirebaseFirestore.instance.collection('grns').doc().id;
//       final grnRef = FirebaseFirestore.instance.collection('grns').doc(id);

//       // Convert GRN model to a map
//       final grnData = grn.toMap();

//       // Add metadata
//       grnData['createdAt'] = FieldValue.serverTimestamp();
//       grnData['updatedAt'] = FieldValue.serverTimestamp();
//       grnData['createdByUserId'] = user.uid;

//       // Save to Firestore
//       await grnRef.set(grnData);

//       // Update the related purchase order status if needed
//       await _updatePurchaseOrderStatus(grn);

//       // Update inventory (you'll implement this separately)
//       //await _updateInventoryFromGrn(grn);
//     } catch (e) {
//       print('Error adding GRN: $e');
//       throw Exception('Failed to create GRN: $e');
//     }
//   }

//   static Future<void> _updateInventoryFromGrn(GrnModel grn) async {
//     try {
//       // Get the current inventory for this product
//       final inventoryRef =
//           FirebaseFirestore.instance.collection('inventory').doc(grn.productId);

//       final inventoryDoc = await inventoryRef.get();

//       if (inventoryDoc.exists) {
//         // Update existing inventory
//         final currentStock = inventoryDoc.data()?['quantity'] ?? 0;
//         final newStock = currentStock + grn.receivedQuantity;

//         await inventoryRef.update({
//           'quantity': newStock,
//           'lastUpdated': FieldValue.serverTimestamp(),
//           'lastGrnId': grn.id,
//         });
//       } else {
//         // Create new inventory entry
//         await inventoryRef.set({
//           'productId': grn.productId,
//           'productCode': grn.productCode,
//           'quantity': grn.receivedQuantity,
//           'createdAt': FieldValue.serverTimestamp(),
//           'lastUpdated': FieldValue.serverTimestamp(),
//           'lastGrnId': grn.id,
//           'minStockLevel': 0,
//           'maxStockLevel': 0,
//         });
//       }

//       // Create inventory transaction history
//       await FirebaseFirestore.instance.collection('inventoryTransactions').add({
//         'productId': grn.productId,
//         'grnId': grn.id,
//         'poId': grn.poId,
//         'type': 'inbound',
//         'quantity': grn.receivedQuantity,
//         // 'previousStock': inventoryDoc.exists ? inventoryDoc.data()?['quantity'] ?? 0 : 0,
//         'newStock': inventoryDoc.exists
//             ? (inventoryDoc.data()?['quantity'] ?? 0) + grn.receivedQuantity
//             : grn.receivedQuantity,
//         'timestamp': FieldValue.serverTimestamp(),
//         'createdBy': grn.createdBy,
//       });
//     } catch (e) {
//       print('Error updating inventory from GRN: $e');
//       // Don't throw here as the GRN was created successfully
//       // You might want to implement a retry mechanism for critical operations like this
//     }
//   }

//   static Future<void> _updatePurchaseOrderStatus(GrnModel grn) async {
//     try {
//       String poStatus = 'partially_received';

//       if (grn.status == 'completed') {
//         poStatus = 'fully_received';
//       }

//       await FirebaseFirestore.instance
//           .collection('purchase')
//           .doc(grn.purchaseId)
//           .collection('purchaseOrder')
//           .doc(grn.poId)
//           .update({
//         'status': poStatus,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint('Error updating PO status: $e');
//       // Don't throw here as the GRN was created successfully
//     }
//   }
// }
