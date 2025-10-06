import 'package:cloud_firestore/cloud_firestore.dart';

class AssetsModel {
  String? id;
  String assetsCode;
  String name;

  String description;
  String assetCatId;
  String parentCatId;
  String custodianId;
  Timestamp purchaseDate;
  double purchaseCost;
  Timestamp? createdAt;
  double expectedLifeOfYears;
  String depreciationMethodId;

  double? depreciationRate;
  bool active;

  AssetsModel({
    this.id,
    required this.name,
    required this.assetsCode,
    required this.description,
    required this.assetCatId,
    required this.parentCatId,
    required this.custodianId,
    required this.purchaseDate,
    required this.purchaseCost,
    required this.depreciationMethodId,
    this.depreciationRate,
    required this.active,
    this.createdAt,
    required this.expectedLifeOfYears,
  });

  factory AssetsModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return AssetsModel(
      id: doc.id,
      assetsCode: data['assetsCode']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      custodianId: data['custodianId']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      assetCatId: data['assetCatId']?.toString() ?? '',
      parentCatId: data['parentCatId']?.toString() ?? '',
      depreciationMethodId: data['depreciationMethodId']?.toString() ?? '',
      depreciationRate: data['depreciationRate'] ?? 0.0,
      expectedLifeOfYears: data['expectedLifeOfYears'] ?? 0.0,
      purchaseCost: data['purchaseCost'] ?? 0.0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      purchaseDate: data['purchaseDate'] ?? Timestamp.now(),
      active: data['active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assetsCode': assetsCode,
      'name': name,
      'description': description,
      'assetCatId': assetCatId,
      'parentCatId': parentCatId,
      'depreciationMethodId': depreciationMethodId,
      'depreciationRate': depreciationRate,
      'expectedLifeOfYears': expectedLifeOfYears,
      'purchaseCost': purchaseCost,
      'custodianId': custodianId,
      'purchaseDate': purchaseDate,
      'active': active,
    };
  }
}
