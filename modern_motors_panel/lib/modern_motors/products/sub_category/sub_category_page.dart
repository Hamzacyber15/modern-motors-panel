import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/products/sub_category/sub_category_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import '../../widgets/page_header_widget.dart';
import '../../widgets/reusable_data_table.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({super.key});

  @override
  State<SubCategoryPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<SubCategoryPage> {
  bool showCategoryList = true;
  bool isLoading = true;

  List<ProductSubCatorymodel> allSubCategories = [];
  List<ProductCategoryModel> allCategories = [];
  List<ProductSubCatorymodel> displayedSubCategories = [];
  List<ProductCategoryModel> displayedCategories = [];

  ProductSubCatorymodel? categoryBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCategoryIds = {};

  final List<String> subCategoryHeaders = [
    "Sub Category".tr(),
    "Category Name".tr(),
    "Create On".tr(),
  ];

  List<List<dynamic>> getSubCategoryRowsForExcel(
    List<ProductSubCatorymodel> data,
  ) {
    return data.map((sub) {
      final categoryName = allCategories
          .firstWhere(
            (cat) => cat.id == sub.catId![0],
            orElse: () => ProductCategoryModel(productName: 'N/A'),
          )
          .productName;

      return [
        sub.name,
        categoryName,
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
          .collection('category')
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
    final subCategories = await DataFetchService.fetchSubCategories();
    final categories = await DataFetchService.fetchProduct();
    setState(() {
      allSubCategories = subCategories;
      displayedSubCategories = subCategories;
      allCategories = categories;
      displayedCategories = categories;
      isLoading = false;
    });
  }

  void showAlert({
    bool isEdit = false,
    ProductSubCatorymodel? categoryModel,
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
            content: SubCategoryFormWidget(
              isEdit: isEdit,
              subCategoryModel: categoryModel,
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

    final pagedProducts = displayedSubCategories
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
            title: "Sub Category".tr(),
            buttonText: "Add Sub Category".tr(),
            subTitle: "Add your Sub categories".tr(),
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
              final rowsToExport = getSubCategoryRowsForExcel(pagedProducts);
              await PdfExporter.exportToPdf(
                headers: subCategoryHeaders,
                rows: rowsToExport,
                fileNamePrefix: 'Product_Sub_Categories_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getSubCategoryRowsForExcel(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: subCategoryHeaders,
                rows: rowsToExport,
                fileNamePrefix: 'Product_Sub_Categories_Report',
              );
            },
          ),
          allSubCategories.isEmpty
              ? EmptyWidget(text: "Sub category has not been added yet.".tr())
              : DynamicDataTable<ProductSubCatorymodel>(
                  data: pagedProducts,
                  columns: subCategoryHeaders,
                  valueGetters: [
                    (v) => v.name,
                    (v) => allCategories
                        .firstWhere((cat) => cat.id == v.catId![0])
                        .productName,
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
                    categoryBeingEdited = caty;
                    showAlert(
                      isEdit: true,
                      categoryModel: categoryBeingEdited,
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
                      displayedSubCategories = allSubCategories
                          .where(
                            (category) => category.name.toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                          )
                          .toList();
                    });
                  },
                ),
          Align(
            alignment: Alignment.topRight,
            child: PaginationWidget(
              currentPage: currentPage,
              totalItems: allSubCategories.length,
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
