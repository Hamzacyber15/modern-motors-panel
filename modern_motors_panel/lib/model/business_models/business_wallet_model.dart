import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessWalletModel {
  String id;
  double balance;
  Timestamp updatedAt;
  String businessId;
  String businessName;
  BusinessWalletModel({
    required this.id,
    required this.balance,
    required this.updatedAt,
    required this.businessId,
    required this.businessName,
  });
  factory BusinessWalletModel.fromMap(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    BusinessWalletModel bw = BusinessWalletModel(
      id: doc.id,
      balance: double.tryParse(data!['balance'].toString()) ?? 0,
      updatedAt: data['updatedAt'] ?? Timestamp.now,
      businessId: doc.id,
      businessName: "",
    );

    return bw;
  }
  static BusinessWalletModel? getBusinessData(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return BusinessWalletModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }
}
