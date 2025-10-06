import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/brands/brand_form_widget.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<BrandPage> {
  bool showBrandList = true;
  bool isLoading = true;

  List<BrandModel> allBrands = [];
  List<BrandModel> displayedBrands = [];

  BrandModel? brandBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedBrandIds = {};

  final List<String> brandHeaders = ["Brand Name".tr(), "Created On".tr()];

  List<List<dynamic>> getBrandRowsForExcel(List<BrandModel> brands) {
    return brands.map((brand) {
      return [
        brand.name,
        brand.timestamp?.toDate().formattedWithDayMonthYear ?? '',
      ];
    }).toList();
  }

  Future<void> _deleteSelectedBrands() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedBrandIds.length,
    );

    if (confirm != true) return;

    for (String brandId in selectedBrandIds) {
      await FirebaseFirestore.instance
          .collection('brand')
          .doc(brandId)
          .delete();
    }

    setState(() {
      selectedBrandIds.clear();
    });

    await _loadBrands();
  }

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    setState(() {
      isLoading = true;
    });
    final products = await DataFetchService.fetchBrands();
    setState(() {
      allBrands = products;
      displayedBrands = products;
      isLoading = false;
    });
  }

  void showAlert({
    bool isEdit = false,
    BrandModel? brandModel,
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
            content: BrandFormWidget(
              isEdit: isEdit,
              brandModel: brandModel,
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

    final pagedProducts = displayedBrands
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return
    // showBrandList
    //   ?
    SingleChildScrollView(
      child: Column(
        children: [
          PageHeaderWidget(
            title: "Brands".tr(),
            buttonText: "Add New Brands".tr(),
            subTitle: "Add your Brands".tr(),
            selectedItems: selectedBrandIds.toList(),
            buttonWidth: 0.34,
            onCreate: () {
              Future.microtask(() {
                if (mounted) {
                  showAlert(
                    isEdit: false,
                    onBack: () async {
                      await _loadBrands();
                    },
                  );
                }
              });
            },
            onDelete: _deleteSelectedBrands,
            onPdfImport: () async {
              final rowsToExport = getBrandRowsForExcel(pagedProducts);
              await PdfExporter.exportToPdf(
                headers: brandHeaders,
                rows: rowsToExport,
                fileNamePrefix: 'Brands_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getBrandRowsForExcel(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: brandHeaders,
                rows: rowsToExport,
                fileNamePrefix: 'Brands_Report',
              );
            },
          ),

          // ReusableHeader(
          //   title: 'Brands',
          //   selectedItems: selectedBrandIds.toList(),
          //   onSearch: (query) {
          //     setState(() {
          //       displayedBrands =
          //           allBrands
          //               .where(
          //                 (brand) => brand.name.toLowerCase().contains(
          //                   query.toLowerCase(),
          //                 ),
          //               )
          //               .toList();
          //     });
          //   },
          //   onCreate: () {
          //     setState(() {
          //       showBrandList = false;
          //     });
          //   },
          //   onDelete: _deleteSelectedBrands,
          // ),
          DynamicDataTable<BrandModel>(
            data: pagedProducts,
            columns: brandHeaders,
            valueGetters: [
              (v) => v.name,
              (v) => v.timestamp!.toDate().formattedWithDayMonthYear,
            ],
            getId: (v) => v.id,
            selectedIds: selectedBrandIds,
            onSelectChanged: (val, cat) {
              setState(() {
                if (val == true) {
                  selectedBrandIds.add(cat.id!);
                } else {
                  selectedBrandIds.remove(cat.id);
                }
              });
            },
            onStatus: (brand) {},
            statusTextGetter: (item) => item.status.capitalizeFirst,
            onEdit: (brand) {
              brandBeingEdited = brand;
              showAlert(
                isEdit: true,
                brandModel: brandBeingEdited,
                onBack: () async {
                  await _loadBrands();
                },
              );
            },
            onSelectAll: (val) {
              setState(() {
                final ids = pagedProducts.map((e) => e.id!).toList();
                if (val == true) {
                  selectedBrandIds.addAll(ids);
                } else {
                  selectedBrandIds.removeAll(ids);
                }
              });
            },
            onSearch: (query) {
              setState(() {
                displayedBrands = allBrands
                    .where(
                      (brand) => brand.name.toLowerCase().contains(
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
              totalItems: allBrands.length,
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
