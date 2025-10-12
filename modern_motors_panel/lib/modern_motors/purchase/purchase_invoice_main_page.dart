import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/purchase/purchase_invoice.dart';
import 'package:modern_motors_panel/modern_motors/sales/sales_screen.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';

class PurchaseInvoiceMainPage extends StatefulWidget {
  const PurchaseInvoiceMainPage({super.key});

  @override
  State<PurchaseInvoiceMainPage> createState() =>
      _PurchaseInvoiceMainPageState();
}

class _PurchaseInvoiceMainPageState extends State<PurchaseInvoiceMainPage> {
  Set<String> selectedSalesIds = {};
  final Set<String> selectedBookingIds = {};
  SaleModel? bookingBeingEdited;
  bool showMaintenanceList = true;
  List<CustomerModel> customers = [];
  List<MmtrucksModel> trucks = [];
  int currentPage = 0;
  int itemsPerPage = 10;

  // @override
  // initState() {
  //   super.initState();
  //   getList();
  // }

  // Future<void> getList() async {
  //   salesList = await DataFetchService.fetchSales();
  //   setState(() {});
  // }

  void changeData() {}

  List<List<dynamic>> _rowsForExport(List<SaleModel> bookings) {
    return bookings.map((b) {
      final tr = trucks.firstWhere(
        (t) => t.id == b.truckId,
        orElse: () => MmtrucksModel(
          plateNumber: 0,
          vehicleType: '',
          modelYear: 0,
          ownBy: '',
          ownById: '',
          chassisNumber: '',
          emptyWeight: 0,
          engineCapacity: 0,
          manufactureYear: 0,
          maxLoad: 0,
          passengerCount: 0,
        ),
      );
      final owner = customers.firstWhere(
        (c) => c.id == tr.ownById,
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
        // b.bookingNumber ?? '',
        // tr.plateNumber ?? '',
        // tr.vehicleType,
        // (tr.modelYear).toString(),
        // tr.ownBy,
        // owner.customerName,
        // b.bookingDate?.toDate().formattedWithDayMonthYear ?? '',
        // (b.itemsTotal ?? 0).toStringAsFixed(2),
        // (b.servicesTotal ?? 0).toStringAsFixed(2),
        // (b.discountedAmount ?? 0).toStringAsFixed(2),
        // (b.taxAmount ?? 0).toStringAsFixed(2),
        // (b.total ?? 0).toStringAsFixed(2),
      ];
    }).toList();
  }

  final headers = <String>[
    'Booking #'.tr(),
    'Truck #'.tr(),
    'Type'.tr(),
    'Model'.tr(),
    'Owned By'.tr(),
    'Owner Name'.tr(),
    'Booked On'.tr(),
    'Items Total'.tr(),
    'Services Total'.tr(),
    'Discount'.tr(),
    'Tax'.tr(),
    'Total'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    // final paged =
    //     salesList.skip(currentPage * itemsPerPage).take(itemsPerPage).toList();
    return Scaffold(
      body: showMaintenanceList
          ? Column(
              children: [
                PageHeaderWidget(
                  title: 'Invoice'.tr(),
                  buttonText: 'Create Invoice'.tr(),
                  subTitle: 'Manage Invoice'.tr(),
                  selectedItems: selectedBookingIds.toList(),
                  requiredPermission: 'Create Invoices',
                  buttonWidth: 0.25,
                  onCreate: () {
                    // navOrderPage();
                    setState(() {
                      bookingBeingEdited = null;
                      showMaintenanceList = false;
                    });
                  },
                  onPdfImport: () async {
                    // final rows = _rowsForExport(paged);
                    // await PdfExporter.exportToPdf(
                    //   headers: headers,
                    //   rows: rows,
                    //   fileNamePrefix: 'Maintenance_Bookings',
                    // );
                  },
                  onExelImport: () async {
                    // final rows = _rowsForExport(paged);
                    // await ExcelExporter.exportToExcel(
                    //   headers: headers,
                    //   rows: rows,
                    //   fileNamePrefix: 'Maintenance_Bookings',
                    // );
                  },
                ),
                Expanded(
                  child: SalesListView(
                    //sales: salesList,
                    selectedIds: selectedSalesIds,
                    onSelectChanged: (isSelected, sale) {
                      setState(() {
                        bookingBeingEdited = sale;
                        showMaintenanceList = false;
                      });
                    },
                    enableSearch: true,
                  ),
                ),
              ],
            )
          : PurchaseInvoice(
              key: UniqueKey(),
              onBack: () async {
                // await getList();
                if (!mounted) return;
                setState(() {
                  showMaintenanceList = true;
                  bookingBeingEdited = null;
                });
              },
            ),
    );
  }
}
