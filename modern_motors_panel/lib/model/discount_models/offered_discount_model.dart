import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/constants.dart';

class OfferedDiscountModel {
  String id;
  double amount;
  String businessId;
  String discountId;
  double discountPercentage;
  String invoice;
  String status;
  DateTime startDate;
  DateTime timeStamp;
  DateTime validity;
  double balance;
  String discountBy;
  String title;
  String discountType;
  double otp;
  OfferedDiscountModel({
    required this.id,
    required this.amount,
    required this.businessId,
    required this.discountId,
    required this.discountPercentage,
    required this.invoice,
    required this.status,
    required this.startDate,
    required this.timeStamp,
    required this.validity,
    required this.balance,
    required this.discountBy,
    required this.title,
    required this.discountType,
    required this.otp,
  });
  factory OfferedDiscountModel.fromMap(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    OfferedDiscountModel lp = OfferedDiscountModel(
      id: doc.id,
      amount: double.tryParse(data!['amount'].toString()) ?? 0,
      businessId: data['businessId'] ?? "",
      discountPercentage:
          double.tryParse(data['discountPercentage'].toString()) ?? 0,
      discountId: data['discountId'] ?? "",
      invoice: data['invoice'] ?? "",
      status: data['status'] ?? "",
      startDate:
          Constants.convertToDateTime(doc['startDate']) ?? DateTime.now(),
      timeStamp:
          Constants.convertToDateTime(doc['timeStamp']) ??
          DateTime.now(), //doc['timeStamp'],
      validity:
          Constants.convertToDateTime(doc['validity']) ??
          DateTime.now(), //doc['validity'],
      balance: double.tryParse(data['balance'].toString()) ?? 0,
      discountBy: data['discountBy'] ?? "",
      title: data['title'] ?? "",
      discountType: data['discountType'] ?? "",
      otp: double.tryParse(data['otp'].toString()) ?? 0,
    );
    return lp;
  }

  static OfferedDiscountModel? getOfferedDiscount(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return OfferedDiscountModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }
}
