// import 'package:app/modern_motors/excel/excel_exporter.dart';
// import 'package:app/modern_motors/inventory_trucks/inventory_trucks.dart';
// import 'package:app/modern_motors/models/trucks/mmtrucks_model.dart';
// import 'package:app/modern_motors/pdf/pdf_exporter.dart';
// import 'package:app/modern_motors/services/data_fetch_service.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:app/modern_motors/widgets/page_header_widget.dart';
// import 'package:app/modern_motors/widgets/pagination_widget.dart';
// import 'package:app/modern_motors/widgets/reusable_data_table.dart';
// import 'package:app/widgets/empty_widget.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'add_trucks.dart';

// class ManageTrucksPage extends StatefulWidget {
//   const ManageTrucksPage({super.key});

//   @override
//   State<ManageTrucksPage> createState() => _ManageTrucksPageState();
// }

// class _ManageTrucksPageState extends State<ManageTrucksPage> {
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
//                   buttonText: "Add Truck".tr(),
//                   subTitle: "Manage your Trucks".tr(),
//                   requiredPermission: 'Add Trucks',
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
//                         editProfileAccessKey: 'Edit Trucks',
//                         deleteProfileAccessKey: 'Delete Trucks',
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
//                           (v) => v.chassisNumber ?? "",
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
//                         onDelete: (p0) {},
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
//             truckModel: truckBeingEdited,
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

import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/inventory_trucks/inventory_trucks.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';

class ManageTrucksPage extends StatefulWidget {
  final Function(MmtrucksModel)? onTruckEdit;
  final Function()? onAddTruck;

  const ManageTrucksPage({super.key, this.onTruckEdit, this.onAddTruck});

  @override
  State<ManageTrucksPage> createState() => _ManageTrucksPageState();
}

class _ManageTrucksPageState extends State<ManageTrucksPage>
    with TickerProviderStateMixin {
  List<MmtrucksModel> _allTrucks = [];
  List<MmtrucksModel> _filteredTrucks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedFuelType;
  String? _selectedStatus;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();

  // Filter options
  final Map<String, String> _categories = {
    'all': 'All Categories',
    'light_truck': 'Light Truck',
    'medium_truck': 'Medium Truck',
    'heavy_truck': 'Heavy Truck',
    'trailer': 'Trailer',
    'pickup': 'Pickup Truck',
    'van': 'Commercial Van',
  };

  final Map<String, String> _conditions = {
    'all': 'All Conditions',
    'new': 'Brand New',
    'used_excellent': 'Used - Excellent',
    'used_good': 'Used - Good',
    'used_fair': 'Used - Fair',
    'refurbished': 'Refurbished',
  };

  final Map<String, String> _fuelTypes = {
    'all': 'All Fuel Types',
    'diesel': 'Diesel',
    'petrol': 'Petrol',
    'electric': 'Electric',
    'hybrid': 'Hybrid',
  };

  final Map<String, String> _statuses = {
    'all': 'All Status',
    'active': 'Active',
    'inactive': 'Inactive',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadTrucks();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  Future<void> _loadTrucks() async {
    try {
      // Replace with your actual truck loading logic
      final trucks = await DataFetchService.fetchTrucks();
      setState(() {
        _allTrucks = trucks;
        _filteredTrucks = trucks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTrucks = _allTrucks.where((truck) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          if (!(truck.plateNumber?.toString().contains(searchLower) == true ||
              truck.brand?.toLowerCase().contains(searchLower) == true ||
              truck.modelName?.toLowerCase().contains(searchLower) == true ||
              truck.code?.toLowerCase().contains(searchLower) == true)) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategory != null && _selectedCategory != 'all') {
          if (truck.category != _selectedCategory) return false;
        }

        // Condition filter
        if (_selectedCondition != null && _selectedCondition != 'all') {
          if (truck.condition != _selectedCondition) return false;
        }

        // Fuel type filter
        if (_selectedFuelType != null && _selectedFuelType != 'all') {
          if (truck.fuelType != _selectedFuelType) return false;
        }

        // Status filter
        if (_selectedStatus != null && _selectedStatus != 'all') {
          if (truck.status != _selectedStatus) return false;
        }

        return true;
      }).toList();
    });
  }

  void _showImageGallery(BuildContext context, MmtrucksModel truck) {
    if (truck.imageUrls == null || truck.imageUrls!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No images available for this truck'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ImageGalleryDialog(
        images: truck.imageUrls!,
        truckInfo: '${truck.brand} ${truck.modelName} - ${truck.plateNumber}',
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterBar(),
            Expanded(child: _buildTruckGrid()),
          ],
        ),
      ),
    );
  }

  void navTrucks() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return InventoryTrucks(
            isEdit: false,
            // truckModel: truckBeingEdited,
            onBack: () async {
              // await _loadTrucksData();
              // setState(() {
              //   showTruckList = true;
              //   truckBeingEdited = null;
              // });
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Truck Inventory',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      '${_filteredTrucks.length} vehicles available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: navTrucks,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add Truck'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: 'Search by plate number, brand, model, or code...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF6B7280)),
                      onPressed: () {
                        _searchController.clear();
                        _searchQuery = '';
                        _applyFilters();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterDropdown(
              'Category',
              _selectedCategory,
              _categories,
              (value) => setState(() {
                _selectedCategory = value;
                _applyFilters();
              }),
            ),
            const SizedBox(width: 12),
            _buildFilterDropdown(
              'Condition',
              _selectedCondition,
              _conditions,
              (value) => setState(() {
                _selectedCondition = value;
                _applyFilters();
              }),
            ),
            const SizedBox(width: 12),
            _buildFilterDropdown(
              'Fuel Type',
              _selectedFuelType,
              _fuelTypes,
              (value) => setState(() {
                _selectedFuelType = value;
                _applyFilters();
              }),
            ),
            const SizedBox(width: 12),
            _buildFilterDropdown(
              'Status',
              _selectedStatus,
              _statuses,
              (value) => setState(() {
                _selectedStatus = value;
                _applyFilters();
              }),
            ),
            const SizedBox(width: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _selectedCondition = null;
                  _selectedFuelType = null;
                  _selectedStatus = null;
                  _searchQuery = '';
                  _searchController.clear();
                  _applyFilters();
                });
              },
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear Filters'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String? value,
    Map<String, String> options,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(label, style: const TextStyle(fontSize: 14)),
        underline: const SizedBox(),
        items: options.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key == 'all' ? null : entry.key,
            child: Text(entry.value, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTruckGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
      );
    }

    if (_filteredTrucks.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredTrucks.length,
        itemBuilder: (context, index) {
          return TruckCard(
            truck: _filteredTrucks[index],
            onTap: () => widget.onTruckEdit?.call(_filteredTrucks[index]),
            onImageTap: () =>
                _showImageGallery(context, _filteredTrucks[index]),
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1400) return 4;
    if (width > 1000) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No trucks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Add your first truck to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          if (widget.onAddTruck != null)
            ElevatedButton.icon(
              onPressed: widget.onAddTruck,
              icon: const Icon(Icons.add),
              label: const Text('Add First Truck'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TruckCard extends StatelessWidget {
  final MmtrucksModel truck;
  final VoidCallback? onTap;
  final VoidCallback? onImageTap;

  const TruckCard({Key? key, required this.truck, this.onTap, this.onImageTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Expanded(child: _buildInfoSection()),
            _buildActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Colors.grey.shade200,
          ),
          child: truck.imageUrls?.isNotEmpty == true
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    truck.imageUrls!.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(),
                  ),
                )
              : _buildPlaceholderImage(),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: truck.status == 'active' ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              truck.status?.toUpperCase() ?? 'UNKNOWN',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (truck.imageUrls?.isNotEmpty == true)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${truck.imageUrls!.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 32, color: Colors.grey.shade400),
            const SizedBox(height: 4),
            Text(
              'No Image',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${truck.brand ?? 'Unknown'} ${truck.modelName ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (truck.condition != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getConditionColor(
                      truck.condition!,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    truck.condition!.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getConditionColor(truck.condition!),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.confirmation_number,
            'Plate: ${truck.plateNumber ?? 'N/A'}',
          ),
          _buildInfoRow(
            Icons.category,
            truck.category?.replaceAll('_', ' ') ?? 'N/A',
          ),
          _buildInfoRow(Icons.local_gas_station, truck.fuelType ?? 'N/A'),
          if (truck.mileage != null)
            _buildInfoRow(Icons.speed, '${truck.mileage} km'),
          const Spacer(),
          if (truck.sellingPrice != null)
            Text(
              'OMR ${truck.sellingPrice!.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF059669),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          if (truck.imageUrls?.isNotEmpty == true)
            Expanded(
              child: TextButton.icon(
                onPressed: onImageTap,
                icon: const Icon(Icons.photo_library, size: 16),
                label: const Text('Gallery', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return Colors.green;
      case 'used_excellent':
        return Colors.blue;
      case 'used_good':
        return Colors.orange;
      case 'used_fair':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class ImageGalleryDialog extends StatefulWidget {
  final List<String> images;
  final String truckInfo;

  const ImageGalleryDialog({
    Key? key,
    required this.images,
    required this.truckInfo,
  }) : super(key: key);

  @override
  State<ImageGalleryDialog> createState() => _ImageGalleryDialogState();
}

class _ImageGalleryDialogState extends State<ImageGalleryDialog> {
  PageController? _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.photo_library, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vehicle Gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.truckInfo,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Failed to load image'),
                                ],
                              ),
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.images.length > 1)
              Container(
                height: 80,
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _pageController?.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _currentIndex == index
                                ? const Color(0xFF3B82F6)
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            widget.images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
