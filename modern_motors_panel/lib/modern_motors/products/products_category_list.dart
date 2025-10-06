import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/products/add_product.dart';
import 'package:modern_motors_panel/modern_motors/products/product_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/primary_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/provider/sell_order_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:provider/provider.dart';

// class ProductsCategoryList extends StatefulWidget {
//   final void Function(String page)? onNavigate;

//   const ProductsCategoryList({super.key, this.onNavigate});

//   @override
//   State<ProductsCategoryList> createState() => _ProductsCategoryListState();
// }

// class _ProductsCategoryListState extends State<ProductsCategoryList> {
//   bool showProductList = true;
//   bool isLoading = true;

//   List<ProductCategoryModel> allProducts = [];
//   List<ProductCategoryModel> displayedProducts = [];
//   Map<String, String> userIdToName = {};

//   ProductCategoryModel? productBeingEdited;

//   int currentPage = 0;
//   int itemsPerPage = 10;
//   Set<String> selectedProductIds = {};
//   List<UnitModel> units = [];

//   Future<void> _deleteSelectedProducts() async {
//     final confirm = await DeleteDialogueHelper.showDeleteConfirmation(
//       context,
//       selectedProductIds.length,
//     );

//     if (confirm != true) return;

//     for (String productId in selectedProductIds) {
//       await FirebaseFirestore.instance
//           .collection('productsCategory')
//           .doc(productId)
//           .delete();
//     }

//     setState(() {
//       selectedProductIds.clear();
//     });

//     await _loadProducts();
//   }

//   final List<String> productHeaders = [
//     'SKU',
//     'Product Name',
//     'Unit',
//     'Created By',
//   ];

//   List<List<dynamic>> getProductRowsForExcel(
//       List<ProductCategoryModel> products) {
//     return products.map((p) {
//       final unit = units.firstWhere(
//         (u) => u.id == p.unitId,
//         orElse: () => UnitModel(name: '', id: ''),
//       );

//       final createdByName = userIdToName[p.createdBy] ?? p.createdBy ?? '';

//       return [p.sku ?? '', p.productName, unit.name, createdByName ?? ''];
//     }).toList();
//   }

//   void _addSelectedToOrder() {
//     final orderProvider = Provider.of<SellOrderProvider>(
//       context,
//       listen: false,
//     );

//     final selected =
//         allProducts.where((p) => selectedProductIds.contains(p.id)).toList();

//     orderProvider.addProducts(selected);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${selected.length} products added to order')),
//     );
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   Future<void> _loadProducts() async {
//     setState(() {
//       isLoading = true;
//     });
//     Future.wait([
//       DataFetchService.fetchUnits(),
//       DataFetchService.fetchProduct(),
//     ]).then((results) {
//       setState(() {
//         units = results[0] as List<UnitModel>;
//         allProducts = results[1] as List<ProductCategoryModel>;
//         displayedProducts = results[1] as List<ProductCategoryModel>;
//         isLoading = false;
//       });
//     });
//   }

//   Future<void> buildUserIdToNameMap(List<ProductCategoryModel> products) async {
//     final userIds = products
//         .map((p) => p.createdBy)
//         .where((id) => id != null && id.isNotEmpty)
//         .toSet();
//     final snapshot = await FirebaseFirestore.instance
//         .collection('profile')
//         .where(FieldPath.documentId, whereIn: userIds.toList())
//         .get();

//     final Map<String, String> map = {
//       for (var doc in snapshot.docs)
//         doc.id: (doc.data()['fullName'] ?? 'Unknown') as String,
//     };

//     userIdToName = map;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final pagedProducts = displayedProducts
//         .skip(currentPage * itemsPerPage)
//         .take(itemsPerPage)
//         .toList();

//     return showProductList
//         ? SingleChildScrollView(
//             child: Column(
//               children: [
//                 PageHeaderWidget(
//                   title: "Product Category List".tr(),
//                   buttonText: "Create".tr(),
//                   subTitle: "Manage your products category".tr(),
//                   selectedItems: selectedProductIds.toList(),
//                   onCreate: () {
//                     setState(() {
//                       showProductList = false;
//                     });
//                   },
//                   onDelete: _deleteSelectedProducts,
//                   onExelImport: () async {
//                     await buildUserIdToNameMap(pagedProducts);
//                     final rowsToExport = getProductRowsForExcel(pagedProducts);
//                     await ExcelExporter.exportToExcel(
//                       headers: productHeaders,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Product_Categories_Report',
//                     );
//                   },
//                   onImport: () {},
//                   onPdfImport: () async {
//                     await buildUserIdToNameMap(pagedProducts);
//                     final rowsToExport = getProductRowsForExcel(pagedProducts);
//                     await PdfExporter.exportToPdf(
//                       headers: productHeaders,
//                       rows: rowsToExport,
//                       fileNamePrefix: 'Product_Categories_Report',
//                     );
//                   },
//                 ),
//                 if (selectedProductIds.isNotEmpty)
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0,
//                         vertical: 8,
//                       ),
//                       child: Consumer<SellOrderProvider>(
//                         builder: (context, p, child) {
//                           return PrimaryButton(
//                             label: 'Add ${selectedProductIds.length} to Order',
//                             onPressed: selectedProductIds.isEmpty
//                                 ? null
//                                 : _addSelectedToOrder,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 allProducts.isEmpty
//                     ? EmptyWidget(text: "noDataFound")
//                     : DynamicDataTable<ProductCategoryModel>(
//                         data: pagedProducts,
//                         isWithImage: true,
//                         combineImageWithTextIndex: 1,
//                         createByIndex: 3,
//                         columns: productHeaders,
//                         valueGetters: [
//                           (v) => v.sku ?? '',
//                           (v) => '${v.productName} , ${v.image}',
//                           (v) => units
//                               .firstWhere((brand) => brand.id == v.unitId)
//                               .name,
//                           (v) => v.createdBy ?? '',
//                         ],
//                         getId: (v) => v.id,
//                         selectedIds: selectedProductIds,
//                         onSelectChanged: (val, vendor) {
//                           setState(() {
//                             if (val == true) {
//                               selectedProductIds.add(vendor.id!);
//                             } else {
//                               selectedProductIds.remove(vendor.id);
//                             }
//                           });
//                         },
//                         onEdit: (product) {
//                           setState(() {
//                             showProductList = false;
//                             productBeingEdited = product;
//                           });
//                         },
//                         onStatus: (product) {},
//                         statusTextGetter: (item) =>
//                             item.status!.capitalizeFirst,
//                         onView: (product) {},
//                         onSelectAll: (val) {
//                           setState(() {
//                             final currentPageIds =
//                                 pagedProducts.map((e) => e.id!).toList();
//                             if (val == true) {
//                               selectedProductIds.addAll(currentPageIds);
//                             } else {
//                               selectedProductIds.removeAll(currentPageIds);
//                             }
//                           });
//                         },
//                         onSearch: (query) {
//                           setState(() {
//                             displayedProducts = allProducts
//                                 .where(
//                                   (product) => product.productName
//                                       .toLowerCase()
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
//                     totalItems: allProducts.length,
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
//         : AddProductPage(
//             isEdit: productBeingEdited != null,
//             productModel: productBeingEdited,
//             onBack: () async {
//               await _loadProducts();
//               setState(() {
//                 showProductList = true;
//                 productBeingEdited = null;
//               });
//             },
//           );
//   }
// }

class ProductCategoryList extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const ProductCategoryList({super.key, this.onNavigate});

  @override
  State<ProductCategoryList> createState() => _ProductCategoryListState();
}

class _ProductCategoryListState extends State<ProductCategoryList> {
  bool showProductList = true;
  bool isLoading = true;

  List<ProductCategoryModel> allProducts = [];
  List<ProductCategoryModel> displayedProducts = [];
  Map<String, String> userIdToName = {};

  ProductCategoryModel? productBeingEdited;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedProductIds = {};
  List<UnitModel> units = [];

  Future<void> _deleteSelectedProducts() async {
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedProductIds.length,
    );

    if (confirm != true) return;

    for (String productId in selectedProductIds) {
      await FirebaseFirestore.instance
          .collection('productsCategory')
          .doc(productId)
          .delete();
    }

    setState(() {
      selectedProductIds.clear();
    });

    // await _loadProducts();
  }

  final List<String> productHeaders = ['Product Name', 'Unit', 'Created By'];

  List<List<dynamic>> getProductRowsForExcel(
    List<ProductCategoryModel> products,
  ) {
    return products.map((p) {
      final unit = units.firstWhere(
        (u) => u.id == p.unitId,
        orElse: () => UnitModel(name: '', id: ''),
      );

      final createdByName = userIdToName[p.createdBy] ?? p.createdBy ?? '';

      return [p.productName, unit.name, createdByName];
    }).toList();
  }

  void getCategory(ProductCategoryModel model) {
    setState(() {
      showProductList = false;
      productBeingEdited = model;
    });
  }

  void _addSelectedToOrder() {
    final orderProvider = Provider.of<SellOrderProvider>(
      context,
      listen: false,
    );

    final selected = allProducts
        .where((p) => selectedProductIds.contains(p.id))
        .toList();

    orderProvider.addProducts(selected);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${selected.length} products added to order')),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> buildUserIdToNameMap(List<ProductCategoryModel> products) async {
    final userIds = products
        .map((p) => p.createdBy)
        .where((id) => id != null && id.isNotEmpty)
        .toSet();
    final snapshot = await FirebaseFirestore.instance
        .collection('profile')
        .where(FieldPath.documentId, whereIn: userIds.toList())
        .get();

    final Map<String, String> map = {
      for (var doc in snapshot.docs)
        doc.id: (doc.data()['fullName'] ?? 'Unknown') as String,
    };

    userIdToName = map;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, resource, child) {
        allProducts = resource.productCategoryList;
        return showProductList
            ? Column(
                children: [
                  PageHeaderWidget(
                    title: "Product Category List".tr(),
                    buttonText: "Add Product".tr(),
                    subTitle: "Manage your products category".tr(),
                    selectedItems: selectedProductIds.toList(),
                    buttonWidth: 0.24,
                    requiredPermission: 'Create Product Category',
                    onCreate: () {
                      setState(() {
                        showProductList = false;
                      });
                    },
                    onDelete: _deleteSelectedProducts,
                    onExelImport: () async {
                      await buildUserIdToNameMap(allProducts);
                      final rowsToExport = getProductRowsForExcel(allProducts);
                      await ExcelExporter.exportToExcel(
                        headers: productHeaders,
                        rows: rowsToExport,
                        fileNamePrefix: 'Product_Categories_Report',
                      );
                    },
                    onImport: () {},
                    onPdfImport: () async {
                      await buildUserIdToNameMap(allProducts);
                      final rowsToExport = getProductRowsForExcel(allProducts);
                      await PdfExporter.exportToPdf(
                        headers: productHeaders,
                        rows: rowsToExport,
                        fileNamePrefix: 'Product_Categories_Report',
                      );
                    },
                  ),
                  if (selectedProductIds.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Consumer<SellOrderProvider>(
                          builder: (context, p, child) {
                            return PrimaryButton(
                              label:
                                  'Add ${selectedProductIds.length} to Order',
                              onPressed: selectedProductIds.isEmpty
                                  ? null
                                  : _addSelectedToOrder,
                            );
                          },
                        ),
                      ),
                    ),
                  allProducts.isEmpty
                      ? EmptyWidget(
                          text: "There's no product category available",
                        )
                      : Expanded(
                          child: ProductCategoryCardListView(
                            productCategoriesList: allProducts,
                            selectedIds: selectedProductIds,
                            onEdit: getCategory,
                          ),
                        ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PaginationWidget(
                      currentPage: currentPage,
                      totalItems: allProducts.length,
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
            : AddProductPage(
                isEdit: productBeingEdited != null,
                productModel: productBeingEdited,
                onBack: () async {
                  // await _loadProducts();
                  setState(() {
                    showProductList = true;
                    productBeingEdited = null;
                  });
                },
              );
      },
    );
  }
}
