import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/employees/advance_payment_employee_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/employees_filter_model.dart';
import 'package:modern_motors_panel/modern_motors/branch/branches_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/employees/advance_payment/add_edit_adv_emp_payment.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card.dart';
import 'package:modern_motors_panel/modern_motors/sales/sale_payment.dart';
import 'package:modern_motors_panel/modern_motors/widgets/helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/hover_info_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:provider/provider.dart';
import '../../../provider/resource_provider.dart';

class EmployeeAdvancePaymentCard extends StatelessWidget {
  final AdvanceEmployeePaymentModel advancePaymentModel;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const EmployeeAdvancePaymentCard({
    super.key,
    required this.advancePaymentModel,
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
                      '${advancePaymentModel.amount} OMR - ${advancePaymentModel.code}',
                      style: headerStyle(),
                    ),
                    buildWidget(
                      title: 'Reference. No',
                      value: advancePaymentModel.referenceNo,
                      color: Color(0x0f5d5656),
                    ),
                  ],
                ),
              ),
              30.w,
              Expanded(flex: 1, child: otherInfo(advancePaymentModel)),
              30.w,
              Expanded(
                flex: 1,
                child: Text(
                  DateFormat(
                    'MMM dd',
                  ).format(advancePaymentModel.createdAt.toDate()),
                  style: headerStyle(),
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
                      ).format(advancePaymentModel.createdAt.toDate()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    MmEmployeeInfoTile(
                      employeeId: advancePaymentModel.createdBy,
                      // isBackground: false,
                      // fontSize: 10,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(
                          advancePaymentModel.status.toLowerCase(),
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        (advancePaymentModel.status).toUpperCase(),
                        style: TextStyle(
                          color: getStatusColor(
                            advancePaymentModel.status.toLowerCase(),
                          ),
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
}

class EmployeeAdvancePaymentCardListView extends StatefulWidget {
  final List<AdvanceEmployeePaymentModel> paymentList;
  final bool enableSearch;
  final Set<String> selectedIds;

  const EmployeeAdvancePaymentCardListView({
    super.key,
    required this.paymentList,
    this.enableSearch = true,
    required this.selectedIds,
  });

  @override
  State<EmployeeAdvancePaymentCardListView> createState() =>
      _EmployeeCardListViewState();
}

class _EmployeeCardListViewState
    extends State<EmployeeAdvancePaymentCardListView> {
  final TextEditingController _searchController = TextEditingController();
  List<AdvanceEmployeePaymentModel> _filteredCategory = [];
  String _searchQuery = '';
  EmployeeFilterModel tempFilter = EmployeeFilterModel();

  @override
  void initState() {
    super.initState();
    _filteredCategory = widget.paymentList;
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

  void onEdit(AdvanceEmployeePaymentModel advancePaymentModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditAdvEmpPay(paymentModel: advancePaymentModel),
      ),
    );
  }

  void _filterSubCat() {
    if (_searchQuery.isEmpty) {
      _filteredCategory = widget.paymentList;
    } else {
      final searchLower = _searchQuery.toLowerCase();

      _filteredCategory = widget.paymentList.where((subCat) {
        final codeMatch = subCat.referenceNo.toString().toLowerCase().contains(
          searchLower,
        );

        final statusMatch = subCat.status.toLowerCase().contains(searchLower);

        final reference = subCat.referenceNo.toLowerCase().contains(
          searchLower,
        );

        return codeMatch || statusMatch || reference;
      }).toList();
    }
  }

  @override
  void didUpdateWidget(EmployeeAdvancePaymentCardListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paymentList != widget.paymentList) {
      _filterSubCat();
    }
  }

  void _handleActionSelected(
    AdvanceEmployeePaymentModel advancePaymentModel,
    ProductAction action,
  ) {
    switch (action) {
      case ProductAction.inventoryLogs:
        debugPrint('Inventory Logs: ${advancePaymentModel.referenceNo}');
        break;
      case ProductAction.inventoryBatch:
        debugPrint('Inventory Batches: ${advancePaymentModel.referenceNo}');
        break;
      case ProductAction.edit:
        onEdit(advancePaymentModel);
        break;
      case ProductAction.addNew:
        debugPrint('Add inventory: ${advancePaymentModel.referenceNo}');
        break;
      case ProductAction.view:
        debugPrint('view inventory: ${advancePaymentModel.referenceNo}');
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(advancePaymentModel);
        break;
      case ProductAction.clone:
        debugPrint('Inventory Logs: ${advancePaymentModel.referenceNo}');
        break;
      // case ProductAction.status:
      //   debugPrint('Inventory Logs: ${advancePaymentModel.referenceNo}');
      //   break;
    }
  }

  void _showDeleteConfirmation(
    AdvanceEmployeePaymentModel advancePaymentModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete advancePaymentModel'),
        content: Text(
          'Are you sure you want to delete "${advancePaymentModel.referenceNo}"?',
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
              debugPrint(
                'Deleted advancePaymentModel : ${advancePaymentModel.referenceNo}',
              );
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
                        hintText: 'Search referenceNo and status',
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
                  'Found ${_filteredCategory.length} Payment${_filteredCategory.length != 1 ? 's' : ''}',
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
                child: Text('Payment Info', style: headerStyle()),
              ),

              Expanded(
                flex: 1,
                child: Text('Other Info', style: headerStyle()),
              ),
              Expanded(flex: 1, child: Text('Date', style: headerStyle())),
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
                    final advancePaymentModel = _filteredCategory[index];

                    return EmployeeAdvancePaymentCard(
                      advancePaymentModel: advancePaymentModel,
                      isSelected: widget.selectedIds.contains(
                        advancePaymentModel.id,
                      ),
                      onActionSelected: (p0) {
                        _handleActionSelected(advancePaymentModel, p0);
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
                ? 'No products sub advancePaymentModel found for "$_searchQuery"'
                : 'No products sub advancePaymentModel available',
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
                : 'Add your first products sub advancePaymentModel to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

Widget otherInfo(AdvanceEmployeePaymentModel advancePaymentModel) {
  return Consumer<MmResourceProvider>(
    builder: (context, resource, child) {
      final employee = resource.getEmployeeByID(advancePaymentModel.employeeId);
      final branch = resource.getBranchByID(advancePaymentModel.branchId);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HoverInfoWidget(
            title: 'Emp',
            value: employee.name,
            color: Color(0xff655d5d),
            hoverColor: Color(0xff57c259),
          ),
          HoverInfoWidget(
            title: 'Branch',
            value: branch.branchName,
            color: Color(0xff655d5d),
            hoverColor: Color(0xff5259ec),
          ),
        ],
      );
    },
  );
}

Widget amountWithCurrency(AdvanceEmployeePaymentModel advancePaymentModel) {
  return Container();
  // return Consumer<ResourceProvider>(
  //   builder: (context, resource, child) {
  //     final currency = resource.getCurrencyID(
  //       advancePaymentModel.currencyId ?? '',
  //     );
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           '${currency.currency} ${advancePaymentModel.amount!
  //           // (advancePaymentModel.amount != null
  //           //         ? (advancePaymentModel.amount! -
  //           //             ((advancePaymentModel.vat1Amount ?? 0) +
  //           //                 (advancePaymentModel.vat2Amount ?? 0)))
  //           //         : 0.0)
  //           .toStringAsFixed(2)}',
  //           style: const TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF1a202c),
  //           ),
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         if (advancePaymentModel.vat1Id != null)
  //           buildWidget(
  //             title: 'VAT1',
  //             value:
  //                 '${advancePaymentModel.vat1Percentage}% -> ${advancePaymentModel.vat1Amount!.toStringAsFixed(2)} ${currency.currency}',
  //             color: Color(0xff5a6e64),
  //           ),
  //         if (advancePaymentModel.vat2Id != null)
  //           buildWidget(
  //             title: 'VAT2',
  //             value:
  //                 '${advancePaymentModel.vat2Percentage}% -> ${advancePaymentModel.vat2Amount!.toStringAsFixed(2)} ${currency.currency}',
  //             color: Color(0xff5a6e64),
  //           ),
  //       ],
  //     );
  //   },
  // );
}
