import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/hr_models/allowance_model.dart';
import 'package:modern_motors_panel/model/hr_models/leaves_model.dart';

class DesignationModel {
  String docId, designation, arabicDesignation, status, addedby;
  double salary, contractedSalary;
  Timestamp timestamp;
  List<LeavesModel> leavesTypeList;
  List<AllowanceModel>? allowances;

  DesignationModel({
    required this.designation,
    required this.docId,
    required this.salary,
    required this.contractedSalary,
    required this.status,
    required this.arabicDesignation,
    required this.leavesTypeList,
    required this.timestamp,
    required this.addedby,
    this.allowances,
  });

  factory DesignationModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    List<LeavesModel> leaves = [];
    if (data['leavesTypeList'] != null && data['leavesTypeList'] is List) {
      leaves = (data['leavesTypeList'] as List)
          .whereType<Map<String, dynamic>>()
          .map((map) => LeavesModel.fromMap(map))
          .toList();
    }
    List<AllowanceModel> allowances = [];
    if (data['allowances'] != null && data['allowances'] is List) {
      allowances = (data['allowances'] as List)
          .whereType<Map<String, dynamic>>()
          .map((map) => AllowanceModel.fromMap(map))
          .toList();
    }

    return DesignationModel(
      docId: snapshot.id,
      designation: data['designation'] ?? '',
      arabicDesignation: data['arabicDesignation'] ?? '',
      contractedSalary: data['contractedSalary'] ?? 0.0,
      salary: data['salary'] ?? 0.0,
      status: data['status'] ?? '',
      leavesTypeList: leaves,
      timestamp: data['timestamp'] ?? Timestamp.now(),
      addedby: data['addedby'] ?? "",
      allowances: allowances,
    );
  }
}
