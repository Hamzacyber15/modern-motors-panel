import 'package:cloud_firestore/cloud_firestore.dart';

class PalletUpdateModel {
  String id;
  String status;
  String url;
  Timestamp timestamp;
  Timestamp? startedAt;
  Timestamp? completedAt;
  Timestamp? cautionAt;
  Timestamp? cautionUpdatedAt;
  PalletUpdateModel({
    required this.id,
    required this.status,
    required this.url,
    required this.timestamp,
    this.startedAt,
    this.completedAt,
    this.cautionAt,
    this.cautionUpdatedAt,
  });
}
