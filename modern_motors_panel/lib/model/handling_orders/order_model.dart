import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/handling_orders/pallet_update_model.dart';

class OrderModel {
  String id;
  Timestamp assignedAt;
  Timestamp startedAt;
  Timestamp endedAt;
  Map<String, dynamic> assignedTo;
  Map<String, dynamic>? oldDropOff;
  String businessId;
  String duration;
  String equipmentId;
  double price;
  String serviceType;
  String status;
  String warehouse;
  String warehouseId;
  String outdoorLocation;
  String outdoorBuilding;
  String outdoorlocationId;
  String packageId;
  String tractorOption;
  String trailerNumber;
  Timestamp timestamp;
  Timestamp? leaseDate;
  String? invoiceId;
  String? paymentId;
  String? generatedBy;
  List<String>? assignedLabour;
  AssignedToModel? assignedToModel;
  String? businessName;
  String? parkingOne;
  String? parkingOneId;
  String? parkingTwo;
  String? parkingTwoId;
  String? supervisorID;
  String? truckId;
  String? refId;
  String? truckNumber;
  bool? caution;
  bool? cautionPermission;
  Timestamp? reportedAt;
  bool? attended;
  String? orderBasis;
  String? scheduledTo;
  Timestamp? scheduledAt;
  String? url;
  List<PalletUpdateModel>? pu;
  String? tenure;
  double? deposit;
  double? leasePrice;
  String? seniorManagerEmployeeID;
  String? seniorManagerID;
  String? refundedBy;
  double? refundAmount;
  OldDropOffModel? oldDropOffModel;
  ServiceChargeModel? serviceChargeModel;
  String? timeoutID;
  String? timeoutReason;
  Timestamp? timedoutAt;
  double? ratings;
  String? businessStatus;
  String? verifiedBy;
  OrderModel({
    required this.id,
    required this.assignedAt,
    required this.startedAt,
    required this.endedAt,
    required this.assignedTo,
    required this.businessId,
    required this.duration,
    required this.equipmentId,
    required this.price,
    required this.serviceType,
    required this.status,
    required this.warehouse,
    required this.warehouseId,
    required this.outdoorLocation,
    required this.outdoorBuilding,
    required this.outdoorlocationId,
    required this.tractorOption,
    required this.trailerNumber,
    required this.timestamp,
    required this.packageId,
    this.oldDropOff,
    this.leaseDate,
    this.invoiceId,
    this.paymentId,
    this.generatedBy,
    this.assignedLabour,
    this.assignedToModel,
    this.businessName,
    this.parkingOne,
    this.parkingOneId,
    this.parkingTwo,
    this.parkingTwoId,
    this.supervisorID,
    this.truckId,
    this.refId,
    this.truckNumber,
    this.caution,
    this.cautionPermission,
    this.reportedAt,
    this.attended,
    this.orderBasis,
    this.scheduledAt,
    this.scheduledTo,
    this.url,
    this.pu,
    this.tenure,
    this.deposit,
    this.leasePrice,
    this.seniorManagerEmployeeID,
    this.seniorManagerID,
    this.refundAmount,
    this.refundedBy,
    this.oldDropOffModel,
    this.serviceChargeModel,
    this.timedoutAt,
    this.timeoutID,
    this.timeoutReason,
    this.ratings,
    this.businessStatus,
    this.verifiedBy,
    //this.permissionAt,
  });

  factory OrderModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    List<dynamic> aLabour = data!['assignedLabour'] ?? [];
    List<String> assignedLabour = [];
    for (var element in aLabour) {
      assignedLabour.add(element);
    }
    Map<String, dynamic> d = {};
    dynamic a = data['assignedTo'] ?? d;
    AssignedToModel? assignedToModel;
    if (a['id'] != null) {
      assignedToModel = AssignedToModel(assignedTo: a['id'], name: a['name']);
    }
    Map<String, dynamic> dropOff = {};
    dynamic oldDropOff = data['oldDropOff'] ?? dropOff;
    OldDropOffModel? oldDropOffModel;
    if (oldDropOff['outdoorBuilding'] != null) {
      oldDropOffModel = OldDropOffModel(
        outdoorBuilding: oldDropOff['outdoorBuilding'],
        outdoorBuildingId: oldDropOff['outdoorBuildingId'],
        outdoorLocation: oldDropOff['outdoorLocation'],
      );
    }
    Map<String, dynamic> sCharge = {};
    dynamic serviceCharge = data['serviceCharge'] ?? sCharge;
    ServiceChargeModel? serviceChargeModel;
    if (serviceCharge['changeDropLocationCharge'] != null) {
      serviceChargeModel = ServiceChargeModel(
        changeDropLocationCharge:
            double.tryParse(
              serviceCharge['changeDropLocationCharge'].toString(),
            ) ??
            0,
        origPrice: double.tryParse(serviceCharge['origPrice'].toString()) ?? 0,
      );
    }

    List<PalletUpdateModel> pm = [];
    Map<String, dynamic> p = {};
    Map<String, dynamic> pallet = data['palletStatus'] ?? p;
    //Map<String, dynamic> pallet = pa;
    if (pallet.isNotEmpty) {
      pallet.forEach((key, value) {
        //if (value is Map<String, dynamic>) {
        PalletUpdateModel p = PalletUpdateModel(
          id: key,
          status: value['status'] ?? "",
          url: value['url'] ?? "",
          timestamp: value['timestamp'] ?? Timestamp.now(),
          startedAt: value['startedAt'] ?? Timestamp.now(),
          completedAt: value['completedAt'] ?? Timestamp.now(),
          cautionAt: value['cautionAt'] ?? Timestamp.now(),
          cautionUpdatedAt: value['cautionUpdatedAt'] ?? Timestamp.now(),
        );
        if (p.status.isNotEmpty) {
          pm.add(p);
        }
        //}
      });
    }
    // List<PalletUpdateModel> pm = [];
    // for (var element in pallet) {
    //   pm.add(
    //     PalletUpdateModel(
    //       status: element['status'] ?? "",
    //       url: element['url'] ?? "",
    //       timestamp: element['timestamp'] ?? Timestamp.now(),
    //     ),
    //   );
    // }
    OrderModel om = OrderModel(
      id: doc.id,
      assignedAt: data['assignedAt'] ?? Timestamp.now(),
      startedAt: data['startedAt'] ?? Timestamp.now(),
      endedAt: data['endedAt'] ?? Timestamp.now(),
      assignedTo: a,
      businessId: data['businessId'] ?? "",
      duration: data['duration'] ?? "",
      equipmentId: data['equipmentId'] ?? "",
      price: double.tryParse(data['price'].toString()) ?? 0,
      serviceType: data['serviceType'] ?? "",
      status: data['status'] ?? "",
      warehouse: data['warehouse'] ?? "",
      warehouseId: data['warehouseId'] ?? "",
      outdoorLocation: data['outdoorLocation'] ?? "",
      outdoorBuilding: data['outdoorBuilding'] ?? "",
      outdoorlocationId: data['outdoorBuildingId'] ?? "",
      tractorOption: data['tractorOption'] ?? "",
      trailerNumber: data['trailerNumber'] ?? "",
      timestamp: data['timestamp'] ?? Timestamp.now(),
      leaseDate: data['leaseDate'] ?? Timestamp.now(),
      packageId: data["packageId"] ?? "",
      invoiceId: data['invoiceId'] ?? "",
      generatedBy: data['generatedBy'] ?? "",
      parkingOne: data['parkingOne'] ?? "",
      parkingOneId: data['parkingOneId'] ?? "",
      parkingTwo: data['parkingTwo'] ?? "",
      parkingTwoId: data['parkingTwoId'] ?? "",
      supervisorID: data['supervisorID'] ?? "",
      truckId: data['truckId'] ?? "",
      refId: data['refId'] ?? "",
      truckNumber: data['truckNumber'] ?? "",
      caution: data['caution'] ?? false,
      reportedAt: data['reportedAt'],
      cautionPermission: data['cautionPermission'] ?? false,
      attended: data['attended'] ?? false,
      //permissionAt: data['permissionAt'] ?? Timestamp.now,
      orderBasis: data['orderBasis'] ?? "",
      scheduledAt: data['scheduledAt'] ?? Timestamp.now(),
      scheduledTo: data['scheduledTo'] ?? "",
      url: data['url'] ?? "",
      pu: pm,
      assignedLabour: assignedLabour,
      assignedToModel: assignedToModel,
      tenure: data['tenure'] ?? "",
      deposit: double.tryParse(data['deposit'].toString()) ?? 0,
      leasePrice: double.tryParse(data['leasePrice'].toString()) ?? 0,
      seniorManagerEmployeeID: data['seniorManagerEmployeeID'] ?? "",
      seniorManagerID: data['seniorManagerID'] ?? "",
      refundAmount: double.tryParse(data['refundAmount'].toString()) ?? 0,
      refundedBy: data['refundedBy'] ?? "",
      oldDropOffModel: oldDropOffModel,
      serviceChargeModel: serviceChargeModel,
      timeoutID: data['timeoutID'] ?? "",
      timeoutReason: data['timeoutReason'] ?? "",
      timedoutAt: data['timedoutAt'] ?? Timestamp.now(),
      ratings: double.tryParse(data['ratings'].toString()) ?? 0,
      businessStatus: data['businessStatus'] ?? "",
      verifiedBy: data['verifiedBy'] ?? "",
    );
    return om;
  }
  static OrderModel? getOrderDetails(DocumentSnapshot<Map<String, dynamic>> d) {
    try {
      return OrderModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }

  static OrderModel getEmptyOrder() {
    return OrderModel(
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
      outdoorlocationId: "",
      tractorOption: "",
      trailerNumber: "",
      timestamp: Timestamp.now(),
      caution: false,
      reportedAt: Timestamp.now(),
      packageId: "",
    );
  }
}

class AssignedToModel {
  String assignedTo;
  String name;
  AssignedToModel({required this.assignedTo, required this.name});
}

class ServiceChargeModel {
  double changeDropLocationCharge;
  double origPrice;
  ServiceChargeModel({
    required this.changeDropLocationCharge,
    required this.origPrice,
  });
}

class OldDropOffModel {
  String outdoorBuilding;
  String outdoorBuildingId;
  String outdoorLocation;
  OldDropOffModel({
    required this.outdoorBuilding,
    required this.outdoorBuildingId,
    required this.outdoorLocation,
  });
}
