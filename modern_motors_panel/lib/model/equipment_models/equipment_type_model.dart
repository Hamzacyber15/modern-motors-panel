import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentTypeModel {
  String id;
  bool? assigned;
  String? driverId;
  String? employeeId;
  String equipmentBrand;
  String equipmentNumber;
  String equipmentType;
  String status;
  String? type;
  String? engineType;
  String? leaseOrderId;

  EquipmentTypeModel({
    required this.id,
    this.assigned,
    this.driverId,
    this.employeeId,
    this.type,
    this.engineType,
    this.leaseOrderId,
    required this.equipmentBrand,
    required this.equipmentNumber,
    required this.equipmentType,
    required this.status,
  });
  factory EquipmentTypeModel.fromMap(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    EquipmentTypeModel em = EquipmentTypeModel(
      id: "",
      equipmentBrand: "",
      equipmentNumber: "",
      equipmentType: "",
      status: "",
    );
    em = EquipmentTypeModel(
      id: doc.id,
      assigned: data!['assigned'] ?? false,
      driverId: data['driverId'] ?? "",
      employeeId: data['employeeId'] ?? "",
      equipmentBrand: data['equipmentBrand'] ?? "",
      equipmentNumber: data['equipmentNumber'] ?? "",
      equipmentType: data['equipmentType'] ?? "",
      status: data['status'] ?? "",
      type: data['type'] ?? "",
      engineType: data['engineType'] ?? "",
      leaseOrderId: data['leaseOrderId'] ?? "",
    );

    return em;
  }
  static EquipmentTypeModel? getEquipment(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return EquipmentTypeModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }
}
