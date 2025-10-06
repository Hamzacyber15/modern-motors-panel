import 'package:cloud_firestore/cloud_firestore.dart';

class EditRequestModel {
  final String id;
  final String edit;
  final String status;
  final Timestamp time;
  final String userId;
  final String? entryType;
  final String? gatePassRef;
  final List<String>? url;

  EditRequestModel({
    required this.id,
    required this.edit,
    required this.status,
    required this.time,
    required this.userId,
    this.entryType,
    this.gatePassRef,
    this.url,
  });

  factory EditRequestModel.fromMap(Map<String, dynamic> map) {
    // Handle URL list conversion
    List<String>? urlList;
    if (map['url'] != null) {
      if (map['url'] is List) {
        urlList = List<String>.from(map['url'].map((item) => item.toString()));
      }
    }

    return EditRequestModel(
      id: map["id"] ?? "",
      edit: map['edit'] ?? '',
      status: map['status'] ?? 'pending',
      time: map['time'] ?? Timestamp.now(),
      userId: map['userId'] ?? '',
      entryType: map['entryType'],
      gatePassRef: map['gateEntryId'],
      url: urlList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'edit': edit,
      'status': status,
      'time': time,
      'userId': userId,
      if (entryType != null) 'entryType': entryType,
      if (gatePassRef != null) 'gateEntryId': gatePassRef,
      if (url != null) 'url': url,
    };
  }

  static Map<String, dynamic> createEditRequest({
    required String editType,
    required String userId,
    required String id,
    String status = 'pending',
    String? entryType,
    String? gatePassRef,
    List<String>? url,
  }) {
    return {
      'id': id,
      'edit': editType,
      'time': FieldValue.serverTimestamp(),
      'status': status,
      'userId': userId,
      if (entryType != null) 'entryType': entryType,
      if (gatePassRef != null) 'gateEntryId': gatePassRef,
      if (url != null && url.isNotEmpty) 'url': url,
    };
  }

  EditRequestModel copyWith({
    String? id,
    String? edit,
    String? status,
    Timestamp? time,
    String? userId,
    String? entryType,
    String? gatePassRef,
    List<String>? url,
  }) {
    return EditRequestModel(
      id: id ?? this.id,
      edit: edit ?? this.edit,
      status: status ?? this.status,
      time: time ?? this.time,
      userId: userId ?? this.userId,
      entryType: entryType ?? this.entryType,
      gatePassRef: gatePassRef ?? this.gatePassRef,
      url: url ?? this.url,
    );
  }
}
