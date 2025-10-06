import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/nationality_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/nationality/nationality_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class NationalityPage extends StatefulWidget {
  const NationalityPage({super.key});

  @override
  State<NationalityPage> createState() => _NationalityPageState();
}

class _NationalityPageState extends State<NationalityPage> {
  bool showCategoryList = true;
  bool isLoading = true;
  List<NationalityModel> allNaionalities = [];
  List<NationalityModel> displayedNaionalities = [];
  NationalityModel? countryBeingEdited;
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCategoryIds = {};

  final headerColumns = [
    "Nationality".tr(),
    "Nationality (Arabic)".tr(),
    "Create On".tr(),
  ];

  Future<void> _deleteSelectedCategories() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedCategoryIds.length,
    );

    if (confirm != true) return;

    for (String categoryId in selectedCategoryIds) {
      await FirebaseFirestore.instance
          .collection('nationality')
          .doc(categoryId)
          .delete();
    }

    setState(() {
      selectedCategoryIds.clear();
    });

    await _loadCategories();
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoading = true;
    });
    final nationalities = await DataFetchService.fetchNationalities();
    setState(() {
      allNaionalities = nationalities;
      displayedNaionalities = nationalities;
      isLoading = false;
    });
  }

  List<List<dynamic>> getCountryRowsForExcel(
    List<NationalityModel> nationalities,
  ) {
    return nationalities.map((nationality) {
      return [
        nationality.nationality,
        nationality.nationalityArabic,
        nationality.timestamp != null
            ? nationality.timestamp!.toDate().formattedWithDayMonthYear
            : '',
      ];
    }).toList();
  }

  void showAlert({
    bool isEdit = false,
    NationalityModel? nationalityModel,
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
            content: NationalityFormWidget(
              isEdit: isEdit,
              nationalityModel: nationalityModel,
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

    final pagedProducts = displayedNaionalities
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return
    // showCategoryList
    //   ?
    SingleChildScrollView(
      child: Column(
        children: [
          PageHeaderWidget(
            title: "Nationality".tr(),
            buttonText: "Add Nationality".tr(),
            subTitle: "Manage Nationalities".tr(),
            requiredPermission: 'Add Nationality',
            selectedItems: selectedCategoryIds.toList(),
            buttonWidth: 0.34,
            onCreate: () {
              Future.microtask(() {
                if (mounted) {
                  showAlert(
                    isEdit: false,
                    onBack: () async {
                      await _loadCategories();
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
                fileNamePrefix: 'Nationality_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getCountryRowsForExcel(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Nationality_Report',
              );
            },
          ),
          allNaionalities.isEmpty
              ? EmptyWidget(text: "No Nationality added yet..")
              : DynamicDataTable<NationalityModel>(
                  data: pagedProducts,
                  editProfileAccessKey: 'Edit Nationality',
                  deleteProfileAccessKey: 'Delete Nationality',
                  columns: headerColumns,
                  valueGetters: [
                    (v) => v.nationality,
                    (v) => v.nationalityArabic,
                    (v) => v.timestamp!.toDate().formattedWithDayMonthYear,
                  ],
                  getId: (v) => v.id,
                  selectedIds: selectedCategoryIds,
                  onSelectChanged: (val, cat) {
                    setState(() {
                      if (val == true) {
                        selectedCategoryIds.add(cat.id!);
                      } else {
                        selectedCategoryIds.remove(cat.id);
                      }
                    });
                  },
                  onStatus: (category) {},
                  statusTextGetter: (item) => item.status!.capitalizeFirst,
                  onEdit: (caty) {
                    countryBeingEdited = caty;
                    showAlert(
                      isEdit: true,
                      nationalityModel: countryBeingEdited,
                      onBack: () async {
                        await _loadCategories();
                      },
                    );
                  },
                  onDelete: (p0) {},
                  onSelectAll: (val) {
                    setState(() {
                      final ids = pagedProducts.map((e) => e.id!).toList();
                      if (val == true) {
                        selectedCategoryIds.addAll(ids);
                      } else {
                        selectedCategoryIds.removeAll(ids);
                      }
                    });
                  },
                  onSearch: (query) {
                    setState(() {
                      displayedNaionalities = allNaionalities
                          .where(
                            (category) => category.nationality
                                .toLowerCase()
                                .contains(query.toLowerCase()),
                          )
                          .toList();
                    });
                  },
                ),
          Align(
            alignment: Alignment.topRight,
            child: PaginationWidget(
              currentPage: currentPage,
              totalItems: allNaionalities.length,
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
