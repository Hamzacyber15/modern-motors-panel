import 'package:cloud_firestore/cloud_firestore.dart';

class LeavesModel {
  String? docId, arabicLeaveType, leaveType, status, addedby;
  double? noOfLeaves;
  Timestamp? timestamp;

  LeavesModel({
    required this.leaveType,
    required this.arabicLeaveType,
    required this.addedby,
    this.docId,
    required this.noOfLeaves,
    this.status,
    this.timestamp,
  });

  factory LeavesModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return LeavesModel(
      docId: data['docId'] ?? "",
      leaveType: data['leaveType'] ?? '',
      arabicLeaveType: data['arabicLeaveType'] ?? '',
      noOfLeaves: data['noOfLeaves'] ?? 0.0,
      status: data['status'] ?? '',
      addedby: data['addedby'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leaveType': leaveType,
      'arabicLeaveType': arabicLeaveType,
      'noOfLeaves': noOfLeaves,
      'docId': docId,
    };
  }

  factory LeavesModel.fromMap(Map<String, dynamic> map) {
    return LeavesModel(
      leaveType: map['leaveType'] ?? '',
      arabicLeaveType: map['arabicLeaveType'] ?? '',
      noOfLeaves: map['noOfLeaves'] ?? 0,
      docId: map['docId'] ?? "",
      addedby: map['addedby'] ?? '',
    );
  }
}
