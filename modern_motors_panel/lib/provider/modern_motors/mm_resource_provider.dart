import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/model/admin_model/unit_model.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/hr_models/allowance_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/hr_models/nationality_model.dart';
import 'package:modern_motors_panel/model/hr_models/role_model.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/model/product_models/category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/model/terms/terms_of_sale_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/model/vendor/vendors_model.dart';
import 'package:modern_motors_panel/model/vendor/ventor_logos_model.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';

class MmResourceProvider with ChangeNotifier {
  List<EmployeeModel> employees = [];
  List<PublicProfileModel> profiles = [];
  List<CustomerModel> customersList = [];
  List<VendorModel> vendorsList = [];
  List<BrandModel> brandsList = [];
  List<ServiceTypeModel> serviceList = [];
  List<CategoryModel> categoryList = [];
  List<ProductModel> productsList = [];
  List<ProductCategoryModel> productCategoryList = [];
  List<ProductSubCategoryModel> productSubCategoryList = [];
  List<RoleModel> designationsList = [];
  VendorLogosListModel? logosList;
  List<EstimationTemplatePreviewModel> estimationTemplatePreviewModel = [];
  List<MmtrucksModel> mmTrucksList = [];
  StreamSubscription<DocumentSnapshot>? employeeSubscription;
  EmployeeModel? employeeModel;
  List<BranchModel> branchesList = [];
  List<BranchModel> suppliersList = [];
  List<NationalityModel> nationalityList = [];
  List<CountryModel> countryList = [];
  List<UnitModel> unitList = [];
  TermsOfSalesModel? termsOfSalesModel;
  List<CurrencyModel> currencyList = [];
  // List<NewTruckModel> newTrucksList = [];
  // List<PackageModel> packageList = [];
  // List<OrderModel> completedOrders = [];
  // List<BusinessWalletModel> walletList = [];
  // List<AllowanceModel> allowancesModel = [];
  // bool walletLoading = false;
  // double walletBalance = 0;
  // double? labourOrderFilter;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> start() async {
    bool result = true;
    final branch = BranchIdSp.getBranchId();
    List<bool> futures = [];
    List<dynamic> futureValues = [];
    setLoading(true);
    resetData();
    futures = [
      false, //1
      false, //2
      false, //3
      false, //4
      false, //5
      false, //6
      false, //7
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];
    futureValues = await Future.wait([
      getEmployees(),
      getProfiles(),
      getCustomers(),
      getVendors(),
      getBrands(),
      getServiceTypes(),
      getCategories(),
      getProducts(),
      // getProducts(branchId: branch),
      getProductsCategory(),
      getProductsSubCategory(),
      getMMTrucks(),
      getBranches(),
      fetchEstimationData(),
      fetchVendorLogos(),
      getNationalities(),
      getDesignations(),
      getUnits(),
      getCurrencies(),
      getCountries(),
      //fetchTerms(),
    ]);
    for (int i = 0; i < futureValues.length; i++) {
      futures[i] = futureValues[i];
    }
    for (int i = 0; i < futures.length; i++) {
      if (!futures[i]) {
        result = false;
        break;
      }
    }
    // estimationTemplatePreviewModel =
    //     futureValues[12] as List<EstimationTemplatePreviewModel>;
    // logosList = futureValues[13] as VendorLogosListModel;
    //termsOfSalesModel = futureValues[14] as TermsOfSalesModel;
    debugPrint('estimation: ${estimationTemplatePreviewModel.length}');
    setLoading(false);

    return result;
  }

  Future<bool> getCountries() async {
    try {
      await FirebaseFirestore.instance.collection('country').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          CountryModel country = CountryModel.fromDoc(doc);
          if (country.id!.isNotEmpty) {
            countryList.add(country);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getCurrencies() async {
    try {
      await FirebaseFirestore.instance.collection('currency').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          CurrencyModel currency = CurrencyModel.fromDoc(doc);
          if (currency.id!.isNotEmpty) {
            currencyList.add(currency);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  CurrencyModel getCurrencyID(String id) {
    CurrencyModel currency;
    currency = currencyList.firstWhere(
      (element) => element.id == id,
      orElse: () => CurrencyModel(currency: ''),
    );
    return currency;
  }

  Future<bool> update() async {
    setLoading(true);
    // final branch = BranchIdSp.getBranchId();
    // allAssets.clear();
    productsList.clear();
    bool result = true;
    List<bool> futures = [];
    List<dynamic> futureValues = [];

    futures = [
      false, //1
      // false, //2
    ];
    futureValues = await Future.wait([
      getProducts(),
      // getAssets(branchId: branch),
    ]);
    for (int i = 0; i < futureValues.length - 3; i++) {
      futures[i] = futureValues[i];
    }
    for (int i = 0; i < futures.length - 3; i++) {
      if (!futures[i]) {
        result = false;
        break;
      }
    }

    setLoading(false);

    return result;
  }

  CountryModel getCountryID(String id) {
    CountryModel country;
    country = countryList.firstWhere((element) => element.id == id);
    return country;
  }

  // Future<bool> fetchTerms() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('termsAndConditionsOfSale')
  //         .limit(1)
  //         .get()
  //         .then((
  //       value,
  //     ) async {
  //       for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
  //         TermsOfSalesModel branch = TermsOfSalesModel.fromDoc(doc);
  //         if (branch.id!.isNotEmpty) {
  //           termsOfSalesModel = branch;
  //         }
  //       }
  //     });
  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  Future<bool> getUnits() async {
    try {
      await FirebaseFirestore.instance.collection('unit').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          UnitModel unit = UnitModel.fromDoc(doc);
          if (unit.id.isNotEmpty) {
            unitList.add(unit);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  UnitModel getUnitID(String id) {
    UnitModel unit;
    unit = unitList.firstWhere((element) => element.id == id);
    return unit;
  }

  Future<bool> getDesignations() async {
    try {
      await FirebaseFirestore.instance.collection('roles').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          RoleModel designation = RoleModel.fromDoc(doc);
          if (designation.id!.isNotEmpty) {
            designationsList.add(designation);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  RoleModel getDesignationById(String id) {
    RoleModel designation;
    designation = designationsList.firstWhere((element) => element.id == id);
    return designation;
  }

  void updateCategory({String? id, required ProductCategoryModel model}) {
    if (id == null) {
      productCategoryList.insert(0, model);
    } else {
      final index = productCategoryList.indexWhere((ven) => ven.id == id);
      if (index != -1) {
        final oldVendor = productCategoryList[index];
        model.timestamp = oldVendor.timestamp;
        model.id = oldVendor.id ?? 'NO ASSIGNED';
        productCategoryList[index] = model;
      }
    }
    notifyListeners();
  }

  Future<bool> getBranches() async {
    try {
      await FirebaseFirestore.instance.collection('branches').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          BranchModel branch = BranchModel.fromDoc(doc);
          if (branch.id!.isNotEmpty) {
            branchesList.add(branch);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  BranchModel getBranchByID(String id) {
    BranchModel branch;
    branch = branchesList.firstWhere(
      (element) => element.id == id,
      orElse: () => BranchModel(branchName: 'No'),
    );
    return branch;
  }

  Future<bool> fetchVendorLogos() async {
    try {
      await FirebaseFirestore.instance
          .collection('vendorLogos')
          .limit(1)
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              VendorLogosListModel branch = VendorLogosListModel.fromDoc(doc);
              if (branch.id!.isNotEmpty) {
                logosList = branch;
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getNationalities() async {
    try {
      await FirebaseFirestore.instance
          .collection('nationality')
          //.where('status', isEqualTo: "active")
          //.where('type', isEqualTo: "business")
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              NationalityModel nationality = NationalityModel.fromSnapshot(doc);
              if (nationality.id!.isNotEmpty) {
                nationalityList.add(nationality);
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  NationalityModel getNationalityByID(String id) {
    NationalityModel nationality;
    nationality = nationalityList.firstWhere((element) => element.id == id);
    return nationality;
  }

  Future<bool> fetchEstimationData() async {
    try {
      await FirebaseFirestore.instance
          .collection('mminvoiceTemplates')
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              EstimationTemplatePreviewModel branch =
                  EstimationTemplatePreviewModel.fromDoc(doc);
              if (branch.id!.isNotEmpty) {
                estimationTemplatePreviewModel.add(branch);
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<MmtrucksModel>> fetchTrucks() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('mmTrucks')
        .get();
    return querySnapshot.docs.map((doc) {
      return MmtrucksModel.fromDoc(doc);
    }).toList();
  }

  Future<bool> getMMTrucks() async {
    try {
      await FirebaseFirestore.instance.collection('mmTrucks').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          MmtrucksModel truck = MmtrucksModel.fromDoc(doc);
          if (truck.id!.isNotEmpty) {
            mmTrucksList.add(truck);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  MmtrucksModel getTruckByID(String id) {
    MmtrucksModel trucks;
    trucks = mmTrucksList.firstWhere((element) => element.id == id);
    return trucks;
  }

  Future<bool> getProductsCategory() async {
    try {
      await FirebaseFirestore.instance
          .collection('productsCategory')
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              ProductCategoryModel product = ProductCategoryModel.fromDoc(doc);
              if (product.id!.isNotEmpty) {
                productCategoryList.add(product);
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  ProductCategoryModel getProductCategoryByID(String id) {
    ProductCategoryModel productCategory;
    productCategory = productCategoryList.firstWhere(
      (element) => element.id == id,
    );
    return productCategory;
  }

  static Future<List<ProductSubCategoryModel>> fetchSubCategories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('subCategory')
        .get();
    return querySnapshot.docs.map((doc) {
      return ProductSubCategoryModel.fromDoc(doc);
    }).toList();
  }

  Future<bool> getProductsSubCategory() async {
    try {
      await FirebaseFirestore.instance.collection('subCategory').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          ProductSubCategoryModel subproduct = ProductSubCategoryModel.fromDoc(
            doc,
          );
          if (subproduct.id!.isNotEmpty) {
            productSubCategoryList.add(subproduct);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  ProductSubCategoryModel getProductSubCategoryByID(String id) {
    ProductSubCategoryModel productSubCategory;
    productSubCategory = productSubCategoryList.firstWhere(
      (element) => element.id == id,
    );
    return productSubCategory;
  }

  // Future<bool> getProducts({String? branchId}) async {
  //   try {
  //     Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
  //       'products',
  //     );
  //     if (branchId != null && branchId != Constants.mainBranchId) {
  //       query = query.where("branchId", isEqualTo: branchId);
  //     }

  //     final snapshot = await query.get();
  //     for (var doc in snapshot.docs) {
  //       ProductModel product = ProductModel.fromMap(doc);
  //       if (product.id!.isNotEmpty) {
  //         productsList.add(product);
  //       }
  //     }
  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  Future<bool> getProducts() async {
    try {
      await FirebaseFirestore.instance.collection('products').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          ProductModel product = ProductModel.fromMap(doc);
          if (product.id!.isNotEmpty) {
            productsList.add(product);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  ProductModel getProductByID(String id) {
    ProductModel product;
    product = productsList.firstWhere((element) => element.id == id);
    return product;
  }

  Future<bool> getEmployees() async {
    try {
      await FirebaseFirestore.instance.collection('mmEmployees').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          EmployeeModel employee = EmployeeModel.fromMap(doc);
          if (employee.id.isNotEmpty) {
            employees.add(employee);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  EmployeeModel getEmployeeByID(String id) {
    EmployeeModel employee;
    employee = employees.firstWhere(
      (element) => element.userId == id,
      orElse: EmployeeModel.getEmptyEmployee,
    );
    return employee;
  }

  Future<bool> getVendors() async {
    try {
      await FirebaseFirestore.instance.collection('vendors').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          VendorModel vendor = VendorModel.fromDoc((doc));
          if (vendor.id!.isNotEmpty) {
            vendorsList.add(vendor);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  VendorModel getVendorByID(String id) {
    VendorModel vendor;
    vendor = vendorsList.firstWhere((element) => element.id == id);
    return vendor;
  }

  Future<bool> getBrands() async {
    try {
      await FirebaseFirestore.instance.collection('brand').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          BrandModel brand = BrandModel.fromDoc(doc);
          if (brand.id!.isNotEmpty) {
            brandsList.add(brand);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getServiceTypes() async {
    try {
      await FirebaseFirestore.instance.collection('serviceTypes').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          ServiceTypeModel serviceType = ServiceTypeModel.fromDoc(doc);
          if (serviceType.id!.isNotEmpty) {
            serviceList.add(serviceType);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  ServiceTypeModel getServiceById(String id) {
    ServiceTypeModel service;
    service = serviceList.firstWhere((element) => element.id == id);
    return service;
  }

  Future<bool> getCategories() async {
    try {
      await FirebaseFirestore.instance.collection('category').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          CategoryModel category = CategoryModel.fromDoc(doc);
          if (category.id!.isNotEmpty) {
            categoryList.add(category);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  CategoryModel getCategoryById(String id) {
    CategoryModel category;
    category = categoryList.firstWhere((element) => element.id == id);
    return category;
  }

  Future<bool> getProfiles() async {
    try {
      await FirebaseFirestore.instance.collection('mmProfile').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          PublicProfileModel profile = PublicProfileModel.fromFirestore(doc);
          profiles.add(profile);
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  PublicProfileModel getProfileByID(String id) {
    PublicProfileModel profile;
    profile = profiles.firstWhere(
      (element) => element.id == id,
      orElse: PublicProfileModel.getEmptyProfile,
    );
    return profile;
  }

  void addProfile(PublicProfileModel profile) {
    profiles.add(profile);
  }

  Future<bool> getCustomers() async {
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          //.where('status', isEqualTo: "active")
          //.where('type', isEqualTo: "business")
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              CustomerModel customer = CustomerModel.fromDoc(doc);
              if (customer.id!.isNotEmpty) {
                customersList.add(customer);
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  CustomerModel getCustomerByID(String id) {
    CustomerModel customer;
    customer = customersList.firstWhere((element) => element.id == id);
    return customer;
  }

  Future<AllowanceModel?> fetchAllowanceById(String docId) async {
    final firestore = FirebaseFirestore.instance;
    try {
      final docSnapshot = await firestore
          .collection('allowance')
          .doc(docId)
          .get();
      if (docSnapshot.exists) {
        return AllowanceModel.fromSnapshot(docSnapshot);
      } else {
        debugPrint('Document not found for ID: $docId');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching allowance document: $e');
      return null;
    }
  }

  void listenToEmployee(String userId) {
    employeeSubscription?.cancel();
    employeeSubscription = FirebaseFirestore.instance
        .collection('mmEmployees')
        .doc(userId)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            employeeModel = EmployeeModel.fromMap(doc);
            notifyListeners();
          }
        });
  }

  void resetData() {
    employees.clear();
    profiles.clear();
    customersList.clear();
    nationalityList.clear();
    vendorsList.clear();
    unitList.clear();
    designationsList.clear();
    brandsList.clear();
    countryList.clear();
    branchesList.clear();
    serviceList.clear();
    categoryList.clear();
    productsList.clear();
    // assetsCategoryList.clear();
    // parentCategories.clear();
    // allAssets.clear();
    estimationTemplatePreviewModel.clear();
    productCategoryList.clear();
    productSubCategoryList.clear();
    mmTrucksList.clear();

    logosList = null;
    termsOfSalesModel = null;
    employeeModel = null;

    // Agar koi subscription chal rahi hai to cancel karna zaroori hai
    employeeSubscription?.cancel();
    employeeSubscription = null;

    notifyListeners(); // 🔥 UI ko refresh karega
  }
}
