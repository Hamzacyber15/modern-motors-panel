import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/service_type_card.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/services_type_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ManageServiceTypes extends StatefulWidget {
  const ManageServiceTypes({super.key});

  @override
  State<ManageServiceTypes> createState() => _ManageServiceTypesState();
}

class _ManageServiceTypesState extends State<ManageServiceTypes> {
  bool showCategoryList = true;
  bool isLoading = true;

  List<ServiceTypeModel> allServices = [];

  List<ServiceTypeModel> displayedServices = [];

  ServiceTypeModel? serviceBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedExpensesIds = {};

  final headerColumns = ["Name".tr(), "Create On".tr()];

  Future<void> _deleteSelectedCategories() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedExpensesIds.length,
    );

    if (confirm != true) return;

    for (String categoryId in selectedExpensesIds) {
      await FirebaseFirestore.instance
          .collection('serviceTypes')
          .doc(categoryId)
          .delete();
    }

    setState(() {
      selectedExpensesIds.clear();
    });

    await _loadServices();
  }

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      isLoading = true;
    });
    final services = await DataFetchService.fetchServiceTypes();
    setState(() {
      allServices = services;
      displayedServices = services;
      isLoading = false;
    });
  }

  List<List<dynamic>> getCountryRowsForExcel(List<ServiceTypeModel> expanses) {
    return expanses.map((expanse) {
      return [
        expanse.name,
        expanse.timestamp != null
            ? expanse.timestamp!.toDate().formattedWithDayMonthYear
            : '',
      ];
    }).toList();
  }

  void showAlert({
    bool isEdit = false,
    ServiceTypeModel? servicesModel,
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
            content: ServiceTypeFormWidget(
              isEdit: isEdit,
              serviceTypeModel: servicesModel,
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

    final pagedProducts = displayedServices
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return
    // showCategoryList
    //   ?
    Column(
      children: [
        PageHeaderWidget(
          title: "Services".tr(),
          buttonText: "Add Service Type".tr(),
          subTitle: "Manage Service Types".tr(),
          requiredPermission: 'Add Service Type',
          selectedItems: selectedExpensesIds.toList(),
          buttonWidth: 0.34,
          onCreate: () {
            Future.microtask(() {
              if (mounted) {
                showAlert(
                  isEdit: false,
                  onBack: () async {
                    await _loadServices();
                  },
                );
              }
            });
          },
          onDelete: _deleteSelectedCategories,
          onPdfImport: () async {
            final rowsToExport = getCountryRowsForExcel(pagedProducts);
            await PdfExporter.exportToPdf(
              headers: headerColumns,
              rows: rowsToExport,
              fileNamePrefix: 'Expanses_Report',
            );
          },
          onExelImport: () async {
            final rowsToExport = getCountryRowsForExcel(pagedProducts);
            await ExcelExporter.exportToExcel(
              headers: headerColumns,
              rows: rowsToExport,
              fileNamePrefix: 'Expanses_Report',
            );
          },
        ),

        allServices.isEmpty
            ? EmptyWidget(text: "No Service Types added yet..")
            : Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${pagedProducts.length} ${'products found'.tr()}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (pagedProducts.length != allServices.length)
                            TextButton(
                              onPressed: () {},
                              child: Text('Clear Filters'.tr()),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ServiceTypeCardListView(
                        servicesList: pagedProducts,
                        selectedIds: selectedExpensesIds,
                      ),
                    ),
                  ],
                ),
              ),
        // : DynamicDataTable<ServiceTypeModel>(
        //   data: pagedProducts,
        //   editProfileAccessKey: 'Edit Service Type',
        //   deleteProfileAccessKey: 'Delete Service Type',
        //   columns: headerColumns,
        //   valueGetters: [
        //     (v) => v.name,
        //     (v) => v.timestamp!.toDate().formattedWithDayMonthYear,
        //   ],
        //   getId: (v) => v.id,
        //   selectedIds: selectedExpensesIds,
        //   onSelectChanged: (val, cat) {
        //     setState(() {
        //       if (val == true) {
        //         selectedExpensesIds.add(cat.id!);
        //       } else {
        //         selectedExpensesIds.remove(cat.id);
        //       }
        //     });
        //   },
        //   onStatus: (category) {},
        //   statusTextGetter: (item) => item.status.capitalizeFirst,
        //   onDelete: (p0) {},
        //   onEdit: (caty) {
        //     serviceBeingEdited = caty;
        //     showAlert(
        //       isEdit: true,
        //       servicesModel: serviceBeingEdited,
        //       onBack: () async {
        //         await _loadServices();
        //       },
        //     );
        //   },
        //   onSelectAll: (val) {
        //     setState(() {
        //       final ids = pagedProducts.map((e) => e.id!).toList();
        //       if (val == true) {
        //         selectedExpensesIds.addAll(ids);
        //       } else {
        //         selectedExpensesIds.removeAll(ids);
        //       }
        //     });
        //   },
        //   onSearch: (query) {
        //     setState(() {
        //       displayedServices =
        //           allServices
        //               .where(
        //                 (category) => category.name
        //                     .toLowerCase()
        //                     .contains(query.toLowerCase()),
        //               )
        //               .toList();
        //     });
        //   },
        // ),
        Align(
          alignment: Alignment.topRight,
          child: PaginationWidget(
            currentPage: currentPage,
            totalItems: allServices.length,
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
    );
  }
}
