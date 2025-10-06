import 'package:cloud_firestore/cloud_firestore.dart';

class VendorLogosListModel {
  final String? id;
  final List<VendorLogosModel> logos;

  VendorLogosListModel({required this.logos, this.id});

  Map<String, dynamic> toMap() {
    return {'logos': logos.map((m) => m.toMap()).toList()};
  }

  factory VendorLogosListModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return VendorLogosListModel(
      id: doc.id,
      logos: (map['logos'] as List<dynamic>? ?? [])
          .map((m) => VendorLogosModel.fromMap(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VendorLogosModel {
  final String imgUrl;
  final String status;
  final Timestamp? createdAt;

  VendorLogosModel({
    required this.imgUrl,
    required this.status,
    this.createdAt,
  });

  /// For nested map data (not a doc, just inside a parent doc)
  factory VendorLogosModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return VendorLogosModel(
      imgUrl: map['imgUrl'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  factory VendorLogosModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return VendorLogosModel.fromMap(map, id: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': imgUrl,
      'status': status,
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }
}
