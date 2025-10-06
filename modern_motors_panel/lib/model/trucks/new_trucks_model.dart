import 'package:cloud_firestore/cloud_firestore.dart';

class NewTruckModel {
  String id;
  String addedBy;
  String chasisNumber;
  String plateOrginCountry;
  Timestamp timestamp;
  String truckCode;
  String truckNumber;
  String truckSize;
  String truckSizeId;
  String url;
  String packageId;
  String status;
  final String? ownBy;
  final String? ownById;
  NewTruckModel({
    required this.id,
    required this.addedBy,
    required this.chasisNumber,
    required this.plateOrginCountry,
    required this.timestamp,
    required this.truckCode,
    required this.truckNumber,
    required this.truckSize,
    required this.truckSizeId,
    required this.packageId,
    required this.url,
    required this.status,
    this.ownBy,
    this.ownById,
  });
  factory NewTruckModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    NewTruckModel tm = NewTruckModel(
      id: doc.id,
      addedBy: data!['addedBy'] ?? "",
      chasisNumber: data['chasisNumber'] ?? "",
      plateOrginCountry: data['plateOrginCountry'] ?? "",
      timestamp: data['timestamp'] ?? Timestamp.now(),
      truckCode: data['truckCode'] ?? "",
      truckNumber: data['truckNumber'] ?? "",
      truckSize: data['truckSize'] ?? "",
      truckSizeId: data['truckSizeId'] ?? "",
      url: data['url'] ?? "",
      packageId: data['packageId'] ?? "",
      ownBy: data['ownBy']?.toString() ?? '',
      ownById: data['ownById'] ?? "",
      status: data['status'] ?? "",
    );
    return tm;
  }
  static NewTruckModel? getTruckList(DocumentSnapshot<Map<String, dynamic>> d) {
    try {
      return NewTruckModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }

  static NewTruckModel getEmptyTruck() {
    return NewTruckModel(
      id: "",
      addedBy: "",
      chasisNumber: "",
      plateOrginCountry: "",
      timestamp: Timestamp.now(),
      truckCode: "",
      truckNumber: "",
      truckSize: "",
      url: "",
      packageId: "",
      status: "",
      truckSizeId: "",
    );
  }
}
