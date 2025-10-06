import 'dart:math';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';

// Add SaleItem class
class SaleItemTest {
  final ProductModel product;
  int quantity;
  final double costPrice;
  double marginPercent;
  double unitPrice;
  double totalPrice;

  SaleItemTest({
    required this.product,
    required this.quantity,
    required this.costPrice,
    required this.marginPercent,
    required this.unitPrice,
    required this.totalPrice,
  });
}

class TestCreateInvoice extends StatefulWidget {
  final VoidCallback? onBack;
  final InvoiceMmModel? invoiceModel;
  final List<InventoryModel>? selectedInventory;
  final List<ProductModel>? products;

  const TestCreateInvoice({
    super.key,
    this.onBack,
    this.invoiceModel,
    this.products,
    this.selectedInventory,
  });

  @override
  TestCreateInvoicePageState createState() => TestCreateInvoicePageState();
}

class TestCreateInvoicePageState extends State<TestCreateInvoice> {
  final customerNameController = TextEditingController();
  final TextEditingController _globalMarginController = TextEditingController(
    text: '20',
  );
  final TextEditingController _searchController = TextEditingController();

  List<CustomerModel> allCustomers = [];
  List<CustomerModel> filteredCustomers = [];
  List<DiscountModel> _discounts = [];
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<SaleItemTest> selectedSaleItems = [];

  bool creditPayment = false;
  bool _isLoadingDiscounts = true;
  bool _isLoadingProducts = true;
  bool showProductSelection = true;

  double totalCost = 0;
  double totalRevenue = 0;
  double totalProfit = 0;
  double totalMargin = 0;

  int currentPage = 0;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
    _globalMarginController.addListener(_applyGlobalMargin);
    _loadInitialData();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    _searchController.removeListener(_filterProducts);
    _globalMarginController.removeListener(_applyGlobalMargin);
    _searchController.dispose();
    _globalMarginController.dispose();
    super.dispose();
  }

  void _loadInitialData() async {
    setState(() {
      _isLoadingDiscounts = true;
      _isLoadingProducts = true;
    });

    try {
      Future.wait([
        DataFetchService.fetchDiscount(),
        DataFetchService.fetchCustomers(),
        DataFetchService.fetchProducts(),
      ]).then((results) {
        setState(() {
          _discounts = results[0] as List<DiscountModel>;
          allCustomers = results[1] as List<CustomerModel>;
          allProducts = results[2] as List<ProductModel>;
          filteredProducts = allProducts;
          _isLoadingDiscounts = false;
          _isLoadingProducts = false;

          // If editing an existing invoice, populate the data
          if (widget.invoiceModel != null) {
            _populateExistingInvoiceData();
          }
        });
      });
    } catch (e) {
      setState(() {
        _isLoadingDiscounts = false;
        _isLoadingProducts = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: ${e.toString()}')),
        );
      }
    }
  }

  void _populateExistingInvoiceData() {
    final selectedCustomer = allCustomers.firstWhere(
      (c) => c.id == widget.invoiceModel!.customerId,
      //   orElse: () => CustomerModel(),
    );

    if (selectedCustomer.id != null) {
      customerNameController.text = selectedCustomer.customerName;
    }

    // Convert existing items to sale items
    if (widget.invoiceModel!.items != null && widget.products != null) {
      for (int i = 0; i < widget.invoiceModel!.items!.length; i++) {
        final item = widget.invoiceModel!.items![i];
        final product = widget.products!.firstWhere(
          (p) => p.id == item.productId,
          orElse: () => ProductModel(),
        );

        if (product.id != null) {
          final costPrice =
              widget.selectedInventory?[i].costPrice ??
              product.averageCost ??
              0;
          selectedSaleItems.add(
            SaleItemTest(
              product: product,
              quantity: item.quantity,
              costPrice: costPrice,
              marginPercent: 20, // Default margin
              unitPrice: item.perItemPrice,
              totalPrice: item.totalPrice,
            ),
          );
        }
      }
      _calculateTotals();
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((product) {
        return product.productName!.toLowerCase().contains(query) ||
            product.code!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _applyGlobalMargin() {
    final margin = double.tryParse(_globalMarginController.text) ?? 0;
    if (margin > 0) {
      setState(() {
        for (int i = 0; i < selectedSaleItems.length; i++) {
          final item = selectedSaleItems[i];
          final newUnitPrice = item.costPrice * (1 + (margin / 100));
          selectedSaleItems[i] = SaleItemTest(
            product: item.product,
            quantity: item.quantity,
            costPrice: item.costPrice,
            marginPercent: margin,
            unitPrice: newUnitPrice,
            totalPrice: newUnitPrice * item.quantity,
          );
        }
        _calculateTotals();
      });
    }
  }

  void _calculateTotals() {
    totalRevenue = selectedSaleItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    totalCost = selectedSaleItems.fold(
      0,
      (sum, item) => sum + (item.costPrice * item.quantity),
    );
    totalProfit = totalRevenue - totalCost;
    totalMargin = totalCost > 0 ? (totalProfit / totalCost) * 100 : 0;
  }

  void _addProductToSale(ProductModel product) {
    final existingIndex = selectedSaleItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      _showEditProductDialog(selectedSaleItems[existingIndex], existingIndex);
    } else {
      _showAddProductDialog(product);
    }
  }

  void _showAddProductDialog(ProductModel product) {
    final quantityController = TextEditingController(text: '1');
    final marginController = TextEditingController(
      text: _globalMarginController.text,
    );
    final costPrice = product.averageCost ?? 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final margin =
              double.tryParse(marginController.text) ??
              double.parse(_globalMarginController.text);
          final sellingPrice = costPrice * (1 + (margin / 100));
          final quantity = int.tryParse(quantityController.text) ?? 1;
          final totalPrice = sellingPrice * quantity;

          return AlertDialog(
            title: Text('Add ${product.productName} to Sale'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cost Price: OMR ${costPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                16.h,
                TextFormField(
                  controller: marginController,
                  decoration: const InputDecoration(
                    labelText: 'Margin %',
                    border: OutlineInputBorder(),
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Selling Price: OMR ${sellingPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total: OMR ${totalPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                if (quantity > (product.totalStockOnHand ?? 0))
                  Text(
                    'Insufficient stock! Available: ${product.totalStockOnHand}',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  final margin =
                      double.tryParse(marginController.text) ??
                      double.parse(_globalMarginController.text);

                  if (quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quantity must be greater than 0'),
                      ),
                    );
                    return;
                  }

                  if (quantity > (product.totalStockOnHand ?? 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Insufficient stock! Available: ${product.totalStockOnHand}',
                        ),
                      ),
                    );
                    return;
                  }

                  final unitPrice = costPrice * (1 + (margin / 100));

                  // Add the product to sale items
                  setState(() {
                    selectedSaleItems.add(
                      SaleItemTest(
                        product: product,
                        quantity: quantity,
                        costPrice: costPrice,
                        marginPercent: margin,
                        unitPrice: unitPrice,
                        totalPrice: unitPrice * quantity,
                      ),
                    );
                    _calculateTotals();
                  });

                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${product.productName} to sale'),
                    ),
                  );
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditProductDialog(SaleItemTest item, int index) {
    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );
    final marginController = TextEditingController(
      text: item.marginPercent.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final margin =
              double.tryParse(marginController.text) ?? item.marginPercent;
          final sellingPrice = item.costPrice * (1 + (margin / 100));
          final quantity =
              int.tryParse(quantityController.text) ?? item.quantity;
          final totalPrice = sellingPrice * quantity;

          return AlertDialog(
            title: Text('Edit ${item.product.productName}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cost Price: OMR ${item.costPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                16.h,
                TextFormField(
                  controller: marginController,
                  decoration: const InputDecoration(
                    labelText: 'Margin %',
                    border: OutlineInputBorder(),
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Selling Price: OMR ${sellingPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total: OMR ${totalPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                if (quantity > (item.product.totalStockOnHand ?? 0))
                  Text(
                    'Insufficient stock! Available: ${item.product.totalStockOnHand}',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  final margin = double.tryParse(marginController.text) ?? 0;

                  if (quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quantity must be greater than 0'),
                      ),
                    );
                    return;
                  }

                  if (quantity > (item.product.totalStockOnHand ?? 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Insufficient stock! Available: ${item.product.totalStockOnHand}',
                        ),
                      ),
                    );
                    return;
                  }

                  final unitPrice = item.costPrice * (1 + (margin / 100));

                  setState(() {
                    selectedSaleItems[index] = SaleItemTest(
                      product: item.product,
                      quantity: quantity,
                      costPrice: item.costPrice,
                      marginPercent: margin,
                      unitPrice: unitPrice,
                      totalPrice: unitPrice * quantity,
                    );
                    _calculateTotals();
                  });

                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Updated ${item.product.productName}'),
                    ),
                  );
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _removeProductFromSale(int index) {
    setState(() {
      final productName = selectedSaleItems[index].product.productName;
      selectedSaleItems.removeAt(index);
      _calculateTotals();

      // Show removal message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Removed $productName from sale')));
    });
  }

  void _toggleView() {
    setState(() {
      showProductSelection = !showProductSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeaderWidget(
                title: 'Create Invoice',
                buttonText: 'Back to Invoices',
                subTitle: 'Create New Invoice',
                onCreateIcon: 'assets/images/back.png',
                selectedItems: [],
                buttonWidth: 0.4,
                onCreate: widget.onBack!.call,
                onDelete: () async {},
              ),
              16.h,
              Expanded(
                child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildProductSelectionSection()),
        16.w,
        Expanded(flex: 1, child: _buildOrderSummarySection()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: _toggleView,
              text: showProductSelection
                  ? 'View Order Summary'
                  : 'View Products',
              buttonType: ButtonType.Filled,
            ),
          ],
        ),
        16.h,
        Expanded(
          child: showProductSelection
              ? _buildProductSelectionSection()
              : _buildOrderSummarySection(),
        ),
      ],
    );
  }

  Widget _buildProductSelectionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products',
            // style: AppTheme.headline.copyWith(fontSize: 18),
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomMmTextField(
                  controller: _searchController,
                  hintText: 'Search products...',
                  //  prefixIcon: const Icon(Icons.search),
                ),
              ),
              16.w,
              SizedBox(
                width: 120,
                child: CustomMmTextField(
                  controller: _globalMarginController,
                  hintText: 'Margin %',
                  //  suffixText: '%',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          16.h,
          Expanded(
            child: _isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = min(startIndex + itemsPerPage, filteredProducts.length);
    final currentProducts = filteredProducts.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: currentProducts.length,
            itemBuilder: (context, index) {
              final product = currentProducts[index];
              final saleItem = selectedSaleItems.firstWhere(
                (item) => item.product.id == product.id,
                orElse: () => SaleItemTest(
                  product: ProductModel(),
                  quantity: 0,
                  costPrice: 0,
                  marginPercent: 0,
                  unitPrice: 0,
                  totalPrice: 0,
                ),
              );

              final isSelected = saleItem.product.id != null;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: isSelected ? Colors.green[50] : null,
                child: ListTile(
                  title: Text(product.productName ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Code: ${product.code} | Stock: ${product.totalStockOnHand}',
                      ),
                      if (isSelected)
                        Text(
                          'In sale: ${saleItem.quantity} × OMR ${saleItem.unitPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  trailing: isSelected
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addProductToSale(product),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () => _addProductToSale(product),
                        ),
                  onTap: () => _addProductToSale(product),
                ),
              );
            },
          ),
        ),
        if (filteredProducts.length > itemsPerPage)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: currentPage > 0
                    ? () => setState(() => currentPage--)
                    : null,
              ),
              Text(
                'Page ${currentPage + 1} of ${(filteredProducts.length / itemsPerPage).ceil()}',
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed:
                    (currentPage + 1) * itemsPerPage < filteredProducts.length
                    ? () => setState(() => currentPage++)
                    : null,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            // style: AppTheme.headline.copyWith(fontSize: 18),
          ),
          16.h,
          CustomMmTextField(
            controller: customerNameController,
            hintText: 'Customer Name',
            // prefixIcon: const Icon(Icons.person),
          ),
          16.h,
          // DiscountSelector(
          //   discounts: _discounts,
          //   isLoading: _isLoadingDiscounts,
          //   onDiscountSelected: (discount, isApplied, percent) {
          //     // Handle discount selection
          //   },
          // ),
          16.h,
          Expanded(
            child: selectedSaleItems.isEmpty
                ? const Center(child: Text('No products added to sale'))
                : ListView.builder(
                    itemCount: selectedSaleItems.length,
                    itemBuilder: (context, index) {
                      final item = selectedSaleItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(item.product.productName ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Qty: ${item.quantity}'),
                              Text(
                                'Unit Price: OMR ${item.unitPrice.toStringAsFixed(2)}',
                              ),
                              Text(
                                'Margin: ${item.marginPercent.toStringAsFixed(1)}%',
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'OMR ${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => _removeProductFromSale(index),
                              ),
                            ],
                          ),
                          onTap: () => _showEditProductDialog(item, index),
                        ),
                      );
                    },
                  ),
          ),
          16.h,
          _buildFinancialSummary(),
          16.h,
          Row(
            children: [
              const Text('Payment Method:'),
              16.w,
              ChoiceChip(
                label: const Text('Cash'),
                selected: !creditPayment,
                onSelected: (selected) =>
                    setState(() => creditPayment = !selected),
              ),
              8.w,
              ChoiceChip(
                label: const Text('Credit'),
                selected: creditPayment,
                onSelected: (selected) =>
                    setState(() => creditPayment = selected),
              ),
            ],
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    // Save as draft functionality
                  },
                  text: 'Save as Draft',
                  buttonType: ButtonType.Filled,
                ),
              ),
              16.w,
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    // Complete sale functionality
                  },
                  text: 'Complete Sale',
                ),
              ),
              // //               //   width: double.infinity,
              // //               //   child: PrimaryButton(
              // //               //     label: 'Submit Order',
              // //               //     onPressed: provider.,
              // //               //   ),
              // //               // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Cost:'),
            Text('OMR ${totalCost.toStringAsFixed(2)}'),
          ],
        ),
        8.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Revenue:'),
            Text('OMR ${totalRevenue.toStringAsFixed(2)}'),
          ],
        ),
        8.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Profit:'),
            Text(
              'OMR ${totalProfit.toStringAsFixed(2)}',
              style: TextStyle(
                color: totalProfit >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        8.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Profit Margin:'),
            Text(
              '${totalMargin.toStringAsFixed(2)}%',
              style: TextStyle(
                color: totalMargin >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
