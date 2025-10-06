import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:modern_motors_panel/modern_motors/billing/create_bill.dart';
import 'package:modern_motors_panel/modern_motors/excel/excel_exporter.dart';
import 'package:modern_motors_panel/modern_motors/inventory/add_inventory_page.dart';
import 'package:modern_motors_panel/modern_motors/pdf/pdf_exporter.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/delete_helper.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/reusable_data_table.dart';
import 'package:modern_motors_panel/provider/selected_inventories_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const InventoryPage({super.key, this.onNavigate});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool showInventoryList = true;
  bool isLoading = true;
  bool isAddInInvoice = false;

  InventoryModel? inventoryBeingEdited;
  List<InventoryModel> allInventories = [];
  List<InventoryModel> displayedInventories = [];

  List<BrandModel> brands = [];
  List<ProductModel> products = [];
  List<ProductCategoryModel> productsCategories = [];
  List<UnitModel> units = [];
  List<ProductSubCatorymodel> subCategories = [];
  List<BranchModel> branches = [];
  List<VendorModel> vendors = [];

  final headers = [
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
  ];

  List<List<dynamic>> getRowsForExcel(List<InventoryModel> inventories) {
    return inventories.map((v) {
      final brand = brands.firstWhere(
        (b) =>
            b.id ==
            products.firstWhere((product) => product.id == v.productId).brandId,
        orElse: () => BrandModel(name: ''),
      );

      final product = products.firstWhere((p) => p.id == v.productId);

      final category = productsCategories.firstWhere(
        (p) => p.id == product.categoryId,
        orElse: () => ProductCategoryModel(productName: ''),
      );
      final subCat = subCategories.firstWhere(
        (s) =>
            s.id ==
            products
                .firstWhere((product) => product.id == product.subCategoryId)
                .subCategoryId,
        orElse: () => ProductSubCatorymodel(name: ''),
      );
      final vendor = vendors.firstWhere(
        (ven) => ven.id == v.vendorId,
        orElse: () => VendorModel(vendorName: ''),
      );

      return [
        product.productName,
        brand.name,
        product.productName,
        subCat.name,
        product.threshold ?? '',
        v.totalItem,
        v.salePrice,
        v.costPrice,
        v.totalCostPrice,
        vendor.vendorName,
        v.timestamp?.toDate().formattedWithDayMonthYear ?? '',
      ];
    }).toList();
  }

  int currentPage = 0;
  int itemsPerPage = 10;

  Future<void> _deleteSelectedItems() async {
    final provider = context.read<SelectedInventoriesProvider>();
    final selectedIds = provider.getSelectedInventoryIds.toList();
    final confirm = await DeleteDialogHelper.showDeleteConfirmation(
      context,
      selectedIds.length,
    );

    if (confirm != true) return;

    for (String id in selectedIds) {
      await FirebaseFirestore.instance.collection('inventory').doc(id).delete();
    }

    provider.removeAllInventory();
    // setState(() {
    //   selectedInventoryIds.clear();
    // });

    await _loadInventory();
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<SelectedInventoriesProvider>();
    provider.clearData();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() {
      isLoading = true;
    });
    Future.wait([
      DataFetchService.fetchInventory(),
      DataFetchService.fetchUnits(),
      DataFetchService.fetchProduct(),
      DataFetchService.fetchSubCategories(),
      DataFetchService.fetchBrands(),
      DataFetchService.fetchBranches(),
      DataFetchService.fetchVendor(),
      DataFetchService.fetchProducts(),
    ]).then((results) {
      setState(() {
        allInventories = results[0] as List<InventoryModel>;
        displayedInventories = results[0] as List<InventoryModel>;
        units = results[1] as List<UnitModel>;
        productsCategories = results[2] as List<ProductCategoryModel>;
        subCategories = results[3] as List<ProductSubCatorymodel>;
        brands = results[4] as List<BrandModel>;
        branches = results[5] as List<BranchModel>;
        vendors = results[6] as List<VendorModel>;
        products = results[7] as List<ProductModel>;
        debugPrint('allInventories $allInventories');
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    final provider = context.read<SelectedInventoriesProvider>();
    provider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = displayedInventories
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Consumer<SelectedInventoriesProvider>(
        builder: (context, selectedInventories, child) {
          if (isAddInInvoice) {
            return CreateBill(
              onBack: () async {
                await _loadInventory();
                setState(() {
                  isAddInInvoice = false;
                });
              },
            );
          } else {
            if (showInventoryList) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    PageHeaderWidget(
                      title: 'Inventory'.tr(),
                      buttonText: "Create Inventory".tr(),
                      subTitle: "Manage your Inventories".tr(),
                      importButtonText: 'Import Inventory'.tr(),
                      selectedItems: selectedInventories.getSelectedInventoryIds
                          .toList(),
                      onCreate: () async {
                        setState(() {
                          showInventoryList = false;
                        });
                      },
                      buttonWidth: 0.28,
                      onDelete: _deleteSelectedItems,
                      onExelImport: () async {
                        final rowsToExport = getRowsForExcel(pagedItems);
                        await ExcelExporter.exportToExcel(
                          headers: headers,
                          rows: rowsToExport,
                          fileNamePrefix: 'Inventory_Report',
                        );
                      },
                      onImport: () {},
                      onPdfImport: () async {
                        final rowsToExport = getRowsForExcel(pagedItems);
                        await PdfExporter.exportToPdf(
                          headers: headers,
                          rows: rowsToExport,
                          fileNamePrefix: "Inventory_Report",
                        );
                      },
                    ),
                    allInventories.isEmpty
                        ? EmptyWidget(
                            text: "There's no Inventories available".tr(),
                          )
                        : DynamicDataTable<InventoryModel>(
                            data: pagedItems,
                            isWithImage: true,
                            combineImageWithTextIndex: 0,
                            columns: headers,
                            valueGetters: [
                              (v) =>
                                  '${products.firstWhere((product) => product.id == v.productId).productName!} , ${products.firstWhere((product) => product.id == v.productId).image!}',
                              // (v) => '${v.name} , ${v.image}',
                              (v) => brands
                                  .firstWhere(
                                    (brand) =>
                                        brand.id ==
                                        products
                                            .firstWhere(
                                              (product) =>
                                                  product.id == v.productId,
                                            )
                                            .brandId,
                                  )
                                  .name,
                              (v) => productsCategories
                                  .firstWhere(
                                    (cat) =>
                                        cat.id ==
                                        products
                                            .firstWhere(
                                              (product) =>
                                                  product.id == v.productId,
                                            )
                                            .categoryId,
                                  )
                                  .productName,
                              (v) => subCategories
                                  .firstWhere(
                                    (cat) =>
                                        cat.id ==
                                        products
                                            .firstWhere(
                                              (product) =>
                                                  product.id == v.productId,
                                            )
                                            .subCategoryId,
                                  )
                                  .name,
                              (v) => products
                                  .firstWhere(
                                    (product) => product.id == v.productId,
                                  )
                                  .threshold
                                  .toString(),
                              (v) => v.totalItem.toString(),
                              (v) => v.salePrice.toString(),
                              (v) => v.costPrice.toString(),
                              (v) => v.totalCostPrice.toString(),
                              (v) => vendors
                                  .firstWhere((cat) => cat.id == v.vendorId)
                                  .vendorName,
                              (v) => v.timestamp!
                                  .toDate()
                                  .formattedWithDayMonthYear,
                            ],
                            getId: (v) => v.id,
                            selectedIds:
                                selectedInventories.getSelectedInventoryIds,
                            onSelectChanged: (value, inventory) {
                              if (value == true) {
                                selectedInventories.addInventory(
                                  inventory,
                                  products.firstWhere(
                                    (product) =>
                                        product.id == inventory.productId,
                                  ),
                                );
                                // selectedInventory.add(inventory);
                                // selectedInventoryIds.add(inventory.id!);
                                // debugPrint(
                                //   'selectedInventory: ${selectedInventory.length}',
                                // );
                              } else {
                                selectedInventories.removeInventory(
                                  inventory,
                                  products.firstWhere(
                                    (product) =>
                                        product.id == inventory.productId,
                                  ),
                                );
                                // selectedInventoryIds.remove(inventory.id);
                                //
                                // selectedInventory.removeWhere(
                                //       (item) => item.id == inventory.id,
                                // );

                                debugPrint(
                                  'selectedInventory: ${selectedInventories.getSelectedInventory.length}',
                                );
                                debugPrint(
                                  'selectedInventoryIds: ${selectedInventories.getSelectedInventoryIds.length}',
                                );
                              }
                              setState(() {
                                // if (value == true) {
                                //   selectedInventories.setInventory(inventory);
                                //   // selectedInventory.add(inventory);
                                //   // selectedInventoryIds.add(inventory.id!);
                                //   // debugPrint(
                                //   //   'selectedInventory: ${selectedInventory.length}',
                                //   // );
                                // }
                                // else {
                                //   selectedInventoryIds.remove(inventory.id);
                                //
                                //   selectedInventory.removeWhere(
                                //         (item) => item.id == inventory.id,
                                //   );
                                //
                                //   debugPrint(
                                //     'selectedInventory: ${selectedInventory.length}',
                                //   );
                                //   debugPrint(
                                //     'selectedInventoryIds: ${selectedInventoryIds.length}',
                                //   );
                                // }
                              });
                            },
                            onEdit: (inventory) {
                              setState(() {
                                inventoryBeingEdited = inventory;
                                showInventoryList = false;
                              });
                            },
                            onStatus: (product) {},
                            statusTextGetter: (item) =>
                                item.status!.capitalizeFirst,
                            onView: (product) {},
                            onSelectAll: (value) {
                              if (value == true) {
                                selectedInventories.removeAllInventory();
                                selectedInventories.addAllInventory(
                                  pagedItems,
                                  products,
                                );
                              } else {
                                selectedInventories.removeAllInventory();
                              }
                              // setState(() {
                              //   selectedInventory.clear();
                              //   final currentPageIds =
                              //   pagedItems.map((e) => e.id!).toList();
                              //   if (value == true) {
                              //     selectedInventoryIds.addAll(currentPageIds);
                              //     selectedInventory.addAll(pagedItems);
                              //   } else {
                              //     selectedInventoryIds.removeAll(currentPageIds);
                              //     selectedInventory.clear();
                              //   }
                              // });
                            },
                            onSearch: (query) {
                              setState(() {
                                // displayedInventories =
                                //     allInventories
                                //         .where(
                                //           (item) => item.name!
                                //               .toLowerCase()
                                //               .contains(query.toLowerCase()),
                                //         )
                                //         .toList();
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
                ),
              );
            } else {
              return AddInventoryPage(
                isEdit: inventoryBeingEdited != null,
                inventoryModel: inventoryBeingEdited,
                onBack: () async {
                  await _loadInventory();
                  setState(() {
                    showInventoryList = true;
                    inventoryBeingEdited = null;
                  });
                },
              );
            }
          }
        },
      );
    }
  }
}
