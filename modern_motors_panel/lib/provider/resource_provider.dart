import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/business_models/business_profile_model.dart';
import 'package:modern_motors_panel/model/business_models/business_wallet_model.dart';
import 'package:modern_motors_panel/model/business_models/shops_model.dart';
import 'package:modern_motors_panel/model/discount_models/discount_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/equipment_models/equipment_model.dart';
import 'package:modern_motors_panel/model/handling_orders/order_model.dart';
import 'package:modern_motors_panel/model/hr_models/allowance_model.dart';
import 'package:modern_motors_panel/model/package_models/package_model.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/model/trucks/new_trucks_model.dart';
import 'package:modern_motors_panel/model/trucks/truck_model.dart';

class ResourceProvider with ChangeNotifier {
  List<EmployeeModel> employees = [];
  List<PublicProfileModel> profiles = [];
  List<BusinessProfileModel> businesses = [];
  List<EquipmentModel> equipmentList = [];
  List<ShopsModel> shopsList = [];
  List<DiscountModel> discountsList = [];
  List<DiscountModel> discountsListAdmin = [];
  List<DiscountModel> timeDiscounts = [];
  List<DiscountModel> leaseDiscounts = [];
  List<TruckModel> trucksList = [];
  List<NewTruckModel> newTrucksList = [];
  List<PackageModel> packageList = [];
  List<OrderModel> completedOrders = [];
  List<BusinessWalletModel> walletList = [];
  List<AllowanceModel> allowancesModel = [];
  bool walletLoading = false;
  double walletBalance = 0;
  double? labourOrderFilter;

  void updateFilter(double i) {
    labourOrderFilter = i;
    notifyListeners();
  }

  void walletStatus(bool status) {
    walletLoading = status;
    notifyListeners();
  }

  Future<bool> start(String type) async {
    bool result = true;
    List<bool> futures = [];
    List<dynamic> futureValues = [];
    if (type == "business") {
      futures = [false, false, false, false, false];
      futureValues = await Future.wait([
        getEquipments(),
        getShops(),
        //getPackages(),
        getProfiles(),
        getDiscounts(),
        getTruckList(),
      ]);
    } else if (type == "admin" || type == "Operation Supervisor") {
      futures = [
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
        getBusinesses(),
        getEquipments(),
        getShops(),
        getDiscounts(),
        getTruckList(),
        getOrders(),
        getPackages(),
        getNewTruckList(),
      ]);
    } else if (type == "Driver") {
      futures = [
        true,
        // false,
        //false,
        // false,
        // false,
        // false,
      ];
      futureValues = await Future.wait([
        //getProfiles(),
        //getBusinesses(),
        // getEquipments(),
        getShops(),
        // getOrders(),
      ]);
    }
    for (int i = 0; i < futureValues.length; i++) {
      futures[i] = futureValues[i];
    }
    for (int i = 0; i < futures.length; i++) {
      if (!futures[i]) {
        result = false;
        break;
      }
    }
    return result;
  }

  Future<bool> getPackages() async {
    try {
      await FirebaseFirestore.instance
          .collection('packages')
          .where('status', isEqualTo: "active")
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              PackageModel package = PackageModel.fromMap(doc);
              if (package.id.isNotEmpty) {
                if (package.type != "other") {
                  packageList.add(package);
                }
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getOrders() async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      await FirebaseFirestore.instance
          .collection('orders')
          .where('serviceType', isNotEqualTo: "package")
          .where('status', isEqualTo: "ended")
          .where('timestamp', isGreaterThanOrEqualTo: today)
          .orderBy('timestamp', descending: true)
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              OrderModel order = OrderModel.fromMap(doc);
              if (order.id.isNotEmpty) {
                completedOrders.add(order);
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getTruckList() async {
    try {
      await FirebaseFirestore.instance.collection('trucks').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          TruckModel truck = TruckModel.fromMap(doc);
          if (truck.id.isNotEmpty) {
            trucksList.add(truck);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getNewTruckList() async {
    newTrucksList.clear();
    try {
      await FirebaseFirestore.instance.collection('newTrucks').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          NewTruckModel truck = NewTruckModel.fromMap(doc);
          if (truck.id.isNotEmpty) {
            if (truck.status != "inactive") {
              newTrucksList.add(truck);
            }
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getDiscounts() async {
    discountsList.clear();
    discountsListAdmin.clear();
    timeDiscounts.clear();
    leaseDiscounts.clear();
    try {
      await FirebaseFirestore.instance
          .collection('discounts')
          .where('status', isEqualTo: "active")
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              DiscountModel discount = DiscountModel.fromMap(doc);
              if (discount.id.isNotEmpty) {
                if (discount.discountType == "Regular") {
                  discountsList.add(discount);
                } else if (discount.discountType == "Admin") {
                  discountsListAdmin.add(discount);
                } else if (discount.discountType == "Timely") {
                  timeDiscounts.add(discount);
                } else if (discount.discountType == "Lease") {
                  leaseDiscounts.add(discount);
                }
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getEmployees() async {
    try {
      await FirebaseFirestore.instance.collection('employees').get().then((
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

  Future<bool> getEquipments() async {
    try {
      await FirebaseFirestore.instance.collection('equipmentType').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          EquipmentModel equipment = EquipmentModel.fromMap(doc);
          if (equipment.id.isNotEmpty) {
            equipmentList.add(equipment);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getShops() async {
    try {
      await FirebaseFirestore.instance.collection('shops').get().then((
        value,
      ) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          ShopsModel shop = ShopsModel.fromMap(doc);
          if (shop.id.isNotEmpty) {
            shopsList.add(shop);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<PackageModel> getPackageByID(String id) async {
    PackageModel package;
    package = packageList.firstWhere(
      (element) => element.id == id,
      orElse: PackageModel.getEmptyPackage,
    );
    if (package.id.isEmpty) {
      await FirebaseFirestore.instance
          .collection('packages')
          .doc(id)
          .get()
          .then((doc) {
            if (doc.exists) {
              package = PackageModel.fromMap(doc);
              if (package.id.isNotEmpty) {
                packageList.add(package);
              }
            }
          });
    }
    return package;
  }

  NewTruckModel getNewTruckByID(String id) {
    NewTruckModel truck;
    truck = newTrucksList.firstWhere(
      (element) => element.id == id,
      orElse: NewTruckModel.getEmptyTruck,
    );
    return truck;
  }

  TruckModel getTruckByID(String id) {
    TruckModel truck;
    truck = trucksList.firstWhere(
      (element) => element.id == id,
      orElse: TruckModel.getEmptyTruck,
    );
    return truck;
  }

  OrderModel getOrderById(String id) {
    OrderModel order;
    order = completedOrders.firstWhere(
      (element) => element.id == id,
      orElse: OrderModel.getEmptyOrder,
    );
    return order;
  }

  ShopsModel getShopsByID(String id) {
    ShopsModel shop;
    shop = shopsList.firstWhere(
      (element) => element.id == id,
      orElse: ShopsModel.getEmptyShops,
    );
    return shop;
  }

  DiscountModel getDiscountById(String id) {
    DiscountModel discount;
    discount = discountsList.firstWhere(
      (element) => element.id == id,
      orElse: DiscountModel.getDiscount,
    );
    return discount;
  }

  DiscountModel getLeaseDiscountById(String id) {
    DiscountModel discount;
    discount = leaseDiscounts.firstWhere(
      (element) => element.id == id,
      orElse: DiscountModel.getDiscount,
    );
    return discount;
  }

  EmployeeModel getEmployeeByID(String id) {
    EmployeeModel employee;
    employee = employees.firstWhere(
      (element) => element.userId == id,
      orElse: EmployeeModel.getEmptyEmployee,
    );
    return employee;
  }

  String getEmployeeName(String id) {
    EmployeeModel? employee;
    employee = getEmployeeByID(id);
    return "${employee.name}\n${"Id"} # ${employee.employeeId}";
  }

  String getEmployeeNameByProfile(String id) {
    PublicProfileModel? employee;
    employee = getProfileByID(id);
    return employee.userName;
  }

  EquipmentModel getEquipmentByID(String id) {
    EquipmentModel e;
    e = equipmentList.firstWhere(
      (element) => element.id == id,
      orElse: EquipmentModel.getEmptyModel,
    );
    return e;
  }

  void addEmployee(EmployeeModel employee) {
    employees.add(employee);
  }

  void addEquipment(EquipmentModel equipment) {
    equipmentList.add(equipment);
  }

  List<EmployeeModel> getEmployeesByName(String name) {
    List<EmployeeModel> list = [];
    list = employees
        .where(
          (element) =>
              element.name.toLowerCase().startsWith(name.toLowerCase()) ||
              element.employeeCode!.toLowerCase().startsWith(
                name.toLowerCase(),
              ),
        )
        .toList();
    return list;
  }

  List<BusinessProfileModel> getBusinessByName(String name) {
    List<BusinessProfileModel> list = [];
    list = businesses
        .where(
          (element) =>
              element.nameEnglish.toLowerCase().startsWith(
                name.toLowerCase(),
              ) ||
              element.registrationNum.toLowerCase().startsWith(
                name.toLowerCase(),
              ),
        )
        .toList();
    return list;
  }

  Future<bool> getProfiles() async {
    try {
      await FirebaseFirestore.instance.collection('profile').get().then((
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

  Future<bool> getBusinesses() async {
    try {
      await FirebaseFirestore.instance
          .collection('business')
          //.where('status', isEqualTo: "active")
          //.where('type', isEqualTo: "business")
          .get()
          .then((value) async {
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in value.docs) {
              BusinessProfileModel business = BusinessProfileModel.fromMap(doc);
              if (business.id.isNotEmpty) {
                // if (businesses.length <= 207) {
                businesses.add(business);
                //}
              }
            }
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  BusinessProfileModel getBusinessByID(String id) {
    BusinessProfileModel business;
    business = businesses.firstWhere(
      (element) => element.id == id,
      orElse: BusinessProfileModel.getEmptyBusiness,
    );
    return business;
  }

  void addBusiness(BusinessProfileModel business) {
    businesses.add(business);
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
}
