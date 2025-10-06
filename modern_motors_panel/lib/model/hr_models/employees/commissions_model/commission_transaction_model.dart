import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommissionTransactionModel {
  String id;
  double commission;
  String employeeId;
  String orderId;
  Timestamp timestamp;
  String type;
  String status;
  String notes;
  String packageId;
  String invoice;
  CommissionTransactionModel({
    required this.id,
    required this.commission,
    required this.employeeId,
    required this.orderId,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.notes,
    required this.packageId,
    required this.invoice,
  });

  factory CommissionTransactionModel.fromMap(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    CommissionTransactionModel cm = CommissionTransactionModel(
      id: doc.id,
      commission: double.tryParse(data!['commission'].toString()) ?? 0,
      employeeId: data['employeeId'] ?? "",
      orderId: data['orderId'] ?? "",
      timestamp: data['timestamp'] ?? Timestamp.now(),
      type: data['type'] ?? "",
      notes: data['notes'] ?? "",
      status: data['status'] ?? "",
      packageId: data['packageId'] ?? "",
      invoice: data['invoice'] ?? "",
    );
    return cm;
  }

  static CommissionTransactionModel? getCommissionList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return CommissionTransactionModel.fromMap(d);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static CommissionTransactionModel getEmptyCommissionModel() {
    return CommissionTransactionModel(
      id: "",
      commission: 0,
      employeeId: "",
      orderId: "",
      timestamp: Timestamp.now(),
      type: "",
      status: "",
      notes: "",
      packageId: "",
      invoice: "",
    );
  }
}
