import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessAreaModel {
  String title;
  String value;
  String id;
  List<String>? blocks;
  BusinessAreaModel({
    required this.title,
    required this.value,
    required this.id,
    this.blocks,
  });
  factory BusinessAreaModel.fromMap(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    List<String> blocksBuilding = [];
    List<dynamic> b = doc['blocks'] ?? [];
    for (var element in b) {
      blocksBuilding.add(element);
    }
    BusinessAreaModel bm = BusinessAreaModel(
      title: data!['building'] ?? "",
      value: data['building'] ?? "",
      id: doc.id,
      blocks: blocksBuilding,
    );
    return bm;
  }

  static BusinessAreaModel? getBusinessList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return BusinessAreaModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }
}
