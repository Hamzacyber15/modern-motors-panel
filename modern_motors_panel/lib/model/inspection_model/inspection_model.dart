import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/business_models/business_area_model.dart';
import 'package:modern_motors_panel/model/edit_request_model.dart';
import 'package:modern_motors_panel/model/invoices/invoice_model.dart';

class InspectionModel {
  String id;
  String chasisNumber;
  String consigneeId;
  String consigneeName;
  String customDeclarationNumber;
  String generatedBy;
  String generatedByProfileId;
  String status;
  Timestamp timestamp;
  String truckCode;
  String truckCountry;
  String truckId;
  String truckNumber;
  String truckSize;
  String type;
  String packageId;
  Timestamp timeClosed;
  String invoice;
  String closedByUser;
  String closedUser;
  String gatePassRef;
  String? origin;
  double amount;
  String? port;
  List<BusinessAreaModel>? businessAreas;
  Timestamp? requestTime;
  Timestamp? approvedAt;
  String? approvedBy;
  Timestamp? arrivedAt;
  String? arrivedBy;
  List<String>? url;
  String? entryType;
  String? trailerNumber;
  Timestamp? cancelAt;
  String? cancelBy;
  Timestamp? exitAt;
  Timestamp? rejectAt;
  String? rejectBy;
  String? exitBy;
  bool? editRequested;
  Timestamp? expirationDate;
  List<InvoiceModel>? transactions;
  InspectionModel({
    required this.id,
    required this.chasisNumber,
    required this.consigneeId,
    required this.consigneeName,
    required this.customDeclarationNumber,
    required this.generatedBy,
    required this.generatedByProfileId,
    required this.status,
    required this.timestamp,
    required this.truckCode,
    required this.truckCountry,
    required this.truckId,
    required this.truckNumber,
    required this.truckSize,
    required this.type,
    required this.packageId,
    required this.timeClosed,
    required this.invoice,
    required this.closedByUser,
    required this.closedUser,
    required this.gatePassRef,
    required this.amount,
    this.origin,
    this.port,
    this.businessAreas,
    this.requestTime,
    this.url,
    this.entryType,
    this.approvedAt,
    this.approvedBy,
    this.arrivedAt,
    this.arrivedBy,
    this.trailerNumber,
    this.cancelAt,
    this.cancelBy,
    this.exitAt,
    this.exitBy,
    this.rejectAt,
    this.rejectBy,
    this.editRequested,
    this.expirationDate,
    this.transactions,
  });
  factory InspectionModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    List<dynamic> bArea = data!['businessAreas'] ?? [];
    List<BusinessAreaModel> businessAreas = [];
    for (var element in bArea) {
      //if (element['id']) {
      businessAreas.add(
        BusinessAreaModel(
          title: element['storage'],
          value: element['title'],
          id: element['id'],
        ),
      );
      // }
    }
    List<dynamic> uList = data['url'] ?? [];
    List<String> url = [];
    for (var element in uList) {
      url.add(element);
    }
    // List<dynamic> editRequestsList = data['editRequests'] ?? [];
    // List<EditRequestModel> editRequests = editRequestsList
    //     .map(
    //         (item) => EditRequestModel.fromMap(Map<String, dynamic>.from(item)))
    //     .toList();
    List<EditRequestModel> editRequests = [];
    if (data['editRequests'] != null) {
      if (data['editRequests'] is List) {
        // Proper list case
        editRequests = (data['editRequests'] as List)
            .whereType<Map<String, dynamic>>() // Ensure each item is a Map
            .map((item) => EditRequestModel.fromMap(item))
            .toList();
      } else if (data['editRequests'] is Map) {
        // Handle case where it might be a map (incorrect structure)
        debugPrint('Warning: editRequests is a Map, expected List');
        editRequests = [EditRequestModel.fromMap(data['editRequests'])];
      }
    }

    // Handle URL list conversion
    List<String> urlList = [];
    if (data['url'] != null) {
      if (data['url'] is List) {
        urlList = List<String>.from(data['url'].map((item) => item.toString()));
      } else if (data['url'] is String) {
        urlList = [data['url']];
      }
    }
    List<dynamic> leaseTransactionList = data['transactions'] ?? [];
    List<InvoiceModel> lT = [];
    for (var element in leaseTransactionList) {
      lT.add(
        InvoiceModel(
          ref: element['ref'] ?? "",
          id: doc.id,
          amount: double.tryParse(element!['amount'].toString()) ?? 0,
          businessId: element['businessId'] ?? "",
          invoice: element['invoice'] ?? "",
          orderId: element['orderId'] ?? "",
          timeStamp: element['timeStamp'] ?? Timestamp.now(),
          type: element['type'] ?? "",
          silalInvoice: element['silalInvoice'] ?? "",
          handlingFee: double.tryParse(element['handlingFee'].toString()) ?? 0,
          gateMoney: double.tryParse(element['gateMoney'].toString()) ?? 0,
        ),
      );
    }
    InspectionModel im = InspectionModel(
      id: doc.id,
      chasisNumber: data['chasisNumber'] ?? "",
      consigneeId: data['consigneeId'] ?? "",
      consigneeName: data['consigneeName'] ?? "",
      customDeclarationNumber: data['customDeclarationNumber'] ?? "",
      generatedBy: data['generatedBy'] ?? "",
      generatedByProfileId: data['generatedByProfileId'] ?? "",
      status: data['status'] ?? "",
      timestamp: data['timestamp'] ?? "",
      truckCode: data['truckCode'] ?? "",
      truckCountry: data['truckCountry'] ?? "",
      truckId: data['truckId'] ?? "",
      truckNumber: data['truckNumber'] ?? "",
      truckSize: data['truckSize'] ?? "",
      type: data['type'] ?? "",
      packageId: data['packageId'] ?? "",
      timeClosed: data['timeClosed'] ?? Timestamp.now(),
      closedUser: data['closedUser'] ?? "",
      closedByUser: data['closedByUser'] ?? "",
      invoice: data['invoiceId'] ?? "",
      gatePassRef: data['gatePassRef'] ?? "",
      amount: double.tryParse(data['amount'].toString()) ?? 0,
      origin: data['origin'] ?? "",
      port: data['port'] ?? "",
      businessAreas: businessAreas,
      requestTime: data['requestTime'] ?? Timestamp.now(),
      approvedAt: data['approvedAt'],
      arrivedAt: data['arrivedAt'],
      approvedBy: data['approvedBy'] ?? "",
      arrivedBy: data['approvedBy'] ?? "",
      entryType: data['entryType'] ?? "",
      trailerNumber: data['trailerNumber'] ?? "",
      url: urlList,
      cancelAt: data['cancelAt'],
      cancelBy: data['cancelBy'] ?? "",
      exitAt: data['exitAt'],
      exitBy: data['exitBy'] ?? "",
      rejectAt: data['rejectAt'],
      rejectBy: data['rejectBy'] ?? "",
      editRequested: data['editRequested'],
      transactions: lT,
      //editRequests: editRequests,
    );

    return im;
  }
  static InspectionModel? getInspections(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return InspectionModel.fromMap(d);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
