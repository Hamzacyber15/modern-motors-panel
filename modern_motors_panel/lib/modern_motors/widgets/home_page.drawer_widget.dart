import 'package:flutter/material.dart';
import 'package:modern_motors_panel/brands/brands_page.dart';
import 'package:modern_motors_panel/modern_motors/branch/branches_page.dart';
import 'package:modern_motors_panel/modern_motors/customers/customers_main_page.dart';
import 'package:modern_motors_panel/modern_motors/dashboard/coming_soon.dart';
import 'package:modern_motors_panel/modern_motors/employees/employee_page.dart';
import 'package:modern_motors_panel/modern_motors/employees/roles_main_page.dart';
import 'package:modern_motors_panel/modern_motors/estimations/create_estimate_main_page.dart';
import 'package:modern_motors_panel/modern_motors/estimations/estimations_main_page.dart';
import 'package:modern_motors_panel/modern_motors/inventory_trucks/manage_truck_inventory.dart';
import 'package:modern_motors_panel/modern_motors/invoices/default_values.dart';
import 'package:modern_motors_panel/modern_motors/manage_terms_and_conditions_of_sales.dart';
import 'package:modern_motors_panel/modern_motors/nationality/nationality_page.dart';
import 'package:modern_motors_panel/modern_motors/products/dummy_pages.dart';
import 'package:modern_motors_panel/modern_motors/products/manage_products.dart';
import 'package:modern_motors_panel/modern_motors/products/products_category_list.dart';
import 'package:modern_motors_panel/modern_motors/products/sub_category/sub_category_page.dart';
import 'package:modern_motors_panel/modern_motors/sales/sales_main_page.dart';
import 'package:modern_motors_panel/modern_motors/sales/sales_settings.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/create_booking_main_page.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/create_maintenance_booking.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/services_main_page.dart';
import 'package:modern_motors_panel/modern_motors/trucks/manage_heavy_equipment.dart';
import 'package:modern_motors_panel/modern_motors/trucks/manage_trucks_page.dart';
import 'package:modern_motors_panel/modern_motors/units/unit_main_page.dart';
import 'package:modern_motors_panel/modern_motors/vendor/manage_vendor_logos.dart';
import 'package:modern_motors_panel/modern_motors/widgets/ChartOfAccountsScreen.dart';
import 'package:modern_motors_panel/modern_motors/widgets/country/country_main_page.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/manage_templates.dart';
import 'package:modern_motors_panel/modern_motors/widgets/log_out1.dart';
import 'package:modern_motors_panel/provider/chart_of_accounts_screen.dart';
import 'package:modern_motors_panel/provider/main_container.dart';

Widget getSelectedPageWidget({
  required MainContainer selectedPage,
  required Function(String page)? onProduct,
}) {
  switch (selectedPage) {
    case MainContainer.dashboard:
      return ComingSoonWidget();
    // CreateBookingMainPage(
    //   tapped: () {},
    // );
    case MainContainer.salesAndInvoices:
      return SalesMainPage();
    case MainContainer.createInvoice:
      return CreateBookingMainPage(
        tapped: () {
          // onProduct?.call(MainContainer.createInvoice);
        },
      );
    case MainContainer.salesSettings:
      return SalesSettings();
    case MainContainer.estimation:
      return EstimationsMainPage(); //ManageEstimation();
    case MainContainer.createEstimate:
      return CreateEstimateMainPage();
    // case MainContainer.servicesType:
    // return
    case MainContainer.creditNotes:
      return CreateEstimateMainPage();
    case MainContainer.refundReceipts:
      return CreateEstimateMainPage();
    case MainContainer.productCategory:
      return ProductCategoryList();
    case MainContainer.product:
      return ManageProducts();
    case MainContainer.subCategory:
      return SubCategoryPage();
    case MainContainer.brand:
      return BrandPage();
    case MainContainer.inventory:
      return CreateMaintenanceBooking();
    case MainContainer.uom:
      return UnitMainPage();
    case MainContainer.customers:
      return ManageCustomerPage();
    case MainContainer.accessControl:
      return CreateMaintenanceBooking();
    case MainContainer.settings:
      return const CreateMaintenanceBooking(
        // data: "590123412345",
      );
    // return Center(
    //   child: TextButton(
    //     onPressed: () {
    //       const BarcodeWidget(data: "590123412345");
    //     },
    //     child: const Text('Settings Page'),
    //   ),
    // );
    case MainContainer.help:
      return const Center(child: Text('Help Page'));
    // case MainContainer.logout:
    //   return Center(
    //     child: TextButton(
    //       onPressed: () async {
    //         // await FirebaseAuth.instance.signOut().then((value) {
    //         //   // context.pop
    //         // });
    //       },
    //       child: Text('Logout'),
    //     ),
    //   );
    case MainContainer.vendor:
      return const CreateMaintenanceBooking();
    case MainContainer.procurementQuotation:
      return const CreateMaintenanceBooking();
    case MainContainer.branches:
      return const BranchesPage();
    case MainContainer.roles:
      return RolePermissionPage();
    case MainContainer.currency:
      return CreateMaintenanceBooking();
    case MainContainer.depreciationMethods:
      return CreateMaintenanceBooking();
    case MainContainer.assetsParentCategories:
      return CreateMaintenanceBooking();
    case MainContainer.assetsCategories:
      return CreateMaintenanceBooking();
    case MainContainer.assets:
      return CreateMaintenanceBooking();
    case MainContainer.country:
      return CountryPage();
    case MainContainer.purchaseRequisition:
      return CreateMaintenanceBooking();
    case MainContainer.discount:
      return CreateMaintenanceBooking();
    case MainContainer.procurmentPurchaseOrderPage:
      return CreateMaintenanceBooking();
    case MainContainer.mmTrucks:
      return ManageTrucksPage();
    case MainContainer.addTrucks:
      return ManageTruckInventory(); //
    case MainContainer.addTripExpense:
      return CreateMaintenanceBooking();
    case MainContainer.bookingCustomer:
      return CreateMaintenanceBooking();
    case MainContainer.employees:
      return EmployeePage();
    case MainContainer.manageallotedAllowance:
      return CreateMaintenanceBooking();
    case MainContainer.deductionCategory:
      return CreateMaintenanceBooking();
    case MainContainer.deduction:
      return CreateMaintenanceBooking();
    case MainContainer.manageAllotedLeaves:
      return CreateMaintenanceBooking();
    case MainContainer.manageDesignation:
      return CreateMaintenanceBooking();
    case MainContainer.nationality:
      return NationalityPage();
    case MainContainer.manageBookings:
      return CreateMaintenanceBooking();
    case MainContainer.servicesType:
      return ManageServiceTypes();
    case MainContainer.maintenanceBooking:
      return CreateMaintenanceBooking();
    // case MainContainer.estimation:
    //   return CreateMaintenanceBooking();
    case MainContainer.termsAndCondition:
      return ManageTermsAndConditionsOfSale();
    case MainContainer.heavyEquipmentType:
      return ManageHeavyEquipmentType();
    case MainContainer.previewTemplates:
      return ManageTemplates();
    case MainContainer.defaultValue:
      return DefaultValues();
    case MainContainer.vendorLogos:
      return ManageVendorsLogos();
    case MainContainer.logout:
      return Logout1();
    case MainContainer.comingSoon:
      return ComingSoonWidget();
    case MainContainer.chartOfAccounts:
      return ChartOfAccountsScreen();
  }
}
