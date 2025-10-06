import 'package:cloud_firestore/cloud_firestore.dart';

class LeasePackageModel {
  String id;
  String duration;
  String durationArabic;
  double price;
  bool employee;
  String employeeCategory;
  LeasePackageModel({
    required this.id,
    required this.duration,
    required this.durationArabic,
    required this.price,
    required this.employee,
    required this.employeeCategory,
  });
  factory LeasePackageModel.fromMap(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    LeasePackageModel lp = LeasePackageModel(
      id: doc.id,
      duration: data!['duration'] ?? "",
      durationArabic: data['durationArabic'] ?? "",
      price: double.tryParse(data['price'].toString()) ?? 0,
      employee: data['employee'] ?? false,
      employeeCategory: data['employeeCategory'] ?? "",
    );
    return lp;
  }

  static LeasePackageModel? getLeasePackageList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return LeasePackageModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }
}
