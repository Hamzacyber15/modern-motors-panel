import 'package:cloud_firestore/cloud_firestore.dart';

class FineModel {
  String fineDescription, status;
  double fineAmount;
  Timestamp timestamp;

  FineModel({
    required this.fineDescription,
    required this.fineAmount,
    required this.status,
    required this.timestamp,
  });

  factory FineModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return FineModel(
      fineDescription: data['fineDescription'] ?? '',
      fineAmount: data['fineAmount'] ?? 0.0,
      status: data['status'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
