import 'package:cloud_firestore/cloud_firestore.dart';

class TermsOfSalesModel {
  final String? id;
  final List<TermsAndConditionsOfSalesModel> terms;

  TermsOfSalesModel({required this.terms, this.id});

  Map<String, dynamic> toMap() {
    return {'terms': terms.map((m) => m.toMap()).toList()};
  }

  factory TermsOfSalesModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return TermsOfSalesModel(
      id: doc.id,
      terms: (map['terms'] as List<dynamic>? ?? [])
          .map(
            (m) => TermsAndConditionsOfSalesModel.fromMap(
              m as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class TermsAndConditionsOfSalesModel {
  final String? id;
  final int index;
  final String title;
  final String description;
  final String status;
  final Timestamp? createdAt;

  TermsAndConditionsOfSalesModel({
    this.id,
    required this.index,
    required this.title,
    required this.description,
    required this.status,
    this.createdAt,
  });

  /// For nested map data (not a doc, just inside a parent doc)
  factory TermsAndConditionsOfSalesModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    return TermsAndConditionsOfSalesModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      index: map['index'] ?? 0,
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  /// For reading directly from a Firestore subcollection/doc
  factory TermsAndConditionsOfSalesModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return TermsAndConditionsOfSalesModel.fromMap(map, id: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'index': index,
      'status': status,
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }
}
