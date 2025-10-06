import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/terms/terms_of_sale_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/modern_motors/widgets/terms_and_conditions_of_sale_form_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ManageTermsAndConditionsOfSale extends StatefulWidget {
  const ManageTermsAndConditionsOfSale({super.key});

  @override
  State<ManageTermsAndConditionsOfSale> createState() => _ProductPageState();
}

class _ProductPageState extends State<ManageTermsAndConditionsOfSale> {
  bool showTermsList = true;
  bool isLoading = true;

  // List<TermsAndConditionsOfSalesModel> terms = [];
  List<TermsAndConditionsOfSalesModel> allTermAndConditions = [];
  TermsOfSalesModel? termsOfSalesModel;

  List<TermsAndConditionsOfSalesModel> displayedTermAndConditions = [];
  TermsAndConditionsOfSalesModel? termsBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCategoryIds = {};
  final headerColumns = ["Title".tr(), "Description".tr(), "Create On".tr()];

  Future<void> _deleteSelectedCategories() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedCategoryIds.length,
    );

    if (confirm != true) return;

    for (String categoryId in selectedCategoryIds) {
      await FirebaseFirestore.instance
          .collection('termsAndConditionsOfSale')
          .doc(categoryId)
          .delete();
    }

    setState(() {
      selectedCategoryIds.clear();
    });

    await _loadTermAndConditions();
  }

  @override
  void initState() {
    super.initState();
    _loadTermAndConditions();
  }

  Future<void> _loadTermAndConditions() async {
    setState(() {
      isLoading = true;
    });
    final termsAndConditions = await DataFetchService.fetchTerms();
    setState(() {
      termsOfSalesModel = termsAndConditions;
      if (termsOfSalesModel != null) {
        allTermAndConditions = termsOfSalesModel?.terms ?? [];
        displayedTermAndConditions = termsOfSalesModel?.terms ?? [];
      }

      isLoading = false;
    });
  }

  List<List<dynamic>> getTermAndConditionsRowsForExcel(
    List<TermsAndConditionsOfSalesModel> terms,
  ) {
    return terms.map((term) {
      return [
        term.index,
        term.createdAt != null
            ? term.createdAt!.toDate().formattedWithDayMonthYear
            : '',
      ];
    }).toList();
  }

  void showAlert({
    bool isEdit = false,
    TermsAndConditionsOfSalesModel? termsAndConditionModel,
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
            content: TermConditionsForSaleFormWidget(
              isEdit: isEdit,
              termsModel: termsAndConditionModel,
              termsList: allTermAndConditions,
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

    final pagedProducts = displayedTermAndConditions
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return showTermsList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: "Term & Conditions".tr(),
                  buttonText: "Add Term & Conditions".tr(),
                  subTitle: "Manage Term & Conditions".tr(),
                  requiredPermission: 'Add Terms & Conditions of Sales',
                  selectedItems: selectedCategoryIds.toList(),
                  buttonWidth: 0.36,
                  onCreate: () {
                    showTermsList = false;
                    setState(() {});
                    // Future.microtask(() {
                    //   if (mounted) {
                    //     showAlert(
                    //       isEdit: false,
                    //       onBack: () async {
                    //         await _loadTermAndConditions();
                    //       },
                    //     );
                    //   }
                    // });
                  },
                  onDelete: _deleteSelectedCategories,
                  onPdfImport: () async {
                    final rowsToExport = getTermAndConditionsRowsForExcel(
                      pagedProducts,
                    );
                    await PdfExporter.exportToPdf(
                      headers: headerColumns,
                      rows: rowsToExport,
                      fileNamePrefix: 'Term & Conditions_Report',
                    );
                  },
                  onExelImport: () async {
                    final rowsToExport = getTermAndConditionsRowsForExcel(
                      pagedProducts,
                    );
                    await ExcelExporter.exportToExcel(
                      headers: headerColumns,
                      rows: rowsToExport,
                      fileNamePrefix: 'Term & Conditions_Report',
                    );
                  },
                ),
                allTermAndConditions.isEmpty
                    ? EmptyWidget(text: "No Term & Conditions added yet..")
                    : DynamicDataTable<TermsAndConditionsOfSalesModel>(
                        data: pagedProducts,
                        editProfileAccessKey:
                            'Edit Terms & Conditions of Sales',
                        isCheckbox: false,
                        deleteProfileAccessKey:
                            'Delete Terms & Conditions of Sales',
                        columns: headerColumns,
                        valueGetters: [
                          (v) => v.title,
                          (v) => v.description,
                          (v) =>
                              v.createdAt!.toDate().formattedWithDayMonthYear,
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
                        onDelete: (p0) {},
                        onEdit: (caty) {
                          termsBeingEdited = caty;
                          showTermsList = false;
                          setState(() {}); // showAlert(
                          //   isEdit: true,
                          //   termsAndConditionModel: termsBeingEdited,
                          //   onBack: () async {
                          //     await _loadTermAndConditions();
                          //   },
                          // );
                        },
                        onSelectAll: (val) {
                          setState(() {
                            final ids = pagedProducts
                                .map((e) => e.id!)
                                .toList();
                            if (val == true) {
                              selectedCategoryIds.addAll(ids);
                            } else {
                              selectedCategoryIds.removeAll(ids);
                            }
                          });
                        },
                        onSearch: (query) {
                          setState(() {
                            displayedTermAndConditions = allTermAndConditions
                                .where(
                                  (category) => category.title
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
                    totalItems: allTermAndConditions.length,
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
          )
        : TermConditionsForSaleFormWidget(
            isEdit: termsBeingEdited != null,
            termsModel: termsBeingEdited,
            termsList: allTermAndConditions,
            docId: termsOfSalesModel!.id,
            onBack: () async {
              showTermsList = true;
              termsBeingEdited = null;
              await _loadTermAndConditions();
            },
          );
  }
}
