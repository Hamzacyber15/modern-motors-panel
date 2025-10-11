// // // ignore_for_file: deprecated_member_use

// // import 'package:app/admin/admin_dasboard.dart';
// // import 'package:app/constants.dart';
// // import 'package:app/erp/hr/roles_main_page.dart';
// // import 'package:app/modern_motors/branch/branches_page.dart';
// // import 'package:app/modern_motors/customers/customers_main_page.dart';
// // import 'package:app/modern_motors/employees/employee_page.dart';
// // import 'package:app/modern_motors/estimations/manage_estimations.dart';
// // import 'package:app/modern_motors/inventory/inventory_page.dart';
// // import 'package:app/modern_motors/inventory_trucks/inventory_trucks.dart';
// // import 'package:app/modern_motors/inventory_trucks/manage_truck_inventory.dart';
// // import 'package:app/modern_motors/invoices/manage_invoices.dart';
// // import 'package:app/modern_motors/invoices/sales_screen.dart';
// // import 'package:app/modern_motors/invoices/test_create_invoice.dart';
// // import 'package:app/modern_motors/products/manage_products.dart';
// // import 'package:app/modern_motors/products/products_category_list.dart';
// // import 'package:app/modern_motors/products/sub_category/sub_category_page.dart';
// // import 'package:app/modern_motors/purchase/grn/goods_receive_notes.dart';
// // import 'package:app/modern_motors/purchase/purchase_orders.dart';
// // import 'package:app/modern_motors/purchase/purchase_requisition.dart';
// // import 'package:app/modern_motors/purchase/qoutations.dart';
// // import 'package:app/modern_motors/services_maintenance/service_booking.dart';
// // import 'package:app/modern_motors/services_maintenance/services_main_page.dart';
// // import 'package:app/modern_motors/units/unit_main_page.dart';
// // import 'package:app/modern_motors/vendor/vendor_page.dart';
// // import 'package:app/modern_motors/widgets/ChartOfAccountsScreen.dart';
// // import 'package:app/modern_motors/widgets/country/country_main_page.dart';
// // import 'package:app/modern_motors/widgets/currency/currency_main_page.dart';
// // import 'package:app/registration/sign_in.dart';
// // import 'package:app/widgets/brands/brands_page.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class MmAdminMainPage extends StatefulWidget {
// //   const MmAdminMainPage({super.key});

// //   @override
// //   State<MmAdminMainPage> createState() => _MmAdminMainPageState();
// // }

// // class _MmAdminMainPageState extends State<MmAdminMainPage> {
// //   int _selectedIndex = 0;
// //   bool _isSidebarCollapsed = false;
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //   String _selectedCompany = 'Modern Motors';
// //   String language = "";
// //   String selectedLanguage = "";

// //   // Expansion tile states
// //   final Map<String, bool> _expansionStates = {
// //     'users': false,
// //     'products': false,
// //     'analytics': false,
// //   };

// //   void logout() async {
// //     FirebaseAuth.instance.signOut().then((value) async {
// //       // ignore: await_only_futures
// //       signOut();
// //     }).catchError((onError) {});
// //   }

// //   void signOut() async {
// //     Navigator.of(context).popUntil((route) => route.isFirst);
// //     await Navigator.of(context).pushReplacement(
// //       MaterialPageRoute(
// //         builder: (_) {
// //           return const SignIn();
// //         },
// //       ),
// //     );
// //   }

// //   Future<bool?> show(BuildContext context) {
// //     return showDialog<bool>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           contentPadding: const EdgeInsets.all(24),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Icon
// //               Container(
// //                 width: 64,
// //                 height: 64,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   gradient: const LinearGradient(
// //                     colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                 ),
// //                 child: const Icon(
// //                   Icons.logout,
// //                   color: Colors.white,
// //                   size: 28,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),

// //               // Title
// //               const Text(
// //                 'Confirm Logout',
// //                 style: TextStyle(
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF2D3748),
// //                 ),
// //               ),
// //               const SizedBox(height: 8),

// //               // Message
// //               const Text(
// //                 'Are you sure you want to logout? You will need to sign in again to access your account.',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 15,
// //                   color: Color(0xFF718096),
// //                   height: 1.4,
// //                 ),
// //               ),
// //               const SizedBox(height: 24),

// //               // Buttons
// //               Row(
// //                 children: [
// //                   // Cancel Button
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: () => Navigator.of(context).pop(false),
// //                       style: OutlinedButton.styleFrom(
// //                         padding: const EdgeInsets.symmetric(vertical: 12),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         side: const BorderSide(
// //                           color: Color(0xFFE2E8F0),
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       child: const Text(
// //                         'Cancel',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w500,
// //                           color: Color(0xFF64748B),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),

// //                   // Logout Button
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: () => Navigator.of(context).pop(true),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFFF6B6B),
// //                         foregroundColor: Colors.white,
// //                         padding: const EdgeInsets.symmetric(vertical: 12),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         elevation: 0,
// //                       ),
// //                       child: const Text(
// //                         'Logout',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void logoutFunction() async {
// //     final bool? shouldLogout = await show(context);

// //     if (shouldLogout == true) {
// //       logout();
// //     }
// //   }

// //   // Sample pages
// //   static const List<Widget> _pages = <Widget>[
// //     SalesScreen(),
// //     //0
// //     //  AdminDashboard(),
// //     //1
// //     //ManageInvoicesPage(),
// //     TestCreateInvoice(),
// //     //2
// //     ManageEstimation(),
// //     //3
// //     ManageProducts(),
// //     //4
// //     ProductsCategoryList(),
// //     //3
// //     SubCategoryPage(),
// //     //4
// //     UnitMainPage(),
// //     //5
// //     BrandPage(),
// //     //5
// //     InventoryPage(),
// //     //6
// //     VendorPage(),
// //     //7
// //     BranchesPage(),
// //     //8
// //     PurchaseRequisitionPage(),
// //     //9
// //     Qoutations(),
// //     //10
// //     PurchaseOrders(),
// //     //11
// //     GoodsReceiveNotes(),
// //     //12
// //     ServicesMainPage(),
// //     //13
// //     ServiceBooking(),
// //     //14
// //     ManageCustomerPage(),
// //     //15
// //     CurrencyPage(),
// //     //16
// //     CountryPage(),
// //     //17
// //     RolesMainPage(),
// //     //18
// //     ManageTruckInventory(),
// //     EmployeePage(),

// //     //ChartOfAccountsScreen(companyId: "12"),
// //     // 12
// //   ];

// //   // Mixed menu items - some single, some in expansion tiles
// //   final List<MenuElement> _menuElements = [
// //     // Single items
// //     MenuElement.single(
// //       item:
// //           MenuItem(icon: Icons.dashboard_rounded, label: 'Dashboard', index: 0),
// //     ),
// //     //ServiceBooking
// //     MenuElement.expansion(
// //       group: MenuGroup(
// //         title: 'Sales & Invoices',
// //         icon: Icons.inventory_2_rounded,
// //         items: [
// //           MenuItem(
// //               icon: Icons.category_rounded, label: 'Manage Invoices', index: 1),
// //           MenuItem(icon: Icons.category_rounded, label: 'Estimates', index: 2),
// //         ],
// //       ),
// //     ),
// //     MenuElement.expansion(
// //       group: MenuGroup(
// //         title: 'inventory'.tr(),
// //         icon: Icons.miscellaneous_services_sharp,
// //         items: [
// //           //ProductsCategoryList
// //           MenuItem(
// //             icon: Icons.inventory_2_rounded, // Box/package icon for products
// //             label: 'Products'.tr(),
// //             index: 3,
// //           ),
// //           MenuItem(
// //             icon: Icons
// //                 .category_rounded, // Category/grid icon for product categories
// //             label: 'Product Category'.tr(),
// //             index: 4,
// //           ),
// //           MenuItem(
// //             icon: Icons
// //                 .subdirectory_arrow_right_rounded, // Arrow for subcategories
// //             label: 'Sub Category'.tr(),
// //             index: 5,
// //           ),
// //           MenuItem(
// //             icon: Icons.straighten_rounded, // Ruler icon for units/measurements
// //             label: 'Units'.tr(),
// //             index: 6,
// //           ),
// //           MenuItem(
// //             icon: Icons.verified_rounded, // Badge/shield icon for brands
// //             label: 'Brands'.tr(),
// //             index: 7,
// //           ),
// //           MenuItem(
// //             icon: Icons.warehouse_rounded, // Warehouse icon for inventory
// //             label: 'Inventory'.tr(),
// //             index: 8,
// //           ),
// //           MenuItem(
// //             icon: Icons.business_rounded, // Building icon for vendors/suppliers
// //             label: 'Vendor'.tr(),
// //             index: 9,
// //           ),
// //           MenuItem(
// //             icon: Icons.store_rounded, // Store/shop icon for branches
// //             label: 'Branches'.tr(),
// //             index: 10,
// //           ),
// //         ],
// //       ),
// //     ),
// //     // MenuElement.expansion(
// //     //   group: MenuGroup(
// //     //     title: 'Purchase',
// //     //     icon: Icons.inventory_2_rounded,
// //     //     items: [
// //     //       MenuItem(
// //     //           icon: Icons.category_rounded,
// //     //           label: 'Purchase Requisition',
// //     //           index: 11),
// //     //       MenuItem(
// //     //           icon: Icons.inventory_rounded, label: 'Qoutation', index: 12),
// //     //       MenuItem(
// //     //           icon: Icons.inventory_rounded,
// //     //           label: 'Purchase Order (PO)',
// //     //           index: 13),
// //     //       MenuItem(icon: Icons.inventory_rounded, label: 'GRN', index: 14),
// //     //     ],
// //     //   ),
// //     // ),
// //     MenuElement.expansion(
// //       group: MenuGroup(
// //         title: 'Purchase',
// //         icon: Icons
// //             .shopping_cart_rounded, // Shopping cart for purchase activities
// //         items: [
// //           MenuItem(
// //             icon:
// //                 Icons.assignment_rounded, // Document/form icon for requisitions
// //             label: 'Purchase Requisition',
// //             index: 11,
// //           ),
// //           MenuItem(
// //             icon:
// //                 Icons.request_quote_rounded, // Quote bubble icon for quotations
// //             label: 'Qoutation',
// //             index: 12,
// //           ),
// //           MenuItem(
// //             icon: Icons
// //                 .receipt_long_rounded, // Receipt/order document icon for PO
// //             label: 'Purchase Order (PO)',
// //             index: 13,
// //           ),
// //           MenuItem(
// //             icon: Icons
// //                 .check_circle_outline_rounded, // Checkmark for goods received
// //             label: 'GRN',
// //             index: 14,
// //           ),
// //         ],
// //       ),
// //     ),
// //     MenuElement.expansion(
// //       group: MenuGroup(
// //         title: 'Garaje Maintenance',
// //         icon: Icons.inventory_2_rounded,
// //         items: [
// //           MenuItem(
// //               icon: Icons.category_rounded, label: 'Service Types', index: 15),
// //           MenuItem(
// //               icon: Icons.inventory_rounded, label: 'Create Bill', index: 16),
// //         ],
// //       ),
// //     ),
// //     MenuElement.single(
// //       item: MenuItem(
// //           icon: Icons.dashboard_rounded, label: 'Customers', index: 17),
// //     ),
// //     // MenuElement.single(
// //     //   item: MenuItem(
// //     //       icon: Icons.dashboard_rounded, label: 'Chart of account', index: 15),
// //     // ),
// //     // Expansion tile for Products section
// //     MenuElement.expansion(
// //       group: MenuGroup(
// //         title: 'Administration',
// //         icon: Icons.inventory_2_rounded,
// //         items: [
// //           MenuItem(icon: Icons.category_rounded, label: 'Currency', index: 18),
// //           MenuItem(
// //               icon: Icons.inventory_rounded, label: 'Countries', index: 19),
// //           MenuItem(
// //               icon: Icons.inventory_rounded,
// //               label: 'Access Control',
// //               index: 20),
// //         ],
// //       ),
// //     ),
// //     MenuElement.single(
// //       item: MenuItem(
// //           icon: Icons.dashboard_rounded, label: 'Inventory Trucks', index: 21),
// //     ),
// //     MenuElement.expansion(
// //       group: MenuGroup(
// //         title: 'Employees',
// //         icon: Icons.inventory_2_rounded,
// //         items: [
// //           MenuItem(icon: Icons.category_rounded, label: 'Employees', index: 22),
// //           MenuItem(
// //               icon: Icons.inventory_rounded, label: 'Inventory', index: 23),
// //         ],
// //       ),
// //     ),
// //     // Single item
// //     MenuElement.single(
// //       item: MenuItem(icon: Icons.logout, label: 'Log Out', index: 23),
// //     ),

// //     // Single item
// //     MenuElement.single(
// //       item:
// //           MenuItem(icon: Icons.settings_rounded, label: 'Settings', index: 24),
// //     ),
// //   ];

// //   // Sample data
// //   // final List<String> _branches = [
// //   //   'New York Branch',
// //   //   'London Branch',
// //   //   'Tokyo Branch',
// //   //   'Sydney Branch'
// //   // ];
// //   final List<String> _companies = [
// //     'Modern Motors',
// //     'Global Logistic Solutions',
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //     if (MediaQuery.of(context).size.width < 900) {
// //       Navigator.of(context).pop();
// //     }
// //   }

// //   void changeLanguage(String lang) {
// //     if (lang == "en") {
// //       context.setLocale(const Locale('en', 'US'));
// //       setState(() {
// //         language = "en";
// //         Constants.language = "en";
// //       });
// //     } else if (lang == "ar") {
// //       context.setLocale(const Locale('ar', 'SA'));
// //       setState(() {
// //         language = "ar";
// //         Constants.language = "ar";
// //       });
// //     } else if (lang == "ur") {
// //       context.setLocale(const Locale('ur', 'PK'));
// //       setState(() {
// //         language = "ur";
// //         Constants.language = "ur";
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isMobile = MediaQuery.of(context).size.width < 800;

// //     return Scaffold(
// //       key: _scaffoldKey,
// //       // backgroundColor: const Color(0xFFF8FAFC),
// //       appBar: isMobile
// //           ? AppBar(
// //               backgroundColor: Colors.white,
// //               elevation: 0,
// //               leading: IconButton(
// //                 icon: const Icon(Icons.menu, color: Colors.black87),
// //                 onPressed: () => _scaffoldKey.currentState?.openDrawer(),
// //               ),
// //               title: const Text('Modern Motors',
// //                   style: TextStyle(
// //                       color: Colors.black87, fontWeight: FontWeight.w600)),
// //               actions: _buildAppBarActions(),
// //             )
// //           : null,
// //       drawer: isMobile
// //           ? Drawer(
// //               backgroundColor: const Color(0xFF0F172A),
// //               child: _buildSidebarContent(),
// //             )
// //           : null,
// //       body: Row(
// //         children: [
// //           // Sidebar for desktop
// //           if (!isMobile)
// //             MouseRegion(
// //               onEnter: (_) => setState(() => _isSidebarCollapsed = false),
// //               child: AnimatedContainer(
// //                 duration: const Duration(milliseconds: 300),
// //                 width: _isSidebarCollapsed ? 70 : 280,
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFF0F172A),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.1),
// //                       blurRadius: 10,
// //                       offset: const Offset(2, 0),
// //                     )
// //                   ],
// //                 ),
// //                 child: _buildSidebarContent(),
// //               ),
// //             ),
// //           // Main content
// //           Expanded(
// //             child: Column(
// //               children: [
// //                 if (!isMobile) _buildDesktopAppBar(),
// //                 Expanded(child: _pages[_selectedIndex]),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDesktopAppBar() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 6,
// //             offset: const Offset(0, 2),
// //           )
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           IconButton(
// //             onPressed: () {
// //               setState(() {
// //                 _isSidebarCollapsed = !_isSidebarCollapsed;
// //               });
// //             },
// //             icon: Icon(
// //               _isSidebarCollapsed
// //                   ? Icons.menu_open_rounded
// //                   : Icons.menu_rounded,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           const Spacer(),
// //           ..._buildAppBarActions(),
// //         ],
// //       ),
// //     );
// //   }

// //   List<Widget> _buildAppBarActions() {
// //     return [
// //       // Company selector
// //       if (Constants.profile.role == "admin")
// //         Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 12),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFFF1F5F9),
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           child: DropdownButtonHideUnderline(
// //             child: DropdownButton<String>(
// //               value: _selectedCompany,
// //               icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
// //               dropdownColor: Colors.white,
// //               style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14),
// //               onChanged: (String? newValue) {
// //                 setState(() {
// //                   _selectedCompany = newValue!;
// //                 });
// //               },
// //               items: _companies.map<DropdownMenuItem<String>>((String value) {
// //                 return DropdownMenuItem<String>(
// //                   value: value,
// //                   child: Text(value),
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //         ),
// //       const SizedBox(width: 16),
// //       // Notifications
// //       IconButton(
// //         icon: const Icon(Icons.notifications_none_rounded,
// //             color: Color(0xFF64748B)),
// //         onPressed: () {},
// //       ),
// //       const SizedBox(width: 8),
// //       // User avatar
// //       const CircleAvatar(
// //         backgroundColor: Color(0xFFE2E8F0),
// //         child: Icon(Icons.person, color: Color(0xFF64748B)),
// //       ),
// //       const SizedBox(width: 16),
// //       // Inside your build method, wherever you want to place the language selector
// //       if (Constants.profile.role == "Operation Supervisor" ||
// //           Constants.profile.role == "admin")
// //         PopupMenuButton<String>(
// //           offset: const Offset(0, 50),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           surfaceTintColor: Colors.white,
// //           elevation: 6,
// //           onSelected: (String item) {
// //             setState(() {
// //               selectedLanguage = item;
// //             });
// //             changeLanguage(item);
// //           },
// //           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
// //             _buildLanguageMenuItem(
// //               value: "en",
// //               icon: Icons.language,
// //               title: "English",
// //               subtitle: "English",
// //               isSelected: selectedLanguage == "en",
// //             ),
// //             _buildLanguageMenuItem(
// //               value: "ar",
// //               icon: Icons.translate,
// //               title: "العربية",
// //               subtitle: "Arabic",
// //               isSelected: selectedLanguage == "ar",
// //             ),
// //             _buildLanguageMenuItem(
// //               value: "ur",
// //               icon: Icons.menu_book_rounded,
// //               title: "اردو",
// //               subtitle: "Urdu",
// //               isSelected: selectedLanguage == "ur",
// //             ),
// //           ],
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.1),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 3),
// //                 ),
// //               ],
// //             ),
// //             child: Icon(
// //               Icons.translate_rounded,
// //               color: Colors.blue.shade700,
// //               size: 28,
// //             ),
// //           ),
// //         )
// //     ];
// //   }

// //   PopupMenuItem<String> _buildLanguageMenuItem({
// //     required String value,
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //     required bool isSelected,
// //   }) {
// //     return PopupMenuItem<String>(
// //       value: value,
// //       height: 56,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// //         decoration: BoxDecoration(
// //           color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(
// //                 icon,
// //                 color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
// //                 size: 20,
// //               ),
// //             ),
// //             const SizedBox(width: 16),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     title,
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w600,
// //                       fontSize: 15,
// //                       color: Colors.grey.shade800,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 2),
// //                   Text(
// //                     subtitle,
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: Colors.grey.shade600,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             if (isSelected)
// //               Icon(
// //                 Icons.check_circle_rounded,
// //                 color: Colors.blue.shade700,
// //                 size: 20,
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSidebarContent() {
// //     return Column(
// //       children: [
// //         // Logo
// //         Container(
// //           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const Icon(Icons.rocket_launch_rounded,
// //                   color: Colors.white, size: 28),
// //               AnimatedOpacity(
// //                 opacity: _isSidebarCollapsed ? 0 : 1,
// //                 duration: const Duration(milliseconds: 300),
// //                 child: const Padding(
// //                   padding: EdgeInsets.only(left: 12),
// //                   child: Text(
// //                     'Modern motors',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.w700,
// //                       letterSpacing: 1.2,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 16),

// //         const SizedBox(height: 16),
// //         // Mixed menu items - single items and expansion tiles
// //         Expanded(
// //           child: ListView(
// //             padding: EdgeInsets.zero,
// //             children: _menuElements.map((element) {
// //               return element.map(
// //                 single: (single) => _buildSingleMenuItem(single.item),
// //                 expansion: (expansion) =>
// //                     _buildExpansionMenuGroup(expansion.group),
// //               );
// //             }).toList(),
// //           ),
// //         ),
// //         // Collapse button
// //         if (!_isSidebarCollapsed)
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFF1E293B),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: ListTile(
// //                 leading:
// //                     const Icon(Icons.arrow_back_rounded, color: Colors.white70),
// //                 title: const Text('Collapse',
// //                     style: TextStyle(color: Colors.white70)),
// //                 onTap: () {
// //                   setState(() {
// //                     _isSidebarCollapsed = true;
// //                   });
// //                 },
// //               ),
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   Widget _buildSingleMenuItem(MenuItem item) {
// //     final isSelected = _selectedIndex == item.index;
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         decoration: BoxDecoration(
// //           color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         child: ListTile(
// //           leading: Icon(item.icon,
// //               color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
// //           title: AnimatedOpacity(
// //             opacity: _isSidebarCollapsed ? 0 : 1,
// //             duration: const Duration(milliseconds: 200),
// //             child: Text(
// //               item.label,
// //               style: TextStyle(
// //                 color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
// //                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
// //               ),
// //             ),
// //           ),
// //           onTap: () => _onItemTapped(item.index),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildExpansionMenuGroup(MenuGroup group) {
// //     final isExpanded = _expansionStates[group.title.toLowerCase()] ?? false;
// //     final hasSelectedItem =
// //         group.items.any((item) => _selectedIndex == item.index);

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
// //       child: ExpansionTile(
// //         key: Key(group.title),
// //         shape: const RoundedRectangleBorder(side: BorderSide.none),
// //         //tilePadding: EdgeInsets.zero,
// //         collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
// //         initiallyExpanded: isExpanded,
// //         onExpansionChanged: (expanded) {
// //           setState(() {
// //             _expansionStates[group.title.toLowerCase()] = expanded;
// //           });
// //         },
// //         leading: Icon(group.icon, color: const Color(0xFF94A3B8)),
// //         title: AnimatedOpacity(
// //           opacity: _isSidebarCollapsed ? 0 : 1,
// //           duration: const Duration(milliseconds: 200),
// //           child: Text(
// //             group.title,
// //             style: TextStyle(
// //               color: hasSelectedItem ? Colors.white : const Color(0xFFE2E8F0),
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ),
// //         trailing: _isSidebarCollapsed
// //             ? null
// //             : Icon(
// //                 isExpanded
// //                     ? Icons.keyboard_arrow_up_rounded
// //                     : Icons.keyboard_arrow_down_rounded,
// //                 color: const Color(0xFF94A3B8),
// //               ),
// //         backgroundColor: WidgetStateColor.resolveWith((states) {
// //           return states.contains(WidgetState.selected)
// //               ? const Color(0xFF1E293B)
// //               : Colors.transparent;
// //         }),
// //         collapsedBackgroundColor: Colors.transparent,
// //         children: group.items.map((item) => _buildSubMenuItem(item)).toList(),
// //       ),
// //     );
// //   }

// //   Widget _buildSubMenuItem(MenuItem item) {
// //     final isSelected = _selectedIndex == item.index;
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 4),
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         decoration: BoxDecoration(
// //           color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         child: ListTile(
// //           visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
// //           leading: Icon(item.icon,
// //               color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
// //           title: AnimatedOpacity(
// //             opacity: _isSidebarCollapsed ? 0 : 1,
// //             duration: const Duration(milliseconds: 200),
// //             child: Text(
// //               item.label,
// //               style: TextStyle(
// //                 color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
// //                 fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
// //               ),
// //             ),
// //           ),
// //           onTap: () => _onItemTapped(item.index),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Data models
// // class MenuItem {
// //   final IconData icon;
// //   final String label;
// //   final int index;

// //   const MenuItem({
// //     required this.icon,
// //     required this.label,
// //     required this.index,
// //   });
// // }

// // class MenuGroup {
// //   final String title;
// //   final IconData icon;
// //   final List<MenuItem> items;

// //   const MenuGroup({
// //     required this.title,
// //     required this.icon,
// //     required this.items,
// //   });
// // }

// // // Union type pattern for mixed menu elements
// // sealed class MenuElement {
// //   const MenuElement();

// //   const factory MenuElement.single({required MenuItem item}) =
// //       SingleMenuElement;
// //   const factory MenuElement.expansion({required MenuGroup group}) =
// //       ExpansionMenuElement;

// //   T map<T>({
// //     required T Function(SingleMenuElement) single,
// //     required T Function(ExpansionMenuElement) expansion,
// //   }) {
// //     return switch (this) {
// //       SingleMenuElement s => single(s),
// //       ExpansionMenuElement e => expansion(e),
// //     };
// //   }
// // }

// // class SingleMenuElement extends MenuElement {
// //   final MenuItem item;

// //   const SingleMenuElement({required this.item});
// // }

// // class ExpansionMenuElement extends MenuElement {
// //   final MenuGroup group;

// //   const ExpansionMenuElement({required this.group});
// // }

// // // Example Pages
// // class DashboardPage extends StatelessWidget {
// //   const DashboardPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Dashboard Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // class UsersPage extends StatelessWidget {
// //   const UsersPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Users Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // class UserGroupsPage extends StatelessWidget {
// //   const UserGroupsPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('User Groups Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // class RolesPage extends StatelessWidget {
// //   const RolesPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Roles Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // class ProductsPage extends StatelessWidget {
// //   const ProductsPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Products Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // class CategoriesPage extends StatelessWidget {
// //   const CategoriesPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Categories Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // // class InventoryPage extends StatelessWidget {
// // //   const InventoryPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return const Center(
// // //       child: Text('Inventory Content',
// // //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// // //     );
// // //   }
// // // }

// // class AnalyticsPage extends StatelessWidget {
// //   const AnalyticsPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Analytics Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // class SettingsPage extends StatelessWidget {
// //   const SettingsPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Settings Content',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
// //     );
// //   }
// // }

// // ignore_for_file: deprecated_member_use

// import 'package:app/app_theme.dart';
// import 'package:app/constants.dart';
// import 'package:app/erp/hr/roles_main_page.dart';
// import 'package:app/modern_motors/branch/branches_page.dart';
// import 'package:app/modern_motors/customers/customers_main_page.dart';
// import 'package:app/modern_motors/employees/employee_page.dart';
// import 'package:app/modern_motors/estimations/manage_estimations.dart';
// import 'package:app/modern_motors/inventory/inventory_page.dart';
// import 'package:app/modern_motors/inventory_trucks/manage_truck_inventory.dart';
// import 'package:app/modern_motors/invoices/manage_invoices.dart';
// import 'package:app/modern_motors/manage_terms_and_conditions_of_sales.dart';
// import 'package:app/modern_motors/products/manage_products.dart';
// import 'package:app/modern_motors/products/products_category_list.dart';
// import 'package:app/modern_motors/products/sub_category/sub_category_page.dart';
// import 'package:app/modern_motors/provider/mm_resource_provider.dart';
// import 'package:app/modern_motors/purchase/grn/goods_receive_notes.dart';
// import 'package:app/modern_motors/purchase/purchase_orders.dart';
// import 'package:app/modern_motors/purchase/purchase_requisition.dart';
// import 'package:app/modern_motors/purchase/qoutations.dart';
// import 'package:app/modern_motors/sales/sales_main_page.dart';
// import 'package:app/modern_motors/services_maintenance/create_booking_main_page.dart';
// import 'package:app/modern_motors/services_maintenance/service_booking.dart';
// import 'package:app/modern_motors/services_maintenance/services_main_page.dart';
// import 'package:app/modern_motors/units/unit_main_page.dart';
// import 'package:app/modern_motors/vendor/vendor_page.dart';
// import 'package:app/modern_motors/widgets/country/country_main_page.dart';
// import 'package:app/modern_motors/widgets/currency/currency_main_page.dart';
// import 'package:app/provider/resource_provider.dart';
// import 'package:app/registration/sign_in.dart';
// import 'package:app/widgets/brands/brands_page.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MmAdminMainPage extends StatefulWidget {
//   const MmAdminMainPage({super.key});

//   @override
//   State<MmAdminMainPage> createState() => _MmAdminMainPageState();
// }

// class _MmAdminMainPageState extends State<MmAdminMainPage> {
//   int _selectedIndex = 0;
//   bool _isSidebarCollapsed = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String _selectedCompany = 'Modern Motors';
//   String language = "";
//   String selectedLanguage = "";
//   late List<Widget> _pages;
//   User? user = FirebaseAuth.instance.currentUser;

//   // Expansion tile states
//   final Map<String, bool> _expansionStates = {
//     'users': false,
//     'products': false,
//     'analytics': false,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _initializePages();
//     final provider = Provider.of<MmResourceProvider>(context, listen: false);
//     provider.listenToEmployee(user!.uid);
//   }

//   void _initializePages() {
//     _pages = <Widget>[
//       //0
//       Container(),
//       //1
//       SalesMainPage(),
//       //2 - Pass the callback function
//       CreateBookingMainPage(
//         key: UniqueKey(),
//         tapped: getValue, // Pass the desired index
//       ),
//       //3
//       const ManageInvoicesPage(),
//       //4
//       const ManageEstimation(),
//       //5
//       const ManageProducts(),
//       //6
//       const ProductsCategoryList(),
//       //7
//       const SubCategoryPage(),
//       //8
//       const UnitMainPage(),
//       //9
//       const BrandPage(),
//       //10
//       const InventoryPage(),
//       //11
//       const VendorPage(),
//       //12
//       const BranchesPage(),
//       //13
//       const PurchaseRequisitionPage(),
//       //14
//       const Qoutations(),
//       //15
//       const PurchaseOrders(),
//       //16
//       const GoodsReceiveNotes(),
//       //17
//       const ServicesMainPage(),
//       //18
//       const ServiceBooking(),
//       //19
//       const ManageCustomerPage(),
//       //20
//       const CurrencyPage(),
//       //21
//       const CountryPage(),
//       //22
//       const RolesMainPage(),
//       //23
//       const ManageTruckInventory(),
//       //24
//       const EmployeePage(),
//       //25
//       const ManageTermsAndConditionsOfSale(),
//     ];
//   }

//   void logout() async {
//     FirebaseAuth.instance.signOut().then((value) async {
//       signOut();
//     }).catchError((onError) {});
//   }

//   void signOut() async {
//     Navigator.of(context).popUntil((route) => route.isFirst);
//     await Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (_) {
//           return const SignIn();
//         },
//       ),
//     );
//   }

//   Future<bool?> showLogoutConfirmation(BuildContext context) {
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           contentPadding: const EdgeInsets.all(24),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Icon
//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [AppTheme.primaryColor],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Icon(
//                   Icons.logout,
//                   color: AppTheme.primaryColor,
//                   size: 28,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Title
//               const Text(
//                 'Confirm Logout',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D3748),
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Message
//               const Text(
//                 'Are you sure you want to logout? You will need to sign in again to access your account.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Color(0xFF718096),
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Buttons
//               Row(
//                 children: [
//                   // Cancel Button
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.of(context).pop(false),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         side: const BorderSide(
//                           color: Color(0xFFE2E8F0),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF64748B),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),

//                   // Logout Button
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.of(context).pop(true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.primaryColor,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         'Logout',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void logoutFunction() async {
//     final bool? shouldLogout = await showLogoutConfirmation(context);

//     if (shouldLogout == true) {
//       logout();
//     }
//   }

//   Widget _createBookingPage() {
//     return CreateBookingMainPage(
//       tapped: () => getValue(),
//     );
//   }

//   // Sample pages
//   //  final List<Widget> _pages = <Widget>[
//   //   //0
//   //   //SalesScreen(),
//   //   //TestCreateInvoice(),
//   //   Container(),
//   //   //1
//   //   SalesMainPage(),
//   //   //2
//   //  _createBookingPage(),
//   //   //3
//   //   const ManageInvoicesPage(),
//   //   //1
//   //   const ManageEstimation(),
//   //   //2
//   //   const ManageProducts(),
//   //   //3
//   //   const ProductsCategoryList(),
//   //   //4
//   //   const SubCategoryPage(),
//   //   //5
//   //   const UnitMainPage(),
//   //   //6
//   //   const BrandPage(),
//   //   //7
//   //   const InventoryPage(),
//   //   //8
//   //   const VendorPage(),
//   //   //9
//   //   const BranchesPage(),
//   //   //10
//   //   const PurchaseRequisitionPage(),
//   //   //11
//   //   const Qoutations(),
//   //   //12
//   //   const PurchaseOrders(),
//   //   //13
//   //   const GoodsReceiveNotes(),
//   //   //14
//   //   const ServicesMainPage(),
//   //   //15
//   //   const ServiceBooking(),
//   //   //16
//   //   const ManageCustomerPage(),
//   //   //17
//   //   const CurrencyPage(),
//   //   //18
//   //   const CountryPage(),
//   //   //19
//   //   const RolesMainPage(),
//   //   //20
//   //   const ManageTruckInventory(),
//   //   //21
//   //   const EmployeePage(),
//   //   //22 - Employee Page
//   //   const ManageTermsAndConditionsOfSale()

//   //   // Add a placeholder for logout (won't be shown in main content)
//   //   // Container(), //22 - Placeholder for logout
//   // ];

//   // Mixed menu items - some single, some in expansion tiles
//   final List<MenuElement> _menuElements = [
//     // Single items
//     MenuElement.single(
//       item:
//           MenuItem(icon: Icons.dashboard_rounded, label: 'Dashboard', index: 0),
//     ),
//     MenuElement.expansion(
//       group: MenuGroup(
//         title: 'Sales & Invoices',
//         icon: Icons.inventory_2_rounded,
//         items: [
//           MenuItem(
//               icon: Icons
//                   .receipt_long, // or Icons.list_alt for invoice management
//               label: 'Manage Invoices',
//               index: 1),
//           MenuItem(
//               icon: Icons.post_add, // or Icons.receipt for creating invoices
//               label: 'Create Invoices',
//               index: 2),
//           MenuItem(
//               icon: Icons.assessment, // or Icons.ballot for estimates
//               label: 'Manage Estimates',
//               index: 3),
//           MenuItem(
//               icon:
//                   Icons.note_add, // or Icons.assignment for creating estimates
//               label: 'Create Estimate',
//               index: 4),
//           MenuItem(
//               icon: Icons.credit_card, // or Icons.money_off for credit notes
//               label: 'Credit Note',
//               index: 5),
//           MenuItem(
//               icon: Icons
//                   .receipt, // or Icons.assignment_return for refund receipts
//               label: 'Refund Receipts',
//               index: 6),
//         ],
//       ),
//     ),
//     MenuElement.expansion(
//       group: MenuGroup(
//         title: 'inventory'.tr(),
//         icon: Icons.miscellaneous_services_sharp,
//         items: [
//           MenuItem(
//             icon: Icons.inventory_2_rounded,
//             label: 'Products'.tr(),
//             index: 3,
//           ),
//           MenuItem(
//             icon: Icons.category_rounded,
//             label: 'Product Category'.tr(),
//             index: 4,
//           ),
//           MenuItem(
//             icon: Icons.subdirectory_arrow_right_rounded,
//             label: 'Sub Category'.tr(),
//             index: 5,
//           ),
//           MenuItem(
//             icon: Icons.straighten_rounded,
//             label: 'Units'.tr(),
//             index: 6,
//           ),
//           MenuItem(
//             icon: Icons.verified_rounded,
//             label: 'Brands'.tr(),
//             index: 7,
//           ),
//           MenuItem(
//             icon: Icons.warehouse_rounded,
//             label: 'Inventory'.tr(),
//             index: 8,
//           ),
//           MenuItem(
//             icon: Icons.business_rounded,
//             label: 'Vendor'.tr(),
//             index: 9,
//           ),
//           MenuItem(
//             icon: Icons.store_rounded,
//             label: 'Branches'.tr(),
//             index: 10,
//           ),
//         ],
//       ),
//     ),
//     MenuElement.expansion(
//       group: MenuGroup(
//         title: 'Purchase',
//         icon: Icons.shopping_cart_rounded,
//         items: [
//           MenuItem(
//             icon: Icons.assignment_rounded,
//             label: 'Purchase Requisition',
//             index: 11,
//           ),
//           MenuItem(
//             icon: Icons.request_quote_rounded,
//             label: 'Qoutation',
//             index: 12,
//           ),
//           MenuItem(
//             icon: Icons.receipt_long_rounded,
//             label: 'Purchase Order (PO)',
//             index: 13,
//           ),
//           MenuItem(
//             icon: Icons.check_circle_outline_rounded,
//             label: 'GRN',
//             index: 14,
//           ),
//         ],
//       ),
//     ),
//     MenuElement.expansion(
//       group: MenuGroup(
//         title: 'Garaje Maintenance',
//         icon: Icons.inventory_2_rounded,
//         items: [
//           MenuItem(
//               icon: Icons.category_rounded, label: 'Service Types', index: 15),
//           MenuItem(
//               icon: Icons.inventory_rounded, label: 'Create Bill', index: 16),
//         ],
//       ),
//     ),
//     MenuElement.single(
//       item: MenuItem(
//           icon: Icons.dashboard_rounded, label: 'Customers', index: 17),
//     ),
//     MenuElement.expansion(
//       group: MenuGroup(
//         title: 'Administration',
//         icon: Icons.inventory_2_rounded,
//         items: [
//           MenuItem(icon: Icons.category_rounded, label: 'Currency', index: 18),
//           MenuItem(
//               icon: Icons.inventory_rounded, label: 'Countries', index: 19),
//           MenuItem(
//               icon: Icons.inventory_rounded,
//               label: 'Access Control',
//               index: 20),
//           MenuItem(
//               icon: Icons.inventory_rounded, label: 'Manage Terms', index: 21),
//         ],
//       ),
//     ),
//     MenuElement.single(
//       item: MenuItem(
//           icon: Icons.dashboard_rounded, label: 'Inventory Trucks', index: 22),
//     ),
//     MenuElement.expansion(
//       group: MenuGroup(
//         title: 'Employees',
//         icon: Icons.inventory_2_rounded,
//         items: [
//           MenuItem(icon: Icons.category_rounded, label: 'Employees', index: 23),
//           MenuItem(
//               icon: Icons.inventory_rounded, label: 'Inventory', index: 24),
//         ],
//       ),
//     ),
//     // Log Out option
//     MenuElement.single(
//       item: MenuItem(
//           icon: Icons.logout, label: 'Log Out', index: 25), // Logout index
//     ),
//   ];

//   final List<String> _companies = [
//     'Modern Motors',
//     'Global Logistic Solutions',
//   ];

//   void getValue() {
//     _onItemTapped(1);
//   }

//   void _onItemTapped(int index) {
//     if (index == 25) {
//       // Log Out index
//       logoutFunction();
//       return;
//     }

//     setState(() {
//       _selectedIndex = index;
//     });
//     if (MediaQuery.of(context).size.width < 900) {
//       Navigator.of(context).pop();
//     }
//   }

//   void changeLanguage(String lang) {
//     if (lang == "en") {
//       context.setLocale(const Locale('en', 'US'));
//       setState(() {
//         language = "en";
//         Constants.language = "en";
//       });
//     } else if (lang == "ar") {
//       context.setLocale(const Locale('ar', 'SA'));
//       setState(() {
//         language = "ar";
//         Constants.language = "ar";
//       });
//     } else if (lang == "ur") {
//       context.setLocale(const Locale('ur', 'PK'));
//       setState(() {
//         language = "ur";
//         Constants.language = "ur";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 800;

//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: isMobile
//           ? AppBar(
//               backgroundColor: Colors.white,
//               elevation: 0,
//               leading: IconButton(
//                 icon: const Icon(Icons.menu, color: Colors.black87),
//                 onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//               ),
//               title: const Text('Modern Motors',
//                   style: TextStyle(
//                       color: Colors.black87, fontWeight: FontWeight.w600)),
//               actions: _buildAppBarActions(),
//             )
//           : null,
//       drawer: isMobile
//           ? Drawer(
//               backgroundColor: const Color(0xFF0F172A),
//               child: _buildSidebarContent(),
//             )
//           : null,
//       body: Row(
//         children: [
//           // Sidebar for desktop
//           if (!isMobile)
//             MouseRegion(
//               onEnter: (_) => setState(() => _isSidebarCollapsed = false),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 width: _isSidebarCollapsed ? 70 : 280,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0F172A),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(2, 0),
//                     )
//                   ],
//                 ),
//                 child: _buildSidebarContent(),
//               ),
//             ),
//           // Main content
//           Expanded(
//             child: Column(
//               children: [
//                 if (!isMobile) _buildDesktopAppBar(),
//                 Expanded(child: _pages[_selectedIndex]),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDesktopAppBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 _isSidebarCollapsed = !_isSidebarCollapsed;
//               });
//             },
//             icon: Icon(
//               _isSidebarCollapsed
//                   ? Icons.menu_open_rounded
//                   : Icons.menu_rounded,
//               color: Colors.black87,
//             ),
//           ),
//           const Spacer(),
//           ..._buildAppBarActions(),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildAppBarActions() {
//     return [
//       // Company selector
//       if (Constants.profile.role == "admin")
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF1F5F9),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedCompany,
//               icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
//               dropdownColor: Colors.white,
//               style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedCompany = newValue!;
//                 });
//               },
//               items: _companies.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       const SizedBox(width: 16),
//       // Notifications
//       IconButton(
//         icon: const Icon(Icons.notifications_none_rounded,
//             color: Color(0xFF64748B)),
//         onPressed: () {},
//       ),
//       const SizedBox(width: 8),
//       // User avatar
//       const CircleAvatar(
//         backgroundColor: Color(0xFFE2E8F0),
//         child: Icon(Icons.person, color: Color(0xFF64748B)),
//       ),
//       const SizedBox(width: 16),
//       // Language selector
//       if (Constants.profile.role == "Operation Supervisor" ||
//           Constants.profile.role == "admin")
//         PopupMenuButton<String>(
//           offset: const Offset(0, 50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           surfaceTintColor: Colors.white,
//           elevation: 6,
//           onSelected: (String item) {
//             setState(() {
//               selectedLanguage = item;
//             });
//             changeLanguage(item);
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             _buildLanguageMenuItem(
//               value: "en",
//               icon: Icons.language,
//               title: "English",
//               subtitle: "English",
//               isSelected: selectedLanguage == "en",
//             ),
//             _buildLanguageMenuItem(
//               value: "ar",
//               icon: Icons.translate,
//               title: "العربية",
//               subtitle: "Arabic",
//               isSelected: selectedLanguage == "ar",
//             ),
//             _buildLanguageMenuItem(
//               value: "ur",
//               icon: Icons.menu_book_rounded,
//               title: "اردو",
//               subtitle: "Urdu",
//               isSelected: selectedLanguage == "ur",
//             ),
//           ],
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Icon(
//               Icons.translate_rounded,
//               color: Colors.blue.shade700,
//               size: 28,
//             ),
//           ),
//         )
//     ];
//   }

//   PopupMenuItem<String> _buildLanguageMenuItem({
//     required String value,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool isSelected,
//   }) {
//     return PopupMenuItem<String>(
//       value: value,
//       height: 56,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                       color: Colors.grey.shade800,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Icon(
//                 Icons.check_circle_rounded,
//                 color: Colors.blue.shade700,
//                 size: 20,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSidebarContent() {
//     return Column(
//       children: [
//         // Logo
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.rocket_launch_rounded,
//                   color: Colors.white, size: 28),
//               AnimatedOpacity(
//                 opacity: _isSidebarCollapsed ? 0 : 1,
//                 duration: const Duration(milliseconds: 300),
//                 child: const Padding(
//                   padding: EdgeInsets.only(left: 12),
//                   child: Text(
//                     'Modern motors',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),

//         const SizedBox(height: 16),
//         // Mixed menu items - single items and expansion tiles
//         Expanded(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: _menuElements.map((element) {
//               return element.map(
//                 single: (single) => _buildSingleMenuItem(single.item),
//                 expansion: (expansion) =>
//                     _buildExpansionMenuGroup(expansion.group),
//               );
//             }).toList(),
//           ),
//         ),
//         // Collapse button
//         if (!_isSidebarCollapsed)
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E293B),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: ListTile(
//                 leading:
//                     const Icon(Icons.arrow_back_rounded, color: Colors.white70),
//                 title: const Text('Collapse',
//                     style: TextStyle(color: Colors.white70)),
//                 onTap: () {
//                   setState(() {
//                     _isSidebarCollapsed = true;
//                   });
//                 },
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildSingleMenuItem(MenuItem item) {
//     final isSelected = _selectedIndex == item.index;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: ListTile(
//           leading: Icon(item.icon,
//               color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
//           title: AnimatedOpacity(
//             opacity: _isSidebarCollapsed ? 0 : 1,
//             duration: const Duration(milliseconds: 200),
//             child: Text(
//               item.label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ),
//           onTap: () => _onItemTapped(item.index),
//         ),
//       ),
//     );
//   }

//   Widget _buildExpansionMenuGroup(MenuGroup group) {
//     final isExpanded = _expansionStates[group.title.toLowerCase()] ?? false;
//     final hasSelectedItem =
//         group.items.any((item) => _selectedIndex == item.index);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//       child: ExpansionTile(
//         key: Key(group.title),
//         shape: const RoundedRectangleBorder(side: BorderSide.none),
//         collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
//         initiallyExpanded: isExpanded,
//         onExpansionChanged: (expanded) {
//           setState(() {
//             _expansionStates[group.title.toLowerCase()] = expanded;
//           });
//         },
//         leading: Icon(group.icon, color: const Color(0xFF94A3B8)),
//         title: AnimatedOpacity(
//           opacity: _isSidebarCollapsed ? 0 : 1,
//           duration: const Duration(milliseconds: 200),
//           child: Text(
//             group.title,
//             style: TextStyle(
//               color: hasSelectedItem ? Colors.white : const Color(0xFFE2E8F0),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         trailing: _isSidebarCollapsed
//             ? null
//             : Icon(
//                 isExpanded
//                     ? Icons.keyboard_arrow_up_rounded
//                     : Icons.keyboard_arrow_down_rounded,
//                 color: const Color(0xFF94A3B8),
//               ),
//         backgroundColor: WidgetStateColor.resolveWith((states) {
//           return states.contains(WidgetState.selected)
//               ? const Color(0xFF1E293B)
//               : Colors.transparent;
//         }),
//         collapsedBackgroundColor: Colors.transparent,
//         children: group.items.map((item) => _buildSubMenuItem(item)).toList(),
//       ),
//     );
//   }

//   Widget _buildSubMenuItem(MenuItem item) {
//     final isSelected = _selectedIndex == item.index;
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 4),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: ListTile(
//           visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
//           leading: Icon(item.icon,
//               color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
//           title: AnimatedOpacity(
//             opacity: _isSidebarCollapsed ? 0 : 1,
//             duration: const Duration(milliseconds: 200),
//             child: Text(
//               item.label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
//                 fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//               ),
//             ),
//           ),
//           onTap: () => _onItemTapped(item.index),
//         ),
//       ),
//     );
//   }
// }

// // Data models
// class MenuItem {
//   final IconData icon;
//   final String label;
//   final int index;

//   const MenuItem({
//     required this.icon,
//     required this.label,
//     required this.index,
//   });
// }

// class MenuGroup {
//   final String title;
//   final IconData icon;
//   final List<MenuItem> items;

//   const MenuGroup({
//     required this.title,
//     required this.icon,
//     required this.items,
//   });
// }

// // Union type pattern for mixed menu elements
// sealed class MenuElement {
//   const MenuElement();

//   const factory MenuElement.single({required MenuItem item}) =
//       SingleMenuElement;
//   const factory MenuElement.expansion({required MenuGroup group}) =
//       ExpansionMenuElement;

//   T map<T>({
//     required T Function(SingleMenuElement) single,
//     required T Function(ExpansionMenuElement) expansion,
//   }) {
//     return switch (this) {
//       SingleMenuElement s => single(s),
//       ExpansionMenuElement e => expansion(e),
//     };
//   }
// }

// class SingleMenuElement extends MenuElement {
//   final MenuItem item;

//   const SingleMenuElement({required this.item});
// }

// class ExpansionMenuElement extends MenuElement {
//   final MenuGroup group;

//   const ExpansionMenuElement({required this.group});
// }

// // Example Pages
// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Dashboard Content',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// class UsersPage extends StatelessWidget {
//   const UsersPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Users Content',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// class UserGroupsPage extends StatelessWidget {
//   const UserGroupsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('User Groups Content',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// class RolesPage extends StatelessWidget {
//   const RolesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Roles Content',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// class ProductsPage extends StatelessWidget {
//   const ProductsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Products Content',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Categories Content',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/home_page.drawer_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/manu_item_widget.dart';
import 'package:modern_motors_panel/provider/hide_app_bar_provider.dart';
import 'package:modern_motors_panel/provider/main_container.dart';
import 'package:modern_motors_panel/provider/main_page_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:modern_motors_panel/widgets/clip_overlay_manager.dart';
import 'package:modern_motors_panel/widgets/profile_overlay.dart';
import 'package:provider/provider.dart';

class MmAdminMainPage extends StatefulWidget {
  const MmAdminMainPage({super.key});

  @override
  State<MmAdminMainPage> createState() => _MmAdminMainPageState();
}

class _MmAdminMainPageState extends State<MmAdminMainPage> {
  // MainContainer selectedPage = MainContainer.dashboard;
  bool isSidebarCollapsed = false;
  User? user = FirebaseAuth.instance.currentUser;

  // Set<MainContainer> hoveredItems = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    testResourceProvider();
    final provider = Provider.of<MmResourceProvider>(context, listen: false);
    provider.listenToEmployee(user!.uid);

    // // provider.listenToEmployee("O4cq5T5khYsyePxfA9Bd");
  }

  void testResourceProvider() async {
    if (mounted) {
      bool result = await context.read<MmResourceProvider>().start();
      if (!result) {
        return;
      }
    }
  }

  final Map<MainContainer, List<String>> permissionsMap = {
    // Dashboard (no CRUD restriction, always show)
    MainContainer.dashboard: [],

    // Sales & Invoices
    MainContainer.salesAndInvoices: [
      "Create Invoices",
      "Edit Invoices",
      "Delete Invoices",
      "View Invoices",
    ],

    MainContainer.createInvoice: ["Create Invoices"],

    // MainContainer.estimation: [
    //   "Create Estimates",
    //   "Edit Estimates",
    //   "Delete Estimates",
    //   "View Estimates",
    // ],
    MainContainer.createEstimate: ["Create Estimates"],
    MainContainer.creditNotes: [
      "Create Credit Notes",
      "Edit Credit Notes",
      "Delete Credit Notes",
      "View Credit Notes",
    ],
    MainContainer.refundReceipts: [
      "Create Refund Receipts",
      "Edit Refund Receipts",
      "Delete Refund Receipts",
      "View Refund Receipts",
    ],

    // Bookings
    MainContainer.manageBookings: [
      "Add Booking",
      "Edit Booking",
      "Delete Booking",
      "View Booking",
    ],
    MainContainer.mmTrucks: [
      "Add Trucks",
      "Edit Trucks",
      "Delete Trucks",
      "View Trucks",
    ],

    MainContainer.addTrucks: [
      "Add Trucks",
      "Edit Trucks",
      "Delete Trucks",
      "View Trucks",
    ],

    MainContainer.addTripExpense: [
      "Add Trip Expense",
      "Edit Trip Expense",
      "Delete Trip Expense",
      "View Trip Expense",
    ],

    // Garage Maintenance
    MainContainer.servicesType: [
      "Add Service Type",
      "Edit Service Type",
      "Delete Service Type",
      "View Service Type",
    ],
    MainContainer.maintenanceBooking: [
      "Add Booking",
      "Edit Booking",
      "Delete Booking",
      "View Booking",
    ],

    // Inventory
    MainContainer.product: [
      "Create Products",
      "Edit Product",
      "Delete Product",
      "View Product",
    ],
    MainContainer.productCategory: [
      "Create Product Category",
      "Edit Product Category",
      "Delete Product Category",
      "View Product Category",
    ],
    MainContainer.subCategory: [
      "Create Sub Category",
      "Edit Sub Category",
      "Delete Sub Category",
      "View Sub Category",
    ],
    MainContainer.brand: [
      "Add Brands",
      "Edit Brands",
      "Delete Brands",
      "View Brands",
    ],
    MainContainer.inventory: [
      "Add Inventory",
      "Edit Inventory",
      "Delete Inventory",
      "View Inventory",
    ],
    MainContainer.uom: [
      "Add Units",
      "Edit Units",
      "Delete Units",
      "View Units",
    ],

    // Assets
    MainContainer.assets: [
      "Add Assets",
      "Edit Assets",
      "Delete Assets",
      "View Assets",
    ],
    MainContainer.assetsParentCategories: [
      "Add Parent Categories",
      "Edit Parent Categories",
      "Delete Parent Categories",
      "View Parent Categories",
    ],
    MainContainer.assetsCategories: [
      "Add Categories",
      "Edit Categories",
      "Delete Categories",
      "View Categories",
    ],
    MainContainer.depreciationMethods: [
      "Add Depreciation Methods",
      "Edit Depreciation Methods",
      "Delete Depreciation Methods",
      "View Depreciation Methods",
    ],

    // Estimation
    MainContainer.estimation: [
      "Create Estimates",
      "Edit Estimates",
      "Delete Estimates",
      "View Estimates",
    ],
    MainContainer.termsAndCondition: [
      "Add Terms & Conditions of Sales",
      "Edit Terms & Conditions of Sales",
      "Delete Terms & Conditions of Sales",
      "View Terms & Conditions of Sales",
    ],
    MainContainer.vendorLogos: [
      "Add Vendors LOGO",
      "Edit Vendors LOGO",
      "Delete Vendors LOGO",
      "View Vendors LOGO",
    ],

    // Preview Templates
    MainContainer.previewTemplates: [
      "Create Template Previews",
      "Edit Template Previews",
      "Delete Template Previews",
      "View Template Previews",
    ],
    MainContainer.defaultValue: [
      "Add Default Addresses",
      "Edit Default Addresses",
      "Delete Default Addresses",
      "View Default Addresses",
      "Add Default Bank Details",
      "Edit Default Bank Details",
      "Delete Default Bank Details",
      "View Default Bank Details",
    ],

    // Purchase
    MainContainer.purchaseRequisition: [
      "Add Purchase Requisition",
      "Edit Purchase Requisition",
      "Delete Purchase Requisition",
      "View Purchase Requisition",
    ],
    MainContainer.procurementQuotation: [
      "Add Quotation",
      "Edit Quotation",
      "Delete Quotation",
      "View Quotation",
    ],
    MainContainer.procurmentPurchaseOrderPage: [
      "Add Purchase Order",
      "Edit Purchase Order",
      "Delete Purchase Order",
      "View Purchase Order",
      "Add GRN",
      "Edit GRN",
      "Delete GRN",
      "View GRN",
    ],

    // Customers
    MainContainer.customers: [
      "Add Customer",
      "Edit Customer",
      "Delete Customer",
      "View Customer",
    ],

    // Designation
    MainContainer.manageDesignation: [
      "Add Designation",
      "Edit Designation",
      "Delete Designation",
      "View Designation",
    ],

    // People
    MainContainer.vendor: [
      "Add Vendors",
      "Edit Vendors",
      "Delete Vendors",
      "View Vendors",
    ],
    MainContainer.branches: [
      "Add Branches",
      "Edit Branches",
      "Delete Branches",
      "View Branches",
    ],
    MainContainer.roles: [
      "Add Roles & Permissions",
      "Edit Roles & Permissions",
      "Delete Roles & Permissions",
      "View Roles & Permissions",
    ],
    MainContainer.employees: [
      "Add Employees",
      "Edit Employees",
      "Delete Employees",
      "View Employees",
    ],

    // Allowances
    MainContainer.manageallotedAllowance: [
      "Add Allowance Category",
      "Edit Allowance Category",
      "Delete Allowance Category",
      "View Allowance Category",
    ],

    // Deduction
    MainContainer.deductionCategory: [
      "Add Deduction Category",
      "Edit Deduction Category",
      "Delete Deduction Category",
      "View Deduction Category",
    ],
    MainContainer.deduction: [
      "Add Deduction",
      "Edit Deduction",
      "Delete Deduction",
      "View Deduction",
    ],

    // Leaves
    MainContainer.manageAllotedLeaves: [
      "Add Leave",
      "Edit Leave",
      "Delete Leave",
      "View Leave",
    ],

    // Heavy Equipment
    MainContainer.heavyEquipmentType: [
      "Add Heavy Equipment Type",
      "Edit Heavy Equipment Type",
      "Delete Heavy Equipment Type",
      "View Heavy Equipment Type",
    ],

    // Settings
    MainContainer.currency: [
      "Add Currency Code",
      "Edit Currency Code",
      "Delete Currency Code",
      "View Currency Code",
    ],
    MainContainer.country: [
      "Add Country",
      "Edit Country",
      "Delete Country",
      "View Country",
    ],
    MainContainer.nationality: [
      "Add Nationality",
      "Edit Nationality",
      "Delete Nationality",
      "View Nationality",
    ],
    MainContainer.discount: [
      "Add Discounts",
      "Edit Discounts",
      "Delete Discounts",
      "View Discounts",
    ],
    MainContainer.settings: [],
    MainContainer.help: [],
    MainContainer.logout: [],
  };

  // bool hasAccess(MainContainer container, List<String> profileAccessKeys) {
  //   if (user!.uid == Constants.adminId) {
  //     return true;
  //   }
  //   final requiredKeys = permissionsMap[container] ?? [];
  //   if (requiredKeys.isEmpty) return true;
  //   return requiredKeys.any(profileAccessKeys.contains);
  // }

  bool hasAccess(MainContainer container, List<String> profileAccessKeys) {
    if (user!.uid == Constants.adminId) {
      return true;
    }
    final requiredKeys = permissionsMap[container] ?? [];
    if (requiredKeys.isEmpty) return true;
    return requiredKeys.any(profileAccessKeys.contains);
  }

  Map<String, List<MainContainer>> buildSidebarSections(
    List<String> profileAccessKeys,
  ) {
    final sidebarSections = {
      'Dashboard'.tr(): [MainContainer.comingSoon],
      'Sales & Invoices'.tr(): [
        MainContainer.salesAndInvoices,
        MainContainer.createInvoice,
        MainContainer.estimation,
        MainContainer.createEstimate,
        MainContainer.creditNotes,
        MainContainer.refundReceipts,
        MainContainer.salesSettings,
      ],
      // 'Create Bookings'.tr(): [
      //   MainContainer.manageBookings,
      //   MainContainer.addTrucks,
      //   MainContainer.addTripExpense,
      // ],
      // 'Garage Maintenance'.tr(): [
      //   MainContainer.servicesType,
      //   MainContainer.maintenanceBooking,
      // ],
      'Inventory'.tr(): [
        MainContainer.product,
        MainContainer.servicesType,
        MainContainer.productCategory,
        MainContainer.subCategory,
        MainContainer.brand,
        // MainContainer.inventory,
        MainContainer.uom,
      ],
      'Client'.tr(): [MainContainer.customers],

      //'Customers'.tr(): [MainContainer.customers],
      //'Designation'.tr(): [MainContainer.manageDesignation],
      'Accounting'.tr(): [
        MainContainer.journalEntries,
        MainContainer.chartOfAccounts,
      ],
      'Finance'.tr(): [
        MainContainer.expenses,
        MainContainer.income,
        MainContainer.treasury,
      ],
      'Purchase'.tr(): [
        MainContainer.purchaseRequisition,
        MainContainer.procurementQuotation,
        MainContainer.procurmentPurchaseOrderPage,
        MainContainer.supplier,
      ],
      'Administration'.tr(): [
        MainContainer.vendor,
        //MainContainer.branches,
        MainContainer.vendorLogos,
        MainContainer.termsAndCondition,
        MainContainer.country,
        MainContainer.nationality,
      ],
      'Branches'.tr(): [MainContainer.branches],
      'Assets'.tr(): [
        MainContainer.assets,
        MainContainer.assetsParentCategories,
        MainContainer.assetsCategories,
        MainContainer.depreciationMethods,
      ],
      // 'Estimation'.tr(): [
      //   MainContainer.termsAndCondition,
      //   MainContainer.vendorLogos,
      // ],
      'Trucks'.tr(): [
        MainContainer.mmTrucks,
        MainContainer.addTrucks,
        MainContainer.heavyEquipmentType,
      ],
      'HR'.tr(): [MainContainer.roles, MainContainer.employees],
      'Preview Templates'.tr(): [
        MainContainer.previewTemplates,
        MainContainer.defaultValue,
      ],
      //'Allowances'.tr(): [MainContainer.manageallotedAllowance],
      'Deduction'.tr(): [
        MainContainer.deductionCategory,
        MainContainer.deduction,
      ],
      'Log Out'.tr(): [MainContainer.logout],
      //'Leaves'.tr(): [MainContainer.manageAllotedLeaves],
      //'Heavy Equipment'.tr(): [MainContainer.heavyEquipmentType],
      // 'Settings'.tr(): [
      //   MainContainer.currency,
      //   MainContainer.country,
      //   MainContainer.nationality,
      //   MainContainer.discount,
      //   MainContainer.settings,
      //   MainContainer.help,
      //   MainContainer.logout,
      // ],
    };

    final filteredSections = <String, List<MainContainer>>{};

    sidebarSections.forEach((section, containers) {
      final allowedContainers = containers
          .where((container) => hasAccess(container, profileAccessKeys))
          .toList();

      if (allowedContainers.isNotEmpty) {
        filteredSections[section] = allowedContainers;
      }
    });

    return filteredSections;
  }

  Widget buildSidebarMenu(
    bool isMobile,
    Map<String, List<MainContainer>> sidebarSections,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1F2937),
            //Color.fromARGB(255, 172, 175, 181),
            Color(0xFF111827),
          ],
        ),
      ),
      child: Column(
        children: [
          // 🔹 Header (logo/title collapsed view)
          Container(
            height: 72,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF374151), width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: isSidebarCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (!isSidebarCollapsed) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/mm_logo.png',
                        height: 32,
                        fit: BoxFit.fitHeight,
                        color: AppTheme.whiteColor,
                      ),
                    ),
                    12.w,
                    if (!isMobile)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modern Motors',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                            ),
                            Text(
                              'Management System',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  if (isSidebarCollapsed)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'P',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 🔹 Sidebar items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: sidebarSections.entries.map((entry) {
                  final sectionTitle = entry.key;
                  final containers = entry.value;
                  final EdgeInsets sectionPadding = const EdgeInsets.symmetric(
                    horizontal: 12,
                  );

                  if (containers.length == 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: sectionPadding.copyWith(top: 20, bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors
                                      .blue[200], //AppTheme.primaryColor.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              8.w,
                              Text(
                                sectionTitle.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Colors.white.withAlpha(200),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      letterSpacing: 0.8,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: sectionPadding,
                          child: MenuItemWidget(
                            imgPath: containers.first.data.iconPath,
                            title: containers.first.data.label.tr(),
                            container: containers.first,
                            isMobile: isMobile,
                            isSidebarCollapsed: isSidebarCollapsed,
                          ),
                        ),
                      ],
                    );
                  }

                  return Theme(
                    data: Theme.of(context).copyWith(
                      //dividerColor: Colors.transparent,
                      unselectedWidgetColor: Colors.white70,
                      iconTheme: const IconThemeData(color: Colors.white70),
                    ),
                    child: ExpansionTile(
                      tilePadding: sectionPadding,
                      title: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          8.w,
                          Text(
                            sectionTitle.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white.withAlpha(200),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  letterSpacing: 0.8,
                                ),
                          ),
                        ],
                      ),
                      children: containers.map((container) {
                        return Padding(
                          padding: sectionPadding,
                          child: MenuItemWidget(
                            imgPath: container.data.iconPath,
                            title: container.data.label.tr(),
                            container: container,
                            isMobile: isMobile,
                            isSidebarCollapsed: isSidebarCollapsed,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          if (!isSidebarCollapsed && !isMobile)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF374151).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(
                //   color: const Color(0xFF4B5563).withValues(alpha: 0.3),
                // ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.help_outline,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                  ),
                  8.w,
                  Expanded(
                    child: Text(
                      'Need Help?'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Consumer<MmResourceProvider>(
      builder: (context, provider, _) {
        User? user = FirebaseAuth.instance.currentUser;
        EmployeeModel employeeModel = provider.getEmployeeByID(user!.uid);

        final branchId = BranchIdSp.getBranchId();
        final allPermissions = provider.employeeModel?.permissions ?? [];
        final branchPermissionModel = allPermissions.firstWhere(
          (p) => p.branchId == branchId,
          orElse: () => Permissions(branchId: branchId, permission: []),
        );
        final branchPermissions = branchPermissionModel.permission;
        final sidebarSections = buildSidebarSections(branchPermissions);

        // final profileKeys = provider.employeeModel?.profileAccessKey ?? [];
        // final sidebarSections = buildSidebarSections(profileKeys);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppTheme.backgroundGreyColor,
          appBar: isMobile
              ? AppBar(
                  foregroundColor: AppTheme.whiteColor,
                  elevation: 2,
                  automaticallyImplyLeading: false,
                  backgroundColor: AppTheme.whiteColor,
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  title: user.uid == Constants.adminId
                      ? Text(
                          "Admin",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          employeeModel.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/notification.png',
                            height: 20,
                            width: 20,
                          ),
                          // const SizedBox(width: 20),
                          // const CircleAvatar(
                          //   radius: 20,
                          //   backgroundImage: AssetImage(
                          //     'assets/images/userimg.png',
                          //   ),
                          // ),
                          20.w,
                          ProfileOverlayWidget(),
                        ],
                      ),
                    ),
                  ],
                )
              : null,
          drawer: isMobile
              ? Drawer(
                  backgroundColor: const Color(0xFF1F2937),
                  child: SafeArea(
                    child: buildSidebarMenu(isMobile, sidebarSections),
                  ),
                )
              : null,
          body: Consumer2<MainPageProvider, HideAppbarProvider>(
            builder: (context, selectedContainer, provider, child) {
              return isMobile
                  ? getSelectedPageWidget(
                      onProduct: (String page) {
                        // setState(() {});
                      },
                      selectedPage: selectedContainer.selectedPage,
                    )
                  : Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: isSidebarCollapsed ? 88 : 280,
                              child: buildSidebarMenu(
                                isMobile,
                                sidebarSections,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  provider.getIsBarValue
                                      ? Material(
                                          key: const ValueKey('appbar_visible'),
                                          elevation: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 28,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.whiteColor,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: AppTheme.borderColor,
                                                ),
                                              ),
                                            ),
                                            height: 64,
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: context.width * 0.08,
                                                  height:
                                                      context.height * 0.047,
                                                  child: CustomButton(
                                                    fontSize: 12,
                                                    text: 'Add New'.tr(),
                                                    onPressed: () {
                                                      ChipOverlayManager.showChipOverlay(
                                                        context,
                                                        onItemSelected: (entry) {
                                                          selectedContainer
                                                              .setSelectedPage(
                                                                entry,
                                                              );
                                                          // setState(() {
                                                          //   selectedContainer.setSelectedPage()= entry;
                                                          // });
                                                        },
                                                      );
                                                    },
                                                    iconAsset:
                                                        'assets/images/add-circle.png',
                                                    iconColor:
                                                        AppTheme.whiteColor,
                                                    buttonType:
                                                        ButtonType.IconAndText,
                                                    backgroundColor:
                                                        AppTheme.primaryColor,
                                                    textColor:
                                                        AppTheme.whiteColor,
                                                  ),
                                                ),
                                                20.w,
                                                GestureDetector(
                                                  onTap: () {
                                                    // context.push(
                                                    //   '/languageSelector',
                                                    // );
                                                  },
                                                  child: Icon(Icons.translate),
                                                ),
                                                20.w,
                                                Image.asset(
                                                  'assets/images/notification.png',
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                // 20.w,
                                                // const CircleAvatar(
                                                //   radius: 20,
                                                //   backgroundImage: AssetImage(
                                                //     'assets/images/userimg.png',
                                                //   ),
                                                // ),
                                                20.w,
                                                ProfileOverlayWidget(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(
                                          key: ValueKey('appbar_hidden'),
                                        ),
                                  Expanded(
                                    child: getSelectedPageWidget(
                                      onProduct: (String page) {
                                        setState(() {});
                                      },
                                      // selectedContainer.setSelectedPage(entry);
                                      selectedPage:
                                          selectedContainer.selectedPage,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: context.height * 0.03,
                          left: isSidebarCollapsed
                              ? context.width * 0.045
                              : context.width * 0.16,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              height: context.height * 0.05,
                              width: context.height * 0.05,
                              child: CustomButton(
                                onPressed: () {
                                  if (isMobile) {
                                    Navigator.of(context).pop();
                                  } else {
                                    setState(() {
                                      isSidebarCollapsed = !isSidebarCollapsed;
                                    });
                                  }
                                },
                                buttonType: ButtonType.IconOnly,
                                iconAsset:
                                    'assets/images/double back arrow.png',
                                borderRadius: 100,
                                backgroundColor: AppTheme.primaryColor,
                                iconColor: AppTheme.whiteColor,
                                iconSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        );
      },
    );
  }
}
