import 'package:cloud_firestore/cloud_firestore.dart';

class CountryModel {
  final String? id;
  final String country;
  final Timestamp? timestamp;
  final String status;

  CountryModel({
    this.id,
    required this.country,
    this.timestamp,
    this.status = 'active',
  });

  factory CountryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CountryModel(
      id: doc.id,
      country: data['country'] ?? '',
      status: data['status'] ?? 'inactive',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'country': country,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {'country': country, 'status': status};
  }

  Map<String, dynamic> toJson() {
    return {'country': country, 'status': status, 'timestamp': timestamp};
  }
}
