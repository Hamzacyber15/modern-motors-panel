import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';

class SelectedInventoriesProvider extends ChangeNotifier {
  SelectedInventoriesProvider() {
    _recalculateInvoice();
  }

  GlobalKey<FormState> createInvoiceKey = GlobalKey<FormState>();
  InvoiceMmModel _invoiceModel = InvoiceMmModel();
  final List<InventoryModel> _selectedInventory = [];
  final List<ProductModel> _productsList = [];
  final Set<String> _selectedInventoryIds = {};
  List<ItemsModel> items = [];
  ValueNotifier<bool> loading = ValueNotifier(false);
  bool _isDiscountApply = false;
  bool isItemsSelection = false;
  bool _isTaxApply = true;
  double total = 0;
  double subTotal = 0;
  double itemsTotal = 0;
  double _discountPercent = 0;
  double _taxPercent = 5;
  String? customerId;
  String? invoiceId;

  DiscountModel? selectedDiscount;
  TextEditingController generateInvoiceNumberController =
      TextEditingController();
  TextEditingController invoiceDateController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  TextEditingController paymentTermsController = TextEditingController();
  DateTime issueDate = DateTime.now();
  DateTime selectDate = DateTime.now();
  DateTime invoiceDate = DateTime.now();
  double _totalRevenue = 0;
  double _totalCost = 0;

  List<InventoryModel> get getSelectedInventory => _selectedInventory;
  List<ProductModel> get productsList => _productsList;

  Set<String> get getSelectedInventoryIds => _selectedInventoryIds;

  InvoiceMmModel get getInvoiceModelValue => _invoiceModel;

  bool get getIsDiscountApply => _isDiscountApply;

  bool get getIsTaxApply => _isTaxApply;

  void updateTotals(double revenue, double cost) {
    _totalRevenue = revenue;
    _totalCost = cost;
    notifyListeners();
  }

  void addInventory(InventoryModel inventory, ProductModel productModel) {
    _selectedInventoryIds.add(inventory.id!);
    _selectedInventory.add(inventory);
    _productsList.add(productModel);
    ItemsModel itemsModel = ItemsModel(
      productId: inventory.id!,
      quantity: 1,
      perItemPrice: inventory.salePrice,
      totalPrice: inventory.salePrice,
    );
    total += (inventory.salePrice * itemsModel.quantity);
    subTotal += (inventory.salePrice * itemsModel.quantity);
    itemsTotal += (inventory.salePrice * itemsModel.quantity);
    items.add(itemsModel);
    _invoiceModel = InvoiceMmModel(
      items: items,
      total: total,
      discountPercent: 0,
      itemsTotal: itemsTotal,
      discountedAmount: 0,
      taxAmount: 0,
      taxPercent: 0,
      isTaxApplied: true,
      isDiscountApplied: false,
      subtotal: subTotal,
    );
    _recalculateInvoice();
    notifyListeners();
  }

  void _recalculateInvoice() {
    double subtotal = 0;
    double itemstotal = 0;

    for (var item in items) {
      subtotal += item.totalPrice;
      itemstotal += item.totalPrice;
    }

    subTotal = subtotal;
    itemsTotal = itemstotal;
    double discountAmount = 0;
    double taxAmount = 0;

    if (_isDiscountApply && _discountPercent > 0) {
      discountAmount = (subTotal * _discountPercent) / 100;
    }
    subTotal = subtotal - discountAmount;

    if (_isTaxApply && _taxPercent > 0) {
      taxAmount = (subTotal * _taxPercent) / 100;
    }

    total = subTotal + taxAmount;

    _invoiceModel = InvoiceMmModel(
      items: items,
      subtotal: subTotal,
      discountPercent: _discountPercent,
      discountedAmount: discountAmount,
      taxPercent: _taxPercent,
      taxAmount: taxAmount,
      itemsTotal: itemsTotal,
      total: total,
      isDiscountApplied: _isDiscountApply,
      isTaxApplied: _isTaxApply,
    );
  }

  void setIsSelection(bool value) {
    isItemsSelection = value;
    notifyListeners();
  }

  void setDiscount(
    bool value,
    DiscountModel? discount, {
    double percent = 0,
    bool isEdit = false,
  }) {
    _isDiscountApply = value;
    _discountPercent = percent;
    selectedDiscount = discount;
    if (!isEdit) {
      _recalculateInvoice();
    }

    notifyListeners();
  }

  void setTax(bool value, [double percent = 0]) {
    _isTaxApply = value;
    _taxPercent = percent;
    _recalculateInvoice();
    notifyListeners();
  }

  void addAllInventory(
    List<InventoryModel> inventories,
    List<ProductModel> products,
  ) {
    for (var inventory in inventories) {
      if (!_selectedInventoryIds.contains(inventory.id)) {
        _selectedInventoryIds.add(inventory.id!);
        _selectedInventory.add(inventory);
        _productsList.add(
          products.firstWhere((product) => product.id == inventory.productId),
        );

        ItemsModel item = ItemsModel(
          productId: inventory.id!,
          quantity: 1,
          perItemPrice: inventory.salePrice,
          totalPrice: inventory.salePrice,
        );

        total += item.totalPrice;
        subTotal += item.totalPrice;
        itemsTotal += item.totalPrice;
        items.add(item);
      }
    }

    _invoiceModel = InvoiceMmModel(
      items: items,
      total: total,
      discountPercent: 0,
      discountedAmount: 0,
      taxAmount: 0,
      taxPercent: 0,
      itemsTotal: itemsTotal,
      isTaxApplied: false,
      subtotal: subTotal,
    );

    notifyListeners();
  }

  void setInvoice(InvoiceMmModel invoice) {
    _invoiceModel = invoice;
    // Set Invoice Info
    generateInvoiceNumberController.text = invoice.invoiceNumber ?? '';
    paymentTermsController.text = invoice.paymentTermsInDays?.toString() ?? '';

    // Set Dates
    if (invoice.invoiceDate != null) {
      invoiceDate = invoice.invoiceDate!.toDate();
      invoiceDateController.text = invoiceDate.formattedWithDayMonthYear;
    }

    if (invoice.issueDate != null) {
      issueDate = invoice.issueDate!.toDate();
      issueDateController.text = issueDate.formattedWithDayMonthYear;
    }

    // if (inventories.isNotEmpty) {
    //   _selectedInventory.clear();
    //   _selectedInventoryIds.clear();
    //   debugPrint('Adding inventories to selected inventory$inventories');
    //   for (var inv in inventories) {
    //     debugPrint('inventory: ${inv.toJson()},');
    //   }
    //   _selectedInventory.addAll(inventories);
    //   debugPrint('_selectedInventory$_selectedInventory');
    // }

    // Payment Date is calculated again from invoiceDate + paymentTermsInDays
    final inDays = invoice.paymentTermsInDays ?? 0;
    _invoiceModel.paymentDate = Timestamp.fromDate(
      invoiceDate.add(Duration(days: inDays)),
    );

    // Set customer & sales
    customerId = invoice.customerId;
    invoiceId = invoice.id;
    _invoiceModel.salesPersonId = invoice.salesPersonId;
    _invoiceModel.status = invoice.status;

    // Set Items
    items = (invoice.items ?? []).map((e) => ItemsModel.clone(e)).toList();

    _isDiscountApply = invoice.isDiscountApplied ?? false;
    _discountPercent = invoice.discountPercent ?? 0;

    // Set Tax
    _isTaxApply = invoice.isTaxApplied ?? false;
    _taxPercent = invoice.taxPercent ?? 0;

    subTotal = 0;
    total = 0;
    itemsTotal = 0;
    invoice.itemsTotal = 0;
    invoice.subtotal = 0;
    invoice.total = 0;

    // Recalculate Totals
    _recalculateInvoice();

    notifyListeners();
  }

  void removeInventory(InventoryModel inventory, ProductModel productModel) {
    _selectedInventoryIds.remove(inventory.id!);
    _selectedInventory.removeWhere((item) => item.id == inventory.id);
    _productsList.removeWhere((product) => product.id == productModel.id);
    // 2. Remove from items list
    final removedItem = items.firstWhere(
      (item) => item.productId == inventory.id!,
      orElse: () => ItemsModel(
        productId: '',
        quantity: 0,
        perItemPrice: 0,
        totalPrice: 0,
      ),
    );

    if (removedItem.productId != '') {
      total -= removedItem.totalPrice;
      subTotal -= removedItem.totalPrice;
      itemsTotal -= removedItem.totalPrice;
      items.removeWhere((item) => item.productId == inventory.id!);
    }

    // 3. Rebuild _invoiceModel
    _invoiceModel = InvoiceMmModel(
      items: items,
      total: total,
      itemsTotal: itemsTotal,
      discountPercent: 0,
      discountedAmount: 0,
      taxPercent: 0,
      taxAmount: 0,
      isTaxApplied: false,
      subtotal: subTotal,
    );
    notifyListeners();
  }

  // void removeAllInventory() {
  //   _selectedInventoryIds.clear();
  //   _selectedInventory.clear();
  //   _invoiceModel = InvoiceModel();
  //   total = 0;
  //   subTotal = 0;
  //   items.clear();
  //   notifyListeners();
  // }

  void removeAllInventory() {
    _selectedInventoryIds.clear();
    _selectedInventory.clear();
    _productsList.clear();
    invoiceDate = DateTime.now();
    issueDate = DateTime.now();
    items.clear();
    _isDiscountApply = false;
    _isTaxApply = false;
    total = 0;
    subTotal = 0;
    itemsTotal = 0;
    _discountPercent = 0;
    _taxPercent = 0;
    selectedDiscount = DiscountModel.getDiscount();
    generateInvoiceNumberController.clear();
    invoiceDateController.clear();
    issueDateController.clear();
    paymentTermsController.clear();
    _invoiceModel = InvoiceMmModel(
      items: [],
      total: 0,
      discountPercent: 0,
      discountedAmount: 0,
      taxPercent: 0,
      taxAmount: 0,
      isTaxApplied: false,
      subtotal: 0,
    );

    notifyListeners();
  }

  void increaseQuantity({
    required BuildContext context,
    required int index,
    required InventoryModel inventory,
  }) {
    if (_invoiceModel.items![index].quantity < inventory.totalItem) {
      _invoiceModel.items![index].quantity++;
      _invoiceModel.items![index].totalPrice =
          _invoiceModel.items![index].quantity *
          _invoiceModel.items![index].perItemPrice;
      _recalculateInvoice();
    } else {
      Constants.showMessage(
        context,
        "Quantity can't be exceeded to ${inventory.totalItem} ",
      );
    }
    notifyListeners();
  }

  void decreaseQuantity({required BuildContext context, required int index}) {
    if (_invoiceModel.items![index].quantity > 1) {
      _invoiceModel.items![index].quantity--;
      _invoiceModel.items![index].totalPrice =
          _invoiceModel.items![index].quantity *
          _invoiceModel.items![index].perItemPrice;
      _recalculateInvoice();
    } else {
      Constants.showMessage(
        context,
        'Quantity must be at least: ${_invoiceModel.items![index].quantity}',
      );
    }

    notifyListeners();
  }

  Future<void> pickDate({
    required BuildContext context,
    required DateTime selectedDate,
    required String type,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // header color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;

      if (type == 'invoice') {
        invoiceDateController.text = selectedDate.formattedWithDayMonthYear;
        invoiceDate = selectedDate;
        _invoiceModel.invoiceDate = Timestamp.fromDate(selectedDate);
      } else if (type == 'issue') {
        issueDateController.text = selectedDate.formattedWithDayMonthYear;
        issueDate = selectedDate;
        _invoiceModel.issueDate = Timestamp.fromDate(selectedDate);
      } else {
        selectDate = selectedDate;
      }
      notifyListeners();
    }
  }

  void createInvoices(
    BuildContext context,
    VoidCallback onBack,
    bool isEdit,
  ) async {
    try {
      if (loading.value) return;

      loading.value = true;
      int inDays = int.tryParse(paymentTermsController.text) ?? 0;
      String? salesPerson = FirebaseAuth.instance.currentUser!.uid;

      _invoiceModel.invoiceNumber = generateInvoiceNumberController.text;
      _invoiceModel.paymentTermsInDays = inDays;
      _invoiceModel.salesPersonId = salesPerson;
      _invoiceModel.paymentDate = Timestamp.fromDate(
        invoiceDate.add(Duration(days: inDays)),
      );
      _invoiceModel.invoiceDate = Timestamp.fromDate(invoiceDate);
      _invoiceModel.issueDate = Timestamp.fromDate(issueDate);
      _invoiceModel.customerId = customerId;
      _invoiceModel.discountId = selectedDiscount!.id;
      _invoiceModel.status = 'active';

      if (isEdit) {
        _invoiceModel.id = invoiceId!;
        await DataUploadService.updateInvoice(_invoiceModel)
            .then((_) {
              if (!context.mounted) return;
              Constants.showMessage(context, 'Invoice Updated successfully');
              clearData();
              onBack();
              // widget.onBack?.call();
            })
            .catchError((error) {
              if (context.mounted) {
                Constants.showMessage(context, 'Failed to updated Invoice');
              }
            });
      } else {
        await DataUploadService.createInvoice(_invoiceModel)
            .then((_) {
              if (!context.mounted) return;
              Constants.showMessage(context, 'Invoice created successfully');
              clearData();
              onBack();
              // widget.onBack?.call();
            })
            .catchError((error) {
              if (context.mounted) {
                Constants.showMessage(context, 'Failed to Create Invoice');
              }
            });
      }
    } catch (e) {
      if (context.mounted) {
        Constants.showMessage(context, 'Failed to Create Invoice: $e');
      }
    } finally {
      loading.value = false;
    }
    notifyListeners();
  }

  void clearData() {
    _selectedInventoryIds.clear();
    _selectedInventory.clear();
    invoiceDate = DateTime.now();
    issueDate = DateTime.now();
    items.clear();
    _isDiscountApply = false;
    _isTaxApply = true;
    total = 0;
    subTotal = 0;
    itemsTotal = 0;
    _discountPercent = 0;
    _taxPercent = 5;

    selectedDiscount = DiscountModel.getDiscount();
    generateInvoiceNumberController.clear();
    invoiceDateController.clear();
    issueDateController.clear();
    paymentTermsController.clear();
    _invoiceModel = InvoiceMmModel(
      items: [],
      total: 0,
      discountPercent: 0,
      discountedAmount: 0,
      isTaxApplied: true,
      subtotal: 0,
    );
    notifyListeners();
  }
}
