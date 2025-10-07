// // ignore_for_file: deprecated_member_use

// import 'package:app/modern_motors/inventory/direct_inventory_add_screen.dart';
// import 'package:app/modern_motors/models/admin/brand_model.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/models/product/product_sub_catorymodel.dart';
// import 'package:app/modern_motors/models/product_category_model.dart';
// import 'package:app/modern_motors/products/add_edit_product.dart';
// import 'package:app/modern_motors/products/product_inventory_batches.dart';
// import 'package:app/modern_motors/products/product_inventory_logs.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';

// // class ProductCard extends StatelessWidget {
// //   final ProductModel product;
// //   final BrandModel brand;
// //   final ProductCategoryModel category;
// //   final ProductSubCategoryModel subCategory;
// //   final bool isSelected;
// //   final VoidCallback? onTap;
// //   final VoidCallback? onEdit;
// //   final VoidCallback? onView;
// //   final Function(bool?)? onSelectChanged;

// //   const ProductCard({
// //     Key? key,
// //     required this.product,
// //     required this.brand,
// //     required this.category,
// //     required this.subCategory,
// //     this.isSelected = false,
// //     this.onTap,
// //     this.onEdit,
// //     this.onView,
// //     this.onSelectChanged,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: isSelected
// //               ? Theme.of(context).primaryColor
// //               : Colors.grey.shade200,
// //           width: isSelected ? 2 : 1,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.08),
// //             spreadRadius: 0,
// //             blurRadius: 12,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: BorderRadius.circular(16),
// //         child: Padding(
// //           padding: const EdgeInsets.all(20),
// //           child: Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Checkbox
// //               if (onSelectChanged != null)
// //                 Container(
// //                   margin: const EdgeInsets.only(right: 16, top: 4),
// //                   child: Checkbox(
// //                     value: isSelected,
// //                     onChanged: onSelectChanged,
// //                     activeColor: Theme.of(context).primaryColor,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(4),
// //                     ),
// //                   ),
// //                 ),

// //               // Product Image
// //               Container(
// //                 width: 80,
// //                 height: 80,
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(12),
// //                   color: Colors.grey.shade100,
// //                   border: Border.all(color: Colors.grey.shade200),
// //                 ),
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(12),
// //                   child: product.image != null && product.image!.isNotEmpty
// //                       ? Image.network(
// //                           product.image!,
// //                           fit: BoxFit.cover,
// //                           errorBuilder: (context, error, stackTrace) =>
// //                               _buildPlaceholderImage(),
// //                         )
// //                       : _buildPlaceholderImage(),
// //                 ),
// //               ),

// //               const SizedBox(width: 20),

// //               // Main Content
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Product Code Badge
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         gradient: LinearGradient(
// //                           colors: [
// //                             Theme.of(context).primaryColor,
// //                             Theme.of(context).primaryColor.withOpacity(0.8),
// //                           ],
// //                         ),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Text(
// //                         'PROD-${product.code}',
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w600,
// //                           letterSpacing: 0.5,
// //                         ),
// //                       ),
// //                     ),

// //                     const SizedBox(height: 12),

// //                     // Product Name
// //                     Text(
// //                       product.productName ?? 'N/A',
// //                       style: const TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.w700,
// //                         color: Color(0xFF2D3748),
// //                         height: 1.2,
// //                       ),
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),

// //                     const SizedBox(height: 8),

// //                     // Brand and Category Row
// //                     Row(
// //                       children: [
// //                         _buildInfoChip(
// //                           icon: Icons.branding_watermark,
// //                           label: brand.name ?? 'N/A',
// //                           color: Colors.blue,
// //                         ),
// //                         const SizedBox(width: 8),
// //                         _buildInfoChip(
// //                           icon: Icons.category,
// //                           label: category.productName ?? 'N/A',
// //                           color: Colors.green,
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 12),

// //                     // Details Grid
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: _buildDetailItem(
// //                             'Sub Category'.tr(),
// //                             subCategory.name ?? 'N/A',
// //                             Icons.subdirectory_arrow_right,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: _buildDetailItem(
// //                             'Threshold'.tr(),
// //                             product.threshold?.toString() ?? '0',
// //                             Icons.warning_amber,
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 8),

// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: _buildDetailItem(
// //                             'Stock in Hand'.tr(),
// //                             product.totalStockOnHand?.toString() ?? '0',
// //                             Icons.inventory_2,
// //                             valueColor: _getStockColor(),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: _buildDetailItem(
// //                             'Avg Cost'.tr(),
// //                             '\$${product.averageCost?.toStringAsFixed(2) ?? '0.00'}',
// //                             Icons.attach_money,
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 12),

// //                     // Dates Row
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: _buildDateInfo(
// //                             'Created'.tr(),
// //                             product.createAt?.toDate() ?? DateTime.now(),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: _buildDateInfo(
// //                             'Last Updated'.tr(),
// //                             product.lastUpdated?.toDate() ?? DateTime.now(),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 16),

// //                     // Status Badge
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: _getStatusColor().withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(12),
// //                         border: Border.all(
// //                           color: _getStatusColor().withOpacity(0.3),
// //                         ),
// //                       ),
// //                       child: Text(
// //                         (product.status ?? 'active').toUpperCase(),
// //                         style: TextStyle(
// //                           color: _getStatusColor(),
// //                           fontSize: 11,
// //                           fontWeight: FontWeight.w600,
// //                           letterSpacing: 0.5,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Action Buttons
// //               Column(
// //                 children: [
// //                   _buildActionButton(
// //                     icon: Icons.visibility,
// //                     onPressed: onView,
// //                     color: Colors.blue,
// //                     tooltip: 'View Details',
// //                   ),
// //                   const SizedBox(height: 8),
// //                   _buildActionButton(
// //                     icon: Icons.edit,
// //                     onPressed: onEdit,
// //                     color: Colors.orange,
// //                     tooltip: 'Edit Product',
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPlaceholderImage() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade100,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Icon(
// //         Icons.image,
// //         color: Colors.grey.shade400,
// //         size: 32,
// //       ),
// //     );
// //   }

// //   Widget _buildInfoChip({
// //     required IconData icon,
// //     required String label,
// //     required Color color,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(
// //             icon,
// //             size: 12,
// //             color: color,
// //           ),
// //           const SizedBox(width: 4),
// //           Text(
// //             label,
// //             style: TextStyle(
// //               color: color,
// //               fontSize: 11,
// //               fontWeight: FontWeight.w500,
// //             ),
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDetailItem(
// //     String label,
// //     String value,
// //     IconData icon, {
// //     Color? valueColor,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Icon(
// //               icon,
// //               size: 14,
// //               color: Colors.grey.shade600,
// //             ),
// //             const SizedBox(width: 4),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 fontSize: 11,
// //                 color: Colors.grey.shade600,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 2),
// //         Text(
// //           value,
// //           style: TextStyle(
// //             fontSize: 13,
// //             fontWeight: FontWeight.w600,
// //             color: valueColor ?? const Color(0xFF2D3748),
// //           ),
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDateInfo(String label, DateTime date) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 11,
// //             color: Colors.grey.shade600,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //         const SizedBox(height: 2),
// //         Text(
// //           DateFormat('MMM dd, yyyy').format(date),
// //           style: const TextStyle(
// //             fontSize: 12,
// //             fontWeight: FontWeight.w600,
// //             color: Color(0xFF2D3748),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildActionButton({
// //     required IconData icon,
// //     required VoidCallback? onPressed,
// //     required Color color,
// //     required String tooltip,
// //   }) {
// //     return Tooltip(
// //       message: tooltip,
// //       child: Container(
// //         width: 36,
// //         height: 36,
// //         decoration: BoxDecoration(
// //           color: color.withOpacity(0.1),
// //           borderRadius: BorderRadius.circular(8),
// //           border: Border.all(
// //             color: color.withOpacity(0.2),
// //           ),
// //         ),
// //         child: IconButton(
// //           icon: Icon(icon, size: 16),
// //           onPressed: onPressed,
// //           color: color,
// //           padding: EdgeInsets.zero,
// //         ),
// //       ),
// //     );
// //   }

// //   Color _getStockColor() {
// //     final stock = product.totalStockOnHand ?? 0;
// //     final threshold = product.threshold ?? 0;

// //     if (stock <= threshold) {
// //       return Colors.red;
// //     } else if (stock <= threshold * 1.5) {
// //       return Colors.orange;
// //     } else {
// //       return Colors.green;
// //     }
// //   }

// //   Color _getStatusColor() {
// //     switch (product.status?.toLowerCase()) {
// //       case 'active':
// //         return Colors.green;
// //       case 'inactive':
// //         return Colors.red;
// //       case 'pending':
// //         return Colors.orange;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// // }

// // // Usage in your ManageProducts widget:
// // class ProductListView extends StatelessWidget {
// //   final List<ProductModel> products;
// //   final List<BrandModel> brands;
// //   final List<ProductCategoryModel> categories;
// //   final List<ProductSubCategoryModel> subCategories;
// //   final Set<String> selectedIds;
// //   final Function(ProductModel) onView;
// //   final Function(ProductModel) onEdit;
// //   final Function(bool?, ProductModel) onSelectChanged;

// //   const ProductListView({
// //     Key? key,
// //     required this.products,
// //     required this.brands,
// //     required this.categories,
// //     required this.subCategories,
// //     required this.selectedIds,
// //     required this.onView,
// //     required this.onEdit,
// //     required this.onSelectChanged,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       padding: const EdgeInsets.all(16),
// //       itemCount: products.length,
// //       itemBuilder: (context, index) {
// //         final product = products[index];
// //         final brand = brands.firstWhere(
// //           (b) => b.id == product.brandId,
// //           orElse: () => BrandModel(name: 'Unknown Brand'),
// //         );
// //         final category = categories.firstWhere(
// //           (c) => c.id == product.categoryId,
// //           orElse: () => ProductCategoryModel(productName: 'Unknown Category'),
// //         );
// //         final subCategory = subCategories.firstWhere(
// //           (s) => s.id == product.subCategoryId,
// //           orElse: () => ProductSubCategoryModel(name: 'Unknown Sub Category'),
// //         );

// //         return ProductCard(
// //           product: product,
// //           brand: brand,
// //           category: category,
// //           subCategory: subCategory,
// //           isSelected: selectedIds.contains(product.id),
// //           onView: () => onView(product),
// //           onEdit: () => onEdit(product),
// //           onSelectChanged: (value) => onSelectChanged(value, product),
// //         );
// //       },
// //     );
// //   }
// // }

// //  // DynamicDataTable<ProductModel>(
// //                     //     onView: (product) {
// //                     //       // Navigator.of(context).push(
// //                     //       //   MaterialPageRoute(
// //                     //       //     builder: (context) =>
// //                     //       //         ProductInventoryLogs(product: product),
// //                     //       //   ),
// //                     //       // );
// //                     //       _showViewOptions(context, product);
// //                     //     },
// //                     //     data: pagedItems,
// //                     //     isWithImage: true,
// //                     //     combineImageWithTextIndex: 1,
// //                     //     columns: headers,
// //                     //     valueGetters: [
// //                     //       (v) => "${"PROD"}-${v.code.toString()}",
// //                     //       (v) => '${v.productName} , ${v.image}',
// //                     //       (v) => brands
// //                     //           .firstWhere(
// //                     //             (brand) => brand.id == v.brandId,
// //                     //           )
// //                     //           .name,
// //                     //       (v) => productsCategories
// //                     //           .firstWhere((cat) => cat.id == v.categoryId)
// //                     //           .productName,
// //                     //       (v) => subCategories
// //                     //           .firstWhere(
// //                     //             (cat) => cat.id == v.subCategoryId,
// //                     //           )
// //                     //           .name,
// //                     //       (v) => v.threshold.toString(),
// //                     //       (v) => v.totalStockOnHand.toString(),
// //                     //       (v) => v.averageCost.toString(),
// //                     //       (v) => v.createAt!
// //                     //           .toDate()
// //                     //           .formattedWithDayMonthYear,
// //                     //       (v) => v.lastUpdated!
// //                     //           .toDate()
// //                     //           .formattedWithDayMonthYear,
// //                     //     ],
// //                     //     getId: (v) => v.id,
// //                     //     selectedIds:
// //                     //         selectedInventories.getSelectedInventoryIds,
// //                     //     onSelectChanged: (value, inventory) {
// //                     //       if (value == true) {
// //                     //         // selectedInventories.addInventory(inventory);
// //                     //       } else {
// //                     //         // selectedInventories.removeInventory(inventory);

// //                     //         debugPrint(
// //                     //           'selectedInventory: ${selectedInventories.getSelectedInventory.length}',
// //                     //         );
// //                     //         debugPrint(
// //                     //           'selectedInventoryIds: ${selectedInventories.getSelectedInventoryIds.length}',
// //                     //         );
// //                     //       }
// //                     //       setState(() {
// //                     //         // if (value == true) {
// //                     //         //   selectedInventories.setInventory(inventory);
// //                     //         //   // selectedInventory.add(inventory);
// //                     //         //   // selectedInventoryIds.add(inventory.id!);
// //                     //         //   // debugPrint(
// //                     //         //   //   'selectedInventory: ${selectedInventory.length}',
// //                     //         //   // );
// //                     //         // }
// //                     //         // else {
// //                     //         //   selectedInventoryIds.remove(inventory.id);
// //                     //         //
// //                     //         //   selectedInventory.removeWhere(
// //                     //         //         (item) => item.id == inventory.id,
// //                     //         //   );
// //                     //         //
// //                     //         //   debugPrint(
// //                     //         //     'selectedInventory: ${selectedInventory.length}',
// //                     //         //   );
// //                     //         //   debugPrint(
// //                     //         //     'selectedInventoryIds: ${selectedInventoryIds.length}',
// //                     //         //   );
// //                     //         // }
// //                     //       });
// //                     //     },
// //                     //     onEdit: (inventory) {
// //                     //       setState(() {
// //                     //         showInventoryList = false;
// //                     //       });
// //                     //     },
// //                     //     onStatus: (product) {},
// //                     //     statusTextGetter: (item) =>
// //                     //         item.status!.capitalizeFirst,
// //                     //     onSelectAll: (value) {
// //                     //       if (value == true) {
// //                     //         selectedInventories.removeAllInventory();
// //                     //         // selectedInventories.addAllInventory(pagedItems);
// //                     //       } else {
// //                     //         selectedInventories.removeAllInventory();
// //                     //       }
// //                     //       // setState(() {
// //                     //       //   selectedInventory.clear();
// //                     //       //   final currentPageIds =
// //                     //       //   pagedItems.map((e) => e.id!).toList();
// //                     //       //   if (value == true) {
// //                     //       //     selectedInventoryIds.addAll(currentPageIds);
// //                     //       //     selectedInventory.addAll(pagedItems);
// //                     //       //   } else {
// //                     //       //     selectedInventoryIds.removeAll(currentPageIds);
// //                     //       //     selectedInventory.clear();
// //                     //       //   }
// //                     //       // });
// //                     //     },
// //                     //     onSearch: (query) {
// //                     //       setState(() {
// //                     //         displayedProducts = allProducts
// //                     //             .where(
// //                     //               (item) => item.productName!
// //                     //                   .toLowerCase()
// //                     //                   .contains(query.toLowerCase()),
// //                     //             )
// //                     //             .toList();
// //                     //       });
// //                     //     },
// //                     //   ),

// // import 'package:flutter/material.dart';
// // import 'package:easy_localization/easy_localization.dart';

// // class ProductCard extends StatelessWidget {
// //   final ProductModel product;
// //   final BrandModel brand;
// //   final ProductCategoryModel category;
// //   final ProductSubCategoryModel subCategory;
// //   final bool isSelected;
// //   final VoidCallback? onTap;
// //   final VoidCallback? onEdit;
// //   final VoidCallback? onView;
// //   final Function(bool?)? onSelectChanged;

// //   const ProductCard({
// //     Key? key,
// //     required this.product,
// //     required this.brand,
// //     required this.category,
// //     required this.subCategory,
// //     this.isSelected = false,
// //     this.onTap,
// //     this.onEdit,
// //     this.onView,
// //     this.onSelectChanged,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 65, // Fixed compact height
// //       margin: const EdgeInsets.only(bottom: 6),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(
// //           color: isSelected
// //               ? Theme.of(context).primaryColor
// //               : Colors.grey.shade300,
// //           width: isSelected ? 2 : 1,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.05),
// //             spreadRadius: 0,
// //             blurRadius: 4,
// //             offset: const Offset(0, 1),
// //           ),
// //         ],
// //       ),
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: BorderRadius.circular(8),
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //           child: Row(
// //             children: [
// //               // Checkbox
// //               if (onSelectChanged != null) ...[
// //                 SizedBox(
// //                   width: 20,
// //                   height: 20,
// //                   child: Checkbox(
// //                     value: isSelected,
// //                     onChanged: onSelectChanged,
// //                     activeColor: Theme.of(context).primaryColor,
// //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //               ],

// //               // Product Code Badge
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [
// //                       Theme.of(context).primaryColor,
// //                       Theme.of(context).primaryColor.withOpacity(0.8),
// //                     ],
// //                   ),
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Text(
// //                   'PROD-${product.code}',
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(width: 10),

// //               // Product Image
// //               Container(
// //                 width: 40,
// //                 height: 40,
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(6),
// //                   color: Colors.grey.shade100,
// //                 ),
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(6),
// //                   child: product.image != null && product.image!.isNotEmpty
// //                       ? Image.network(
// //                           product.image!,
// //                           fit: BoxFit.cover,
// //                           errorBuilder: (context, error, stackTrace) => Icon(
// //                               Icons.image,
// //                               color: Colors.grey.shade400,
// //                               size: 16),
// //                         )
// //                       : Icon(Icons.image,
// //                           color: Colors.grey.shade400, size: 16),
// //                 ),
// //               ),

// //               const SizedBox(width: 12),

// //               // Product Name & Brand (Flex 2)
// //               Expanded(
// //                 flex: 2,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       product.productName ?? 'N/A',
// //                       style: const TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w600,
// //                         color: Color(0xFF1a202c),
// //                       ),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 4, vertical: 1),
// //                       decoration: BoxDecoration(
// //                         color: Colors.blue.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(3),
// //                       ),
// //                       child: Text(
// //                         brand.name ?? 'Unknown',
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: Colors.blue.shade700,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Category (Flex 1)
// //               Expanded(
// //                 flex: 1,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       category.productName ?? 'N/A',
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         fontWeight: FontWeight.w500,
// //                         color: Colors.grey.shade700,
// //                       ),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Text(
// //                       subCategory.name ?? 'N/A',
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         color: Colors.grey.shade500,
// //                       ),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Stock Info (Flex 1)
// //               Expanded(
// //                 flex: 1,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       'Stock: ${product.totalStockOnHand ?? 0}',
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w600,
// //                         color: _getStockColor(),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Text(
// //                       'Threshold: ${product.threshold ?? 0}',
// //                       style: TextStyle(
// //                         fontSize: 9,
// //                         color: Colors.grey.shade600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Price & Status (Flex 1)
// //               Expanded(
// //                 flex: 1,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       '\$${product.averageCost?.toStringAsFixed(2) ?? '0.00'}',
// //                       style: const TextStyle(
// //                         fontSize: 11,
// //                         fontWeight: FontWeight.w600,
// //                         color: Color(0xFF059669),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 4, vertical: 1),
// //                       decoration: BoxDecoration(
// //                         color: _getStatusColor().withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(3),
// //                       ),
// //                       child: Text(
// //                         (product.status ?? 'active').toUpperCase(),
// //                         style: TextStyle(
// //                           color: _getStatusColor(),
// //                           fontSize: 8,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Dates (Flex 1)
// //               Expanded(
// //                 flex: 1,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       DateFormat('MMM dd')
// //                           .format(product.createAt?.toDate() ?? DateTime.now()),
// //                       style: TextStyle(
// //                         fontSize: 9,
// //                         color: Colors.grey.shade600,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Text(
// //                       'Updated',
// //                       style: TextStyle(
// //                         fontSize: 8,
// //                         color: Colors.grey.shade500,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               const SizedBox(width: 8),

// //               // Action Buttons
// //               Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   _buildActionButton(
// //                     Icons.visibility,
// //                     Colors.blue,
// //                     onView,
// //                     'View',
// //                   ),
// //                   const SizedBox(width: 4),
// //                   _buildActionButton(
// //                     Icons.edit,
// //                     Colors.orange,
// //                     onEdit,
// //                     'Edit',
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildActionButton(
// //       IconData icon, Color color, VoidCallback? onPressed, String tooltip) {
// //     return Tooltip(
// //       message: tooltip,
// //       child: InkWell(
// //         onTap: onPressed,
// //         borderRadius: BorderRadius.circular(4),
// //         child: Container(
// //           width: 24,
// //           height: 24,
// //           decoration: BoxDecoration(
// //             color: color.withOpacity(0.1),
// //             borderRadius: BorderRadius.circular(4),
// //           ),
// //           child: Icon(
// //             icon,
// //             size: 12,
// //             color: color,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Color _getStockColor() {
// //     final stock = product.totalStockOnHand ?? 0;
// //     final threshold = product.threshold ?? 0;

// //     if (stock <= threshold) {
// //       return Colors.red;
// //     } else if (stock <= threshold * 1.5) {
// //       return Colors.orange;
// //     } else {
// //       return Colors.green;
// //     }
// //   }

// //   Color _getStatusColor() {
// //     switch (product.status?.toLowerCase()) {
// //       case 'active':
// //         return Colors.green;
// //       case 'inactive':
// //         return Colors.red;
// //       case 'pending':
// //         return Colors.orange;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// // }

// // // Compact ListView for products
// // class ProductListView extends StatelessWidget {
// //   final List<ProductModel> products;
// //   final List<BrandModel> brands;
// //   final List<ProductCategoryModel> categories;
// //   final List<ProductSubCategoryModel> subCategories;
// //   final Set<String> selectedIds;
// //   final Function(ProductModel) onView;
// //   final Function(ProductModel) onEdit;
// //   final Function(bool?, ProductModel) onSelectChanged;
// //   final Function(String)? onSearch;

// //   const ProductListView({
// //     Key? key,
// //     required this.products,
// //     required this.brands,
// //     required this.categories,
// //     required this.subCategories,
// //     required this.selectedIds,
// //     required this.onView,
// //     required this.onEdit,
// //     required this.onSelectChanged,
// //     this.onSearch,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         // Search Bar
// //         if (onSearch != null)
// //           Container(
// //             height: 40,
// //             margin: const EdgeInsets.all(16),
// //             child: TextField(
// //               onChanged: onSearch,
// //               decoration: InputDecoration(
// //                 hintText: 'Search products...',
// //                 hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
// //                 prefixIcon:
// //                     Icon(Icons.search, size: 20, color: Colors.grey.shade400),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                   borderSide: BorderSide(color: Colors.grey.shade300),
// //                 ),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                   borderSide: BorderSide(color: Colors.grey.shade300),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                   borderSide: BorderSide(color: Theme.of(context).primaryColor),
// //                 ),
// //                 filled: true,
// //                 fillColor: Colors.grey.shade50,
// //                 contentPadding:
// //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //               ),
// //             ),
// //           ),

// //         // Header Row
// //         Container(
// //           height: 35,
// //           margin: const EdgeInsets.symmetric(horizontal: 16),
// //           padding: const EdgeInsets.symmetric(horizontal: 12),
// //           decoration: BoxDecoration(
// //             color: Colors.grey.shade100,
// //             borderRadius: BorderRadius.circular(6),
// //           ),
// //           child: Row(
// //             children: [
// //               if (selectedIds.isNotEmpty) const SizedBox(width: 32),
// //               const SizedBox(width: 80), // Product code space
// //               const SizedBox(width: 52), // Image space
// //               Expanded(
// //                   flex: 2,
// //                   child: Text('Product & Brand', style: _headerStyle())),
// //               Expanded(flex: 1, child: Text('Category', style: _headerStyle())),
// //               Expanded(
// //                   flex: 1,
// //                   child: Text('Stock',
// //                       style: _headerStyle(), textAlign: TextAlign.center)),
// //               Expanded(
// //                   flex: 1,
// //                   child: Text('Price & Status',
// //                       style: _headerStyle(), textAlign: TextAlign.center)),
// //               Expanded(
// //                   flex: 1,
// //                   child: Text('Created',
// //                       style: _headerStyle(), textAlign: TextAlign.center)),
// //               const SizedBox(width: 60), // Actions space
// //             ],
// //           ),
// //         ),

// //         const SizedBox(height: 8),

// //         // Products List
// //         Expanded(
// //           child: ListView.builder(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             itemCount: products.length,
// //             itemBuilder: (context, index) {
// //               final product = products[index];
// //               final brand = brands.firstWhere(
// //                 (b) => b.id == product.brandId,
// //                 orElse: () => BrandModel(name: 'Unknown Brand'),
// //               );
// //               final category = categories.firstWhere(
// //                 (c) => c.id == product.categoryId,
// //                 orElse: () =>
// //                     ProductCategoryModel(productName: 'Unknown Category'),
// //               );
// //               final subCategory = subCategories.firstWhere(
// //                 (s) => s.id == product.subCategoryId,
// //                 orElse: () =>
// //                     ProductSubCategoryModel(name: 'Unknown Sub Category'),
// //               );

// //               return ProductCard(
// //                 product: product,
// //                 brand: brand,
// //                 category: category,
// //                 subCategory: subCategory,
// //                 isSelected: selectedIds.contains(product.id),
// //                 onView: () => onView(product),
// //                 onEdit: () => onEdit(product),
// //                 onSelectChanged: (value) => onSelectChanged(value, product),
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   TextStyle _headerStyle() {
// //     return TextStyle(
// //       fontSize: 14,
// //       fontWeight: FontWeight.w600,
// //       color: Colors.grey.shade700,
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:easy_localization/easy_localization.dart';

// // Enum for dropdown actions
// enum ProductAction {
//   inventoryLogs,
//   inventoryBatch,
//   edit,
//   // duplicate,
//   // archive,
//   addNew,
//   delete
// }

// class ProductCard extends StatelessWidget {
//   final ProductModel product;
//   final BrandModel brand;
//   final ProductCategoryModel category;
//   final ProductSubCategoryModel subCategory;
//   final bool isSelected;
//   final VoidCallback? onTap;
//   final Function(ProductAction)? onActionSelected;
//   final Function(bool?)? onSelectChanged;

//   const ProductCard({
//     super.key,
//     required this.product,
//     required this.brand,
//     required this.category,
//     required this.subCategory,
//     this.isSelected = false,
//     this.onTap,
//     this.onActionSelected,
//     this.onSelectChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 65, // Fixed compact height
//       margin: const EdgeInsets.only(bottom: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isSelected
//               ? Theme.of(context).primaryColor
//               : Colors.grey.shade300,
//           width: isSelected ? 2 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.05),
//             spreadRadius: 0,
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: Row(
//             children: [
//               // Checkbox
//               if (onSelectChanged != null) ...[
//                 SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: Checkbox(
//                     value: isSelected,
//                     onChanged: onSelectChanged,
//                     activeColor: Theme.of(context).primaryColor,
//                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//               ],

//               // Product Code Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Theme.of(context).primaryColor,
//                       Theme.of(context).primaryColor.withOpacity(0.8),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   'PROD-${product.code}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 20),

//               // Product Image
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: product.image != null && product.image!.isNotEmpty
//                       ? Image.network(
//                           product.image!,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) => Icon(
//                               Icons.image,
//                               color: Colors.grey.shade400,
//                               size: 16),
//                         )
//                       : Icon(Icons.image,
//                           color: Colors.grey.shade400, size: 16),
//                 ),
//               ),

//               const SizedBox(width: 12),

//               // Product Name & Brand (Flex 2)
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       product.productName ?? 'N/A',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1a202c),
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 2),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 4, vertical: 1),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(3),
//                       ),
//                       child: Text(
//                         brand.name,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.blue.shade700,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Category (Flex 1)
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       category.productName,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey.shade700,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       "${"Sub Cat"}: ${subCategory.name}",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade500,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),

//               // Stock Info (Flex 1)
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Stock: ${product.totalStockOnHand ?? 0}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: _getStockColor(),
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Threshold: ${product.threshold ?? 0}',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Price & Status (Flex 1)
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '\$${product.averageCost?.toStringAsFixed(2) ?? '0.00'}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF059669),
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 4, vertical: 1),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor().withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(3),
//                       ),
//                       child: Text(
//                         (product.status ?? 'active').toUpperCase(),
//                         style: TextStyle(
//                           color: _getStatusColor(),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '\$${product.fifoValue?.toStringAsFixed(2) ?? '0.00'}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF059669),
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 4, vertical: 1),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor().withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(3),
//                       ),
//                       child: Text(
//                         "FIFO",
//                         style: TextStyle(
//                           color: _getStatusColor(),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Dates (Flex 1)
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       DateFormat('MMM dd')
//                           .format(product.createAt?.toDate() ?? DateTime.now()),
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Updated',
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                     // if (product.categoryId != null)
//                     // Text(
//                     // product.categoryId == "",
//                     //   style: TextStyle(
//                     //     fontSize: 14,
//                     //     color: Colors.grey.shade600,
//                     //     fontWeight: FontWeight.w500,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),

//               // Action Dropdown Menu
//               PopupMenuButton<ProductAction>(
//                 onSelected: (ProductAction action) {
//                   if (onActionSelected != null) {
//                     onActionSelected!(action);
//                   }
//                 },
//                 icon: Icon(
//                   Icons.more_vert,
//                   size: 18,
//                   color: Colors.grey.shade600,
//                 ),
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(minWidth: 0),
//                 itemBuilder: (BuildContext context) => [
//                   PopupMenuItem<ProductAction>(
//                     value: ProductAction.inventoryLogs,
//                     child: Row(
//                       children: [
//                         Icon(Icons.visibility, size: 18, color: Colors.blue),
//                         const SizedBox(width: 8),
//                         Text('Inventory Logs'),
//                       ],
//                     ),
//                   ),
//                   PopupMenuItem<ProductAction>(
//                     value: ProductAction.inventoryBatch,
//                     child: Row(
//                       children: [
//                         Icon(Icons.batch_prediction_sharp,
//                             size: 18, color: Colors.orange),
//                         const SizedBox(width: 8),
//                         Text('Inventory Batch'),
//                       ],
//                     ),
//                   ),
//                   PopupMenuItem<ProductAction>(
//                     value: ProductAction.edit,
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit, size: 18, color: Colors.green),
//                         const SizedBox(width: 8),
//                         Text('Edit'),
//                       ],
//                     ),
//                   ),
//                   PopupMenuItem<ProductAction>(
//                     value: ProductAction.addNew,
//                     child: Row(
//                       children: [
//                         Icon(Icons.add, size: 18, color: Colors.blue),
//                         const SizedBox(width: 8),
//                         Text('Add Manual Inventory'),
//                       ],
//                     ),
//                   ),
//                   // PopupMenuItem<ProductAction>(
//                   //   value: ProductAction.duplicate,
//                   //   child: Row(
//                   //     children: [
//                   //       Icon(Icons.content_copy, size: 16, color: Colors.green),
//                   //       const SizedBox(width: 8),
//                   //       Text('Duplicate'),
//                   //     ],
//                   //   ),
//                   // ),
//                   // PopupMenuItem<ProductAction>(
//                   //   value: ProductAction.archive,
//                   //   child: Row(
//                   //     children: [
//                   //       Icon(Icons.archive, size: 16, color: Colors.purple),
//                   //       const SizedBox(width: 8),
//                   //       Text('Archive'),
//                   //     ],
//                   //   ),
//                   // ),
//                   const PopupMenuDivider(),
//                   PopupMenuItem<ProductAction>(
//                     value: ProductAction.delete,
//                     child: Row(
//                       children: [
//                         Icon(Icons.delete, size: 16, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Text('Delete', style: TextStyle(color: Colors.red)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getStockColor() {
//     final stock = product.totalStockOnHand ?? 0;
//     final threshold = product.threshold ?? 0;

//     if (stock <= threshold) {
//       return Colors.red;
//     } else if (stock <= threshold * 1.5) {
//       return Colors.orange;
//     } else {
//       return Colors.green;
//     }
//   }

//   Color _getStatusColor() {
//     switch (product.status?.toLowerCase()) {
//       case 'active':
//         return Colors.green;
//       case 'inactive':
//         return Colors.red;
//       case 'pending':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// // Enhanced ProductListView with search functionality
// class ProductListView extends StatefulWidget {
//   final List<ProductModel> products;
//   final List<BrandModel> brands;
//   final List<ProductCategoryModel> categories;
//   final List<ProductSubCategoryModel> subCategories;
//   final Set<String> selectedIds;
// //  final Function(ProductModel, ProductAction) onActionSelected;
//   final Function(bool?, ProductModel) onSelectChanged;
//   final bool enableSearch;

//   const ProductListView({
//     super.key,
//     required this.products,
//     required this.brands,
//     required this.categories,
//     required this.subCategories,
//     required this.selectedIds,
//     // required this.onActionSelected,
//     required this.onSelectChanged,
//     this.enableSearch = true,
//   });

//   @override
//   State<ProductListView> createState() => _ProductListViewState();
// }

// class _ProductListViewState extends State<ProductListView> {
//   final TextEditingController _searchController = TextEditingController();
//   List<ProductModel> _filteredProducts = [];
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _filteredProducts = widget.products;
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     setState(() {
//       _searchQuery = _searchController.text;
//       _filterProducts();
//     });
//   }

//   void _filterProducts() {
//     if (_searchQuery.isEmpty) {
//       _filteredProducts = widget.products;
//     } else {
//       _filteredProducts = widget.products.where((product) {
//         final searchLower = _searchQuery.toLowerCase();

//         // Get brand name
//         final brand = widget.brands.firstWhere(
//           (b) => b.id == product.brandId,
//           orElse: () => BrandModel(name: ''),
//         );

//         // Get category name
//         final category = widget.categories.firstWhere(
//           (c) => c.id == product.categoryId,
//           orElse: () => ProductCategoryModel(productName: ''),
//         );

//         // Get subcategory name
//         final subCategory = widget.subCategories.firstWhere(
//           (s) => s.id == product.subCategoryId,
//           orElse: () => ProductSubCategoryModel(name: ''),
//         );

//         return (product.productName?.toLowerCase().contains(searchLower) ??
//                 false) ||
//             (product.code?.toLowerCase().contains(searchLower) ?? false) ||
//             (brand.name.toLowerCase().contains(searchLower)) ||
//             (category.productName.toLowerCase().contains(searchLower)) ||
//             (subCategory.name.toLowerCase().contains(searchLower)) ||
//             (product.status?.toLowerCase().contains(searchLower) ?? false);
//       }).toList();
//     }
//   }

//   @override
//   void didUpdateWidget(ProductListView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.products != widget.products) {
//       _filterProducts();
//     }
//   }

//   void _handleActionSelected(ProductModel product, ProductAction action) {
//     switch (action) {
//       case ProductAction.inventoryLogs:
//         // Navigator.pop(context);
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ProductInventoryLogs(product: product),
//           ),
//         );
//         debugPrint('Inventory Logs: ${product.productName}');
//         break;
//       case ProductAction.inventoryBatch:
//         // Navigator.pop(context);
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ProductInventoryBatches(product: product),
//           ),
//         );
//         debugPrint('Inventory Batches: ${product.productName}');
//         break;
//       case ProductAction.edit:
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//           return AddEditProduct(
//             isEdit: true,
//             productModel: product,
//             onBack: () {
//               //Navigator.of(context).pop();
//             },
//           );
//         }));
//         debugPrint('Edit product: ${product.productName}');
//         break;
//       case ProductAction.addNew:
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DirectInventoryAddScreen(product: product),
//             ));
//         debugPrint('Edit product: ${product.productName}');
//         break;

//       //ListTile(
//       //             leading: Icon(Icons.add),
//       //             title: Text('Add/Remove Stock'),
//       //             onTap: () {
//       //               Navigator.pop(context);
//       //               Navigator.push(
//       //                   context,
//       //                   MaterialPageRoute(
//       //                     builder: (context) =>
//       //                         DirectInventoryAddScreen(product: product),
//       //                   ));
//       //             },
//       //           ),

//       //case ProductAction.duplicate:
//       // Handle duplicate action
//       // debugPrint('Duplicate product: ${product.productName}');
//       // break;
//       // case ProductAction.archive:
//       //   // Handle archive action
//       //   debugPrint('Archive product: ${product.productName}');
//       //   break;
//       case ProductAction.delete:
//         // Handle delete action with confirmation
//         _showDeleteConfirmation(product);
//         break;
//     }
//   }

//   void _showDeleteConfirmation(ProductModel product) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Product'),
//         content:
//             Text('Are you sure you want to delete "${product.productName}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Perform delete action
//               print('Deleted product: ${product.productName}');
//             },
//             child: Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Search Bar
//         if (widget.enableSearch)
//           Container(
//             height: 50,
//             margin: const EdgeInsets.all(16),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText:
//                     'Search by product name, code, brand, category, or status...',
//                 hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//                 prefixIcon:
//                     Icon(Icons.search, size: 20, color: Colors.grey.shade400),
//                 suffixIcon: _searchQuery.isNotEmpty
//                     ? IconButton(
//                         icon: Icon(Icons.clear,
//                             size: 20, color: Colors.grey.shade400),
//                         onPressed: () {
//                           _searchController.clear();
//                         },
//                       )
//                     : null,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Theme.of(context).primaryColor),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               ),
//             ),
//           ),

//         // Results count
//         if (widget.enableSearch && _searchQuery.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Row(
//               children: [
//                 Text(
//                   'Found ${_filteredProducts.length} product${_filteredProducts.length != 1 ? 's' : ''}',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 if (_searchQuery.isNotEmpty) ...[
//                   Text(
//                     ' for "$_searchQuery"',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),

//         // Header Row
//         Container(
//           height: 35,
//           margin: const EdgeInsets.symmetric(horizontal: 16),
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Row(
//             children: [
//               if (widget.selectedIds.isNotEmpty) const SizedBox(width: 32),
//               const SizedBox(width: 100), // Product code space
//               const SizedBox(width: 52), // Image space
//               Expanded(
//                   flex: 1,
//                   child: Text('Product & Brand', style: _headerStyle())),
//               Expanded(flex: 1, child: Text('Category', style: _headerStyle())),
//               Expanded(
//                   flex: 1,
//                   child: Text('Stock',
//                       style: _headerStyle(), textAlign: TextAlign.center)),
//               Expanded(
//                   flex: 1,
//                   child: Text('Price & Status',
//                       style: _headerStyle(), textAlign: TextAlign.center)),
//               Expanded(
//                   flex: 1,
//                   child: Text('Valuation',
//                       style: _headerStyle(), textAlign: TextAlign.center)),
//               Expanded(
//                   flex: 1,
//                   child: Text('Created',
//                       style: _headerStyle(), textAlign: TextAlign.center)),
//               const SizedBox(width: 30), // Actions space
//             ],
//           ),
//         ),

//         const SizedBox(height: 8),

//         // Products List
//         Expanded(
//           child: _filteredProducts.isEmpty
//               ? _buildEmptyState()
//               : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: _filteredProducts.length,
//                   itemBuilder: (context, index) {
//                     final product = _filteredProducts[index];
//                     final brand = widget.brands.firstWhere(
//                       (b) => b.id == product.brandId,
//                       orElse: () => BrandModel(name: 'Unknown Brand'),
//                     );
//                     final category = widget.categories.firstWhere(
//                       (c) => c.id == product.categoryId,
//                       orElse: () =>
//                           ProductCategoryModel(productName: 'Unknown Category'),
//                     );
//                     final subCategory = widget.subCategories.firstWhere(
//                       (s) => s.id == product.subCategoryId,
//                       orElse: () =>
//                           ProductSubCategoryModel(name: 'Unknown Sub Category'),
//                     );

//                     return ProductCard(
//                       product: product,
//                       brand: brand,
//                       category: category,
//                       subCategory: subCategory,
//                       isSelected: widget.selectedIds.contains(product.id),
//                       onActionSelected: (action) =>
//                           _handleActionSelected(product, action),
//                       onSelectChanged: (value) =>
//                           widget.onSelectChanged(value, product),
//                     );
//                   },
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             _searchQuery.isNotEmpty
//                 ? Icons.search_off
//                 : Icons.inventory_2_outlined,
//             size: 64,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _searchQuery.isNotEmpty
//                 ? 'No products found for "$_searchQuery"'
//                 : 'No products available',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _searchQuery.isNotEmpty
//                 ? 'Try searching with different keywords'
//                 : 'Add your first product to get started',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   TextStyle _headerStyle() {
//     return TextStyle(
//       fontSize: 14,
//       fontWeight: FontWeight.w700,
//       color: Colors.grey.shade700,
//     );
//   }
// }

// // Usage Example
// class ProductListPage extends StatefulWidget {
//   const ProductListPage({super.key});

//   @override
//   State<ProductListPage> createState() => _ProductListPageState();
// }

// class _ProductListPageState extends State<ProductListPage> {
//   Set<String> selectedIds = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Products')),
//       body: ProductListView(
//         products: [], // Your products list
//         brands: [], // Your brands list
//         categories: [], // Your categories list
//         subCategories: [], // Your subcategories list
//         selectedIds: selectedIds,
//         //onActionSelected: _handleActionSelected,
//         onSelectChanged: (isSelected, product) {
//           setState(() {
//             if (isSelected == true) {
//               selectedIds.add(product.id!);
//             } else {
//               selectedIds.remove(product.id);
//             }
//           });
//         },
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/modern_motors/inventory/direct_inventory_add_screen.dart';
import 'package:modern_motors_panel/modern_motors/products/add_edit_product.dart';
import 'package:modern_motors_panel/modern_motors/products/product_details_page.dart';
import 'package:modern_motors_panel/modern_motors/products/product_inventory_batches_main_page.dart';
import 'package:modern_motors_panel/modern_motors/products/product_inventory_logs_main_page.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/mm_employee_info_tile.dart';

// Enum for dropdown actions
enum ProductAction { view, inventoryLogs, inventoryBatch, edit, addNew, delete }

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final BrandModel brand;
  final ProductCategoryModel category;
  final ProductSubCategoryModel subCategory;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(ProductAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const ProductCard({
    super.key,
    required this.product,
    required this.brand,
    required this.category,
    required this.subCategory,
    this.isSelected = false,
    this.onTap,
    this.onActionSelected,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Increased height from 65 to 85
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
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ), // Increased vertical padding
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

              // Product Code Badge
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
                  'PROD-${product.code}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Product Image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: product.image != null && product.image!.isNotEmpty
                      ? Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image,
                            color: Colors.grey.shade400,
                            size: 16,
                          ),
                        )
                      : Icon(
                          Icons.image,
                          color: Colors.grey.shade400,
                          size: 16,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Product Name & Brand with Description
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.productName ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a202c),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Description
                    Text(
                      product.description ?? 'No description',
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
                        brand.name,
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

              // Category
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.productName,
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
                      "${"Sub Cat"}: ${subCategory.name}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${"SKU"}: ${product.sku ?? ""}",
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

              // Stock Info
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 6, vertical: 3),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         Theme.of(context).primaryColor,
                    //         Theme.of(context).primaryColor.withOpacity(0.8),
                    //       ],
                    //     ),
                    //     borderRadius: BorderRadius.circular(4),
                    //   ),
                    //   child: Text(
                    //     'PROD-${product.code}',
                    //     style: const TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStockStatusColor(),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getStockStatusText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Stock: ${product.totalStockOnHand ?? 0}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStockColor(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Threshold: ${product.threshold ?? 0}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Price Info with Min Price & Status
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sell : ${product.sellingPrice?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Avg: ${product.averageCost?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 1),
                    // Minimum Price
                    if (product.minimumPrice != null)
                      Text(
                        'Min: ${product.minimumPrice?.toStringAsFixed(2) ?? '0.00'}',
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
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        (product.status ?? 'active').toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // FIFO Valuation
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.fifoValue?.toStringAsFixed(2) ?? '0.00',
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
                        "FIFO",
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
                      ).format(product.createAt?.toDate() ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    // Created By
                    // Text(
                    //   'By: ${product.createdBy ?? 'System'}',
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     color: Colors.grey.shade500,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    MmEmployeeInfoTile(
                      employeeId: product.createdBy ?? "System",
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
              PopupMenuButton<ProductAction>(
                onSelected: (ProductAction action) {
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
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.view,
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('View'),
                      ],
                    ),
                  ),
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.inventoryLogs,
                    child: Row(
                      children: [
                        Icon(
                          Icons.production_quantity_limits,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text('Inventory Logs'),
                      ],
                    ),
                  ),
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.inventoryBatch,
                    child: Row(
                      children: [
                        Icon(
                          Icons.batch_prediction_sharp,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text('Inventory Batch'),
                      ],
                    ),
                  ),
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.edit,
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.addNew,
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Add Manual Inventory'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<ProductAction>(
                    value: ProductAction.delete,
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

  Color _getStockStatusColor() {
    final stock = product.totalStockOnHand ?? 0;
    final threshold = product.threshold ?? 0;

    if (stock == 0) {
      return Colors.red; // Out of stock - red
    } else if (stock <= threshold) {
      return Colors.orange; // Low stock - orange
    } else {
      return Colors.green; // In stock - green
    }
  }

  Color _getStockColor() {
    final stock = product.totalStockOnHand ?? 0;
    final threshold = product.threshold ?? 0;

    if (stock < 0) {
      return Colors.purple; // or Colors.deepOrange
    } else if (stock == 0) {
      return Colors.red;
    } else if (stock <= threshold) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getStockStatusText() {
    final stock = product.totalStockOnHand ?? 0;
    final threshold = product.threshold ?? 0;

    if (stock < 0) {
      return 'Negative Stock';
    } else if (stock == 0) {
      return 'Out of Stock';
    } else if (stock <= threshold) {
      return 'Low Stock';
    } else {
      return 'In Stock';
    }
  }

  Color _getStatusColor() {
    switch (product.status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// Enhanced ProductListView with updated header
class ProductListView extends StatefulWidget {
  final List<ProductModel> products;
  final List<BrandModel> brands;
  final List<ProductCategoryModel> categories;
  final List<ProductSubCategoryModel> subCategories;
  final Set<String> selectedIds;
  final Function(bool?, ProductModel) onSelectChanged;
  final bool enableSearch;
  final Function? tapped;

  const ProductListView({
    super.key,
    required this.products,
    required this.brands,
    required this.categories,
    required this.subCategories,
    required this.selectedIds,
    required this.onSelectChanged,
    this.tapped,
    this.enableSearch = true,
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
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
      _filterProducts();
    });
  }

  void _filterProducts() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = widget.products;
    } else {
      _filteredProducts = widget.products.where((product) {
        final searchLower = _searchQuery.toLowerCase();

        // Get brand name
        final brand = widget.brands.firstWhere(
          (b) => b.id == product.brandId,
          orElse: () => BrandModel(name: ''),
        );

        // Get category name
        final category = widget.categories.firstWhere(
          (c) => c.id == product.categoryId,
          orElse: () => ProductCategoryModel(productName: ''),
        );

        // Get subcategory name
        final subCategory = widget.subCategories.firstWhere(
          (s) => s.id == product.subCategoryId,
          orElse: () => ProductSubCategoryModel(name: ''),
        );

        return (product.productName?.toLowerCase().contains(searchLower) ??
                false) ||
            (product.code?.toLowerCase().contains(searchLower) ?? false) ||
            (brand.name.toLowerCase().contains(searchLower)) ||
            (category.productName.toLowerCase().contains(searchLower)) ||
            (subCategory.name.toLowerCase().contains(searchLower)) ||
            (product.status?.toLowerCase().contains(searchLower) ?? false) ||
            (product.description?.toLowerCase().contains(searchLower) ??
                false) ||
            (product.createdBy?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }
  }

  Future<void> updateStatus() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await widget.tapped!();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(ProductListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.products != widget.products) {
      _filterProducts();
    }
  }

  void _handleActionSelected(
    ProductModel product,
    ProductAction action, {
    String? brand,
    String? category,
    String? subcategory,
  }) async {
    switch (action) {
      case ProductAction.inventoryLogs:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ProductInventoryLogsMainPage(product: product),
          ),
        );
        debugPrint('Inventory Logs: ${product.productName}');
        break;
      case ProductAction.inventoryBatch:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ProductInventoryBatchesMainPage(product: product),
          ),
        );
        debugPrint('Inventory Batches: ${product.productName}');
        break;
      case ProductAction.edit:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AddEditProduct(
                isEdit: true,
                productModel: product,
                onBack: () {
                  Navigator.of(context).pop();
                  if (widget.tapped != null) {
                    widget.tapped!(); // ✅ This actually calls the function
                  }
                },
              );
            },
          ),
        );

        debugPrint('Edit product: ${product.productName}');
        break;
      // case ProductAction.addNew:
      //   double q = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => DirectInventoryAddScreen(product: product),
      //       ));
      //   //changeStatus(product, q);
      //   if (q != null)
      //   updateStatus();
      //   debugPrint('Add inventory: ${product.productName}');
      //   break;
      case ProductAction.addNew:
        try {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DirectInventoryAddScreen(
                product: product,
                // onBack: () {
                //   Navigator.of(context).pop();
                //   if (widget.tapped != null) {
                //     widget.tapped!(); // ✅ This actually calls the function
                //   }
                // },
              ),
            ),
          ).then((value) async {
            //Navigator.of(context).pop();
            if (widget.tapped != null) {
              // widget.tapped!(); // ✅ This actually calls the function
              await updateStatus();
            }
          });

          // await WidgetsBinding.instance.endOfFrame;
          // //changeStatus(product, q);
          // await updateStatus();
          debugPrint('Add inventory: ${product.productName}');
        } catch (e) {
          debugPrint('Error in addNew: $e');
        }
        break;
      case ProductAction.view:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              product: product,
              brand: brand,
              category: category,
              subCategory: subcategory,
            ),
          ),
        );
        debugPrint('Add inventory: ${product.productName}');
        break;
      case ProductAction.delete:
        _showDeleteConfirmation(product);
        break;
    }
  }

  void tapFunction() {
    widget.tapped;
  }

  void changeStatus(ProductModel p, double q) {
    int i = _filteredProducts.indexWhere((element) => element.id == p.id);
    if (i != -1) {
      setState(() {
        double quantity = (_filteredProducts[i].totalStockOnHand ?? 0) + q;
        _filteredProducts[i] = _filteredProducts[i].copyWith(
          totalStockOnHand: quantity,
        );
      });
    }
  }

  void _showDeleteConfirmation(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.productName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform delete action
              debugPrint('Deleted product: ${product.productName}');
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
          // Container(
          //   height: 50,
          //   margin: const EdgeInsets.all(16),
          //   child: TextField(
          //     controller: _searchController,
          //     decoration: InputDecoration(
          //       hintText:
          //           'Search by product name, code, brand, category, description, or created by...',
          //       hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          //       prefixIcon:
          //           Icon(Icons.search, size: 20, color: Colors.grey.shade400),
          //       suffixIcon: _searchQuery.isNotEmpty
          //           ? IconButton(
          //               icon: Icon(Icons.clear,
          //                   size: 20, color: Colors.grey.shade400),
          //               onPressed: () {
          //                 _searchController.clear();
          //               },
          //             )
          //           : null,
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(8),
          //         borderSide: BorderSide(color: Colors.grey.shade300),
          //       ),
          //       enabledBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(8),
          //         borderSide: BorderSide(color: Colors.grey.shade300),
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(8),
          //         borderSide: BorderSide(color: Theme.of(context).primaryColor),
          //       ),
          //       filled: true,
          //       fillColor: Colors.grey.shade50,
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //     ),
          //   ),
          // ),
          // Results count
          if (widget.enableSearch && _searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Found ${_filteredProducts.length} product${_filteredProducts.length != 1 ? 's' : ''}',
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

        // Header Row - Updated to match new columns
        Container(
          height: 40, // Slightly increased header height
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              if (widget.selectedIds.isNotEmpty) const SizedBox(width: 32),
              const SizedBox(width: 100), // Product code space
              const SizedBox(width: 52), // Image space
              Expanded(
                flex: 2,
                child: Text('Product & Description', style: _headerStyle()),
              ),
              Expanded(flex: 1, child: Text('Category', style: _headerStyle())),
              Expanded(
                flex: 1,
                child: Text(
                  'Stock',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Pricing (OMR)',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Valuation',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Created Info',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 30), // Actions space
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Products List
        Expanded(
          child: _filteredProducts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    final brand = widget.brands.firstWhere(
                      (b) => b.id == product.brandId,
                      orElse: () => BrandModel(name: 'Unknown Brand'),
                    );
                    final category = widget.categories.firstWhere(
                      (c) => c.id == product.categoryId,
                      orElse: () =>
                          ProductCategoryModel(productName: 'Unknown Category'),
                    );
                    final subCategory = widget.subCategories.firstWhere(
                      (s) => s.id == product.subCategoryId,
                      orElse: () =>
                          ProductSubCategoryModel(name: 'Unknown Sub Category'),
                    );

                    return ProductCard(
                      product: product,
                      brand: brand,
                      category: category,
                      subCategory: subCategory,
                      isSelected: widget.selectedIds.contains(product.id),
                      onTap: () => widget.tapped,
                      onActionSelected: (action) => _handleActionSelected(
                        product,
                        action,
                        subcategory: subCategory.name,
                        category: category.productName,
                        brand: brand.name,
                      ),
                      onSelectChanged: (value) => {}, //changeStatus(product),
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
            _searchQuery.isNotEmpty
                ? Icons.search_off
                : Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No products found for "$_searchQuery"'
                : 'No products available',
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
                : 'Add your first product to get started',
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
