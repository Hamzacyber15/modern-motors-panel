// import 'package:app/constants.dart';
// import 'package:app/modern_motors/models/product/product_model.dart';
// import 'package:app/modern_motors/services/data_fetch_service.dart';
// import 'package:app/modern_motors/services/data_upload_service.dart';
// import 'package:app/modern_motors/widgets/extension.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class SalesScreen extends StatefulWidget {
//   const SalesScreen({super.key});

//   @override
//   State<SalesScreen> createState() => _SalesScreenState();
// }

// class _SalesScreenState extends State<SalesScreen> {
//   final TextEditingController _customerNameController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   final TextEditingController _globalMarginController =
//       TextEditingController(text: '20'); // Default 20% margin

//   List<ProductModel> allProducts = [];
//   List<ProductModel> filteredProducts = [];
//   List<SaleItem> selectedProducts = [];
//   double totalCost = 0;
//   double totalRevenue = 0;
//   double totalProfit = 0;
//   double totalMargin = 0;
//   bool isLoading = true;
//   bool isSelling = false;
//   bool showProductSelection = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//     _searchController.addListener(_filterProducts);
//     _globalMarginController.addListener(_applyGlobalMargin);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_filterProducts);
//     _globalMarginController.removeListener(_applyGlobalMargin);
//     _searchController.dispose();
//     _globalMarginController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadProducts() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final products = await DataFetchService.fetchProducts();
//       setState(() {
//         allProducts = products;
//         filteredProducts = products;
//         isLoading = false;
//       });
//     } catch (e) {
//       Constants.showMessage(context, 'Error loading products: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _filterProducts() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredProducts = allProducts.where((product) {
//         return product.productName!.toLowerCase().contains(query) ||
//             product.code!.toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   void _applyGlobalMargin() {
//     final margin = double.tryParse(_globalMarginController.text) ?? 0;
//     if (margin > 0) {
//       setState(() {
//         for (final item in selectedProducts) {
//           final newUnitPrice = item.costPrice * (1 + (margin / 100));
//           final index = selectedProducts
//               .indexWhere((i) => i.product.id == item.product.id);
//           if (index != -1) {
//             selectedProducts[index] = SaleItem(
//               product: item.product,
//               quantity: item.quantity,
//               costPrice: item.costPrice,
//               marginPercent: margin,
//               unitPrice: newUnitPrice,
//               totalPrice: newUnitPrice * item.quantity,
//             );
//           }
//         }
//         _calculateTotals();
//       });
//     }
//   }

//   void _addProductToSale(ProductModel product) {
//     final existingItem = selectedProducts.firstWhere(
//       (item) => item.product.id == product.id,
//       orElse: () => SaleItem(
//           product: ProductModel(),
//           quantity: 0,
//           costPrice: 0,
//           marginPercent: 0,
//           unitPrice: 0,
//           totalPrice: 0),
//     );

//     if (existingItem.product.id != null) {
//       _showEditProductDialog(existingItem);
//     } else {
//       _showAddProductDialog(product);
//     }
//   }

//   void _showAddProductDialog(ProductModel product) {
//     final quantityController = TextEditingController(text: '1');
//     final marginController =
//         TextEditingController(text: _globalMarginController.text);
//     final costPrice = product.averageCost ?? 0;
//     final initialSellingPrice =
//         costPrice * (1 + (double.parse(marginController.text) / 100));

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           void updateSellingPrice() {
//             final margin = double.tryParse(marginController.text) ?? 0;
//             final sellingPrice = costPrice * (1 + (margin / 100));
//             setState(() {});
//           }

//           return AlertDialog(
//             title: Text('Add ${product.productName} to Sale'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: quantityController,
//                   decoration: const InputDecoration(
//                     labelText: 'Quantity',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Cost Price: OMR ${costPrice.toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//                 16.h,
//                 TextFormField(
//                   controller: marginController,
//                   decoration: const InputDecoration(
//                     labelText: 'Margin %',
//                     border: OutlineInputBorder(),
//                     suffixText: '%',
//                   ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Selling Price: OMR ${(costPrice * (1 + ((double.tryParse(marginController.text) ?? 0) / 100))).toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final quantity = int.tryParse(quantityController.text) ?? 0;
//                   final margin = double.tryParse(marginController.text) ?? 0;

//                   if (quantity <= 0) return;
//                   if (quantity > (product.totalStockOnHand ?? 0)) return;

//                   final unitPrice = costPrice * (1 + (margin / 100));

//                   setState(() {
//                     selectedProducts.add(SaleItem(
//                       product: product,
//                       quantity: quantity,
//                       costPrice: costPrice,
//                       marginPercent: margin,
//                       unitPrice: unitPrice,
//                       totalPrice: unitPrice * quantity,
//                     ));
//                     _calculateTotals();
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Add'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _showEditProductDialog(SaleItem item) {
//     final quantityController =
//         TextEditingController(text: item.quantity.toString());
//     final marginController =
//         TextEditingController(text: item.marginPercent.toStringAsFixed(1));

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           void updateSellingPrice() {
//             final margin = double.tryParse(marginController.text) ?? 0;
//             final sellingPrice = item.costPrice * (1 + (margin / 100));
//             setState(() {});
//           }

//           return AlertDialog(
//             title: Text('Edit ${item.product.productName}'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: quantityController,
//                   decoration: const InputDecoration(
//                     labelText: 'Quantity',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Cost Price: OMR ${item.costPrice.toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//                 16.h,
//                 TextFormField(
//                   controller: marginController,
//                   decoration: const InputDecoration(
//                     labelText: 'Margin %',
//                     border: OutlineInputBorder(),
//                     suffixText: '%',
//                   ),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => updateSellingPrice(),
//                 ),
//                 16.h,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Selling Price: OMR ${(item.costPrice * (1 + ((double.tryParse(marginController.text) ?? 0) / 100))).toStringAsFixed(2)}'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final quantity = int.tryParse(quantityController.text) ?? 0;
//                   final margin = double.tryParse(marginController.text) ?? 0;

//                   if (quantity <= 0) return;
//                   if (quantity > (item.product.totalStockOnHand ?? 0)) return;

//                   final unitPrice = item.costPrice * (1 + (margin / 100));

//                   setState(() {
//                     final index = selectedProducts
//                         .indexWhere((i) => i.product.id == item.product.id);
//                     if (index != -1) {
//                       selectedProducts[index] = SaleItem(
//                         product: item.product,
//                         quantity: quantity,
//                         costPrice: item.costPrice,
//                         marginPercent: margin,
//                         unitPrice: unitPrice,
//                         totalPrice: unitPrice * quantity,
//                       );
//                       _calculateTotals();
//                     }
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Update'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _removeProductFromSale(ProductModel product) {
//     setState(() {
//       selectedProducts.removeWhere((item) => item.product.id == product.id);
//       _calculateTotals();
//     });
//   }

//   void _calculateTotals() {
//     totalRevenue =
//         selectedProducts.fold(0, (sum, item) => sum + item.totalPrice);
//     totalCost = selectedProducts.fold(
//         0, (sum, item) => sum + (item.costPrice * item.quantity));
//     totalProfit = totalRevenue - totalCost;
//     totalMargin = totalCost > 0 ? (totalProfit / totalCost) * 100 : 0;
//   }

//   Future<void> _processSale() async {
//     if (selectedProducts.isEmpty) {
//       Constants.showMessage(context, 'Please add products to sale');
//       return;
//     }

//     if (_customerNameController.text.isEmpty) {
//       Constants.showMessage(context, 'Please enter customer name');
//       return;
//     }

//     setState(() {
//       isSelling = true;
//     });

//     try {
//       final saleData = {
//         'customerName': _customerNameController.text,
//         'notes': _notesController.text,
//         'items': selectedProducts
//             .map((item) => {
//                   'productId': item.product.id,
//                   'productName': item.product.productName,
//                   'quantity': item.quantity,
//                   'costPrice': item.costPrice,
//                   'marginPercent': item.marginPercent,
//                   'unitPrice': item.unitPrice,
//                   'totalPrice': item.totalPrice,
//                 })
//             .toList(), // Ensure this is a List, not null
//         'totalRevenue': totalRevenue,
//         'totalCost': totalCost, // This will be recalculated with actual FIFO
//         'totalProfit': totalProfit,
//         'totalMargin': totalMargin,
//         'saleDate': FieldValue.serverTimestamp(),
//         'createdAt': FieldValue.serverTimestamp(),
//         'status': 'pending',
//       };

//       await DataUploadService.processSale(saleData);

//       if (!mounted) return;
//       Constants.showMessage(context, 'Sale processed successfully!');
//       _resetForm();
//     } catch (e) {
//       if (!mounted) return;
//       Constants.showMessage(context, 'Error processing sale: $e');
//     } finally {
//       setState(() {
//         isSelling = false;
//       });
//     }
//   }

//   void _resetForm() {
//     setState(() {
//       selectedProducts.clear();
//       _customerNameController.clear();
//       _notesController.clear();
//       totalCost = 0;
//       totalRevenue = 0;
//       totalProfit = 0;
//       totalMargin = 0;
//     });
//   }

//   void _toggleView() {
//     setState(() {
//       showProductSelection = !showProductSelection;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Sale'),
//         actions: [
//           IconButton(
//             icon:
//                 Icon(showProductSelection ? Icons.shopping_cart : Icons.search),
//             onPressed: _toggleView,
//             tooltip: showProductSelection ? 'View Cart' : 'Browse Products',
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : showProductSelection
//               ? _buildProductSelection()
//               : _buildSaleSummary(),
//     );
//   }

//   Widget _buildProductSelection() {
//     return Column(
//       children: [
//         // Global Margin Control
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _globalMarginController,
//                   decoration: const InputDecoration(
//                     labelText: 'Default Margin %',
//                     border: OutlineInputBorder(),
//                     suffixText: '%',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ),
//               16.w,
//               ElevatedButton(
//                 onPressed: _applyGlobalMargin,
//                 child: const Text('Apply to All'),
//               ),
//             ],
//           ),
//         ),

//         // Search Bar
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               labelText: 'Search Products',
//               border: const OutlineInputBorder(),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.clear),
//                 onPressed: () => _searchController.clear(),
//               ),
//             ),
//           ),
//         ),
//         16.h,

//         // Products List
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredProducts.length,
//             itemBuilder: (context, index) {
//               final product = filteredProducts[index];
//               final isInCart =
//                   selectedProducts.any((item) => item.product.id == product.id);
//               final margin =
//                   double.tryParse(_globalMarginController.text) ?? 20;
//               final suggestedPrice =
//                   (product.averageCost ?? 0) * (1 + (margin / 100));

//               return ListTile(
//                 title: Text(product.productName ?? ''),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Code: ${product.code}'),
//                     Text('Stock: ${product.totalStockOnHand} units'),
//                     Text(
//                         'Cost: OMR ${product.averageCost?.toStringAsFixed(2)}'),
//                     Text(
//                         'Suggested: OMR ${suggestedPrice.toStringAsFixed(2)} ($margin%)'),
//                   ],
//                 ),
//                 trailing: isInCart
//                     ? const Icon(Icons.check_circle, color: Colors.green)
//                     : const Icon(Icons.add_circle_outline),
//                 onTap: () => _addProductToSale(product),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSaleSummary() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           // Selected Products List
//           Expanded(
//             child: ListView(
//               children: [
//                 const Text(
//                   'Selected Products',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 16.h,
//                 ...selectedProducts.map((item) => Card(
//                       child: ListTile(
//                         title: Text(item.product.productName ?? ''),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Qty: ${item.quantity}'),
//                             Text(
//                                 'Cost: OMR ${item.costPrice.toStringAsFixed(2)}'),
//                             Text(
//                                 'Margin: ${item.marginPercent.toStringAsFixed(1)}%'),
//                             Text(
//                                 'Price: OMR ${item.unitPrice.toStringAsFixed(2)}'),
//                           ],
//                         ),
//                         trailing:
//                             Text('OMR ${item.totalPrice.toStringAsFixed(2)}'),
//                         onTap: () => _showEditProductDialog(item),
//                         onLongPress: () => _removeProductFromSale(item.product),
//                       ),
//                     )),
//               ],
//             ),
//           ),

//           // Totals
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildTotalRow('Total Revenue:', totalRevenue),
//                   _buildTotalRow('Total Cost:', totalCost),
//                   _buildTotalRow('Total Profit:', totalProfit, isProfit: true),
//                   _buildTotalRow('Profit Margin:', totalMargin,
//                       isPercent: true),
//                 ],
//               ),
//             ),
//           ),

//           // Customer Info
//           TextFormField(
//             controller: _customerNameController,
//             decoration: const InputDecoration(
//               labelText: 'Customer Name *',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           16.h,

//           // Notes
//           TextFormField(
//             controller: _notesController,
//             decoration: const InputDecoration(
//               labelText: 'Notes (Optional)',
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 2,
//           ),
//           16.h,

//           // Action Buttons
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: _resetForm,
//                   child: const Text('Clear All'),
//                 ),
//               ),
//               16.w,
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: isSelling ? null : _processSale,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                   child: isSelling
//                       ? const CircularProgressIndicator()
//                       : const Text('Process Sale'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTotalRow(String label, double value,
//       {bool isProfit = false, bool isPercent = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: isProfit
//                   ? value >= 0
//                       ? Colors.green
//                       : Colors.red
//                   : Colors.black,
//             ),
//           ),
//           Text(
//             isPercent
//                 ? '${value.toStringAsFixed(1)}%'
//                 : 'OMR ${value.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: isProfit
//                   ? value >= 0
//                       ? Colors.green
//                       : Colors.red
//                   : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SaleItem {
//   final ProductModel product;
//   final int quantity;
//   final double costPrice;
//   final double marginPercent;
//   final double unitPrice;
//   final double totalPrice;

//   SaleItem({
//     required this.product,
//     required this.quantity,
//     required this.costPrice,
//     required this.marginPercent,
//     required this.unitPrice,
//     required this.totalPrice,
//   });
// }
