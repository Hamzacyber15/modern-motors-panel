import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/trucks/add_trucks.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

// class ManageTruckInventory extends StatefulWidget {
//   const ManageTruckInventory({super.key});

//   @override
//   State<ManageTruckInventory> createState() => _ManageTruckInventoryState();
// }

// class _ManageTruckInventoryState extends State<ManageTruckInventory> {
//   bool showTruckList = true;
//   bool isLoading = false;

//   List<MmtrucksModel> allTrucks = [];
//   List<MmtrucksModel> displayedTrucks = [];

//   MmtrucksModel? truckBeingEdited;

//   int currentPage = 0;
//   int itemsPerPage = 10;
//   Set<String> selectedTruckIds = {};

//   // List<UnitModel> units = [];
//   //
//   Future<void> _deleteSelectedProducts() async {
//     // final confirm = await DeleteDialogHelper.showDeleteConfirmation(
//     //   context,
//     //   selectedTruckIds.length,
//     // );
//     //
//     // if (confirm != true) return;
//     //
//     // for (String productId in selectedTruckIds) {
//     //   await FirebaseFirestore.instance
//     //       .collection('productsCategory')
//     //       .doc(productId)
//     //       .delete();
//     // }
//     //
//     // setState(() {
//     //   selectedTruckIds.clear();
//     // });
//     //
//     // await _loadProducts();
//   }

//   final List<String> productHeaders = [
//     'Plate Number',
//     'Code',
//     'Vehicle Type',
//     'Color',
//     'Country',
//     'Model Year',
//     'Engine Capacity',
//     'Empty Weight',
//     'MaxLoad',
//     'Manufacture Year',
//     'Passenger Count',
//     'Chassis Number',
//     'Created By',
//   ];

//   List<List<dynamic>> getTrucksRowsForExcel(List<MmtrucksModel> trucks) {
//     return trucks.map((t) {
//       return [
//         t.plateNumber ?? '',
//         t.code,
//         t.vehicleType,
//         t.color,
//         t.country,
//         t.modelYear,
//         t.engineCapacity,
//         t.emptyWeight,
//         t.maxLoad,
//         t.manufactureYear,
//         t.passengerCount,
//         t.createAt!.toDate().formattedWithDayMonthYear,
//       ];
//     }).toList();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadTrucksData();
//   }

//   Future<void> _loadTrucksData() async {
//     setState(() {
//       isLoading = true;
//     });
//     Future.wait([DataFetchService.fetchTrucks()]).then((results) {
//       setState(() {
//         allTrucks = results[0];
//         displayedTrucks = results[0];
//         isLoading = false;
//       });
//     });
//   }

//   // Future<void> buildUserIdToNameMap(List<ProductModel> products) async {
//   //   final userIds =
//   //       products
//   //           .map((p) => p.createdBy)
//   //           .where((id) => id != null && id.isNotEmpty)
//   //           .toSet();
//   //   final snapshot =
//   //       await FirebaseFirestore.instance
//   //           .collection('profile')
//   //           .where(FieldPath.documentId, whereIn: userIds.toList())
//   //           .get();
//   //
//   //   final Map<String, String> map = {
//   //     for (var doc in snapshot.docs)
//   //       doc.id: (doc.data()['fullName'] ?? 'Unknown') as String,
//   //   };
//   //
//   //   userIdToName = map;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final pagedTrucks = displayedTrucks
//         .skip(currentPage * itemsPerPage)
//         .take(itemsPerPage)
//         .toList();

//     return showTruckList
//         ? SingleChildScrollView(
//             child: Column(
//               children: [
//                 PageHeaderWidget(
//                   title: "Trucks List".tr(),
//                   buttonText: "Create".tr(),
//                   subTitle: "Manage your Trucks".tr(),
//                   selectedItems: selectedTruckIds.toList(),
//                   onCreate: () {
//                     setState(() {
//                       showTruckList = false;
//                     });
//                   },
//                   onDelete: _deleteSelectedProducts,
//                   onExelImport: () async {
//                     final rowsToExport = getTrucksRowsForExcel(pagedTrucks);
//                     await ExcelExporter.exportToExcel(
//                       headers: productHeaders,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Trucks_Report',
//                     );
//                   },
//                   onImport: () {},
//                   onPdfImport: () async {
//                     final rowsToExport = getTrucksRowsForExcel(pagedTrucks);
//                     await PdfExporter.exportToPdf(
//                       headers: productHeaders,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Trucks_Report',
//                     );
//                   },
//                 ),
//                 allTrucks.isEmpty
//                     ? EmptyWidget(text: "There's no trucks available")
//                     : DynamicDataTable<MmtrucksModel>(
//                         data: pagedTrucks,
//                         columns: productHeaders,
//                         valueGetters: [
//                           (v) => v.plateNumber.toString(),
//                           (v) => v.code ?? '',
//                           (v) => v.vehicleType,
//                           (v) => v.color ?? '',
//                           (v) => v.country ?? '',
//                           (v) => v.modelYear.toString(),
//                           (v) => v.engineCapacity.toString(),
//                           (v) => v.emptyWeight.toString(),
//                           (v) => v.maxLoad.toString(),
//                           (v) => v.manufactureYear.toString(),
//                           (v) => v.passengerCount.toString(),
//                           (v) => v.chassisNumber!,
//                           (v) => v.createAt!.toDate().formattedWithDayMonthYear,
//                         ],
//                         getId: (v) => v.id,
//                         selectedIds: selectedTruckIds,
//                         onSelectChanged: (val, trucks) {
//                           setState(() {
//                             if (val == true) {
//                               selectedTruckIds.add(trucks.id!);
//                             } else {
//                               selectedTruckIds.remove(trucks.id);
//                             }
//                           });
//                         },
//                         onEdit: (product) {
//                           setState(() {
//                             showTruckList = false;
//                             truckBeingEdited = product;
//                           });
//                         },
//                         onStatus: (trucks) {},
//                         statusTextGetter: (item) =>
//                             item.status!.capitalizeFirst,
//                         onView: (product) {},
//                         onSelectAll: (val) {
//                           setState(() {
//                             final currentPageIds =
//                                 pagedTrucks.map((e) => e.id!).toList();
//                             if (val == true) {
//                               selectedTruckIds.addAll(currentPageIds);
//                             } else {
//                               selectedTruckIds.removeAll(currentPageIds);
//                             }
//                           });
//                         },
//                         onSearch: (query) {
//                           setState(() {
//                             displayedTrucks = allTrucks
//                                 .where(
//                                   (product) => product.plateNumber
//                                       .toString()
//                                       .contains(query.toLowerCase()),
//                                 )
//                                 .toList();
//                           });
//                         },
//                       ),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: PaginationWidget(
//                     currentPage: currentPage,
//                     totalItems: allTrucks.length,
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
//         : InventoryTrucks(
//             isEdit: truckBeingEdited != null,
//             MmtrucksModel: truckBeingEdited,
//             onBack: () async {
//               await _loadTrucksData();
//               setState(() {
//                 showTruckList = true;
//                 truckBeingEdited = null;
//               });
//             },
//           );
//   }
// }

// Enum for dropdown actions
enum TruckAction { view, edit, delete }

class TruckCard extends StatelessWidget {
  final MmtrucksModel truck;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(TruckAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const TruckCard({
    super.key,
    required this.truck,
    this.isSelected = false,
    this.onTap,
    this.onActionSelected,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Checkbox
              if (onSelectChanged != null) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectChanged,
                    activeColor: Theme.of(context).primaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Truck Code Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'TRUCK-${truck.code}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Truck Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade100,
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Plate Number & Vehicle Type
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      truck.plateNumber.toString() ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a202c),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      truck.vehicleType ?? 'No vehicle type',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        truck.chassisNumber ?? 'No chassis',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Vehicle Details
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      truck.color ?? 'N/A',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${"Model"}: ${truck.modelYear ?? 'N/A'}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Engine & Weight Info
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Engine: ${truck.engineCapacity ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getEngineColor(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Weight: ${truck.emptyWeight ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Capacity Info
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Load: ${truck.maxLoad ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Passengers: ${truck.passengerCount ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 1),
                    // Manufacture Year
                    if (truck.manufactureYear != null)
                      Text(
                        'Made: ${truck.manufactureYear}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        (truck.vehicleType ?? 'truck').toUpperCase(),
                        style: TextStyle(
                          color: _getTypeColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Country & Additional Info
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      truck.country ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        "TRUCK",
                        style: TextStyle(
                          color: Colors.purple.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Created Date & Created By
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat(
                        'MMM dd',
                      ).format(truck.createAt?.toDate() ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    // Created By
                    Text(
                      'By: ${truck.addedBy ?? 'System'}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Created',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Action Dropdown Menu
              PopupMenuButton<TruckAction>(
                onSelected: (TruckAction action) {
                  if (onActionSelected != null) {
                    onActionSelected!(action);
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 0),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<TruckAction>(
                    value: TruckAction.view,
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('View'),
                      ],
                    ),
                  ),
                  PopupMenuItem<TruckAction>(
                    value: TruckAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<TruckAction>(
                    value: TruckAction.delete,
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (truck.status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      case 'busy':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getEngineColor() {
    final capacity = truck.engineCapacity ?? 0;
    if (capacity > 3000) return Colors.red;
    if (capacity > 2000) return Colors.orange;
    return Colors.green;
  }

  Color _getTypeColor() {
    switch (truck.vehicleType?.toLowerCase()) {
      case 'heavy':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'light':
        return Colors.green;
      case 'pickup':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (truck.status?.toLowerCase()) {
      case 'active':
        return 'ACTIVE';
      case 'inactive':
        return 'INACTIVE';
      case 'maintenance':
        return 'MAINTENANCE';
      case 'busy':
        return 'BUSY';
      default:
        return 'UNKNOWN';
    }
  }
}

// Enhanced TruckListView with updated header
class TruckListView extends StatefulWidget {
  final List<MmtrucksModel> trucks;
  final Set<String> selectedIds;
  final Function(bool?, MmtrucksModel) onSelectChanged;
  final bool enableSearch;
  final Function? tapped;

  const TruckListView({
    super.key,
    required this.trucks,
    required this.selectedIds,
    required this.onSelectChanged,
    this.tapped,
    this.enableSearch = true,
  });

  @override
  State<TruckListView> createState() => _TruckListViewState();
}

class _TruckListViewState extends State<TruckListView> {
  final TextEditingController _searchController = TextEditingController();
  List<MmtrucksModel> _filteredTrucks = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredTrucks = widget.trucks;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterTrucks();
    });
  }

  void _filterTrucks() {
    if (_searchQuery.isEmpty) {
      _filteredTrucks = widget.trucks;
    } else {
      _filteredTrucks = widget.trucks.where((truck) {
        final searchLower = _searchQuery.toLowerCase();
        return (truck.plateNumber?.toString().contains(searchLower) ?? false) ||
            (truck.code?.toLowerCase().contains(searchLower) ?? false) ||
            (truck.vehicleType?.toLowerCase().contains(searchLower) ?? false) ||
            (truck.color?.toLowerCase().contains(searchLower) ?? false) ||
            (truck.country?.toLowerCase().contains(searchLower) ?? false) ||
            (truck.chassisNumber?.toLowerCase().contains(searchLower) ??
                false) ||
            (truck.status?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }
  }

  @override
  void didUpdateWidget(TruckListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trucks != widget.trucks) {
      _filterTrucks();
    }
  }

  void _handleActionSelected(MmtrucksModel truck, TruckAction action) async {
    switch (action) {
      case TruckAction.view:
        // Implement view functionality
        debugPrint('View truck: ${truck.plateNumber}');
        break;
      case TruckAction.edit:
        // Edit will be handled by parent widget
        debugPrint('Edit truck: ${truck.plateNumber}');
        break;
      case TruckAction.delete:
        _showDeleteConfirmation(truck);
        break;
    }
  }

  void _showDeleteConfirmation(MmtrucksModel truck) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Truck'),
        content: Text(
          'Are you sure you want to delete "${truck.plateNumber}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              debugPrint('Deleted truck: ${truck.plateNumber}');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        if (widget.enableSearch)
          Container(
            height: 50,
            margin: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    'Search by plate number, code, vehicle type, color, country...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),

        // Results count
        if (widget.enableSearch && _searchQuery.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Found ${_filteredTrucks.length} truck${_filteredTrucks.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_searchQuery.isNotEmpty) ...[
                  Text(
                    ' for "$_searchQuery"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

        // Header Row
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              if (widget.selectedIds.isNotEmpty) const SizedBox(width: 32),
              const SizedBox(width: 100), // Truck code space
              const SizedBox(width: 52), // Icon space
              Expanded(
                flex: 2,
                child: Text('Plate & Details', style: _headerStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text('Vehicle Info', style: _headerStyle()),
              ),
              Expanded(
                flex: 1,
                child: Text('Engine & Status', style: _headerStyle()),
              ),
              Expanded(flex: 1, child: Text('Capacity', style: _headerStyle())),
              Expanded(flex: 1, child: Text('Country', style: _headerStyle())),
              Expanded(
                flex: 1,
                child: Text('Created Info', style: _headerStyle()),
              ),
              const SizedBox(width: 30), // Actions space
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Trucks List
        Expanded(
          child: _filteredTrucks.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredTrucks.length,
                  itemBuilder: (context, index) {
                    final truck = _filteredTrucks[index];

                    return TruckCard(
                      truck: truck,
                      isSelected: widget.selectedIds.contains(truck.id),
                      onActionSelected: (action) =>
                          _handleActionSelected(truck, action),
                      onSelectChanged: (value) =>
                          widget.onSelectChanged(value, truck),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty ? Icons.search_off : Icons.local_shipping,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No trucks found for "$_searchQuery"'
                : 'No trucks available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Add your first truck to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade700,
    );
  }
}

class ManageTruckInventory extends StatefulWidget {
  const ManageTruckInventory({super.key});

  @override
  State<ManageTruckInventory> createState() => _ManageTruckInventoryState();
}

class _ManageTruckInventoryState extends State<ManageTruckInventory> {
  bool showTruckList = true;
  bool isLoading = false;
  List<MmtrucksModel> allTrucks = [];
  List<MmtrucksModel> displayedTrucks = [];
  MmtrucksModel? truckBeingEdited;
  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedTruckIds = {};

  final List<String> productHeaders = [
    'Plate Number',
    'Code',
    'Vehicle Type',
    'Color',
    'Country',
    'Model Year',
    'Engine Capacity',
    'Empty Weight',
    'MaxLoad',
    'Manufacture Year',
    'Passenger Count',
    'Chassis Number',
    'Created By',
  ];

  List<List<dynamic>> getTrucksRowsForExcel(List<MmtrucksModel> trucks) {
    return trucks.map((t) {
      return [
        t.plateNumber ?? '',
        t.code,
        t.vehicleType,
        t.color,
        t.country,
        t.modelYear,
        t.engineCapacity,
        t.emptyWeight,
        t.maxLoad,
        t.manufactureYear,
        t.passengerCount,
        t.createAt!.toDate().formattedWithDayMonthYear,
      ];
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadTrucksData();
  }

  Future<void> _loadTrucksData() async {
    setState(() {
      isLoading = true;
    });
    Future.wait([DataFetchService.fetchTrucks()]).then((results) {
      setState(() {
        allTrucks = results[0];
        displayedTrucks = results[0];
        isLoading = false;
      });
    });
  }

  Future<void> _deleteSelectedProducts() async {
    // Implementation for delete functionality
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pagedTrucks = displayedTrucks
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return showTruckList
        ? Column(
            children: [
              PageHeaderWidget(
                title: "Trucks List".tr(),
                buttonText: "Add Truck".tr(),
                subTitle: "Manage your Trucks".tr(),
                requiredPermission: 'Add Trucks',
                selectedItems: selectedTruckIds.toList(),
                onCreate: () {
                  setState(() {
                    showTruckList = false;
                  });
                },
                onDelete: _deleteSelectedProducts,
                onExelImport: () async {
                  final rowsToExport = getTrucksRowsForExcel(pagedTrucks);
                  await ExcelExporter.exportToExcel(
                    headers: productHeaders,
                    rows: rowsToExport,
                    fileNamePrefix: 'Trucks_Report',
                  );
                },
                onImport: () {},
                onPdfImport: () async {
                  final rowsToExport = getTrucksRowsForExcel(pagedTrucks);
                  await PdfExporter.exportToPdf(
                    headers: productHeaders,
                    rows: rowsToExport,
                    fileNamePrefix: 'Trucks_Report',
                  );
                },
              ),
              allTrucks.isEmpty
                  ? EmptyWidget(text: "There's no trucks available")
                  : Expanded(
                      child: Column(
                        children: [
                          // Results count
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${displayedTrucks.length} ${'trucks found'.tr()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Trucks list
                          Expanded(
                            child: TruckListView(
                              trucks: pagedTrucks,
                              selectedIds: selectedTruckIds,
                              tapped: _loadTrucksData,
                              onSelectChanged: (isSelected, truck) {
                                setState(() {
                                  if (isSelected == true) {
                                    selectedTruckIds.add(truck.id!);
                                  } else {
                                    selectedTruckIds.remove(truck.id);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              displayedTrucks.length > itemsPerPage
                  ? Align(
                      alignment: Alignment.center,
                      child: PaginationWidget(
                        currentPage: currentPage,
                        totalItems: displayedTrucks.length,
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
                    )
                  : const SizedBox.shrink(),
            ],
          )
        : AddTrucks(
            isEdit: truckBeingEdited != null,
            truckModel: truckBeingEdited,
            onBack: () async {
              await _loadTrucksData();
              setState(() {
                showTruckList = true;
                truckBeingEdited = null;
              });
            },
          );
  }
}
