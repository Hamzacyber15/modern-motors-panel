import 'package:cloud_firestore/cloud_firestore.dart';

class ShopsModel {
  String id;
  String area;
  Map<String, dynamic> location;
  String name;
  String status;
  String block;
  String building;
  dynamic lat;
  dynamic lng;
  ShopsModel({
    required this.id,
    required this.area,
    required this.location,
    required this.name,
    required this.status,
    required this.block,
    required this.building,
    this.lat,
    this.lng,
  });
  factory ShopsModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    Map<String, dynamic> d = {};
    dynamic location = data!['location'] ?? d;
    ShopsModel am = ShopsModel(
      id: doc.id,
      area: data['area'] ?? "",
      location: location,
      name: data['name'] ?? "",
      status: data['status'] ?? "",
      block: data['block'] ?? "",
      lat: location['lat'] ?? 0,
      lng: location['lng'] ?? 0,
      building: location['building'] ?? "",
    );
    return am;
  }

  static ShopsModel? getShops(DocumentSnapshot<Map<String, dynamic>> d) {
    try {
      return ShopsModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }

  static ShopsModel getEmptyShops() {
    return ShopsModel(
      id: "",
      area: "",
      location: {},
      name: "",
      status: "",
      block: "",
      building: "",
    );
  }
}
