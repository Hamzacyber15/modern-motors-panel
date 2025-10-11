import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/billing/create_bill.dart';
import 'package:modern_motors_panel/modern_motors/products/add_edit_product.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/mmLoading_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/provider/selected_inventories_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:provider/provider.dart';

class BanksTreasury extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const BanksTreasury({super.key, this.onNavigate});

  @override
  State<BanksTreasury> createState() => _BanksTreasuryState();
}

class _BanksTreasuryState extends State<BanksTreasury> {
  bool showInventoryList = true;
  bool isLoading = true;
  bool isAddInInvoice = false;
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';

  ProductModel? productBeingEdited;
  List<ProductModel> allProducts = [];
  List<ProductModel> displayedProducts = [];
  List<BrandModel> brands = [];
  List<ProductCategoryModel> productsCategories = [];
  List<UnitModel> units = [];
  List<ProductSubCategoryModel> subCategories = [];
  List<BranchModel> branches = [];
  List<VendorModel> vendors = [];

  // Enhanced Filter variables
  bool showFilters = false;
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedBrand;
  StockFilterStatus stockFilterStatus = StockFilterStatus.all;
  bool showInactive = false;

  // Filter badge counter
  int get activeFilterCount {
    int count = 0;
    if (selectedCategory != null) count++;
    if (selectedSubCategory != null) count++;
    if (selectedBrand != null) count++;
    if (stockFilterStatus != StockFilterStatus.all) count++;
    if (showInactive) count++;
    return count;
  }

  final headers = [
    'Product Code'.tr(),
    'Product Name'.tr(),
    'Brand'.tr(),
    'Product Cat'.tr(),
    'Sub Category'.tr(),
    'Threshold'.tr(),
    "Stock in Hand".tr(),
    "Avg Cost".tr(),
    'Create On'.tr(),
    'last updated'.tr(),
  ];

  List<List<dynamic>> getRowsForExcel(List<ProductModel> inventories) {
    return inventories.map((v) {
      final brand = brands.firstWhere(
        (b) => b.id == v.brandId,
        orElse: () => BrandModel(name: ''),
      );
      final product = productsCategories.firstWhere(
        (p) => p.id == v.categoryId,
        orElse: () => ProductCategoryModel(productName: ''),
      );
      final subCat = subCategories.firstWhere(
        (s) => s.id == v.subCategoryId,
        orElse: () => ProductSubCategoryModel(name: ''),
      );

      return [
        v.code ?? '',
        v.productName ?? '',
        brand.name,
        product.productName,
        subCat.name,
        v.threshold ?? '',
        v.createAt?.toDate().formattedWithDayMonthYear ?? '',
      ];
    }).toList();
  }

  int currentPage = 0;
  int itemsPerPage = 10;

  Future<void> _deleteSelectedItems() async {
    final provider = context.read<SelectedInventoriesProvider>();
    final selectedIds = provider.getSelectedInventoryIds.toList();
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedIds.length,
    );

    if (confirm != true) return;

    for (String id in selectedIds) {
      await FirebaseFirestore.instance.collection('inventory').doc(id).delete();
    }

    provider.removeAllInventory();
    await _loadInventory();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SelectedInventoriesProvider>();
      provider.clearData();
    });
    _loadInventory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterProducts();
    });
  }

  void _filterProducts() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = allProducts;
    } else {
      _filteredProducts = allProducts.where((product) {
        final searchLower = _searchQuery.toLowerCase();

        // Get brand name
        final brand = brands.firstWhere(
          (b) => b.id == product.brandId,
          orElse: () => BrandModel(name: ''),
        );

        // Get category name
        final category = productsCategories.firstWhere(
          (c) => c.id == product.categoryId,
          orElse: () => ProductCategoryModel(productName: ''),
        );

        // Get subcategory name
        final subCategory = subCategories.firstWhere(
          (s) => s.id == product.subCategoryId,
          orElse: () => ProductSubCategoryModel(name: ''),
        );

        return (product.productName?.toLowerCase().contains(searchLower) ??
                false) ||
            (product.code?.toLowerCase().contains(searchLower) ?? false) ||
            (brand.name.toLowerCase().contains(searchLower)) ||
            (category.productName.toLowerCase().contains(searchLower)) ||
            (subCategory.name.toLowerCase().contains(searchLower)) ||
            (product.status?.toLowerCase().contains(searchLower) ?? false) ||
            (product.description?.toLowerCase().contains(searchLower) ??
                false) ||
            (product.createdBy?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }
  }

  Future<void> _loadInventory() async {
    setState(() {
      isLoading = true;
    });
    Future.wait([
      DataFetchService.fetchProducts(),
      DataFetchService.fetchUnits(),
      DataFetchService.fetchProduct(),
      DataFetchService.fetchSubCategories(),
      DataFetchService.fetchBrands(),
      DataFetchService.fetchBranches(),
      DataFetchService.fetchVendor(),
    ]).then((results) {
      setState(() {
        allProducts = results[0] as List<ProductModel>;
        _filteredProducts = allProducts;
        displayedProducts = allProducts;
        units = results[1] as List<UnitModel>;
        productsCategories = results[2] as List<ProductCategoryModel>;
        subCategories = results[3] as List<ProductSubCategoryModel>;
        brands = results[4] as List<BrandModel>;
        branches = results[5] as List<BranchModel>;
        vendors = results[6] as List<VendorModel>;
        isLoading = false;
      });
    });
  }

  void _applyFilters() {
    setState(() {
      displayedProducts = allProducts.where((product) {
        // Category filter
        if (selectedCategory != null &&
            product.categoryId != selectedCategory) {
          return false;
        }

        // Subcategory filter
        if (selectedSubCategory != null &&
            product.subCategoryId != selectedSubCategory) {
          return false;
        }

        // Brand filter
        if (selectedBrand != null && product.brandId != selectedBrand) {
          return false;
        }

        // Stock status filter
        final stock = product.totalStockOnHand ?? 0;
        final threshold = product.threshold ?? 0;

        switch (stockFilterStatus) {
          case StockFilterStatus.outOfStock:
            if (stock > 0) return false;
            break;
          case StockFilterStatus.lowStock:
            if (stock > threshold || stock <= 0) return false;
            break;
          case StockFilterStatus.inStock:
            if (stock <= threshold) return false;
            break;
          case StockFilterStatus.negativeStock:
            if (stock >= 0) return false;
            break;
          case StockFilterStatus.all:
            break;
        }

        // Inactive products filter
        if (!showInactive && product.status != "active") {
          return false;
        }

        return true;
      }).toList();

      currentPage = 0;
    });
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedSubCategory = null;
      selectedBrand = null;
      stockFilterStatus = StockFilterStatus.all;
      showInactive = false;
      displayedProducts = allProducts;
      currentPage = 0;
    });
  }

  void _showAdvancedFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => ProductFilterDialog(
        currentFilters: ProductFilters(
          categoryId: selectedCategory,
          subCategoryId: selectedSubCategory,
          brandId: selectedBrand,
          stockStatus: stockFilterStatus,
          showInactive: showInactive,
        ),
        categories: productsCategories,
        subCategories: subCategories,
        brands: brands,
        onApplyFilters: (newFilters) {
          setState(() {
            selectedCategory = newFilters.categoryId;
            selectedSubCategory = newFilters.subCategoryId;
            selectedBrand = newFilters.brandId;
            stockFilterStatus = newFilters.stockStatus;
            showInactive = newFilters.showInactive;
          });
          _applyFilters();
        },
        onClearFilters: _clearFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = displayedProducts
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    if (isLoading) {
      return const Center(child: MmloadingWidget());
    } else {
      return Consumer<SelectedInventoriesProvider>(
        builder: (context, selectedInventories, child) {
          if (isAddInInvoice) {
            return CreateBill(
              onBack: () async {
                await _loadInventory();
                setState(() {
                  isAddInInvoice = false;
                });
              },
            );
          } else {
            if (showInventoryList) {
              return Column(
                children: [
                  PageHeaderWidget(
                    title: 'Products'.tr(),
                    buttonText: "Create Product".tr(),
                    subTitle: "Manage your products".tr(),
                    selectedItems: selectedInventories.getSelectedInventoryIds
                        .toList(),
                    onCreate: () async {
                      setState(() {
                        showInventoryList = false;
                      });
                    },
                    buttonWidth: 0.28,
                    onDelete: _deleteSelectedItems,
                    onRefresh: _loadInventory,
                    onImport: () {},
                    // Add professional filter button
                    //additionalButton: _buildProfessionalFilterButton(),
                  ),

                  // Quick stock status chips
                  _buildQuickFilterChips(),

                  allProducts.isEmpty
                      ? EmptyWidget(
                          text: "There's no Inventories available".tr(),
                        )
                      : Expanded(
                          child: Column(
                            children: [
                              // Results count with filter info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.all(16),
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search by product name, code, brand, category, description, or created by...',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade500,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 20,
                                            color: Colors.grey.shade400,
                                          ),
                                          suffixIcon: _searchQuery.isNotEmpty
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.clear,
                                                    size: 20,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  onPressed: () {
                                                    _searchController.clear();
                                                  },
                                                )
                                              : null,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _buildResultsHeader(),
                                  _buildProfessionalFilterButton(),
                                  const SizedBox(width: 10),
                                ],
                              ),

                              // Products list
                              Expanded(
                                child: ProductListView(
                                  products: pagedItems,
                                  brands: brands,
                                  categories: productsCategories,
                                  subCategories: subCategories,
                                  selectedIds: selectedInventories
                                      .getSelectedInventoryIds,
                                  tapped: _loadInventory,
                                  onSelectChanged: (isSelected, product) {
                                    // _loadInventory();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                  displayedProducts.length > itemsPerPage
                      ? Align(
                          alignment: Alignment.center,
                          child: PaginationWidget(
                            currentPage: currentPage,
                            totalItems: displayedProducts.length,
                            itemsPerPage: itemsPerPage,
                            onPageChanged: (newPage) {
                              setState(() {
                                currentPage = newPage;
                              });
                            },
                            onItemsPerPageChanged: (newLimit) {
                              setState(() {
                                itemsPerPage = newLimit;
                              });
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            } else {
              return AddEditProduct(
                isEdit: productBeingEdited != null,
                productModel: productBeingEdited,
                onBack: () async {
                  await _loadInventory();
                  setState(() {
                    showInventoryList = true;
                    productBeingEdited = null;
                  });
                },
              );
            }
          }
        },
      );
    }
  }

  Widget _buildProfessionalFilterButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showAdvancedFilterDialog,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Icon(Icons.filter_alt, color: Colors.white, size: 20),
                    if (activeFilterCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            activeFilterCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                Text(
                  'Filters'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStockChip(StockFilterStatus.all, 'All Products'.tr()),
            _buildStockChip(StockFilterStatus.inStock, 'In Stock'.tr()),
            _buildStockChip(StockFilterStatus.lowStock, 'Low Stock'.tr()),
            _buildStockChip(StockFilterStatus.outOfStock, 'Out of Stock'.tr()),
            _buildStockChip(
              StockFilterStatus.negativeStock,
              'Negative Stock'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockChip(StockFilterStatus status, String label) {
    final isSelected = stockFilterStatus == status;
    final color = _getStockStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            stockFilterStatus = selected ? status : StockFilterStatus.all;
          });
          _applyFilters();
        },
        checkmarkColor: Colors.white,
        selectedColor: color,
        backgroundColor: color.withOpacity(0.1),
        shape: StadiumBorder(
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
        avatar: isSelected
            ? Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${displayedProducts.length} ${'products found'.tr()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (displayedProducts.length != allProducts.length)
            TextButton.icon(
              onPressed: _clearFilters,
              icon: Icon(Icons.clear, size: 16),
              label: Text('Clear Filters'.tr()),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade600),
            ),
        ],
      ),
    );
  }

  Color _getStockStatusColor(StockFilterStatus status) {
    switch (status) {
      case StockFilterStatus.outOfStock:
        return Colors.red;
      case StockFilterStatus.lowStock:
        return Colors.orange;
      case StockFilterStatus.inStock:
        return Colors.green;
      case StockFilterStatus.negativeStock:
        return Colors.purple;
      case StockFilterStatus.all:
        return Theme.of(context).primaryColor;
    }
  }
}

// Enhanced Filter Dialog
class ProductFilterDialog extends StatefulWidget {
  final ProductFilters currentFilters;
  final List<ProductCategoryModel> categories;
  final List<ProductSubCategoryModel> subCategories;
  final List<BrandModel> brands;
  final Function(ProductFilters) onApplyFilters;
  final VoidCallback onClearFilters;

  const ProductFilterDialog({
    super.key,
    required this.currentFilters,
    required this.categories,
    required this.subCategories,
    required this.brands,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  late ProductFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Products'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Filter Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stock Status
                    _buildFilterSection(
                      title: 'Stock Status',
                      child: Column(
                        children: [
                          _buildRadioTile(
                            StockFilterStatus.all,
                            'All Products',
                          ),
                          _buildRadioTile(
                            StockFilterStatus.inStock,
                            'In Stock',
                          ),
                          _buildRadioTile(
                            StockFilterStatus.lowStock,
                            'Low Stock',
                          ),
                          _buildRadioTile(
                            StockFilterStatus.outOfStock,
                            'Out of Stock',
                          ),
                          _buildRadioTile(
                            StockFilterStatus.negativeStock,
                            'Negative Stock',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Category
                    _buildFilterSection(
                      title: 'Category',
                      child: DropdownButtonFormField<String>(
                        value: _filters.categoryId,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Categories'.tr()),
                          ),
                          ...widget.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(category.productName ?? ''),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filters = _filters.copyWith(categoryId: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subcategory
                    _buildFilterSection(
                      title: 'Subcategory',
                      child: DropdownButtonFormField<String>(
                        value: _filters.subCategoryId,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Subcategories'.tr()),
                          ),
                          ...widget.subCategories
                              .where(
                                (subCat) =>
                                    _filters.categoryId == null ||
                                    subCat.catId == _filters.categoryId,
                              )
                              .map((subCategory) {
                                return DropdownMenuItem(
                                  value: subCategory.id,
                                  child: Text(subCategory.name ?? ''),
                                );
                              }),
                        ],
                        onChanged: _filters.categoryId != null
                            ? (value) {
                                setState(() {
                                  _filters = _filters.copyWith(
                                    subCategoryId: value,
                                  );
                                });
                              }
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Brand
                    _buildFilterSection(
                      title: 'Brand',
                      child: DropdownButtonFormField<String>(
                        value: _filters.brandId,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Brands'.tr()),
                          ),
                          ...widget.brands.map((brand) {
                            return DropdownMenuItem(
                              value: brand.id,
                              child: Text(brand.name ?? ''),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filters = _filters.copyWith(brandId: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Inactive Products
                    _buildFilterSection(
                      title: 'Status',
                      child: SwitchListTile(
                        title: Text('Show Inactive Products'.tr()),
                        value: _filters.showInactive,
                        onChanged: (value) {
                          setState(() {
                            _filters = _filters.copyWith(showInactive: value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onClearFilters();
                      Navigator.pop(context);
                    },
                    child: Text('Clear All'.tr()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(_filters);
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filters'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.tr(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildRadioTile(StockFilterStatus status, String label) {
    return RadioListTile<StockFilterStatus>(
      title: Text(label.tr()),
      value: status,
      groupValue: _filters.stockStatus,
      onChanged: (value) {
        setState(() {
          _filters = _filters.copyWith(stockStatus: value!);
        });
      },
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// Enums and Models
enum StockFilterStatus { all, inStock, lowStock, outOfStock, negativeStock }

class ProductFilters {
  final String? categoryId;
  final String? subCategoryId;
  final String? brandId;
  final StockFilterStatus stockStatus;
  final bool showInactive;

  const ProductFilters({
    this.categoryId,
    this.subCategoryId,
    this.brandId,
    this.stockStatus = StockFilterStatus.all,
    this.showInactive = false,
  });

  ProductFilters copyWith({
    String? categoryId,
    String? subCategoryId,
    String? brandId,
    StockFilterStatus? stockStatus,
    bool? showInactive,
  }) {
    return ProductFilters(
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      brandId: brandId ?? this.brandId,
      stockStatus: stockStatus ?? this.stockStatus,
      showInactive: showInactive ?? this.showInactive,
    );
  }
}
