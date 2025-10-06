// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ManageProducts extends StatefulWidget {
//   final void Function(String page)? onNavigate;

//   const ManageProducts({super.key, this.onNavigate});

//   @override
//   State<ManageProducts> createState() => _ManageProductsState();
// }

// class _ManageProductsState extends State<ManageProducts> {
//   bool showInventoryList = true;
//   bool isLoading = true;
//   bool isAddInInvoice = false;

//   ProductModel? productBeingEdited;
//   List<ProductModel> allProducts = [];
//   List<ProductModel> displayedProducts = [];
//   List<BrandModel> brands = [];
//   List<ProductCategoryModel> productsCategories = [];
//   List<UnitModel> units = [];
//   List<ProductSubCatorymodel> subCategories = [];
//   List<BranchModel> branches = [];
//   List<VendorModel> vendors = [];

//   final headers = [
//     'Product Code'.tr(),
//     'Product Name'.tr(),
//     'Brand'.tr(),
//     'Product Cat'.tr(),
//     'Sub Category'.tr(),
//     'Threshold'.tr(),
//     "Stock in Hand".tr(),
//     "Avg Cost".tr(),
//     'Create On'.tr(),
//     'last updated'.tr(),
//   ];

//   List<List<dynamic>> getRowsForExcel(List<ProductModel> inventories) {
//     return inventories.map((v) {
//       final brand = brands.firstWhere(
//         (b) => b.id == v.brandId,
//         orElse: () => BrandModel(name: ''),
//       );
//       final product = productsCategories.firstWhere(
//         (p) => p.id == v.categoryId,
//         orElse: () => ProductCategoryModel(productName: ''),
//       );
//       final subCat = subCategories.firstWhere(
//         (s) => s.id == v.subCategoryId,
//         orElse: () => ProductSubCatorymodel(name: ''),
//       );

//       return [
//         v.code ?? '',
//         v.productName ?? '',
//         brand.name,
//         product.productName,
//         subCat.name,
//         v.threshold ?? '',
//         v.createAt?.toDate().formattedWithDayMonthYear ?? '',
//       ];
//     }).toList();
//   }

//   int currentPage = 0;
//   int itemsPerPage = 10;

//   Future<void> _deleteSelectedItems() async {
//     final provider = context.read<SelectedInventoriesProvider>();
//     final selectedIds = provider.getSelectedInventoryIds.toList();
//     final confirm = await DeleteDialogHelper.showDeleteConfirmation(
//       context,
//       selectedIds.length,
//     );

//     if (confirm != true) return;

//     for (String id in selectedIds) {
//       await FirebaseFirestore.instance.collection('inventory').doc(id).delete();
//     }

//     provider.removeAllInventory();
//     // setState(() {
//     //   selectedInventoryIds.clear();
//     // });

//     await _loadInventory();
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   final provider = context.read<SelectedInventoriesProvider>();
//   //   provider.clearData();
//   //   _loadInventory();
//   // }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<SelectedInventoriesProvider>();
//       provider.clearData();
//     });
//     _loadInventory();
//   }

//   Future<void> _loadInventory() async {
//     setState(() {
//       isLoading = true;
//     });
//     Future.wait([
//       DataFetchService.fetchProducts(),
//       DataFetchService.fetchUnits(),
//       DataFetchService.fetchProduct(),
//       DataFetchService.fetchSubCategories(),
//       DataFetchService.fetchBrands(),
//       DataFetchService.fetchBranches(),
//       DataFetchService.fetchVendor(),
//     ]).then((results) {
//       setState(() {
//         allProducts = results[0] as List<ProductModel>;
//         displayedProducts = results[0] as List<ProductModel>;
//         units = results[1] as List<UnitModel>;
//         productsCategories = results[2] as List<ProductCategoryModel>;
//         subCategories = results[3] as List<ProductSubCatorymodel>;
//         brands = results[4] as List<BrandModel>;
//         branches = results[5] as List<BranchModel>;
//         vendors = results[6] as List<VendorModel>;
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     final provider = context.read<SelectedInventoriesProvider>();
//     provider.clearData();
//     debugPrint('dispose called');
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pagedItems = displayedProducts
//         .skip(currentPage * itemsPerPage)
//         .take(itemsPerPage)
//         .toList();

//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else {
//       return Consumer<SelectedInventoriesProvider>(
//         builder: (context, selectedInventories, child) {
//           if (isAddInInvoice) {
//             return CreateBill(
//               onBack: () async {
//                 await _loadInventory();
//                 setState(() {
//                   isAddInInvoice = false;
//                 });
//               },
//             );
//           } else {
//             if (showInventoryList) {
//               return Column(
//                 children: [
//                   PageHeaderWidget(
//                     title: 'Products'.tr(),
//                     buttonText: "Create Product".tr(),
//                     subTitle: "Manage your products".tr(),
//                     selectedItems:
//                         selectedInventories.getSelectedInventoryIds.toList(),
//                     onCreate: () async {
//                       setState(() {
//                         showInventoryList = false;
//                       });
//                     },
//                     buttonWidth: 0.28,
//                     onDelete: _deleteSelectedItems,
//                     onImport: () {},
//                   ),
//                   allProducts.isEmpty
//                       ? EmptyWidget(
//                           text: "There's no Inventories available".tr(),
//                         )
//                       : Expanded(
//                           child: ProductListView(
//                             products: allProducts,
//                             brands: brands,
//                             categories: productsCategories,
//                             subCategories: subCategories,
//                             selectedIds:
//                                 selectedInventories.getSelectedInventoryIds,
//                             onSelectChanged: (isSelected, product) {},
//                           ),
//                         ),
//                   displayedProducts.length > itemsPerPage
//                       ? Align(
//                           alignment: Alignment.center,
//                           child: PaginationWidget(
//                             currentPage: currentPage,
//                             totalItems: displayedProducts.length,
//                             itemsPerPage: itemsPerPage,
//                             onPageChanged: (newPage) {
//                               setState(() {
//                                 currentPage = newPage;
//                               });
//                             },
//                             onItemsPerPageChanged: (newLimit) {
//                               setState(() {
//                                 itemsPerPage = newLimit;
//                               });
//                             },
//                           ),
//                         )
//                       : const SizedBox.shrink(),
//                 ],
//               );
//             } else {
//               return AddEditProduct(
//                 isEdit: productBeingEdited != null,
//                 productModel: productBeingEdited,
//                 onBack: () async {
//                   await _loadInventory();
//                   setState(() {
//                     showInventoryList = true;
//                     productBeingEdited = null;
//                   });
//                 },
//               );
//             }
//           }
//         },
//       );
//     }
//   }
// }
