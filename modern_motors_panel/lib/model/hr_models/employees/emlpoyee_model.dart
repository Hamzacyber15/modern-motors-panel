import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/hr_models/employees/alloted_allowances_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/alloted_leaves_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/assigned_equipment_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/hr_info_model.dart';

class EmployeeModel {
  String id;
  List<String> attachments;
  String contactNumber;
  String designation;
  String idCardNumber;
  String name;
  String emergencyName;
  String emergencyContact;
  String gender;
  String streetAddress1;
  String streetAddress2;
  String city;
  String state;
  String postalCode;
  String countryId;
  String branchId;
  List<String>? branches;
  String roleId;
  DateTime dob;
  String? profileUrl;
  String otherCompany;
  String status;
  Timestamp timestamp;
  String userId;
  bool globalEmployee;
  List<String> equipments;
  String email;
  String? assignedVehicle;
  String? assignedBuilding;
  String? assignedBuildingBlock;
  String? assignedBuildingId;
  Timestamp? assignedBuildingTime;
  List<String>? adminAccess;
  String? employeeId;
  String? employeeCode;
  Uint8List? marker;
  String? employeeNumber;
  String? najahiBusinessID;
  String? nationality;
  String? nationalityId;
  String? workingArea;
  String? workingAreaId;
  HrInfoModel? hrInfo;
  List<String>? profileAccessKey;
  AssignedEquipmentModel? assignedEquipment;
  List<AllotedLeavesModel>? leaveInfo;
  double? baasi;
  double? baasiEmpCon;
  double? baasiEmprCon;
  List<AllotedAllowancesModel>? allowanceInfo;

  EmployeeModel({
    required this.id,
    required this.attachments,
    required this.contactNumber,
    required this.designation,
    required this.idCardNumber,
    required this.name,
    required this.emergencyName,
    required this.emergencyContact,
    required this.gender,
    required this.streetAddress1,
    required this.streetAddress2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.countryId,
    required this.roleId,
    this.profileUrl,
    required this.branchId,
    required this.dob,
    required this.otherCompany,
    required this.status,
    required this.timestamp,
    required this.userId,
    required this.globalEmployee,
    required this.equipments,
    required this.email,
    this.profileAccessKey,
    this.assignedVehicle,
    this.branches,
    this.assignedBuilding,
    this.assignedBuildingBlock,
    this.assignedBuildingId,
    this.assignedBuildingTime,
    this.adminAccess,
    this.employeeId,
    this.employeeCode,
    this.marker,
    this.employeeNumber,
    this.najahiBusinessID,
    this.nationality,
    this.nationalityId,
    this.workingArea,
    this.workingAreaId,
    this.hrInfo,
    this.leaveInfo,
    this.baasi,
    this.baasiEmpCon,
    this.baasiEmprCon,
    this.allowanceInfo,
    this.assignedEquipment,
  });

  factory EmployeeModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    EmployeeModel em = EmployeeModel(
      id: "",
      attachments: [],
      contactNumber: "",
      designation: "",
      idCardNumber: "",
      name: "",
      emergencyName: "",
      emergencyContact: "",
      streetAddress1: "",
      streetAddress2: "",
      profileUrl: "",
      dob: DateTime.now(),
      roleId: '',
      branchId: '',
      city: "",
      state: "",
      postalCode: "",
      countryId: "",
      gender: "",
      otherCompany: "",
      status: "",
      timestamp: Timestamp.now(),
      userId: "",
      equipments: [],
      email: "",
      profileAccessKey: [],
      globalEmployee: false,
      najahiBusinessID: "",
    );
    List<dynamic> a = data!['attachments'] ?? [];
    List<String> attachments = [];
    for (var element in a) {
      attachments.add(element);
    }
    List<dynamic> e = data['equipments'] ?? [];
    List<String> equipments = [];
    for (var element in e) {
      equipments.add(element);
    }
    List<dynamic> pAccess = data['profileAccessKey'] ?? [];
    List<String> profileAccessKey = pAccess.map((e) => e.toString()).toList();

    List<dynamic> aAcess = data['adminAccess'] ?? [];
    List<String> adminAcess = [];
    for (var element in aAcess) {
      adminAcess.add(element);
    }
    HrInfoModel? hrInfo = data['hrInfo'] != null
        ? HrInfoModel.fromMap(Map<String, dynamic>.from(data['hrInfo']))
        : null;

    HrInfoModel? hrInfotable;
    AssignedEquipmentModel? aEquipment = data['assignedEquipment'] != null
        ? AssignedEquipmentModel.fromMap(
            Map<String, dynamic>.from(data['assignedEquipment']),
          )
        : null;
    List<AllotedLeavesModel> leaveInfo = [];
    List<AllotedAllowancesModel> allowancesInfo = [];
    if (data['hrInfo'] != null) {
      hrInfotable = HrInfoModel.fromMap(
        Map<String, dynamic>.from(data['hrInfo']),
      );
      // Check if leaveInfo exists within hrInfo
      if (data['hrInfo']['leaveInfo'] != null) {
        for (var leave in data['hrInfo']['leaveInfo']) {
          leaveInfo.add(
            AllotedLeavesModel.fromMap(Map<String, dynamic>.from(leave)),
          );
        }
      }
    }
    if (data['hrInfo'] != null) {
      hrInfotable = HrInfoModel.fromMap(
        Map<String, dynamic>.from(data['hrInfo']),
      );
      // Check if leaveInfo exists within hrInfo
      if (data['hrInfo']['allowanceInfo'] != null) {
        for (var allowance in data['hrInfo']['allowanceInfo']) {
          allowancesInfo.add(
            AllotedAllowancesModel.fromMap(
              Map<String, dynamic>.from(allowance),
            ),
          );
        }
      }
    }
    em = EmployeeModel(
      id: doc.id,
      attachments: attachments,
      contactNumber: data['contactNumber'] ?? "",
      designation: data['designation'] ?? "",
      idCardNumber: data['idCardNumber'] ?? "",
      name: data['name'] ?? "",
      emergencyName: data['emergencyName'] ?? '',
      emergencyContact: data['emergencyContact'] ?? '',
      profileUrl: data['profileUrl'] ?? '',
      otherCompany: data['otherCompany'] ?? "",
      status: data['status'] ?? "",
      globalEmployee: data['globalEmployee'] ?? false,
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userId: data['userId'] ?? "",
      email: data['email'] ?? "",
      branches:
          (data['branches'] as List?)?.map((e) => e.toString()).toList() ?? [],
      assignedVehicle: data['assignedVehicle'] ?? "",
      countryId: data['countryId'] ?? '',
      postalCode: data['postalCode'] ?? '',
      state: data['state'] ?? '',
      city: data['city'] ?? '',
      streetAddress1: data['streetAddress1'] ?? '',
      streetAddress2: data['streetAddress2'] ?? '',
      gender: data['gender'] ?? '',
      roleId: data['roleId'] ?? '',
      branchId: data['branchId'] ?? '',
      dob: (data['dob'] as Timestamp?)?.toDate() ?? DateTime.now(),
      equipments: equipments,
      assignedBuilding: data['assignedBuilding'] ?? "",
      assignedBuildingBlock: data['assignedBuildingBlock'] ?? "",
      assignedBuildingId: data['assignedBuildingId'] ?? "",
      assignedBuildingTime: data['assignedBuildingTime'] ?? Timestamp.now(),
      employeeId: data['employeeId'] ?? "",
      employeeCode: data['employeeCode'] ?? "",
      employeeNumber: data['employeeNumber'] ?? "",
      najahiBusinessID: data['najahiBusinessID'] ?? "",
      workingArea: data['workingArea'] ?? "",
      nationality: data['nationality'] ?? "",
      workingAreaId: data['workingAreaId'] ?? "",
      nationalityId: data['nationalityId'] ?? "",
      baasi: double.tryParse(data['baasi'].toString()) ?? -2,
      baasiEmpCon: double.tryParse(data['baasiEmpCon'].toString()) ?? 0,
      baasiEmprCon: double.tryParse(data['baasiEmprCon'].toString()) ?? 0,
      adminAccess: adminAcess,
      hrInfo: hrInfo,
      leaveInfo: leaveInfo,
      allowanceInfo: allowancesInfo,
      assignedEquipment: aEquipment,
      profileAccessKey: profileAccessKey,
    );
    return em;
  }

  static EmployeeModel? getBusinessList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return EmployeeModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }

  static EmployeeModel getEmptyEmployee() {
    return EmployeeModel(
      id: "",
      attachments: [],
      contactNumber: "",
      designation: "",
      idCardNumber: "",
      name: "",
      otherCompany: "",
      emergencyName: "",
      emergencyContact: "",
      streetAddress1: "",
      streetAddress2: "",
      city: "",
      state: "",
      postalCode: "",
      countryId: "",
      gender: "",
      dob: DateTime.now(),
      roleId: '',
      branchId: '',
      status: "",
      timestamp: Timestamp.now(),
      userId: "",
      equipments: [],
      email: "",
      globalEmployee: false,
      najahiBusinessID: "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "attachments": attachments,
      "contactNumber": contactNumber,
      "designation": designation,
      "idCardNumber": idCardNumber,
      "name": name,
      "emergencyName": emergencyName,
      "emergencyContact": emergencyContact,
      "gender": gender,
      "streetAddress1": streetAddress1,
      "streetAddress2": streetAddress2,
      "city": city,
      "state": state,
      "postalCode": postalCode,
      "countryId": countryId,
      "branchId": branchId,
      "roleId": roleId,
      "dob": dob,
      "profileUrl": profileUrl,
      "otherCompany": otherCompany,
      "status": status,
      "timestamp": timestamp,
      "userId": userId,
      "globalEmployee": globalEmployee,
      "equipments": equipments,
      "email": email,
      'branches': branches,
      "assignedVehicle": assignedVehicle,
      "assignedBuilding": assignedBuilding,
      "assignedBuildingBlock": assignedBuildingBlock,
      "assignedBuildingId": assignedBuildingId,
      "assignedBuildingTime": assignedBuildingTime,
      "adminAccess": adminAccess,
      "employeeCode": employeeNumber,
      "employeeNumber": employeeNumber,
      "najahiBusinessID": najahiBusinessID,
      "nationality": nationality,
      "nationalityId": nationalityId,
      "workingArea": workingArea,
      "workingAreaId": workingAreaId,
      "baasi": baasi,
      "baasiEmpCon": baasiEmpCon,
      "baasiEmprCon": baasiEmprCon,
      "hrInfo": hrInfo?.toMap(), // nested model
      //  "assignedEquipment": assignedEquipment?.toMap(),
      "leaveInfo": leaveInfo?.map((e) => e.toMapForAdd()).toList(),
      "allowanceInfo": allowanceInfo?.map((e) => e.toMapForAdd()).toList(),
      "profileAccessKey": profileAccessKey ?? [],
    };
  }
}
