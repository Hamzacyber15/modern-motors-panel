import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/maintenance_booking_models/maintenance_booking_model.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/template_model/template1_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/create_maintenance_booking.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/qr_code_generator.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

class ServiceBooking extends StatefulWidget {
  const ServiceBooking({super.key});

  @override
  State<ServiceBooking> createState() => _ServiceBookingState();
}

class _ServiceBookingState extends State<ServiceBooking> {
  bool showMaintenanceList = true;
  bool isLoading = true;
  bool isPDfView = false;
  List<MaintenanceBookingModel> allBookings = [];
  List<MaintenanceBookingModel> displayedBookings = [];
  List<MmtrucksModel> trucks = [];
  List<CustomerModel> customers = [];
  List<InventoryModel> allInventories = [];
  List<InventoryModel> selectedInventories = [];
  SaleModel? bookingBeingEdited;
  Template1Model template1Model = Template1Model();
  final Set<String> selectedBookingIds = {};
  int currentPage = 0;
  int itemsPerPage = 10;
  int selectedTemplateIndex = 0;
  String selectedColumn = 'All';
  final List<String> searchableColumns = ['All', 'ISH', 'Others'];

  // Headers
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
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        DataFetchService.fetchMaintenanceBooking(),
        DataFetchService.fetchTrucks(),
        DataFetchService.fetchCustomers(),
        DataFetchService.fetchInventory(),
      ]);
      allBookings = (results[0] as List<MaintenanceBookingModel>);
      displayedBookings = List.of(allBookings);
      trucks = (results[1] as List<MmtrucksModel>);
      customers = (results[2] as List<CustomerModel>);
      allInventories = results[3] as List<InventoryModel>;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deleteSelected() async {
    final count = selectedBookingIds.length;
    if (count == 0) return;

    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      count,
    );
    if (confirm != true) return;

    for (final id in selectedBookingIds) {
      await FirebaseFirestore.instance
          .collection('maintenanceBookings')
          .doc(id)
          .delete();
    }
    selectedBookingIds.clear();
    await _loadBookings();
  }

  List<List<dynamic>> _rowsForExport(List<MaintenanceBookingModel> bookings) {
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
        b.bookingNumber ?? '',
        tr.plateNumber ?? '',
        tr.vehicleType,
        (tr.modelYear).toString(),
        tr.ownBy,
        owner.customerName,
        b.bookingDate?.toDate().formattedWithDayMonthYear ?? '',
        (b.itemsTotal ?? 0).toStringAsFixed(2),
        (b.servicesTotal ?? 0).toStringAsFixed(2),
        (b.discountedAmount ?? 0).toStringAsFixed(2),
        (b.taxAmount ?? 0).toStringAsFixed(2),
        (b.total ?? 0).toStringAsFixed(2),
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final paged = displayedBookings
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();
    if (isPDfView && bookingBeingEdited != null) {
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
                  await _loadBookings();
                  setState(() {
                    showMaintenanceList = true;
                    bookingBeingEdited = null;
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
              DropdownMenuItem(value: 0, child: Text("Template 1".tr())),
              DropdownMenuItem(value: 1, child: Text("Template 2".tr())),
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
          //if (selectedTemplateIndex == 0)
          //Template1(template1Model: template1Model)
          //else if (selectedTemplateIndex == 1)
          //Template2(template1Model: template1Model),
        ],
      );
    }
    return showMaintenanceList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: 'Maintenance Bookings'.tr(),
                  buttonText: 'Add Booking'.tr(),
                  subTitle: 'Manage Maintenance Bookings'.tr(),
                  selectedItems: selectedBookingIds.toList(),
                  buttonWidth: 0.34,
                  onCreate: () {
                    setState(() {
                      bookingBeingEdited = null;
                      showMaintenanceList = false;
                    });
                  },
                  onDelete: _deleteSelected,
                  onPdfImport: () async {
                    final rows = _rowsForExport(paged);
                    await PdfExporter.exportToPdf(
                      headers: headers,
                      rows: rows,
                      fileNamePrefix: 'Maintenance_Bookings',
                    );
                  },
                  onExelImport: () async {
                    final rows = _rowsForExport(paged);
                    await ExcelExporter.exportToExcel(
                      headers: headers,
                      rows: rows,
                      fileNamePrefix: 'Maintenance_Bookings',
                    );
                  },
                ),
                //
                // displayedBookings.isEmpty
                //     ? EmptyListWidget(msg: "No Maintenance Bookings yet.".tr())
                //     :
                DynamicDataTable<MaintenanceBookingModel>(
                  data: paged,
                  columns: headers,
                  valueGetters: [
                    (v) => v.bookingNumber ?? '',
                    (v) {
                      final t = trucks.firstWhere(
                        (x) => x.id == v.truckId,
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
                      return t.plateNumber.toString();
                    },
                    (v) {
                      final t = trucks.firstWhere(
                        (x) => x.id == v.truckId,
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
                      return t.vehicleType;
                    },
                    (v) {
                      final t = trucks.firstWhere(
                        (x) => x.id == v.truckId,
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
                      return (t.modelYear).toString();
                    },
                    (v) {
                      final t = trucks.firstWhere(
                        (x) => x.id == v.truckId,
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
                      return t.ownBy!;
                    },
                    (v) {
                      final t = trucks.firstWhere(
                        (x) => x.id == v.truckId,
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
                      final c = customers.firstWhere(
                        (cust) => cust.id == t.ownById,
                        orElse: () => CustomerModel(
                          customerName: 'ISH',
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
                      return c.customerName;
                    },
                    (v) =>
                        v.bookingDate?.toDate().formattedWithDayMonthYear ?? '',
                    (v) => v.customerId == "ISH"
                        ? '-'
                        : (v.itemsTotal ?? 0).toStringAsFixed(2),
                    (v) => v.customerId == "ISH"
                        ? '-'
                        : (v.servicesTotal ?? 0).toStringAsFixed(2),
                    (v) => v.customerId == "ISH"
                        ? '-'
                        : (v.discountedAmount ?? 0).toStringAsFixed(2),
                    (v) => v.customerId == "ISH"
                        ? '-'
                        : (v.taxAmount ?? 0).toStringAsFixed(2),
                    (v) => v.customerId == "ISH"
                        ? '-'
                        : (v.total ?? 0).toStringAsFixed(2),
                  ],
                  getId: (v) => v.id,
                  selectedIds: selectedBookingIds,
                  onSelectChanged: (selected, row) {
                    setState(() {
                      if (selected == true && row.id != null) {
                        selectedBookingIds.add(row.id!);
                      } else {
                        selectedBookingIds.remove(row.id);
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
                        selectedBookingIds.addAll(ids);
                      } else {
                        selectedBookingIds.removeAll(ids);
                      }
                    });
                  },
                  onEdit: (booking) {
                    selectedInventories = allInventories
                        .where(
                          (inventory) => booking.items!.any(
                            (item) => item.productId == inventory.id,
                          ),
                        )
                        .toList();

                    setState(() {
                      //  bookingBeingEdited = booking;
                      showMaintenanceList = false;
                    });
                  },
                  onView: (booking) async {
                    //bookingBeingEdited = booking;
                    selectedInventories = allInventories
                        .where(
                          (inventory) => booking.items!.any(
                            (item) => item.productId == inventory.id,
                          ),
                        )
                        .toList();
                    final customerModel = customers.firstWhere(
                      (customer) => customer.id == booking.customerId,
                    );
                    debugPrint(
                      'customerModel: ${customerModel.toIndividualMap()}',
                    );
                    Uint8List qrBytes = await generateQrCodeBytes(
                      booking.bookingNumber.toString(),
                    );

                    template1Model = Template1Model(
                      // bookingModel: booking,
                      // inventoryModelList: selectedInventories,
                      // customerModel: customerModel,
                      qrBytes: qrBytes,
                    );
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
                          displayedBookings = List.of(allBookings);
                        } else if (q == 'ish') {
                          displayedBookings = allBookings
                              .where((booking) => booking.customerId == 'ISH')
                              .toList();
                        } else {
                          displayedBookings = allBookings
                              .where((booking) => booking.customerId != 'ISH')
                              .toList();
                        }
                      });
                    },
                  ),
                  statusTextGetter: (row) => (row.status ?? '').capitalizeFirst,
                  onSearch: (query) {
                    setState(() {
                      final q = query.toLowerCase();
                      displayedBookings = allBookings.where((b) {
                        final t = trucks.firstWhere(
                          (x) => x.id == b.truckId,
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
                          (c) => c.id == t.ownById,
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
                        return (b.bookingNumber ?? '').toLowerCase().contains(
                              q,
                            ) ||
                            (t.plateNumber ?? '')
                                .toString()
                                .toLowerCase()
                                .contains(q) ||
                            (t.vehicleType).toLowerCase().contains(q) ||
                            (owner.customerName).toLowerCase().contains(q);
                      }).toList();
                      currentPage = 0;
                    });
                  },
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: PaginationWidget(
                    currentPage: currentPage,
                    totalItems: displayedBookings.length,
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
        : CreateMaintenanceBooking(
            sale: bookingBeingEdited,
            onBack: () async {
              await _loadBookings();
              if (!mounted) return;
              setState(() {
                showMaintenanceList = true;
                bookingBeingEdited = null;
              });
            },
          );
  }
}
