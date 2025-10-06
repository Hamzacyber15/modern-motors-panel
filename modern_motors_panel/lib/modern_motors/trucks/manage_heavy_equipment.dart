import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/heavy_equipment_model.dart';
import 'package:modern_motors_panel/modern_motors/trucks/add_edit_heavy_equipment_type.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class ManageHeavyEquipmentType extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const ManageHeavyEquipmentType({super.key, this.onNavigate});

  @override
  State<ManageHeavyEquipmentType> createState() =>
      _ManageHeavyEquipmentTypeState();
}

class _ManageHeavyEquipmentTypeState extends State<ManageHeavyEquipmentType> {
  bool showList = true;
  bool isLoading = true;

  HeavyEquipmentTypeModel? equipmentBeingEdited;
  List<HeavyEquipmentTypeModel> allEquipment = [];
  List<HeavyEquipmentTypeModel> displayedEquipment = [];
  Set<String> selectedIds = {}; // ✅ Local selection state

  final headers = [
    'Name'.tr(),
    'Name(Arabic)'.tr(),
    'Description'.tr(),
    'Description(Arabic)'.tr(),
    'Created On'.tr(),
  ];

  int currentPage = 0;
  int itemsPerPage = 10;

  Future<void> _deleteSelectedItems() async {
    if (selectedIds.isEmpty) {
      SnackbarUtils.showSnackbar(context, "No equipment selected for deletion");
      return;
    }
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedIds.length,
    );

    if (confirm != true) return;

    for (String id in selectedIds) {
      await FirebaseFirestore.instance
          .collection('heavyEquipmentType')
          .doc(id)
          .delete();
    }

    setState(() {
      selectedIds.clear();
    });

    await _loadEquipment();
  }

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }

  Future<void> _loadEquipment() async {
    setState(() => isLoading = true);

    final snapshot = await FirebaseFirestore.instance
        .collection('heavyEquipmentType')
        .orderBy('timestamp', descending: true)
        .get();

    final equipmentList = snapshot.docs
        .map((doc) => HeavyEquipmentTypeModel.fromDoc(doc))
        .toList();

    setState(() {
      allEquipment = equipmentList;
      displayedEquipment = equipmentList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = displayedEquipment
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return showList
        ? SingleChildScrollView(
            child: Column(
              children: [
                PageHeaderWidget(
                  title: 'Heavy Equipment Type'.tr(),
                  buttonText: "Create Equipment".tr(),
                  subTitle: "Manage your heavy equipment".tr(),
                  requiredPermission: 'Add Heavy Equipment Type',
                  selectedItems: selectedIds.toList(),
                  onCreate: () => setState(() => showList = false),
                  buttonWidth: 0.28,
                  onDelete: _deleteSelectedItems,
                  onImport: () {},
                  onExelImport: () {},
                  onPdfImport: () {},
                ),
                allEquipment.isEmpty
                    ? EmptyWidget(
                        text: "There's no Heavy Equipment Type available".tr(),
                      )
                    : DynamicDataTable<HeavyEquipmentTypeModel>(
                        data: pagedItems,
                        editProfileAccessKey: 'Edit Heavy Equipment Type',
                        deleteProfileAccessKey: 'Delete Heavy Equipment Type',
                        isWithImage: true,
                        combineImageWithTextIndex: 0,
                        columns: headers,
                        valueGetters: [
                          (v) => v.name,
                          (v) => v.nameArabic,
                          (v) => v.description,
                          (v) => v.descriptionArabic,
                          (v) =>
                              v.timestamp?.toDate().formattedWithDayMonthYear ??
                              '',
                        ],
                        getId: (v) => v.id ?? '',
                        selectedIds: selectedIds,
                        // ✅ Pass current selection
                        onSelectChanged: (value, item) {
                          setState(() {
                            if (value == true) {
                              selectedIds.add(item.id ?? '');
                            } else {
                              selectedIds.remove(item.id ?? '');
                            }
                          });
                        },
                        onSelectAll: (value) {
                          setState(() {
                            if (value == true) {
                              selectedIds.addAll(
                                pagedItems.map((e) => e.id ?? ''),
                              );
                            } else {
                              selectedIds.clear();
                            }
                          });
                        },
                        onDelete: (p0) {},
                        onEdit: (equipment) {
                          setState(() {
                            equipmentBeingEdited = equipment;
                            showList = false;
                          });
                        },
                        onStatus: (item) async {
                          final newStatus = item.status == "active"
                              ? "inactive"
                              : "active";
                          await FirebaseFirestore.instance
                              .collection(
                                'heavyEquipmentType',
                              ) // ✅ fixed collection
                              .doc(item.id)
                              .update({'status': newStatus});
                          await _loadEquipment();
                        },
                        statusTextGetter: (item) => item.status.capitalizeFirst,
                        onView: (equipment) {},
                        onSearch: (query) {
                          setState(() {
                            displayedEquipment = allEquipment
                                .where(
                                  (item) =>
                                      item.name.toLowerCase().contains(
                                        query.toLowerCase(),
                                      ) ||
                                      item.description.toLowerCase().contains(
                                        query.toLowerCase(),
                                      ),
                                )
                                .toList();
                          });
                        },
                      ),
                displayedEquipment.length > itemsPerPage
                    ? Align(
                        alignment: Alignment.center,
                        child: PaginationWidget(
                          currentPage: currentPage,
                          totalItems: displayedEquipment.length,
                          itemsPerPage: itemsPerPage,
                          onPageChanged: (newPage) =>
                              setState(() => currentPage = newPage),
                          onItemsPerPageChanged: (newLimit) =>
                              setState(() => itemsPerPage = newLimit),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          )
        : AddEditHeavyEquipmentType(
            isEdit: equipmentBeingEdited != null,
            heavyEquipment: equipmentBeingEdited,
            onBack: () async {
              await _loadEquipment();
              setState(() {
                showList = true;
                equipmentBeingEdited = null;
              });
            },
          );
  }
}
