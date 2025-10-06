import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/units/add_edit_role_unit.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

class UnitMainPage extends StatefulWidget {
  const UnitMainPage({super.key});

  @override
  State<UnitMainPage> createState() => _UnitMainPageState();
}

class _UnitMainPageState extends State<UnitMainPage> {
  bool showProductList = true;
  bool isLoading = true;
  List<UnitModel> allUnits = [];
  List<UnitModel> displayedUnits = [];
  UnitModel? unitsBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedUnitIds = {};

  Future<void> _deleteSelectedRole() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedUnitIds.length,
    );

    if (confirm != true) return;

    for (String unitId in selectedUnitIds) {
      await FirebaseFirestore.instance.collection('unit').doc(unitId).delete();
    }

    setState(() {
      selectedUnitIds.clear();
    });

    await _loadRoles();
  }

  final headers = ["Unit Name".tr(), "Created Date".tr()];

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() {
      isLoading = true;
    });
    final units = await DataFetchService.fetchUnits();
    setState(() {
      allUnits = units;
      displayedUnits = units;
      isLoading = false;
    });
  }

  List<List<dynamic>> getRowsFromUnits(List<UnitModel> allUnits) {
    return allUnits.map((unit) {
      return [
        unit.name,
        unit.timestamp != null
            ? DateFormat('dd MMM yyyy').format(unit.timestamp!.toDate())
            : '',
      ];
    }).toList();
  }

  void showAlert({
    bool isEdit = false,
    UnitModel? units,
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
            content: AddEditUnitWidget(
              isEdit: isEdit,
              unitModel: units,
              onBack: onBack,
            ),
          ),
        );
      } catch (e) {
        print("Error showing dialog: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pagedProducts = displayedUnits
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
            title: "Units List".tr(),
            buttonText: "Add Unit".tr(),
            subTitle: "Manage your Units".tr(),
            selectedItems: selectedUnitIds.toList(),
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
              final rowsToExport = getRowsFromUnits(pagedProducts);
              await PdfExporter.exportToPdf(
                headers: headers,
                rows: rowsToExport,
                fileNamePrefix: 'Units_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getRowsFromUnits(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: headers,
                rows: rowsToExport,
                fileNamePrefix: 'Units_Report',
              );
            },
          ),
          DynamicDataTable<UnitModel>(
            data: pagedProducts,
            isWithImage: false,
            columns: headers,
            valueGetters: [
              (b) => b.name,
              (b) => b.timestamp != null
                  ? DateFormat('dd MMM yyyy').format(b.timestamp!.toDate())
                  : '',
            ],
            getId: (b) => b.id,
            selectedIds: selectedUnitIds,
            onSelectChanged: (val, role) {
              setState(() {
                if (val == true) {
                  selectedUnitIds.add(role.id);
                } else {
                  selectedUnitIds.remove(role.id);
                }
              });
            },
            onView: (unit) {},
            onEdit: (unit) {
              unitsBeingEdited = unit;
              showAlert(
                isEdit: true,
                units: unitsBeingEdited,
                onBack: () async {
                  await _loadRoles();
                },
              );
            },
            onStatus: (unit) {},
            statusTextGetter: (item) => item.status.capitalizeFirst,
            onSelectAll: (val) {
              setState(() {
                final ids = pagedProducts.map((e) => e.id).toList();
                if (val == true) {
                  selectedUnitIds.addAll(ids);
                } else {
                  selectedUnitIds.removeAll(ids);
                }
              });
            },
            onSearch: (query) {
              setState(() {
                displayedUnits = allUnits
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
              totalItems: allUnits.length,
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
