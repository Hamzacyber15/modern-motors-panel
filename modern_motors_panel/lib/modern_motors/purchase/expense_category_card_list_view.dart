import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/employees_filter_model.dart';
import 'package:modern_motors_panel/model/purchase_models/expense_category_model.dart';
import 'package:modern_motors_panel/modern_motors/branch/branches_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/mm_employee_info_tile.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:provider/provider.dart';
import '../../../provider/resource_provider.dart';

class ExpenseCategoryCard extends StatelessWidget {
  final ExpenseCategoryModel category;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const ExpenseCategoryCard({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.onActionSelected,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85, // Increased height from 65 to 85
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1a202c),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        1.h,
                      ],
                    ),
                  ],
                ),
              ),
              40.w,
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'EC${category.code}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1a202c),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        1.h,
                      ],
                    ),
                  ],
                ),
              ),
              40.w,
              Expanded(
                flex: 1,
                child: MmEmployeeInfoTile(
                  employeeId: category.createdBy ?? '',
                  // isBackground: false,
                  // fontSize: 14,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat(
                        'MMM dd',
                      ).format(category.timestamp?.toDate() ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 2),
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
                        (category.status).toUpperCase(),
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

              Consumer<MmResourceProvider>(
                builder: (context, resource, child) {
                  final branchId = BranchIdSp.getBranchId();
                  final allPermissions =
                      resource.employeeModel?.permissions ??
                      []; // List<Permissions>
                  final branchPermissionModel = allPermissions.firstWhere(
                    (p) => p.branchId == branchId,
                    orElse: () =>
                        Permissions(branchId: branchId, permission: []),
                  );

                  final branchPermissions = branchPermissionModel.permission;
                  return PopupMenuButton<ProductAction>(
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
                      if (branchPermissions.contains('Edit Expenses Category'))
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
                      if (branchPermissions.contains(
                        'Delete Expenses Category',
                      )) ...[
                        const PopupMenuDivider(),
                        PopupMenuItem<ProductAction>(
                          value: ProductAction.delete,
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (category.status.toLowerCase()) {
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

class ExpenseCategoryCardListView extends StatefulWidget {
  final List<ExpenseCategoryModel> expenseCategoriesList;
  final bool enableSearch;
  final Set<String> selectedIds;
  final Function onEdit;

  const ExpenseCategoryCardListView({
    super.key,
    required this.expenseCategoriesList,
    this.enableSearch = true,
    required this.selectedIds,
    required this.onEdit,
  });

  @override
  State<ExpenseCategoryCardListView> createState() =>
      _EmployeeCardListViewState();
}

class _EmployeeCardListViewState extends State<ExpenseCategoryCardListView> {
  final TextEditingController _searchController = TextEditingController();
  List<ExpenseCategoryModel> _filteredCategory = [];
  String _searchQuery = '';
  EmployeeFilterModel tempFilter = EmployeeFilterModel();

  @override
  void initState() {
    super.initState();
    _filteredCategory = widget.expenseCategoriesList;
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
      _filterSubCat();
    });
  }

  void selectCategory(ExpenseCategoryModel category) {
    setState(() {
      widget.onEdit(category);
    });
  }

  void _filterSubCat() {
    if (_searchQuery.isEmpty) {
      _filteredCategory = widget.expenseCategoriesList;
    } else {
      final searchLower = _searchQuery.toLowerCase();

      _filteredCategory = widget.expenseCategoriesList.where((subCat) {
        final nameMatch = subCat.name.toLowerCase().contains(searchLower);
        final codeMatch = subCat.code.toString().toLowerCase().contains(
          searchLower,
        );

        final statusMatch = subCat.status.toLowerCase().contains(searchLower);

        return nameMatch || codeMatch || statusMatch;
      }).toList();
    }
  }

  @override
  void didUpdateWidget(ExpenseCategoryCardListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expenseCategoriesList != widget.expenseCategoriesList) {
      _filterSubCat();
    }
  }

  void _handleActionSelected(
    ExpenseCategoryModel category,
    ProductAction action,
  ) {
    switch (action) {
      case ProductAction.inventoryLogs:
        debugPrint('Inventory Logs: ${category.name}');
        break;
      case ProductAction.inventoryBatch:
        debugPrint('Inventory Batches: ${category.name}');
        break;
      case ProductAction.edit:
        selectCategory(category);
        debugPrint('Edit product: ${category.name}');
        break;
      case ProductAction.addNew:
        debugPrint('Add inventory: ${category.name}');
        break;
      case ProductAction.view:
        debugPrint('view inventory: ${category.name}');
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(category);
        break;
      case ProductAction.clone:
        debugPrint('Inventory Logs: ${category.name}');
        break;
        //  case ProductAction.status:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _showDeleteConfirmation(ExpenseCategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform delete action
              debugPrint('Deleted category : ${category.name}');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
                        hintText: 'Search by name, code and status',
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
              40.w,
              // Image space
              Expanded(
                flex: 1,
                child: Text('Category Info', style: headerStyle()),
              ),

              Expanded(flex: 1, child: Text('Code', style: headerStyle())),
              Expanded(flex: 1, child: Text('CreatedBy', style: headerStyle())),
              Expanded(
                flex: 1,
                child: Text(
                  'Created Info',
                  style: headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              // const SizedBox(width: 20),
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

                    return ExpenseCategoryCard(
                      category: category,
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
                ? 'No products sub category found for "$_searchQuery"'
                : 'No products sub category available',
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
                : 'Add your first products sub category to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// Widget unitWidget(ExpenseCategoryModel category) {
//   return Consumer<ResourceProvider>(
//     builder: (context, resource, child) {
//       final unit = resource.getUnitID(category.unitId ?? '');
//       return Container(
//         margin: const EdgeInsets.only(bottom: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Unit: ${unit.name}',
//               style: TextStyle(
//                 fontSize: 9,
//                 color: Colors.teal.shade700,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
