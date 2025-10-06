import 'package:cloud_firestore/cloud_firestore.dart';

class EstimationTemplatePreviewModel {
  final String? id; // Firestore doc id
  final String? type; // "estimation"
  final Timestamp? timestamp;
  final String? headerLogo;

  final CompanyDetails companyDetails;
  final BankDetails bank1Details;
  final BankDetails bank2Details;

  EstimationTemplatePreviewModel({
    this.id,
    this.type,
    this.timestamp,
    this.headerLogo,
    required this.companyDetails,
    required this.bank1Details,
    required this.bank2Details,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'timestamp': timestamp,
      'headerLogo': headerLogo,
      'companyDetails': companyDetails.toMap(),
      'bank1Details': bank1Details.toMap(),
      'bank2Details': bank2Details.toMap(),
    };
  }

  factory EstimationTemplatePreviewModel.fromDoc(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});

    Map<String, dynamic> safeMap(dynamic v) =>
        (v is Map<String, dynamic>) ? v : <String, dynamic>{};

    return EstimationTemplatePreviewModel(
      id: doc.id,
      type: data['type'] as String?,
      timestamp: data['timestamp'] is Timestamp
          ? data['timestamp'] as Timestamp
          : null,
      headerLogo: data['headerLogo'] as String?,
      companyDetails: CompanyDetails.fromMap(safeMap(data['companyDetails'])),
      bank1Details: BankDetails.fromMap(safeMap(data['bank1Details'])),
      bank2Details: BankDetails.fromMap(safeMap(data['bank2Details'])),
    );
  }

  EstimationTemplatePreviewModel copyWith({
    String? id,
    String? type,
    Timestamp? timestamp,
    String? headerLogo,
    CompanyDetails? companyDetails,
    BankDetails? bank1Details,
    BankDetails? bank2Details,
  }) {
    return EstimationTemplatePreviewModel(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      headerLogo: headerLogo ?? this.headerLogo,
      companyDetails: companyDetails ?? this.companyDetails,
      bank1Details: bank1Details ?? this.bank1Details,
      bank2Details: bank2Details ?? this.bank2Details,
    );
  }
}

class CompanyDetails {
  final String? companyName;
  final String? companyNameAr;
  final String? taxId;
  final String? vatNo;
  final String? companyAddress;
  final String? companyAddressAr;
  final String? streetAddress;
  final String? city;
  final String? companyContact1;
  final String? companyContact2;
  final String? addressLine1;
  final String? addressLine3;
  final String? addressLine1Ar;
  final String? addressLine2Ar;
  final String? addressLine3Ar;
  final String? addressLine2;
  final String? website;
  final String? email;
  final String? address2Line1;
  final String? address2Line1Ar;
  final String? address2Line2;
  final String? address2Line2Ar;
  final String? address2Line3;
  final String? address2Line3Ar;
  final String? email2;
  final String? vinNumber;
  final String? taxCardNumber;
  final String? faxNumber;
  final String? crNumber;
  final String? branchLine1;
  final String? branchLine2;

  CompanyDetails({
    this.companyName,
    this.companyNameAr,
    this.companyAddress,
    this.companyAddressAr,
    this.companyContact1,
    this.companyContact2,
    this.streetAddress,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.addressLine1Ar,
    this.addressLine2Ar,
    this.addressLine3Ar,
    this.website,
    this.city,
    this.taxId,
    this.vatNo,
    this.email,
    this.address2Line1,
    this.address2Line1Ar,
    this.address2Line2,
    this.address2Line2Ar,
    this.address2Line3,
    this.address2Line3Ar,
    this.email2,
    this.vinNumber,
    this.crNumber,
    this.taxCardNumber,
    this.faxNumber,
    this.branchLine1,
    this.branchLine2,
  });

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'companyNameAr': companyNameAr,
      'companyAddress': companyAddress,
      'companyContact1': companyContact1,
      'companyContact2': companyContact2,
      'streetAddress': streetAddress,
      'addressLine1': addressLine1,
      'addressLine1Ar': addressLine1Ar,
      'addressLine2': addressLine2,
      'addressLine2Ar': addressLine2Ar,
      'addressLine3': addressLine3,
      'addressLine3Ar': addressLine3Ar,
      'website': website,
      'city': city,
      'taxId': taxId,
      'vatNo': vatNo,
      'email': email,
      'crNumber': crNumber,
      'address2Line1': address2Line1,
      'address2Line1Ar': address2Line1Ar,
      'address2Line2': address2Line2,
      'address2Line2Ar': address2Line2Ar,
      'address2Line3': address2Line3,
      'address2Line3Ar': address2Line3Ar,
      'email2': email2,
      'vinNumber': vinNumber,
      'taxCardNumber': taxCardNumber,
      'faxNumber': faxNumber,
      'branchLine1': branchLine1,
      'branchLine2': branchLine2,
    };
  }

  factory CompanyDetails.fromMap(Map<String, dynamic> map) {
    return CompanyDetails(
      companyName: map['companyName'] as String?,
      companyNameAr: map['companyNameAr'] as String?,
      companyAddress: map['companyAddress'] as String?,
      companyContact1: map['companyContact1'] as String?,
      companyContact2: map['companyContact2'] as String?,
      addressLine1: map['addressLine1'] as String?,
      addressLine2: map['addressLine2'] as String?,
      addressLine3: map['addressLine3'] as String?,
      addressLine1Ar: map['addressLine1Ar'] as String?,
      addressLine2Ar: map['addressLine2Ar'] as String?,
      addressLine3Ar: map['addressLine3Ar'] as String?,
      website: map['website'] as String?,
      city: map['city'] as String?,
      streetAddress: map['streetAddress'] as String?,
      taxId: map['taxId'] as String?,
      crNumber: map['crNumber'] as String?,
      vatNo: map['vatNo'] as String?,
      email: map['email'] as String?,
      address2Line1: map['address2Line1'] as String?,
      address2Line1Ar: map['address2Line1Ar'] as String?,
      address2Line2: map['address2Line2'] as String?,
      address2Line2Ar: map['address2Line2Ar'] as String?,
      address2Line3: map['address2Line3'] as String?,
      address2Line3Ar: map['address2Line3Ar'] as String?,
      email2: map['email2'] as String?,
      vinNumber: map['vinNumber'] as String?,
      taxCardNumber: map['taxCardNumber'] as String?,
      faxNumber: map['faxNumber'] as String?,
      branchLine1: map['branchLine1'] as String?,
      branchLine2: map['branchLine2'] as String?,
    );
  }

  CompanyDetails copyWith({
    String? companyName,
    String? companyNameAr,
    String? companyAddress,
    String? companyContact1,
    String? companyContact2,
    String? streetAddress,
    String? addressLine1,
    String? addressLine1Ar,
    String? addressLine2,
    String? addressLine2Ar,
    String? addressLine3,
    String? addressLine3Ar,
    String? website,
    String? city,
    String? taxId,
    String? vatNo,
    String? email,
    String? crNumber,
    String? address2Line1,
    String? address2Line1Ar,
    String? address2Line2,
    String? address2Line2Ar,
    String? address2Line3,
    String? address2Line3Ar,
    String? email2,
    String? vinNumber,
    String? taxCardNumber,
    String? faxNumber,
    String? branchLine1,
    String? branchLine2,
  }) {
    return CompanyDetails(
      companyName: companyName ?? this.companyName,
      companyNameAr: companyNameAr ?? this.companyNameAr,
      companyAddress: companyAddress ?? this.companyAddress,
      companyContact1: companyContact1 ?? this.companyContact1,
      companyContact2: companyContact2 ?? this.companyContact2,
      streetAddress: streetAddress ?? this.streetAddress,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      addressLine3: addressLine3 ?? this.addressLine3,
      addressLine1Ar: addressLine1Ar ?? this.addressLine1Ar,
      addressLine2Ar: addressLine2Ar ?? this.addressLine2Ar,
      addressLine3Ar: addressLine3Ar ?? this.addressLine3Ar,
      address2Line1: address2Line1 ?? this.address2Line1,
      address2Line2: address2Line2 ?? this.address2Line2,
      address2Line3: address2Line3 ?? this.address2Line3,
      address2Line1Ar: address2Line1Ar ?? this.address2Line1Ar,
      address2Line2Ar: address2Line2Ar ?? this.address2Line2Ar,
      address2Line3Ar: address2Line3Ar ?? this.address2Line3Ar,
      website: website ?? this.website,
      city: city ?? this.city,
      taxId: taxId ?? this.taxId,
      crNumber: crNumber ?? this.crNumber,
      vatNo: vatNo ?? this.vatNo,
      email: email ?? this.email,
      email2: email2 ?? this.email2,
      vinNumber: vinNumber ?? this.vinNumber,
      taxCardNumber: taxCardNumber ?? this.taxCardNumber,
      faxNumber: faxNumber ?? this.faxNumber,
      branchLine1: branchLine1 ?? this.branchLine1,
      branchLine2: branchLine2 ?? this.branchLine2,
    );
  }
}

class BankDetails {
  final String? id; // 🔹 Firestore docId
  final String? bankName;
  final String? accountNumber;
  final String? ibanNumber;
  final String? swiftNumber;
  final String? status;

  BankDetails({
    this.id,
    this.bankName,
    this.accountNumber,
    this.ibanNumber,
    this.swiftNumber,
    this.status,
  });

  /// ✅ Convert to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ibanNumber': ibanNumber,
      'swiftNumber': swiftNumber,
      'status': status,
    };
  }

  /// ✅ From Map (Firestore data only, without docId)
  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      bankName: map['bankName'] as String?,
      accountNumber: map['accountNumber'] as String?,
      ibanNumber: map['ibanNumber'] as String?,
      swiftNumber: map['swiftNumber'] as String?,
      status: map['status'] as String?,
    );
  }

  /// ✅ From Firestore DocumentSnapshot (with docId)
  factory BankDetails.fromDoc(dynamic doc) {
    final map = doc.data() as Map<String, dynamic>;
    return BankDetails.fromMap(map).copyWith(id: doc.id);
  }

  /// ✅ CopyWith method
  BankDetails copyWith({
    String? id,
    String? bankName,
    String? accountNumber,
    String? ibanNumber,
    String? swiftNumber,
    String? status,
  }) {
    return BankDetails(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ibanNumber: ibanNumber ?? this.ibanNumber,
      swiftNumber: swiftNumber ?? this.swiftNumber,
      status: status ?? this.status,
    );
  }
}
