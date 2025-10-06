import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceTypeModel {
  final String? id;
  final String name;
  final List? prices;
  final Timestamp? timestamp;
  final String status;
  final double? minimumPrice;
  final String createdBy;
  final String? code;

  ServiceTypeModel({
    this.id,
    required this.name,
    this.prices,
    this.timestamp,
    this.status = 'active',
    this.code,
    this.minimumPrice,
    required this.createdBy,
  });

  factory ServiceTypeModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ServiceTypeModel(
      id: doc.id,
      name: data['name'] ?? '',
      prices: data['prices'] as List? ?? [],
      status: data['status'] ?? 'inactive',
      code: data['code'] ?? '',
      minimumPrice: data['minimumPrice'] ?? 0.0,
      createdBy: data['createdBy'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'name': name,
      'status': status,
      'prices': prices ?? [],
      'timestamp': FieldValue.serverTimestamp(),
      'minimumPrice': minimumPrice ?? 0.0,
      'createdBy': createdBy,
      'code': code,
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {
      'name': name,
      'prices': prices ?? [],
      'status': status,
      'minimumPrice': minimumPrice,
    };
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'status': status, 'timestamp': timestamp};
  }
}

class BookedServices {
  final double price;
  final ServiceTypeModel serviceTypeModel;

  BookedServices({required this.price, required this.serviceTypeModel});
}
