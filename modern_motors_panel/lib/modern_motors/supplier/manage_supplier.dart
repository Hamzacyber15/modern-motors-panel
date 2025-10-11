import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/supplier/supplier_card_list_view.dart';
import 'package:modern_motors_panel/model/supplier/supplier_model.dart';
import 'package:modern_motors_panel/modern_motors/customers/add_edit_customers.dart';
import 'package:modern_motors_panel/modern_motors/customers/client_page.dart';
import 'package:modern_motors_panel/modern_motors/customers/customer_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/supplier/add_edit_supplier.dart';
import 'package:modern_motors_panel/modern_motors/supplier/supplier_page.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ManageSupplier extends StatefulWidget {
  const ManageSupplier({super.key});

  @override
  State<ManageSupplier> createState() => _ManageSupplierState();
}

class _ManageSupplierState extends State<ManageSupplier> {
  bool showCustomersList = true;
  bool isLoading = true;

  List<SupplierModel> allSuppliers = [];
  List<CurrencyModel> allCurrencies = [];
  List<CountryModel> allCountries = [];
  List<SupplierModel> displayedSuppliers = [];

  SupplierModel? customerBeingEdited;
  bool isClone = false;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCustomerIds = {};

  final headerColumns = [
    "Supplier Name".tr(),
    "Supplier Type".tr(),
    "Telephone Number".tr(),
    "Contact Number".tr(),
    "Address".tr(),
    "Country".tr(),
    "Currency".tr(),
  ];

  List<List<dynamic>> getCustomerRowsForExcel(List<SupplierModel> customers) {
    return customers.map((c) {
      final country = allCountries
          .firstWhere(
            (cat) => cat.id == c.countryId,
            orElse: () => CountryModel(country: 'Unknown'),
          )
          .country;

      final currency = allCurrencies
          .firstWhere(
            (cat) => cat.id == c.currencyId,
            orElse: () => CurrencyModel(currency: 'Unknown'),
          )
          .currency;

      final fullAddress =
          '${c.streetAddress1}, ${c.streetAddress2},${c.state}, ${c.city}';

      return [
        c.supplierName,
        c.supplierType.capitalizeFirstOnly,
        c.telePhoneNumber,
        c.contactNumber,
        fullAddress,
        country,
        currency,
      ];
    }).toList();
  }

  Future<void> _deleteSelectedVendor() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedCustomerIds.length,
    );

    if (confirm != true) return;

    for (String productId in selectedCustomerIds) {
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(productId)
          .delete();
    }

    setState(() {
      selectedCustomerIds.clear();
    });

    await _loadSuppliers();
  }

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  void getCustomer(SupplierModel customer) {
    setState(() {
      showCustomersList = false;
      customerBeingEdited = customer;
    });
  }

  void onView(SupplierModel supplier) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierPage(supplierModel: supplier),
      ),
    );
    if (result == 'updated') {
      _loadSuppliers();
    }
  }

  void onClone(SupplierModel customer) {
    setState(() {
      showCustomersList = false;
      isClone = true;
      customerBeingEdited = customer;
    });
  }

  Future<void> _loadSuppliers() async {
    setState(() {
      isLoading = true;
    });
    final country = await DataFetchService.fetchCountries();
    final currency = await DataFetchService.fetchCurrencies();

    final suppliers = await DataFetchService.fetchSuppliers();
    setState(() {
      allSuppliers = suppliers;
      displayedSuppliers = suppliers;
      allCurrencies = currency;
      allCountries = country;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pagedCustomers = displayedSuppliers
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return showCustomersList
        ? Column(
            children: [
              PageHeaderWidget(
                title: "Supplier List".tr(),
                buttonText: "Add Supplier".tr(),
                subTitle: "Manage your Supplier".tr(),
                requiredPermission: 'Add Supplier',
                selectedItems: selectedCustomerIds.toList(),
                buttonWidth: 0.26,
                onCreate: () {
                  setState(() {
                    showCustomersList = false;
                  });
                },
                onDelete: _deleteSelectedVendor,
                onPdfImport: () async {
                  final rowsToExport = getCustomerRowsForExcel(pagedCustomers);
                  await PdfExporter.exportToPdf(
                    headers: headerColumns,
                    rows: rowsToExport,
                    fileNamePrefix: 'Supplier_Details_Report',
                  );
                },
                onExelImport: () async {
                  final rowsToExport = getCustomerRowsForExcel(pagedCustomers);
                  await ExcelExporter.exportToExcel(
                    headers: headerColumns,
                    rows: rowsToExport,
                    fileNamePrefix: 'Supplier_Details_Report',
                  );
                },
              ),

              allSuppliers.isEmpty
                  ? EmptyWidget(text: "There's no Supplier available".tr())
                  : Expanded(
                      child: SupplierCardListView(
                        suppliersList: pagedCustomers,
                        selectedIds: selectedCustomerIds,
                        onEdit: getCustomer,
                        onClone: onClone,
                        onView: onView,
                      ),
                    ),

              // : DynamicDataTable<SupplierModel>(
              //   data: pagedCustomers,
              //   editProfileAccessKey: 'Edit Customer',
              //   deleteProfileAccessKey: 'Delete Customer',
              //   isWithImage: true,
              //   combineImageWithTextIndex: 0,
              //   columns: headerColumns,
              //   valueGetters: [
              //     (v) => '${v.customerName} , ${v.imageUrl}',
              //     (v) => v.customerType.capitalizeFirstOnly,
              //     (v) =>
              //         v.telePhoneNumber.isNotEmpty
              //             ? v.telePhoneNumber
              //             : 'N/A',
              //     (v) =>
              //         v.contactNumber.isNotEmpty ? v.contactNumber : 'N/A',
              //     (v) => [
              //       v.streetAddress1,
              //       v.state,
              //       v.city,
              //     ].where((e) => e.isNotEmpty).join(', '),
              //     (v) =>
              //         allCountries
              //             .firstWhere(
              //               (cat) => cat.id == v.countryId,
              //               orElse:
              //                   () => CountryModel(id: '', country: 'N/A'),
              //             )
              //             .country,
              //     (v) =>
              //         allCurrencies
              //             .firstWhere(
              //               (cat) => cat.id == v.currencyId,
              //               orElse:
              //                   () =>
              //                       CurrencyModel(id: '', currency: 'N/A'),
              //             )
              //             .currency,
              //   ],
              //   getId: (v) => v.id,
              //   selectedIds: selectedCustomerIds,
              //   onSelectChanged: (val, vendor) {
              //     setState(() {
              //       if (val == true) {
              //         selectedCustomerIds.add(vendor.id!);
              //       } else {
              //         selectedCustomerIds.remove(vendor.id);
              //       }
              //     });
              //   },
              //   onView: (customer) {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder:
              //             (context) => ClientPage(SupplierModel: customer),
              //       ),
              //     );
              //   },
              //   onDelete: (p0) {},
              //   onClone: (customer) {
              //     setState(() {
              //       showCustomersList = false;
              //       isClone = true;
              //       customerBeingEdited = customer;
              //     });
              //   },
              //   onEdit: (customer) {
              //     customerBeingEdited = customer;
              //     // showAlert(
              //     //   isEdit: true,
              //     //   customer: customerBeingEdited,
              //     //   onBack: () async {
              //     //     await _loadCustomers();
              //     //   },
              //     // );
              //     setState(() {
              //       // customerBeingEdited = customer;
              //       showCustomersList = false;
              //       customerBeingEdited = customer;
              //     });
              //   },
              //   onStatus: (customer) {},
              //   statusTextGetter: (item) => item.status.capitalizeFirst,
              //   onSelectAll: (val) {
              //     setState(() {
              //       final ids = pagedCustomers.map((e) => e.id!).toList();
              //       if (val == true) {
              //         selectedCustomerIds.addAll(ids);
              //       } else {
              //         selectedCustomerIds.removeAll(ids);
              //       }
              //     });
              //   },
              //   onSearch: (query) {
              //     setState(() {
              //       displayedSuppliers =
              //           allCustomers
              //               .where(
              //                 (v) => v.customerName.toLowerCase().contains(
              //                   query.toLowerCase(),
              //                 ),
              //               )
              //               .toList();
              //     });
              //   },
              // ),
              Align(
                alignment: Alignment.topRight,
                child: PaginationWidget(
                  currentPage: currentPage,
                  totalItems: allSuppliers.length,
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
          )
        : AddEditSupplier(
            isEdit: customerBeingEdited != null,
            supplierModel: customerBeingEdited,
            isClone: isClone,
            onBack: () async {
              await _loadSuppliers();
              setState(() {
                showCustomersList = true;
                customerBeingEdited = null;
                isClone = false;
              });
            },
          );
  }
}

// class ManageSupplier extends StatefulWidget {
//   const ManageCustomerPage({super.key});

//   @override
//   State<ManageCustomerPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ManageCustomerPage> {
//   bool showCustomersList = true;
//   bool isLoading = true;
//   List<SupplierModel> allCustomers = [];
//   List<CurrencyModel> allCurrencies = [];
//   List<CountryModel> allCountries = [];
//   List<SupplierModel> displayedSuppliers = [];
//   SupplierModel? customerBeingEdited;
//   int currentPage = 0;
//   int itemsPerPage = 10;
//   Set<String> selectedCustomerIds = {};

//   final headerColumns = [
//     "Customer Name".tr(),
//     "Customer Type".tr(),
//     "Telephone Number".tr(),
//     "Contact Number".tr(),
//     "Address".tr(),
//     "Country".tr(),
//     "Currency".tr(),
//   ];

//   List<List<dynamic>> getCustomerRowsForExcel(List<SupplierModel> customers) {
//     return customers.map((c) {
//       final country = allCountries
//           .firstWhere(
//             (cat) => cat.id == c.countryId,
//             orElse: () => CountryModel(country: 'Unknown'),
//           )
//           .country;

//       final currency = allCurrencies
//           .firstWhere(
//             (cat) => cat.id == c.currencyId,
//             orElse: () => CurrencyModel(currency: 'Unknown'),
//           )
//           .currency;

//       final fullAddress =
//           '${c.streetAddress1}, ${c.streetAddress2},${c.state}, ${c.city}';

//       return [
//         c.customerName,
//         c.customerType.capitalizeFirstOnly,
//         c.telePhoneNumber,
//         c.contactNumber,
//         fullAddress,
//         country,
//         currency,
//       ];
//     }).toList();
//   }

//   Future<void> _deleteSelectedVendor() async {
//     final confirm = await DeleteDialogHelper.showDeleteConfirmation(
//       context,
//       selectedCustomerIds.length,
//     );

//     if (confirm != true) return;

//     for (String productId in selectedCustomerIds) {
//       await FirebaseFirestore.instance
//           .collection('vendors')
//           .doc(productId)
//           .delete();
//     }

//     setState(() {
//       selectedCustomerIds.clear();
//     });

//     await _loadProducts();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   Future<void> _loadProducts() async {
//     setState(() {
//       isLoading = true;
//     });
//     final country = await DataFetchService.fetchCountries();
//     final currency = await DataFetchService.fetchCurrencies();

//     final customers = await DataFetchService.fetchCustomers();
//     setState(() {
//       allCustomers = customers;
//       displayedSuppliers = customers;
//       allCurrencies = currency;
//       allCountries = country;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final pagedProducts = displayedSuppliers
//         .skip(currentPage * itemsPerPage)
//         .take(itemsPerPage)
//         .toList();

//     return showCustomersList
//         ? SingleChildScrollView(
//             child: Column(
//               children: [
//                 PageHeaderWidget(
//                   title: "Customers List".tr(),
//                   buttonText: "Add Customer".tr(),
//                   subTitle: "Manage your customers".tr(),
//                   selectedItems: selectedCustomerIds.toList(),
//                   buttonWidth: 0.26,
//                   onCreate: () {
//                     setState(() {
//                       showCustomersList = false;
//                     });
//                   },
//                   onDelete: _deleteSelectedVendor,
//                   onPdfImport: () async {
//                     final rowsToExport = getCustomerRowsForExcel(pagedProducts);
//                     await PdfExporter.exportToPdf(
//                       headers: headerColumns,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Customer_Details_Report',
//                     );
//                   },
//                   onExelImport: () async {
//                     final rowsToExport = getCustomerRowsForExcel(pagedProducts);
//                     await ExcelExporter.exportToExcel(
//                       headers: headerColumns,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Customer_Details_Report',
//                     );
//                   },
//                 ),
//                 allCustomers.isEmpty
//                     ? EmptyWidget(text: "There's no customers available".tr())
//                     : DynamicDataTable<SupplierModel>(
//                         data: pagedProducts,
//                         isWithImage: true,
//                         combineImageWithTextIndex: 0,
//                         columns: headerColumns,
//                         valueGetters: [
//                           (v) => '${v.customerName} , ${v.imageUrl}',
//                           (v) => v.customerType.capitalizeFirstOnly,
//                           (v) => v.telePhoneNumber,
//                           (v) => v.contactNumber,
//                           (v) => '${v.streetAddress1},${v.state},${v.city}',
//                           (v) => allCountries
//                               .firstWhere((cat) => cat.id == v.countryId)
//                               .country,
//                           (v) => allCurrencies
//                               .firstWhere((cat) => cat.id == v.currencyId)
//                               .currency,
//                         ],
//                         getId: (v) => v.id,
//                         selectedIds: selectedCustomerIds,
//                         onSelectChanged: (val, vendor) {
//                           setState(() {
//                             if (val == true) {
//                               selectedCustomerIds.add(vendor.id!);
//                             } else {
//                               selectedCustomerIds.remove(vendor.id);
//                             }
//                           });
//                         },
//                         onView: (customer) {},
//                         onEdit: (customer) {
//                           customerBeingEdited = customer;
//                           // showAlert(
//                           //   isEdit: true,
//                           //   customer: customerBeingEdited,
//                           //   onBack: () async {
//                           //     await _loadProducts();
//                           //   },
//                           // );
//                           setState(() {
//                             // customerBeingEdited = customer;
//                             showCustomersList = false;
//                             customerBeingEdited = customer;
//                           });
//                         },
//                         onStatus: (customer) {},
//                         statusTextGetter: (item) => item.status.capitalizeFirst,
//                         onSelectAll: (val) {
//                           setState(() {
//                             final ids = pagedProducts
//                                 .map((e) => e.id!)
//                                 .toList();
//                             if (val == true) {
//                               selectedCustomerIds.addAll(ids);
//                             } else {
//                               selectedCustomerIds.removeAll(ids);
//                             }
//                           });
//                         },
//                         onSearch: (query) {
//                           setState(() {
//                             displayedSuppliers = allCustomers
//                                 .where(
//                                   (v) => v.customerName.toLowerCase().contains(
//                                     query.toLowerCase(),
//                                   ),
//                                 )
//                                 .toList();
//                           });
//                         },
//                       ),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: PaginationWidget(
//                     currentPage: currentPage,
//                     totalItems: allCustomers.length,
//                     itemsPerPage: itemsPerPage,
//                     onPageChanged: (newPage) {
//                       setState(() {
//                         currentPage = newPage;
//                       });
//                     },
//                     onItemsPerPageChanged: (newLimit) {
//                       setState(() {
//                         itemsPerPage = newLimit;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : AddEditCustomer(
//             isEdit: customerBeingEdited != null,
//             SupplierModel: customerBeingEdited,
//             onBack: () async {
//               await _loadProducts();
//               setState(() {
//                 showCustomersList = true;
//                 customerBeingEdited = null;
//               });
//             },
//           );
//   }
// }
