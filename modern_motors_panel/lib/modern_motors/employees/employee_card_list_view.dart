import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/employees_filter_model.dart';
import 'package:modern_motors_panel/model/hr_models/role_model.dart';
import 'package:modern_motors_panel/modern_motors/employees/employee_filter_widget.dart';
import 'package:modern_motors_panel/modern_motors/employees/mm_employee_screen.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/widgets/build_filter_chip.dart';
import 'package:modern_motors_panel/modern_motors/widgets/filter_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/permission_dialogue.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeModel employeeMoel;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const EmployeeCard({
    super.key,
    required this.employeeMoel,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${employeeMoel.name} - ${employeeMoel.employeeCode}',
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
                      title: 'ID#',
                      value: employeeMoel.idCardNumber,
                      color: Color(0xff23af01),
                    ),
                  ],
                ),
              ),

              Expanded(flex: 1, child: designationWidget(employeeMoel)),
              Expanded(
                flex: 1,
                child: Consumer<MmResourceProvider>(
                  builder: (context, resource, child) {
                    final permissions =
                        resource.employees
                            .firstWhere(
                              (employee) => employee.id == employeeMoel.id,
                            )
                            .profileAccessKey ??
                        [];
                    return Builder(
                      builder: (context) {
                        if (permissions.isEmpty) {
                          return const Text(
                            'No Permissions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffec4400),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }

                        final showList = permissions.length > 3
                            ? permissions.take(3).toList()
                            : permissions;

                        return Wrap(
                          spacing: 2,
                          runSpacing: 1,
                          children: [
                            ...showList.map((perm) {
                              return containerWidget(perm);
                            }),
                            if (permissions.length > 3)
                              permissionDialog(context, permissions),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              24.w,
              Expanded(
                flex: 1,
                child: Consumer<MmResourceProvider>(
                  builder: (context, resource, child) {
                    final branches = resource.branchesList
                        .where((p) => employeeMoel.branches!.contains(p.id))
                        .map((p) => p.branchName)
                        .toList();
                    return Builder(
                      builder: (context) {
                        if (branches.isEmpty) {
                          return const Text(
                            'No Branches Assigned',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffec4400),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }

                        final showList = branches.length > 3
                            ? branches.take(3).toList()
                            : branches;

                        return Wrap(
                          spacing: 2,
                          runSpacing: 1,
                          children: [
                            ...showList.map((perm) {
                              return containerWidget(perm);
                            }),
                            if (branches.length > 3)
                              permissionDialog(context, branches),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              // Expanded(flex: 1, child: branch(employeeMoel)),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat(
                        'MMM dd',
                      ).format(employeeMoel.timestamp.toDate()),
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
                        (employeeMoel.status).toUpperCase(),
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
    switch (employeeMoel.status.toLowerCase()) {
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

class EmployeeCardListView extends StatefulWidget {
  final List<EmployeeModel> employeeList;
  final bool enableSearch;
  final Set<String> selectedIds;
  final Function onEdit;

  const EmployeeCardListView({
    super.key,
    required this.employeeList,
    this.enableSearch = true,
    required this.selectedIds,
    required this.onEdit,
  });

  @override
  State<EmployeeCardListView> createState() => _EmployeeCardListViewState();
}

class _EmployeeCardListViewState extends State<EmployeeCardListView> {
  final TextEditingController _searchController = TextEditingController();
  List<EmployeeModel> _filteredEmployee = [];
  String _searchQuery = '';
  EmployeeFilterModel tempFilter = EmployeeFilterModel();

  @override
  void initState() {
    super.initState();
    _filteredEmployee = widget.employeeList;
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
      _filterEmployees();
    });
  }

  void selectEmployee(EmployeeModel employee) {
    setState(() {
      widget.onEdit(employee);
    });
  }

  void _applyFilters(EmployeeFilterModel filter) {
    _filteredEmployee = widget.employeeList.where((employee) {
      bool matches = true;

      // Status filter
      if (filter.status != null) {
        matches =
            matches &&
            employee.status.toLowerCase() == filter.status!.toLowerCase();
      }

      // Branch filter
      if (filter.branchId != null) {
        matches = matches && employee.branchId == filter.branchId;
      }

      // Designation filter
      if (filter.designationId != null) {
        matches = matches && employee.roleId == filter.designationId;
      }

      // Permission filter
      if (filter.permission != null) {
        matches =
            matches &&
            (employee.profileAccessKey?.contains(filter.permission!) ?? false);
      }

      return matches;
    }).toList();

    setState(() {});
  }

  void _filterEmployees() {
    final provider = context.read<MmResourceProvider>();

    if (_searchQuery.isEmpty) {
      _filteredEmployee = widget.employeeList;
    } else {
      final searchLower = _searchQuery.toLowerCase();

      _filteredEmployee = widget.employeeList.where((employee) {
        final nameMatch = employee.name.toLowerCase().contains(searchLower);
        final codeMatch = employee.employeeNumber
            .toString()
            .toLowerCase()
            .contains(searchLower);

        final statusMatch = employee.status.toLowerCase().contains(searchLower);

        final designation = provider.designationsList.firstWhere(
          (d) => d.id == employee.roleId,
          orElse: () => RoleModel(name: ''),
        );
        final designationName = designation.name.toLowerCase();
        final designationMatch = designationName.contains(searchLower);

        final permissions = employee.profileAccessKey ?? [];
        final permissionMatch = permissions.any(
          (p) => p.toLowerCase().contains(searchLower),
        );

        return nameMatch ||
            codeMatch ||
            statusMatch ||
            designationMatch ||
            permissionMatch;
      }).toList();
    }
  }

  @override
  void didUpdateWidget(EmployeeCardListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.employeeList != widget.employeeList) {
      _filterEmployees();
    }
  }

  void _handleActionSelected(EmployeeModel employee, ProductAction action) {
    switch (action) {
      case ProductAction.inventoryLogs:
        debugPrint('Inventory Logs: ${employee.name}');
        break;
      case ProductAction.inventoryBatch:
        debugPrint('Inventory Batches: ${employee.name}');
        break;
      case ProductAction.edit:
        selectEmployee(employee);
        debugPrint('Edit product: ${employee.name}');
        break;
      case ProductAction.addNew:
        debugPrint('Add inventory: ${employee.name}');
        break;
      case ProductAction.view:
        onView(employee);
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(employee);
        break;
    }
  }

  void onView(EmployeeModel employee) {
    final provider = context.read<MmResourceProvider>();

    final designation = provider.getDesignationById(employee.roleId);
    final branch = provider.getBranchByID(employee.branchId);
    final nationality = provider.getNationalityByID(
      employee.nationalityId ?? '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MmEmployeeScreen(
          employee: employee,
          roleName: designation.name,
          branchName: branch.branchName,
          nationalityName: nationality.nationality,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Employee'),
        content: Text('Are you sure you want to delete "${employee.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform delete action
              debugPrint('Deleted Employee : ${employee.name}');
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
                        hintText:
                            'Search by name, code, designation or permissions',
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
              filterButton(context, () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return employeeFilterWidget(context, tempFilter, () {
                      Navigator.pop(context);
                      _applyFilters(tempFilter);
                    });
                  },
                );
              }, _getActiveFilterCount()),
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
                      _applyFilters(tempFilter);
                    });
                  },
                ),
              ],
              if (tempFilter.status != null) ...[
                buildFilterChip(context, 'Status: ${tempFilter.status}', () {
                  setState(() {
                    tempFilter.status = null;
                    _applyFilters(tempFilter);
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
                      _applyFilters(tempFilter);
                    });
                  },
                ),
              ],
              if (tempFilter.branchId != null) ...[
                buildFilterChip(context, 'Branch: ${tempFilter.branchId}', () {
                  setState(() {
                    tempFilter.branchId = null;
                    _applyFilters(tempFilter);
                  });
                }),
              ],
              if (tempFilter.hasActiveFilters) ...[
                buildFilterChip(context, 'Clear All', () {
                  setState(() {
                    tempFilter.clear();
                    _searchQuery = '';
                    _filteredEmployee = widget.employeeList;
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
                  'Found ${_filteredEmployee.length} employee${_filteredEmployee.length != 1 ? 's' : ''}',
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
              const SizedBox(width: 30),
              // Image space
              Expanded(
                flex: 1,
                child: Text('Employee Info', style: _headerStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Designation Info',
                  style: _headerStyle(),
                  // textAlign: TextAlign.center,
                ),
              ),

              // Expanded(
              //   flex: 1,
              //   child: Text(
              //     'Address',
              //     style: _headerStyle(),
              //     textAlign: TextAlign.center,
              //   ),
              // ),

              // Expanded(
              //   flex: 1,
              //   child: Text(
              //     'Branch, Role\nDesignation',
              //     style: _headerStyle(),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Text('Access Permissions', style: _headerStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Branches',
                  // textAlign: TextAlign.center,
                  style: _headerStyle(),
                ),
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
          child: _filteredEmployee.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredEmployee.length,
                  itemBuilder: (context, index) {
                    final employee = _filteredEmployee[index];

                    return EmployeeCard(
                      employeeMoel: employee,
                      isSelected: widget.selectedIds.contains(employee.id),
                      onActionSelected: (p0) {
                        _handleActionSelected(employee, p0);
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
}) {
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
        if (icon != null) ...[
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
        ],
        Text(
          '$title: $value',
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const SizedBox(width: ),
      ],
    ),
  );
}

Widget nationality(EmployeeModel employee) {
  return Consumer<MmResourceProvider>(
    builder: (context, resource, child) {
      final nationality = resource.getNationalityByID(
        employee.nationalityId ?? '',
      );
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
              'Nationality: ${nationality.nationality} / ${nationality.nationalityArabic}',
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

Widget designationWidget(EmployeeModel employee) {
  return Consumer<MmResourceProvider>(
    builder: (context, resource, child) {
      final designation = resource.getDesignationById(employee.roleId);
      return Text(
        designation.name,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      );
    },
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
            fontSize: 10,
            color: Colors.teal.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget branch(EmployeeModel employee) {
  return Consumer<MmResourceProvider>(
    builder: (context, resource, child) {
      final branch = resource.getBranchByID(employee.branchId);
      return Text(
        branch.branchName,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      );
    },
  );
}
