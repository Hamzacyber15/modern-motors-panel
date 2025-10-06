import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/vendor/vendor_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({super.key});

  @override
  State<VendorPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<VendorPage> {
  bool showProductList = true;
  bool isLoading = true;

  List<VendorModel> allVendors = [];
  List<VendorModel> displayedVendors = [];

  VendorModel? vendorBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedProductIds = {};

  final headerColumns = [
    "Company Name".tr(),
    "CR Number".tr(),
    "Contact Number".tr(),
    "Address".tr(),
    "Manager Name".tr(),
    "Manager Number".tr(),
    "Manager Nationality".tr(),
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _deleteSelectedVendor() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedProductIds.length,
    );

    if (confirm != true) return;

    for (String productId in selectedProductIds) {
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(productId)
          .delete();
    }

    setState(() {
      selectedProductIds.clear();
    });

    await _loadProducts();
  }

  List<List<dynamic>> getVendorRowsForExcel(List<VendorModel> vendors) {
    return vendors.map((v) {
      final managerNames =
          v.managers?.map((m) => m.name).join(', ') ?? 'No Managers';
      final managerNumbers =
          v.managers?.map((m) => m.number).join(', ') ?? 'No Managers';
      final managerNationalities =
          v.managers?.map((m) => m.nationality).join(', ') ?? 'No Managers';

      return [
        v.vendorName,
        v.crNumber ?? '',
        v.contactNumber ?? '',
        v.address ?? '',
        managerNames,
        managerNumbers,
        managerNationalities,
      ];
    }).toList();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    final products = await DataFetchService.fetchVendor();
    setState(() {
      allVendors = products;
      displayedVendors = products;
      isLoading = false;
    });
  }

  void showAlert({
    bool isEdit = false,
    VendorModel? vendor,
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
            content: VerdorFormWidget(
              isEdit: isEdit,
              vendorModel: vendor,
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

    final pagedProducts = displayedVendors
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
            title: "Vendors List".tr(),
            buttonText: "Add Vendor".tr(),
            subTitle: "Manage your vendors".tr(),
            selectedItems: selectedProductIds.toList(),
            buttonWidth: 0.24,
            onCreate: () {
              Future.microtask(() {
                if (mounted) {
                  showAlert(isEdit: false);
                }
              });
            },
            onDelete: _deleteSelectedVendor,
            onPdfImport: () async {
              final rowsToExport = getVendorRowsForExcel(pagedProducts);
              await PdfExporter.exportToPdf(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Vendors_Report',
              );
            },
            onExelImport: () async {
              final rowsToExport = getVendorRowsForExcel(pagedProducts);
              await ExcelExporter.exportToExcel(
                headers: headerColumns,
                rows: rowsToExport,
                fileNamePrefix: 'Vendors_Report',
              );
            },
          ),
          DynamicDataTable<VendorModel>(
            data: pagedProducts,
            isWithImage: true,
            combineImageWithTextIndex: 0,
            columns: headerColumns,
            valueGetters: [
              (v) => '${v.vendorName} , ${v.imageUrl}',
              (v) => v.crNumber ?? '',
              (v) => v.contactNumber ?? '',
              (v) => v.address ?? '',
              (v) => v.managers?.map((m) => m.name).join(', ') ?? 'No Managers',
              (v) =>
                  v.managers?.map((m) => m.number).join(', ') ?? 'No Managers',
              (v) =>
                  v.managers?.map((m) => m.nationality).join(', ') ??
                  'No Managers',
            ],
            getId: (v) => v.id,
            selectedIds: selectedProductIds,
            onSelectChanged: (val, vendor) {
              setState(() {
                if (val == true) {
                  selectedProductIds.add(vendor.id!);
                } else {
                  selectedProductIds.remove(vendor.id);
                }
              });
            },
            onView: (vendor) {},
            onEdit: (vendor) {
              vendorBeingEdited = vendor;
              showAlert(
                isEdit: true,
                vendor: vendorBeingEdited,
                onBack: () async {
                  await _loadProducts();
                },
              );
              // setState(() {
              //   vendorBeingEdited = vendor;
              //   showProductList = false;
              //   vendorBeingEdited = vendor;
              // });
            },
            onStatus: (vendor) {},
            statusTextGetter: (item) => item.status!.capitalizeFirst,
            onSelectAll: (val) {
              setState(() {
                final ids = pagedProducts.map((e) => e.id!).toList();
                if (val == true) {
                  selectedProductIds.addAll(ids);
                } else {
                  selectedProductIds.removeAll(ids);
                }
              });
            },
            onSearch: (query) {
              setState(() {
                displayedVendors = allVendors
                    .where(
                      (v) => v.vendorName.toLowerCase().contains(
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
              totalItems: allVendors.length,
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
    // : AddEditVendorPage(
    //   isEdit: vendorBeingEdited != null,
    //
    //   vendorModel: vendorBeingEdited,
    //   onBack: () async {
    //     await _loadProducts();
    //     setState(() {
    //       showProductList = true;
    //       vendorBeingEdited = null;
    //     });
    //   },
    // );
  }
}
