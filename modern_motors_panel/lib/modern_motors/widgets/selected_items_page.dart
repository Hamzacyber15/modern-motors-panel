// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:practice_erp/model/inventory_model.dart';
// import 'package:practice_erp/services/data_fetch.dart';
// import 'package:practice_erp/utils/pagination_widget.dart';
// import 'package:practice_erp/view/unit/extensions.dart';
// import 'package:provider/provider.dart';
//
// import '../../model/branch_model.dart';
// import '../../model/brand_model.dart';
// import '../../model/product_model.dart';
// import '../../model/sub_category_model.dart';
// import '../../model/unit_model.dart';
// import '../../model/vendor_model.dart';
// import '../../provider/selected_inventories_provider.dart';
// import '../../widgets/empty_list_widget.dart';
// import '../../widgets/page_header_widget.dart';
// import '../../widgets/reusable_data_table.dart';
//
// class SelectItemsPage extends StatefulWidget {
//   final SelectedInventoriesProvider provider;
//   final void Function(String page)? onNavigate;
//
//   const SelectItemsPage({super.key, this.onNavigate, required this.provider});
//
//   @override
//   State<SelectItemsPage> createState() => _SelectItemsPageState();
// }
//
// class _SelectItemsPageState extends State<SelectItemsPage> {
//   bool showInventoryList = true;
//   bool isLoading = true;
//   bool isAddInInvoice = false;
//
//   InventoryModel? inventoryBeingEdited;
//   List<InventoryModel> allInventories = [];
//   List<InventoryModel> displayedInventories = [];
//
//   List<BrandModel> brands = [];
//   List<ProductModel> productsCategories = [];
//   List<UnitModel> units = [];
//   List<ProductSu> subCategories = [];
//   List<BranchModel> branches = [];
//   List<VendorModel> vendors = [];
//
//   int currentPage = 0;
//   int itemsPerPage = 10;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadInventory();
//   }
//
//   Future<void> _loadInventory() async {
//     setState(() {
//       isLoading = true;
//     });
//     Future.wait([
//       DataFetchService.fetchInventory(),
//       DataFetchService.fetchUnits(),
//       DataFetchService.fetchProduct(),
//       DataFetchService.fetchSubCategories(),
//       DataFetchService.fetchBrands(),
//       DataFetchService.fetchBranches(),
//       DataFetchService.fetchVendor(),
//     ]).then((results) {
//       setState(() {
//         allInventories = results[0] as List<InventoryModel>;
//         displayedInventories = results[0] as List<InventoryModel>;
//         units = results[1] as List<UnitModel>;
//         productsCategories = results[2] as List<ProductModel>;
//         subCategories = results[3] as List<ProductSu>;
//         brands = results[4] as List<BrandModel>;
//         branches = results[5] as List<BranchModel>;
//         vendors = results[6] as List<VendorModel>;
//         isLoading = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final pagedItems =
//         displayedInventories
//             .skip(currentPage * itemsPerPage)
//             .take(itemsPerPage)
//             .toList();
//
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else {
//       return Consumer<SelectedInventoriesProvider>(
//         builder: (context, selectedInventories, child) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 PageHeaderWidget(
//                   title: 'Select Items'.tr(),
//                   buttonText: "Go Back".tr(),
//                   subTitle: "Pick Items for Invoice".tr(),
//                   onCreateIcon: 'assets/icons/back.png',
//                   selectedItems:
//                       selectedInventories.getSelectedInventoryIds.toList(),
//                   onCreate: () async {
//                     setState(() {
//                       // showInventoryList = false;
//                       widget.provider.setIsSelection(false);
//                     });
//                   },
//                   onAddInInvoice: () {
//                     widget.provider.setIsSelection(false);
//                   },
//                   buttonWidth: 0.28,
//                 ),
//
//                 allInventories.isEmpty
//                     ? EmptyListWidget(
//                       msg: "There's no Inventories available".tr(),
//                     )
//                     : DynamicDataTable<InventoryModel>(
//                       data: pagedItems,
//                       isWithImage: true,
//                       combineImageWithTextIndex: 0,
//
//                       columns: [
//                         'Product Name'.tr(),
//                         'Brand'.tr(),
//                         'Product Cat'.tr(),
//                         'Sub Category'.tr(),
//                         'Threshold'.tr(),
//                         'Total Item'.tr(),
//                         'Sale Price'.tr(),
//                         'Cost Price'.tr(),
//                         'Total Cost Price'.tr(),
//                         'Vendor'.tr(),
//                         'Create On'.tr(),
//                       ],
//                       valueGetters: [
//                         (v) => '${v.name} , ${v.image}',
//                         (v) =>
//                             brands
//                                 .firstWhere((brand) => brand.id == v.brandId)
//                                 .name,
//                         (v) =>
//                             productsCategories
//                                 .firstWhere((cat) => cat.id == v.productId)
//                                 .productName,
//                         (v) =>
//                             subCategories
//                                 .firstWhere((cat) => cat.id == v.subCategoryId)
//                                 .name,
//                         (v) => v.threshold.toString(),
//                         (v) => v.totalItem.toString(),
//                         (v) => v.salePrice.toString(),
//                         (v) => v.costPrice.toString(),
//                         (v) => v.totalCostPrice.toString(),
//                         (v) =>
//                             vendors
//                                 .firstWhere((cat) => cat.id == v.vendorId)
//                                 .vendorName,
//                         (v) => v.timestamp!.toDate().formattedWithDayMonthYear,
//                       ],
//                       getId: (v) => v.id,
//                       selectedIds: selectedInventories.getSelectedInventoryIds,
//                       onSelectChanged: (value, inventory) {
//                         if (value == true) {
//                           selectedInventories.addInventory(inventory);
//                         } else {
//                           selectedInventories.removeInventory(inventory);
//                         }
//                         setState(() {});
//                       },
//                       onEdit: (inventory) {
//                         setState(() {
//                           inventoryBeingEdited = inventory;
//                           showInventoryList = false;
//                         });
//                       },
//                       onStatus: (product) {},
//                       statusTextGetter: (item) => item.status!.capitalizeFirst,
//                       onView: (product) {},
//                       onSelectAll: (value) {
//                         if (value == true) {
//                           selectedInventories.removeAllInventory();
//                           selectedInventories.addAllInventory(pagedItems);
//                         } else {
//                           selectedInventories.removeAllInventory();
//                         }
//                       },
//                       onSearch: (query) {
//                         setState(() {
//                           displayedInventories =
//                               allInventories
//                                   .where(
//                                     (item) => item.name!.toLowerCase().contains(
//                                       query.toLowerCase(),
//                                     ),
//                                   )
//                                   .toList();
//                         });
//                       },
//                     ),
//
//                 displayedInventories.length > itemsPerPage
//                     ? Align(
//                       alignment: Alignment.center,
//                       child: PaginationWidget(
//                         currentPage: currentPage,
//                         totalItems: displayedInventories.length,
//                         itemsPerPage: itemsPerPage,
//                         onPageChanged: (newPage) {
//                           setState(() {
//                             currentPage = newPage;
//                           });
//                         },
//                         onItemsPerPageChanged: (newLimit) {
//                           setState(() {
//                             itemsPerPage = newLimit;
//                           });
//                         },
//                       ),
//                     )
//                     : const SizedBox.shrink(),
//               ],
//             ),
//           );
//         },
//       );
//     }
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/inventory_selection_bridge.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';

class SelectItemsPage extends StatefulWidget {
  final InventorySelectionBridge bridge;
  final void Function(String page)? onNavigate;

  const SelectItemsPage({super.key, required this.bridge, this.onNavigate});

  @override
  State<SelectItemsPage> createState() => _SelectItemsPageState();
}

class _SelectItemsPageState extends State<SelectItemsPage> {
  bool isLoading = true;

  List<InventoryModel> allInventories = [];
  List<InventoryModel> displayedInventories = [];

  List<BrandModel> brands = [];
  List<ProductModel> productsList = [];
  List<ProductModel> products = [];
  List<ProductCategoryModel> productsCategories = [];
  List<UnitModel> units = [];
  List<ProductSubCatorymodel> subCategories = [];
  List<BranchModel> branches = [];
  List<VendorModel> vendors = [];

  int currentPage = 0;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() => isLoading = true);
    final results = await Future.wait([
      DataFetchService.fetchInventory(),
      DataFetchService.fetchUnits(),
      DataFetchService.fetchProduct(),
      DataFetchService.fetchSubCategories(),
      DataFetchService.fetchBrands(),
      DataFetchService.fetchBranches(),
      DataFetchService.fetchVendor(),
      DataFetchService.fetchProducts(),
    ]);
    setState(() {
      allInventories = results[0] as List<InventoryModel>;
      displayedInventories = allInventories;
      units = results[1] as List<UnitModel>;
      productsCategories = results[2] as List<ProductCategoryModel>;
      subCategories = results[3] as List<ProductSubCatorymodel>;
      brands = results[4] as List<BrandModel>;
      branches = results[5] as List<BranchModel>;
      vendors = results[6] as List<VendorModel>;
      productsList = results[7] as List<ProductModel>;
      products.addAll(productsList);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = displayedInventories
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    if (isLoading) return const Center(child: CircularProgressIndicator());

    final p = widget.bridge;

    return SingleChildScrollView(
      child: Column(
        children: [
          PageHeaderWidget(
            title: 'Select Items'.tr(),
            buttonText: "Go Back".tr(),
            subTitle: "Pick Items".tr(),
            onCreateIcon: 'assets/images/back.png',
            selectedItems: p.selectedIds().toList(),
            onCreate: () => p.setIsSelection(false),
            // back
            onAddInInvoice: () => p.setIsSelection(false),
            // done
            buttonWidth: 0.28,
          ),
          allInventories.isEmpty
              ? EmptyWidget(text: "There's no Inventories available".tr())
              : DynamicDataTable<InventoryModel>(
                  data: pagedItems,
                  isWithImage: true,
                  combineImageWithTextIndex: 0,
                  columns: [
                    'Product Name'.tr(),
                    'Brand'.tr(),
                    'Product Cat'.tr(),
                    'Sub Category'.tr(),
                    'Threshold'.tr(),
                    'Total Item'.tr(),
                    'Sale Price'.tr(),
                    'Cost Price'.tr(),
                    'Total Cost Price'.tr(),
                    'Vendor'.tr(),
                    'Create On'.tr(),
                  ],
                  valueGetters: [
                    (v) =>
                        '${products.firstWhere((product) => product.id == v.productId).productName!} , ${products.firstWhere((product) => product.id == v.productId).image!}',
                    (v) => brands
                        .firstWhere(
                          (b) =>
                              b.id ==
                              products
                                  .firstWhere(
                                    (product) => product.id == v.productId,
                                  )
                                  .brandId,
                        )
                        .name,
                    (v) => productsCategories
                        .firstWhere(
                          (c) =>
                              c.id ==
                              products
                                  .firstWhere(
                                    (product) => product.id == v.productId,
                                  )
                                  .categoryId,
                        )
                        .productName,
                    (v) => subCategories
                        .firstWhere(
                          (s) =>
                              s.id ==
                              products
                                  .firstWhere(
                                    (product) => product.id == v.productId,
                                  )
                                  .subCategoryId,
                        )
                        .name,
                    (v) => products
                        .firstWhere((product) => product.id == v.productId)
                        .threshold
                        .toString(),
                    (v) => v.totalItem.toString(),
                    (v) => v.salePrice.toString(),
                    (v) => v.costPrice.toString(),
                    (v) => v.totalCostPrice.toString(),
                    (v) => vendors
                        .firstWhere((ven) => ven.id == v.vendorId)
                        .vendorName,
                    (v) => v.timestamp!.toDate().formattedWithDayMonthYear,
                  ],
                  getId: (v) => v.id,
                  selectedIds: p.selectedIds(),
                  onSelectChanged: (value, inv) {
                    if (value == true) {
                      p.add(
                        inv,
                        products.firstWhere(
                          (product) => product.id == inv.productId,
                        ),
                      );
                    } else {
                      p.remove(
                        inv,
                        products.firstWhere(
                          (product) => product.id == inv.productId,
                        ),
                      );
                    }
                    setState(() {});
                  },
                  onSelectAll: (value) {
                    if (value == true) {
                      p.clearAll();
                      p.addAll(pagedItems, products);
                    } else {
                      p.clearAll();
                    }
                    setState(() {});
                  },
                  onSearch: (query) {
                    setState(() {
                      displayedInventories = allInventories
                          .where(
                            (item) =>
                                (products
                                            .firstWhere(
                                              (product) =>
                                                  product.productName == query,
                                            )
                                            .id ??
                                        '')
                                    .toLowerCase()
                                    .contains(query.toLowerCase()),
                          )
                          .toList();
                    });
                  },
                ),
          displayedInventories.length > itemsPerPage
              ? Align(
                  alignment: Alignment.center,
                  child: PaginationWidget(
                    currentPage: currentPage,
                    totalItems: displayedInventories.length,
                    itemsPerPage: itemsPerPage,
                    onPageChanged: (newPage) {
                      setState(() => currentPage = newPage);
                    },
                    onItemsPerPageChanged: (newLimit) {
                      setState(() => itemsPerPage = newLimit);
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
