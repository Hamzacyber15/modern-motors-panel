import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// class EmployeePage extends StatefulWidget {
//   const EmployeePage({super.key});

//   @override
//   State<EmployeePage> createState() => _EmployeePageState();
// }

// class _EmployeePageState extends State<EmployeePage> {
//   List<EmployeeModel> allEmployees = [];
//   List<BranchModel> allBranches = [];
//   List<RoleModel> allRoles = [];
//   List<NationalityModel> allNationalities = [];
//   List<CountryModel> allCountries = [];
//   List<EmployeeModel> displayedEmployees = [];
//   EmployeeModel? employeeBeingEdited;
//   int currentPage = 0;
//   int itemsPerPage = 10;
//   Set<String> selectedCustomerIds = {};
//   bool showCustomersList = true;
//   bool isLoading = true;
//   final headerColumns = [
//     "Employee Name".tr(),
//     "Role".tr(),
//     "Mobile Number".tr(),
//     "Nationality".tr(),
//     'ID Card Number'.tr(),
//     "Date of Birth".tr(),
//     "Gender".tr(),
//     "Emergency Contact Name".tr(),
//     "Emergency Contact No".tr(),
//     "Branch".tr(),
//     "Designation",
//     "Address".tr(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadEmployees();
//   }

//   List<List<dynamic>> getCustomerRowsForExcel(List<EmployeeModel> employees) {
//     return employees.map((c) {
//       final country = allCountries
//           .firstWhere(
//             (cat) => cat.id == c.countryId,
//             orElse: () => CountryModel(country: 'Unknown'),
//           )
//           .country;

//       final fullAddress =
//           '${c.streetAddress1}, ${c.streetAddress2},${c.state}, ${c.city}';

//       return [
//         c.name,
//         //c.gender,
//         c.contactNumber,
//         c.nationalityId,
//         fullAddress,
//         country,
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
//           .collection('mmEmployees')
//           .doc(productId)
//           .delete();
//     }
//     setState(() {
//       selectedCustomerIds.clear();
//     });
//     SnackbarUtils.showSnackbar(context, "Employee Deleted successfully");

//     await _loadEmployees();
//   }

//   Future<void> _loadEmployees() async {
//     setState(() {
//       isLoading = true;
//     });
//     final country = await DataFetchService.fetchCountries();
//     final branch = await DataFetchService.fetchBranches();
//     final role = await DataFetchService.fetchRoles();
//     final employees = await DataFetchService.fetchEmployees();
//     final nationalities = await DataFetchService.fetchNationalities();

//     setState(() {
//       allEmployees = employees;
//       displayedEmployees = employees;
//       allBranches = branch;
//       allRoles = role;
//       allCountries = country;
//       allNationalities = nationalities;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final pagedProducts = displayedEmployees
//         .skip(currentPage * itemsPerPage)
//         .take(itemsPerPage)
//         .toList();

//     return showCustomersList
//         ? SingleChildScrollView(
//             child: Column(
//               children: [
//                 PageHeaderWidget(
//                   title: "Employees List".tr(),
//                   buttonText: "Add Employees".tr(),
//                   subTitle: "Manage your Employees".tr(),
//                   selectedItems: selectedCustomerIds.toList(),
//                   requiredPermission: 'Add Employees',
//                   buttonWidth: 0.26,
//                   onCreate: () {
//                     setState(() {
//                       showCustomersList = false;
//                     });
//                   },
//                   onDelete: _deleteSelectedVendor,
//                   onDesignation: () async {
//                     await DesignationHelper.assignDesignationToEmployees(
//                       context: context,
//                       selectedEmployeeIds: selectedCustomerIds,
//                       onSuccess: () async {
//                         setState(() {
//                           selectedCustomerIds.clear();
//                         });
//                         await _loadEmployees();
//                       },
//                     );
//                   },
//                   onPdfImport: () async {
//                     final rowsToExport = getCustomerRowsForExcel(pagedProducts);
//                     await PdfExporter.exportToPdf(
//                       headers: headerColumns,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Employees_Details_Report'.tr(),
//                     );
//                   },
//                   onExelImport: () async {
//                     final rowsToExport = getCustomerRowsForExcel(pagedProducts);
//                     await ExcelExporter.exportToExcel(
//                       headers: headerColumns,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Employees_Details_Report'.tr(),
//                     );
//                   },
//                 ),
//                 allEmployees.isEmpty
//                     ? EmptyWidget(text: "There's no Employees available".tr())
//                     : DynamicDataTable<EmployeeModel>(
//                         data: pagedProducts,
//                         isWithImage: true,
//                         editProfileAccessKey: 'Edit Employees',
//                         deleteProfileAccessKey: 'Delete Employees',
//                         combineImageWithTextIndex: 0,
//                         columns: headerColumns,
//                         valueGetters: [
//                           (v) => '${v.name} , ${v.imageUrl}',
//                           (v) {
//                             final roles = allRoles.firstWhere(
//                               (b) => b.id == v.roleId,
//                               orElse: () => RoleModel(name: "Unknown".tr()),
//                             );
//                             return roles.name;
//                           },
//                           (v) => v.contactNumber,
//                           (v) {
//                             final nationalities = allNationalities.firstWhere(
//                               (b) => b.id == v.nationalityId,
//                               orElse: () => NationalityModel(
//                                 nationality: 'unKnown',
//                                 nationalityArabic: '',
//                                 id: '',
//                                 status: '',
//                                 timestamp: Timestamp.now(),
//                               ),
//                             );
//                             return nationalities.nationality;
//                           },
//                           (v) => v.idCardNumber,
//                           (v) => DateFormat('yyyy-MM-dd')
//                               .format(v.dob ?? DateTime.now()),
//                           (v) => "", //v.gender ?? "",
//                           (v) => v.emergencyName ?? "",
//                           (v) => v.emergencyContact ?? "",
//                           (v) {
//                             final branch = allBranches.firstWhere(
//                               (b) => b.id == v.emergencyName, //v.branchId,
//                               orElse: () =>
//                                   BranchModel(branchName: "Unknown".tr()),
//                             );
//                             return branch.branchName;
//                           },
//                           (v) => v.hrInfo != null &&
//                                   v.hrInfo!.hrDesignationEnglish.isNotEmpty
//                               ? v.hrInfo!.hrDesignationEnglish
//                               : "Not Assigned".tr(),
//                           (v) => '${v.streetAddress1},${v.state},${v.city}',
//                         ],
//                         getId: (v) => v.id,
//                         selectedIds: selectedCustomerIds,
//                         onSelectChanged: (val, vendor) {
//                           setState(() {
//                             if (val == true) {
//                               selectedCustomerIds.add(vendor.id);
//                             } else {
//                               selectedCustomerIds.remove(vendor.id);
//                             }
//                           });
//                         },
//                         onView: (employees) async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => MmEmployeeScreen(
//                                 employee: employees,
//                                 roleName: "", //roleName ?? "N/A",
//                                 branchName: "", //branchName ?? "N/A",
//                                 nationalityName:
//                                     "", // nationalityName ?? "N/A",
//                               ),
//                             ),
//                           );
//                         },
//                         onDelete: (p0) {},
//                         onEdit: (employees) {
//                           employeeBeingEdited = employees;

//                           setState(() {
//                             showCustomersList = false;
//                             employeeBeingEdited = employees;
//                           });
//                         },
//                         onStatus: (employees) {},
//                         statusTextGetter: (item) => item.status.capitalizeFirst,
//                         onSelectAll: (val) {
//                           setState(() {
//                             final ids = pagedProducts.map((e) => e.id).toList();
//                             if (val == true) {
//                               selectedCustomerIds.addAll(ids);
//                             } else {
//                               selectedCustomerIds.removeAll(ids);
//                             }
//                           });
//                         },
//                         onSearch: (query) {
//                           setState(() {
//                             displayedEmployees = allEmployees
//                                 .where(
//                                   (v) => v.name.toLowerCase().contains(
//                                         query.toLowerCase(),
//                                       ),
//                                 )
//                                 .toList();
//                           });
//                         },
//                       ),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: PaginationWidget(
//                     currentPage: currentPage,
//                     totalItems: allEmployees.length,
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
//         : AddEditEmployee(
//             isEdit: employeeBeingEdited != null,
//             employeeModel: employeeBeingEdited,
//             onBack: () async {
//               await _loadEmployees();
//               setState(() {
//                 showCustomersList = true;
//                 employeeBeingEdited = null;
//               });
//             },
//           );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/nationality_model.dart';
import 'package:modern_motors_panel/model/hr_models/role_model.dart';
import 'package:modern_motors_panel/modern_motors/employees/add_edit_employee.dart';
import 'package:modern_motors_panel/modern_motors/employees/employee_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/designation_helper_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<EmployeeModel> allEmployees = [];
  List<BranchModel> allBranches = [];
  List<RoleModel> allRoles = [];
  List<NationalityModel> allNationalities = [];
  List<CountryModel> allCountries = [];
  List<EmployeeModel> displayedEmployees = [];
  EmployeeModel? employeeBeingEdited;
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCustomerIds = {};
  bool showCustomersList = true;
  bool isLoading = true;
  final headerColumns = [
    "Employee Name".tr(),
    "Role".tr(),
    "Mobile Number".tr(),
    "Nationality".tr(),
    'ID Card Number'.tr(),
    "Date of Birth".tr(),
    "Gender".tr(),
    "Emergency Contact Name".tr(),
    "Emergency Contact No".tr(),
    "Branch".tr(),
    "Designation",
    "Address".tr(),
  ];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  List<List<dynamic>> getCustomerRowsForExcel(List<EmployeeModel> employees) {
    return employees.map((c) {
      final country = allCountries
          .firstWhere(
            (cat) => cat.id == c.countryId,
            orElse: () => CountryModel(country: 'Unknown'),
          )
          .country;

      final fullAddress =
          '${c.streetAddress1}, ${c.streetAddress2},${c.state}, ${c.city}';

      return [
        c.name,
        c.gender,
        c.contactNumber,
        c.nationalityId,
        fullAddress,
        country,
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
          .collection('employees')
          .doc(productId)
          .delete();
    }
    setState(() {
      selectedCustomerIds.clear();
    });
    SnackbarUtils.showSnackbar(context, "Employee Deleted successfully");

    await _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      isLoading = true;
    });
    final country = await DataFetchService.fetchCountries();
    final branch = await DataFetchService.fetchBranches();
    final role = await DataFetchService.fetchRoles();
    final employees = await DataFetchService.fetchEmployees();
    final nationalities = await DataFetchService.fetchNationalities();

    setState(() {
      allEmployees = employees;
      displayedEmployees = employees;
      allBranches = branch;
      allRoles = role;
      allCountries = country;
      allNationalities = nationalities;
      isLoading = false;
    });
  }

  void getEmployee(EmployeeModel employee) {
    setState(() {
      showCustomersList = false;
      employeeBeingEdited = employee;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pagedProducts = displayedEmployees
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return showCustomersList
        ? Column(
            children: [
              PageHeaderWidget(
                title: "Employees List".tr(),
                buttonText: "Add Employees".tr(),
                subTitle: "Manage your Employees".tr(),
                requiredPermission: 'Add Employees',
                selectedItems: selectedCustomerIds.toList(),
                buttonWidth: 0.26,
                onCreate: () {
                  setState(() {
                    showCustomersList = false;
                  });
                },
                onDelete: _deleteSelectedVendor,
                onDesignation: () async {
                  await DesignationHelper.assignDesignationToEmployees(
                    context: context,
                    selectedEmployeeIds: selectedCustomerIds,
                    onSuccess: () async {
                      setState(() {
                        selectedCustomerIds.clear();
                      });
                      await _loadEmployees();
                    },
                  );
                },
                onPdfImport: () async {
                  final rowsToExport = getCustomerRowsForExcel(pagedProducts);
                  await PdfExporter.exportToPdf(
                    headers: headerColumns,
                    rows: rowsToExport,
                    fileNamePrefix: 'Employees_Details_Report'.tr(),
                  );
                },
                onExelImport: () async {
                  final rowsToExport = getCustomerRowsForExcel(pagedProducts);
                  await ExcelExporter.exportToExcel(
                    headers: headerColumns,
                    rows: rowsToExport,
                    fileNamePrefix: 'Employees_Details_Report'.tr(),
                  );
                },
              ),
              allEmployees.isEmpty
                  ? EmptyWidget(text: "There's no Employees available".tr())
                  : Expanded(
                      child: EmployeeCardListView(
                        employeeList: pagedProducts,
                        selectedIds: selectedCustomerIds,
                        onEdit: getEmployee,
                      ),
                    ),
              Align(
                alignment: Alignment.topRight,
                child: PaginationWidget(
                  currentPage: currentPage,
                  totalItems: allEmployees.length,
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
        : AddEditEmployee(
            isEdit: employeeBeingEdited != null,
            employeeModel: employeeBeingEdited,
            onBack: () async {
              await _loadEmployees();
              setState(() {
                showCustomersList = true;
                employeeBeingEdited = null;
              });
            },
          );
  }
}
