import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyModel {
  final String? id;
  final String currency;
  final Timestamp? timestamp;
  final String status;

  CurrencyModel({
    this.id,
    required this.currency,
    this.timestamp,
    this.status = 'active',
  });

  factory CurrencyModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CurrencyModel(
      id: doc.id,
      currency: data['currency'] ?? '',
      status: data['status'] ?? 'inactive',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'currency': currency,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {'currency': currency, 'status': status};
  }

  Map<String, dynamic> toJson() {
    return {'currency': currency, 'status': status, 'timestamp': timestamp};
  }
}
