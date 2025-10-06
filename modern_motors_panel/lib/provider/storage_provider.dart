import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/firebase_services/services.dart';
import 'package:modern_motors_panel/model/business_models/business_profile_model.dart';
import 'package:modern_motors_panel/model/business_models/storage_area_model.dart';
import 'package:modern_motors_panel/model/business_models/working_labour_fields_model.dart';
import 'package:modern_motors_panel/model/discount_models/offered_discount_model.dart';
import 'package:modern_motors_panel/model/drop_down_menu_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/model/equipment_models/equipment_model.dart';
import 'package:modern_motors_panel/model/equipment_models/equipment_type_model.dart';
import 'package:modern_motors_panel/model/hr_models/fine_model.dart';
import 'package:modern_motors_panel/model/hr_models/nationality_model.dart';
import 'package:modern_motors_panel/model/invoices/invoice_model.dart';
import 'package:modern_motors_panel/model/package_models/package_model.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/model/trucks/truck_model.dart';

class StorageProvider with ChangeNotifier {
  List<StorageAreaModel> coldStorageAreaList = [];
  List<DropDownMenuDataModel> coldStorageArea = [];
  List<DropDownMenuDataModel> wholeSaleArea = [];
  List<StorageAreaModel> wholeSaleList = [];
  List<DropDownMenuDataModel> onionArea = [];
  List<StorageAreaModel> onionList = [];
  List<DropDownMenuDataModel> potatoArea = [];
  List<StorageAreaModel> potatoList = [];
  List<DropDownMenuDataModel> sellFromTruckArea = [];
  List<StorageAreaModel> sellFromTruckList = [];
  List<EquipmentTypeModel> indoorEquipment = [];
  List<EquipmentTypeModel> outdoorEquipment = [];
  List<DropDownMenuDataModel> indoorEquipmentDropDown = [];
  List<DropDownMenuDataModel> indoorEquipmentDropDownType = [];
  List<DropDownMenuDataModel> outdoorEquipmentDropDownType = [];
  List<DropDownMenuDataModel> outdoorEquipmentDropDownTypeActive = [];
  List<StorageAreaModel> parkingAreaListA = [];
  List<DropDownMenuDataModel> parkingAreaA = [];
  List<StorageAreaModel> parkingAreaListC = [];
  List<DropDownMenuDataModel> parkingAreaC = [];
  List<StorageAreaModel> parkingAreaListB = [];
  List<DropDownMenuDataModel> parkingAreaB = [];
  List<StorageAreaModel> commercialAreaListB = [];
  List<DropDownMenuDataModel> commercialAreaB = [];
  List<StorageAreaModel> commercialAreaListA = [];
  List<DropDownMenuDataModel> commercialAreaA = [];
  List<EquipmentModel> equipmentList = [];
  List<DropDownMenuDataModel> equipmentListDropDown = [];
  List<DropDownMenuDataModel> sortingWarehouse = [];
  List<DropDownMenuDataModel> dryStorage = [];
  List<StorageAreaModel> sortingWarehouseList = [];
  List<PackageModel> handlingPackages = [];
  List<PackageModel> sealedInspectionPackages = [];
  List<PackageModel> unsealedInspectionPackages = [];
  List<PackageModel> allInspections = [];
  List<PackageModel> leasePackages = [];
  List<PackageModel> gatePassPackage = [];
  OfferedDiscountModel? discount;
  int stackIndex = 0;
  bool showStart = false;
  bool showPackage = false;
  PackageModel? packageDetail;
  String selectedBlock = "";
  bool isSelected = false;
  bool loading = false;
  List<DropDownMenuDataModel> businessAreaList = [];
  EquipmentModel equipment = EquipmentModel(
    id: "",
    area: "",
    equipmentCapacity: "",
    equipmentIcon: "",
    equipmentTitle: "",
    status: "",
    timestamp: Timestamp.now(),
    price: [],
  );
  BusinessProfileModel business = BusinessProfileModel(
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
    businessLogo: "",
    vatNumber: "",
    type: "",
    terms: false,
    userAttachment: [],
  );
  PublicProfileModel profile = PublicProfileModel(
    "",
    "",
    Timestamp.now(),
    "",
    "",
    "",
    "",
    "",
  );

  // void getColdStorageBlock(String block) {
  //   selectedBlock = block;
  //   //  getColdStorage();
  // }

  void getData() {
    getBusinessProfile(false);
    // getParkingArea();
    // getParkingArea();
    getEquipmentList();
    getWarehouse(false);
  }

  void changeSelected() {
    isSelected != isSelected;
    notifyListeners();
  }

  void updateStackIndex(int s) {
    stackIndex = s;
    notifyListeners();
  }

  void lastIndex() {
    stackIndex -= 1;
    notifyListeners();
  }

  void nextIndex() {
    stackIndex += 1;
    notifyListeners();
  }

  void changeStatus() {
    loading != loading;
  }

  void downloadClosingBalance() {}

  int extractNumericPart(String parkingSpot) {
    List<String> parts = parkingSpot.split('-');
    if (parts.length > 1) {
      return int.tryParse(parts[1]) ?? 0;
    }
    return 0;
  }

  void getWarehouse(bool notify) async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
        'shops',
      );
      query.where('status', isEqualTo: "active");
      await query.get().then((value) {
        // wholeSaleList.clear();
        wholeSaleArea.clear();
        coldStorageArea.clear();
        //coldStorageAreaList.clear();
        onionArea.clear();
        // onionList.clear();
        potatoArea.clear();
        //  potatoList.clear();
        sellFromTruckArea.clear();
        //   sellFromTruckList.clear();
        parkingAreaA.clear();
        //  parkingAreaListA.clear();
        parkingAreaC.clear();
        // parkingAreaListC.clear();
        sortingWarehouse.clear();
        dryStorage.clear();
        parkingAreaB.clear();
        parkingAreaListB.clear();
        commercialAreaA.clear();
        commercialAreaListA.clear();
        commercialAreaB.clear();
        commercialAreaListB.clear();
        for (var doc in value.docs) {
          StorageAreaModel? sm = StorageAreaModel.getStorageList(doc);
          if (sm != null) {
            //if (type == "wholeSale") {
            if (sm.area == "wholeSale") {
              //  wholeSaleList.add(sm);
              wholeSaleArea.add(
                DropDownMenuDataModel(sm.id, "Whole Sale", sm.name),
              );
              // }
            } else if (sm.area == "coldStorage") {
              // coldStorageAreaList.add(sm);
              coldStorageArea.add(
                DropDownMenuDataModel(sm.id, "Cold Storage", sm.name),
              );
            } else if (sm.area == "onionShade") {
              // onionList.add(sm);
              onionArea.add(
                DropDownMenuDataModel(sm.id, "Onion Shade", sm.name),
              );
            } else if (sm.area == "potatoShade") {
              // potatoList.add(sm);
              potatoArea.add(
                DropDownMenuDataModel(sm.id, "Potato Shade", sm.name),
              );
            } else if (sm.area == "saleFromTruck") {
              // sellFromTruckList.add(sm);
              sellFromTruckArea.add(
                DropDownMenuDataModel(sm.id, "Sale From Truck", sm.name),
              );
            } else if (sm.area == "parking") {
              if (sm.block == "a") {
                //  parkingAreaListA.add(sm);
                parkingAreaA.add(
                  DropDownMenuDataModel(sm.id, sm.area, sm.name),
                );
              } else if (sm.block == "c") {
                //  parkingAreaListC.add(sm);
                parkingAreaC.add(
                  DropDownMenuDataModel(sm.id, sm.area, sm.name),
                );
              } else if (sm.block == "b") {
                parkingAreaB.add(
                  DropDownMenuDataModel(sm.id, sm.area, sm.name),
                );
              }
            } else if (sm.area == "sortingWarehouse") {
              sortingWarehouse.add(
                DropDownMenuDataModel(sm.id, sm.area, sm.name),
              );
            } else if (sm.area == "dryStorage") {
              dryStorage.add(
                DropDownMenuDataModel(sm.id, "Dry Storage", sm.name),
              );
            } else if (sm.area == "commercialAreaA") {
              commercialAreaA.add(
                DropDownMenuDataModel(
                  sm.id,
                  "Commercial Building (A)",
                  sm.name,
                ),
              );
            } else if (sm.area == "commercialAreaB") {
              commercialAreaB.add(
                DropDownMenuDataModel(
                  sm.id,
                  "Commercial Building (B)",
                  sm.name,
                ),
              );
            }
          }
        }
        if (wholeSaleArea.isNotEmpty) {
          // wholeSaleArea.sort((a, b) {
          //   int numericPartA = extractNumericPart(a.value);
          //   int numericPartB = extractNumericPart(b.value);
          //   String prefixA = a.value.split('-')[0];
          //   String prefixB = b.value.split('-')[0];
          //   if (prefixA != prefixB) {
          //     return prefixA
          //         .compareTo(prefixB); // Sort alphabetically by prefix
          //   } else {
          //     return numericPartA
          //         .compareTo(numericPartB); // Sort numerically by number part
          //   }
          // });
          // wholeSaleArea.sort((a, b) {
          //   int numericPartA = extractNumericPart(a.value);
          //   int numericPartB = extractNumericPart(b.value);

          //   String prefixA = a.value.split('-')[0];
          //   String prefixB = b.value.split('-')[0];

          //   int prefixComparison = prefixA.compareTo(prefixB);
          //   if (prefixComparison != 0) {
          //     return prefixComparison;
          //   } else {
          //     return numericPartA.compareTo(numericPartB);
          //   }
          // });
          wholeSaleArea.sort((a, b) {
            // Extract numeric parts directly within the sort function
            int numericPartA = int.parse(a.value.split('-')[1]);
            int numericPartB = int.parse(b.value.split('-')[1]);

            // Extract prefixes
            String prefixA = a.value.split('-')[0];
            String prefixB = b.value.split('-')[0];

            // Compare prefixes first
            int prefixComparison = prefixA.compareTo(prefixB);
            if (prefixComparison != 0) {
              return prefixComparison;
            } else {
              // If prefixes are the same, compare numeric parts
              return numericPartA.compareTo(numericPartB);
            }
          });
        }
        if (coldStorageArea.isNotEmpty) {
          coldStorageArea.sort((a, b) {
            // Extract numeric parts directly within the sort function
            int numericPartA = int.parse(a.value.split('-')[1]);
            int numericPartB = int.parse(b.value.split('-')[1]);

            // Extract prefixes
            String prefixA = a.value.split('-')[0];
            String prefixB = b.value.split('-')[0];

            // Compare prefixes first
            int prefixComparison = prefixA.compareTo(prefixB);
            if (prefixComparison != 0) {
              return prefixComparison;
            } else {
              // If prefixes are the same, compare numeric parts
              return numericPartA.compareTo(numericPartB);
            }
          });
          // coldStorageArea.sort((a, b) {
          //   String firstCharA = a.value.isNotEmpty ? a.value[0] : '';
          //   String firstCharB = b.value.isNotEmpty ? b.value[0] : '';
          //   if (firstCharA != firstCharB) {
          //     return firstCharA.compareTo(firstCharB);
          //   } else {
          //     int numericPartA = int.tryParse(a.value.substring(1)) ?? 0;
          //     int numericPartB = int.tryParse(b.value.substring(1)) ?? 0;
          //     return numericPartA.compareTo(numericPartB);
          //   }
          // });
          // coldStorageArea.sort((a, b) {
          //   // Extract numeric parts directly within the sort function
          //   int numericPartA = int.parse(a.value.split('-')[1]);
          //   int numericPartB = int.parse(b.value.split('-')[1]);

          //   // Extract the last character of the prefixes
          //   String lastCharA = a.value.split('-')[0].substring(2, 3);
          //   String lastCharB = b.value.split('-')[0].substring(2, 3);

          //   // Compare numeric parts first
          //   int numericComparison = numericPartA.compareTo(numericPartB);
          //   if (numericComparison != 0) {
          //     return numericComparison;
          //   } else {
          //     // If numeric parts are the same, compare the last character of the prefix
          //     return lastCharA.compareTo(lastCharB);
          //   }
          // });
        }
        if (onionArea.isNotEmpty) {
          onionArea.sort((a, b) {
            // Extract numeric parts directly within the sort function
            int numericPartA = int.parse(a.value.split('-')[1]);
            int numericPartB = int.parse(b.value.split('-')[1]);

            // Extract prefixes
            String prefixA = a.value.split('-')[0];
            String prefixB = b.value.split('-')[0];

            // Compare prefixes first
            int prefixComparison = prefixA.compareTo(prefixB);
            if (prefixComparison != 0) {
              return prefixComparison;
            } else {
              // If prefixes are the same, compare numeric parts
              return numericPartA.compareTo(numericPartB);
            }
          });
        }
        if (potatoArea.isNotEmpty) {
          potatoArea.sort((a, b) {
            // Extract numeric parts directly within the sort function
            int numericPartA = int.parse(a.value.split('-')[1]);
            int numericPartB = int.parse(b.value.split('-')[1]);

            // Extract prefixes
            String prefixA = a.value.split('-')[0];
            String prefixB = b.value.split('-')[0];

            // Compare prefixes first
            int prefixComparison = prefixA.compareTo(prefixB);
            if (prefixComparison != 0) {
              return prefixComparison;
            } else {
              // If prefixes are the same, compare numeric parts
              return numericPartA.compareTo(numericPartB);
            }
          });
        }
        if (sellFromTruckArea.isNotEmpty) {
          sellFromTruckArea.sort((a, b) {
            // Extract numeric parts directly within the sort function
            int numericPartA = int.parse(a.value.split('-')[1]);
            int numericPartB = int.parse(b.value.split('-')[1]);

            // Extract prefixes
            String prefixA = a.value.split('-')[0];
            String prefixB = b.value.split('-')[0];

            // Compare prefixes first
            int prefixComparison = prefixA.compareTo(prefixB);
            if (prefixComparison != 0) {
              return prefixComparison;
            } else {
              // If prefixes are the same, compare numeric parts
              return numericPartA.compareTo(numericPartB);
            }
          });
          // sellFromTruckArea.sort((a, b) {
          //   // Get first character of parking spots
          //   String firstCharA = a.value.isNotEmpty ? a.value[0] : '';
          //   String firstCharB = b.value.isNotEmpty ? b.value[0] : '';

          //   // Compare based on first character
          //   if (firstCharA != firstCharB) {
          //     // If first characters are different, sort alphabetically
          //     return firstCharA.compareTo(firstCharB);
          //   } else {
          //     // If first characters are same, sort numerically
          //     int numericPartA = int.tryParse(a.value.substring(1)) ?? 0;
          //     int numericPartB = int.tryParse(b.value.substring(1)) ?? 0;
          //     return numericPartA.compareTo(numericPartB);
          //   }
          // });
          // sellFromTruckArea.sort((a, b) {
          //   int numericPartA = extractNumericPart(a.value);
          //   int numericPartB = extractNumericPart(b.value);
          //   String prefixA = a.value.split('-')[0];
          //   String prefixB = b.value.split('-')[0];
          //   if (prefixA != prefixB) {
          //     return prefixA
          //         .compareTo(prefixB); // Sort alphabetically by prefix
          //   } else {
          //     return numericPartA
          //         .compareTo(numericPartB); // Sort numerically by number part
          //   }
          // });
        }
        if (parkingAreaA.isNotEmpty) {
          // parkingAreaA.sort((a, b) {
          //   // Get first character of parking spots
          //   String firstCharA = a.value.isNotEmpty ? a.value[0] : '';
          //   String firstCharB = b.value.isNotEmpty ? b.value[0] : '';

          //   // Compare based on first character
          //   if (firstCharA != firstCharB) {
          //     // If first characters are different, sort alphabetically
          //     return firstCharA.compareTo(firstCharB);
          //   } else {
          //     // If first characters are same, sort numerically
          //     int numericPartA = int.tryParse(a.value.substring(1)) ?? 0;
          //     int numericPartB = int.tryParse(b.value.substring(1)) ?? 0;
          //     return numericPartA.compareTo(numericPartB);
          //   }
          // });
          parkingAreaA.sort((a, b) {
            // Get first character of parking spots
            String firstCharA = a.value.isNotEmpty ? a.value[0] : '';
            String firstCharB = b.value.isNotEmpty ? b.value[0] : '';

            // Compare based on first character
            if (firstCharA != firstCharB) {
              // If first characters are different, sort alphabetically
              return firstCharA.compareTo(firstCharB);
            } else {
              // If first characters are same, sort numerically
              int numericPartA = int.tryParse(a.value.substring(1)) ?? 0;
              int numericPartB = int.tryParse(b.value.substring(1)) ?? 0;
              return numericPartA.compareTo(numericPartB);
            }
          });
        }
        if (parkingAreaC.isNotEmpty) {
          parkingAreaC.sort((a, b) {
            // Get first character of parking spots
            String firstCharA = a.value.isNotEmpty ? a.value[0] : '';
            String firstCharB = b.value.isNotEmpty ? b.value[0] : '';

            // Compare based on first character
            if (firstCharA != firstCharB) {
              // If first characters are different, sort alphabetically
              return firstCharA.compareTo(firstCharB);
            } else {
              // If first characters are same, sort numerically
              int numericPartA = int.tryParse(a.value.substring(1)) ?? 0;
              int numericPartB = int.tryParse(b.value.substring(1)) ?? 0;
              return numericPartA.compareTo(numericPartB);
            }
          });
        }
        if (sortingWarehouse.isNotEmpty) {
          sortingWarehouse.sort((a, b) {
            // Get first character of parking spots
            String firstCharA = a.value.isNotEmpty ? a.value[0] : '';
            String firstCharB = b.value.isNotEmpty ? b.value[0] : '';

            // Compare based on first character
            if (firstCharA != firstCharB) {
              // If first characters are different, sort alphabetically
              return firstCharA.compareTo(firstCharB);
            } else {
              // If first characters are same, sort numerically
              int numericPartA = int.tryParse(a.value.substring(1)) ?? 0;
              int numericPartB = int.tryParse(b.value.substring(1)) ?? 0;
              return numericPartA.compareTo(numericPartB);
            }
          });
        }
        if (dryStorage.isNotEmpty) {
          dryStorage.sort((a, b) {
            // Get first character of parking spots
            String firstCharA = a.value.isNotEmpty ? a.value[0] : '';
            String firstCharB = b.value.isNotEmpty ? b.value[0] : '';

            // Compare based on first character
            if (firstCharA != firstCharB) {
              // If first characters are different, sort alphabetically
              return firstCharA.compareTo(firstCharB);
            } else {
              // If first characters are same, sort numerically
              int numericPartA = int.tryParse(a.value.substring(1)) ?? 0;
              int numericPartB = int.tryParse(b.value.substring(1)) ?? 0;
              return numericPartA.compareTo(numericPartB);
            }
          });
        }
      });
      if (notify) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getBusinessProfile(bool notify) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('business')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              BusinessProfileModel? bp = BusinessProfileModel.getBusinessList(
                doc,
              );
              if (bp != null) {
                business = bp;
                Constants.businessProfile = bp;
                // if (bp.depositAmount! > 0) {
                //   Constants.deposit = true;
                // } else {
                //   Constants.deposit = false;
                // }

                //Constants.businessId = business.id;
              }
            }
            for (var element in business.businessAreas) {
              businessAreaList.add(
                DropDownMenuDataModel(element.id, element.title, element.value),
              );
            }
          });
      if (notify) {
        notifyListeners();
      }
      // notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<EmployeeModel?> getEmployeeProfileById(String businessId) async {
    EmployeeModel? employee;
    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(businessId)
          .get()
          .then((doc) {
            if (doc.exists) {
              EmployeeModel? em = EmployeeModel.getBusinessList(doc);
              if (em != null) {
                employee = em;
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return employee;
  }

  Future<List<String>> getEmployeeEquipment(String employeeId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('equipments')) {
          final equipmentList = List<String>.from(data['equipments'] ?? []);
          return equipmentList;
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getting employee equipment: $e');
      return []; // Return empty list on error
    }
  }

  Future<BusinessProfileModel?> getBusinessProfileById(String id) async {
    BusinessProfileModel? b;
    try {
      await FirebaseFirestore.instance
          .collection('business')
          .doc(id)
          .get()
          .then((doc) {
            BusinessProfileModel? bp = BusinessProfileModel.getBusinessList(
              doc,
            );
            if (bp != null) {
              b = bp;
            }
          });
      // notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
    return b;
  }

  Future<TruckModel?> getTruckData(String id) async {
    TruckModel? b;
    try {
      await FirebaseFirestore.instance.collection('trucks').doc(id).get().then((
        doc,
      ) {
        TruckModel? bp = TruckModel.getTruckList(doc);
        if (bp != null) {
          b = bp;
        }
      });
      // notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
    return b;
  }

  void getParkingArea() async {
    try {
      await FirebaseFirestore.instance
          .collection('parking')
          .where('status', isEqualTo: "active")
          .get()
          .then((value) {
            parkingAreaA.clear();
            parkingAreaListA.clear();
            parkingAreaC.clear();
            parkingAreaListC.clear();
            for (var doc in value.docs) {
              StorageAreaModel sm = StorageAreaModel(
                id: doc.id,
                block: doc.data()['block'] ?? "",
                area: doc.data()['parking'] ?? "",
                status: doc.data()['status'] ?? "",
                name: "",
              );
              if (sm.block == "a") {
                parkingAreaListA.add(sm);
                parkingAreaA.add(
                  DropDownMenuDataModel(sm.id, sm.block!, sm.area),
                );
              } else {
                parkingAreaListC.add(sm);
                parkingAreaC.add(
                  DropDownMenuDataModel(sm.id, sm.block!, sm.area),
                );
              }
            }
          });
      // notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  void getEquipment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('equipment')
          .where('status', isEqualTo: "active")
          .orderBy("equipmentNumber", descending: false)
          .get()
          .then((value) {
            //   if (type == "Indoor") {
            indoorEquipment.clear();
            indoorEquipmentDropDown.clear();
            for (var doc in value.docs) {
              EquipmentTypeModel? em = EquipmentTypeModel.getEquipment(doc);
              if (em != null) {
                // int i = int.tryParse(em.equipmentNumber) ?? 0;
                //  if (type == "Indoor") {
                indoorEquipment.add(em);
                indoorEquipmentDropDown.add(
                  DropDownMenuDataModel(
                    em.id,
                    em.equipmentNumber,
                    em.equipmentNumber,
                  ),
                );
              }
            }
          });
      // notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<EquipmentTypeModel>?> getAllEquipments() async {
    List<EquipmentTypeModel> allEquipments = [];
    try {
      await FirebaseFirestore.instance
          .collection('equipment')
          .where('status', isEqualTo: "active")
          .get()
          .then((value) {
            for (var doc in value.docs) {
              EquipmentTypeModel? em = EquipmentTypeModel.getEquipment(doc);
              if (em != null) {
                //  if (type == "Indoor") {
                allEquipments.add(em);
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return allEquipments;
  }

  Future<List<EquipmentTypeModel>?> getAllEquipmentType(String id) async {
    List<EquipmentTypeModel> allEquipments = [];
    try {
      await FirebaseFirestore.instance
          .collection('equipment')
          .where('equipmentType', isEqualTo: id)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              EquipmentTypeModel? em = EquipmentTypeModel.getEquipment(doc);
              if (em != null) {
                //  if (type == "Indoor") {
                allEquipments.add(em);
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return allEquipments;
  }

  Future<EquipmentTypeModel?> getEquipmentDetailsById(String id) async {
    EquipmentTypeModel? equipment;
    try {
      await FirebaseFirestore.instance
          .collection('equipment')
          .doc(id)
          .get()
          .then((doc) {
            if (doc.exists) {
              EquipmentTypeModel? em = EquipmentTypeModel.getEquipment(doc);
              if (em != null) {
                //  if (type == "Indoor") {
                equipment = em;
              }
            }
          });
      // notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
    return equipment;
  }

  Future<List<EquipmentTypeModel>?> getEquipmentByType(String id) async {
    List<EquipmentTypeModel> equipmentList = [];
    try {
      await FirebaseFirestore.instance
          .collection('equipment')
          .where('equipmentType', isEqualTo: id)
          .get()
          .then((value) {
            //   if (type == "Indoor") {

            for (var doc in value.docs) {
              EquipmentTypeModel? em = EquipmentTypeModel.getEquipment(doc);
              if (em != null) {
                equipmentList.add(em);
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return equipmentList;
  }

  Future<TruckModel?> getTruckById(String id) async {
    TruckModel? truck;
    try {
      await FirebaseFirestore.instance
          .collection('trucks')
          .where('truckCode', isNotEqualTo: "")
          .get()
          .then((value) {
            //   if (type == "Indoor") {

            for (var doc in value.docs) {
              TruckModel? em = TruckModel.getTruckList(doc);
              if (em != null) {
                truck = em;
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return truck;
  }

  void getPackages() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('packages')
          .where('status', isNotEqualTo: "pending")
          .get()
          .then((value) {
            handlingPackages.clear();
            sealedInspectionPackages.clear();
            unsealedInspectionPackages.clear();
            leasePackages.clear();
            allInspections.clear();
            gatePassPackage.clear();
            for (var doc in value.docs) {
              PackageModel? pm = PackageModel.getPackage(doc);
              if (pm != null) {
                if (pm.type == "handling") {
                  handlingPackages.add(pm);
                } else if (pm.type == "inspection") {
                  allInspections.add(pm);
                  if (pm.inspectionType == "Sealed") {
                    sealedInspectionPackages.add(pm);
                  } else {
                    unsealedInspectionPackages.add(pm);
                  }
                } else if (pm.type == "lease") {
                  leasePackages.add(pm);
                } else if (pm.type == "trailer" ||
                    pm.type == "truckOffloading") {
                  gatePassPackage.add(pm);
                }
              }
            }
            notifyListeners();
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  /*
  Future<PackageModel?> getPackageById(String id) async {
    PackageModel? p;
    try {
      await FirebaseFirestore.instance
          .collection('packages')
          .doc(id)
          .get()
          .then((doc) {
        //packages.clear();
        if (doc.exists) {
          PackageModel? pm = PackageModel.getPackage(doc);
          if (pm != null) {
            p = pm;
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return p;
  }
  */

  Future<List<LabourWorkingFieldsModel>> fetchWorkingFields() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('labourWorkingFields')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((e) => LabourWorkingFieldsModel.fromSnapshot(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    } finally {}
  }

  Future<List<NationalityModel>> fetchNationality() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('nationality')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((e) => NationalityModel.fromSnapshot(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    } finally {}
  }

  void getEquipmentList() async {
    equipmentList.clear();
    equipmentListDropDown.clear();
    indoorEquipmentDropDownType.clear();
    outdoorEquipmentDropDownType.clear();
    try {
      await FirebaseFirestore.instance
          .collection('equipmentType')
          .where('status', isNotEqualTo: "")
          .get()
          .then((value) {
            for (var doc in value.docs) {
              // equipmentList.clear();
              // equipmentListDropDown.clear();
              EquipmentModel? em = EquipmentModel.getBusinessList(doc);
              if (em != null) {
                if (em.status == "active") {
                  if (em.area == "Indoor") {
                    indoorEquipmentDropDownType.add(
                      DropDownMenuDataModel(
                        em.id,
                        em.equipmentTitle,
                        em.equipmentTitle,
                        image: em.equipmentIcon,
                      ),
                    );
                  } else if (em.area == "Outdoor") {
                    outdoorEquipmentDropDownType.add(
                      DropDownMenuDataModel(
                        em.id,
                        em.equipmentTitle,
                        em.equipmentTitle,
                        image: em.equipmentIcon,
                      ),
                    );
                  }
                }
                equipmentList.add(em);
                equipmentListDropDown.add(
                  DropDownMenuDataModel(
                    em.id,
                    em.equipmentTitle,
                    em.equipmentTitle,
                    image: em.equipmentIcon,
                  ),
                );
              }
            }
          });
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<EquipmentModel>> getEquipmentList1() async {
    List<EquipmentModel> eList = [];

    outdoorEquipmentDropDownTypeActive.clear();
    // equipmentListDropDown.clear();
    // indoorEquipmentDropDownType.clear();
    // outdoorEquipmentDropDownType.clear();
    try {
      await FirebaseFirestore.instance
          .collection('equipmentType')
          .where('status', isEqualTo: "active")
          .get()
          .then((value) {
            for (var doc in value.docs) {
              // equipmentList.clear();
              // equipmentListDropDown.clear();
              EquipmentModel? em = EquipmentModel.getBusinessList(doc);
              if (em != null) {
                eList.add(em);
                outdoorEquipmentDropDownTypeActive.add(
                  DropDownMenuDataModel(
                    em.id,
                    em.equipmentTitle,
                    em.equipmentTitle,
                    image: em.equipmentIcon,
                  ),
                );
              }
            }
          });
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
    return eList;
  }

  Future<EquipmentModel?> getEquipmentById(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    EquipmentModel? equipment;
    if (user == null) {
      return equipment;
    }
    try {
      await FirebaseFirestore.instance
          .collection('equipmentType')
          .doc(id)
          .get()
          .then((doc) {
            EquipmentModel? em = EquipmentModel.getBusinessList(doc);
            if (em != null) {
              equipment = em;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return equipment;
  }

  Future<List<InvoiceModel>?> getInvoices(String title, String heading) async {
    List<InvoiceModel> invoiceList = [];
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .where(title, isEqualTo: heading)
          .orderBy('timeStamp', descending: true)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              InvoiceModel? i = InvoiceModel.getInvoiceList(doc);
              if (i != null) {
                invoiceList.add(i);
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return invoiceList;
  }

  Future<List<InvoiceModel>?> getAdminInvoices(
    String title,
    String heading,
  ) async {
    List<InvoiceModel> invoiceList = [];
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          //.where("type", isNotEqualTo: "")
          .orderBy('timeStamp', descending: true)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              InvoiceModel? i = InvoiceModel.getInvoiceList(doc);
              if (i != null) {
                invoiceList.add(i);
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return invoiceList;
  }

  // Future<List<InvoiceModel>?> getAdminFilteredInvoices(String title) async {
  //   List<InvoiceModel> invoiceList = [];

  //   try {
  //     Query query = FirebaseFirestore.instance
  //         .collection('transactions')
  //         .orderBy('timeStamp', descending: true);

  //     // Apply type filter only if not "All"
  //     if (title != "All") {
  //       query = query.where("type", isEqualTo: title);
  //     }

  //     final snapshot = await query.get();

  //     for (var doc in snapshot.docs) {
  //       final DocumentSnapshot<Map<String, dynamic>> castedDoc =
  //           doc as DocumentSnapshot<Map<String, dynamic>>;
  //       InvoiceModel? invoice = InvoiceModel.getInvoiceList(castedDoc);
  //       if (invoice != null) {
  //         invoiceList.add(invoice);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching invoices: $e");
  //   }

  //   return invoiceList;
  // }

  // Future<List<InvoiceModel>?> getAdminFilteredInvoices({
  //   String? type, // e.g., "lease", "order", etc.
  //   DateTime? startDate, // optional start date
  //   DateTime? endDate, // optional end date
  //   String? invoiceNumber, // optional invoice number search
  // }) async {
  //   List<InvoiceModel> invoiceList = [];

  //   try {
  //     CollectionReference<Map<String, dynamic>> ref =
  //         FirebaseFirestore.instance.collection('transactions');

  //     Query<Map<String, dynamic>> query = ref;

  //     // If invoice number is provided, search only for that
  //     if (invoiceNumber != null && invoiceNumber.isNotEmpty) {
  //       query = query.where("invoice", isEqualTo: invoiceNumber);
  //     } else {
  //       // Filter by type if specified and not "All"
  //       if (type != null && type.isNotEmpty && type != "All") {
  //         query = query.where("type", isEqualTo: type);
  //       }

  //       // Filter by date range
  //       if (startDate != null) {
  //         query = query.where("timeStamp",
  //             isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
  //       }
  //       if (endDate != null) {
  //         query = query.where("timeStamp",
  //             isLessThanOrEqualTo: Timestamp.fromDate(endDate));
  //       }

  //       // Always order by date
  //       query = query.orderBy("timeStamp", descending: true);
  //     }

  //     final snapshot = await query.get();

  //     for (var doc in snapshot.docs) {
  //       final DocumentSnapshot<Map<String, dynamic>> castedDoc =
  //           doc as DocumentSnapshot<Map<String, dynamic>>;
  //       InvoiceModel? invoice = InvoiceModel.getInvoiceList(castedDoc);
  //       if (invoice != null) {
  //         invoiceList.add(invoice);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching invoices: $e");
  //   }

  //   return invoiceList;
  // }

  Future<List<InvoiceModel>?> getAdminFilteredInvoices({
    String? type, // e.g., "lease", "order", etc.
    DateTime? startDate, // optional start date
    DateTime? endDate, // optional end date
    String? invoiceNumber, // optional invoice number search
  }) async {
    List<InvoiceModel> invoiceList = [];

    try {
      CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore.instance
          .collection('transactions');

      Query<Map<String, dynamic>> query = ref;

      // If invoice number is provided, search only for that
      if (invoiceNumber != null && invoiceNumber.isNotEmpty) {
        query = query.where("invoice", isEqualTo: invoiceNumber);
      } else {
        // Filter by type if specified and not "All"
        if (type != null && type.isNotEmpty && type != "All") {
          query = query.where("type", isEqualTo: type);
        }

        // Filter by date range
        if (startDate != null) {
          query = query.where(
            "timeStamp",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          );
        }
        if (endDate != null) {
          query = query.where(
            "timeStamp",
            isLessThanOrEqualTo: Timestamp.fromDate(
              DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59),
            ),
          );
        }

        // Always order by date
        query = query.orderBy("timeStamp", descending: true);
      }

      final snapshot = await query.get();

      for (var doc in snapshot.docs) {
        InvoiceModel? invoice = InvoiceModel.getInvoiceList(doc);
        if (invoice != null) {
          invoiceList.add(invoice);
        }
      }
    } catch (e) {
      debugPrint("Error fetching invoices: $e");
      // Add more detailed error logging
      debugPrint(
        "Parameters - type: $type, startDate: $startDate, endDate: $endDate, invoiceNumber: $invoiceNumber",
      );
    }

    return invoiceList.isNotEmpty ? invoiceList : null;
  }

  Future<List<InvoiceModel>?> getSilalInvoices() async {
    List<InvoiceModel> invoiceList = [];
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          //.where("type", isNotEqualTo: "")
          .orderBy('timeStamp', descending: true)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              InvoiceModel? i = InvoiceModel.getInvoiceList(doc);
              if (i != null) {
                if (i.type == "inspectionPayment") {
                  invoiceList.add(i);
                }
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return invoiceList;
  }

  Future<List<InvoiceModel>?> getSilalInvoicesByBusinessId(
    String businessId,
  ) async {
    List<InvoiceModel> invoiceList = [];
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .where("businessId", isNotEqualTo: businessId)
          .orderBy('timeStamp', descending: true)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              InvoiceModel? i = InvoiceModel.getInvoiceList(doc);
              if (i != null) {
                if (i.type == "inspectionPayment") {
                  invoiceList.add(i);
                }
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return invoiceList;
  }

  Future<double> getWalletBalance(String id) async {
    double amount = 0;
    try {
      await FirebaseFirestore.instance.collection('wallet').doc(id).get().then((
        doc,
      ) {
        if (doc.exists) {
          amount = double.tryParse(doc['depositAmount'].toString()) ?? 0;
          if (amount > 0) {
            Constants.deposit = true;
            Constants.depositAmount = amount;
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return amount;
  }

  void changeDistanceView(bool status) {
    showStart = status;
    notifyListeners();
  }

  DateTime? convertToDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  final Services _fineService = Services();
  List<FineModel> _fines = [];
  bool _isLoading = false;
  String? _error;
  List<FineModel> get fines => _fines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch fines and update state
  Future<void> fetchFines() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _fines = await _fineService.fetchFines();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
