import 'package:cloud_firestore/cloud_firestore.dart';

class HeavyEquipmentTypeModel {
  final String? id;
  final String name;
  final String description;
  final String nameArabic;
  final String descriptionArabic;
  final Timestamp? timestamp;
  final String status;
  final String? image;

  HeavyEquipmentTypeModel({
    this.id,
    required this.name,
    this.timestamp,
    required this.description,
    this.status = 'active',
    this.image,
    required this.nameArabic,
    required this.descriptionArabic,
  });

  factory HeavyEquipmentTypeModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HeavyEquipmentTypeModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      nameArabic: data['nameArabic'] ?? '',
      descriptionArabic: data['descriptionArabic'] ?? '',
      image: data['image'] ?? '',
      status: data['status'] ?? 'inactive',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'image': image,
      'nameArabic': nameArabic,
      'descriptionArabic': descriptionArabic,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {
      'name': name,
      'status': status,
      'description': description,
      'image': image,
      'nameArabic': nameArabic,
      'descriptionArabic': descriptionArabic,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'timestamp': timestamp,
      'description': description,
      'nameArabic': nameArabic,
      'descriptionArabic': descriptionArabic,
      'image': image,
    };
  }
}
