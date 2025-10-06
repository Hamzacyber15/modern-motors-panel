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
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/trucks/new_trucks_model.dart';

const String kIshCustomerId = 'ISH';

enum BillingParty { ish, others }

class MaintenanceBookingProvider extends ChangeNotifier {
  MaintenanceBookingProvider() {
    _recalculateTotals();
  }
  //ServiceTypeModel
  final GlobalKey<FormState> createBookingKey = GlobalKey<FormState>();
  final ValueNotifier<bool> loading = ValueNotifier(false);

  final TextEditingController generateBookingNumberController =
      TextEditingController();
  final TextEditingController bookingDateController = TextEditingController();
  EmployeeCommissionModel? employeeCommissionModel;
  DateTime saleDate = DateTime.now();
  double _servicesTotal = 0;
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

  // Selection toggle (open/close items selection)
  bool isItemsSelection = false;
  //List<ServiceLineItem> _selectedServiceLines = [];
  bool get getIsSelection => isItemsSelection;
  bool _isCommissionApply = false;

  bool get isCommissionApply => _isCommissionApply;
  double _discountAmount = 0;
  double get discountAmount => _discountAmount;
  double _discountPercent = 0;
  double get discountPercent => _discountPercent;

  // void updateServiceLines(List<ServiceLineItem> serviceLines) {
  //   _selectedServiceLines = serviceLines;
  //   notifyListeners();
  // }

  // // Clear services
  // void clearServices() {
  //   _selectedServiceLines.clear();
  //   notifyListeners();
  // }

  void setServicesTotal(double value) {
    _servicesTotal = value;
    notifyListeners();
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

  // void setDiscount(bool apply, DiscountModel? discount,
  //     {double amount = 0, double percent = 0}) {
  //   _isDiscountApply = apply;
  //   _selectedDiscount = discount;

  //   if (percent > 0) {
  //     // Calculate discount amount based on percentage
  //     _discountPercent = percent;
  //     _discountAmount = (_servicesTotal + _productsTotal) * (percent / 100);
  //   } else if (amount > 0) {
  //     // Use fixed discount amount
  //     _discountAmount = amount;
  //     _discountPercent = (_servicesTotal + _productsTotal) > 0
  //         ? (amount / (_servicesTotal + _productsTotal)) * 100
  //         : 0;
  //   }

  //   _calculateTotal();
  //   notifyListeners();
  // }

  // void _calculateTotal() {
  //   _subTotal = _servicesTotal + _productsTotal;
  //   _grandTotal = _subTotal - _discountAmount;

  //   // Ensure grand total is not negative
  //   if (_grandTotal < 0) {
  //     _grandTotal = 0;
  //   }
  // }

  BillingParty _billingParty = BillingParty.others;

  BillingParty get billingParty => _billingParty;

  bool get isIsh => _billingParty == BillingParty.ish;

  void setBillingParty(BillingParty party) {
    if (_billingParty == party) return;
    _billingParty = party;

    if (party == BillingParty.ish) {
      customerId = kIshCustomerId;
      truckId = null;
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
      customerId = kIshCustomerId;
    } else {
      _billingParty = BillingParty.others;
      customerId = cid;
    }
    _recalculateTotals();
    notifyListeners();
  }

  List<NewTruckModel> filterTrucksForParty(List<NewTruckModel> all) {
    if (isIsh) {
      final ish = kIshCustomerId.toLowerCase();
      return all
          .where((t) => ((t.ownBy)!.trim().toLowerCase()) == ish)
          .toList();
    } else {
      if (customerId == null || customerId!.isEmpty) return const [];
      return all.where((t) => t.ownById == customerId).toList();
    }
  }

  String? customerId;
  String? truckId;
  String? saleId; // for edit
  bool _isDiscountApply = false;
  bool _isTaxApply = true;

  ///double _discountPercent = 0;
  double _taxPercent = 5;
  final List<InventoryModel> _selectedInventory = [];
  final List<ProductModel> _productsList = [];
  final Set<String> _selectedInventoryIds = {};
  List<SaleItem> items = [];

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

  List<InventoryModel> get getSelectedInventory => _selectedInventory;
  List<ProductModel> get productsList => _productsList;

  Set<String> get getSelectedInventoryIds => _selectedInventoryIds;

  bool get getIsDiscountApply => _isDiscountApply;

  bool get getIsTaxApply => _isTaxApply;

  double get taxPercent => _taxPercent;

  // ---------- INVENTORY ----------
  void addInventory(InventoryModel inv, ProductModel productModel) {
    if (inv.id == null) return;
    if (_selectedInventoryIds.contains(inv.id)) return;

    _selectedInventoryIds.add(inv.id!);
    _selectedInventory.add(inv);
    _productsList.add(productModel);

    final line = SaleItem(
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

    _selectedInventory
      ..clear()
      ..addAll(invs);
    _recalculateTotals();
    notifyListeners();
  }

  // void addAllInventory(
  //   List<InventoryModel> inventories,
  //   List<ProductModel> products,
  // ) {
  //   for (final inv in inventories) {
  //     if (inv.id == null) continue;
  //     if (_selectedInventoryIds.contains(inv.id)) continue;

  //     _selectedInventoryIds.add(inv.id!);
  //     _selectedInventory.add(inv);
  //     _productsList.add(
  //       products.firstWhere((product) => product.id == inv.productId),
  //     );

  //   final line = SaleItem(
  //     discount: 0,
  //     margin: 0,
  //     productName: productModel.productName!,
  //     sellingPrice: 0,
  //     unitPrice: productModel.sellingPrice!,
  //     type: "product",
  //     productId: inv.id!,
  //     quantity: 1,
  //     cost: inv.salePrice,
  //     totalPrice: inv.salePrice,
  //   );
  //     items.add(line);
  //   }
  //   _recalculateTotals();
  //   notifyListeners();
  // }

  void removeInventory(InventoryModel inv, ProductModel productModel) {
    if (inv.id == null) return;
    _selectedInventoryIds.remove(inv.id);
    _selectedInventory.removeWhere((e) => e.id == inv.id);
    _productsList.removeWhere((product) => product.id == productModel.id);
    items.removeWhere((e) => e.productId == inv.id);
    _recalculateTotals();
    notifyListeners();
  }

  void removeAllInventory() {
    _selectedInventoryIds.clear();
    _selectedInventory.clear();
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

  // ---------- DISCOUNT / TAX ----------
  // void setDiscount(
  //   bool value,
  //   DiscountModel? discount, {
  //   double percent = 0,
  //   bool isEdit = false,
  // }) {
  //   _isDiscountApply = value;
  //   _discountPercent = percent;
  //   selectedDiscount = discount;
  //   if (!isEdit) _recalculateTotals();
  //   notifyListeners();
  // }

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

  // void setDiscountAmount(double amount) {
  //   if (amount < 0) return;

  //   _isDiscountApply = amount > 0;
  //   _discountAmount = amount;

  //   // Calculate percentage based on current totals
  //   final base = itemsTotal + servicesTotal;
  //   _discountPercent = base > 0 ? (amount / base) * 100 : 0;

  //   _recalculateTotals();
  //   notifyListeners();
  // }
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
    final base = itemsTotal + _servicesTotal;
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
    if (customerId != id) {
      truckId = null; // filter change
    }
    customerId = id;
    _recalculateTotals();
    notifyListeners();
  }

  void setTruckId(String? id) {
    truckId = id;
    notifyListeners();
  }

  String? get effectiveCustomerId => isIsh ? kIshCustomerId : customerId;

  void setBookingTime(DateTime dt) {
    saleDate = dt;
    bookingDateController.text = saleDate.formattedWithYMDHMSAM;
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

    //   servicesTotal = selectedServicesWithPrice.values.fold(0.0, (a, b) => a + b);

    final base = itemsTotal + servicesTotal;

    // DON'T reset discountAmount to 0 here - keep the existing value
    // _discountAmount = 0; // REMOVE THIS LINE

    // Only calculate discount if discount is applied and we have a percentage
    //if (_isDiscountApply && _discountPercent > 0) {
    //_discountAmount = (base * _discountPercent) / 100;
    // }

    // Ensure discount doesn't exceed the base amount
    //if (_discountAmount > base) {
    //_discountAmount = base;
    // }

    //subtotal = base - _discountAmount;
    setSubtotal(base - discountAmount);

    taxAmount = 0;
    if (_isTaxApply && _taxPercent > 0) {
      taxAmount = (subtotal * _taxPercent) / 100;
    }

    total = subtotal + taxAmount;
    notifyListeners();
  }

  // Update the setDiscountAmount method

  // Update the setDiscountPercent method
  // void setDiscountPercent(double percent) {
  //   if (percent < 0) return;

  //   _isDiscountApply = percent > 0;
  //   _discountPercent = percent;

  //   // Calculate discount amount based on current totals
  //   final base = itemsTotal + servicesTotal;
  //   _discountAmount = (base * percent) / 100;

  //   _recalculateTotals();
  //   notifyListeners();
  // }

  // Add a method to handle the discount toggle
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

  // ---------- RECALC ----------
  // void _recalculateTotals() {
  //   if (isIsh) {
  //     itemsTotal = 0;
  //     servicesTotal = 0;
  //     //  discountAmount = 0;
  //     taxAmount = 0;
  //     subtotal = 0;
  //     total = 0;
  //     return;
  //   }

  //   double it = 0;
  //   for (final l in items) {
  //     it += l.totalPrice;
  //   }
  //   itemsTotal = it;

  //   servicesTotal = selectedServicesWithPrice.values.fold(0.0, (a, b) => a + b);

  //   final base = itemsTotal + servicesTotal;

  //   //  discountAmount = 0;
  //   if (_isDiscountApply && _discountPercent > 0) {
  //     //    discountAmount = (base * _discountPercent) / 100;
  //   }
  //   subtotal = base - discountAmount;

  //   taxAmount = 0;
  //   if (_isTaxApply && _taxPercent > 0) {
  //     taxAmount = (subtotal * _taxPercent) / 100;
  //   }

  //   total = subtotal + taxAmount;
  // }

  //   void _recalculateTotals() {
  //   if (isIsh) {
  //     itemsTotal = 0;
  //     servicesTotal = 0;
  //     _discountAmount = 0; // Use the private field
  //     taxAmount = 0;
  //     subtotal = 0;
  //     total = 0;
  //     return;
  //   }

  //   double it = 0;
  //   for (final l in items) {
  //     it += l.totalPrice;
  //   }
  //   itemsTotal = it;

  //   servicesTotal = selectedServicesWithPrice.values.fold(0.0, (a, b) => a + b);

  //   final base = itemsTotal + servicesTotal;

  //   // Calculate discount amount properly
  //   _discountAmount = 0;
  //   if (_isDiscountApply && _discountPercent > 0) {
  //     _discountAmount = (base * _discountPercent) / 100;
  //   }

  //   subtotal = base - _discountAmount;

  //   taxAmount = 0;
  //   if (_isTaxApply && _taxPercent > 0) {
  //     taxAmount = (subtotal * _taxPercent) / 100;
  //   }

  //   total = subtotal + taxAmount;
  // }

  void addAllInventory(
    List<InventoryModel> inventories,
    List<ProductModel> products,
  ) {
    for (final inv in inventories) {
      if (inv.id == null) continue;
      if (_selectedInventoryIds.contains(inv.id)) continue;

      _selectedInventoryIds.add(inv.id!);
      _selectedInventory.add(inv);
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
    SaleModel sale, {
    required Map<String, String> servicesIdToName,
  }) {
    saleId = sale.id;
    setBillingPartyFromCustomerId(sale.customerName); // sets party + customerId
    truckId = sale.truckId;

    // Booking number/date
    //generateBookingNumberController.text = booking.bookingNumber ?? '';
    if (sale.createdAt != null) {
      saleDate = sale.createdAt;
      bookingDateController.text = saleDate.formattedWithYMDHMSAM;
    }

    // Items (lines)
    items = (sale.items).map((e) => SaleItem.clone(e)).toList();

    // Services
    selectedServicesWithPrice.clear();
    selectedServiceNamePairs.clear();
    // for (final s in (sale.serviceTypes ?? [])) {
    //   selectedServicesWithPrice[s.serviceId] = s.serviceCharges;
    //   final name = servicesIdToName[s.serviceId] ?? s.serviceId;
    //   selectedServiceNamePairs.add(MapEntry(s.serviceId, name));
    // }

    // Discount/Tax
    _isDiscountApply = sale.discount == 0 ? false : true;
    _discountPercent = sale.discountType == "percentage" ? sale.discount : 0;
    _isTaxApply = sale.taxAmount == 0 ? false : true;
    _taxPercent = sale.taxAmount == 0 ? 0 : sale.taxAmount;

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

  Future<void> saveBooking({
    required BuildContext context,
    required List<Map<String, Object?>> productsData,
    required Map<String, Object> depositData,
    required Map<String, Object> paymentData,
    //required List<Map<String, Object?>> servicesData,
    required double total,
    required double taxAmount,
    required double discount,
    required String statusType,
    VoidCallback? onBack,
    bool isEdit = false,
    SaleModel? sale,
  }) async {
    try {
      if (loading.value) return;
      if (effectiveCustomerId == null || effectiveCustomerId!.isEmpty) {
        Constants.showMessage(context, 'Please select a customer.');
        //  loading.value = false;
        updateLoadingStatus(false);
        return;
      }
      String invoiceNumber = "";
      if (sale == null) {
        if (statusType == "draft") {
          invoiceNumber = await Constants.getUniqueNumber('Draft');
        } else if (statusType == "estimate") {
          invoiceNumber = await Constants.getUniqueNumber('EST');
        } else if (statusType == "estimateDraft") {
          invoiceNumber = await Constants.getUniqueNumber('EDraft');
        } else {
          invoiceNumber = await Constants.getUniqueNumber('MM');
        }
      }
      final firestore = FirebaseFirestore.instance;
      String saleDocId = "";
      if (sale == null) {
        final saleRef = firestore.collection('sales').doc();
        saleDocId = saleRef.id;
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
      Map<String, dynamic> saleData = {};
      // if (draft != null) {
      //   s = draft;
      // } else {
      //   s = "pending";
      // }
      if (statusType == "estimate") {
        saleData = {
          //'draft': invoiceNumber,
          'saleId': saleDocId,
          "discountType": discountType,
          "discount": discountAmount,
          'depositA': depositAmount,
          'remaining': remainingAmount,
          'invoice': invoiceNumber,
          //'estimate': invoiceNumber,
          // 'productId': "", //productsData[0]["productid"],
          // 'productName': "", //productsData[0]["productName"],
          'quantity': totalQuantity,
          //'sellingPrice': 0, //productsData[0].first.unitPrice,
          'totalRevenue': 0,
          'total': total,
          'totalCost': 0,
          'profit': 0,
          'customerName': customerId,
          // 'notes': notesController.text.isNotEmpty ? notesController.text : '',
          'status': statusType, //'pending',
          'previousStock':
              0, //selectedSaleItems.first.product.totalStockOnHand,
          'batchAllocations': [],
          // 'createdAt': FieldValue.serverTimestamp(),
          // 'updatedAt': FieldValue.serverTimestamp(),
          'paymentMethod': 'cash',
          'taxAmount': taxAmount,
          'createBy': user.uid,
          'truckId': truckId,
          // 'serviceItems': servicesData
          //     .map((d) => {
          //           'serviceId': d["serviceId"] ?? "",
          //           'productName': d["serviceName"] ?? "",
          //           'quantity': d["quantity"] ?? 0,
          //           'sellingPrice': d["price"] ?? 0,
          //           'totalPrice': d["total"] ?? 0,
          //           'discount': d['discount'] ?? 0,
          //         })
          //     .toList(),
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
        saleData = {
          'invoice': invoiceNumber,
          'saleId': saleDocId,
          "discountType": discountType,
          "discount": discountAmount,
          'depositA': depositAmount,
          'remaining': remainingAmount,
          // 'productId': "", //productsData[0]["productid"],
          // 'productName': "", //productsData[0]["productName"],
          'quantity': totalQuantity,
          //'sellingPrice': 0, //productsData[0].first.unitPrice,
          'totalRevenue': grandTotal, //totalRevenue,
          'totalCost': 0,
          'profit': 0,
          'customerName': customerId,
          // 'notes': notesController.text.isNotEmpty ? notesController.text : '',
          'status': statusType, //'pending',
          'previousStock':
              0, //selectedSaleItems.first.product.totalStockOnHand,
          'batchAllocations': [],
          // 'createdAt': FieldValue.serverTimestamp(),
          // 'updatedAt': FieldValue.serverTimestamp(),
          'paymentMethod': 'cash',
          'taxAmount': taxAmount,
          'createBy': user.uid,
          'truckId': truckId,
          // 'serviceItems': servicesData
          //     .map((d) => {
          //           'serviceId': d["serviceId"] ?? "",
          //           'productName': d["serviceName"] ?? "",
          //           'quantity': d["quantity"] ?? 0,
          //           'sellingPrice': d["price"] ?? 0,
          //           'totalPrice': d["total"] ?? 0,
          //           'discount': d['discount'] ?? 0,
          //         })
          //     .toList(),
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
      } else {
        saleData = {
          'invoice': isEdit ? sale!.invoice : invoiceNumber,
          'saleId': isEdit ? sale!.id : saleDocId,
          "discountType": discountType,
          "discount": discountAmount,
          'depositA': discount,
          'remaining': remainingAmount,
          'total': total,
          // 'productId': "", //productsData[0]["productid"],
          // 'productName': "", //productsData[0]["productName"],
          'quantity': 0, //totalQuantity,
          //'sellingPrice': 0, //productsData[0].first.unitPrice,
          'totalRevenue': grandTotal, //totalRevenue,
          'totalCost': 0,
          'profit': 0,
          'customerName': customerId,
          // 'notes': notesController.text.isNotEmpty ? notesController.text : '',
          'status': statusType, //'pending',
          'previousStock':
              0, //selectedSaleItems.first.product.totalStockOnHand,
          'batchAllocations': [],
          // 'createdAt': FieldValue.serverTimestamp(),
          // 'updatedAt': FieldValue.serverTimestamp(),
          'paymentMethod': 'cash',
          'taxAmount': taxAmount,
          'createBy': user.uid,
          'truckId': truckId,
          // 'serviceItems': servicesData
          //     .map((d) => {
          //           'serviceId': d["serviceId"] ?? "",
          //           'productName': d["serviceName"] ?? "",
          //           'quantity': d["quantity"] ?? 0,
          //           'sellingPrice': d["price"] ?? 0,
          //           'totalPrice': d["total"] ?? 0,
          //           'discount': d['discount'] ?? 0,
          //         })
          //     .toList(),
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
          'saveSale',
        );
        final results = await callable({
          'saleId': saleDocId, //'000testSale',
          "saleData": saleData,
        });
        debugPrint(results.data.toString());
      } else {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'editSale',
        );
        final results = await callable({
          'saleId': sale!.id, //'000testSale',
          "saleData": saleData,
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
      saleDate = picked;
      bookingDateController.text = saleDate.formattedWithDayMonthYear;
      notifyListeners();
    }
  }

  void clearData() {
    _selectedInventoryIds.clear();
    _selectedInventory.clear();
    items.clear();

    selectedServicesWithPrice.clear();
    selectedServiceNamePairs.clear();

    _billingParty = BillingParty.others; // default
    customerId = null;
    truckId = null;
    saleId = null;

    saleDate = DateTime.now();
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
