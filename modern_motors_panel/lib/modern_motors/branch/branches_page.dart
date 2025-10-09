import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/modern_motors/branch/branches_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/branch/branches_form_widget.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';

// class BranchesPage extends StatefulWidget {
//   const BranchesPage({super.key});

//   @override
//   State<BranchesPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<BranchesPage> {
//   bool showProductList = true;
//   bool isLoading = true;
//   List<BranchModel> allBranches = [];
//   List<BranchModel> displayedBranches = [];
//   BranchModel? branchesBeingEdited;
//   int currentPage = 0;
//   int itemsPerPage = 10;
//   Set<String> selectedBranchIds = {};

//   final headerColumns = [
//     "Branch Name".tr(),
//     "Description".tr(),
//     "Address".tr(),
//     "Store Manager".tr(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadBranches();
//   }

//   Future<void> _deleteSelectedBranch() async {
//     final confirm = await DeleteDialogHelper.showDeleteConfirmation(
//       context,
//       selectedBranchIds.length,
//     );

//     if (confirm != true) return;

//     for (String branchId in selectedBranchIds) {
//       await FirebaseFirestore.instance
//           .collection('branches')
//           .doc(branchId)
//           .delete();
//     }

//     setState(() {
//       selectedBranchIds.clear();
//     });

//     await _loadBranches();
//   }

//   Future<void> _loadBranches() async {
//     setState(() {
//       isLoading = true;
//     });
//     final branches = await DataFetchService.fetchBranches();
//     setState(() {
//       allBranches = branches;
//       displayedBranches = branches;
//       isLoading = false;
//     });
//   }

//   List<List<dynamic>> getRow(List<BranchModel> branches) {
//     return branches.map((b) {
//       return [
//         b.branchName,
//         b.description ?? '',
//         b.address ?? '',
//         b.storeManager ?? '',
//       ];
//     }).toList();
//   }

//   void showAlert({
//     bool isEdit = false,
//     BranchModel? branch,
//     VoidCallback? onBack,
//   }) {
//     if (!mounted) return;
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       try {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             contentPadding: EdgeInsets.zero,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             content: BranchFormWidget(
//               isEdit: isEdit,
//               branchModel: branch,
//               onBack: onBack,
//             ),
//           ),
//         );
//       } catch (e) {
//         debugPrint("Error showing dialog: $e");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final pagedProducts = displayedBranches
//         .skip(currentPage * itemsPerPage)
//         .take(itemsPerPage)
//         .toList();

//     return
//     // showProductList
//     //   ?
//     SingleChildScrollView(
//       child: Column(
//         children: [
//           PageHeaderWidget(
//             title: "Branches List".tr(),
//             buttonText: "Add Branch".tr(),
//             subTitle: "Manage your branches".tr(),
//             selectedItems: selectedBranchIds.toList(),
//             buttonWidth: 0.24,
//             onCreate: () {
//               Future.microtask(() {
//                 if (mounted) {
//                   showAlert(isEdit: false);
//                 }
//               });
//             },
//             onDelete: _deleteSelectedBranch,
//             onPdfImport: () async {
//               final rowsToExport = getRow(pagedProducts);
//               await PdfExporter.exportToPdf(
//                 headers: headerColumns,
//                 rows: rowsToExport,
//                 fileNamePrefix: 'Branches_Report',
//               );
//             },
//             onExelImport: () async {
//               final rowsToExport = getRow(pagedProducts);
//               await ExcelExporter.exportToExcel(
//                 headers: headerColumns,
//                 rows: rowsToExport,
//                 fileNamePrefix: 'Branches_Report',
//               );
//             },
//           ),
//           DynamicDataTable<BranchModel>(
//             data: pagedProducts,
//             isWithImage: true,
//             combineImageWithTextIndex: 0,
//             columns: headerColumns,
//             valueGetters: [
//               (b) => '${b.branchName} , ${b.imageUrl}',
//               (b) => b.description ?? '',
//               (b) => b.address ?? '',
//               (b) => b.storeManager ?? '',
//             ],
//             getId: (b) => b.id,
//             selectedIds: selectedBranchIds,
//             onSelectChanged: (val, branch) {
//               setState(() {
//                 if (val == true) {
//                   selectedBranchIds.add(branch.id!);
//                 } else {
//                   selectedBranchIds.remove(branch.id);
//                 }
//               });
//             },
//             onView: (branch) {},
//             onEdit: (branch) {
//               branchesBeingEdited = branch;
//               showAlert(
//                 isEdit: true,
//                 branch: branchesBeingEdited,
//                 onBack: () async {
//                   await _loadBranches();
//                 },
//               );
//             },
//             onStatus: (branch) {},
//             statusTextGetter: (item) => item.status!.capitalizeFirst,
//             onSelectAll: (val) {
//               setState(() {
//                 final ids = pagedProducts.map((e) => e.id!).toList();
//                 if (val == true) {
//                   selectedBranchIds.addAll(ids);
//                 } else {
//                   selectedBranchIds.removeAll(ids);
//                 }
//               });
//             },
//             onSearch: (query) {
//               setState(() {
//                 displayedBranches = allBranches
//                     .where(
//                       (b) => b.branchName.toLowerCase().contains(
//                         query.toLowerCase(),
//                       ),
//                     )
//                     .toList();
//               });
//             },
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: PaginationWidget(
//               currentPage: currentPage,
//               totalItems: allBranches.length,
//               itemsPerPage: itemsPerPage,
//               onPageChanged: (newPage) {
//                 setState(() {
//                   currentPage = newPage;
//                 });
//               },
//               onItemsPerPageChanged: (newLimit) {
//                 setState(() {
//                   itemsPerPage = newLimit;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<BranchesPage> {
  bool showProductList = true;
  bool isLoading = true;
  List<BranchModel> allBranches = [];
  List<BranchModel> displayedBranches = [];
  BranchModel? branchesBeingEdited;
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedBranchIds = {};

  final headerColumns = [
    "Branch Name".tr(),
    "Description".tr(),
    "Address".tr(),
    "Store Manager".tr(),
  ];

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _deleteSelectedBranch() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedBranchIds.length,
    );

    if (confirm != true) return;

    for (String branchId in selectedBranchIds) {
      await FirebaseFirestore.instance
          .collection('branches')
          .doc(branchId)
          .delete();
    }

    setState(() {
      selectedBranchIds.clear();
    });

    await _loadBranches();
  }

  Future<void> _loadBranches() async {
    setState(() {
      isLoading = true;
    });
    final branches = await DataFetchService.fetchBranches();
    setState(() {
      allBranches = branches;
      displayedBranches = branches;
      isLoading = false;
    });
  }

  List<List<dynamic>> getRow(List<BranchModel> branches) {
    return branches.map((b) {
      return [
        b.branchName,
        b.description ?? '',
        b.address ?? '',
        b.storeManager ?? '',
      ];
    }).toList();
  }

  void getBranch(BranchModel branch) {
    branchesBeingEdited = branch;
    showAlert(
      isEdit: true,
      branch: branchesBeingEdited,
      onBack: () {
        _loadBranches();
        branchesBeingEdited = null;
      },
    );
  }

  void showAlert({
    bool isEdit = false,
    BranchModel? branch,
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
            content: BranchFormWidget(
              isEdit: isEdit,
              branchModel: branch,
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

    final pagedProducts = displayedBranches
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return
    // showProductList
    //   ?
    Column(
      children: [
        PageHeaderWidget(
          title: "Branches List".tr(),
          buttonText: "Add Branch".tr(),
          subTitle: "Manage your branches".tr(),
          requiredPermission: 'Add Branches',
          selectedItems: selectedBranchIds.toList(),
          buttonWidth: 0.24,
          onCreate: () {
            Future.microtask(() {
              if (mounted) {
                showAlert(
                  isEdit: false,
                  onBack: () async {
                    await _loadBranches();
                  },
                );
              }
            });
          },
          onDelete: _deleteSelectedBranch,
          onPdfImport: () async {
            final rowsToExport = getRow(pagedProducts);
            await PdfExporter.exportToPdf(
              headers: headerColumns,
              rows: rowsToExport,
              fileNamePrefix: 'Branches_Report',
            );
          },
          onExelImport: () async {
            final rowsToExport = getRow(pagedProducts);
            await ExcelExporter.exportToExcel(
              headers: headerColumns,
              rows: rowsToExport,
              fileNamePrefix: 'Branches_Report',
            );
          },
        ),
        Expanded(
          child: BranchesCardListView(
            branchList: pagedProducts,
            selectedIds: selectedBranchIds,
            onEdit: getBranch,
          ),
        ),

        // DynamicDataTable<BranchModel>(
        //   data: pagedProducts,
        //   editProfileAccessKey: 'Edit Branches',
        //   deleteProfileAccessKey: 'Delete Branches',
        //   isWithImage: true,
        //   combineImageWithTextIndex: 0,
        //   columns: headerColumns,
        //   valueGetters: [
        //     (b) => '${b.branchName} , ${b.imageUrl}',
        //     (b) => b.description ?? '',
        //     (b) => b.address ?? '',
        //     (b) => b.storeManager ?? '',
        //   ],
        //   getId: (b) => b.id,
        //   selectedIds: selectedBranchIds,
        //   onSelectChanged: (val, branch) {
        //     setState(() {
        //       if (val == true) {
        //         selectedBranchIds.add(branch.id!);
        //       } else {
        //         selectedBranchIds.remove(branch.id);
        //       }
        //     });
        //   },
        //   onView: (branch) {},
        //   onDelete: (p0) {},
        //   onEdit: (branch) {
        //     branchesBeingEdited = branch;
        //     showAlert(
        //       isEdit: true,
        //       branch: branchesBeingEdited,
        //       onBack: () async {
        //         await _loadBranches();
        //       },
        //     );
        //   },
        //   onStatus: (branch) {},
        //   statusTextGetter: (item) => item.status!.capitalizeFirst,
        //   onSelectAll: (val) {
        //     setState(() {
        //       final ids = pagedProducts.map((e) => e.id!).toList();
        //       if (val == true) {
        //         selectedBranchIds.addAll(ids);
        //       } else {
        //         selectedBranchIds.removeAll(ids);
        //       }
        //     });
        //   },
        //   onSearch: (query) {
        //     setState(() {
        //       displayedBranches =
        //           allBranches
        //               .where(
        //                 (b) => b.branchName.toLowerCase().contains(
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
            totalItems: allBranches.length,
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
  }
}
