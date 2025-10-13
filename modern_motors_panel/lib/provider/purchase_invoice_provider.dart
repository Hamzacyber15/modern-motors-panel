import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/employees_commision_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_model.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/trucks/new_trucks_model.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:provider/provider.dart';

const String kIshCustomerId = 'ISH';

enum BillingParty { ish, others }

class PurchaseInvoiceProvider extends ChangeNotifier {
  PurchaseInvoiceProvider() {
    _recalculateTotals();
  }
  //ServiceTypeModel
  final GlobalKey<FormState> createBookingKey = GlobalKey<FormState>();
  final ValueNotifier<bool> loading = ValueNotifier(false);

  final TextEditingController generateBookingNumberController =
      TextEditingController();
  final TextEditingController bookingDateController = TextEditingController();
  EmployeeCommissionModel? employeeCommissionModel;
  DateTime purchaseDate = DateTime.now();
  double _servicesTotal = 0;
  double billExpenseTotal = 0;
  double _productsTotal = 0;
  double _subtotal = 0;
  double _total = 0;
  double depositAmount = 0;
  double remainingAmount = 0;
  String discountType = '';
  bool orderLoading = false;
  // Getters
  double get servicesTotal => _servicesTotal;
  double get productsTotal => _productsTotal;
  double get subtotal => _subtotal;
  bool isItemsSelection = false;
  bool get getIsSelection => isItemsSelection;
  bool _isCommissionApply = false;

  bool get isCommissionApply => _isCommissionApply;
  double _discountAmount = 0;
  double get discountAmount => _discountAmount;
  double _discountPercent = 0;
  double get discountPercent => _discountPercent;
  DateTime? paymentDate;

  void setServicesTotal(double value) {
    _servicesTotal = value;
    notifyListeners();
  }

  DateTime getDateAfterDays(int days) {
    DateTime today = DateTime.now();
    return today.add(Duration(days: days));
  }

  void setPaymentDate(int d) {
    paymentDate = getDateAfterDays(d);
  }

  void setProductsTotal(double value) {
    _productsTotal = value;
    notifyListeners();
  }

  void setSubtotal(double value) {
    _subtotal = value;
    notifyListeners();
  }

  void getValues(double tax, double gtotal) {
    taxAmount = tax;
    //  grandtotal = gtotal;
    notifyListeners();
  }

  // Update the existing setTotal method if it exists, or add it:
  void setTotal(double value) {
    // If you already have a total property, update it
    _total = value;
    notifyListeners();
  }

  void setIsSelection(bool value) {
    isItemsSelection = value;
    notifyListeners();
  }

  void setEmployeeCommissionModel(EmployeeCommissionModel? model) {
    employeeCommissionModel = model;
  }

  BillingParty _billingParty = BillingParty.others;

  BillingParty get billingParty => _billingParty;

  bool get isIsh => _billingParty == BillingParty.ish;

  void setBillingParty(BillingParty party) {
    if (_billingParty == party) return;
    _billingParty = party;

    if (party == BillingParty.ish) {
      supplierId = kIshCustomerId;
    }
    _recalculateTotals(); // totals reflect immediately
    notifyListeners();
  }

  void setCommission(bool value) {
    _isCommissionApply = value;
    notifyListeners();
  }

  void setBillingPartyFromCustomerId(String? cid) {
    final v = (cid ?? '').trim().toLowerCase();
    if (v == kIshCustomerId.toLowerCase()) {
      _billingParty = BillingParty.ish;
      supplierId = kIshCustomerId;
    } else {
      _billingParty = BillingParty.others;
      supplierId = cid;
    }
    _recalculateTotals();
    notifyListeners();
  }

  String? supplierId;
  String? purchaseId; // for edit
  bool _isDiscountApply = false;
  bool _isTaxApply = true;
  double _taxPercent = 5;
  final List<ProductModel> _productsList = [];
  final Set<String> _selectedInventoryIds = {};
  List<PurchaseItem> items = [];

  final Map<String, double> selectedServicesWithPrice = {};
  List<MapEntry<String, String>> selectedServiceNamePairs = [];

  double itemsTotal = 0;
  double grandTotal = 0;
  // double servicesTotal = 0;
  // double subtotal = 0;
  double total = 0;
  //double discountAmount = 0;
  double taxAmount = 0;
  DiscountModel? selectedDiscount;
  List<ProductModel> get productsList => _productsList;
  bool get getIsDiscountApply => _isDiscountApply;
  bool get getIsTaxApply => _isTaxApply;
  double get taxPercent => _taxPercent;

  // ---------- INVENTORY ----------
  void addInventory(InventoryModel inv, ProductModel productModel) {
    if (inv.id == null) return;
    if (_selectedInventoryIds.contains(inv.id)) return;

    _selectedInventoryIds.add(inv.id!);
    _productsList.add(productModel);

    final line = PurchaseItem(
      discount: 0,
      margin: 0,
      productName: productModel.productName!,
      sellingPrice: 0,
      minimumPrice: productModel.minimumPrice ?? 0,
      unitPrice: productModel.sellingPrice!,
      type: "product",
      productId: inv.id!,
      quantity: 1,
      cost: inv.salePrice,
      totalPrice: inv.salePrice,
    );
    items.add(line);

    _recalculateTotals();
    notifyListeners();
  }

  void setSelectedInventoryFromItems(List<InventoryModel> invs) {
    _selectedInventoryIds
      ..clear()
      ..addAll(invs.where((e) => e.id != null).map((e) => e.id!));
    _recalculateTotals();
    notifyListeners();
  }

  void removeInventory(InventoryModel inv, ProductModel productModel) {
    if (inv.id == null) return;
    _selectedInventoryIds.remove(inv.id);
    _productsList.removeWhere((product) => product.id == productModel.id);
    items.removeWhere((e) => e.productId == inv.id);
    _recalculateTotals();
    notifyListeners();
  }

  void removeAllInventory() {
    _selectedInventoryIds.clear();
    _productsList.clear();
    items.clear();
    _recalculateTotals();
    notifyListeners();
  }

  // ---------- SERVICES ----------
  void setSelectedServices(List<MapEntry<String, String>> pairs) {
    final allowed = pairs.map((e) => e.key).toSet();
    selectedServicesWithPrice.removeWhere((k, v) => !allowed.contains(k));
    selectedServiceNamePairs = List.from(pairs);
    _recalculateTotals();
    notifyListeners();
  }

  void setServicePrice(String serviceId, double price) {
    selectedServicesWithPrice[serviceId] = price;
    _recalculateTotals();
    notifyListeners();
  }

  void removeService(String serviceId) {
    selectedServiceNamePairs.removeWhere((e) => e.key == serviceId);
    selectedServicesWithPrice.remove(serviceId);
    _recalculateTotals();
    notifyListeners();
  }

  void setDiscount(
    bool value,
    DiscountModel? discount, {
    double percent = 0,
    double amount = 0,
    bool isEdit = false,
  }) {
    _isDiscountApply = value;

    if (percent > 0) {
      _discountPercent = percent;
      // Calculate discount amount based on current totals
      final base = itemsTotal + servicesTotal;
      _discountAmount = (base * percent) / 100;
    } else if (amount > 0) {
      _discountAmount = amount;
      // Calculate percentage based on current totals
      final base = itemsTotal + servicesTotal;
      _discountPercent = base > 0 ? (amount / base) * 100 : 0;
    }

    selectedDiscount = discount;

    if (!isEdit) _recalculateTotals();
    notifyListeners();
  }

  void setDiscountValue(double d) {
    _discountAmount = d;
    _recalculateTotals();
    notifyListeners();
  }

  // Add a method to handle discount percentage input
  void setDiscountPercent(double percent) {
    if (percent < 0) return;

    _isDiscountApply = percent > 0;
    _discountPercent = percent;

    // Calculate discount amount based on current totals
    final base = itemsTotal + _servicesTotal + billExpenseTotal;
    _discountAmount = (base * percent) / 100;

    _recalculateTotals();
    notifyListeners();
  }

  void setDiscountAmount(double amount) {
    if (amount < 0) return;

    _isDiscountApply = amount > 0;
    _discountAmount = amount;

    // Calculate percentage based on current totals
    final base = itemsTotal + servicesTotal;
    _discountPercent = base > 0 ? (amount / base) * 100 : 0;

    _recalculateTotals();
    notifyListeners();
  }

  void setTax(bool value, [double percent = 0]) {
    _isTaxApply = value;
    _taxPercent = percent;
    _recalculateTotals();
    notifyListeners();
  }

  void setCustomer({required String id}) {
    if (_billingParty != BillingParty.others) {
      _billingParty = BillingParty.others;
    }
    if (supplierId != id) {}
    supplierId = id;
    _recalculateTotals();
    notifyListeners();
  }

  String? get effectiveCustomerId => isIsh ? kIshCustomerId : supplierId;

  void setBookingTime(DateTime dt) {
    purchaseDate = dt;
    bookingDateController.text = purchaseDate.formattedWithYMDHMSAM;
    notifyListeners();
  }

  void generateRandomBookingNumber() {
    final random = Random();
    final rnd = 10000 + random.nextInt(90000);
    generateBookingNumberController.text = rnd.toString();
    notifyListeners();
  }

  // Update the _recalculateTotals method
  void _recalculateTotals() {
    if (isIsh) {
      itemsTotal = 0;
      // servicesTotal = 0;
      _discountAmount = 0;
      taxAmount = 0;
      //  subtotal = 0;
      total = 0;
      return;
    }
    double it = 0;
    for (final l in items) {
      it += l.totalPrice;
    }
    itemsTotal = it;
    final base = itemsTotal + servicesTotal;
    setSubtotal(base - discountAmount);

    taxAmount = 0;
    if (_isTaxApply && _taxPercent > 0) {
      taxAmount = (subtotal * _taxPercent) / 100;
    }

    total = subtotal + taxAmount;
    notifyListeners();
  }

  void toggleDiscount(bool apply) {
    _isDiscountApply = apply;

    if (!apply) {
      _discountAmount = 0;
      _discountPercent = 0;
    } else if (_discountPercent > 0) {
      // Recalculate discount amount if percentage was previously set
      final base = itemsTotal + servicesTotal;
      _discountAmount = (base * _discountPercent) / 100;
    }

    _recalculateTotals();
    notifyListeners();
  }

  void addAllInventory(
    List<InventoryModel> inventories,
    List<ProductModel> products,
  ) {
    for (final inv in inventories) {
      if (inv.id == null) continue;
      if (_selectedInventoryIds.contains(inv.id)) continue;

      _selectedInventoryIds.add(inv.id!);
      _productsList.add(
        products.firstWhere((product) => product.id == inv.productId),
      );

      // final line = ItemsModel(
      //   productId: inv.id!,
      //   quantity: 1,
      //   perItemPrice: inv.salePrice,
      //   totalPrice: inv.salePrice,
      // );
      // items.add(line);
    }
    _recalculateTotals();
    notifyListeners();
  }

  void setFromBooking(
    NewPurchaseModel purchase, {
    required Map<String, String> servicesIdToName,
  }) {
    purchaseId = purchase.id;
    setBillingPartyFromCustomerId(
      purchase.supplierId,
    ); // sets party + customerId

    // Booking number/date
    //generateBookingNumberController.text = booking.bookingNumber ?? '';
    if (purchase.createdAt != null) {
      purchaseDate = purchase.createdAt;
      bookingDateController.text = purchaseDate.formattedWithYMDHMSAM;
    }

    // Items (lines)
    items = (purchase.items).map((e) => PurchaseItem.clone(e)).toList();

    // Services
    selectedServicesWithPrice.clear();
    selectedServiceNamePairs.clear();
    // for (final s in (sale.serviceTypes ?? [])) {
    //   selectedServicesWithPrice[s.serviceId] = s.serviceCharges;
    //   final name = servicesIdToName[s.serviceId] ?? s.serviceId;
    //   selectedServiceNamePairs.add(MapEntry(s.serviceId, name));
    // }

    // Discount/Tax
    _isDiscountApply = purchase.discount == 0 ? false : true;
    _discountPercent = purchase.discountType == "percentage"
        ? purchase.discount
        : 0;
    _isTaxApply = purchase.taxAmount == 0 ? false : true;
    _taxPercent = purchase.taxAmount == 0 ? 0 : purchase.taxAmount;

    //;

    _recalculateTotals();
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> _performFifoAllocation(
    String productId,
    int quantity,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final batchesQuery = await firestore
        .collection('mmInventoryBatches')
        .where('productId', isEqualTo: productId)
        .where('isActive', isEqualTo: true)
        .where('quantityRemaining', isGreaterThan: 0)
        .orderBy('receivedDate', descending: false)
        .get();

    if (batchesQuery.docs.isEmpty) {
      throw Exception('No available batches found for product $productId');
    }

    final List<Map<String, dynamic>> batchAllocations = [];
    int remainingQuantity = quantity;

    for (final batchDoc in batchesQuery.docs) {
      if (remainingQuantity <= 0) break;

      final batchData = batchDoc.data() as Map<String, dynamic>;
      final int batchQtyRemaining = batchData['quantityRemaining'] ?? 0;
      final double unitCost = (batchData['unitCost'] ?? 0).toDouble();

      if (batchQtyRemaining > 0) {
        final int allocateQty = remainingQuantity > batchQtyRemaining
            ? batchQtyRemaining
            : remainingQuantity;

        final double allocationTotalCost = allocateQty * unitCost;

        batchAllocations.add({
          'batchId': batchDoc.id,
          'batchReference': batchData['batchReference'],
          'quantity': allocateQty,
          'unitCost': unitCost,
          'totalCost': allocationTotalCost,
          'batchQuantityRemaining': batchQtyRemaining,
        });

        remainingQuantity -= allocateQty;
      }
    }

    if (remainingQuantity > 0) {
      throw Exception(
        'Could not allocate full quantity. Only ${quantity - remainingQuantity} of $quantity could be allocated.',
      );
    }

    return batchAllocations;
  }

  dynamic _sanitizeForFirebase(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map(
          (e) => MapEntry(e.key.toString(), _sanitizeForFirebase(e.value)),
        ),
      );
    } else if (value is List) {
      return value.map(_sanitizeForFirebase).toList();
    } else if (value is FieldValue) {
      // Replace Firestore sentinel values with something serializable
      return DateTime.now().toIso8601String();
    } else {
      return value;
    }
  }

  void debugPrintMapTypes(Map<String, dynamic> map, [String prefix = '']) {
    map.forEach((key, value) {
      final type = value.runtimeType;

      if (value is Map<String, dynamic>) {
        debugPrint('$prefix$key → Map');
        debugPrintMapTypes(value, '$prefix  ');
      } else if (value is List) {
        debugPrint('$prefix$key → List');
        for (int i = 0; i < value.length; i++) {
          final element = value[i];
          debugPrint('$prefix  [$i] → ${element.runtimeType}');
          if (element is Map<String, dynamic>) {
            debugPrintMapTypes(element, '$prefix    ');
          }
        }
      } else {
        debugPrint('$prefix$key → $type : $value');
      }
    });
  }

  Future<void> _processSaleWithCloudFunction(
    String saleId,
    Map<String, dynamic> saleData,
  ) async {
    try {
      final functions = FirebaseFunctions.instance;

      final cleanSaleData = _sanitizeForFirebase(saleData);
      debugPrintMapTypes(cleanSaleData);
      debugPrint(cleanSaleData.toString());
      debugPrint(saleId);
      final Map<String, dynamic> callData = {
        'saleId': saleId,
        'saleData': cleanSaleData,
      };
      final result = await functions
          .httpsCallable(
            //'processSale',
            'saveSale',
            options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
          )
          .call(callData);

      debugPrint('Cloud Function result: ${result.data}');

      // Handle response
      final response = result.data;
      if (response is Map<String, dynamic> && response['success'] == false) {
        throw Exception(response['message'] ?? 'Sale processing failed');
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Firebase Functions Exception: ${e.code} - ${e.message}');
      throw Exception('Cloud Function Error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to process sale: $e');
    }
  }

  void updateLoadingStatus(bool status) {
    orderLoading = status;
    notifyListeners();
  }

  Future<void> savePurchase({
    required BuildContext context,
    required List<Map<String, Object?>> productsData,
    required List<Map<String, Object?>> expensesData,
    required Map<String, Object> depositData,
    required Map<String, Object> paymentData,
    //required List<Map<String, Object?>> servicesData,
    required double total,
    required double taxAmount,
    required double discount,
    required String statusType,
    VoidCallback? onBack,
    bool isEdit = false,
    NewPurchaseModel? purchase,
  }) async {
    try {
      if (loading.value) return;
      if (effectiveCustomerId == null || effectiveCustomerId!.isEmpty) {
        Constants.showMessage(context, 'Please select a customer.');
        //  loading.value = false;
        updateLoadingStatus(false);
        return;
      }
      final branch = context.read<MmResourceProvider>().getBranchByID(
        BranchIdSp.getBranchId(),
      );
      String invoiceNumber = "";
      if (purchase == null) {
        if (statusType == "draft") {
          invoiceNumber = await Constants.getUniqueNumber('purchaseDraft');
        } else if (statusType == "estimate") {
          invoiceNumber = await Constants.getUniqueNumber('EST');
        } else if (statusType == "estimateDraft") {
          invoiceNumber = await Constants.getUniqueNumber('EDraft');
        } else {
          invoiceNumber = await Constants.getUniqueNumber('purchase');
        }
      }
      final firestore = FirebaseFirestore.instance;
      String purchaseDocId = "";
      if (purchase == null) {
        final purchaseRef = firestore.collection('inventoryAdjustments').doc();
        purchaseDocId = purchaseRef.id;
      }

      final totalQuantity = productsData.fold(
        0,
        (sum, item) => sum + (item['quantity'] as int),
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      Map<String, dynamic> d = {};
      d = {
        'requireDeposit': depositData['requireDeposit'] ?? false,
        'depositType': depositData['depositType'],
        'depositAmount': depositData['depositAmount'],
        'depositPercentage': depositData['depositPercentage'],
        'depositAlreadyPaid': depositData["depositAlreadyPaid"],
        'nextPaymentAmount': depositData["nextPaymentAmount"],
      };
      String s = "";
      Map<String, dynamic> purchaseData = {};
      // if (draft != null) {
      //   s = draft;
      // } else {
      //   s = "pending";
      // }
      if (statusType == "estimate") {
        purchaseData = {
          //'draft': invoiceNumber,
          'purchaseId': purchaseDocId,
          "discountType": discountType,
          "discount": discountAmount,
          //'depositA': depositAmount,
          'remaining': remainingAmount,
          'invoice': invoiceNumber,
          'totalRevenue': 0,
          'total': total,
          //'totalCost': 0,
          //'profit': 0,
          'supplierId': supplierId,
          // 'notes': notesController.text.isNotEmpty ? notesController.text : '',
          'status': statusType, //'pending',
          'previousStock':
              0, //selectedSaleItems.first.product.totalStockOnHand,
          'paymentMethod': 'cash',
          'taxAmount': taxAmount,
          'createBy': user.uid,
          'paymentData': paymentData,
          'deposit': d,
          'items': productsData
              .map(
                (item) => {
                  'type': item['type'],
                  'productId': item["productId"],
                  'productName': item["productName"],
                  'quantity': item["quantity"],
                  'unitPrice': item["sellingPrice"] ?? 0,
                  'totalPrice': item["total"] ?? 0,
                  'discount': item['discount'] ?? 0,
                  'sellingPrice': item['sellingPrice'] ?? 0,
                },
              )
              .toList(),
        };
      } else if (statusType == "estimateDraft" || statusType == "draft") {
        purchaseData = {
          'invoice': invoiceNumber,
          'purchaseId': purchaseDocId,
          "discountType": discountType,
          "discount": discountAmount,
          'total': total,
          'remaining': remainingAmount,
          'totalRevenue': grandTotal, //totalRevenue,
          'supplierId': supplierId,
          'status': statusType, //'pending',
          'previousStock':
              0, //selectedSaleItems.first.product.totalStockOnHand,
          'paymentMethod': 'cash',
          'taxAmount': taxAmount,
          'createBy': user.uid,
          'deposit': d,
          'items': productsData
              .map(
                (item) => {
                  'type': item['type'],
                  'productId': item["productId"],
                  'productName': item["productName"],
                  'quantity': item["quantity"],
                  'unitPrice': item["sellingPrice"] ?? 0,
                  'totalPrice': item["total"] ?? 0,
                  'discount': item['discount'] ?? 0,
                  'sellingPrice': item['sellingPrice'] ?? 0,
                },
              )
              .toList(),
        };
      } else {
        purchaseData = {
          'dueDate': paymentDate,
          'branchId': branch.id,
          
          'invoice': isEdit ? purchase!.invoice : invoiceNumber,
          'purchaseId': isEdit ? purchase!.id : purchaseDocId,
          "discountType": discountType,
          "discount": discountAmount,
          //'depositA': discount,
          'remaining': remainingAmount,
          'total': total,
          // 'productId': "", //productsData[0]["productid"],
          // 'productName': "", //productsData[0]["productName"],
          //'sellingPrice': 0, //productsData[0].first.unitPrice,
          'totalRevenue': grandTotal, //totalRevenue,
          //'totalCost': 0,
          //'profit': 0,
          'supplierId': supplierId,
          // 'notes': notesController.text.isNotEmpty ? notesController.text : '',
          'status': statusType, //'pending',
          'previousStock':
              0, //selectedSaleItems.first.product.totalStockOnHand,
          'paymentMethod': 'cash',
          'taxAmount': taxAmount,
          'paymentData': paymentData,
          'deposit': d,
          'items': productsData
              .map(
                (item) => {
                  'type': item['type'],
                  'productId': item["productId"],
                  'productName': item["productName"],
                  'quantity': item["quantity"],
                  'unitPrice': item["sellingPrice"] ?? 0,
                  'totalPrice': item["total"] ?? 0,
                  'discount': item['discount'] ?? 0,
                  'sellingPrice': item['sellingPrice'] ?? 0,
                },
              )
              .toList(),
        };
      }
      if (!isEdit) {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'savePurchase',
        );
        final results = await callable({
          'purchaseId': purchaseDocId, //'000testSale',
          "purchaseData": purchaseData,
          'expenseData': expensesData,
        });
        debugPrint(results.data.toString());
      } else if (isEdit) {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'editPurchase',
        );
        final results = await callable({
          'saleId': purchase!.id, //'000testSale',
          "purchaseData": purchaseData,
        });
        debugPrint(results.data.toString());
      }

      // for (final item in productsData) {
      //   final allocations = await _performFifoAllocation(
      //       item['productId'] as String, item['quantity'] as int? ?? 0);
      //   (saleData['batchAllocations'] as List).addAll(allocations);
      // }
      //await saleRef.set(saleData);
      // ✅ Call Cloud Function to process the sale
      //await _processSaleWithCloudFunction(saleRef.id, saleData);

      // final fs = FirebaseFirestore.instance;
      // final batch = fs.batch();

      // final bookingCol = fs.collection('maintenanceBookings');

      // late DocumentReference bookingDoc;
      // if (isEdit && bookingId != null) {
      //   bookingDoc = bookingCol.doc(bookingId);
      //   batch.update(bookingDoc, booking.toMap());
      // } else {
      //   bookingDoc = bookingCol.doc(); // create new id
      //   bookingId = bookingDoc.id;
      //   batch.set(bookingDoc, booking.toMap());
      // }

      // if (employeeCommissionModel != null && isCommissionApply) {
      //   employeeCommissionModel!.bookingId = bookingId;
      //   final commissionCol = fs.collection('employeeCommissions');
      //   final commissionDoc = commissionCol.doc(); // new doc
      //   batch.set(commissionDoc, employeeCommissionModel!.toMap());
      // }

      // if (employeeCommissionModel != null && isCommissionApply) {
      //   employeeCommissionModel!.bookingId = saleId;

      //   final commissionCol = fs.collection('employeeCommissions');
      //   if ((employeeCommissionModel!.id ?? '').isEmpty) {
      //     // CREATE
      //     final commissionDoc = commissionCol.doc();
      //     employeeCommissionModel!.id = commissionDoc.id;
      //     batch.set(commissionDoc, employeeCommissionModel!.toMap());
      //   } else {
      //     // UPDATE
      //     final commissionDoc = commissionCol.doc(employeeCommissionModel!.id);
      //     batch.update(commissionDoc, employeeCommissionModel!.toMap());
      //   }
      // }
      // await batch.commit();
      if (!context.mounted) return;
      Constants.showMessage(
        context,
        isEdit
            ? 'Booking updated successfully'
            : 'Booking created successfully',
      );

      clearData();
      onBack?.call();
    } catch (e) {
      if (context.mounted) {
        debugPrint("${"sale error"} ${e.toString()}");
        Constants.showMessage(context, 'Failed to save booking: $e');
        updateLoadingStatus(false);
        onBack?.call();
      }
    } finally {
      updateLoadingStatus(false);
      notifyListeners();
    }
  }

  Future<void> pickDate({
    required BuildContext context,
    required DateTime selectedDate,
    required String type, // 'booking'
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.teal),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      purchaseDate = picked;
      bookingDateController.text = purchaseDate.formattedWithDayMonthYear;
      notifyListeners();
    }
  }

  void clearData() {
    _selectedInventoryIds.clear();
    items.clear();

    selectedServicesWithPrice.clear();
    selectedServiceNamePairs.clear();

    _billingParty = BillingParty.others; // default
    supplierId = null;
    purchaseId = null;

    purchaseDate = DateTime.now();
    bookingDateController.clear();
    generateBookingNumberController.clear();

    _isDiscountApply = false;
    _isTaxApply = true;
    _discountPercent = 0;
    _taxPercent = 5;

    itemsTotal = 0;
    // servicesTotal = 0;
    // subtotal = 0;
    total = 0;
    //  discountAmount = 0;
    taxAmount = 0;
    _isCommissionApply = false;
    employeeCommissionModel = null;
    selectedDiscount = DiscountModel.getDiscount();

    notifyListeners();
  }
}
