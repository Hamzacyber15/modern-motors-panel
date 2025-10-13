import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
// import 'package:app/file_download/download_mobile.dart'
//     if (dart.library.html) 'package:app/file_download/download_web.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/file_download/download_mobile.dart';
import 'package:modern_motors_panel/invoice_widget.dart/invoice_list_future_builder.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/business_models/business_profile_model.dart';
import 'package:modern_motors_panel/model/discount_models/offered_discount_model.dart';
import 'package:modern_motors_panel/model/drop_down_menu_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/commission_transaction_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/equipment_models/equipment_type_model.dart';
import 'package:modern_motors_panel/model/handling_orders/order_model.dart';
import 'package:modern_motors_panel/model/handling_orders/pallet_update_model.dart';
import 'package:modern_motors_panel/model/package_models/package_model.dart';
import 'package:modern_motors_panel/model/payment_data.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/model/purchase_models/new_purchase_model.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProductValidationException implements Exception {
  final String userMessage;
  final String technicalMessage;

  ProductValidationException({
    required this.userMessage,
    this.technicalMessage = '',
  });

  @override
  String toString() => technicalMessage;
}

class EmptyProductsException extends ProductValidationException {
  EmptyProductsException()
    : super(
        userMessage: "Please add at least one product to proceed",
        technicalMessage: "Product list cannot be empty",
      );
}

class InvalidQuantityException extends ProductValidationException {
  InvalidQuantityException(int rowNumber, String productName)
    : super(
        userMessage: "Quantity for '$productName' must be at least 1",
        technicalMessage:
            "Quantity in row $rowNumber cannot be less than 1 for product: $productName",
      );
}

class PriceBelowMinimumException extends ProductValidationException {
  PriceBelowMinimumException(
    int rowNumber,
    String productName,
    double sellingPrice,
    double minimumPrice,
  ) : super(
        userMessage:
            "Price for '$productName' cannot be less than ${minimumPrice.toStringAsFixed(2)} OMR",
        technicalMessage:
            "Selling price in row $rowNumber ($sellingPrice) cannot be less than minimum price ($minimumPrice) for product: $productName",
      );
}

class Constants {
  static String collectionPrefix = "test_";
  static String businessId = "";
  static String profileId = "";
  static bool bigScreen = false;
  static bool mediumScreen = false;
  static String language = "";
  static double vat = 5;
  static String adminId = "dVaqI5nCKQZnlqhiqNQyXAERJbG3";
  static final String mainBranchId = 'NRHLuRZIA2AMZXjW4TDI';
  static bool deposit = false;
  static double depositAmount = 0;
  static double driverCommission = 0.25;
  static double androidVersion = 4.3;
  static double iosVersion = 4.3;
  static double webVersion = 3.2;
  static String accessMessage =
      "You don’t have access to this functionality. Please contact the admin";
  static const String pallet_Alarm =
      'https://firebasestorage.googleapis.com/v0/b/globallogistics-94538.appspot.com/o/public%2Forder_alarm.mp3?alt=media&token=765e56af-d55a-4925-8141-c7f7fdd28c06';
  static const String clock_Alarm =
      "https://firebasestorage.googleapis.com/v0/b/globallogistics-94538.appspot.com/o/public%2Fclock-alarm.mp3?alt=media&token=c1ad1b8c-7019-4037-8832-99890749fbd0";
  static DropDownMenuDataModel a = DropDownMenuDataModel("", "A-1", "A-1");
  static DropDownMenuDataModel d = DropDownMenuDataModel("", "A-1", "A-1");
  static DropDownMenuDataModel o = DropDownMenuDataModel("", "A-1", "A-1");
  static DropDownMenuDataModel p = DropDownMenuDataModel("", "A-1", "A-1");
  static List<String> orderCategoryImage = [
    'assets/images/truck.png',
    'assets/images/semi-trailer.png',
    'assets/images/semi-trailer.png',
  ];

  static List<String> orderLoadingUnloadingImage = [
    'assets/images/truck.png',
    'assets/images/semi-trailer.png',
    'assets/images/semi-trailer.png',
  ];
  static PackageModel package = PackageModel(
    id: "",
    packageTitle: "",
    arabicPackageTitle: "",
    description: "",
    arabicDescription: "",
    labour: 0,
    price: 0,
    containerSize: "",
    estimatedDelivery: "",
    orderCategory: "",
    equipment: "",
    equipmentId: "",
    type: "",
    status: "",
    containerSizeArabic: "",
    estimatedDeliveryArabic: "",
  );
  static OrderModel order = OrderModel(
    id: "",
    assignedAt: Timestamp.now(),
    startedAt: Timestamp.now(),
    endedAt: Timestamp.now(),
    assignedTo: {},
    businessId: "",
    duration: "",
    equipmentId: "",
    price: 0,
    serviceType: "",
    status: "",
    warehouse: "",
    warehouseId: "",
    outdoorLocation: "",
    outdoorBuilding: "",
    tractorOption: "",
    trailerNumber: "",
    outdoorlocationId: "",
    packageId: "",
    timestamp: Timestamp.now(),
  );
  static EmployeeModel employee = EmployeeModel(
    emergencyName: "",
    emergencyContact: "",
    streetAddress1: "",
    streetAddress2: "",
    city: "",
    state: "",
    postalCode: "",
    countryId: "",
    roleId: "",
    dob: DateTime.now(),
    id: "",
    attachments: [],
    contactNumber: "",
    email: "",
    gender: "",
    branchId: "",
    designation: "",
    idCardNumber: "",
    name: "",
    otherCompany: "",
    status: "",
    timestamp: Timestamp.now(),
    userId: "",
    equipments: [],
    globalEmployee: false,
    assignedBuilding: "",
    assignedBuildingId: "",
    adminAccess: [],
  );
  static List<DropDownMenuDataModel> countries = [
    DropDownMenuDataModel("", "Oman", "country"),
    DropDownMenuDataModel("", "United Arab Emirates", "country"),
    DropDownMenuDataModel("", "Lebanon", "country"),
    DropDownMenuDataModel("", "Bahrain", "country"),
    DropDownMenuDataModel("", "India", "country"),
    DropDownMenuDataModel("", "Pakistan", "country"),
    DropDownMenuDataModel("", "Bangladesh", "country"),
    DropDownMenuDataModel("", "Egypt", "country"),
  ];

  static List<DropDownMenuDataModel> jobTitles = [
    DropDownMenuDataModel("", "Accountant", "accountant"),
    DropDownMenuDataModel("", "Operator", "operator"),
    DropDownMenuDataModel("", "Sales Person", "salesperson"),
    DropDownMenuDataModel("", "Store Manager", "storemanager"),
  ];

  static List<DropDownMenuDataModel> depositSources = [
    DropDownMenuDataModel("", "Bank", "bank"),
    DropDownMenuDataModel("", "Other", "other"),
  ];

  static List<DropDownMenuDataModel> searchList = [
    DropDownMenuDataModel("", "Invoice", "invoice"),
    //DropDownMenuDataModel("", "Status", "status"),
    DropDownMenuDataModel("", "Date", "date"),
  ];

  static List<DropDownMenuDataModel> forkListFilter = [
    DropDownMenuDataModel("", "Invoice", "invoice"),
    //DropDownMenuDataModel("", "Status", "status"),
    DropDownMenuDataModel("", "Date", "date"),
    DropDownMenuDataModel("", "Location", "location"),
  ];

  static List<DropDownMenuDataModel> labourOrderSearch = [
    DropDownMenuDataModel("", "Date", "date"),
    // DropDownMenuDataModel("", "0", "0"),
    // DropDownMenuDataModel("", "1", "1"),
    // DropDownMenuDataModel("", "2", "2"),
    // DropDownMenuDataModel("", "<3", "<3"),
  ];

  static List<DropDownMenuDataModel> searchListSorting = [
    DropDownMenuDataModel("", "Invoice", "invoice"),
    DropDownMenuDataModel("", "Ref Id", "ref id"),
    DropDownMenuDataModel("", "Job Ref", "job ref"),
    DropDownMenuDataModel("", "Date", "date"),
  ];

  static List<DropDownMenuDataModel> inspectionSearchList = [
    DropDownMenuDataModel("", "Custom Declaration", "Custom Declaration"),
    //DropDownMenuDataModel("", "Status", "status"),
    DropDownMenuDataModel("", "Date", "date"),
  ];

  static List<DropDownMenuDataModel> paymentMode = [
    DropDownMenuDataModel("4GZV0GZDCuXfh8Wz6cYM", "Bank", "Bank"),
    DropDownMenuDataModel(
      "MBC54WDNrqdkwJfIQKGl",
      "Swipe Machine",
      "swipe machine",
    ),
  ];

  static List<DropDownMenuDataModel> inspectionType = [
    DropDownMenuDataModel("", "Sealed", "sealed"),
    DropDownMenuDataModel("", "Unsealed", "unsealed"),
  ];

  // static final List<SaleModel> saleDataList = [
  //   SaleModel(
  //     "invoice": 15,
  //     id: "000testSale",
  //     "discountType": "percentage",
  //     "discount": 1.6,
  //     "depositA": 0,
  //     "remaining": 0,
  //     "quantity": 1,
  //     "totalRevenue": 15.12,
  //     "totalCost": 0,
  //     "profit": 0,
  //     customerName: "etkIMTnQDWnkgTcM0av3",
  //     "status": "pending",
  //     "previousStock": 0,
  //     "batchAllocations": [],
  //     paymentMethod: "cash",
  //     "taxAmount": 0.72,
  //     "createBy": "dVaqI5nCKQZnlqhiqNQyXAERJbG3",
  //     "truckId": null,
  //     "paymentData": {
  //       "isAlreadyPaid": false,
  //       "paymentMethods": [],
  //       "totalPaid": 0,
  //       "remainingAmount": 15.12,
  //     },
  //     "deposit": {
  //       "requireDeposit": false,
  //       "depositType": "percentage",
  //       "depositAmount": 0,
  //       "depositPercentage": 0,
  //       "depositAlreadyPaid": false,
  //       "nextPaymentAmount": 15.12,
  //     },
  //     "items": [
  //       {
  //         "type": "product",
  //         "productId": "VNauPX6k0jqmhNhsef9W",
  //         "productName": "diesel - wd-40",
  //         "quantity": 1,
  //         "unitPrice": 16,
  //         "totalPrice": 16,
  //         "discount": 0,
  //         "sellingPrice": 16,
  //       },
  //     ],
  //   );
  // ];

  static List<DropDownMenuDataModel> gccCountries = [
    DropDownMenuDataModel("", "Oman", "country"),
    DropDownMenuDataModel("", "United Arab Emirates", "country"),
    DropDownMenuDataModel("", "Bahrain", "country"),
    DropDownMenuDataModel("", "Saudia Arabia", "country"),
    DropDownMenuDataModel("", "Qatar", "country"),
    DropDownMenuDataModel("", "Kuwait", "country"),
    DropDownMenuDataModel("", "Yemen", "country"),
    DropDownMenuDataModel("", "Jordan", "country"),
    DropDownMenuDataModel("", "Lebanon", "country"),
    DropDownMenuDataModel("", "Egypt", "country"),
  ];

  static List<DropDownMenuDataModel> gccCountriesArabic = [
    DropDownMenuDataModel("1", "عمان", "country"),
    DropDownMenuDataModel("2", "الامارات العربية المتحدة", "country"),
    DropDownMenuDataModel("3", "البحرين", "country"),
    DropDownMenuDataModel("4", "السعودية", "country"),
    DropDownMenuDataModel("5", "قطر", "country"),
    DropDownMenuDataModel("6", "الكويت", "country"),
    DropDownMenuDataModel("7", "اليمن", "country"),
    DropDownMenuDataModel("8", "الاردن", "country"),
    DropDownMenuDataModel("9", "لبنان", "country"),
    DropDownMenuDataModel("10", "مصر", "country"),
    DropDownMenuDataModel("11", "السودان", "country"),
    DropDownMenuDataModel("12", "سوريا", "country"),
    DropDownMenuDataModel("13", "إيران", "country"),
  ];

  static List<DropDownMenuDataModel> ports = [
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "مستودع خارجي", "port"),
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "منفذ الوجاجة", "port"),
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "منفذ الربع الخالي ", "port"),
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "منفذ المزيونة ", "port"),
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "منفذ خطمة ملاحة ", "port"),
    DropDownMenuDataModel("5cwYneac1v0c52kDDksr", "مطار مسقط", "port"),
    DropDownMenuDataModel("Q5Ls1uIcIrgPsjNrkMDp", "ميناء صحار", "port"),
    DropDownMenuDataModel("NeZmdXlR0LHlBNTEbtVU", "ميناء صلالة", "port"),
    DropDownMenuDataModel("cdEa03c9OMScpMLLsjUA", "ميناء السويق", "port"),
    DropDownMenuDataModel(
      "HdvXhJckvkmxGe5O8ywu",
      "ميناء السلطان قابوس",
      "port",
    ),
    DropDownMenuDataModel("FMC2ZtlyC8U9lWcgcn4b", "ميناء شناص", "port"),
  ];

  static List<DropDownMenuDataModel> portsEnglish = [
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "External Warehouse", "port"),
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "Wajajah Border ", "port"),
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "Rub Alkali Border", "port"),
    DropDownMenuDataModel("tEDTy4nzSfUolU2C1F9I", "Mazyonah Border", "port"),
    DropDownMenuDataModel(
      "tEDTy4nzSfUolU2C1F9I",
      "Khatmat Milaha Border",
      "port",
    ),
    DropDownMenuDataModel("5cwYneac1v0c52kDDksr", "Muscat Airport", "port"),
    DropDownMenuDataModel("Q5Ls1uIcIrgPsjNrkMDp", "Sohar Port", "port"),
    DropDownMenuDataModel("NeZmdXlR0LHlBNTEbtVU", "Salalah Port", "port"),
    DropDownMenuDataModel("cdEa03c9OMScpMLLsjUA", "Suwaiq Port", "port"),
    DropDownMenuDataModel("HdvXhJckvkmxGe5O8ywu", "Sultan Qaboos Port", "port"),
    DropDownMenuDataModel("FMC2ZtlyC8U9lWcgcn4b", "Shinas Port", "port"),
  ];

  static List<DropDownMenuDataModel> truckSize = [
    DropDownMenuDataModel("", "1.5-Ton Bus", "truckSize"),
    DropDownMenuDataModel("", "1.5-Ton Pickup", "truckSize"),
    DropDownMenuDataModel("", "3 to 4-Ton", "truckSize"),
    DropDownMenuDataModel("", "7-Ton", "truckSize"),
    DropDownMenuDataModel("", "10 to 16-Ton", "truckSize"),
    DropDownMenuDataModel("", "40-Ton", "truckSize"),
    DropDownMenuDataModel("", "65-Ton", "truckSize"),
  ];

  static List<DropDownMenuDataModel> truckSizeArabic = [
    DropDownMenuDataModel("", "باص 1.5", "truckSize"),
    DropDownMenuDataModel("", "بيكب 1.5", "truckSize"),
    DropDownMenuDataModel("", "شاحنة 4 الى 3 طن", "truckSize"),
    DropDownMenuDataModel("", "شاحنة 7 طن", "truckSize"),
    DropDownMenuDataModel("", "شاحنة 16 الى 10 طن ", "truckSize"),
    DropDownMenuDataModel("", "شاحنة 40 طن", "truckSize"),
    DropDownMenuDataModel("", "شاحنة 65 طن", "truckSize"),
  ];

  static List<DropDownMenuDataModel> truckWeightArabic = [
    DropDownMenuDataModel("800", "طن 1.5", "800"),
    DropDownMenuDataModel("800", "1.5 طن", "800"),
    DropDownMenuDataModel("3000", "4 - 3 طن", "3000"),
    DropDownMenuDataModel("7000", "7 طن", "7000"),
    DropDownMenuDataModel("1000", "16-10 طن", "10000"),
    DropDownMenuDataModel("40000", "40 طن", "40000"),
    DropDownMenuDataModel("65000", "65 طن", "65000"),
  ];

  static List<DropDownMenuDataModel> handlingCategory = [
    DropDownMenuDataModel("Loading", "Loading", "Loading"),
    DropDownMenuDataModel("Unloading", "Unloading", "Unloading"),
  ];

  static List<DropDownMenuDataModel> orderCategory = [
    DropDownMenuDataModel("", "Indoor", "indoor"),
    DropDownMenuDataModel("", "Outdoor", "outdoor"),
  ];

  static List<DropDownMenuDataModel> tuktukEmployee = [
    DropDownMenuDataModel("", "Pakistani", "Pakistani"),
    DropDownMenuDataModel("", "Nigerian", "Nigerian"),
    DropDownMenuDataModel("", "Company", "Company"),
  ];

  static List<DropDownMenuDataModel> orderBasis = [
    DropDownMenuDataModel("L7PWgtYkk0yA3ANnkOHb", "pallet", "orderBasis"),
    DropDownMenuDataModel("31pFc0JKDtRQMPTvbrUf", "time", "orderBasis"),
    DropDownMenuDataModel("uBSKR6WDf0pIzIgiD5bf", "round", "orderBasis"),
    DropDownMenuDataModel("uBSKR6WDf0pIzIgiD5bf", "day", "orderBasis"),
  ];

  static List<DropDownMenuDataModel> indoorEquipmentType = [
    DropDownMenuDataModel(
      "",
      "Electric ForkLift",
      "Electric Forklift",
      image: "assets/images/electric_forklift.png",
    ),
    DropDownMenuDataModel(
      "",
      "Ride On ForkLift",
      "Ride On ForkLift",
      image: "assets/images/rideon_forklift.png",
    ),
  ];
  static List<DropDownMenuDataModel> outDoorEquipmentType = [
    DropDownMenuDataModel(
      "",
      'Four Wheel Forklift',
      '4 Wheel Diesel Forklift',
      image: "assets/images/4wheel_diesel_forklift.png",
    ),
    DropDownMenuDataModel(
      "",
      "Electric Tuk Tuk",
      "Electric Tuk Tuk",
      image: "assets/images/electric_tuk-tuk.png",
    ),
    DropDownMenuDataModel(
      "",
      "Tractor",
      "Tractor",
      image: "assets/images/tractor.jpeg",
    ),
    DropDownMenuDataModel(
      "",
      "10-Ton Reefer Truck",
      "10-Ton Reefer Truck",
      image: "assets/images/reefer_truck.png",
    ),
  ];

  static List<DropDownMenuDataModel> equipmentType = [
    DropDownMenuDataModel(
      "",
      "3-Wheel Electric ForkLift",
      "3-Wheel Electric Forklift",
      image: "assets/images/electric_forklift.png",
    ),
    DropDownMenuDataModel(
      "",
      "Ride On Electric ForkLift",
      "Ride On Electric ForkLift",
      image: "assets/images/rideon_forklift.png",
    ),
    DropDownMenuDataModel(
      "",
      '4-Wheel Forklift',
      '4-Wheel Diesel Forklift',
      image: "assets/images/4wheel_diesel_forklift.png",
    ),
    DropDownMenuDataModel(
      "",
      "Electric Tuk Tuk",
      "Electric Tuk Tuk",
      image: "assets/images/electric_tuk-tuk.png",
    ),
    DropDownMenuDataModel(
      "",
      "Tractor",
      "Tractor",
      image: "assets/images/tractor.jpeg",
    ),
    DropDownMenuDataModel(
      "",
      "10-Ton Reefer Truck",
      "10-Ton Reefer Truck",
      image: "assets/images/reefer_truck.png",
    ),
  ];

  static List<DropDownMenuDataModel> engineType = [
    DropDownMenuDataModel("", "Electric", "Electric"),
    DropDownMenuDataModel("", "Diesel", "Diesel"),
  ];

  static List<DropDownMenuDataModel> truckColors = [
    DropDownMenuDataModel("", "Black", "Black"),
    DropDownMenuDataModel("", "Grey", "Grey"),
    DropDownMenuDataModel("", "Blue", "Blue"),
    DropDownMenuDataModel("", "Green", "Green"),
    DropDownMenuDataModel("", "White", "White"),
  ];

  static List<DropDownMenuDataModel> discountType = [
    DropDownMenuDataModel("", "Regular", "Regular"),
    DropDownMenuDataModel("", "Admin", "Admin"),
    DropDownMenuDataModel("", "Timely", "Timely"),
    DropDownMenuDataModel("", "Lease", "Lease"),
  ];

  static List<DropDownMenuDataModel> employeeCategoryWithLabour = [
    // DropDownMenuDataModel("", "Operation Supervisor", "operation supervisor"),
    // DropDownMenuDataModel("", "Driver", "driver"),
    // // DropDownMenuDataModel("", "TukTuk Driver", "tuktuk driver"),
    // // DropDownMenuDataModel("", "Forklift Driver", "forklift driver"),
    DropDownMenuDataModel("", "Labour", "labour"),
  ];

  static List<DropDownMenuDataModel> employeeCategory = [
    DropDownMenuDataModel("", "Operation Supervisor", "operation supervisor"),
    DropDownMenuDataModel("", "Driver", "driver"),
    // DropDownMenuDataModel("", "TukTuk Driver", "tuktuk driver"),
    // DropDownMenuDataModel("", "Forklift Driver", "forklift driver"),
    // DropDownMenuDataModel("", "Labour", "labour"),
  ];

  static List<DropDownMenuDataModel> allEmployeeCategory = [
    DropDownMenuDataModel("", "All", "all"),
    DropDownMenuDataModel("", "Operation Supervisor", "operation supervisor"),
    DropDownMenuDataModel("", "Driver", "driver"),
    // DropDownMenuDataModel("", "TukTuk Driver", "tuktuk driver"),
    // DropDownMenuDataModel("", "Forklift Driver", "forklift driver"),
    DropDownMenuDataModel("", "Labour", "labour"),
  ];

  static List<DropDownMenuDataModel> driverActionOptions = [
    DropDownMenuDataModel(
      "",
      "Camera",
      "camera",
      image: "assets/images/camera.png",
    ),
    DropDownMenuDataModel(
      "",
      "Time out",
      "time out",
      image: "assets/images/timeout.png",
    ),
    DropDownMenuDataModel(
      "",
      "Chat",
      "chat",
      image: "assets/images/chatting.png",
    ),
    // DropDownMenuDataModel("", "Operation Supervisor", "operation supervisor"),
    // DropDownMenuDataModel("", "Driver", "driver"),
    // DropDownMenuDataModel("", "TukTuk Driver", "tuktuk driver"),
    // DropDownMenuDataModel("", "Forklift Driver", "forklift driver"),
    // DropDownMenuDataModel("", "Labour", "labour"),
  ];

  static List<String> supervisorId = [
    "9derzpOSuHhYMEOoMIwuydfTPPO2",
    "oqvtDa1dCnf5kjLE8snZJJ3155M2",
  ];

  static List<DropDownMenuDataModel> businessArea = [
    //  "Onion Shade": "مظلة بيع البصل ",
    // "Potato Shade": "مظلة بيع البطاطا ",
    // "Cold Storage": "المستودعات المبردة",
    // "Whole Sale":
    DropDownMenuDataModel("", "Parking Area (A)", "a"),
    DropDownMenuDataModel("", "Parking Area (B)", "b"),
    DropDownMenuDataModel("", "Parking Area (C)", "c"),
    DropDownMenuDataModel("", "Whole Sale", "Whole Sale"),
    DropDownMenuDataModel("", "Cold Storage", "Cold Storage"),
    DropDownMenuDataModel("", "Onion Shade", "Onion Shade"),
    DropDownMenuDataModel("", "Potato Shade", "Potato Shade"),
    DropDownMenuDataModel(
      "",
      "Sell from the truck area",
      "sell from thr truck area",
    ),
    DropDownMenuDataModel("", "Sorting Warehouse", "sorting warehouse"),
    DropDownMenuDataModel("", "Dry Storage", "dry storage"),
    DropDownMenuDataModel("", "Commercial Building (A)", "A"),
    DropDownMenuDataModel("", "Commercial Building (B)", "B"),
  ];

  static List<DropDownMenuDataModel> buildings = [
    //  "Onion Shade": "مظلة بيع البصل ",
    // "Potato Shade": "مظلة بيع البطاطا ",
    // "Cold Storage": "المستودعات المبردة",
    // "Whole Sale":
    DropDownMenuDataModel("", "Parking Area (A)", "Parking Area (A)"),
    DropDownMenuDataModel("", "Parking Area (C)", "Parking Area (C)"),
    DropDownMenuDataModel("", "Whole Sale", "Whole Sale"),
    DropDownMenuDataModel("", "Cold Storage", "Cold Storage"),
    DropDownMenuDataModel("", "Onion Shade", "Onion Shade"),
    DropDownMenuDataModel("", "Potato Shade", "Potato Shade"),
    DropDownMenuDataModel(
      "",
      "Sell from the truck area",
      "Sell from the truck area",
    ),
    DropDownMenuDataModel("", "Sorting Warehouse", "Sorting Warehouse"),
    DropDownMenuDataModel("", "Dry Storage", "Dry Storage"),
  ];

  static List<DropDownMenuDataModel> parkingArea = [
    DropDownMenuDataModel("", "Parking Area (A)", "a"),
    DropDownMenuDataModel("", "Parking Area (C)", "c"),
  ];

  static List<DropDownMenuDataModel> adminAccess = [
    DropDownMenuDataModel("", "Orders", "orders"),
    DropDownMenuDataModel("", "Parking A", "parking a"),
    DropDownMenuDataModel("", "Parking C", "parking c"),
    DropDownMenuDataModel("", "Business", "Business"),
    DropDownMenuDataModel("", "Available Drivers", "available Drivers"),
    DropDownMenuDataModel("", "Invoices", "invoices"),
    DropDownMenuDataModel("", "Silal Invoice", "silal invoice"),
    DropDownMenuDataModel("", "Employees", "employees"),
    DropDownMenuDataModel("", "Equipment Type", "equipment Type"),
    DropDownMenuDataModel("", "Equipment", "equipment"),
    DropDownMenuDataModel("", "Packages", "packages"),
    DropDownMenuDataModel("", "Parking", "parking"),
    DropDownMenuDataModel("", "Business Area", "business area"),
    DropDownMenuDataModel("", "Password", "password"),
    DropDownMenuDataModel("", "Commissions", "commissions"),
    DropDownMenuDataModel("", "Messages", "Messages"),
    DropDownMenuDataModel("", "Labour Limit Order", "labour limit order"),
    DropDownMenuDataModel("", "New Labour Booking", "new Labour Booking"),
    DropDownMenuDataModel("", "Register Trucks", "Register Trucks"),
    DropDownMenuDataModel("", "Edit Truck", "Edit Truck"),
    DropDownMenuDataModel("", "Unloading", "Unloading"),
    DropDownMenuDataModel("", "Payroll", "Payroll"),
    DropDownMenuDataModel("", "Lease", "Lease"),
    DropDownMenuDataModel("", "Add Balance", "Add Balance"),
    DropDownMenuDataModel("", "View Salary", "View Salary"),
    DropDownMenuDataModel("", "Edit Employee Profile", "Edit Employee Profile"),
    DropDownMenuDataModel("", "Grow Plus Driver", "Grow Plus Driver"),
    DropDownMenuDataModel(
      "",
      "Mark Handling Order Complete",
      "Mark Handling Order Complete",
    ),
    DropDownMenuDataModel("", "other Business Orders", "other Business Orders"),
    DropDownMenuDataModel("", "Add Spare Parts", "Add Spare Parts"),
    DropDownMenuDataModel(
      "",
      "Create Maintenance Logs",
      "Create Maintenance Logs",
    ),
    DropDownMenuDataModel("", "Assign Equipment", "Assign Equipment"),
    DropDownMenuDataModel(
      "",
      "other Business package reports",
      "other Business package reports",
    ),
    DropDownMenuDataModel(
      "",
      "verify loading unloading",
      "verify loading unloading",
    ),
    DropDownMenuDataModel(
      "",
      "Mark Maintenance Complete",
      "Mark Maintenance Complete",
    ),
    DropDownMenuDataModel("", "Create Invoice", "Create Invoice"),
  ];

  static List<DropDownMenuDataModel> coldStorageBlock = [
    DropDownMenuDataModel("", "D", "d"),
    DropDownMenuDataModel("", "E", "e"),
    DropDownMenuDataModel("", "F", "f"),
  ];

  static List<DropDownMenuDataModel> languageList = [
    DropDownMenuDataModel("", "Arabic", "arabic"),
    DropDownMenuDataModel("", "English", "english"),
    DropDownMenuDataModel("", "Malyalam", "malyalam"),
    DropDownMenuDataModel("", "Bangali", "bangali"),
    DropDownMenuDataModel("", "Urdu", "urdu"),
  ];

  static EquipmentTypeModel equipment = EquipmentTypeModel(
    id: "",
    equipmentBrand: "",
    equipmentNumber: "",
    equipmentType: "",
    status: "",
  );

  static BusinessProfileModel? businessProfile;

  static BusinessProfileModel businessProfileDummy = BusinessProfileModel(
    businessLogo: "",
    id: "",
    businessAddress: "",
    businessAreas: [],
    certificate: [],
    nameArabic: "",
    nameEnglish: "",
    phoneNumber: "",
    registrationNum: "",
    status: "",
    userCountry: "",
    userEmail: "",
    userId: "",
    userLanguage: "",
    userMobile: "",
    userName: "",
    vatNumber: "",
    type: "",
    userAttachment: [],
  );
  static PublicProfileModel profile = PublicProfileModel(
    "",
    "",
    Timestamp.now(),
    "",
    "",
    "",
    "",
    "",
  );

  static Future<String> uploadAttachment(AttachmentModel attachment) async {
    String url = '';
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return url;
    }
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = timestamp.toString() + user.uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child('attachments')
        .child(fileName);
    UploadTask? uploadTask;
    if (attachment.file != null) {
      uploadTask = ref.putFile(attachment.file!);
    }
    // else if (attachment.attachmentType.isNotEmpty) {
    //   uploadTask = ref.putFile(attachment.file!);
    // String url = await (await uploadTask).ref.getDownloadURL();
    // uploadTask = ref.putData(attachment.file!);
    //  }
    else if (attachment.bytes != null) {
      uploadTask = ref.putData(attachment.bytes!);
    }
    url = await (await uploadTask!).ref.getDownloadURL();
    return url;
  }

  static Future<String> uploadMulkiaAttachment(
    AttachmentModel attachment,
    String id,
  ) async {
    String url = '';
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return url;
    }
    final ref = FirebaseStorage.instance.ref().child('mulkia').child(id);
    UploadTask? uploadTask;
    if (attachment.file != null) {
      uploadTask = ref.putFile(attachment.file!);
    } else if (attachment.bytes != null) {
      uploadTask = ref.putData(attachment.bytes!);
    }
    url = await (await uploadTask!).ref.getDownloadURL();
    return url;
  }

  static String translateToArabic(String text) {
    if (text.startsWith('E-mail:')) {
      final parts = text.split(':');
      if (parts.length > 1) {
        return 'البريد الإلكتروني: ${parts.sublist(1).join(":").trim()}';
      }
    }

    final translations = {
      'Tel:': 'هاتف:',
      'P.O. BOX:': 'ص.ب:',
      'Postal Code': 'الرمز البريدي',
      'Ind, Area': 'المنطقة الصناعية',
      'Muscat - Sultanate of Oman': 'مسقط - سلطنة عمان',
      'Br. Sohat-Sultanate of Oman': 'فرع صحار - سلطنة عمان',
    };

    String translated = text;
    translations.forEach((k, v) {
      translated = translated.replaceAll(k, v);
    });

    translated = toArabicDigits(translated);

    return translated;
  }

  static String toArabicDigits(String input) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = input;
    for (int i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], eastern[i]);
    }
    return result;
  }

  static final regexForEmail = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');

  static String getFormattedDateTime(DateTime dt, String type) {
    String result = '';
    String hour = dt.hour.toString();
    String minutes = dt.minute.toString();
    String seconds = dt.minute.toString();
    String month = dt.month.toString();
    String day = dt.day.toString();
    String year = dt.year.toString();

    if (hour.length == 1) {
      hour = "0${dt.hour}";
    }
    if (minutes.length == 1) {
      minutes = "0${dt.minute}";
    }
    if (month.length == 1) {
      month = "0${dt.month}";
    }
    if (day.length == 1) {
      day = "0${dt.day}";
    }
    if (type == 'full') {
      result = "$day-$month-$year @ $hour:$minutes";
    } else if (type == 'justTime') {
      result = "$hour:$minutes:$seconds";
    } else if (type == 'justDate') {
      result = "${dt.day}/${dt.month}/${dt.year}";
    } else if (type == 'yearmonth') {
      result = "${dt.year}/$month";
    } else if (type == "simple") {
      result = "${dt.year}$month$day";
    }
    return result;
  }

  // static Future<String> getDownloadPath() async {
  //   String directory = "/storage/emulated/0/Download/";
  //   bool dirDownloadExists = await Directory(directory).exists();
  //   if (dirDownloadExists) {
  //     directory = "/storage/emulated/0/Download";
  //   } else {
  //     directory = "/storage/emulated/0/Downloads";
  //   }
  //   return directory;
  // }

  static Timestamp addDurationToTimestamp(String duration, Timestamp t) {
    try {
      double minutes = double.parse(duration);
      DateTime originalDateTime = t.toDate();
      DateTime updatedDateTime = originalDateTime.add(
        Duration(minutes: minutes.toInt()),
      );
      return Timestamp.fromDate(updatedDateTime);
    } catch (e) {
      throw FormatException("Invalid duration format: $duration");
    }
  }

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.tr()),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Future<String> getTempPath() async {
    String outputPath = "";
    Directory directory = await getTemporaryDirectory();
    bool directoryExists = await Directory(directory.path).exists();
    if (!directoryExists) {
      await Directory(directory.path).create(recursive: true);
    }
    outputPath = directory.path;
    return outputPath;
  }

  static Future<String> getDownloadPath() async {
    String directory = "/storage/emulated/0/Download/";
    bool dirDownloadExists = await Directory(directory).exists();
    if (dirDownloadExists) {
      directory = "/storage/emulated/0/Download";
    } else {
      directory = "/storage/emulated/0/Downloads";
    }
    return directory;
  }

  static double kMobileBreakpoint = 700;

  static bool isMobileView(BoxConstraints constraints) {
    return constraints.maxWidth <= kMobileBreakpoint;
  }

  static Future<bool> getPermisson() async {
    bool result = true;
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      result = true;
      status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        //Constants.showMessage(context, "Permission denied");
        result = false;
      }
    }
    return result;
  }

  static downloadImage(String id) async {
    if (
    //loading &&
    FirebaseAuth.instance.currentUser == null) {
      return;
    }
    // if (!await getPermisson()) {
    //   return;
    // }

    try {
      // setState(() {
      //   downloading = true;
      //   loading = true;
      // });
      String downloadPath = await getDownloadPath();
      String savePath = "$downloadPath/download.png";
      if (Directory(downloadPath).existsSync()) {
        final dio = Dio();
        debugPrint(savePath);
        await dio.download(
          id,
          savePath,
          onReceiveProgress: (received, total) async {
            if (total != -1) {
              // setState(() {
              //   progress = (received / total) * 100;
              // });
              // if (progress == 100) {
              //   Constants.showMessage(context, "Saved, successfully");
              // }
            } else {
              debugPrint(received.toString());
            }
          },
        );
      }
      // setState(() {
      //   loading = false;
      // });
    } catch (e) {
      //  Constants.showMessage(context, e.toString());
    }
  }

  static Future<void> download(String url, String fileName) async {
    await downloadFile(url, fileName);
  }

  static void showImageDialog(
    BuildContext context,
    String imageUrl, {
    OrderModel? order,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () =>
                            download(imageUrl, "${order!.invoiceId!}.png"),
                        icon: Icon(Icons.download, color: AppTheme.redColor),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close, color: AppTheme.redColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint("Error loading image: $error");
                      return const Center(
                        child: Text(
                          "Failed to load image",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void confirmPalletDialog(
    BuildContext context,
    List<PalletUpdateModel> data,
    VoidCallback cancel, {
    OrderModel? order,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pallet Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  onPressed: cancel,
                  icon: Icon(Icons.cancel, color: AppTheme.redColor),
                ),
              ],
            ),
            actions: [
              Column(
                children: [
                  for (int i = 0; i < data.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          trailing: GestureDetector(
                            onTap: () => Constants.showImageDialog(
                              context,
                              data[i].url,
                              order: order,
                            ),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(data[i].url),
                                ),
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor,
                            radius: 32,
                            child: Text(
                              "${i + 1}",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.whiteColor,
                              ),
                            ),
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: "${"startedAt".tr()} : ",
                              style: TextStyle(
                                color: AppTheme.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Raleway",
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: Constants.getFormattedDateTime(
                                    data[i].startedAt!.toDate(),
                                    "justTime",
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.blackColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Raleway",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "${"status".tr()} : ",
                                  style: TextStyle(
                                    color: AppTheme.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Raleway",
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: data[i].status,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.blackColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Raleway",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (data[i].status == "completed")
                                RichText(
                                  text: TextSpan(
                                    text: "${"completedAt".tr()} : ",
                                    style: TextStyle(
                                      color: AppTheme.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway",
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: Constants.getFormattedDateTime(
                                          data[i].completedAt!.toDate(),
                                          "justTime",
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.blackColor,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Raleway",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Divider(),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> isHrDesignationIdAssigned(String hrDesignationId) async {
    // setState(() {
    //   loading = true;
    // });
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('employees')
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (data.containsKey('hrInfo')) {
          final hrInfo = data['hrInfo'];
          if (hrInfo != null &&
              hrInfo is Map &&
              hrInfo.containsKey('hrDesignationId') &&
              hrInfo['hrDesignationId'] == hrDesignationId) {
            return true; // Found
          }
        }
      }
      // setState(() {
      //   loading = false;
      // });
    } catch (e) {
      debugPrint('Error checking HR Designation ID: $e');
    }

    return false; // Not found
  }

  static Future<bool> checkHeadingIdExists(String headingId) async {
    final designationCollection = FirebaseFirestore.instance.collection(
      'designation',
    );

    try {
      final querySnapshot = await designationCollection.get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();

        if (data.containsKey('allowances') && data['allowances'] is List) {
          final List<dynamic> allowances = data['allowances'];

          for (final allowance in allowances) {
            if (allowance is Map<String, dynamic> &&
                allowance['headingId'] == headingId) {
              return true;
            }
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error checking headingId: $e');
      return false;
    }
  }

  static Future<String> getComissionDocId(
    String id,
    List<CommissionTransactionModel> existingCommissionList,
  ) async {
    String docId = "";
    for (int i = 0; i < existingCommissionList.length; i++) {
      if (id == existingCommissionList[i].employeeId) {
        docId = existingCommissionList[i].id;
      }
    }
    return docId;
  }

  static Future<List<CommissionTransactionModel>> getCommissionDoc(
    OrderModel order,
  ) async {
    List<CommissionTransactionModel> existingCommissionList = [];
    try {
      for (int i = 0; i < order.assignedLabour!.length; i++) {
        await FirebaseFirestore.instance
            .collection('commissions')
            .where('orderId', isEqualTo: order.id)
            .where('employeeId', isEqualTo: order.assignedLabour![i])
            .get()
            .then((value) {
              for (var doc in value.docs) {
                CommissionTransactionModel? commission =
                    CommissionTransactionModel.getCommissionList(doc);
                if (commission != null) {
                  existingCommissionList.add(commission);
                }
              }
            });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return existingCommissionList;
  }

  static Future<String> uploadMedia(
    AttachmentModel attachment,
    String id,
    String path,
  ) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(attachment.file!);
      String url = await (await uploadTask).ref.getDownloadURL();
      await updateAttachment(path, id, attachment, url);
      return url;
    } catch (e) {
      return "";
    }
  }

  static Future<bool> updateAttachment(
    String path,
    String id,
    AttachmentModel attachment,
    String downloadURL,
  ) async {
    return FirebaseFirestore.instance
        .collection(path)
        .doc(id)
        .set(attachment.toFirestore(downloadURL))
        .then((value) {
          return true;
        })
        .catchError((onError) {
          return false;
        });
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text.tr();
    }
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  static Future<String> getUniqueNumber(String type) async {
    String uniqueCode = "";
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getUniqueNumber',
      );
      final results = await callable({'numberType': type});
      if (results.data != '-1') {
        //debugPrint(results.data.toString());
        uniqueCode = results.data.toString();
      } else {
        debugPrint("please try again later");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return uniqueCode;
  }

  static Future<dynamic> getUniqueNumberValue(String type) async {
    try {
      // Reference to the document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("currentUniqueNumbers")
          .doc(type)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data["value"]; // Return the value for the given key
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error fetching value: $e");
      return null;
    }
  }

  // static List<Map<String, dynamic>> buildProductsData(
  //   List<dynamic> productRows,
  // ) {
  //   return productRows.map((row) {
  //     return {
  //       'type': row.saleItem?.type,
  //       'productId': row.saleItem?.productId,
  //       'productName': row.saleItem?.productName,
  //       'sellingPrice': row.sellingPrice,
  //       'quantity': row.quantity,
  //       'discount': row.discount,
  //       'applyVat': row.applyVat,
  //       'subtotal': row.subtotal,
  //       'vatAmount': row.vatAmount,
  //       'total': row.total,
  //       'profit': row.profit,
  //     };
  //   }).toList();
  // }

  // static List<Map<String, dynamic>> buildProductsData(
  //   List<dynamic> productRows,
  // ) {
  //   // Check if productRows is empty
  //   if (productRows.isEmpty) {
  //     throw Exception("Product list cannot be empty");
  //   }

  //   // Validate each row before processing
  //   for (int i = 0; i < productRows.length; i++) {
  //     final row = productRows[i];
  //     final rowNumber = i + 1;

  //     // Check if row is null
  //     if (row == null) {
  //       throw Exception("Row $rowNumber is null");
  //     }

  //     // Check quantity cannot be less than 1
  //     if (row.quantity < 1) {
  //       throw Exception("Quantity in row $rowNumber cannot be less than 1");
  //     }

  //     // Check if sellingPrice is less than minimumPrice
  //     final minimumPrice = row.saleItem?.minimumPrice ?? 0;
  //     if (row.sellingPrice < minimumPrice) {
  //       throw Exception(
  //         "Selling price in row $rowNumber (${row.sellingPrice}) cannot be less than minimum price ($minimumPrice) for product: ${row.saleItem?.productName ?? 'Unknown'}",
  //       );
  //     }

  //     // Additional validation for required fields
  //     if (row.saleItem?.productId == null || row.saleItem?.productId.isEmpty) {
  //       throw Exception("Product ID is missing in row $rowNumber");
  //     }

  //     if (row.saleItem?.productName == null ||
  //         row.saleItem?.productName.isEmpty) {
  //       throw Exception("Product name is missing in row $rowNumber");
  //     }
  //   }

  //   // If all validations pass, build the data
  //   return productRows.map((row) {
  //     return {
  //       'type': row.saleItem?.type,
  //       'productId': row.saleItem?.productId,
  //       'productName': row.saleItem?.productName,
  //       'sellingPrice': row.sellingPrice,
  //       'quantity': row.quantity,
  //       'discount': row.discount,
  //       'applyVat': row.applyVat,
  //       'subtotal': row.subtotal,
  //       'vatAmount': row.vatAmount,
  //       'total': row.total,
  //       'profit': row.profit,
  //     };
  //   }).toList();
  // }

  static List<Map<String, dynamic>> buildProductsData(
    List<dynamic> productRows,
  ) {
    if (productRows.isEmpty) {
      throw EmptyProductsException();
    }

    for (int i = 0; i < productRows.length; i++) {
      final row = productRows[i];
      final rowNumber = i + 1;
      final productName = row.saleItem?.productName ?? 'Unknown Product';

      if (row == null) {
        throw ProductValidationException(
          userMessage: "Invalid product in row $rowNumber",
          technicalMessage: "Row $rowNumber is null",
        );
      }

      if (row.quantity < 1 || row.quantity == 0) {
        throw InvalidQuantityException(rowNumber, productName);
      }

      final minimumPrice = row.saleItem?.minimumPrice ?? 0;
      if (row.sellingPrice < minimumPrice) {
        throw PriceBelowMinimumException(
          rowNumber,
          productName,
          row.sellingPrice,
          minimumPrice,
        );
      }
    }

    return productRows.map((row) {
      return {
        'type': row.saleItem?.type,
        'productId': row.saleItem?.productId,
        'productName': row.saleItem?.productName,
        'sellingPrice': row.sellingPrice,
        'quantity': row.quantity,
        'discount': row.discount,
        'applyVat': row.applyVat,
        'subtotal': row.subtotal,
        'vatAmount': row.vatAmount,
        'total': row.total,
        'profit': row.profit,
      };
    }).toList();
  }

  static void showValidationError(BuildContext context, dynamic error) {
    String userMessage;

    if (error is ProductValidationException) {
      userMessage = error.userMessage;
    } else if (error is Exception) {
      // Handle generic exceptions
      userMessage = _getUserFriendlyMessage(error.toString());
    } else {
      userMessage = "An unexpected error occurred. Please try again.";
    }

    _showErrorDialog(context, userMessage);
  }

  static String _getUserFriendlyMessage(String technicalMessage) {
    if (technicalMessage.contains('Product list cannot be empty')) {
      return "Please add at least one product to proceed";
    } else if (technicalMessage.contains('Quantity') &&
        technicalMessage.contains('less than 1')) {
      return "Product quantity must be at least 1";
    } else if (technicalMessage.contains('Selling price') &&
        technicalMessage.contains('less than minimum price')) {
      return "Product price is below the minimum allowed price";
    } else {
      return "Please check all product information and try again";
    }
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Validation Error', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  static SaleModel parseToSaleModel({
    required List<Map<String, dynamic>> productsData,
    required Map<String, dynamic> depositData,
    required Map<String, dynamic> paymentData,
    required double totalRevenue,
    required double discount,
    required double taxAmount,
    required String customerName,
    required String? truckId,
    required bool isEdit,
  }) {
    // Validate that productsData is not empty
    if (productsData.isEmpty) {
      throw ArgumentError('productsData cannot be empty');
    }

    // Validate required fields
    if (customerName.isEmpty) {
      throw ArgumentError('customerName cannot be empty');
    }

    // Calculate totals from products data with null safety
    double totalCost = 0;
    double totalProfit = 0;
    int totalQuantity = 0;
    List<SaleItem> saleItems = [];
    List<ProductUpdated> productsUpdated = [];

    for (var product in productsData) {
      // Validate each product has required fields
      if (product['productId'] == null ||
          product['productId'].toString().isEmpty) {
        throw ArgumentError('Each product must have a productId');
      }

      final cost = (product['sellingPrice'] as num?)?.toDouble() ?? 0;
      final quantity = (product['quantity'] as num?)?.toInt() ?? 0;
      final profit = (product['profit'] as num?)?.toDouble() ?? 0;

      totalCost += cost * quantity;
      totalProfit += profit * quantity;
      totalQuantity += quantity;

      // Create SaleItem
      saleItems.add(
        SaleItem(
          productId: product['productId'] as String? ?? '',
          productName: product['productName'] as String? ?? '',
          quantity: quantity,
          unitPrice: cost,
          sellingPrice: cost,
          minimumPrice: (product['minimumPrice'] as num?)?.toDouble() ?? 0,
          discount: (product['discount'] as num?)?.toDouble() ?? 0,
          margin: 0,
          totalPrice: (product['total'] as num?)?.toDouble() ?? 0,
          type: product['type'] as String? ?? 'product',
          cost: (product['cost'] as num?)?.toDouble() ?? 0,
        ),
      );

      // Create ProductUpdated
      productsUpdated.add(
        ProductUpdated(
          productId: product['productId'] as String? ?? '',
          quantityDeducted: 0,
          stockAfter: 0,
          stockBefore: 0,
        ),
      );
    }

    // Parse deposit data with defaults
    final deposit = Deposit(
      depositA: (depositData['depositAmount'] as num?)?.toDouble() ?? 0,
      requireDeposit: depositData['requireDeposit'] as bool? ?? false,
      depositType: depositData['depositType'] as String? ?? '',
      depositAmount: (depositData['depositAmount'] as num?)?.toDouble() ?? 0,
      depositPercentage:
          (depositData['depositPercentage'] as num?)?.toDouble() ?? 0,
      depositAlreadyPaid: depositData['depositAlreadyPaid'] as bool? ?? false,
      nextPaymentAmount:
          (depositData['nextPaymentAmount'] as num?)?.toDouble() ?? 0,
    );

    // Parse payment data with validation
    final paymentMethods =
        (paymentData['paymentMethods'] as List<dynamic>?)?.map((method) {
          final methodMap = method as Map<String, dynamic>;
          return PaymentMethod(
            method: methodMap['method'] ?? "",
            methodName: methodMap['methodName'] ?? "",
            reference: methodMap['reference'] ?? "",
            amount: (methodMap['amount'] as num?)?.toDouble() ?? 0,
          );
        }).toList() ??
        [];

    final paymentInfo = PaymentData(
      isAlreadyPaid: paymentData['isAlreadyPaid'] as bool? ?? false,
      paymentMethods: paymentMethods,
      totalPaid: (paymentData['totalPaid'] as num?)?.toDouble() ?? 0,
      remainingAmount:
          (paymentData['remainingAmount'] as num?)?.toDouble() ?? 0,
    );

    // Generate a unique ID or use existing one
    final String saleId = ""; //existingBooking?.id ?? _generateSaleId();

    // Determine payment method from payment data
    String primaryPaymentMethod = 'cash';
    if (paymentMethods.isNotEmpty) {
      if (paymentMethods.length == 1) {
        primaryPaymentMethod = paymentMethods.first.method ?? 'cash';
      } else {
        primaryPaymentMethod = 'multiple';
      }
    }

    // Create the SaleModel
    return SaleModel(
      id: saleId,
      customerName: customerName,
      paymentMethod: primaryPaymentMethod,
      createdAt: DateTime.now(),
      processedAt: DateTime.now(),
      batchAllocations: [],
      batchesUsed: [],
      items: saleItems,
      serviceItems: [],
      productsUpdated: productsUpdated,
      profit: totalProfit,
      quantity: totalQuantity,
      saleId: saleId,
      sellingPrice: totalRevenue,
      status: 'completed',
      totalCost: totalCost,
      totalQuantityProcessed: totalQuantity,
      totalRevenue: totalRevenue,
      updatedAt: DateTime.now(),
      createdBy: 'system',
      invoice: _generateInvoiceNumber(),
      createBy: 'system',
      taxAmount: taxAmount,
      truckId: truckId,
      previousStock: 0,
      productId: saleItems.isNotEmpty ? saleItems.first.productId : '',
      productName: saleItems.isNotEmpty ? saleItems.first.productName : '',
      deposit: deposit,
      discount: discount,
      discountType: 'percentage',
      paymentData: paymentInfo,
      remaining: paymentInfo.remainingAmount,
      draft: isEdit ? 'updated' : null,
    );
  }

  static NewPurchaseModel parseToPurchaseModel({
    required List<Map<String, dynamic>> productsData,
    required Map<String, dynamic> depositData,
    required Map<String, dynamic> paymentData,
    required double totalRevenue,
    required double discount,
    required double taxAmount,
    required String supplierId,
    required bool isEdit,
  }) {
    // Validate that productsData is not empty
    if (productsData.isEmpty) {
      throw ArgumentError('productsData cannot be empty');
    }

    // Validate required fields
    if (supplierId.isEmpty) {
      throw ArgumentError('customerName cannot be empty');
    }

    // Calculate totals from products data with null safety
    double totalCost = 0;
    double totalProfit = 0;
    int totalQuantity = 0;
    List<PurchaseItem> purchaseItems = [];

    for (var product in productsData) {
      // Validate each product has required fields
      if (product['productId'] == null ||
          product['productId'].toString().isEmpty) {
        throw ArgumentError('Each product must have a productId');
      }

      final cost = (product['sellingPrice'] as num?)?.toDouble() ?? 0;
      final quantity = (product['quantity'] as num?)?.toInt() ?? 0;
      final profit = (product['profit'] as num?)?.toDouble() ?? 0;

      totalCost += cost * quantity;
      totalProfit += profit * quantity;
      totalQuantity += quantity;

      // Create SaleItem
      purchaseItems.add(
        PurchaseItem(
          productId: product['productId'] as String? ?? '',
          productName: product['productName'] as String? ?? '',
          quantity: quantity,
          unitPrice: cost,
          sellingPrice: cost,
          minimumPrice: (product['minimumPrice'] as num?)?.toDouble() ?? 0,
          discount: (product['discount'] as num?)?.toDouble() ?? 0,
          margin: 0,
          totalPrice: (product['total'] as num?)?.toDouble() ?? 0,
          type: product['type'] as String? ?? 'product',
          cost: (product['cost'] as num?)?.toDouble() ?? 0,
        ),
      );
    }

    // Parse deposit data with defaults
    final deposit = Deposit(
      depositA: (depositData['depositAmount'] as num?)?.toDouble() ?? 0,
      requireDeposit: depositData['requireDeposit'] as bool? ?? false,
      depositType: depositData['depositType'] as String? ?? '',
      depositAmount: (depositData['depositAmount'] as num?)?.toDouble() ?? 0,
      depositPercentage:
          (depositData['depositPercentage'] as num?)?.toDouble() ?? 0,
      depositAlreadyPaid: depositData['depositAlreadyPaid'] as bool? ?? false,
      nextPaymentAmount:
          (depositData['nextPaymentAmount'] as num?)?.toDouble() ?? 0,
    );

    // Parse payment data with validation
    final paymentMethods =
        (paymentData['paymentMethods'] as List<dynamic>?)?.map((method) {
          final methodMap = method as Map<String, dynamic>;
          return PaymentMethod(
            method: methodMap['method'] ?? "",
            methodName: methodMap['methodName'] ?? "",
            reference: methodMap['reference'] ?? "",
            amount: (methodMap['amount'] as num?)?.toDouble() ?? 0,
          );
        }).toList() ??
        [];

    final paymentInfo = PaymentData(
      isAlreadyPaid: paymentData['isAlreadyPaid'] as bool? ?? false,
      paymentMethods: paymentMethods,
      totalPaid: (paymentData['totalPaid'] as num?)?.toDouble() ?? 0,
      remainingAmount:
          (paymentData['remainingAmount'] as num?)?.toDouble() ?? 0,
    );

    // Generate a unique ID or use existing one
    final String saleId = ""; //existingBooking?.id ?? _generateSaleId();

    // Determine payment method from payment data
    String primaryPaymentMethod = 'cash';
    if (paymentMethods.isNotEmpty) {
      if (paymentMethods.length == 1) {
        primaryPaymentMethod = paymentMethods.first.method ?? 'cash';
      } else {
        primaryPaymentMethod = 'multiple';
      }
    }

    // Create the SaleModel
    return NewPurchaseModel(
      id: saleId,
      supplierId: supplierId,
      branchId: "",
      paymentMethod: primaryPaymentMethod,
      createdAt: DateTime.now(),
      processedAt: DateTime.now(),
      items: purchaseItems,
      quantity: totalQuantity,
      purchasePrice: totalRevenue,
      status: 'completed',
      totalCost: totalCost,
      totalQuantityProcessed: totalQuantity,
      updatedAt: DateTime.now(),
      createdBy: 'system',
      invoice: _generateInvoiceNumber(),
      createBy: 'system',
      taxAmount: taxAmount,
      previousStock: 0,
      productId: purchaseItems.isNotEmpty ? purchaseItems.first.productId : '',
      productName: purchaseItems.isNotEmpty
          ? purchaseItems.first.productName
          : '',
      deposit: deposit,
      discount: discount,
      discountType: 'percentage',
      paymentData: paymentInfo,
      remaining: paymentInfo.remainingAmount,
      draft: isEdit ? 'updated' : null,
    );
  }

  static String _generateSaleId() {
    return 'SALE_${DateTime.now().millisecondsSinceEpoch}';
  }

  static String _generateInvoiceNumber() {
    return 'INV_${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  static Future<String> getUniqueNumberWithCode(String type) async {
    String uniqueCode = "";
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getUniqueNumberWithCode',
      );
      final results = await callable({'code': type});
      if (results.data != '-1') {
        //debugPrint(results.data.toString());
        uniqueCode = results.data.toString();
      } else {
        debugPrint("please try again later");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return uniqueCode;
  }

  static Future<bool?> confirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.greenColor, // Text Color
              ),
              //style: ButtonStyle(backgroundColor: AppTheme.greenColor),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Yes", style: TextStyle(color: AppTheme.whiteColor)),
            ),
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(false),
            //   child: const Text("No"),
            // ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.redColor, // Text Color
              ),
              //style: ButtonStyle(backgroundColor: AppTheme.greenColor),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No", style: TextStyle(color: AppTheme.whiteColor)),
            ),
          ],
        );
      },
    );
    return result;
  }

  static String monthToString(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }

  static Future<bool?> confirmDialogAlert(BuildContext context) async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Image.asset(
            'assets/images/warning.png',
            height: 100,
            width: 100,
          ),
          title: Text(
            "${"warning".tr()}!!!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.redColor,
              fontSize: 20,
            ),
          ),
          content: Text(
            "eConsent".tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.greenColor, // Text Color
                      ),
                      //style: ButtonStyle(backgroundColor: AppTheme.greenColor),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        "yes".tr(),
                        style: TextStyle(color: AppTheme.whiteColor),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(child: Text("warningAgree".tr())),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.redColor, // Text Color
                      ),
                      //style: ButtonStyle(backgroundColor: AppTheme.greenColor),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        "no".tr(),
                        style: TextStyle(color: AppTheme.whiteColor),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(child: Text("warningDecline".tr())),
                  ],
                ),
              ],
            ),
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(false),
            //   child: const Text("No"),
            // ),
          ],
        );
      },
    );
    return result;
  }

  static Future<Uint8List> getMarkerBitmap(String initials, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;
    const double radius = 18.0;
    canvas.drawCircle(const Offset(radius, radius), radius, paint);
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: initials.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );
    final img = await pictureRecorder.endRecording().toImage(
      (radius * 2).toInt(),
      (radius * 2).toInt(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  static Future<String> markOrder(String orderID, String status) async {
    String result = "";
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'markOrder',
      );
      final results = await callable({'orderID': orderID, 'status': status});
      result = results.data.toString();
    } catch (e) {
      result = "error, please try again later";
      debugPrint(e.toString());
    }
    return result;
  }

  static Future<String> markPendingOrder(String orderID) async {
    String result = "";
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'markIncompletePendingOrder',
      );
      final results = await callable({'orderID': orderID});
      result = results.data.toString();
    } catch (e) {
      result = "error, please try again later";
      debugPrint(e.toString());
    }
    return result;
  }

  static DateTime? convertToDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  static String formatPrice(double? price) {
    if (price == null) return "0.00";
    return price.toStringAsFixed(2);
  }

  static Future<OfferedDiscountModel?> getCurrentDiscount(String id) async {
    OfferedDiscountModel? discount;
    try {
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day, 0, 0, 0);
      await FirebaseFirestore.instance
          .collection('discountsAvailed')
          .where('businessId', isEqualTo: id)
          // .where('status', isNotEqualTo: "pending")
          .where('validity', isGreaterThanOrEqualTo: today)
          .get()
          .then((value) {
            // for (var doc in value.docs) {
            //   OfferedDiscountModel? od =
            //       OfferedDiscountModel.getOfferedDiscount(doc);
            //   if (od != null) {
            //     DateTime now = DateTime.now();
            //     DateTime today = DateTime(now.year, now.month, now.day);
            //     DateTime startDate = DateTime(
            //         od.startDate.year, od.startDate.month, od.startDate.day);
            //     DateTime endDate =
            //         DateTime(od.validity.year, od.validity.month, od.validity.day);

            //     if (today.isAfter(startDate) ||
            //         now.isAfter(startDate) && today.isBefore(endDate) ||
            //         now.isBefore(endDate)) {
            //       discount = od;
            //     }
            //   }
            // }
            OfferedDiscountModel? timelyDiscount;
            OfferedDiscountModel? anyValidDiscount;

            // for (var doc in value.docs) {
            //   OfferedDiscountModel? od =
            //       OfferedDiscountModel.getOfferedDiscount(doc);
            //   if (od != null) {
            //     DateTime now = DateTime.now();
            //     DateTime today = DateTime(now.year, now.month, now.day);
            //     DateTime startDate = DateTime(
            //         od.startDate.year, od.startDate.month, od.startDate.day);
            //     DateTime endDate =
            //         DateTime(od.validity.year, od.validity.month, od.validity.day);
            //     bool isValid =
            //         today.isAfter(startDate) && today.isBefore(endDate) ||
            //             today == startDate ||
            //             today == endDate;

            //     if (isValid) {
            //       if (od.discountType == "Timely") {
            //         if (od.status != "pending") {
            //           timelyDiscount = od;
            //         }
            //       } else {
            //         anyValidDiscount ??= od;
            //       }
            //     }
            //   }
            // }
            for (var doc in value.docs) {
              OfferedDiscountModel? od =
                  OfferedDiscountModel.getOfferedDiscount(doc);
              if (od != null) {
                DateTime now = DateTime.now();
                DateTime today = DateTime(now.year, now.month, now.day);
                if (od.discountType == "Timely") {
                  bool isValid =
                      now.isAfter(od.startDate) && now.isBefore(od.validity) ||
                      now.isAtSameMomentAs(od.startDate) ||
                      now.isAtSameMomentAs(od.validity);
                  if (isValid && od.status != "pending") {
                    timelyDiscount = od;
                  }
                } else {
                  DateTime startDate = DateTime(
                    od.startDate.year,
                    od.startDate.month,
                    od.startDate.day,
                  );
                  DateTime endDate = DateTime(
                    od.validity.year,
                    od.validity.month,
                    od.validity.day,
                  );
                  bool isValid =
                      (today.isAfter(startDate) && today.isBefore(endDate)) ||
                      today == startDate ||
                      today == endDate;

                  if (isValid) {
                    anyValidDiscount ??= od;
                  }
                }
              }
            }
            discount = timelyDiscount ?? anyValidDiscount;
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return discount;
  }

  static Future<OfferedDiscountModel?> getTimeDiscount(String id) async {
    OfferedDiscountModel? discount;
    bool isValid = false;
    try {
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day, 0, 0, 0);
      await FirebaseFirestore.instance
          .collection('discountsAvailed')
          .where('businessId', isEqualTo: id)
          .where('discountType', isEqualTo: "Timely")
          .where('validity', isGreaterThanOrEqualTo: today)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              OfferedDiscountModel? od =
                  OfferedDiscountModel.getOfferedDiscount(doc);
              if (od != null) {
                bool isValid = false;
                DateTime now = DateTime.now();
                DateTime startDate = DateTime(
                  od.startDate.year,
                  od.startDate.month,
                  od.startDate.day,
                );
                DateTime endDate = DateTime(
                  od.validity.year,
                  od.validity.month,
                  od.validity.day,
                );
                if (od.status == "pending") {
                  isValid =
                      (today.isAfter(startDate) && today.isBefore(endDate)) ||
                      today == startDate ||
                      today == endDate;
                } else if (od.status == "active") {
                  isValid =
                      (now.isAfter(od.startDate) &&
                          now.isBefore(od.validity)) ||
                      now.isAtSameMomentAs(od.startDate) ||
                      now.isAtSameMomentAs(od.validity);
                }
                if (isValid) {
                  discount = od; // keep updating with the latest valid one
                }
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return discount;
  }

  static Future<double> getWalletBalance() async {
    double amount = 0;
    try {
      await FirebaseFirestore.instance
          .collection('wallet')
          .doc(Constants.businessId)
          .get()
          .then((doc) {
            if (doc.exists) {
              amount = double.tryParse(doc['depositAmount'].toString()) ?? 0;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return amount;
  }

  static String getText(String type, String duration) {
    String result = "";
    if (type == "pallet") {
      return result = "$type-$duration";
    } else if (type == "round") {
      return result = "$duration-$type";
    } else {
      int totalMinutes = double.parse(duration).toInt();

      // Check if the input is less than 60 minutes
      if (totalMinutes < 60) {
        return result = '$totalMinutes minute${totalMinutes == 1 ? '' : 's'}';
      }

      // Calculate hours and remaining minutes
      int hours = totalMinutes ~/ 60;
      int remainingMinutes = totalMinutes % 60;

      // Construct the result string based on hours and minutes
      if (remainingMinutes == 0) {
        return result = '$hours hour${hours == 1 ? '' : 's'}';
      } else {
        return result =
            '$hours hour${hours == 1 ? '' : 's'} $remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}';
      }
    }
  }

  static String getTextHeading(String type, String duration) {
    String result = "";
    if (type == "pallet") {
      return result = "${type.tr()} - $duration";
    } else if (type == "round") {
      return result = "${type.tr()} - $duration";
    } else {
      int totalMinutes = double.parse(duration).toInt();
      if (totalMinutes < 60) {
        return result = '$totalMinutes minute${totalMinutes == 1 ? '' : 's'}';
      }
      int hours = totalMinutes ~/ 60;
      int remainingMinutes = totalMinutes % 60;
      if (remainingMinutes == 0) {
        return result = '${"Booking"} $hours hour${hours == 1 ? '' : 's'}';
      } else {
        return result =
            '${"Booking"} $hours hour${hours == 1 ? '' : 's'} $remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}';
      }
    }
  }

  static String addDurationToTimestampString1(DateTime t, String d) {
    List<String> durationParts = d.split(':');
    if (durationParts.length != 3) {
      throw ArgumentError('Duration must be in the format hh:mm:ss');
    }
    int hours = int.parse(durationParts[0]);
    int minutes = int.parse(durationParts[1]);
    int seconds = int.parse(durationParts[2]);
    Duration duration = Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
    DateTime newTime = t.add(duration);
    String formattedTime =
        '${newTime.hour.toString().padLeft(2, '0')}:'
        '${newTime.minute.toString().padLeft(2, '0')}:'
        '${newTime.second.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  // static String addDurationToTimestampString(DateTime t, String d) {
  //   int minutesToAdd = int.parse(d);
  //   Duration duration = Duration(minutes: minutesToAdd);
  //   DateTime newTime = t.add(duration);

  //   String formattedTime = '${newTime.hour.toString().padLeft(2, '0')}:'
  //       '${newTime.minute.toString().padLeft(2, '0')}:'
  //       '${newTime.second.toString().padLeft(2, '0')}';

  //   return formattedTime;
  // }

  static String addDurationToTimestampString(DateTime t, String d) {
    // Validate the duration input
    if (d.isEmpty || !RegExp(r'^\d+$').hasMatch(d)) {
      throw ArgumentError('Duration must be a non-negative integer string.');
    }

    // Parse the duration string as minutes
    int minutesToAdd = int.parse(d);

    // Create a Duration object with the specified minutes
    Duration duration = Duration(minutes: minutesToAdd);

    // Add the duration to the timestamp
    DateTime newTime = t.add(duration);

    // Format the new time as a string in hh:mm:ss
    String formattedTime =
        '${newTime.hour.toString().padLeft(2, '0')}:'
        '${newTime.minute.toString().padLeft(2, '0')}:'
        '${newTime.second.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  static int getDaysInMonth(int month, int year) {
    int result = 31;
    if ((month == 2) && (year % 4 == 0)) {
      result = 29;
    } else if ((month == 2) && (year % 4 != 0)) {
      result = 28;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      result = 30;
    }
    return result;
  }

  static (int, int, int) calculateDifferenceBetweenDates(
    DateTime from,
    DateTime to,
  ) {
    if (to.isBefore(from)) {
      final temp = from;
      from = to;
      to = temp;
    }
    int diffInYears = to.year - from.year;
    int diffInMonths = to.month - from.month;
    int diffInDays = to.day - from.day;
    if (diffInDays < 0) {
      diffInMonths -= 1;
      final prevMonth = DateTime(to.year, to.month, 0);
      diffInDays += prevMonth.day;
    }

    if (diffInMonths < 0) {
      diffInYears -= 1;
      diffInMonths += 12;
    }
    return (diffInYears, diffInMonths, diffInDays);
  }

  static String formatDateKey(DateTime date, {bool includeDay = false}) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return includeDay ? '${date.year}$month$day' : '${date.year}$month';
  }

  static Future<String> checkDate(String endDate, String businessId) async {
    final closingBalanceRef = FirebaseFirestore.instance
        .collection('business_wallet')
        .doc(businessId)
        .collection('closingBalance');
    final endDateDoc = await closingBalanceRef.doc(endDate).get();
    String effectiveEndDate = endDate;
    if (!endDateDoc.exists) {
      final previousDoc = await closingBalanceRef
          .where(FieldPath.documentId, isLessThanOrEqualTo: endDate)
          .orderBy(FieldPath.documentId, descending: true)
          .get();
      if (previousDoc.docs.isNotEmpty) {
        effectiveEndDate = previousDoc.docs.first.id;
      } else {
        return effectiveEndDate;
      }
    }
    return effectiveEndDate;
  }

  static Future<String> getLastClosingBalanceDate(String businessId) async {
    try {
      final closingBalanceRef = FirebaseFirestore.instance
          .collection('business_wallet')
          .doc(businessId)
          .collection('closingBalance');

      // Query to get the most recent document by date (assuming document IDs are dates)
      final querySnapshot = await closingBalanceRef
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id; // Returns the most recent date
      }
      // Return empty string if no documents exist
      return '20240620';
    } catch (e) {
      debugPrint('Error getting last closing balance date: $e');
      return '';
    }
  }

  static DateTime parseDateKeyToDateTime(
    String dateKey, {
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) {
    try {
      final dateTime = dateKey.length == 6
          ? DateTime(
              int.parse(dateKey.substring(0, 4)), // year
              int.parse(dateKey.substring(4, 6)), // month
              1, // default day 1 for month-only
              hour,
              minute,
              second,
            )
          : DateTime(
              int.parse(dateKey.substring(0, 4)), // year
              int.parse(dateKey.substring(4, 6)), // month
              int.parse(dateKey.substring(6, 8)), // day
              hour,
              minute,
              second,
            );

      // Convert to UTC+4 (Gulf Standard Time)
      return dateTime.toUtc().add(const Duration(hours: 4));
    } catch (e) {
      throw FormatException('Failed to parse date key: $dateKey');
    }
  }

  /// Converts date strings (yyyyMMdd or yyyyMM) to DateTime at midnight (00:00:00)
  /// Example inputs: "20250330" → March 30, 2025 00:00:00
  ///                "202503" → March 1, 2025 00:00:00
  static DateTime parseDateKeyToMidnight(String dateKey) {
    try {
      // Remove any non-digit characters (optional safety check)
      final cleanKey = dateKey.replaceAll(RegExp(r'[^0-9]'), '');

      if (cleanKey.length == 6) {
        // yyyyMM format
        return DateTime(
          int.parse(cleanKey.substring(0, 4)), // year
          int.parse(cleanKey.substring(4, 6)), // month
          1, // day
        );
      } else if (cleanKey.length == 8) {
        // yyyyMMdd format
        return DateTime(
          int.parse(cleanKey.substring(0, 4)), // year
          int.parse(cleanKey.substring(4, 6)), // month
          int.parse(cleanKey.substring(6, 8)), // day
        );
      }
      throw FormatException(
        'Date key must be 6 (yyyyMM) or 8 (yyyyMMdd) digits',
      );
    } catch (e) {
      throw FormatException('Invalid date key "$dateKey": ${e.toString()}');
    }
  }

  // For Firestore Timestamp version:
  static Timestamp parseDateKeyToTimestamp(String dateKey) {
    return Timestamp.fromDate(parseDateKeyToDateTime(dateKey));
  }

  static Future<String> getCurrentLanguage(BuildContext context) async {
    Locale currentLocale = EasyLocalization.of(context)!.locale;
    return currentLocale.languageCode;
  }

  static String? formatDateWithMonth(DateTime? dateTime) {
    if (dateTime != null) {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      String day = dateTime.day.toString().padLeft(2, '0');
      String month = months[dateTime.month - 1]; // Convert month to string
      String year = dateTime.year.toString();
      return '$month $day, $year';
    } else {
      return null;
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.red;
      case 'active':
        return Colors.green;
      case 'completed':
        return AppTheme.primaryColor;
      case 'inactive':
        return const Color.fromARGB(255, 148, 136, 32);
      case 'in-progress':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'requestComplete':
        return Colors.green;
      case 'ended':
        return AppTheme.darkprimaryColor;
      default:
        return Colors.grey;
    }
  }

  static String getEquipmenTitle(String title) {
    if (title == 'oxYxJafDOmkkqa8IrdOz') {
      return "Fork Lift";
    } else if (title == 'v7EgLeGzaKmWuNsfi2wD') {
      return "Electric Tuk Tuk";
    } else if (title == "HBXp8Ene1Gv8RALxfMT7") {
      return "Ride On Forklift";
    } else if (title == "OlaUASyc3tojm6T57bz7") {
      return "Three Wheel Electrick Forklift";
    } else if (title == "mJ7Yp31PmQkbeoCKZmed") {
      return "Tractor";
    } else if (title == "ndkrFAe4IXfsch2i9kKp") {
      return "10-Ton Reefer Truck";
    } else if (title == "ndkrFAe4IXfsch2i9kKp") {
      return "10-Ton Reefer Truck";
    }
    return "Equipment";
  }

  static bool has72HoursPassed(DateTime timestamp) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(timestamp);
    return difference.inHours >= 72;
  }

  static bool isTimestampPassed(Timestamp timestamp) {
    final now = DateTime.now();
    final comparisonTime = timestamp.toDate();
    return now.isAfter(comparisonTime);
  }

  static Map<String, dynamic> calculateOverlapTime(DateTime pastTimestamp) {
    final currentTime = DateTime.now();
    final timeDifference = currentTime.difference(pastTimestamp);
    final totalHours = timeDifference.inHours;
    final totalDays = timeDifference.inDays;
    bool overlap = totalHours > 72;
    int hoursBeyond = overlap ? totalHours - 72 : 0;
    int daysBeyond = overlap ? (hoursBeyond / 24).floor() : 0;
    hoursBeyond = overlap ? hoursBeyond % 24 : 0;

    return {
      'overlap': overlap,
      'hours': hoursBeyond,
      'days': daysBeyond,
      'total_hours': totalHours,
      'total_days': totalDays,
    };
  }

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'active':
        return Icons.check_circle;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.info_outline;
    }
  }

  static Future<void> addActivityLog({
    required String userId,
    required String activityTitle,
    required String docId,
    // required dynamic oldValue,
    // required dynamic newValue
  }) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'addLog',
      );

      final results = await callable({
        'userId': userId,
        'activityTitle': activityTitle,
        'docId': docId,
      });
      debugPrint('Log added successfully: ${results.data}');
    } catch (e) {
      debugPrint('Error adding log: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  static String getEntryType(String entryType) {
    return entryType == "trailer/Offloading"
        ? "Ty/Trailer Offloading"
        : entryType == "truckLoading"
        ? "Truck Loading"
        : entryType == "truckOffloading"
        ? "Truck Offloading"
        : "No Entry Type";
  }

  static Future<String?> getGateEntryStatus(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('gateEntry')
          .doc(docId)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['status'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching gateEntry status: $e');
      return null;
    }
  }

  static Future<void> showInvoiceDialog(
    BuildContext context,
    String orderId,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Invoice Details",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   "MHS #${order.invoiceId}",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.grey[600],
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    Divider(height: 1, color: Colors.grey[200]),
                    const SizedBox(height: 16),
                    InvoiceListFutureBuilder(orderId: orderId),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // ignore: deprecated_member_use
                          backgroundColor: AppTheme.primaryColor.withOpacity(
                            0.1,
                          ),
                        ),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<List<EmployeeModel>> getLabourEmployees() async {
    List<EmployeeModel> list = [];
    list.clear();
    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .where('designation', isEqualTo: "Labour")
          .where('status', isEqualTo: "active")
          .orderBy('timestamp', descending: true)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              EmployeeModel? e = EmployeeModel.getBusinessList(doc);
              if (e != null) {
                list.add(e);
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  static Future<List<EmployeeModel>> getAllEmployees() async {
    List<EmployeeModel> list = [];
    list.clear();
    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .where('designation', isNotEqualTo: "Operation Supervisor")
          .where('status', isEqualTo: "active")
          .orderBy('timestamp', descending: true)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              EmployeeModel? e = EmployeeModel.getBusinessList(doc);
              if (e != null) {
                list.add(e);
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  static Future<bool> doesTemperatureLogExist(String gateEntryId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('temperatureLogs')
          .where('gateEntryId', isEqualTo: gateEntryId)
          .limit(1) // Only need to check if at least one exists
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking temperature log: $e');
      return false;
    }
  }

  static String getDropDownDisplayText({
    required bool isMultiSelect,
    List<String>? selectedValues,
    required Map<String, String> items,
    required String hintText,
    String? value,
  }) {
    switch (isMultiSelect) {
      case true:
        return ((selectedValues == null || selectedValues.isEmpty)
            ? hintText
            : selectedValues
                  .map((key) => items[key])
                  .whereType<String>()
                  .join(', '));
      case false:
        return (items[value] ?? hintText);
    }
  }

  // static String timestampToString(Timestamp dt) {
  //   DateTime t = dt.toDate();
  //   var formatter = intl.DateFormat('hh.mm a, dd MMM, yy');
  //   return formatter.format(t);
  // }

  // static void functionTemplate(bool loading, User? user) async {
  //   if (loading) {
  //     return;
  //   }
  //   user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     return;
  //   }
  // await FirebaseFirestore.collection('')
  // }
}
