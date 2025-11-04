import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/purchase_models/expense_category_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/purchase/expense_category_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/purchase/expense_category_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/provider/resource_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:provider/provider.dart';

class ExpenseCategoryPage extends StatefulWidget {
  const ExpenseCategoryPage({super.key});

  @override
  State<ExpenseCategoryPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ExpenseCategoryPage> {
  bool showCategoryList = true;
  bool isLoading = true;

  List<ExpenseCategoryModel> allCategories = [];
  List<ExpenseCategoryModel> displayedSubCategories = [];

  ExpenseCategoryModel? categoryBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCategoryIds = {};

  final List<String> expenseCategoryHeaders = [
    "Sub Category".tr(),
    "Create On".tr(),
  ];

  List<List<dynamic>> getExpenseCategoryRowsForExcel(
    List<ExpenseCategoryModel> data,
  ) {
    return data.map((sub) {
      return [
        sub.name,
        sub.timestamp?.toDate().formattedWithDayMonthYear ?? '',
      ];
    }).toList();
  }

  Future<void> _deleteSelectedCategories() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedCategoryIds.length,
    );

    if (confirm != true) return;

    for (String categoryId in selectedCategoryIds) {
      await FirebaseFirestore.instance
          .collection('expenseCategory')
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
    final categories = await DataFetchService.fetchExpenseCategories();
    setState(() {
      allCategories = categories;
      displayedSubCategories = categories;
      isLoading = false;
    });
  }

  void showAlert({
    bool isEdit = false,
    ExpenseCategoryModel? categoryModel,
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
            content: ExpenseCategoryFormWidget(
              isEdit: isEdit,
              expenseCategoryModel: categoryModel,
              onBack: onBack,
            ),
          ),
        );
      } catch (e) {
        debugPrint("Error showing dialog: $e");
      }
    });
  }

  void getSubCategory(ExpenseCategoryModel model) {
    categoryBeingEdited = model;
    showAlert(
      isEdit: true,
      categoryModel: categoryBeingEdited,
      onBack: () async {
        categoryBeingEdited = null;
        // await _loadCategories();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceProvider>(
      builder: (context, resource, child) {
        allCategories = resource.expenseCategoryList;
        return Column(
          children: [
            PageHeaderWidget(
              title: "Expense Category".tr(),
              buttonText: "Add Category".tr(),
              subTitle: "Add your categories".tr(),
              requiredPermission: 'Add Expenses Category',
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
                final rowsToExport = getExpenseCategoryRowsForExcel(
                  allCategories,
                );
                await PdfExporter.exportToPdf(
                  headers: expenseCategoryHeaders,
                  rows: rowsToExport,
                  fileNamePrefix: 'Expense_Categories_Report',
                );
              },
              onExelImport: () async {
                final rowsToExport = getExpenseCategoryRowsForExcel(
                  allCategories,
                );
                await ExcelExporter.exportToExcel(
                  headers: expenseCategoryHeaders,
                  rows: rowsToExport,
                  fileNamePrefix: 'Expense_Categories_Report',
                );
              },
            ),

            allCategories.isEmpty
                ? EmptyWidget(
                    text: "Expense category has not been added yet.".tr(),
                  )
                // : Container(),
                : Expanded(
                    child: ExpenseCategoryCardListView(
                      expenseCategoriesList: allCategories,
                      selectedIds: selectedCategoryIds,
                      onEdit: getSubCategory,
                    ),
                  ),
            Align(
              alignment: Alignment.topRight,
              child: PaginationWidget(
                currentPage: currentPage,
                totalItems: allCategories.length,
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
      },
    );
  }
}
