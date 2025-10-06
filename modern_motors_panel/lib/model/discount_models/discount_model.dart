import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscountModel {
  String id;
  double daysValidity;
  double discount;
  double higherRange;
  double lowerRange;
  String status;
  Timestamp timestamp;
  String title;
  String discountType;

  DiscountModel({
    required this.id,
    required this.daysValidity,
    required this.discount,
    required this.higherRange,
    required this.lowerRange,
    required this.status,
    required this.title,
    required this.timestamp,
    required this.discountType,
  });

  factory DiscountModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    DiscountModel dm = DiscountModel(
      id: doc.id,
      daysValidity: double.tryParse(data!['daysValidity'].toString()) ?? 0,
      discount: double.tryParse(data['discount'].toString()) ?? 0,
      higherRange: double.tryParse(data['higherRange'].toString()) ?? 0,
      lowerRange: double.tryParse(data['lowerRange'].toString()) ?? 0,
      status: data['status'] ?? "",
      title: data['title'] ?? "",
      timestamp: data['timestamp'] ?? Timestamp.now(),
      discountType: data['discountType'] ?? "",
    );
    return dm;
  }

  static DiscountModel? getDiscountsList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return DiscountModel.fromMap(d);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static DiscountModel getDiscount() {
    return DiscountModel(
      id: "",
      daysValidity: 0,
      discount: 0,
      higherRange: 0,
      lowerRange: 0,
      timestamp: Timestamp.now(),
      status: "",
      discountType: "",
      title: "",
    );
  }
}
