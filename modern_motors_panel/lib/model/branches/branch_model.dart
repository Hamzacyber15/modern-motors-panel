import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  String? id;
  String branchName;
  String? imageUrl;
  String? address;
  String? description;
  String? storeManager;
  String? status;
  Timestamp? timestamp;

  BranchModel({
    this.id,
    required this.branchName,
    this.imageUrl,
    this.address,
    this.description,
    this.storeManager,
    this.timestamp,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'branchName': branchName,
      'imageUrl': imageUrl,
      'address': address,
      'description': description,
      'storeManager': storeManager,
      'status': status,
      'timestamp': timestamp != null ? Timestamp.now() : null,
    };
  }

  factory BranchModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return BranchModel(
      id: doc.id,
      branchName: map['branchName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      address: map['address'] ?? '',
      storeManager: map['storeManager'] ?? '',
      status: map['status'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
