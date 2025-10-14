// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductDetailsPage extends StatefulWidget {
//   final ProductModel product;

//   const ProductDetailsPage({super.key, required this.product});

//   @override
//   State<ProductDetailsPage> createState() => _ProductDetailsPageState();
// }

// class _ProductDetailsPageState extends State<ProductDetailsPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.productName ?? 'Product Details'),
//         elevation: 0,
//         backgroundColor: Colors.blue.shade600,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             onPressed: _editProduct,
//             icon: const Icon(Icons.edit),
//             tooltip: 'Edit Product',
//           ),
//           IconButton(
//             onPressed: _cloneProduct,
//             icon: const Icon(Icons.content_copy),
//             tooltip: 'Clone Product',
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Header Section
//             _buildProductHeader(),

//             // Quick Stats Cards
//             _buildQuickStats(),

//             // Action Buttons
//             _buildActionButtons(),

//             // Tabs Section
//             _buildTabSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Colors.grey.shade50,
//       child: Row(
//         children: [
//           // Product Image
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: widget.product.image != null &&
//                       widget.product.image!.isNotEmpty
//                   ? Image.network(
//                       widget.product.image!,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) =>
//                           _buildPlaceholderImage(),
//                     )
//                   : _buildPlaceholderImage(),
//             ),
//           ),
//           const SizedBox(width: 16),

//           // Product Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.product.productName ?? 'N/A',
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildInfoRow('Product Code', widget.product.code),
//                 _buildInfoRow('Status', widget.product.status),
//                 _buildInfoRow('Category ID', widget.product.categoryId),
//                 _buildInfoRow('Brand ID', widget.product.brandId),
//                 _buildInfoRow(
//                     'Threshold', widget.product.threshold?.toString()),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlaceholderImage() {
//     return Container(
//       color: Colors.grey.shade200,
//       child: Icon(
//         Icons.image,
//         size: 40,
//         color: Colors.grey.shade400,
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value ?? 'N/A',
//               style: const TextStyle(fontWeight: FontWeight.w400),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildStatCard(
//               'Stock on Hand Value',
//               '\$${(widget.product.totalStockOnHand ?? 0).toStringAsFixed(2)}',
//               Icons.inventory,
//               Colors.green,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _buildStatCard(
//               'Average Unit Cost',
//               '\$${(widget.product.averageCost ?? 0).toStringAsFixed(2)}',
//               Icons.attach_money,
//               Colors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(
//       String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 32),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: _editProduct,
//               icon: const Icon(Icons.edit),
//               label: const Text('Edit Product'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue.shade600,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: OutlinedButton.icon(
//               onPressed: _cloneProduct,
//               icon: const Icon(Icons.content_copy),
//               label: const Text('Clone Product'),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabSection() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.blue.shade600,
//               unselectedLabelColor: Colors.grey.shade600,
//               indicatorColor: Colors.blue.shade600,
//               indicatorWeight: 3,
//               tabs: const [
//                 Tab(text: 'Inventory Logs', icon: Icon(Icons.history)),
//                 Tab(text: 'Inventory Batches', icon: Icon(Icons.inventory_2)),
//                 Tab(text: 'Batch Logs', icon: Icon(Icons.list_alt)),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 400,
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildInventoryLogs(),
//                 _buildInventoryBatches(),
//                 _buildBatchLogs(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInventoryLogs() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildLogItem(
//           'Stock Addition',
//           '+50 units',
//           'Jan 15, 2024 10:30 AM',
//           Icons.add_circle,
//           Colors.green,
//         ),
//         _buildLogItem(
//           'Stock Reduction',
//           '-25 units',
//           'Jan 14, 2024 02:15 PM',
//           Icons.remove_circle,
//           Colors.red,
//         ),
//         _buildLogItem(
//           'Price Update',
//           '\$15.99 → \$17.99',
//           'Jan 12, 2024 09:45 AM',
//           Icons.attach_money,
//           Colors.blue,
//         ),
//         _buildLogItem(
//           'Stock Addition',
//           '+100 units',
//           'Jan 10, 2024 11:20 AM',
//           Icons.add_circle,
//           Colors.green,
//         ),
//       ],
//     );
//   }

//   Widget _buildInventoryBatches() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildBatchItem('Batch #001', 150, '\$15.50', 'Jan 15, 2024'),
//         _buildBatchItem('Batch #002', 200, '\$16.20', 'Jan 10, 2024'),
//         _buildBatchItem('Batch #003', 75, '\$14.80', 'Jan 05, 2024'),
//         _buildBatchItem('Batch #004', 300, '\$15.90', 'Dec 28, 2023'),
//       ],
//     );
//   }

//   Widget _buildBatchLogs() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildLogItem(
//           'Batch #001 Created',
//           '150 units added',
//           'Jan 15, 2024 10:30 AM',
//           Icons.add_box,
//           Colors.green,
//         ),
//         _buildLogItem(
//           'Batch #002 Sold',
//           '25 units sold from Batch #002',
//           'Jan 14, 2024 02:15 PM',
//           Icons.shopping_cart,
//           Colors.orange,
//         ),
//         _buildLogItem(
//           'Batch #003 Updated',
//           'Cost updated to \$14.80',
//           'Jan 12, 2024 09:45 AM',
//           Icons.edit,
//           Colors.blue,
//         ),
//       ],
//     );
//   }

//   Widget _buildLogItem(
//       String title, String subtitle, String time, IconData icon, Color color) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             time,
//             style: TextStyle(
//               color: Colors.grey.shade500,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBatchItem(
//       String batchId, int quantity, String cost, String date) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child:
//                 Icon(Icons.inventory_2, color: Colors.blue.shade600, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   batchId,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$quantity units • Unit Cost: $cost',
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Created: $date',
//                   style: TextStyle(
//                     color: Colors.grey.shade500,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: () => _viewBatchDetails(batchId),
//             icon: const Icon(Icons.arrow_forward_ios),
//             iconSize: 16,
//           ),
//         ],
//       ),
//     );
//   }

//   void _editProduct() {
//     // Navigate to edit product page
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditProductPage(product: widget.product),
//       ),
//     );
//   }

//   void _cloneProduct() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Clone Product'),
//         content: const Text(
//             'Are you sure you want to create a copy of this product?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _performClone();
//             },
//             child: const Text('Clone'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _performClone() {
//     // Create a new product with cloned data
//     ProductModel clonedProduct = ProductModel(
//       productName: '${widget.product.productName} (Copy)',
//       code: '${widget.product.code}-COPY',
//       categoryId: widget.product.categoryId,
//       image: widget.product.image,
//       subCategoryId: widget.product.subCategoryId,
//       brandId: widget.product.brandId,
//       status: 'pending',
//       threshold: widget.product.threshold,
//       createdBy: widget.product.createdBy,
//       description: widget.product.description,
//       createAt: Timestamp.now(),
//     );

//     // Here you would typically save to Firestore
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Product cloned successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   void _viewBatchDetails(String batchId) {
//     // Navigate to batch details or show more info
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Batch Details - $batchId'),
//         content: const Text(
//             'Batch details would be shown here with more comprehensive information.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Placeholder for EditProductPage - you would implement this separately
// class EditProductPage extends StatelessWidget {
//   final ProductModel product;

//   const EditProductPage({Key? key, required this.product}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Product'),
//       ),
//       body: const Center(
//         child: Text('Edit Product Page - Implement your edit form here'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/products/add_edit_product.dart';
import 'package:modern_motors_panel/modern_motors/products/product_inventory_batches.dart';
import 'package:modern_motors_panel/modern_motors/products/product_inventory_logs.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final String? category;
  final String? subCategory;
  final String? brand;
  const ProductDetailsPage({
    super.key,
    required this.product,
    this.category,
    this.subCategory,
    this.brand,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ChartAccount? _selectedRevenueAccount;
  ChartAccount? _selectedCostOfSalesAccount;
  ChartAccount? _selectedAssetAccount;

  // Dropdown items
  List<ChartAccount> _revenueAccounts = [];
  List<ChartAccount> _costOfSalesAccounts = [];
  List<ChartAccount> _assetAccounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChartAccounts();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _loadChartAccounts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final branch = context.read<MmResourceProvider>().getBranchByID(
        BranchIdSp.getBranchId(),
      );

      // Load revenue accounts (4000)
      final revenueParentAccounts =
          await DataFetchService.getChartAccountsByCode(branch.id!, '4000');

      List<ChartAccount> allRevenueAccounts = [];
      for (var parentAccount in revenueParentAccounts) {
        allRevenueAccounts.add(parentAccount);
        if (parentAccount.childAccountIds.isNotEmpty) {
          final childAccounts = await DataFetchService.getChildAccounts(
            branch.id!,
            parentAccount.childAccountIds,
          );
          allRevenueAccounts.addAll(childAccounts);
        }
      }

      // Load cost of sales accounts (5100)
      final costParentAccounts = await DataFetchService.getChartAccountsByCode(
        branch.id!,
        '5100',
      );

      List<ChartAccount> allCostAccounts = [];
      for (var parentAccount in costParentAccounts) {
        allCostAccounts.add(parentAccount);
        if (parentAccount.childAccountIds.isNotEmpty) {
          final childAccounts = await DataFetchService.getChildAccounts(
            branch.id!,
            parentAccount.childAccountIds,
          );
          allCostAccounts.addAll(childAccounts);
        }
      }

      // Load asset accounts (1000)
      final assetParentAccounts = await DataFetchService.getChartAccountsByCode(
        branch.id!,
        '1000',
      );

      List<ChartAccount> allAssetAccounts = [];
      for (var parentAccount in assetParentAccounts) {
        allAssetAccounts.add(parentAccount);
        if (parentAccount.childAccountIds.isNotEmpty) {
          final childAccounts = await DataFetchService.getChildAccounts(
            branch.id!,
            parentAccount.childAccountIds,
          );
          allAssetAccounts.addAll(childAccounts);
        }
      }

      setState(() {
        _revenueAccounts = allRevenueAccounts;
        _costOfSalesAccounts = allCostAccounts;
        _assetAccounts = allAssetAccounts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading chart accounts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;
    final isTablet = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: isDesktop
                ? _buildDesktopLayout()
                : isTablet
                ? _buildTabletLayout()
                : _buildMobileLayout(),
          ),
        ],
      ),
    );
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  void editProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddEditProduct(
            isEdit: true,
            productModel: widget.product,
            onBack: () {
              //Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        children: [
          // Breadcrumb
          //Icon(Icons.arrow_back),
          IconButton(
            onPressed: cancel,
            icon: Icon(Icons.arrow_back, size: 20, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              const SizedBox(width: 8),
              Text(
                'Products',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text(
                widget.product.productName ?? 'Product Details',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Action Buttons
          Row(
            children: [
              _buildHeaderButton(
                'Edit Product',
                Icons.edit_outlined,
                onPressed: editProduct,
                isPrimary: false,
              ),
              const SizedBox(width: 12),
              _buildHeaderButton(
                'Clone Product',
                Icons.content_copy_outlined,
                onPressed: _cloneProduct,
                isPrimary: true,
              ),
              // const SizedBox(width: 12),
              // _buildHeaderButton(
              //   'Export Data',
              //   Icons.download_outlined,
              //   onPressed: () {},
              //   isPrimary: true,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(
    String label,
    IconData icon, {
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF0F172A) : Colors.white,
        foregroundColor: isPrimary ? Colors.white : const Color(0xFF475569),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        side: isPrimary ? null : const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Product Overview
          SizedBox(
            width: 400,
            child: Column(
              children: [
                _buildProductOverviewCard(),
                const SizedBox(height: 24),
                //_buildQuickActionsCard(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right Column - Details and Stats
          Expanded(
            child: Column(
              children: [
                _buildMetricsRow(),
                const SizedBox(height: 24),
                Expanded(child: _buildDataTabs()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildProductOverviewCard()),
              const SizedBox(width: 20),
              //  Expanded(child: _buildQuickActionsCard()),
            ],
          ),
          const SizedBox(height: 20),
          _buildMetricsRow(),
          const SizedBox(height: 20),
          Expanded(child: _buildDataTabs()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProductOverviewCard(),
          const SizedBox(height: 16),
          _buildMetricsRow(),
          const SizedBox(height: 16),
          //  _buildQuickActionsCard(),
          const SizedBox(height: 16),
          Expanded(child: _buildDataTabs()),
        ],
      ),
    );
  }

  Widget _buildAccountDropdown({
    required String label,
    required List<ChartAccount> accounts,
    required ChartAccount? selectedAccount,
    required Function(ChartAccount?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<ChartAccount>(
            value: selectedAccount,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(6),
            dropdownColor: Colors.white,
            hint: const Text('Select Account'),
            items: [
              const DropdownMenuItem<ChartAccount>(
                value: null,
                child: Text('Select Account'),
              ),
              ...accounts.map((account) {
                return DropdownMenuItem<ChartAccount>(
                  value: account,
                  child: Text(
                    '${account.accountCode} - ${account.accountName}',
                    style: TextStyle(
                      color: account.level > 0 ? Colors.blue : Colors.black,
                      fontWeight: account.level > 0
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProductOverviewCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child:
                        widget.product.image != null &&
                            widget.product.image!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.product.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    color: Colors.grey.shade400,
                                    size: 32,
                                  ),
                            ),
                          )
                        : Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.grey.shade400,
                            size: 32,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.productName ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildStatusBadge(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // _buildProductDetails(),
            ],
          ),
        ),
        //Text("testing"),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chart of Accounts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    // Revenue Account Dropdown
                    _buildAccountDropdown(
                      label: 'Revenue Account (4000)',
                      accounts: _revenueAccounts,
                      selectedAccount: _selectedRevenueAccount,
                      onChanged: (value) {
                        setState(() {
                          _selectedRevenueAccount = value;
                        });
                      },
                    ),

                    // Cost of Sales Account Dropdown
                    _buildAccountDropdown(
                      label: 'Cost of Sales Account (5100)',
                      accounts: _costOfSalesAccounts,
                      selectedAccount: _selectedCostOfSalesAccount,
                      onChanged: (value) {
                        setState(() {
                          _selectedCostOfSalesAccount = value;
                        });
                      },
                    ),

                    // Asset Account Dropdown
                    _buildAccountDropdown(
                      label: 'Asset Account (1000)',
                      accounts: _assetAccounts,
                      selectedAccount: _selectedAssetAccount,
                      onChanged: (value) {
                        setState(() {
                          _selectedAssetAccount = value;
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final status = widget.product.status ?? 'unknown';
    final config = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config['backgroundColor'],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: config['textColor'],
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Map<String, Color> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return {
          'backgroundColor': const Color(0xFFDCFCE7),
          'textColor': const Color(0xFF166534),
        };
      case 'pending':
        return {
          'backgroundColor': const Color(0xFFFEF3C7),
          'textColor': const Color(0xFF92400E),
        };
      case 'inactive':
        return {
          'backgroundColor': const Color(0xFFFEE2E2),
          'textColor': const Color(0xFF991B1B),
        };
      default:
        return {
          'backgroundColor': const Color(0xFFF1F5F9),
          'textColor': const Color(0xFF475569),
        };
    }
  }

  Widget _buildProductDetails() {
    final details = [
      {'label': 'SKU', 'value': widget.product.code ?? 'N/A'},
      {'label': 'Category', 'value': widget.category ?? 'N/A'},
      {'label': 'Sub Category', 'value': widget.subCategory ?? 'N/A'},
      {'label': 'Brand', 'value': widget.brand ?? 'N/A'},
      {'label': 'Min Stock', 'value': '${widget.product.threshold ?? 0}'},
      {
        'label': 'Mini Price',
        'value': '${"OMR"} ${widget.product.minimumPrice ?? 0}',
      },
      {'label': 'Created By', 'value': widget.product.createdBy ?? 'N/A'},
    ];

    return Column(
      children: details
          .map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      detail['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      detail['value']!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMetricsRow() {
    final metrics = [
      {
        'title': 'Current Stock Value',
        'value': 'OMR ${_formatCurrency(widget.product.fifoValue ?? 0)}',
        //'change': '+12.5%',
        'isPositive': true,
        'icon': Icons.inventory_outlined,
      },
      {
        'title': 'Average Unit Cost',
        'value': 'OMR ${_formatCurrency(widget.product.averageCost ?? 0)}',
        //'change': '+2.3%',
        'isPositive': true,
        'icon': Icons.trending_up_outlined,
      },
      // {
      //   'title': 'FIFO Value',
      //   'value': 'OMR ${_formatCurrency(widget.product.fifoValue ?? 0)}',
      //   //'change': '-1.2%',
      //   'isPositive': false,
      //   'icon': Icons.layers_outlined,
      // },
      {
        'title': 'Last Purchase Cost',
        'value': 'OMR ${_formatCurrency(widget.product.lastCost ?? 0)}',
        //'change': '+5.1%',
        'isPositive': true,
        'icon': Icons.receipt_outlined,
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: metrics.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) => _buildMetricCard(metrics[index]),
      ),
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> metric) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric['icon'], size: 20, color: const Color(0xFF64748B)),
              const Spacer(),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              //   decoration: BoxDecoration(
              //     color: metric['isPositive']
              //         ? const Color(0xFFDCFCE7)
              //         : const Color(0xFFFEE2E2),
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   child: Text(
              //     metric['change'],
              //     style: TextStyle(
              //       fontSize: 11,
              //       fontWeight: FontWeight.w600,
              //       color: metric['isPositive']
              //           ? const Color(0xFF166534)
              //           : const Color(0xFF991B1B),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            metric['title'],
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric['value'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildQuickActionsCard() {
  //   final actions = [
  //     {
  //       'title': 'Adjust Stock',
  //       'icon': Icons.tune,
  //       'color': const Color(0xFF3B82F6)
  //     },
  //     {
  //       'title': 'Add Batch',
  //       'icon': Icons.add_box_outlined,
  //       'color': const Color(0xFF10B981)
  //     },
  //     {
  //       'title': 'Update Price',
  //       'icon': Icons.attach_money,
  //       'color': const Color(0xFF8B5CF6)
  //     },
  //     {
  //       'title': 'View Reports',
  //       'icon': Icons.analytics_outlined,
  //       'color': const Color(0xFF06B6D4)
  //     },
  //   ];

  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: const Color(0xFFE2E8F0)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Quick Actions',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF0F172A),
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         ...actions.map((action) => Padding(
  //               padding: const EdgeInsets.only(bottom: 12),
  //               child: InkWell(
  //                 onTap: () {},
  //                 borderRadius: BorderRadius.circular(6),
  //                 child: Container(
  //                   padding: const EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(6),
  //                     border: Border.all(color: const Color(0xFFE2E8F0)),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.all(6),
  //                         decoration: BoxDecoration(
  //                           color: (action['color'] as Color).withOpacity(0.1),
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         child: Icon(
  //                           action['icon'] as IconData,
  //                           size: 16,
  //                           color: action['color'] as Color,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Text(
  //                         action['title'] as String,
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w500,
  //                           color: Color(0xFF374151),
  //                         ),
  //                       ),
  //                       const Spacer(),
  //                       const Icon(
  //                         Icons.arrow_forward_ios,
  //                         size: 12,
  //                         color: Color(0xFF9CA3AF),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             )),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDataTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Tab Header
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF0F172A),
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorColor: const Color(0xFF3B82F6),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Inventory Logs'),
                Tab(text: 'Stock Batches'),
                // Tab(text: 'Batch History'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                //_buildInventoryLogsTab(),
                ProductInventoryLogs(product: widget.product),
                ProductInventoryBatches(product: widget.product),
                //_buildStockBatchesTab(),
                // _buildBatchHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryLogsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTableHeader(['Date', 'Action', 'Quantity', 'User', 'Notes']),
        ...List.generate(
          10,
          (index) => _buildTableRow([
            '2024-01-${15 - index}',
            index % 3 == 0
                ? 'Stock In'
                : index % 3 == 1
                ? 'Stock Out'
                : 'Adjustment',
            '${(index + 1) * 25}',
            'John Doe',
            'Regular inventory movement',
          ], index),
        ),
      ],
    );
  }

  Widget _buildStockBatchesTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTableHeader([
          'Batch ID',
          'Quantity',
          'Unit Cost',
          'Total Value',
          'Created',
        ]),
        ...List.generate(
          8,
          (index) => _buildTableRow([
            'BTH-2024-${(index + 1).toString().padLeft(3, '0')}',
            '${(index + 1) * 50}',
            '\$${(15.0 + index * 0.5).toStringAsFixed(2)}',
            '\$${((index + 1) * 50 * (15.0 + index * 0.5)).toStringAsFixed(2)}',
            '2024-01-${15 - index}',
          ], index),
        ),
      ],
    );
  }

  Widget _buildBatchHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTableHeader(['Date', 'Batch ID', 'Action', 'Quantity', 'Notes']),
        ...List.generate(
          12,
          (index) => _buildTableRow([
            '2024-01-${15 - index}',
            'BTH-2024-${((index % 3) + 1).toString().padLeft(3, '0')}',
            index % 4 == 0
                ? 'Created'
                : index % 4 == 1
                ? 'Updated'
                : index % 4 == 2
                ? 'Sold'
                : 'Expired',
            '${(index + 1) * 15}',
            'Batch operation completed',
          ], index),
        ),
      ],
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: headers
            .map(
              (header) => Expanded(
                child: Text(
                  header,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTableRow(List<String> cells, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.5),
        ),
      ),
      child: Row(
        children: cells
            .map(
              (cell) => Expanded(
                child: Text(
                  cell,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }

  void _editProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: widget.product),
      ),
    );
  }

  void _cloneProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          'Clone Product',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text('Create a duplicate of "${widget.product.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product cloned successfully'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('Clone', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class EditProductPage extends StatelessWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: const Center(child: Text('Professional Edit Form Implementation')),
    );
  }
}
