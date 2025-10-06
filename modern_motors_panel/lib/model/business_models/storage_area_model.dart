import 'package:cloud_firestore/cloud_firestore.dart';

class StorageAreaModel {
  String id;
  String? block;
  String area;
  String name;
  String status;
  StorageAreaModel({
    required this.id,
    this.block,
    required this.area,
    required this.name,
    required this.status,
  });
  factory StorageAreaModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    // dynamic l = data!['location'] ?? "";
    // double lat = double.tryParse(l['lat']) ?? 0;
    // double lng = double.tryParse(l['lng']) ?? 0;
    StorageAreaModel sm = StorageAreaModel(
      id: "",
      block: "",
      area: "",
      name: "",
      status: "",
    );
    sm = StorageAreaModel(
      id: doc.id,
      block: data!['block'] ?? "",
      area: data['area'] ?? "",
      name: data['name'] ?? "",
      status: data['status'] ?? "",
    );
    return sm;
  }
  static StorageAreaModel? getStorageList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return StorageAreaModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }
}
