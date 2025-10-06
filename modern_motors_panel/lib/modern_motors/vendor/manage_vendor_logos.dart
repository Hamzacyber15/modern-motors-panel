import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/vendor/ventor_logos_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/vendor/add_edit_vendor_logos.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ManageVendorsLogos extends StatefulWidget {
  const ManageVendorsLogos({super.key});

  @override
  State<ManageVendorsLogos> createState() => _ProductPageState();
}

class _ProductPageState extends State<ManageVendorsLogos> {
  bool showTermsList = true;
  bool isLoading = true;
  bool setLogoLoader = false;
  List selectionList = [];

  // List<TermsAndConditionsOfSalesModel> terms = [];
  List<VendorLogosModel> allLogos = [];
  List<VendorLogosModel> tempLogos = [];
  VendorLogosListModel? logosList;

  List<VendorLogosModel> displayedVendorLogos = [];
  VendorLogosModel? logosBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedCategoryIds = {};

  final headerColumns = ["Logo".tr(), "Create On".tr()];

  @override
  void initState() {
    super.initState();
    loadVendorLogos();
  }

  Future<void> loadVendorLogos() async {
    setState(() {
      isLoading = true;
    });
    final vendorsLogos = await DataFetchService.fetchVendorLogos();
    setState(() {
      logosList = vendorsLogos;
      if (logosList != null) {
        allLogos = logosList?.logos ?? [];
        displayedVendorLogos = logosList?.logos ?? [];
        tempLogos = logosList?.logos ?? [];
        selectedCategoryIds = allLogos
            .asMap()
            .entries
            .where((entry) => entry.value.status == "active")
            .map((entry) => entry.key.toString())
            .toSet();
      }

      isLoading = false;
    });
  }

  Future<void> updateLogosStatus() async {
    if (logosList == null || logosList!.id == null) return;

    if (setLogoLoader) return;
    setState(() {
      setLogoLoader = true;
    });
    final updatedLogos = allLogos.asMap().entries.map((entry) {
      final index = entry.key.toString();
      final logo = entry.value;

      return VendorLogosModel(
        imgUrl: logo.imgUrl,
        status: selectedCategoryIds.contains(index) ? "active" : "inactive",
        createdAt: logo.createdAt,
      ).toMap();
    }).toList();

    try {
      await FirebaseFirestore.instance
          .collection("vendorLogos")
          .doc(logosList!.id)
          .update({"logos": updatedLogos});

      if (mounted) {
        setState(() {
          allLogos = updatedLogos
              .map((m) => VendorLogosModel.fromMap(m))
              .toList();
        });
        Constants.showMessage(context, "Logos status updated successfully");
        loadVendorLogos();
      }
    } catch (e) {
      debugPrint("Error updating statuses: $e");
      if (!mounted) return;
      Constants.showMessage(context, "Error: $e");
    } finally {
      setState(() {
        setLogoLoader = false;
      });
    }
  }

  void showAlert({
    bool isEdit = false,
    VendorLogosModel? termsAndConditionModel,
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
            content: AddEditVendorLogos(
              isEdit: isEdit,
              termsModel: termsAndConditionModel,
              termsList: allLogos,
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

    final pagedProducts = displayedVendorLogos
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return showTermsList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: "Vendor LOGOS".tr(),
                  buttonText: "Add Vendor LOGOS".tr(),
                  subTitle: "Manage Vendor LOGOS".tr(),
                  requiredPermission: 'Add Vendors LOGO',
                  selectedItems: [],
                  buttonWidth: 0.34,
                  onCreate: () {
                    showTermsList = false;
                    setState(() {});
                  },
                  // onDelete: _deleteSelectedCategories,
                  selection: selectionList.isNotEmpty,
                  setLogos: setLogoLoader
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: 120,
                          height: context.height * 0.06,
                          child: CustomButton(
                            text: 'Marked',
                            onPressed: () async {
                              await updateLogosStatus();
                            },
                            iconColor: AppTheme.whiteColor,
                            buttonType: ButtonType.TextOnly,
                            borderColor: Color(
                              0xff0686ef,
                            ).withValues(alpha: 0.7),
                            backgroundColor: Color(
                              0xff0686ef,
                            ).withValues(alpha: 0.1),
                            textColor: Color(0xff0686ef),
                          ),
                        ),
                  // buildActionButton(
                  //       icon: Icons.track_changes_outlined,
                  //       color: Color(0xff0b2cda),
                  //       tooltip: 'Set LOGOS',
                  //       onTap: ,
                  //     ),
                ),

                allLogos.isEmpty
                    ? EmptyWidget(text: "No Vendor LOGOS added yet..")
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFF8FAFC),
                                const Color(0xFFE2E8F0).withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(
                                0xFFE2E8F0,
                              ).withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemCount: pagedProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6, // columns
                                  crossAxisSpacing: 26,
                                  mainAxisSpacing: 26,
                                  childAspectRatio: 1.3,
                                ),
                            itemBuilder: (context, index) {
                              final logo = pagedProducts[index];
                              final logoIndex = allLogos.indexOf(logo);
                              final isSelected = selectedCategoryIds.contains(
                                logoIndex.toString(),
                              );

                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        logo.imgUrl,
                                        fit: BoxFit.cover,
                                        width: context.width * 0.8,
                                        height: context.height * 0.8,
                                        errorBuilder: (_, __, ___) =>
                                            Image.asset(
                                              'assets/images/logo1.png',
                                              fit: BoxFit.cover,
                                              width: context.width * 0.8,
                                              height: context.height * 0.8,
                                            ),
                                      ),
                                    ),
                                  ),

                                  // 🔹 Checkbox at top-right
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Checkbox(
                                      value: isSelected,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            selectedCategoryIds.add(
                                              logoIndex.toString(),
                                            );
                                            selectionList.add(
                                              logoIndex.toString(),
                                            );
                                          } else {
                                            selectedCategoryIds.remove(
                                              logoIndex.toString(),
                                            );
                                            selectionList.remove(
                                              logoIndex.toString(),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                // : DynamicDataTable<VendorLogosModel>(
                //   data: pagedProducts,
                //   isWithImage: true,
                //   columns: headerColumns,
                //   valueGetters: [
                //     (v) => v.imgUrl,
                //     (v) => v.createdAt!.toDate().formattedWithDayMonthYear,
                //   ],
                //   getId: (v) => allLogos.indexOf(v).toString(),
                //   selectedIds: selectedCategoryIds,
                //   onSelectChanged: (val, logo) {
                //     final index = allLogos.indexOf(logo);
                //     if (index == -1) return;
                //     setState(() {
                //       if (val == true) {
                //         selectedCategoryIds.add(index.toString());
                //         selectionList.add(index.toString());
                //       } else {
                //         selectedCategoryIds.remove(index.toString());
                //         selectionList.remove(index.toString());
                //       }
                //     });
                //   },
                //   onStatus: (logo) {},
                //   statusTextGetter: (item) => item.status.capitalizeFirst,
                //   onSelectAll: (logos) {
                //     setState(() {
                //       if (logos == true) {
                //         selectedCategoryIds =
                //             allLogos
                //                 .asMap()
                //                 .entries
                //                 .map((entry) => entry.key.toString())
                //                 .toSet();
                //         selectionList.add(logos);
                //       } else {
                //         selectedCategoryIds =
                //             allLogos
                //                 .asMap()
                //                 .entries
                //                 .where(
                //                   (entry) => entry.value.status == "active",
                //                 )
                //                 .map((entry) => entry.key.toString())
                //                 .toSet();
                //         selectionList.clear();
                //       }
                //     });
                //   },
                // ),
                Align(
                  alignment: Alignment.topRight,
                  child: PaginationWidget(
                    currentPage: currentPage,
                    totalItems: allLogos.length,
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
        : AddEditVendorLogos(
            isEdit: logosBeingEdited != null,
            termsModel: logosBeingEdited,
            termsList: allLogos,
            docId: logosList!.id,
            onBack: () async {
              showTermsList = true;
              logosBeingEdited = null;
              await loadVendorLogos();
            },
          );
  }
}
