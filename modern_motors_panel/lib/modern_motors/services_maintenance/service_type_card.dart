import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/mm_employee_info_tile.dart';

class ServiceTypeCard extends StatelessWidget {
  final ServiceTypeModel serviceTypeModel;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const ServiceTypeCard({
    super.key,
    required this.serviceTypeModel,
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
            color: Colors.grey.withOpacity(0.05),
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

              // Product Code Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                  'SER-${serviceTypeModel.code ?? 'NIL'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      serviceTypeModel.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a202c),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                    const SizedBox(height: 1),
                    // Minimum Price
                    if (serviceTypeModel.minimumPrice != null)
                      Text(
                        'Min: OMR ${serviceTypeModel.minimumPrice?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        (serviceTypeModel.status).toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        'OMR ${serviceTypeModel.prices!.map((e) => e.toString()).join(", ")}',
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

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM dd').format(
                        serviceTypeModel.timestamp?.toDate() ?? DateTime.now(),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    // Created By
                    MmEmployeeInfoTile(employeeId: serviceTypeModel.createdBy),
                    const SizedBox(height: 1),
                    Text(
                      'Created',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade400,
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

  // Color _getStockColor() {
  //   final stock = product.totalStockOnHand ?? 0;
  //   final threshold = product.threshold ?? 0;
  //
  //   if (stock <= threshold) {
  //     return Colors.red;
  //   } else if (stock <= threshold * 1.5) {
  //     return Colors.orange;
  //   } else {
  //     return Colors.green;
  //   }
  // }

  Color _getStatusColor() {
    switch (serviceTypeModel.status.toLowerCase()) {
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

class ServiceTypeCardListView extends StatefulWidget {
  final List<ServiceTypeModel> servicesList;
  final bool enableSearch;
  final Set<String> selectedIds;

  const ServiceTypeCardListView({
    super.key,
    required this.servicesList,
    this.enableSearch = true,
    required this.selectedIds,
  });

  @override
  State<ServiceTypeCardListView> createState() =>
      _ServiceTypeCardListViewState();
}

class _ServiceTypeCardListViewState extends State<ServiceTypeCardListView> {
  final TextEditingController _searchController = TextEditingController();
  List<ServiceTypeModel> _filteredServicesType = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredServicesType = widget.servicesList;
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
      _filteredServicesType = widget.servicesList;
    } else {
      _filteredServicesType = widget.servicesList.where((service) {
        final searchLower = _searchQuery.toLowerCase();

        return (service.name.toLowerCase().contains(searchLower)) ||
            (service.status.toLowerCase().contains(searchLower));
      }).toList();
    }
  }

  @override
  void didUpdateWidget(ServiceTypeCardListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.servicesList != widget.servicesList) {
      _filterProducts();
    }
  }

  void _handleActionSelected(
    ServiceTypeModel service,
    ProductAction action,
    //     {
    //   String? brand,
    //   String? category,
    //   String? subcategory,
    // }
  ) {
    switch (action) {
      case ProductAction.inventoryLogs:
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder:
        //         (context) => ProductInventoryLogsMainPage(product: product),
        //   ),
        // );
        debugPrint('Inventory Logs: ${service.name}');
        break;
      case ProductAction.inventoryBatch:
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => ProductInventoryBatches(product: product),
        //   ),
        // );
        debugPrint('Inventory Batches: ${service.name}');
        break;
      case ProductAction.edit:
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return AddEditProduct(
        //         isEdit: true,
        //         productModel: product,
        //         onBack: () {
        //           //Navigator.of(context).pop();
        //         },
        //       );
        //     },
        //   ),
        // );
        debugPrint('Edit product: ${service.name}');
        break;
      case ProductAction.addNew:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DirectInventoryAddScreen(product: product),
        //   ),
        // );
        debugPrint('Add inventory: ${service.name}');
        break;
      case ProductAction.view:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (context) => ProductDetailsPage(
        //           product: product,
        //           brand: brand,
        //           category: category,
        //           subCategory: subcategory,
        //         ),
        //   ),
        // );
        debugPrint('Add inventory: ${service.name}');
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(service);
        break;
      case ProductAction.clone:
        //_showDeleteConfirmation(employee);
        break;
    }
  }

  void _showDeleteConfirmation(ServiceTypeModel service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Service Type'),
        content: Text('Are you sure you want to delete "${service.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform delete action
              print('Deleted service type: ${service.name}');
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
        if (widget.enableSearch)
          Container(
            height: 50,
            margin: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Service Type',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
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
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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

        // Results count
        if (widget.enableSearch && _searchQuery.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Found ${_filteredServicesType.length} service${_filteredServicesType.length != 1 ? 's' : ''}',
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
              const SizedBox(width: 100),
              // Product code space
              // const SizedBox(width: 52),
              // Image space
              Expanded(flex: 1, child: Text('Name', style: _headerStyle())),

              Expanded(
                flex: 1,
                child: Text(
                  'Pricing',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
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
              const SizedBox(width: 30),
              // Actions space
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Products List
        Expanded(
          child: _filteredServicesType.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredServicesType.length,
                  itemBuilder: (context, index) {
                    final serviceType = _filteredServicesType[index];

                    return ServiceTypeCard(
                      serviceTypeModel: serviceType,
                      isSelected: widget.selectedIds.contains(serviceType.id),
                      onActionSelected: (p0) {
                        _handleActionSelected(serviceType, p0);
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
