// import 'package:cloud_firestore/cloud_firestore.dart';

// class NationalityModel {
//   String id, nationality, nationalityArabic, status;
//   Timestamp timestamp;

//   NationalityModel(
//       {required this.id,
//       required this.nationality,
//       required this.nationalityArabic,
//       required this.status,
//       required this.timestamp});

//   factory NationalityModel.fromSnapshot(DocumentSnapshot snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

//     return NationalityModel(
//         id: snapshot.id,
//         nationality: data['nationality'] ?? '',
//         nationalityArabic: data['nationalityArabic'] ?? '',
//         status: data['status'] ?? '',
//         timestamp: data['timestamp'] ?? Timestamp.now());
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class NationalityModel {
  String? id, status;
  String nationality, nationalityArabic;
  Timestamp? timestamp;
  NationalityModel({
    this.id,
    required this.nationality,
    required this.nationalityArabic,
    this.status,
    this.timestamp,
  });

  factory NationalityModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return NationalityModel(
      id: snapshot.id,
      nationality: data['nationality'] ?? '',
      nationalityArabic: data['nationalityArabic'] ?? '',
      status: data['status'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nationality': nationality,
      'nationalityArabic': nationalityArabic,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(), // hamesha latest rakhega
    };
  }
}
