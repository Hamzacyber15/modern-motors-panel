import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultAddressModel {
  String? id;
  String? companyName;
  String? companyNameAr;
  String? companyAddress;
  String? companyContact1;
  String? companyContact2;
  String? streetAddress;
  String? addressLine1;
  String? addressLine1Ar;
  String? addressLine2;
  String? addressLine2Ar;
  String? addressLine3;
  String? addressLine3Ar;
  String? website;
  String? city;
  String? email;
  String? address2Line1;
  String? address2Line1Ar;
  String? address2Line2;
  String? address2Line2Ar;
  String? address2Line3;
  String? address2Line3Ar;
  String? email2;
  String? branchLine1;
  String? branchLine2;
  String? status;

  DefaultAddressModel({
    this.id,
    this.companyName,
    this.companyNameAr,
    this.companyAddress,
    this.companyContact1,
    this.companyContact2,
    this.streetAddress,
    this.addressLine1,
    this.addressLine1Ar,
    this.addressLine2,
    this.addressLine2Ar,
    this.addressLine3,
    this.addressLine3Ar,
    this.website,
    this.city,
    this.email,
    this.address2Line1,
    this.address2Line1Ar,
    this.address2Line2,
    this.address2Line2Ar,
    this.address2Line3,
    this.address2Line3Ar,
    this.email2,
    this.branchLine1,
    this.branchLine2,
    this.status,
  });

  /// ✅ Convert to Map
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
      'email': email,
      'address2Line1': address2Line1,
      'address2Line1Ar': address2Line1Ar,
      'address2Line2': address2Line2,
      'address2Line2Ar': address2Line2Ar,
      'address2Line3': address2Line3,
      'address2Line3Ar': address2Line3Ar,
      'email2': email2,
      'branchLine1': branchLine1,
      'branchLine2': branchLine2,
      'status': status,
    };
  }

  /// ✅ From Firestore Map only (no docId)
  factory DefaultAddressModel.fromMap(Map<String, dynamic> map) {
    return DefaultAddressModel(
      companyAddress: map['companyAddress'] as String?,
      companyName: map['companyName'] as String?,
      companyNameAr: map['companyNameAr'] as String?,
      companyContact1: map['companyContact1'] as String?,
      companyContact2: map['companyContact2'] as String?,
      streetAddress: map['streetAddress'] as String?,
      addressLine1: map['addressLine1'] as String?,
      addressLine1Ar: map['addressLine1Ar'] as String?,
      addressLine2: map['addressLine2'] as String?,
      addressLine2Ar: map['addressLine2Ar'] as String?,
      addressLine3: map['addressLine3'] as String?,
      addressLine3Ar: map['addressLine3Ar'] as String?,
      website: map['website'] as String?,
      city: map['city'] as String?,
      email: map['email'] as String?,
      address2Line1: map['address2Line1'] as String?,
      address2Line1Ar: map['address2Line1Ar'] as String?,
      address2Line2: map['address2Line2'] as String?,
      address2Line2Ar: map['address2Line2Ar'] as String?,
      address2Line3: map['address2Line3'] as String?,
      address2Line3Ar: map['address2Line3Ar'] as String?,
      email2: map['email2'] as String?,
      branchLine1: map['branchLine1'] as String?,
      branchLine2: map['branchLine2'] as String?,
      status: map['status'] as String?,
    );
  }

  /// ✅ From Firestore DocumentSnapshot (includes docId)
  factory DefaultAddressModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DefaultAddressModel.fromMap(data).copyWith(id: doc.id);
  }

  /// ✅ CopyWith
  DefaultAddressModel copyWith({
    String? id,
    String? companyAddress,
    String? companyName,
    String? companyNameAr,
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
    String? email,
    String? address2Line1,
    String? address2Line1Ar,
    String? address2Line2,
    String? address2Line2Ar,
    String? address2Line3,
    String? address2Line3Ar,
    String? email2,
    String? branchLine1,
    String? branchLine2,
    String? status,
  }) {
    return DefaultAddressModel(
      id: id ?? this.id,
      companyAddress: companyAddress ?? this.companyAddress,
      companyName: companyName ?? this.companyName,
      companyNameAr: companyNameAr ?? this.companyNameAr,
      companyContact1: companyContact1 ?? this.companyContact1,
      companyContact2: companyContact2 ?? this.companyContact2,
      streetAddress: streetAddress ?? this.streetAddress,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine1Ar: addressLine1Ar ?? this.addressLine1Ar,
      addressLine2: addressLine2 ?? this.addressLine2,
      addressLine2Ar: addressLine2Ar ?? this.addressLine2Ar,
      addressLine3: addressLine3 ?? this.addressLine3,
      addressLine3Ar: addressLine3Ar ?? this.addressLine3Ar,
      website: website ?? this.website,
      city: city ?? this.city,
      email: email ?? this.email,
      address2Line1: address2Line1 ?? this.address2Line1,
      address2Line1Ar: address2Line1Ar ?? this.address2Line1Ar,
      address2Line2: address2Line2 ?? this.address2Line2,
      address2Line2Ar: address2Line2Ar ?? this.address2Line2Ar,
      address2Line3: address2Line3 ?? this.address2Line3,
      address2Line3Ar: address2Line3Ar ?? this.address2Line3Ar,
      email2: email2 ?? this.email2,
      branchLine1: branchLine1 ?? this.branchLine1,
      branchLine2: branchLine2 ?? this.branchLine2,
      status: status ?? this.status,
    );
  }
}
