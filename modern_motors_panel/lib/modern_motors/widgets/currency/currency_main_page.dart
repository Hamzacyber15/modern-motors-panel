import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/currency/currency_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import '../../widgets/page_header_widget.dart';
import '../../widgets/reusable_data_table.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<CurrencyPage> {
  bool showCategoryList = true;
  bool isLoading = true;
  List<CurrencyModel> allCurrencies = [];
  List<CurrencyModel> displayedCurrencies = [];
  CurrencyModel? currencyBeingEdited;
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCategoryIds = {};
  final headerColumns = ["Currency".tr(), "Create On".tr()];
  Future<void> _deleteSelectedCategories() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedCategoryIds.length,
    );
    if (confirm != true) return;
    for (String categoryId in selectedCategoryIds) {
      await FirebaseFirestore.instance
          .collection('currency')
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
    final currencies = await DataFetchService.fetchCurrencies();
    setState(() {
      allCurrencies = currencies;
      displayedCurrencies = currencies;
      isLoading = false;
    });
  }

  List<List<dynamic>> getCurrencyRowsForExcel(List<CurrencyModel> currencies) {
    return currencies.map((currency) {
      return [
        currency.currency,
        currency.timestamp != null
            ? currency.timestamp!.toDate().formattedWithDayMonthYear
            : '',
      ];
    }).toList();
  }

  void showAlert({
    bool isEdit = false,
    CurrencyModel? currencyModel,
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
            content: CurrencyFormWidget(
              isEdit: isEdit,
              currencyModel: currencyModel,
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

    final pagedProducts = displayedCurrencies
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
            title: "Currency".tr(),
            buttonText: "Add Currency".tr(),
            subTitle: "Add Currency Code".tr(),
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
              final rowsToExport = getCurrencyRowsForExcel(pagedProducts);
              await PdfExporter.exportToPdf(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Currencies_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getCurrencyRowsForExcel(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Currencies_Report',
              );
            },
          ),
          allCurrencies.isEmpty
              ? EmptyWidget(text: "No Currencies added yet..")
              : DynamicDataTable<CurrencyModel>(
                  data: pagedProducts,
                  columns: headerColumns,
                  valueGetters: [
                    (v) => v.currency,
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
                    currencyBeingEdited = caty;
                    showAlert(
                      isEdit: true,
                      currencyModel: currencyBeingEdited,
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
                      displayedCurrencies = allCurrencies
                          .where(
                            (category) => category.currency
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
              totalItems: allCurrencies.length,
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
