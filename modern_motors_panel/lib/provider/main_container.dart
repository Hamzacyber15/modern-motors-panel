class ContainerData {
  final String key;
  final String label;
  final String iconPath;

  const ContainerData({
    required this.key,
    required this.label,
    required this.iconPath,
  });
}

enum MainContainer {
  dashboard(
    ContainerData(
      key: "dashboard",
      label: 'Dashboard',
      iconPath: "assets/images/dashboard.png",
    ),
  ),
  comingSoon(
    ContainerData(
      key: "dashboard",
      label: 'Dashboard',
      iconPath: "assets/images/dashboard.png",
    ),
  ),
  salesAndInvoices(
    ContainerData(
      key: "manageInvoices",
      label: 'Manage Invoices',
      iconPath: "assets/images/invoices.png",
    ),
  ),
  createInvoice(
    ContainerData(
      key: "createInvoices",
      label: 'Create Invoices',
      iconPath: "assets/images/invoices.png",
    ),
  ),
  mmTrucks(
    ContainerData(
      key: "mmTrucks",
      label: 'Manage MM Trucks',
      iconPath: "assets/images/add_truck.png",
    ),
  ),
  addTrucks(
    ContainerData(
      key: "addTrucks",
      label: 'Manage Trucks',
      iconPath: "assets/images/add_truck.png",
    ),
  ),
  servicesType(
    ContainerData(
      key: "servicesType",
      label: 'Services',
      iconPath: "assets/images/add_truck.png",
    ),
  ),
  previewTemplates(
    ContainerData(
      key: "templates",
      label: 'Manage Templates',
      iconPath: "assets/images/add_truck.png",
    ),
  ),
  defaultValue(
    ContainerData(
      key: "Default Values",
      label: 'Manage Default Values',
      iconPath: "assets/images/add_truck.png",
    ),
  ),
  maintenanceBooking(
    ContainerData(
      key: "maintenanceBooking",
      label: 'Manage Booking',
      iconPath: "assets/images/add_truck.png",
    ),
  ),
  manageBookings(
    ContainerData(
      key: "manageBooking",
      label: 'Manage Bookings',
      iconPath: "assets/images/mange_booking.png",
    ),
  ),
  addTripExpense(
    ContainerData(
      key: "addTripExpense",
      label: 'Manage Trip Expense',
      iconPath: "assets/images/dashboard.png",
    ),
  ),
  bookingCustomer(
    ContainerData(
      key: "addBookingCustomer",
      label: 'Manage Customers',
      iconPath: "assets/images/manage_customer.png",
    ),
  ),

  product(
    ContainerData(
      key: "product",
      label: "Product",
      iconPath: "assets/images/product_icon.png",
    ),
  ),
  estimation(
    ContainerData(
      key: "estimation",
      label: "Manage Estimation",
      iconPath: "assets/images/product_icon.png",
    ),
  ),
  productCategory(
    ContainerData(
      key: "productCategory",
      label: "Product Category",
      iconPath: "assets/images/product_icon.png",
    ),
  ),

  // category(
  //   ContainerData(
  //     key: "category",
  //     label: 'Category',
  //     iconPath: "assets/images/categories.png",
  //   ),
  // ),
  subCategory(
    ContainerData(
      key: "subCategory",
      label: 'Sub Category',
      iconPath: "assets/images/category_icon.png",
    ),
  ),
  brand(
    ContainerData(
      key: "brand",
      label: "Brand",
      iconPath: "assets/images/brand.png",
    ),
  ),
  inventory(
    ContainerData(
      key: "inventory",
      label: "Inventory",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  uom(
    ContainerData(
      key: "unitMainPage",
      label: "UOM",
      iconPath: "assets/images/unit_icon.png",
    ),
  ),
  procurementQuotation(
    ContainerData(
      key: "quotation",
      label: "Quotation",
      iconPath: "assets/images/unit_icon.png",
    ),
  ),
  manageAllotedLeaves(
    ContainerData(
      key: "manageAllotedLeaves",
      label: "Manage Alloted Leaves",
      iconPath: "assets/images/unit_icon.png",
    ),
  ),
  heavyEquipmentType(
    ContainerData(
      key: "heavyEquipmentType",
      label: "Manage Heavy Equipment Type",
      iconPath: "assets/images/unit_icon.png",
    ),
  ),
  // leave(
  //   ContainerData(
  //     key: "leave",
  //     label: "Leaves",
  //     iconPath: "assets/images/unit_icon.png",
  //   ),
  // ),
  accessControl(
    ContainerData(
      key: "accessControl",
      label: "Access Control",
      iconPath: "assets/images/setting_icon.png",
    ),
  ),
  settings(
    ContainerData(
      key: "settings",
      label: "Settings",
      iconPath: "assets/images/setting.png",
    ),
  ),
  customers(
    ContainerData(
      key: "customers",
      label: 'Manage Customers',
      iconPath: "assets/images/vendors_icon.png",
    ),
  ),
  employees(
    ContainerData(
      key: "employees",
      label: 'Manage Employees',
      iconPath: "assets/images/vendors_icon.png",
    ),
  ),
  purchaseRequisition(
    ContainerData(
      key: "purchaseRequisition",
      label: "Purchase Requisition",
      iconPath: "assets/images/access_control.png",
    ),
  ),
  help(
    ContainerData(
      key: "help",
      label: "Help",
      iconPath: "assets/images/help-circle.png",
    ),
  ),
  logout(
    ContainerData(
      key: "logout",
      label: "Logout",
      iconPath: "assets/images/logout.png",
    ),
  ),
  procurmentPurchaseOrderPage(
    ContainerData(
      key: "procurementPurchaseOrderPage",
      label: "Purchase Orders",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  vendor(
    ContainerData(
      key: "vendor",
      label: "Vendor",
      iconPath: "assets/images/vendors_icon.png",
    ),
  ),
  branches(
    ContainerData(
      key: "branches",
      label: "Branches",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  roles(
    ContainerData(
      key: "roles",
      label: "Roles & Permission",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  deductionCategory(
    ContainerData(
      key: "deductionCategory",
      label: "Deduction Category",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  deduction(
    ContainerData(
      key: "deduction",
      label: "Deduction",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  // addDesignation(
  //   ContainerData(
  //     key: "addDesignation",
  //     label: "Add Designation",
  //     iconPath: "assets/images/shopping.png",
  //   ),
  // ),
  manageDesignation(
    ContainerData(
      key: "manageDesignation",
      label: "Manage Designation",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  currency(
    ContainerData(
      key: "currencyCode",
      label: "Manage Currency Code",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  depreciationMethods(
    ContainerData(
      key: "depreciationMethod",
      label: "Depreciation Method",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  assetsParentCategories(
    ContainerData(
      key: "assetsParentCategories",
      label: "Parent Categories",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  assetsCategories(
    ContainerData(
      key: "assetsCategories",
      label: "Categories",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  assets(
    ContainerData(
      key: "assets",
      label: "Manage Assets",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  country(
    ContainerData(
      key: "country",
      label: "Manage Countries",
      iconPath: "assets/images/shopping.png",
    ),
  ),
  manageallotedAllowance(
    ContainerData(
      key: "manageallotedAllowance",
      label: "Manage Alloted Allowance",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  // allowances(
  //   ContainerData(
  //     key: "allowance",
  //     label: "Allowance",
  //     iconPath: "assets/images/dollar.png",
  //   ),
  // ),
  discount(
    ContainerData(
      key: "discount",
      label: "Discount",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  termsAndCondition(
    ContainerData(
      key: "termsAndCondition",
      label: "Terms And Condition",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  vendorLogos(
    ContainerData(
      key: "vendorLogos",
      label: "Manage Vendor Logos",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  createEstimate(
    ContainerData(
      key: "createEstimate",
      label: "Create Estimate",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  creditNotes(
    ContainerData(
      key: "creditNotes",
      label: "Credit Notes",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  refundReceipts(
    ContainerData(
      key: "refundReceipts",
      label: "Refund Receipts",
      iconPath: "assets/images/dollar.png",
    ),
  ),
  nationality(
    ContainerData(
      key: "nationality",
      label: "Manage Nationality",
      iconPath: "assets/images/dollar.png",
    ),
  );

  final ContainerData data;

  const MainContainer(this.data);
}
