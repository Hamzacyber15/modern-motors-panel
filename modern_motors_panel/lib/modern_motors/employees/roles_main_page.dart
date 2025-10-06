import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/role_model.dart';
import 'package:modern_motors_panel/modern_motors/employees/roles_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

class RolePermissionPage extends StatefulWidget {
  const RolePermissionPage({super.key});

  @override
  State<RolePermissionPage> createState() => _RolePermissionPageState();
}

class _RolePermissionPageState extends State<RolePermissionPage> {
  bool showProductList = true;
  bool isLoading = true;
  List<RoleModel> allRoles = [];
  List<RoleModel> displayedRoles = [];
  RoleModel? rolesBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedRoleIds = {};

  final headerColumns = ["Role".tr(), "Created Date".tr()];

  Future<void> _deleteSelectedRole() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedRoleIds.length,
    );

    if (confirm != true) return;

    for (String roleId in selectedRoleIds) {
      await FirebaseFirestore.instance.collection('roles').doc(roleId).delete();
    }

    setState(() {
      selectedRoleIds.clear();
    });

    await _loadRoles();
  }

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() {
      isLoading = true;
    });
    final roles = await DataFetchService.fetchRoles();
    setState(() {
      allRoles = roles;
      displayedRoles = roles;
      isLoading = false;
    });
  }

  List<List<dynamic>> getRoleRowsForExcel(List<RoleModel> roles) {
    return roles.map((role) {
      return [
        role.name,
        role.timestamp != null
            ? DateFormat('dd MMM yyyy').format(role.timestamp!.toDate())
            : '',
      ];
    }).toList();
  }

  void showAlert({
    bool isEdit = false,
    RoleModel? roles,
    VoidCallback? onBack,
  }) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: RoleFormWidget(
              isEdit: isEdit,
              roleModel: roles,
              onBack: onBack,
            ),
          ),
        );
      } catch (e) {
        debugPrint("Error showing dialog: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pagedProducts = displayedRoles
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return
    // showProductList
    //   ?
    SingleChildScrollView(
      child: Column(
        children: [
          PageHeaderWidget(
            title: "Roles List".tr(),
            buttonText: "Add Role".tr(),
            subTitle: "Manage your Roles".tr(),
            requiredPermission: 'Add Roles & Permissions',
            selectedItems: selectedRoleIds.toList(),
            buttonWidth: 0.24,
            onCreate: () {
              Future.microtask(() {
                if (mounted) {
                  showAlert(isEdit: false);
                }
              });
            },
            onDelete: _deleteSelectedRole,
            onPdfImport: () async {
              final rowsToExport = getRoleRowsForExcel(pagedProducts);
              await PdfExporter.exportToPdf(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Roles&Permission_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getRoleRowsForExcel(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Roles&Permission_Report',
              );
            },
          ),
          DynamicDataTable<RoleModel>(
            data: pagedProducts,
            editProfileAccessKey: 'Edit Roles & Permissions',
            deleteProfileAccessKey: 'Delete Roles & Permissions',
            isWithImage: false,
            columns: headerColumns,
            valueGetters: [
              (b) => b.name,
              (b) => b.timestamp != null
                  ? DateFormat('dd MMM yyyy').format(b.timestamp!.toDate())
                  : '',
            ],
            getId: (b) => b.id,
            selectedIds: selectedRoleIds,
            onSelectChanged: (val, role) {
              setState(() {
                if (val == true) {
                  selectedRoleIds.add(role.id!);
                } else {
                  selectedRoleIds.remove(role.id);
                }
              });
            },
            onView: (role) {
              // Text('Tehjsnksd dkn dksnkld ksjdkjs');
            },
            onDelete: (p0) {},
            onEdit: (role) {
              rolesBeingEdited = role;
              showAlert(
                isEdit: true,
                roles: rolesBeingEdited,
                onBack: () async {
                  await _loadRoles();
                },
              );
            },
            onStatus: (role) {},
            statusTextGetter: (item) => item.status.capitalizeFirst,
            onSelectAll: (val) {
              setState(() {
                final ids = pagedProducts.map((e) => e.id!).toList();
                if (val == true) {
                  selectedRoleIds.addAll(ids);
                } else {
                  selectedRoleIds.removeAll(ids);
                }
              });
            },
            onSearch: (query) {
              setState(() {
                displayedRoles = allRoles
                    .where(
                      (b) => b.name.toLowerCase().contains(query.toLowerCase()),
                    )
                    .toList();
              });
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: PaginationWidget(
              currentPage: currentPage,
              totalItems: allRoles.length,
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
          ),
        ],
      ),
    );
  }
}
