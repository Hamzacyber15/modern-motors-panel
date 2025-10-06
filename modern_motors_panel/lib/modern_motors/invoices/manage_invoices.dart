import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/invoices/create_invoice_mm.dart';
import 'package:modern_motors_panel/modern_motors/invoices/template_1.dart';
import 'package:modern_motors_panel/modern_motors/invoices/template_5.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/app_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/qr_code_generator.dart';
import 'package:modern_motors_panel/modern_motors/widgets/retail_layout.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ManageInvoicesPage extends StatefulWidget {
  const ManageInvoicesPage({super.key});

  @override
  State<ManageInvoicesPage> createState() => _SellOrderPageState();
}

class _SellOrderPageState extends State<ManageInvoicesPage> {
  String? brand;
  final brands = ['Lenovo', 'Beats', 'Nike', 'Apple'];
  bool showInvoicesList = true;
  bool isLoading = true;
  bool isPDfView = false;
  DateTimeRange? selectedDateRange;
  int selectedTemplateIndex = 0; // 0 = Retail, 1 = Template1, 2 = Template5
  List<InvoiceMmModel> allInvoices = [];
  List<CustomerModel> allCustomers = [];
  List<InventoryModel> allInventories = [];
  List<ProductModel> products = [];
  List<ProductModel> selectedProducts = [];
  List<InvoiceMmModel> displayedInvoices = [];
  InvoiceMmModel? invoiceBeingEdited;
  List<InventoryModel> selectedInventories = [];
  CustomerModel? customerModel;
  Template1Model template1Model = Template1Model();
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedInvooicesIds = {};
  String selectedStatus = 'All';
  String selectedFilterDate = 'Last 7 days';
  final List<String> statusList = ['All', 'Active', 'Inactive'];
  final List<String> selectedFilterDatesList = [
    'Last 7 days',
    '1 month',
    '3 months ',
    'Custom date',
  ];

  Future<void> _deleteSelectedInvoices() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedInvooicesIds.length,
    );

    if (confirm != true) return;

    for (String productId in selectedInvooicesIds) {
      await FirebaseFirestore.instance
          .collection('mmInvoices')
          .doc(productId)
          .delete();
    }

    setState(() {
      selectedInvooicesIds.clear();
    });

    await _loadInvoices();
  }

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    setState(() {
      isLoading = true;
    });
    Future.wait([
      DataFetchService.fetchInvoices(),
      DataFetchService.fetchInventory(),
      DataFetchService.fetchCustomers(),
      DataFetchService.fetchProducts(),
    ]).then((results) {
      setState(() {
        allInvoices = results[0] as List<InvoiceMmModel>;
        displayedInvoices = results[0] as List<InvoiceMmModel>;
        allInventories = results[1] as List<InventoryModel>;
        allCustomers = results[2] as List<CustomerModel>;
        products = results[3] as List<ProductModel>;
        isLoading = false;
      });
    });
  }

  // Filter bookings based on the selected range or custom date
  void filterBookings() {
    setState(() {
      // Filter based on selectedFilterDate
      if (selectedFilterDate == 'Last 7 days') {
        displayedInvoices = allInvoices
            .where(
              (invoice) =>
                  invoice.createdAt != null &&
                  (invoice.createdAt!.toDate()).isAfter(
                    DateTime.now().subtract(Duration(days: 7)),
                  ),
            )
            .toList();
      } else if (selectedFilterDate == '1 month') {
        displayedInvoices = allInvoices
            .where(
              (invoice) =>
                  invoice.createdAt != null &&
                  (invoice.createdAt!.toDate()).isAfter(
                    DateTime.now().subtract(Duration(days: 30)),
                  ),
            )
            .toList();
      } else if (selectedFilterDate == '3 months') {
        displayedInvoices = allInvoices
            .where(
              (invoice) =>
                  invoice.createdAt != null &&
                  (invoice.createdAt!.toDate()).isAfter(
                    DateTime.now().subtract(Duration(days: 90)),
                  ),
            )
            .toList();
      } else if (selectedFilterDate == 'Custom date' &&
          selectedDateRange != null) {
        displayedInvoices = allInvoices
            .where(
              (invoice) =>
                  invoice.createdAt != null &&
                  (invoice.createdAt!.toDate()).isAfter(
                    selectedDateRange!.start,
                  ) &&
                  (invoice.createdAt!.toDate()).isBefore(
                    selectedDateRange!.end,
                  ),
            )
            .toList();
      } else {
        // Show all invoices if no filter is selected
        displayedInvoices = List.of(allInvoices);
      }
    });
  }

  Future<void> _pickDateRange() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange:
          selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(Duration(days: 30)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedRange != null) {
      setState(() {
        selectedDateRange = pickedRange;
      });
      filterBookings(); // Apply the filter after selecting the date range
    }
  }

  List<String> headers = [
    'Invoice Number'.tr(),
    'Customer\\\nContact'.tr(),
    'Invoice\\\nIssue Date'.tr(),
    'Due Date'.tr(),
    'Due Days'.tr(),
    'Items Sub Total'.tr(),
    'Discounted Amount'.tr(),
    'Sub Total'.tr(),
    'Tax Amount'.tr(),
    'Total'.tr(),
  ];

  List<List<dynamic>> getRowsForExcel(List<InvoiceMmModel> invoices) {
    return invoices.map((v) {
      final customer = allCustomers.firstWhere(
        (c) => c.id == v.customerId,
        orElse: () => CustomerModel(
          customerName: '',
          contactNumber: '',
          customerType: '',
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
        v.invoiceNumber.toString(), // Invoice Number
        customer.customerName, // Customer Name
        customer.contactNumber, // Contact Number
        v.invoiceDate?.toDate().formattedWithDayMonthYear ?? '', // Invoice Date
        v.issueDate?.toDate().formattedWithDayMonthYear ?? '', // Issue Date
        v.paymentDate?.toDate().formattedWithDayMonthYear ?? '', // Due Date
        v.paymentTermsInDays?.toString() ?? '', // Due Days
        v.itemsTotal?.toStringAsFixed(2) ?? '', // Items Sub Total
        v.discountedAmount?.toStringAsFixed(2) ?? '', // Discounted Amount
        v.subtotal?.toStringAsFixed(2) ?? '', // Sub Total
        v.taxAmount?.toStringAsFixed(2) ?? '', // Tax Amount
        v.total?.toStringAsFixed(2) ?? '', // Total
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pagedInvoices = displayedInvoices
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    if (isPDfView && invoiceBeingEdited != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          16.w,
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              height: context.height * 0.062,
              width: context.height * 0.065,
              child: CustomButton(
                onPressed: () async {
                  await _loadInvoices();
                  setState(() {
                    showInvoicesList = true;
                    invoiceBeingEdited = null;
                    template1Model = Template1Model();
                    isPDfView = false;
                  });
                },
                iconAsset: 'assets/images/back.png',
                buttonType: ButtonType.IconOnly,
                borderColor: AppTheme.borderColor,
                backgroundColor: AppTheme.whiteColor,
                iconSize: 20,
              ),
            ),
          ),
          20.w,
          DropdownButton<int>(
            value: selectedTemplateIndex,
            items: [
              DropdownMenuItem(value: 0, child: Text("Retail Layout".tr())),
              DropdownMenuItem(value: 1, child: Text("Template 1".tr())),
              DropdownMenuItem(value: 2, child: Text("Template 5".tr())),
            ],
            onChanged: (int? value) {
              if (value != null) {
                setState(() {
                  selectedTemplateIndex = value;
                });
              }
            },
          ),
          16.h,
          // Layout view
          if (selectedTemplateIndex == 0)
            RetailLayout(template1Model: template1Model)
          else if (selectedTemplateIndex == 1)
            Template1(template1Model: template1Model)
          else
            Template5(template1Model: template1Model),
          // RetailLayout(template1Model: template1Model),
          // Template5(template1Model: template1Model),
          // Template1(template1Model: template1Model),
        ],
      );
    } else {
      return showInvoicesList
          ? SingleChildScrollView(
              child: Column(
                children: [
                  PageHeaderWidget(
                    title: 'Manage Invoices'.tr(),
                    buttonText: "Create Invoice".tr(),
                    subTitle: "Manage your Invoices".tr(),
                    importButtonText: 'Import Invoices'.tr(),
                    selectedItems: selectedInvooicesIds.toList(),
                    onCreate: () async {
                      setState(() {
                        showInvoicesList = false;
                      });
                    },
                    buttonWidth: 0.28,
                    onDelete: _deleteSelectedInvoices,
                    onExelImport: () async {
                      final rowsToExport = getRowsForExcel(pagedInvoices);
                      await ExcelExporter.exportToExcel(
                        headers: headers,
                        rows: rowsToExport,
                        fileNamePrefix: 'Invoices_Report',
                      );
                    },
                    onImport: () {},
                    onPdfImport: () async {
                      final rowsToExport = getRowsForExcel(pagedInvoices);
                      await PdfExporter.exportToPdf(
                        headers: headers,
                        rows: rowsToExport,
                        fileNamePrefix: "Invoices_Report",
                      );
                    },
                  ),
                  allInvoices.isEmpty
                      ? EmptyWidget(text: "There's no invoices available".tr())
                      : DynamicDataTable<InvoiceMmModel>(
                          data: pagedInvoices,

                          // isWithImage: true,
                          // combineImageWithTextIndex: 0,
                          columns: headers,
                          valueGetters: [
                            (v) => v.invoiceNumber.toString(),
                            (v) =>
                                '${allCustomers.firstWhere((customer) => customer.id == v.customerId).customerName}\\\n${allCustomers.firstWhere((customer) => customer.id == v.customerId).contactNumber}',
                            (v) =>
                                '${v.invoiceDate!.toDate().formattedWithDayMonthYear}\\\n${v.issueDate!.toDate().formattedWithDayMonthYear}',
                            (v) => v.paymentDate!
                                .toDate()
                                .formattedWithDayMonthYear,
                            (v) => v.paymentTermsInDays.toString(),
                            (v) => v.itemsTotal!.toStringAsFixed(2),
                            (v) => v.discountedAmount!.toStringAsFixed(2),
                            (v) => v.subtotal!.toStringAsFixed(2),
                            (v) => v.taxAmount!.toStringAsFixed(2),
                            (v) => v.total!.toStringAsFixed(2),
                          ],
                          getId: (v) => v.id,
                          selectedIds: selectedInvooicesIds,
                          onSelectChanged: (value, invoices) {
                            setState(() {
                              if (value == true) {
                                selectedInvooicesIds.add(invoices.id!);
                              } else {
                                selectedInvooicesIds.remove(invoices.id);
                              }
                            });
                          },
                          onEdit: (invoices) {
                            setState(() {
                              selectedInventories = allInventories
                                  .where(
                                    (inventory) => invoices.items!.any(
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
                              invoiceBeingEdited = invoices;
                              showInvoicesList = false;
                            });
                          },
                          onStatus: (invoices) {},
                          statusTextGetter: (item) =>
                              item.status!.capitalizeFirst,
                          onView: (invoices) async {
                            invoiceBeingEdited = invoices;
                            selectedInventories = allInventories
                                .where(
                                  (inventory) => invoices.items!.any(
                                    (item) => item.productId == inventory.id,
                                  ),
                                )
                                .toList();
                            customerModel = allCustomers.firstWhere(
                              (customer) => customer.id == invoices.customerId,
                            );
                            Uint8List qrBytes = await generateQrCodeBytes(
                              invoices.invoiceNumber.toString(),
                            );

                            template1Model = Template1Model(
                              // invoiceModel: invoices,
                              // inventoryModelList: selectedInventories,
                              // customerModel: customerModel,
                              qrBytes: qrBytes,
                            );
                            isPDfView = true;
                            setState(() {});
                            // _showProductDialog(
                            //   context,
                            //   allInventories
                            //       .where(
                            //         (inventory) => invoices.items!.any(
                            //           (item) => item.productId == inventory.id,
                            //         ),
                            //       )
                            //       .toList(),
                            //   invoices.items ?? [],
                            // );
                          },
                          dropDownWidget: Row(
                            children: [
                              AppDropdown<String>(
                                width: 92,
                                hint: selectedStatus,
                                value: selectedStatus,
                                items: statusList,
                                labelBuilder: (s) => s,
                                onChanged: (val) {
                                  setState(() {
                                    selectedStatus = val;
                                    final q = val.toLowerCase();
                                    if (q == 'all') {
                                      displayedInvoices = List.of(allInvoices);
                                    } else if (q == 'active') {
                                      displayedInvoices = allInvoices
                                          .where(
                                            (booking) =>
                                                booking.status == 'active',
                                          )
                                          .toList();
                                    } else {
                                      displayedInvoices = allInvoices
                                          .where(
                                            (booking) =>
                                                booking.status == 'inactive',
                                          )
                                          .toList();
                                    }
                                  });
                                },
                              ),
                              10.w,
                              AppDropdown<String>(
                                width: 130,
                                hint: selectedFilterDate,
                                value: selectedFilterDate,
                                items: selectedFilterDatesList,
                                labelBuilder: (s) => s,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFilterDate = newValue!;

                                    // Check if "Custom date" is selected
                                    if (selectedFilterDate == 'Custom date') {
                                      _pickDateRange();
                                    } else {
                                      // Apply the filter immediately for other date options
                                      filterBookings();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          onSelectAll: (value) {
                            setState(() {
                              selectedInvooicesIds.clear();
                              final currentPageIds = pagedInvoices
                                  .map((e) => e.id!)
                                  .toList();
                              if (value == true) {
                                selectedInvooicesIds.addAll(currentPageIds);
                              } else {
                                selectedInvooicesIds.removeAll(currentPageIds);
                              }
                            });
                          },
                          hintText: 'Search By Invoice Number',
                          onSearch: (query) {
                            setState(() {
                              displayedInvoices = allInvoices
                                  .where(
                                    (item) => item.invoiceNumber
                                        .toString()
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
                      totalItems: allInvoices.length,
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
          // : Template1();
          : CreateInvoiceMm(
              invoiceModel: invoiceBeingEdited,
              selectedInventory: selectedInventories,
              products: selectedProducts,
              onBack: () async {
                await _loadInvoices();
                setState(() {
                  showInvoicesList = true;
                  invoiceBeingEdited = null;
                  isPDfView = false;
                });
              },
            );
    }
  }
}
