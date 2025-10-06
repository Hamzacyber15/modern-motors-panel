import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/model/admin_model/expenses_model.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/assets_model/assets_category_model.dart';
import 'package:modern_motors_panel/model/assets_model/assets_model.dart';
import 'package:modern_motors_panel/model/assets_model/assets_parent_category_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/default_address_preview.dart';
import 'package:modern_motors_panel/model/depriciation/depriciation_methods_model.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/estimates_models/estimates_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/nationality_model.dart';
import 'package:modern_motors_panel/model/hr_models/role_model.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/inventory_models/modern_motors.dart/mminventory_batches_model.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/maintenance_booking_models/maintenance_booking_model.dart';
import 'package:modern_motors_panel/model/product_models/category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/purchase_models/grn/grn_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_order_model.dart';
import 'package:modern_motors_panel/model/purchase_models/purchase_requisition_model.dart';
import 'package:modern_motors_panel/model/purchase_models/quotation_procurement_model.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/model/terms/terms_of_sale_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/model/vendor/ventor_logos_model.dart';

class DataFetchService {
  static Future<List<ProductCategoryModel>> fetchProduct() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productsCategory')
        .get();
    return querySnapshot.docs.map((doc) {
      return ProductCategoryModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<NationalityModel>> fetchNationalities() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('nationality')
        .get();
    return querySnapshot.docs.map((doc) {
      return NationalityModel.fromSnapshot(doc);
    }).toList();
  }

  static Future<List<EstimationTemplatePreviewModel>>
  fetchPreviewTemplated() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('mminvoiceTemplates')
        .get();
    return querySnapshot.docs.map((doc) {
      return EstimationTemplatePreviewModel.fromDoc((doc));
    }).toList();
  }

  static Future<VendorLogosListModel> fetchVendorLogos() async {
    final doc = await FirebaseFirestore.instance
        .collection('vendorLogos')
        .limit(1)
        .get();

    if (doc.docs.isEmpty) return VendorLogosListModel(logos: []);

    final map = doc.docs.first.data();
    // final termsList =
    //     (map['terms'] as List<dynamic>? ?? [])
    //         .map((item) => TermsAndConditionsOfSalesModel.fromMap(item))
    //         .toList();
    // return termsList;
    return VendorLogosListModel.fromDoc(doc.docs.first);
  }

  static Future<List<SaleModel>> fetchSales() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('sales')
          .where('status', whereNotIn: ["estimate", "estimateDraft"])
          .orderBy("createdAt", descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return SaleModel.fromFirestore(doc);
      }).toList();
    } catch (e, stackTrace) {
      debugPrint("${"Error"} :${e.toString()}");
      return []; // return empty list on error
    }
  }

  static Future<List<SaleModel>> fetchEstimates() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('sales')
          .where('status', isEqualTo: "estimate")
          .orderBy("createdAt", descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return SaleModel.fromFirestore(doc);
      }).toList();
    } catch (e, stackTrace) {
      debugPrint("${"Error"} :${e.toString()}");
      return []; // return empty list on error
    }
  }

  static Future<EstimationTemplatePreviewModel?> fetchEstimationTemplateData(
    String type,
  ) async {
    final q = await FirebaseFirestore.instance
        .collection('mminvoiceTemplates')
        .where('type', isEqualTo: type)
        .limit(1)
        .get();
    if (q.docs.isEmpty) {
      return EstimationTemplatePreviewModel(
        companyDetails: CompanyDetails(),
        bank1Details: BankDetails(),
        bank2Details: BankDetails(),
      );
    }
    return EstimationTemplatePreviewModel.fromDoc(q.docs.first);
  }

  static Future<DefaultAddressModel?> fetchDefaultAddress() async {
    final snap = await FirebaseFirestore.instance
        .collection("defaultAddresses")
        .where("status", isEqualTo: "default")
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      return DefaultAddressModel.fromDoc(snap.docs.first);
    }
    return null;
  }

  static Future<BankDetails?> fetchDefaultBank() async {
    final snap = await FirebaseFirestore.instance
        .collection("defaultBankDetails")
        .where("status", isEqualTo: "default")
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      return BankDetails.fromDoc(snap.docs.first);
    }
    return null;
  }

  static Future<List<ProductModel>> fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();
    return querySnapshot.docs.map((doc) {
      return ProductModel.fromMap((doc));
    }).toList();
  }

  static Future<List<AssetsParentCategoryModel>>
  fetchAssetParentCategories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('assetsParentCategories')
        .where('status', isEqualTo: 'active')
        .get();
    return querySnapshot.docs.map((doc) {
      return AssetsParentCategoryModel.fromMap(doc);
    }).toList();
  }

  // Add to your DataFetchService class
  static Future<List<MmInventoryBatchesModel>> fetchAvailableBatchesForProduct(
    String productId,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mmInventoryBatches')
          .where('productId', isEqualTo: productId)
          .where('quantityRemaining', isGreaterThan: 0)
          .where('isActive', isEqualTo: true)
          .orderBy('receivedDate', descending: false) // FIFO - oldest first
          .get();

      return snapshot.docs
          .map((doc) => MmInventoryBatchesModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching available batches: $e');
      rethrow;
    }
  }

  static Future<TermsOfSalesModel> fetchTerms() async {
    final doc = await FirebaseFirestore.instance
        .collection('termsAndConditionsOfSale')
        .limit(1)
        .get();

    if (doc.docs.isEmpty) return TermsOfSalesModel(terms: []);

    final map = doc.docs.first.data();
    return TermsOfSalesModel.fromDoc(doc.docs.first);
  }

  static Future<List<CategoryModel>> fetchCategories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('category')
        .get();
    return querySnapshot.docs.map((doc) {
      return CategoryModel.fromDoc(doc);
    }).toList();
  }

  // Allowances

  // static Future<List<AllowancesCategoryModel>> fetchAllowenceCategory() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('allowanceCategory').get();
  //   return querySnapshot.docs.map((doc) {
  //     return AllowancesCategoryModel.fromDoc(doc);
  //   }).toList();
  // }

  // static Future<List<AllowanceModel>> fetchAllowences() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('allowance').get();
  //   return querySnapshot.docs.map((doc) {
  //     return AllowanceModel.fromDoc(doc);
  //   }).toList();
  // }

  // // Deduction
  // static Future<List<DeductionCategoryModel>> fetchDeductionCategory() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('deductionCategory').get();
  //   return querySnapshot.docs.map((doc) {
  //     return DeductionCategoryModel.fromDoc(doc);
  //   }).toList();
  // }

  // // Leave
  // static Future<List<LeavesTypeModel>> fetchLeaveType() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('leaveType').get();
  //   return querySnapshot.docs.map((doc) {
  //     return LeavesTypeModel.fromDoc(doc);
  //   }).toList();
  // }

  // static Future<List<LeaveModel>> fetchAllLeaves() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('leave').get();
  //   return querySnapshot.docs.map((doc) {
  //     return LeaveModel.fromDoc(doc);
  //   }).toList();
  // }

  // static Future<List<DeductionModel>> fetchDeduction() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('deduction').get();
  //   return querySnapshot.docs.map((doc) {
  //     return DeductionModel.fromDoc(doc);
  //   }).toList();
  // }

  static Future<List<ProductSubCatorymodel>> fetchSubCategories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('subCategory')
        .get();
    return querySnapshot.docs.map((doc) {
      return ProductSubCatorymodel.fromDoc(doc);
    }).toList();
  }

  static Future<MmtrucksModel> fetchSingleTruck(String id) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('mmTrucks')
        .doc(id)
        .get();
    return MmtrucksModel.fromDoc(querySnapshot);
    // return querySnapshot.map((doc) {
    //   return TruckModel.fromDoc(doc);
    // }).toList();
  }

  static Future<List<CurrencyModel>> fetchCurrencies() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('currency')
        .get();
    return querySnapshot.docs.map((doc) {
      return CurrencyModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<DepreciationMethodsModel>>
  fetchDepreciationMethods() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('depreciationMethods')
        .get();
    return querySnapshot.docs.map((doc) {
      return DepreciationMethodsModel.fromMap(doc);
    }).toList();
  }

  static Future<List<AssetsParentCategoryModel>>
  fetchAssetsParentCategories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('assetsParentCategories')
        .get();
    return querySnapshot.docs.map((doc) {
      return AssetsParentCategoryModel.fromMap(doc);
    }).toList();
  }

  static Future<List<CountryModel>> fetchCountries() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('country')
        .get();
    return querySnapshot.docs.map((doc) {
      return CountryModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<ExpensesModel>> fetchTripExpanses() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('tripExpanses')
        .get();
    return querySnapshot.docs.map((doc) {
      return ExpensesModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<ServiceTypeModel>> fetchServiceTypes() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('serviceTypes')
        .get();
    return querySnapshot.docs.map((doc) {
      return ServiceTypeModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<MaintenanceBookingModel>> fetchMaintenanceBooking() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('maintenanceMMBookings')
        .get();
    return querySnapshot.docs.map((doc) {
      return MaintenanceBookingModel.from(doc);
    }).toList();
  }

  static Future<List<BrandModel>> fetchBrands() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('brand')
        .get();
    return querySnapshot.docs.map((doc) {
      return BrandModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<UnitModel>> fetchUnits() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('unit')
        .get();
    return querySnapshot.docs.map((doc) {
      return UnitModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<MmtrucksModel>> fetchTrucks() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('mmTrucks')
        .get();
    return querySnapshot.docs.map((doc) {
      return MmtrucksModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<EstimationModel>> fetchEstimation() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('estimations')
        .get();
    return querySnapshot.docs.map((doc) {
      return EstimationModel.from(doc);
    }).toList();
  }

  //Designation
  // static Future<List<DesignationModel>> fetchDesignation() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('designation').get();
  //   return querySnapshot.docs.map((doc) {
  //     return DesignationModel.fromDoc(doc);
  //   }).toList();
  // }

  static Future<List<InventoryModel>> fetchInventory() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('inventory')
        .get();
    return querySnapshot.docs.map((doc) {
      return InventoryModel.fromMap((doc));
    }).toList();
  }

  // static Future<List<OrdersBookingModel>> fetchOrderBookings() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance
  //           .collection('orderBookings')
  //           .orderBy('createdAt', descending: true)
  //           .get();
  //   return querySnapshot.docs.map((doc) {
  //     return OrdersBookingModel.fromMap((doc));
  //   }).toList();
  // }

  // static Future<BookingCustomerModel?> getCustomerById(
  //   String customerId,
  // ) async {
  //   final doc =
  //       await FirebaseFirestore.instance
  //           .collection('bookingCustomer')
  //           .doc(customerId)
  //           .get();
  //   if (doc.exists) {
  //     return BookingCustomerModel.fromDoc(doc);
  //   }
  //   return null;
  // }

  // static Future<ProfileModel?> getDriverData() async {
  //   final doc =
  //       await FirebaseFirestore.instance
  //           .collection('profile')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .get();
  //   if (doc.exists) {
  //     return ProfileModel.fromFirestore(doc);
  //   }
  //   return null;
  // }

  // static Future<List<OrdersBookingModel>> loadUpcomingOrders() async {
  //   try {
  //     final now = DateTime.now().toUtc();
  //     final endOfToday = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       23,
  //       59,
  //       59,
  //       999,
  //     );
  //     final query =
  //         await FirebaseFirestore.instance
  //             .collection('orderBookings')
  //             .where(
  //               'preferredDateAndTime',
  //               isGreaterThan: Timestamp.fromDate(endOfToday),
  //             )
  //             .where(
  //               'driverId',
  //               isEqualTo: FirebaseAuth.instance.currentUser!.uid,
  //             )
  //             .orderBy('preferredDateAndTime')
  //             .get();

  //     return query.docs.map((doc) => OrdersBookingModel.fromMap(doc)).toList();
  //   } catch (e) {
  //     debugPrint('Error in loadUpcomingOrders: $e');
  //     return [];
  //   }
  // }

  // static Future<List<OrdersBookingModel>> getAllTrips() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   final query =
  //       await FirebaseFirestore.instance
  //           .collection('orderBookings')
  //           .where('driverId', isEqualTo: userId)
  //           .where('status', whereIn: ['completed', 'hold'])
  //           .orderBy('preferredDateAndTime', descending: true)
  //           .get();
  //   return query.docs.map((doc) => OrdersBookingModel.fromMap(doc)).toList();
  // }

  // static Future<List<OrdersBookingModel>> getCompletedTrips() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   final query =
  //       await FirebaseFirestore.instance
  //           .collection('orderBookings')
  //           .where('driverId', isEqualTo: userId)
  //           .where('status', isEqualTo: 'completed')
  //           .orderBy('preferredDateAndTime', descending: true)
  //           .get();
  //   return query.docs.map((doc) => OrdersBookingModel.fromMap(doc)).toList();
  // }

  // static Future<List<OrdersBookingModel>> getHoldTrips() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   final query =
  //       await FirebaseFirestore.instance
  //           .collection('orderBookings')
  //           .where('driverId', isEqualTo: userId)
  //           .where('status', isEqualTo: 'hold')
  //           .orderBy('preferredDateAndTime', descending: true)
  //           .get();
  //   return query.docs.map((doc) => OrdersBookingModel.fromMap(doc)).toList();
  // }

  // static Future<TruckModel?> getTruckData(String truckId) async {
  //   final doc =
  //       await FirebaseFirestore.instance
  //           .collection('trucks')
  //           .doc(truckId)
  //           .get();
  //   if (doc.exists) {
  //     return TruckModel.fromDoc(doc);
  //   }
  //   return null;
  // }

  static Stream<QuerySnapshot> getTodayOrdersStream() {
    final now = DateTime.now().toUtc();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    return FirebaseFirestore.instance
        .collection('orderBookings')
        // .where(
        //   'preferredDateAndTime',
        //   isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        // )
        // .where(
        //   'preferredDateAndTime',
        //   isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
        // )
        .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static Future<List<DiscountModel>> fetchDiscount() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('discounts')
        .get();
    return querySnapshot.docs.map((doc) {
      return DiscountModel.fromMap((doc));
    }).toList();
  }

  static Future<List<AssetsCategoryModel>> fetchAssetsCategories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('assetsCategory')
        .get();
    return querySnapshot.docs.map((doc) {
      return AssetsCategoryModel.fromDoc((doc));
    }).toList();
  }

  static Future<List<AssetsModel>> fetchAssets() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('assets')
        .get();
    return querySnapshot.docs.map((doc) {
      return AssetsModel.fromDoc((doc));
    }).toList();
  }

  static Future<List<VendorModel>> fetchVendor() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .get();
    return querySnapshot.docs.map((doc) {
      return VendorModel.fromDoc((doc));
    }).toList();
  }

  // static Future<List<BookingCustomerModel>> fetchBookingCustomer() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('bookingCustomer').get();
  //   return querySnapshot.docs.map((doc) {
  //     return BookingCustomerModel.fromDoc((doc));
  //   }).toList();
  // }

  static Future<List<CustomerModel>> fetchCustomers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .get();
    return querySnapshot.docs.map((doc) {
      return CustomerModel.fromDoc((doc));
    }).toList();
  }

  // static Future<List<EmployeeModel>> fetchEmployees() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('mmEmployees').get();
  //   return querySnapshot.docs.map((doc) {
  //     return EmployeeModel.fromMap((doc));
  //   }).toList();
  // }

  static Future<List<EmployeeModel>> fetchEmployees() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('mmEmployees')
          .get();

      return querySnapshot.docs.map((doc) {
        return EmployeeModel.fromMap(doc);
      }).toList();
    } catch (e, stackTrace) {
      debugPrint('Error fetching employees: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to fetch employees: ${e.toString()}');
    }
  }

  // static Future<List<EmployeeModel>> fetchDrivers(String driverId) async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance
  //           .collection('employees')
  //           .where('roleId', isEqualTo: driverId)
  //           .get();
  //   return querySnapshot.docs.map((doc) {
  //     return EmployeeModel.fromDoc((doc));
  //   }).toList();
  // }

  static Future<List<QuotationProcurementModel>> fetchQuotation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collectionGroup('quotations') // search in all subcollections
        // .where('userId', isEqualTo: user.uid)
        .get();
    return querySnapshot.docs
        .map((doc) => QuotationProcurementModel.fromDoc(doc))
        .toList();
  }

  static Future<List<BranchModel>> fetchBranches() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('branches')
        .get();
    return querySnapshot.docs.map((doc) {
      return BranchModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<RoleModel>> fetchRoles() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('roles')
        .get();
    return querySnapshot.docs.map((doc) {
      return RoleModel.fromDoc(doc);
    }).toList();
  }

  static Future<List<PurchaseModel>> fetchPurchaseOrders() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('purchaseOrder')
        .get();
    return querySnapshot.docs.map((doc) {
      return PurchaseModel.fromMap((doc));
    }).toList();
  }

  static Future<List<InvoiceMmModel>> fetchInvoices() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('mmInvoices')
        .get();
    return querySnapshot.docs.map((doc) {
      return InvoiceMmModel.from((doc));
    }).toList();
  }

  // static Future<List<SellOrderModel>> fetchSellOrder() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('sellOrders').get();
  //   return querySnapshot.docs.map((doc) {
  //     return SellOrderModel.from((doc));
  //   }).toList();
  // }

  // // Fetch Current  User Profile

  // static Future<ProfileModel?> fetchCurrentUserProfile() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return null;

  //   final query =
  //       await FirebaseFirestore.instance
  //           .collection('profile')
  //           .where('userId', isEqualTo: uid)
  //           .limit(1)
  //           .get();

  //   if (query.docs.isNotEmpty) {
  //     return ProfileModel.fromSnapshot(query.docs.first);
  //   } else {
  //     return null;
  //   }
  // }

  // Fetch Purchase Requesition

  static Future<List<PurchaseRequisitionModel>>
  fetchPurchaseRequesition() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collectionGroup(
          'purchaseRequisitions',
        ) // ✅ this looks inside *all* subcollections
        //.where('createdBy', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs
        .map((doc) => PurchaseRequisitionModel.fromDoc(doc))
        .toList();
  }

  static Future<List<PurchaseRequisitionModel>>
  fetchPurchseRequistionOnApproval() async {
    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('purchaseRequisitions')
        .where('status', isEqualTo: 'Accepted')
        .get();

    return snapshot.docs
        .map((doc) => PurchaseRequisitionModel.fromDoc(doc))
        .toList();
  }

  // static Future<List<VendorModel>> fetchVendorsFromAllQuotations() async {
  //   final List<VendorModel> vendorList = [];
  //   final Set<String> seenVendorIds = {};

  //   final snapshot =
  //       await FirebaseFirestore.instance
  //           .collectionGroup('quotations') // collection group query
  //           .get();

  //   for (final doc in snapshot.docs) {
  //     final data = doc.data();
  //     final quotationList = data['quotationList'] as List<dynamic>?;

  //     if (quotationList != null) {
  //       for (final item in quotationList) {
  //         final vendorId = item['vendorId'];
  //         final vendorName = item['vendorName'];
  //         final imageURL = item['imageURL'];

  //         if (vendorId != null && !seenVendorIds.contains(vendorId)) {
  //           seenVendorIds.add(vendorId);
  //           vendorList.add(
  //             VendorModel(
  //               id: vendorId,
  //               vendorName: vendorName ?? '',
  //               imageUrl: imageURL ?? '',
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   }

  //   return vendorList;
  // }

  static Future<List<PurchaseOrderModel>> fetchPurchaseOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collectionGroup(
          'purchaseOrder',
        ) // ✅ this looks inside *all* subcollections
        .get();

    return querySnapshot.docs
        .map((doc) => PurchaseOrderModel.fromDoc(doc))
        .toList();
  }

  static Future<List<GrnModel>> fetchGrns() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('grns') // ✅ this looks inside *all* subcollections
        .get();

    return querySnapshot.docs.map((doc) => GrnModel.fromDoc(doc)).toList();
  }
}
