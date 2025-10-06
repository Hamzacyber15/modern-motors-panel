import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/estimates_models/estimates_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/maintenance_booking_models/maintenance_booking_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';

class EstimationProvider extends ChangeNotifier {
  EstimationProvider() {
    _recalculateTotals();
  }

  final GlobalKey<FormState> makeEstimateKey = GlobalKey<FormState>();
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final TextEditingController advancePaymentController =
      TextEditingController();

  final TextEditingController visitingDateController = TextEditingController();
  DateTime visitingDate = DateTime.now();

  // Selection toggle (open/close items selection)
  bool isItemsSelection = false;

  bool get getIsSelection => isItemsSelection;
  bool _isCommissionApply = false;

  bool get isCommissionApply => _isCommissionApply;

  void setIsSelection(bool value) {
    isItemsSelection = value;
    notifyListeners();
  }

  String? customerId;
  String? estimationId; // for edit
  bool _isDiscountApply = false;
  bool _isTaxApply = true;
  double _discountPercent = 0;
  double _taxPercent = 5;
  final List<InventoryModel> _selectedInventory = [];
  final List<ProductModel> _productsList = [];
  final Set<String> _selectedInventoryIds = {};
  List<ItemsModel> items = [];
  final Map<String, double> selectedServicesWithPrice = {};
  List<MapEntry<String, String>> selectedServiceNamePairs = [];
  double itemsTotal = 0;
  double servicesTotal = 0;
  double subtotal = 0;
  double total = 0;
  double discountAmount = 0;
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

    final line = ItemsModel(
      productId: inv.id!,
      quantity: 1,
      perItemPrice: inv.salePrice,
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

      final line = ItemsModel(
        productId: inv.id!,
        quantity: 1,
        perItemPrice: inv.salePrice,
        totalPrice: inv.salePrice,
      );
      items.add(line);
    }
    _recalculateTotals();
    notifyListeners();
  }

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

  void increaseQuantity({
    required BuildContext context,
    required int index,
    required InventoryModel inventory,
  }) {
    if (index < 0 || index >= items.length) return;
    if (items[index].quantity < inventory.totalItem) {
      items[index].quantity++;
      items[index].totalPrice =
          items[index].quantity * items[index].perItemPrice;
      _recalculateTotals();
    } else {
      Constants.showMessage(
        context,
        "Quantity can't be exceeded to ${inventory.totalItem}",
      );
    }
    notifyListeners();
  }

  void decreaseQuantity({required BuildContext context, required int index}) {
    if (index < 0 || index >= items.length) return;
    if (items[index].quantity > 1) {
      items[index].quantity--;
      items[index].totalPrice =
          items[index].quantity * items[index].perItemPrice;
      _recalculateTotals();
    } else {
      Constants.showMessage(
        context,
        'Quantity must be at least: ${items[index].quantity}',
      );
    }
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
  void setDiscount(
    bool value,
    DiscountModel? discount, {
    double percent = 0,
    bool isEdit = false,
  }) {
    _isDiscountApply = value;
    _discountPercent = percent;
    selectedDiscount = discount;
    if (!isEdit) _recalculateTotals();
    notifyListeners();
  }

  void setTax(bool value, [double percent = 0]) {
    _isTaxApply = value;
    _taxPercent = percent;
    _recalculateTotals();
    notifyListeners();
  }

  void setVisitingTime(DateTime dt) {
    visitingDate = dt;
    visitingDateController.text = visitingDate.formattedWithYMDHMSAM;
    notifyListeners();
  }

  // ---------- RECALC ----------
  void _recalculateTotals() {
    double it = 0;
    for (final l in items) {
      it += l.totalPrice;
    }
    itemsTotal = it;

    servicesTotal = selectedServicesWithPrice.values.fold(0.0, (a, b) => a + b);

    final base = itemsTotal + servicesTotal;

    discountAmount = 0;
    if (_isDiscountApply && _discountPercent > 0) {
      discountAmount = (base * _discountPercent) / 100;
    }
    subtotal = base - discountAmount;

    taxAmount = 0;
    if (_isTaxApply && _taxPercent > 0) {
      taxAmount = (subtotal * _taxPercent) / 100;
    }

    total = subtotal + taxAmount;
  }

  void setCustomer({required String id}) {
    customerId = id;
    notifyListeners();
  }

  void setFromEstimation(
    EstimationModel estimation, {
    required Map<String, String> servicesIdToName,
  }) {
    estimationId = estimation.id;
    // estimation number/date
    if (estimation.visitingDate != null) {
      visitingDate = estimation.visitingDate!.toDate();
      visitingDateController.text = visitingDate.formattedWithYMDHMSAM;
    }

    // Items (lines)
    items = (estimation.items ?? []).map((e) => ItemsModel.clone(e)).toList();

    // Services
    selectedServicesWithPrice.clear();
    selectedServiceNamePairs.clear();
    for (final s in (estimation.serviceTypes ?? [])) {
      selectedServicesWithPrice[s.serviceId] = s.serviceCharges;
      final name = servicesIdToName[s.serviceId] ?? s.serviceId;
      selectedServiceNamePairs.add(MapEntry(s.serviceId, name));
    }

    // Discount/Tax
    _isDiscountApply = estimation.isDiscountApplied ?? false;
    _discountPercent = estimation.discountPercent ?? 0;
    _isTaxApply = estimation.isTaxApplied ?? false;
    _taxPercent = estimation.taxPercent ?? 0;

    _recalculateTotals();
    notifyListeners();
  }

  Future<void> saveEstimation({
    required BuildContext context,
    VoidCallback? onBack,
    bool isEdit = false,
  }) async {
    try {
      if (loading.value) return;
      loading.value = true;

      // if ((generateCustomerNumberController.text).trim().isEmpty) {
      //   Constants.showMessage(context, 'Generate a estimation number first.');
      //   return;
      // }
      if (customerId == null || customerId!.isEmpty) {
        Constants.showMessage(context, 'Please select a customer.');
        return;
      }

      if (selectedServicesWithPrice.isEmpty && items.isEmpty) {
        Constants.showMessage(
          context,
          'Please add at least one item or service.',
        );
        return;
      }
      String estimateNumber = await Constants.getUniqueNumber("Estimate");
      if (estimateNumber.isEmpty) {
        estimateNumber = await Constants.getUniqueNumber("Estimate");
      }
      final estimation = EstimationModel(
        id: estimationId,
        customerNumber: estimateNumber,
        customerId: customerId ?? "",
        items: items,
        advancePercentage: double.tryParse(advancePaymentController.text),
        serviceTypes: selectedServicesWithPrice.entries
            .map(
              (e) => SelectedServiceWithPrice(
                serviceId: e.key,
                serviceCharges: e.value,
              ),
            )
            .toList(),
        visitingDate: Timestamp.fromDate(visitingDate),
        status: 'active',
        itemsTotal: itemsTotal,
        servicesTotal: servicesTotal,
        subtotal: subtotal,
        total: total,
        isDiscountApplied: _isDiscountApply,
        discountId: selectedDiscount?.id,
        discountPercent: _discountPercent,
        discountedAmount: discountAmount,
        isTaxApplied: _isTaxApply,
        taxPercent: _taxPercent,
        taxAmount: taxAmount,
      );

      final fs = FirebaseFirestore.instance;
      final batch = fs.batch();

      final estimationCol = fs.collection('estimations');

      late DocumentReference estimationDoc;
      if (isEdit && estimationId != null) {
        estimationDoc = estimationCol.doc(estimationId);
        batch.update(estimationDoc, estimation.toMap());
      } else {
        estimationDoc = estimationCol.doc(); // create new id
        estimationId = estimationDoc.id;
        batch.set(estimationDoc, {
          ...estimation.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (!context.mounted) return;
      Constants.showMessage(
        context,
        isEdit
            ? 'Estimation updated successfully'
            : 'Estimation created successfully',
      );

      clearData();
      onBack?.call();
    } catch (e) {
      if (context.mounted) {
        Constants.showMessage(context, 'Failed to save estimation: $e');
      }
    } finally {
      loading.value = false;
      notifyListeners();
    }
  }

  Future<void> pickDate({
    required BuildContext context,
    required DateTime selectedDate,
    required String type, // 'estimation'
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
      visitingDate = picked;
      visitingDateController.text = visitingDate.formattedWithDayMonthYear;
      notifyListeners();
    }
  }

  void clearData() {
    _selectedInventoryIds.clear();
    _selectedInventory.clear();
    items.clear();

    selectedServicesWithPrice.clear();
    selectedServiceNamePairs.clear();

    customerId = null;
    estimationId = null;

    visitingDate = DateTime.now();
    visitingDateController.clear();
    _isDiscountApply = false;
    _isTaxApply = true;
    _discountPercent = 0;
    _taxPercent = 5;

    itemsTotal = 0;
    servicesTotal = 0;
    subtotal = 0;
    total = 0;
    discountAmount = 0;
    taxAmount = 0;
    _isCommissionApply = false;
    selectedDiscount = DiscountModel.getDiscount();

    notifyListeners();
  }
}
