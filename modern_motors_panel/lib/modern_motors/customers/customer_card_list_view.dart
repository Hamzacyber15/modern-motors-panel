import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/employees_filter_model.dart';
import 'package:modern_motors_panel/modern_motors/branch/branches_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/widgets/build_filter_chip.dart';
import 'package:modern_motors_panel/modern_motors/widgets/table_image_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:provider/provider.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customerModel;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const CustomerCard({
    super.key,
    required this.customerModel,
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
                flex: 2,
                child: Row(
                  children: [
                    TableImageWidget(imageUrl: customerModel.imageUrl ?? ''),
                    12.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${customerModel.customerName}-CL${customerModel.codeNumber}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1a202c),
                          ),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        1.h,
                        buildWidget(
                          title: 'Type',
                          value: customerModel.customerType,
                          color: Color(0xff23af01),
                          removeColor: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              50.w,
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (customerModel.contactNumber.isNotEmpty)
                          buildWidget(
                            title: 'Mobile',
                            icon: Icons.call,
                            value: customerModel.contactNumber,
                            color: Color(0xff268291),
                          ),
                        if (customerModel.telePhoneNumber.isNotEmpty)
                          buildWidget(
                            title: 'Whatsapp',
                            icon: Icons.mobile_friendly_sharp,
                            value: customerModel.telePhoneNumber,
                            color: Color(0xff268291),
                          ),
                      ],
                    ),

                    if (customerModel.emailAddress.isNotEmpty)
                      buildWidget(
                        title: 'Email',
                        icon: Icons.email,
                        value: customerModel.emailAddress,
                        color: Color(0xff268291),
                      ),
                  ],
                ),
              ),
              20.w,
              Expanded(flex: 2, child: countryCurrency(customerModel)),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM dd').format(
                        customerModel.timestamp?.toDate() ?? DateTime.now(),
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
                        (customerModel.status).toUpperCase(),
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
                      if (branchPermissions.contains('View Customer') ||
                          Constants.profile.role == "admin")
                        PopupMenuItem<ProductAction>(
                          value: ProductAction.view,
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility,
                                size: 18,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text('View'),
                            ],
                          ),
                        ),
                      if (branchPermissions.contains('Edit Customer') ||
                          Constants.profile.role == "admin")
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
                      PopupMenuItem<ProductAction>(
                        value: ProductAction.clone,
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text('Clone'),
                          ],
                        ),
                      ),

                      if (branchPermissions.contains('Delete Customer')) ...[
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
    switch (customerModel.status.toLowerCase()) {
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

class CustomerCardListView extends StatefulWidget {
  final List<CustomerModel> customersList;
  final bool enableSearch;
  final Set<String> selectedIds;
  final Function onEdit;
  final Function onClone;
  final Function onView;

  const CustomerCardListView({
    super.key,
    required this.customersList,
    this.enableSearch = true,
    required this.selectedIds,
    required this.onEdit,
    required this.onClone,
    required this.onView,
  });

  @override
  State<CustomerCardListView> createState() => _EmployeeCardListViewState();
}

class _EmployeeCardListViewState extends State<CustomerCardListView> {
  final TextEditingController _searchController = TextEditingController();
  List<CustomerModel> _filteredCustomer = [];
  String _searchQuery = '';
  EmployeeFilterModel tempFilter = EmployeeFilterModel();

  @override
  void initState() {
    super.initState();
    _filteredCustomer = widget.customersList;
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
      _filterCustomer();
    });
  }

  void selectCustomer(CustomerModel customer) {
    setState(() {
      widget.onEdit(customer);
    });
  }

  void onCloneGetCustomer(CustomerModel customer) {
    setState(() {
      widget.onClone(customer);
    });
  }

  void onViewGetCustomer(CustomerModel customer) {
    setState(() {
      widget.onView(customer);
    });
  }

  @override
  void didUpdateWidget(CustomerCardListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customersList != widget.customersList) {
      _filterCustomer();
    }
  }

  void _handleActionSelected(CustomerModel customer, ProductAction action) {
    switch (action) {
      case ProductAction.inventoryLogs:
        debugPrint('Inventory Logs: ${customer.customerName}');
        break;
      case ProductAction.inventoryBatch:
        debugPrint('Inventory Batches: ${customer.customerName}');
        break;
      case ProductAction.edit:
        selectCustomer(customer);
        debugPrint('Edit product: ${customer.customerName}');
        break;
      case ProductAction.addNew:
        debugPrint('Add inventory: ${customer.customerName}');
        break;
      case ProductAction.view:
        onViewGetCustomer(customer);
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(customer);
        break;
      case ProductAction.clone:
        onCloneGetCustomer(customer);
        break;
    }
  }

  void _showDeleteConfirmation(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Client'),
        content: Text(
          'Are you sure you want to delete "${customer.customerName}"?',
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
              debugPrint('Deleted Client : ${customer.customerName}');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _filterCustomer() {
    if (_searchQuery.isEmpty) {
      _filteredCustomer = widget.customersList;
    } else {
      final searchLower = _searchQuery.toLowerCase();

      _filteredCustomer = widget.customersList.where((customer) {
        final nameMatch = customer.customerName.toLowerCase().contains(
          searchLower,
        );
        final emailMatch = customer.emailAddress.toLowerCase().contains(
          searchLower,
        );
        // final crNumberMatch = customer.crNumber!.toLowerCase().contains(
        //   searchLower,
        // );
        final codeMatch = customer.codeNumber.toString().toLowerCase().contains(
          searchLower,
        );

        final statusMatch = customer.status.toLowerCase().contains(searchLower);

        return nameMatch || codeMatch || statusMatch || emailMatch
        // ||
        // crNumberMatch
        ;
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
                        hintText: 'Search by name, code, email or CR Number',
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
                    _filteredCustomer = widget.customersList;
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
                  'Found ${_filteredCustomer.length} Vendor${_filteredCustomer.length != 1 ? 's' : ''}',
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
                flex: 2,
                child: Text('Client Info', style: headerStyle()),
              ),
              Expanded(
                flex: 2,
                child: Text('Contact Info', style: headerStyle()),
              ),

              Expanded(
                flex: 2,
                child: Text('Country\nCurrency', style: headerStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Created Info',
                  style: headerStyle(),
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
          child: _filteredCustomer.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredCustomer.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomer[index];

                    return CustomerCard(
                      customerModel: customer,
                      isSelected: widget.selectedIds.contains(customer.id),
                      onActionSelected: (p0) {
                        _handleActionSelected(customer, p0);
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
                ? 'No Clients found for "$_searchQuery"'
                : 'No Client available',
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
                : 'Add your first client to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

Widget countryCurrency(CustomerModel customer) {
  return Consumer<MmResourceProvider>(
    builder: (context, resource, child) {
      final currency = resource.getCurrencyID(customer.currencyId);
      final country = resource.getCountryID(customer.countryId);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (customer.currencyId.isNotEmpty)
            buildWidget(
              title: 'Currency',
              icon: Icons.currency_exchange,
              value: currency.currency,
              color: Color(0xff268291),
            ),
          if (customer.countryId.isNotEmpty)
            buildWidget(
              title: 'Country',
              icon: Icons.phone,
              value: country.country,
              color: Color(0xff268291),
            ),
        ],
      );
    },
  );
}
