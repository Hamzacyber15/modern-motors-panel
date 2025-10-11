import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:modern_motors_panel/model/contact_model.dart';

class SupplierModel {
  String? id;
  String supplierName;
  String bankName;
  String supplierType;
  String? businessName;
  String telePhoneNumber;
  String streetAddress1;
  String streetAddress2;
  String city;
  String state;
  String postalCode;
  String countryId;
  String? vatNumber;
  String codeNumber;
  String accountNumber;
  String currencyId;
  String notes;
  String? files;
  String? imageUrl;
  String? crNumber;
  String contactNumber;
  String emailAddress;
  // String? whatsappNumber;
  String status;
  String addedBy;
  List<ContactModel> contacts;

  // List<Manager>? managers;

  Timestamp? timestamp;

  SupplierModel({
    this.id,
    required this.supplierName,
    this.imageUrl,
    this.crNumber,
    required this.contactNumber,
    required this.supplierType,
    this.businessName,
    required this.telePhoneNumber,
    required this.streetAddress1,
    required this.streetAddress2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.countryId,
    this.vatNumber,
    required this.accountNumber,
    required this.currencyId,
    required this.emailAddress,
    required this.bankName,
    required this.notes,
    this.files,
    // this.whatsappNumber,
    // this.managers,
    this.timestamp,
    this.contacts = const [],
    required this.status,
    required this.addedBy,
    required this.codeNumber,
  });

  Map<String, dynamic> toIndividualMap() {
    return {
      'supplierName': supplierName,
      'supplierType': supplierType,
      'telePhoneNumber': telePhoneNumber,
      'contactNumber': contactNumber,
      'imageUrl': imageUrl,
      'streetAddress1': streetAddress1,
      'streetAddress2': streetAddress2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'countryId': countryId,
      'codeNumber': codeNumber,
      'currencyId': currencyId,
      'emailAddress': emailAddress,
      'bankName': bankName,
      'notes': notes,
      'accountNumber': accountNumber,
      'vatNumber': vatNumber,
      'status': status,
      'files': files,
      'contacts': contacts.map((c) => c.toMap()).toList(),
      // 'timestamp': timestamp != null ? Timestamp.now() : null,
    };
  }

  Map<String, dynamic> toBusinessMap() {
    return {
      'supplierName': supplierName,
      'businessName': businessName,
      'supplierType': supplierType,
      'telePhoneNumber': telePhoneNumber,
      'contactNumber': contactNumber,
      'imageUrl': imageUrl,
      'streetAddress1': streetAddress1,
      'streetAddress2': streetAddress2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'countryId': countryId,
      'codeNumber': codeNumber,
      'currencyId': currencyId,
      'emailAddress': emailAddress,
      'bankName': bankName,
      'notes': notes,
      'accountNumber': accountNumber,
      'vatNumber': vatNumber,
      'status': status,
      'files': files,
      'contacts': contacts.map((c) => c.toMap()).toList(),
    };
  }

  factory SupplierModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    final List contactList = map['contacts'] ?? [];
    return SupplierModel(
      id: doc.id,
      supplierName: map['supplierName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      crNumber: map['crNumber'] ?? '',
      emailAddress: map['emailAddress'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      currencyId: map['currencyId'] ?? '',
      codeNumber: map['codeNumber'] ?? '',
      countryId: map['countryId'] ?? '',
      postalCode: map['postalCode'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      streetAddress1: map['streetAddress1'] ?? '',
      telePhoneNumber: map['telePhoneNumber'] ?? '',
      supplierType: map['supplierType'] ?? '',
      addedBy: map['addedBy'] ?? '',
      notes: map['notes'] ?? '',
      streetAddress2: map['streetAddress2'] ?? '',
      businessName: map['businessName'] ?? '',
      files: map['files'] ?? '',
      vatNumber: map['vatNumber'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      status: map['status'] ?? '',
      contacts: contactList
          .map((e) => ContactModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      contactNumber: map['contactNumber'] ?? '',
    );
  }
}

class Manager {
  final String name;
  final String number;
  final String nationality;

  Manager({
    required this.name,
    required this.number,
    required this.nationality,
  });

  Map<String, dynamic> toMap() {
    return {
      'managerName': name,
      'managerNumber': number,
      'managerNationality': nationality,
    };
  }

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      name: map['managerName'] ?? '',
      number: map['managerNumber'] ?? '',
      nationality: map['managerNationality'] ?? '',
    );
  }
}
