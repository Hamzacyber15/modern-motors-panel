import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PublicProfileModel {
  String id;
  String businessEmail;
  String? businessId;
  Timestamp timestamp;
  String userEmail;
  String role;
  String status;
  String userName;
  String profileUrl;
  String? userMobile;
  String? employeeNumber;
  bool? terms;
  String? idCard;
  String? najahiBusinessID;
  String? branchId;

  PublicProfileModel(
    this.id,
    this.businessEmail,
    this.timestamp,
    this.userEmail,
    this.role,
    this.status,
    this.userName,
    this.profileUrl, {
    this.businessId,
    this.userMobile,
    this.employeeNumber,
    this.terms,
    this.idCard,
    this.najahiBusinessID,
    this.branchId,
  });
  factory PublicProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PublicProfileModel(
      doc.id,
      data['businessEmail'] ?? "",
      data['timestamp'] ?? Timestamp.now(),
      data['userEmail'] ?? "",
      data['userRole'] ?? "",
      data['status'] ?? "",
      data['userName'] ?? "",
      data['profileUrl'] ?? "",
      userMobile: data['userMobile'] ?? "",
      businessId: data['businessId'] ?? "",
      employeeNumber: data['employeeNumber'] ?? "",
      terms: data['terms'] ?? false,
      idCard: data['idCardNumber'] ?? "",
      najahiBusinessID: data['najahiBusinessID'] ?? "",
      branchId: data['branchId'] ?? "",
    );
  }

  static Future<PublicProfileModel?> getPublicProfile(String id) async {
    try {
      return FirebaseFirestore.instance
          .collection('profile')
          .doc(id)
          .get()
          .then((value) {
            if (value.exists) {
              return PublicProfileModel.fromFirestore(value);
            } else {
              return Future.value(null);
            }
          });
    } catch (_) {
      debugPrint("test_ profile error: $id");
      return Future.value(null);
    }
  }

  static Future<PublicProfileModel?> getmmPublicProfile(String id) async {
    try {
      return FirebaseFirestore.instance
          .collection('mmProfile')
          .doc(id)
          .get()
          .then((value) {
            if (value.exists) {
              return PublicProfileModel.fromFirestore(value);
            } else {
              return Future.value(null);
            }
          });
    } catch (_) {
      debugPrint("test_ profile error: $id");
      return Future.value(null);
    }
  }

  static PublicProfileModel getEmptyProfile() {
    return PublicProfileModel("", "", Timestamp.now(), "", "", "", "", "");
  }
}
