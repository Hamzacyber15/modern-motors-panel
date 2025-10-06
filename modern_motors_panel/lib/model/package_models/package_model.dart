import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/lease_package/lease_package_model.dart';
import 'package:modern_motors_panel/model/price_model.dart';

class PackageModel {
  String id;
  String packageTitle;
  String arabicPackageTitle;
  String description;
  String arabicDescription;
  int labour;
  double price;
  double? gatePass;
  double? cost;
  String containerSize;
  String containerSizeArabic;
  String estimatedDelivery;
  String estimatedDeliveryArabic;
  String orderCategory;
  String equipment;
  String equipmentId;
  String type;
  String status;
  List<LeasePackageModel>? leasePackage;
  List<PriceModel>? prices;
  String? inspectionType;
  bool? employee;
  String? employeeType;
  String? truckSize;
  double? truckSizeKg;
  String? handlingCategory;
  String? country;
  String? port;
  String? businessType;
  PackageModel({
    required this.id,
    required this.packageTitle,
    required this.arabicPackageTitle,
    required this.description,
    required this.arabicDescription,
    required this.labour,
    required this.price,
    required this.containerSize,
    required this.estimatedDelivery,
    required this.orderCategory,
    required this.equipment,
    required this.equipmentId,
    required this.type,
    required this.status,
    this.leasePackage,
    this.gatePass,
    this.inspectionType,
    this.cost,
    required this.containerSizeArabic,
    required this.estimatedDeliveryArabic,
    this.employee,
    this.employeeType,
    this.truckSize,
    this.truckSizeKg,
    this.handlingCategory,
    this.prices,
    this.country,
    this.port,
    this.businessType,
  });
  factory PackageModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    // PackageModel pm = PackageModel(
    //     id: "",
    //     packageTitle: "",
    //     arabicPackageTitle: "",
    //     description: "",
    //     arabicDescription: "",
    //     labour: 0,
    //     price: 0,
    //     containerSize: "",
    //     estimatedDelivery: "",
    //     orderCategory: "",
    //     equipment: "",
    //     equipmentId: "",
    //     type: "",
    //     estimatedDeliveryArabic: "",
    //     containerSizeArabic: "",
    //     status: "");
    List<dynamic> ppDynamic = data!['gatePassPackage'] ?? [];
    List<Map<String, dynamic>> p1 = List<Map<String, dynamic>>.from(ppDynamic);
    List<PriceModel> prices1 = [];
    String dataPlan = "";
    for (var element in p1) {
      double value = 0;
      double price = 0;
      String basis = "";
      String priceStatus = "";
      bool? discountApplied;
      // if (element.containsKey(== "custom") ) {
      //   prices.add(PriceModel(
      //       id: "",
      //       price: element.values.first,
      //       status: "",
      //       duration: element.keys.first,
      //       // orderBasis: element.values.last,
      //       createdAt: DateTime.now()));
      // } else
      // {
      if (element.containsKey('value')) {
        value = double.tryParse(element['value'].toString()) ?? 0;
      }
      if (element.containsKey('custom')) {
        price = double.tryParse(element['custom'].toString()) ?? 0;
        dataPlan = "custom";
      }
      if (element.containsKey('price')) {
        price = double.tryParse(element['price'].toString()) ?? 0;
      }
      if (element.containsKey('basis')) {
        basis = element['basis'] ?? "";
      }
      if (element.containsKey('discountApplied')) {
        discountApplied = element['discountApplied'] ?? false;
      }
      priceStatus = element['status'] ?? "";
      double p = double.tryParse(price.toString()) ?? 0;
      //int p = int.tryParse(price.toString()) ?? 0;

      prices1.add(
        PriceModel(
          id: "",
          price: p,
          status: priceStatus,
          duration: value.toString(),
          createdAt: DateTime.now(),
          orderBasis: basis,
          applyDiscount: discountApplied,
        ),
      );

      // prices.add(PriceModel(
      //     id: "",
      //     price: element.values.first,
      //     status: "",
      //     duration: element.keys.first,
      //     // orderBasis: element.values.last,
      //     createdAt: DateTime.now()));
    }
    List<dynamic> pDynamic = data['leasePackage'] ?? [];
    List<Map<String, dynamic>> p = List<Map<String, dynamic>>.from(pDynamic);
    List<LeasePackageModel> prices = [];
    bool employee = false;
    String empType = "";
    for (var element in p) {
      if (element.containsKey('employee')) {
        employee = element['employee'] ?? false;
      }
      if (element.containsKey('employeeType')) {
        empType = element['employeeType'] ?? "";
      }
      prices.add(
        LeasePackageModel(
          id: "",
          duration: element.keys.first,
          durationArabic: element.keys.last,
          employee: employee,
          employeeCategory: empType,
          price: double.tryParse(element.values.first.toString()) ?? 0,
        ),
      );
    }
    PackageModel pm = PackageModel(
      id: doc.id,
      packageTitle: data['packageTitle'] ?? "",
      arabicPackageTitle: data['arabicPackageTitle'] ?? "",
      description: data['description'] ?? "",
      arabicDescription: data['arabicDescription'] ?? "",
      labour: int.tryParse(data['labour'].toString()) ?? 0,
      price: double.tryParse(data['price'].toString()) ?? 0,
      cost: double.tryParse(data['cost'].toString()) ?? 0,
      gatePass: double.tryParse(data['gatePass'].toString()) ?? 0,
      containerSize: data['containerSize'] ?? "",
      estimatedDelivery: data['estimatedDelivery'] ?? "",
      orderCategory: data['orderCategory'] ?? "",
      equipment: data['equipment'] ?? "",
      equipmentId: data['equipmentId'] ?? "",
      type: data['type'] ?? "",
      status: data['status'] ?? "",
      inspectionType: data['inspectionType'] ?? "",
      estimatedDeliveryArabic: data['estimatedDeliveryArabic'] ?? "",
      containerSizeArabic: data['containerSizeArabic'] ?? "",
      leasePackage: prices,
      employee: data['employee'] ?? false,
      employeeType: data['employeeType'] ?? "",
      truckSize: data['sizeTon'] ?? "",
      truckSizeKg: double.tryParse(data['sizeKg'].toString()) ?? 0,
      handlingCategory: data['handlingCategory'] ?? "",
      port: data['port'] ?? "",
      country: data['country'] ?? "",
      prices: prices1,
      businessType: data['businessType'] ?? "",
    );

    return pm;
  }
  static PackageModel? getPackage(DocumentSnapshot<Map<String, dynamic>> d) {
    try {
      return PackageModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }

  static PackageModel getEmptyPackage() {
    return PackageModel(
      id: "",
      packageTitle: "",
      arabicPackageTitle: "",
      description: "",
      arabicDescription: "",
      labour: 0,
      price: 0,
      cost: 0,
      gatePass: 0,
      containerSize: "",
      estimatedDelivery: "",
      orderCategory: "",
      equipment: "",
      equipmentId: "",
      type: "",
      inspectionType: "",
      estimatedDeliveryArabic: "",
      containerSizeArabic: "",
      status: "",
      leasePackage: [],
    );
  }
}
