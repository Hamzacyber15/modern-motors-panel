import 'package:cloud_firestore/cloud_firestore.dart';

class LabourWorkingFieldsModel {
  String id, area, arabicArea, status;
  Timestamp timestamp;

  LabourWorkingFieldsModel({
    required this.id,
    required this.area,
    required this.arabicArea,
    required this.status,
    required this.timestamp,
  });

  factory LabourWorkingFieldsModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return LabourWorkingFieldsModel(
      id: snapshot.id,
      area: data['area'] ?? '',
      status: data['status'] ?? '',
      arabicArea: data['arabicArea'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
