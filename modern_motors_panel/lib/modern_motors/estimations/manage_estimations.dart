import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/estimates_models/estimates_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/modern_motors/estimations/make_estimation.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/invoices/estimation_invoice.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/qr_code_generator.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

class ManageEstimation extends StatefulWidget {
  const ManageEstimation({super.key});

  @override
  State<ManageEstimation> createState() => _ManageEstimationState();
}

class _ManageEstimationState extends State<ManageEstimation> {
  bool showEstimationList = true;
  bool isLoading = true;
  bool isPDfView = false;
  DateTimeRange? selectedDateRange;
  List<EstimationModel> allEstimation = [];
  List<EstimationModel> displayedEstimation = [];
  List<ProductModel> products = [];
  List<ProductModel> selectedProducts = [];
  List<CustomerModel> customers = [];
  List<InventoryModel> allInventories = [];
  List<InventoryModel> selectedInventories = [];
  EstimationModel? estimateBeingEdited;
  Template1Model template1Model = Template1Model();
  final Set<String> selectedEstimationIds = {};
  int currentPage = 0;
  int itemsPerPage = 10;
  int selectedTemplateIndex = 0;
  String selectedColumn = 'All';
  String selectedDateColumn = 'Last 7 days';
  final List<String> searchableColumns = ['All', 'ISH', 'Others'];
  final List<String> searchableDateColumns = [
    'Last 7 days',
    '1 month',
    '3 months',
    'Custom date',
  ];

  // Headers
  final headers = <String>[
    'Estimate #'.tr(),
    'Customer Name'.tr(),
    'Estimate Date'.tr(),
    'Items Total'.tr(),
    'Services Total'.tr(),
    'Discount'.tr(),
    'Tax'.tr(),
    'Total'.tr(),
    'Created At'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        DataFetchService.fetchEstimation(),
        DataFetchService.fetchTrucks(),
        DataFetchService.fetchCustomers(),
        DataFetchService.fetchInventory(),
        DataFetchService.fetchProducts(),
      ]);
      allEstimation = (results[0] as List<EstimationModel>);
      displayedEstimation = List.of(allEstimation);
      customers = (results[2] as List<CustomerModel>);
      allInventories = results[3] as List<InventoryModel>;
      products = results[4] as List<ProductModel>;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deleteSelected() async {
    final count = selectedEstimationIds.length;
    if (count == 0) return;

    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      count,
    );
    if (confirm != true) return;

    for (final id in selectedEstimationIds) {
      await FirebaseFirestore.instance
          .collection('estimations')
          .doc(id)
          .delete();
    }
    selectedEstimationIds.clear();
    await _loadBookings();
  }

  List<List<dynamic>> _rowsForExport(List<EstimationModel> estimation) {
    return estimation.map((b) {
      final customer = customers.firstWhere(
        (c) => c.id == b.customerId,
        orElse: () => CustomerModel(
          customerName: '',
          customerType: '',
          contactNumber: '',
          telePhoneNumber: '',
          streetAddress1: '',
          streetAddress2: '',
          city: '',
          state: '',
          postalCode: '',
          countryId: '',
          accountNumber: '',
          currencyId: '',
          emailAddress: '',
          bankName: '',
          notes: '',
          status: '',
          addedBy: '',
          codeNumber: '',
        ),
      );

      return [
        b.customerNumber ?? '',
        customer.customerName,
        b.visitingDate?.toDate().formattedWithDayMonthYear ?? '',
        (b.itemsTotal ?? 0).toStringAsFixed(2),
        (b.servicesTotal ?? 0).toStringAsFixed(2),
        (b.discountedAmount ?? 0).toStringAsFixed(2),
        (b.taxAmount ?? 0).toStringAsFixed(2),
        (b.total ?? 0).toStringAsFixed(2),
        b.createdAt?.toDate().formattedWithDayMonthYear ?? '',
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    final paged = displayedEstimation
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();
    if (isPDfView && estimateBeingEdited != null) {
      return EstimationInvoice(template1Model: template1Model);
    }
    return showEstimationList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: 'Estimations'.tr(),
                  buttonText: 'Create Estimate'.tr(),
                  subTitle: 'Manage Estimations'.tr(),
                  requiredPermission: 'Create Estimates',
                  selectedItems: selectedEstimationIds.toList(),
                  buttonWidth: 0.34,
                  onCreate: () {
                    setState(() {
                      estimateBeingEdited = null;
                      showEstimationList = false;
                    });
                  },
                  onDelete: _deleteSelected,
                  onPdfImport: () async {
                    final rows = _rowsForExport(paged);
                    await PdfExporter.exportToPdf(
                      headers: headers,
                      rows: rows,
                      fileNamePrefix: 'Estimation',
                    );
                  },
                  onExelImport: () async {
                    final rows = _rowsForExport(paged);
                    await ExcelExporter.exportToExcel(
                      headers: headers,
                      rows: rows,
                      fileNamePrefix: 'Estimation',
                    );
                  },
                ),
                DynamicDataTable<EstimationModel>(
                  data: paged,
                  columns: headers,
                  valueGetters: [
                    (v) => "${"EST"}-${v.customerNumber}",
                    (v) => v.customerId == null && v.customerId!.isEmpty
                        ? "N/A"
                        : customers
                              .firstWhere(
                                (customer) => customer.id == v.customerId,
                              )
                              .customerName,
                    (v) =>
                        v.visitingDate?.toDate().formattedWithDayMonthYear ??
                        '',
                    (v) => v.customerId == "ISH"
                        ? '-'
                        : (v.itemsTotal ?? 0).toStringAsFixed(2),
                    (v) => (v.servicesTotal ?? 0).toStringAsFixed(2),
                    (v) => (v.discountedAmount ?? 0).toStringAsFixed(2),
                    (v) => (v.taxAmount ?? 0).toStringAsFixed(2),
                    (v) => (v.total ?? 0).toStringAsFixed(2),
                    (v) =>
                        v.createdAt?.toDate().formattedWithDayMonthYear ?? '',
                  ],
                  getId: (v) => v.id,
                  selectedIds: selectedEstimationIds,
                  onSelectChanged: (selected, row) {
                    setState(() {
                      if (selected == true && row.id != null) {
                        selectedEstimationIds.add(row.id!);
                      } else {
                        selectedEstimationIds.remove(row.id);
                      }
                    });
                  },
                  onSelectAll: (value) {
                    setState(() {
                      final ids = paged
                          .map((e) => e.id!)
                          .whereType<String>()
                          .toList();
                      if (value == true) {
                        selectedEstimationIds.addAll(ids);
                      } else {
                        selectedEstimationIds.removeAll(ids);
                      }
                    });
                  },
                  onEdit: (estimation) {
                    selectedInventories = allInventories
                        .where(
                          (inventory) => estimation.items!.any(
                            (item) => item.productId == inventory.id,
                          ),
                        )
                        .toList();

                    for (var inv in selectedInventories) {
                      final product = products.firstWhere(
                        (pro) => pro.id == inv.productId,
                      );
                      selectedProducts.add(product);
                    }
                    setState(() {
                      estimateBeingEdited = estimation;
                      showEstimationList = false;
                    });
                  },
                  onView: (estimation) async {
                    estimateBeingEdited = estimation;
                    selectedInventories = allInventories
                        .where(
                          (inventory) => estimation.items!.any(
                            (item) => item.productId == inventory.id,
                          ),
                        )
                        .toList();
                    final customerModel = customers.firstWhere(
                      (customer) => customer.id == estimation.customerId,
                    );
                    // debugPrint(
                    //   'customerModel: ${customerModel.toIndividualMap()}',
                    // );
                    Uint8List qrBytes = await generateQrCodeBytes(
                      estimation.visitingDate.toString(),
                    );

                    template1Model = Template1Model(
                      // inventoryModelList: selectedInventories,
                      // estimationModel: estimation,
                      // customerModel: customerModel,
                    );

                    // template1Model = Template1Model(
                    //   bookingModel: estimation,
                    //   inventoryModelList: selectedInventories,
                    //   customerModel: customerModel,
                    //   qrBytes: qrBytes,
                    // );
                    isPDfView = true;
                    setState(() {});
                  },
                  onStatus: (row) {},
                  dropDownWidget: DropdownButton<String>(
                    value: selectedColumn,
                    items: searchableColumns
                        .map(
                          (col) =>
                              DropdownMenuItem(value: col, child: Text(col)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedColumn = val!;
                        final q = val.toLowerCase();
                        if (q == 'all') {
                          displayedEstimation = List.of(allEstimation);
                        } else if (q == 'ish') {
                          displayedEstimation = allEstimation
                              .where(
                                (estimation) => estimation.customerId == 'ISH',
                              )
                              .toList();
                        } else {
                          displayedEstimation = allEstimation
                              .where(
                                (estimation) => estimation.customerId != 'ISH',
                              )
                              .toList();
                        }
                      });
                    },
                  ),
                  statusTextGetter: (row) => (row.status ?? '').capitalizeFirst,
                  onSearch: (query) {
                    setState(() {
                      final q = query.toLowerCase();
                      displayedEstimation = allEstimation.where((b) {
                        final owner = customers.firstWhere(
                          (c) => c.id == b.customerId,
                          orElse: () => CustomerModel(
                            customerName: '',
                            customerType: '',
                            contactNumber: '',
                            telePhoneNumber: '',
                            streetAddress1: '',
                            streetAddress2: '',
                            city: '',
                            state: '',
                            postalCode: '',
                            countryId: '',
                            accountNumber: '',
                            currencyId: '',
                            emailAddress: '',
                            bankName: '',
                            notes: '',
                            status: '',
                            addedBy: '',
                            codeNumber: '',
                          ),
                        );
                        return (b.customerNumber ?? '').toLowerCase().contains(
                          q,
                        );
                      }).toList();
                      currentPage = 0;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: PaginationWidget(
                    currentPage: currentPage,
                    totalItems: displayedEstimation.length,
                    itemsPerPage: itemsPerPage,
                    onPageChanged: (newPage) =>
                        setState(() => currentPage = newPage),
                    onItemsPerPageChanged: (newLimit) =>
                        setState(() => itemsPerPage = newLimit),
                  ),
                ),
              ],
            ),
          )
        : MakeEstimation(
            estimationModel: estimateBeingEdited,
            selectedInventory: selectedInventories,
            products: selectedProducts,
            onBack: () async {
              await _loadBookings();
              if (!mounted) return;
              setState(() {
                showEstimationList = true;
                estimateBeingEdited = null;
              });
            },
          );
  }
}
