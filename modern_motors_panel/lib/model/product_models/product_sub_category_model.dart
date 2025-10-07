// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductSubCatorymodel {
//   final String? id;
//   final String name;
//   final List<String>? catId;
//   final Timestamp? timestamp;
//   final String status;

//   ProductSubCatorymodel({
//     this.id,
//     required this.name,
//     this.catId = const [],
//     this.timestamp,
//     this.status = 'active',
//   });

//   factory ProductSubCatorymodel.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>? ?? {};
//     return ProductSubCatorymodel(
//       id: doc.id,
//       name: data['name'] ?? '',
//       catId: (data['catId'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       status: data['status'] ?? 'active',
//       timestamp: data['timestamp'] ?? Timestamp.now(),
//     );
//   }

//   Map<String, dynamic> toMapForAdd() {
//     return {
//       'name': name,
//       'catId': catId,
//       'status': status,
//       'timestamp': FieldValue.serverTimestamp(),
//     };
//   }

//   Map<String, dynamic> toMapForUpdate() {
//     return {'name': name, 'catId': catId, 'status': status};
//   }

//   Map<String, dynamic> toJson() {
//     return {'name': name, 'status': status, 'timestamp': timestamp};
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSubCategoryModel {
  String? id;
  String name;
  String? code;
  List<String>? catId;
  Timestamp? timestamp;
  String status;
  String? createdBy;

  ProductSubCategoryModel({
    this.id,
    required this.name,
    this.code,
    this.catId = const [],
    this.timestamp,
    this.createdBy,
    this.status = 'active',
  });

  factory ProductSubCategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProductSubCategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      createdBy: data['createdBy'] ?? '',
      catId: (data['catId'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: data['status'] ?? 'active',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'name': name,
      'catId': catId,
      'status': status,
      'code': code,
      'createdBy': createdBy,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {'name': name, 'catId': catId, 'status': status};
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'status': status, 'timestamp': timestamp};
  }
}
