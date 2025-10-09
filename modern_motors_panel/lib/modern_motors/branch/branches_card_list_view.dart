import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/employees_filter_model.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/widgets/build_filter_chip.dart';
import 'package:modern_motors_panel/modern_motors/widgets/table_image_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class BranchesCard extends StatelessWidget {
  final BranchModel branchModel;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const BranchesCard({
    super.key,
    required this.branchModel,
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
                    TableImageWidget(imageUrl: branchModel.imageUrl ?? ''),
                    12.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${branchModel.branchName} - V${branchModel.code}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1a202c),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        1.h,
                        buildWidget(
                          title: 'Address',
                          value: branchModel.address ?? '',
                          color: Color(0xff23af01),
                          removeColor: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              70.w,
              Expanded(
                flex: 1,
                child: Text(
                  branchModel.description ?? 'No Description',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a202c),
                  ),
                  softWrap: true,
                ),
              ),
              30.w,
              Expanded(
                flex: 1,
                child: storeManager(branchModel.storeManager ?? ''),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM dd').format(
                        branchModel.timestamp?.toDate() ?? DateTime.now(),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
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
                        (branchModel.status ?? 'No Status').toUpperCase(),
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
    switch (branchModel.status?.toLowerCase() ?? 'No Status') {
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

class BranchesCardListView extends StatefulWidget {
  final List<BranchModel> branchList;
  final bool enableSearch;
  final Set<String> selectedIds;
  final Function onEdit;

  const BranchesCardListView({
    super.key,
    required this.branchList,
    this.enableSearch = true,
    required this.selectedIds,
    required this.onEdit,
  });

  @override
  State<BranchesCardListView> createState() => _EmployeeCardListViewState();
}

class _EmployeeCardListViewState extends State<BranchesCardListView> {
  final TextEditingController _searchController = TextEditingController();
  List<BranchModel> _filteredBranch = [];
  String _searchQuery = '';
  EmployeeFilterModel tempFilter = EmployeeFilterModel();

  @override
  void initState() {
    super.initState();
    _filteredBranch = widget.branchList;
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
      _filterVendor();
    });
  }

  void selectVendor(BranchModel branch) {
    setState(() {
      widget.onEdit(branch);
    });
  }

  @override
  void didUpdateWidget(BranchesCardListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branchList != widget.branchList) {
      _filterVendor();
    }
  }

  void _handleActionSelected(BranchModel branch, ProductAction action) {
    switch (action) {
      case ProductAction.inventoryLogs:
        debugPrint('Inventory Logs: ${branch.branchName}');
        break;
      case ProductAction.inventoryBatch:
        debugPrint('Inventory Batches: ${branch.branchName}');
        break;
      case ProductAction.edit:
        selectVendor(branch);
        debugPrint('Edit product: ${branch.branchName}');
        break;
      case ProductAction.addNew:
        debugPrint('Add inventory: ${branch.branchName}');
        break;
      case ProductAction.view:
        debugPrint('view inventory: ${branch.branchName}');
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(branch);
        break;
    }
  }

  void _showDeleteConfirmation(BranchModel branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Branch'),
        content: Text(
          'Are you sure you want to delete "${branch.branchName}"?',
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
              debugPrint('Deleted Branch : ${branch.branchName}');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _filterVendor() {
    if (_searchQuery.isEmpty) {
      _filteredBranch = widget.branchList;
    } else {
      final provider = context.read<MmResourceProvider>();
      final searchLower = _searchQuery.toLowerCase();

      _filteredBranch = widget.branchList.where((branch) {
        final nameMatch = branch.branchName.toLowerCase().contains(searchLower);
        final manager = provider.profiles.firstWhere(
          (d) => d.id == branch.storeManager,
          orElse: () => PublicProfileModel.getEmptyProfile(),
        );
        final managerName = manager.userName.toLowerCase();
        final managerMatch = managerName.contains(searchLower);
        final codeMatch = branch.code.toString().toLowerCase().contains(
          searchLower,
        );
        final descriptionMatch = branch.description
            .toString()
            .toLowerCase()
            .contains(searchLower);

        final statusMatch = branch.status!.toLowerCase().contains(searchLower);

        return nameMatch ||
            codeMatch ||
            statusMatch ||
            managerMatch ||
            descriptionMatch;
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
                            'Search by name, code, description or store manager',
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

        if (tempFilter.hasActiveFilters)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (tempFilter.permission != null) ...[
                buildFilterChip(
                  context,
                  'Permission: ${tempFilter.permission}',
                  () {
                    setState(() {
                      tempFilter.permission = null;
                      // _applyFilters(tempFilter);
                    });
                  },
                ),
              ],
              if (tempFilter.status != null) ...[
                buildFilterChip(context, 'Status: ${tempFilter.status}', () {
                  setState(() {
                    tempFilter.status = null;
                    // _applyFilters(tempFilter);
                  });
                }),
              ],
              if (tempFilter.designationId != null) ...[
                buildFilterChip(
                  context,
                  'Designation: ${tempFilter.designationId}',
                  () {
                    setState(() {
                      tempFilter.designationId = null;
                      // _applyFilters(tempFilter);
                    });
                  },
                ),
              ],
              if (tempFilter.branchId != null) ...[
                buildFilterChip(context, 'Branch: ${tempFilter.branchId}', () {
                  setState(() {
                    tempFilter.branchId = null;
                    // _applyFilters(tempFilter);
                  });
                }),
              ],
              if (tempFilter.hasActiveFilters) ...[
                buildFilterChip(context, 'Clear All', () {
                  setState(() {
                    tempFilter.clear();
                    _searchQuery = '';
                    _filteredBranch = widget.branchList;
                  });
                }, isClearAll: true),
              ],
            ],
          ),

        if (widget.enableSearch && _searchQuery.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Found ${_filteredBranch.length} Vendor${_filteredBranch.length != 1 ? 's' : ''}',
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
                child: Text('Branch Info', style: _headerStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text('Description', style: _headerStyle()),
              ),

              Expanded(
                flex: 1,
                child: Text('Store Manager', style: _headerStyle()),
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
          child: _filteredBranch.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredBranch.length,
                  itemBuilder: (context, index) {
                    final branch = _filteredBranch[index];

                    return BranchesCard(
                      branchModel: branch,
                      isSelected: widget.selectedIds.contains(branch.id),
                      onActionSelected: (p0) {
                        _handleActionSelected(branch, p0);
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

Widget storeManager(String id) {
  return Consumer<MmResourceProvider>(
    builder: (context, resource, child) {
      final manage = resource.getProfileByID(id);
      return Text(
        manage.userName,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      );
    },
  );
}
