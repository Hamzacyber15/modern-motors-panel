import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/employees/employees_filter_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/mm_employee_info_tile.dart';
import 'package:modern_motors_panel/modern_motors/widgets/table_image_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class ProductCategoryCard extends StatelessWidget {
  final ProductCategoryModel productCategory;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const ProductCategoryCard({
    super.key,
    required this.productCategory,
    this.isSelected = false,
    this.onTap,
    this.onActionSelected,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Increased height from 65 to 85
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ), // Increased vertical padding
          child: Row(
            children: [
              // Checkbox
              if (onSelectChanged != null) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectChanged,
                    activeColor: Theme.of(context).primaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    TableImageWidget(imageUrl: productCategory.image ?? ''),
                    12.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'PC-${productCategory.code}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          productCategory.productName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1a202c),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        1.h,
                        // unitWidget(productCategory),
                      ],
                    ),
                  ],
                ),
              ),
              40.w,

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      productCategory.description ?? 'No Description',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a202c),
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM dd').format(
                        productCategory.timestamp?.toDate() ?? DateTime.now(),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    MmEmployeeInfoTile(
                      employeeId: productCategory.createdBy ?? '',
                    ),
                    const SizedBox(height: 1),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        (productCategory.status ?? 'No Status').toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Action Dropdown Menu
              PopupMenuButton<ProductAction>(
                onSelected: (ProductAction action) {
                  if (onActionSelected != null) {
                    onActionSelected!(action);
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 0),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.view,
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('View'),
                      ],
                    ),
                  ),
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.delete,
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (productCategory.status?.toLowerCase() ?? 'No Status') {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class ProductCategoryCardListView extends StatefulWidget {
  final List<ProductCategoryModel> productCategoriesList;
  final bool enableSearch;
  final Set<String> selectedIds;
  final Function onEdit;

  const ProductCategoryCardListView({
    super.key,
    required this.productCategoriesList,
    this.enableSearch = true,
    required this.selectedIds,
    required this.onEdit,
  });

  @override
  State<ProductCategoryCardListView> createState() =>
      _EmployeeCardListViewState();
}

class _EmployeeCardListViewState extends State<ProductCategoryCardListView> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductCategoryModel> _filteredCategory = [];
  String _searchQuery = '';
  EmployeeFilterModel tempFilter = EmployeeFilterModel();

  @override
  void initState() {
    super.initState();
    _filteredCategory = widget.productCategoriesList;
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
      _filterCategory();
    });
  }

  void selectCategory(ProductCategoryModel category) {
    setState(() {
      widget.onEdit(category);
    });
  }

  // void _applyFilters(EmployeeFilterModel filter) {
  //   _filteredCategory =
  //       widget.productCategoriesList.where((employee) {
  //         bool matches = true;
  //
  //         // Status filter
  //         if (filter.status != null) {
  //           matches =
  //               matches &&
  //                   employee.status!.toLowerCase() == filter.status!.toLowerCase();
  //         }
  //
  //         // Branch filter
  //         if (filter.branchId != null) {
  //           matches = matches && employee.contactNumber == filter.branchId;
  //         }
  //
  //         // Designation filter
  //         if (filter.designationId != null) {
  //           matches = matches && employee.contactNumber == filter.designationId;
  //         }
  //
  //         // Permission filter
  //         if (filter.permission != null) {
  //           matches =
  //               matches &&
  //                   (employee.profileAccessKey?.contains(filter.permission!) ??
  //                       false);
  //         }
  //
  //         return matches;
  //       }).toList();
  //
  //   setState(() {});
  // }

  // void _filterEmployees() {
  //   final provider = context.read<ResourceProvider>();
  //
  //   if (_searchQuery.isEmpty) {
  //     _filteredCategory = widget.productCategoriesList;
  //   } else {
  //     final searchLower = _searchQuery.toLowerCase();
  //
  //     _filteredCategory =
  //         widget.productCategoriesList.where((employee) {
  //           final nameMatch = employee.name.toLowerCase().contains(searchLower);
  //           final codeMatch = employee.employeeNumber
  //               .toString()
  //               .toLowerCase()
  //               .contains(searchLower);
  //
  //           final statusMatch = employee.status.toLowerCase().contains(
  //             searchLower,
  //           );
  //
  //           final designation = provider.designationsList.firstWhere(
  //                 (d) => d.id == employee.roleId,
  //             orElse: () => RoleModel(name: ''),
  //           );
  //           final designationName = designation.name.toLowerCase();
  //           final designationMatch = designationName.contains(searchLower);
  //
  //           final permissions = employee.profileAccessKey ?? [];
  //           final permissionMatch = permissions.any(
  //                 (p) => p.toLowerCase().contains(searchLower),
  //           );
  //
  //           return nameMatch ||
  //               codeMatch ||
  //               statusMatch ||
  //               designationMatch ||
  //               permissionMatch;
  //         }).toList();
  //   }
  // }

  @override
  void didUpdateWidget(ProductCategoryCardListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productCategoriesList != widget.productCategoriesList) {
      _filterCategory();
    }
  }

  void _handleActionSelected(
    ProductCategoryModel category,
    ProductAction action,
  ) {
    switch (action) {
      case ProductAction.inventoryLogs:
        debugPrint('Inventory Logs: ${category.productName}');
        break;
      case ProductAction.inventoryBatch:
        debugPrint('Inventory Batches: ${category.productName}');
        break;
      case ProductAction.edit:
        selectCategory(category);
        debugPrint('Edit product: ${category.productName}');
        break;
      case ProductAction.addNew:
        debugPrint('Add inventory: ${category.productName}');
        break;
      case ProductAction.view:
        debugPrint('view inventory: ${category.productName}');
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(category);
        break;
    }
  }

  void _showDeleteConfirmation(ProductCategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete category'),
        content: Text(
          'Are you sure you want to delete "${category.productName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform delete action
              debugPrint('Deleted category : ${category.productName}');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _filterCategory() {
    if (_searchQuery.isEmpty) {
      _filteredCategory = widget.productCategoriesList;
    } else {
      final searchLower = _searchQuery.toLowerCase();

      _filteredCategory = widget.productCategoriesList.where((cat) {
        final nameMatch = cat.productName.toLowerCase().contains(searchLower);
        final descriptionMatch = cat.description?.toLowerCase().contains(
          searchLower,
        );
        final codeMatch = cat.code.toString().toLowerCase().contains(
          searchLower,
        );

        final statusMatch = cat.status?.toLowerCase().contains(searchLower);

        return nameMatch || descriptionMatch! || codeMatch || statusMatch!;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (widget.enableSearch)
                Expanded(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText:
                            'Search by name, code, description and status',
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
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              // SizedBox(
              //   height: 50,
              //   child: ElevatedButton.icon(
              //     onPressed: () async {
              //       await showDialog(
              //         context: context,
              //         builder: (_) {
              //           return employeeFilterWidget(context, tempFilter, () {
              //             Navigator.pop(context);
              //             // _applyFilters(tempFilter);
              //           });
              //         },
              //       );
              //     },
              //     icon: Icon(
              //       Icons.filter_list,
              //       size: 20,
              //       color:
              //           tempFilter.hasActiveFilters
              //               ? Colors.white
              //               : Colors.grey.shade700,
              //     ),
              //     label: Text(
              //       'Filter${tempFilter.hasActiveFilters ? ' (${_getActiveFilterCount()})' : ''}',
              //       style: TextStyle(
              //         color:
              //             tempFilter.hasActiveFilters
              //                 ? Colors.white
              //                 : Colors.grey.shade700,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor:
              //           tempFilter.hasActiveFilters
              //               ? Theme.of(context).primaryColor
              //               : Colors.grey.shade100,
              //       elevation: tempFilter.hasActiveFilters ? 2 : 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //         side: BorderSide(
              //           color:
              //               tempFilter.hasActiveFilters
              //                   ? Theme.of(context).primaryColor
              //                   : Colors.grey.shade300,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        if (widget.enableSearch && _searchQuery.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Found ${_filteredCategory.length} category${_filteredCategory.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_searchQuery.isNotEmpty) ...[
                  Text(
                    ' for "$_searchQuery"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

        // Header Row - Updated to match new columns
        Container(
          height: 40,
          // Slightly increased header height
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              // if (widget.selectedIds.isNotEmpty) const SizedBox(width: 32),
              // const SizedBox(width: 100),
              // Product code space
              85.w,
              // Image space
              Expanded(
                flex: 1,
                child: Text('Category Info', style: _headerStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text('Description', style: _headerStyle()),
              ),

              Expanded(
                flex: 1,
                child: Text(
                  'Created Info',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 20),
              // Actions space
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Products List
        Expanded(
          child: _filteredCategory.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredCategory.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategory[index];

                    return ProductCategoryCard(
                      productCategory: category,
                      isSelected: widget.selectedIds.contains(category.id),
                      onActionSelected: (p0) {
                        _handleActionSelected(category, p0);
                      },
                      onSelectChanged: (p0) {},
                      // onSelectChanged:
                      //     (value) => widget.onSelectChanged(value, product),
                    );
                  },
                ),
        ),
      ],
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (tempFilter.status != null) count++;
    if (tempFilter.branchId != null) count++;
    if (tempFilter.designationId != null) count++;
    if (tempFilter.permission != null) count++;
    return count;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty
                ? Icons.search_off
                : Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No products found for "$_searchQuery"'
                : 'No products available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Add your first product to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade700,
    );
  }
}

Widget buildWidget({
  required String title,
  required String value,
  required Color color,
  IconData? icon,
  bool removeColor = true,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: removeColor
          ? Colors.grey.withValues(alpha: 0.1)
          : color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
        ],
        Text(
          icon != null ? value : '$title: $value',
          style: TextStyle(
            fontSize: 9,
            color: removeColor ? Colors.black : color,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const SizedBox(width: ),
      ],
    ),
  );
}

Widget unitWidget(ProductCategoryModel category) {
  return Consumer<MmResourceProvider>(
    builder: (context, resource, child) {
      final unit = resource.getUnitID(category.unitId ?? '');
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unit: ${unit.name}',
              style: TextStyle(
                fontSize: 9,
                color: Colors.teal.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget withIconWidget({required IconData icon, required String value}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            color: Colors.teal.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

final List<Color> permissionColors = [
  Colors.blue.shade100,
  Colors.green.shade100,
  Colors.orange.shade100,
  Colors.purple.shade100,
  Colors.red.shade100,
  Colors.teal.shade100,
  Colors.indigo.shade100,
];

Widget containerWidget(String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            color: Colors.teal.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
