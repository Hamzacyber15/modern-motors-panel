import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/summary_row.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/selected_inventories_provider.dart';
import 'package:provider/provider.dart';

// Widget buildProductListSection(
//   BuildContext context,
//   SelectedInventoriesProvider provider,
// ) {
//   ConnectivityResult connectionStatus =
//       context.watch<ConnectivityProvider>().connectionStatus;
//   return Container(
//     padding: EdgeInsets.all(12),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(14),
//       color: AppTheme.whiteColor,
//       border: Border.all(color: AppTheme.borderColor),
//     ),
//     child: provider.getSelectedInventory.isEmpty
//         ? SizedBox(
//             height: context.height * 0.4,
//             child: CustomButton(
//               backgroundColor: Colors.transparent,
//               textColor: AppTheme.primaryColor,
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               onPressed: () {
//                 provider.setIsSelection(true);
//               },
//               text: 'Add Items',
//             ),
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   provider.setIsSelection(true);
//                 },
//                 child: Text(
//                   'Add',
//                   style: AppTheme.getCurrentTheme(false, connectionStatus)
//                       .textTheme
//                       .displaySmall!
//                       .copyWith(color: AppTheme.primaryColor),
//                 ),
//               ),
//               const Divider(),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       'Products',
//                       style: Theme.of(
//                         context,
//                       ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       'Price/Item',
//                       style: Theme.of(
//                         context,
//                       ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       'Total Price',
//                       style: Theme.of(
//                         context,
//                       ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       'Quantity',
//                       style: Theme.of(
//                         context,
//                       ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                     ),
//                   ),
//                   SizedBox(width: 30),
//                 ],
//               ),
//               const Divider(),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: provider.getSelectedInventory.length,
//                 itemBuilder: (context, index) {
//                   final product = provider.getSelectedInventory[index];

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 3,
//                               child: Row(
//                                 children: [
//                                   Image.asset(
//                                     'assets/images/userimg.png',
//                                     height: 50,
//                                     width: 50,
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Flexible(child: Text(product.name!)),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 provider.getInvoiceModelValue.items![index]
//                                     .perItemPrice
//                                     .toStringAsFixed(2),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 provider.getInvoiceModelValue.items![index]
//                                     .totalPrice
//                                     .toStringAsFixed(2),
//                               ),
//                             ),
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.remove),
//                                     onPressed: () => provider.decreaseQuantity(
//                                       index: index,
//                                       context: context,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${provider.getInvoiceModelValue.items![index].quantity}',
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.add),
//                                     onPressed: () => provider.increaseQuantity(
//                                       index: index,
//                                       context: context,
//                                       inventory: product,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 provider.removeInventory(
//                                   provider.getSelectedInventory[index],
//                                 );
//                               },
//                               icon: const Icon(Icons.delete),
//                             ),
//                           ],
//                         ),
//                         Divider(),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               SummaryRow(label: 'Items total', value: provider.itemsTotal),
//               const Divider(),
//             ],
//           ),
//   );
// }

// class SelectedItemsList extends StatelessWidget {
//   const SelectedItemsList({
//     super.key,
//     required this.contextHeight,
//     required this.selectedInventory,
//     required this.lines, // List<ItemsModel> (qty/price/total)
//     required this.itemsTotal,
//     required this.onAddItems,
//     required this.onIncreaseQty,
//     required this.onDecreaseQty,
//     required this.onRemoveItem,
//   });

//   final double contextHeight;
//   final List<InventoryModel> selectedInventory;
//   final List<ItemsModel> lines;
//   final double itemsTotal;

//   final VoidCallback onAddItems;
//   final void Function(int index, InventoryModel inv) onIncreaseQty;
//   final void Function(int index) onDecreaseQty;
//   final void Function(int index) onRemoveItem;

//   @override
//   Widget build(BuildContext context) {
//     final isEmpty = selectedInventory.isEmpty;
//     ConnectivityResult connectionStatus =
//         context.watch<ConnectivityProvider>().connectionStatus;
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         color: AppTheme.whiteColor,
//         border: Border.all(color: AppTheme.borderColor),
//       ),
//       child: isEmpty
//           ? SizedBox(
//               height: contextHeight * 0.4,
//               child: CustomButton(
//                 backgroundColor: Colors.transparent,
//                 textColor: AppTheme.primaryColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 onPressed: onAddItems,
//                 text: 'Add Items',
//               ),
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: onAddItems,
//                   child: Text(
//                     'Add',
//                     style: AppTheme.getCurrentTheme(false, connectionStatus)
//                         .textTheme
//                         .displaySmall!
//                         .copyWith(color: AppTheme.primaryColor),
//                   ),
//                 ),
//                 const Divider(),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Text(
//                         'Products',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Price/Item',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Total Price',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Quantity',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     const SizedBox(width: 30),
//                   ],
//                 ),
//                 const Divider(),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: selectedInventory.length,
//                   itemBuilder: (context, index) {
//                     final inv = selectedInventory[index];
//                     final line = lines[index];

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 3,
//                                 child: Row(
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/userimg.png',
//                                       height: 50,
//                                       width: 50,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Flexible(child: Text(inv.name ?? '')),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   line.perItemPrice.toStringAsFixed(2),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   line.totalPrice.toStringAsFixed(2),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.remove),
//                                       onPressed: () => onDecreaseQty(index),
//                                     ),
//                                     Text('${line.quantity}'),
//                                     IconButton(
//                                       icon: const Icon(Icons.add),
//                                       onPressed: () =>
//                                           onIncreaseQty(index, inv),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () => onRemoveItem(index),
//                                 icon: const Icon(Icons.delete),
//                               ),
//                             ],
//                           ),
//                           const Divider(),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 SummaryRow(label: 'Items total', value: itemsTotal),
//                 const Divider(),
//               ],
//             ),
//     );
//   }
// }

Widget buildProductListSection(
  BuildContext context,
  SelectedInventoriesProvider provider,
) {
  ConnectivityResult connectionStatus = context
      .watch<ConnectivityProvider>()
      .connectionStatus;
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: AppTheme.whiteColor,
      border: Border.all(color: AppTheme.borderColor),
    ),
    child: provider.getSelectedInventory.isEmpty
        ? SizedBox(
            height: context.height * 0.1,
            child: CustomButton(
              backgroundColor: Colors.transparent,
              textColor: AppTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              onPressed: () {
                provider.setIsSelection(true);
              },
              text: 'Add Items',
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  provider.setIsSelection(true);
                },
                child: Text(
                  'Add',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: AppTheme.primaryColor),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Products',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Price/Item',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Total Price',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Quantity',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 30),
                ],
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.getSelectedInventory.length,
                itemBuilder: (context, index) {
                  final inventory = provider.getSelectedInventory[index];
                  final product = provider.productsList[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/userimg.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(child: Text(product.productName!)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                provider
                                    .getInvoiceModelValue
                                    .items![index]
                                    .perItemPrice
                                    .toStringAsFixed(2),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                provider
                                    .getInvoiceModelValue
                                    .items![index]
                                    .totalPrice
                                    .toStringAsFixed(2),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => provider.decreaseQuantity(
                                      index: index,
                                      context: context,
                                    ),
                                  ),
                                  Text(
                                    '${provider.getInvoiceModelValue.items![index].quantity}',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => provider.increaseQuantity(
                                      index: index,
                                      context: context,
                                      inventory: inventory,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                provider.removeInventory(
                                  provider.getSelectedInventory[index],
                                  provider.productsList[index],
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
              SummaryRow(label: 'Items total', value: provider.itemsTotal),
              const Divider(),
            ],
          ),
  );
}

//
// Widget buildProductListSectionForGarage(
//   BuildContext context,
//   MaintenanceBookingProvider provider,
// ) {
//   return Container(
//     padding: EdgeInsets.all(12),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(14),
//       color: AppTheme.whiteColor,
//       border: Border.all(color: AppTheme.borderColor),
//     ),
//     child:
//         provider.getSelectedInventory.isEmpty
//             ? SizedBox(
//               height: context.height * 0.4,
//               child: CustomButton(
//                 backgroundColor: Colors.transparent,
//                 textColor: AppTheme.primaryColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 onPressed: () {
//                   provider.setIsSelection(true);
//                 },
//                 text: 'Add Items',
//               ),
//             )
//             : Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     provider.setIsSelection(true);
//                   },
//                   child: Text(
//                     'Add',
//                     style: AppTheme.getCurrentTheme().textTheme.displaySmall!
//                         .copyWith(color: AppTheme.primaryColor),
//                   ),
//                 ),
//                 const Divider(),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Text(
//                         'Products',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Price/Item',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Total Price',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Quantity',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.titleLarge?.copyWith(fontSize: 14),
//                       ),
//                     ),
//                     SizedBox(width: 30),
//                   ],
//                 ),
//                 const Divider(),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: provider.getSelectedInventory.length,
//                   itemBuilder: (context, index) {
//                     final product = provider.getSelectedInventory[index];
//
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 3,
//                                 child: Row(
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/userimg.png',
//                                       height: 50,
//                                       width: 50,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Flexible(child: Text(product.name!)),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   provider
//                                       .getInvoiceModelValue
//                                       .items![index]
//                                       .perItemPrice
//                                       .toStringAsFixed(2),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   provider
//                                       .getInvoiceModelValue
//                                       .items![index]
//                                       .totalPrice
//                                       .toStringAsFixed(2),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.remove),
//                                       onPressed:
//                                           () => provider.decreaseQuantity(
//                                             index: index,
//                                             context: context,
//                                           ),
//                                     ),
//                                     Text(
//                                       '${provider.getInvoiceModelValue.items![index].quantity}',
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.add),
//                                       onPressed:
//                                           () => provider.increaseQuantity(
//                                             index: index,
//                                             context: context,
//                                             inventory: product,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   provider.removeInventory(
//                                     provider.getSelectedInventory[index],
//                                   );
//                                 },
//                                 icon: const Icon(Icons.delete),
//                               ),
//                             ],
//                           ),
//                           Divider(),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 SummaryRow(label: 'Items total', value: provider.itemsTotal),
//                 const Divider(),
//               ],
//             ),
//   );
// }

class SelectedItemsList extends StatelessWidget {
  final double contextHeight;
  final List<InventoryModel> selectedInventory;
  final List<ProductModel> selectedProducts;
  final List<ItemsModel> lines;
  final double itemsTotal;

  final VoidCallback onAddItems;
  final void Function(int index, InventoryModel inv) onIncreaseQty;
  final void Function(int index) onDecreaseQty;
  final void Function(int index) onRemoveItem;

  const SelectedItemsList({
    super.key,
    required this.contextHeight,
    required this.selectedInventory,
    required this.selectedProducts,
    required this.lines, // List<ItemsModel> (qty/price/total)
    required this.itemsTotal,
    required this.onAddItems,
    required this.onIncreaseQty,
    required this.onDecreaseQty,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = selectedInventory.isEmpty;
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppTheme.whiteColor,
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: isEmpty
          ? SizedBox(
              height: contextHeight * 0.1,
              child: CustomButton(
                backgroundColor: Colors.transparent,
                textColor: AppTheme.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                onPressed: onAddItems,
                text: 'Add Items',
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onAddItems,
                  child: Text(
                    'Add',
                    style: AppTheme.getCurrentTheme(false, connectionStatus)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: AppTheme.primaryColor),
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Products',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Price/Item',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Total Price',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Quantity',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedInventory.length,
                  itemBuilder: (context, index) {
                    final inv = selectedInventory[index];
                    final product = selectedProducts.firstWhere(
                      (product) => product.id == inv.productId,
                    );
                    final line = lines[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Image.network(
                                      product.image!,
                                      height: 50,
                                      width: 50,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(product.productName ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  line.perItemPrice.toStringAsFixed(2),
                                ),
                              ),
                              Expanded(
                                child: Text(line.totalPrice.toStringAsFixed(2)),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => onDecreaseQty(index),
                                    ),
                                    Text('${line.quantity}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () =>
                                          onIncreaseQty(index, inv),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => onRemoveItem(index),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
                SummaryRow(label: 'Items total', value: itemsTotal),
                const Divider(),
              ],
            ),
    );
  }
}
