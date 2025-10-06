import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? id;
  String customerName;
  String bankName;
  String customerType;
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

  // List<Manager>? managers;

  Timestamp? timestamp;

  CustomerModel({
    this.id,
    required this.customerName,
    this.imageUrl,
    this.crNumber,
    required this.contactNumber,
    required this.customerType,
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
    required this.status,
    required this.addedBy,
    required this.codeNumber,
  });

  Map<String, dynamic> toIndividualMap() {
    return {
      'customerName': customerName,
      'customerType': customerType,
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
      // 'timestamp': timestamp != null ? Timestamp.now() : null,
    };
  }

  Map<String, dynamic> toBusinessMap() {
    return {
      'customerName': customerName,
      'businessName': businessName,
      'customerType': customerType,
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
    };
  }

  factory CustomerModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return CustomerModel(
      id: doc.id,
      customerName: map['customerName'] ?? '',
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
      customerType: map['customerType'] ?? '',
      addedBy: map['addedBy'] ?? '',
      notes: map['notes'] ?? '',
      streetAddress2: map['streetAddress2'] ?? '',
      businessName: map['businessName'] ?? '',
      files: map['files'] ?? '',
      vatNumber: map['vatNumber'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      status: map['status'] ?? '',
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
