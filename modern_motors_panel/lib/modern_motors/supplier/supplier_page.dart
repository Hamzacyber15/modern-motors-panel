import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/price/price_item.dart';
import 'package:modern_motors_panel/model/supplier/supplier_model.dart';
import 'package:modern_motors_panel/modern_motors/customers/add_payment_credit_page.dart';
import 'package:modern_motors_panel/modern_motors/customers/addopeningbalance.dart';
import 'package:modern_motors_panel/modern_motors/supplier/add_edit_supplier.dart';
import 'package:modern_motors_panel/modern_motors/transactions/transaction_item.dart';
import 'package:modern_motors_panel/modern_motors/transactions/transaction_tab.dart';
import 'package:modern_motors_panel/modern_motors/widgets/top_tab.dart';
import 'package:modern_motors_panel/modern_motors/widgets/top_tab_dropdown.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class SupplierPage extends StatefulWidget {
  final SupplierModel? supplierModel;

  const SupplierPage({super.key, this.supplierModel});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  String? selectedOption;
  DropdownItem? selectedPaymentMethod;
  DropdownItem? selectedExportMethod;
  String bottomTabs = 'Details';
  List<DropdownItem> paymentMethods = [];
  bool isUpdated = false;

  @override
  void initState() {
    initializePaymentMethodList();
    super.initState();
  }

  final exportMethods = [
    DropdownItem(label: 'Excel', icon: Icons.document_scanner_sharp),
    DropdownItem(label: 'PDF', icon: Icons.picture_as_pdf),
  ];

  void initializePaymentMethodList() {
    paymentMethods = [
      DropdownItem(
        label: 'Add Opening Balance',
        icon: Icons.money,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPaymentCreditPage()),
          );
        },
      ),
      DropdownItem(label: 'Add Work Order', icon: Icons.credit_card),
      DropdownItem(label: 'Login as Client', icon: Icons.lock_outlined),
      DropdownItem(label: 'Suspend', icon: Icons.pause_circle_filled),
      DropdownItem(label: 'Delete Client', icon: Icons.delete),
      DropdownItem(
        label: 'Clone ',
        icon: Icons.copy,
        onTap: () {
          onEdit(true);
        },
      ),
    ];
  }

  void onEdit(bool isClone) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditSupplier(
          isEdit: true,
          supplierModel: widget.supplierModel,
          isClone: isClone,
          onBack: () {},
          from: 'detailed',
        ),
      ),
    );
    if (result == 'customer_added') {
      isUpdated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            isUpdated
                ? Navigator.pop(context, 'updated')
                : Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: context.width * 0.9,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border(
                    right: borderSide(),
                    top: borderSide(),
                    left: borderSide(),
                  ),
                ),
                child: Row(
                  children: [
                    topTab(
                      onTap: () {
                        onEdit(false);
                      },
                      icon: Icons.edit,
                      title: 'Edit',
                    ),
                    topTab(
                      onTap: () {},
                      icon: Icons.money,
                      title: 'Create Invoices',
                    ),
                    topTab(
                      onTap: () {},
                      icon: Icons.money,
                      title: 'Create Estimate',
                    ),
                    topTab(
                      onTap: () {},
                      icon: Icons.money,
                      title: 'Create Credit Note',
                    ),
                    topTab(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AddOpeningBalance(customer: widget.supplierModel,),
                        //   ),
                        // );
                      },
                      icon: Icons.calculate,
                      // title: 'Opening Balance',
                      title: 'Statement',
                    ),

                    topTab(
                      onTap: () {},
                      icon: Icons.money,
                      title: 'Add Payment Credit',
                    ),
                    topTabDropdown(
                      title: 'Payment Method',
                      items: paymentMethods,
                      selectedValue: selectedPaymentMethod,
                      onChanged: (val) {
                        setState(() {
                          selectedPaymentMethod = val;
                        });
                        final selectedItem = paymentMethods.firstWhere(
                          (e) => e.label == val?.label,
                        );
                        selectedItem.onTap?.call();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: context.width * 0.9,
                  child: Column(
                    children: [
                      10.h,
                      SizedBox(
                        width: context.width * 0.77,
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                bottomTabs = 'Details';
                                setState(() {});
                              },
                              child: Text('Details'),
                            ),
                            10.w,
                            TextButton(
                              onPressed: () {
                                bottomTabs = 'Payment';
                                setState(() {});
                              },
                              child: Text('Payment'),
                            ),
                            10.w,
                            TextButton(
                              onPressed: () {
                                bottomTabs = 'Transaction';
                                setState(() {});
                              },
                              child: Text('Transaction List'),
                            ),
                            10.w,
                            TextButton(
                              onPressed: () {
                                bottomTabs = 'Timeline';
                                setState(() {});
                              },
                              child: Text('Timeline'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            width: context.width * 0.75,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderColor),
                            ),
                            child: SingleChildScrollView(
                              child: tabsGetter(
                                bottomTabs,
                                context: context,
                                exportMethods: exportMethods,
                                selectedExportMethod: selectedExportMethod,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

BorderSide borderSide({Color? color}) {
  return BorderSide(color: color ?? Colors.white);
}

class DropdownItem {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  DropdownItem({required this.label, required this.icon, this.onTap});
}

// Widget topTabDropdown({
//   required String title,
//   required List<DropdownItem> items,
//   required DropdownItem? selectedValue,
//   required ValueChanged<DropdownItem?> onChanged,
//   Color? color,
// }) {
//   return Container(
//     height: color == null ? 28 : 33,
//     padding: const EdgeInsets.symmetric(horizontal: 8),
//     decoration: BoxDecoration(
//       border: Border.all(
//         color: color == null ? AppTheme.borderColor : Colors.transparent,
//       ),
//       color: color ?? Colors.white,
//     ),
//     child: Row(
//       children: [
//         if (color != null) ...[
//           Icon(Icons.downloading_rounded, color: Colors.white, size: 16),
//           2.w,
//         ],
//         DropdownButton<DropdownItem>(
//           value: selectedValue,
//           hint: Text(
//             title,
//             style: TextStyle(
//               fontSize: 13,
//               color: color == null ? Colors.black : Colors.white,
//             ),
//           ),
//           underline: const SizedBox(),
//           isDense: true,
//           isExpanded: false,
//           icon: Icon(
//             Icons.arrow_drop_down,
//             size: 16,
//             color: color == null ? Colors.black : Colors.white,
//           ),
//           dropdownColor: Colors.white,
//           style: TextStyle(
//             color: color == null ? Colors.black : Colors.white,
//             fontSize: 13,
//           ),
//           items: items.map((DropdownItem item) {
//             return DropdownMenuItem<DropdownItem>(
//               value: item,
//               child: Row(
//                 children: [
//                   Icon(item.icon, size: 14, color: Colors.black),
//                   const SizedBox(width: 6),
//                   Text(
//                     item.label,
//                     style: TextStyle(fontSize: 13, color: Colors.black),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//           onChanged: onChanged,
//         ),
//       ],
//     ),
//   );
// }

Widget tabsGetter(
  String tab, {
  required BuildContext context,
  required List<DropdownItem> exportMethods,
  DropdownItem? selectedExportMethod,
}) {
  switch (tab) {
    case 'Details':
      return detailsTab(context);
    case 'Payment':
      return Text('Payment');

    case 'Transaction':
      return TransactionTab(
        exportMethods: exportMethods,
        selectedExportMethod: selectedExportMethod,
      );

    case 'Timeline':
      return Text('Timeline');

    default:
      return const SizedBox(); // fallback
  }
}

Widget detailsTab(BuildContext context) {
  ConnectivityResult connectionStatus = context
      .watch<ConnectivityProvider>()
      .connectionStatus;
  return Column(
    children: [
      Row(
        children: [
          Text(
            'Country Code',
            style: AppTheme.getCurrentTheme(
              false,
              connectionStatus,
            ).textTheme.headlineSmall!.copyWith(color: AppTheme.primaryColor),
          ),
          (context.width * 0.1).dw,
          Text(
            'OM',
            style: AppTheme.getCurrentTheme(
              false,
              connectionStatus,
            ).textTheme.headlineSmall!.copyWith(color: Colors.black),
          ),
        ],
      ),
    ],
  );
}

final transactions = [
  TransactionItem(
    date: '08/10/2025',
    transaction: 'Invoice #1234',
    amount: '15.000',
    balanceDue: '5.000',
    priceItems: [
      PriceItem(priceQty: '5 × 2', item: 'Wrench Set', total: '10.000'),
      PriceItem(priceQty: '1 × 5', item: 'Gloves', total: '5.000'),
    ],
  ),
  TransactionItem(
    date: '09/10/2025',
    transaction: 'Invoice #5678',
    amount: '20.000',
    balanceDue: '0.000',
    priceItems: [
      PriceItem(priceQty: '2 × 3', item: 'Drill Machine', total: '6.000'),
      PriceItem(priceQty: '1 × 14', item: 'Cement Bags', total: '14.000'),
    ],
  ),
];
