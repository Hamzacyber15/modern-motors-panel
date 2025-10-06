import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/country/country_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import '../../widgets/page_header_widget.dart';
import '../../widgets/reusable_data_table.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({super.key});

  @override
  State<CountryPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<CountryPage> {
  bool showCategoryList = true;
  bool isLoading = true;
  List<CountryModel> allCountries = [];
  List<CountryModel> displayedCountries = [];
  CountryModel? countryBeingEdited;
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCategoryIds = {};

  final headerColumns = ["Country".tr(), "Create On".tr()];

  Future<void> _deleteSelectedCategories() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedCategoryIds.length,
    );

    if (confirm != true) return;

    for (String categoryId in selectedCategoryIds) {
      await FirebaseFirestore.instance
          .collection('country')
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
    final countries = await DataFetchService.fetchCountries();
    setState(() {
      allCountries = countries;
      displayedCountries = countries;
      isLoading = false;
    });
  }

  List<List<dynamic>> getCountryRowsForExcel(List<CountryModel> countries) {
    return countries.map((country) {
      return [
        country.country,
        country.timestamp != null
            ? country.timestamp!.toDate().formattedWithDayMonthYear
            : '',
      ];
    }).toList();
  }

  void showAlert({
    bool isEdit = false,
    CountryModel? countryModel,
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
            content: CountryFormWidget(
              isEdit: isEdit,
              countryModel: countryModel,
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

    final pagedProducts = displayedCountries
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
            title: "Country".tr(),
            buttonText: "Add Country".tr(),
            subTitle: "Manage Countries".tr(),
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
                fileNamePrefix: 'Countries_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getCountryRowsForExcel(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Countries_Report',
              );
            },
          ),
          allCountries.isEmpty
              ? EmptyWidget(text: "No countries added yet..")
              : DynamicDataTable<CountryModel>(
                  data: pagedProducts,
                  columns: headerColumns,
                  valueGetters: [
                    (v) => v.country,
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
                  statusTextGetter: (item) => item.status.capitalizeFirst,
                  onEdit: (caty) {
                    countryBeingEdited = caty;
                    showAlert(
                      isEdit: true,
                      countryModel: countryBeingEdited,
                      onBack: () async {
                        await _loadCategories();
                      },
                    );
                  },
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
                      displayedCountries = allCountries
                          .where(
                            (category) => category.country
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
              totalItems: allCountries.length,
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
