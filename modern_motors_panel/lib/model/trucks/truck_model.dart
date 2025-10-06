import 'package:cloud_firestore/cloud_firestore.dart';

class TruckModel {
  String id;
  String addedBy;
  String chasisNumber;
  String plateOrginCountry;
  Timestamp timestamp;
  String truckCode;
  String truckNumber;
  String truckSize;
  String truckSizeId;
  TruckModel({
    required this.id,
    required this.addedBy,
    required this.chasisNumber,
    required this.plateOrginCountry,
    required this.timestamp,
    required this.truckCode,
    required this.truckNumber,
    required this.truckSize,
    required this.truckSizeId,
  });
  factory TruckModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    TruckModel tm = TruckModel(
      id: doc.id,
      addedBy: data!['addedBy'] ?? "",
      chasisNumber: data['chasisNumber'] ?? "",
      plateOrginCountry: data['plateOrginCountry'] ?? "",
      timestamp: data['timestamp'] ?? Timestamp.now(),
      truckCode: data['truckCode'] ?? "",
      truckNumber: data['truckNumber'] ?? "",
      truckSize: data['truckSize'] ?? "",
      truckSizeId: data['truckSizeId'] ?? "",
    );
    return tm;
  }
  static TruckModel? getTruckList(DocumentSnapshot<Map<String, dynamic>> d) {
    try {
      return TruckModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }

  static TruckModel getEmptyTruck() {
    return TruckModel(
      id: "",
      addedBy: "",
      chasisNumber: "",
      plateOrginCountry: "",
      timestamp: Timestamp.now(),
      truckCode: "",
      truckNumber: "",
      truckSize: "",
      truckSizeId: "",
    );
  }
}
