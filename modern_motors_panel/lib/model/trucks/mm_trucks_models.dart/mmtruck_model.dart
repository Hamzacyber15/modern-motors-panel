// import 'package:cloud_firestore/cloud_firestore.dart';

// class MmtrucksModel {
//   final String? id;
//   final int? plateNumber;
//   final String? code;
//   final String vehicleType;
//   final String? image;
//   final String? color;
//   final String? country;
//   final int modelYear;
//   final int engineCapacity;
//   final int emptyWeight;
//   final int maxLoad;
//   final int manufactureYear;
//   final int passengerCount;
//   final String chassisNumber;
//   final String? status;
//   final Timestamp? createAt;
//   final String ownBy;
//   final String? ownById;

//   MmtrucksModel({
//     this.id,
//     this.plateNumber,
//     this.code,
//     required this.vehicleType,
//     this.image,
//     this.color,
//     this.country,
//     required this.modelYear,
//     required this.chassisNumber,
//     required this.ownBy,
//     this.ownById,
//     this.createAt,
//     required this.emptyWeight,
//     required this.engineCapacity,
//     required this.manufactureYear,
//     required this.maxLoad,
//     required this.passengerCount,
//     this.status = 'active',
//   });

//   factory MmtrucksModel.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>? ?? {};

//     return MmtrucksModel(
//       id: doc.id,
//       code: data['code']?.toString(),
//       plateNumber: data['plateNumber'] ?? 0000,
//       vehicleType: data['vehicleType']?.toString() ?? '',
//       image: data['image']?.toString(),
//       color: data['color']?.toString(),
//       country: data['country']?.toString(),
//       chassisNumber: data['chassisNumber'].toString(),
//       createAt: data['createAt'] ?? Timestamp.now(),
//       emptyWeight: data['emptyWeight'] ?? 0,
//       engineCapacity: data['engineCapacity'] ?? 0,
//       manufactureYear: data['manufactureYear'] ?? 0,
//       maxLoad: data['maxLoad'] ?? 0,
//       ownBy: data['ownBy']?.toString() ?? '',
//       ownById: data['ownById'] ?? 'ISH',
//       modelYear: data['modelYear'] ?? 0,
//       passengerCount: data['passengerCount'] ?? 0,
//       status: data['status'] ?? 'Pending',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'plateNumber': plateNumber,
//       'vehicleType': vehicleType,
//       'code': code,
//       // 'image': image,
//       'color': color,
//       'country': country,
//       'status': status,
//       'chassisNumber': chassisNumber,
//       'modelYear': modelYear,
//       'emptyWeight': emptyWeight,
//       'engineCapacity': engineCapacity,
//       'ownBy': ownBy,
//       'ownById': ownById,
//       'manufactureYear': manufactureYear,
//       'maxLoad': maxLoad,
//       'passengerCount': passengerCount,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class MmtrucksModel {
  final String? id;
  final int? plateNumber;
  final String? code;
  final String vehicleType;
  final String? image;
  final String? color;
  final String? country;
  final int? modelYear;
  final int? engineCapacity;
  final int? emptyWeight;
  final int? maxLoad;
  final int? manufactureYear;
  final int? passengerCount;
  final String? chassisNumber;
  final String? status;
  final Timestamp? createAt;
  final String? ownBy;
  final String? ownById;
  final String? addedBy;
  // ✅ Newly added fields (all nullable)
  final String? vinNumber;
  final String? engineNumber;
  final String? transmission;
  final String? fuelType;
  final String? brand;
  final String? modelName;
  final double? purchasePrice;
  final double? sellingPrice;
  final String? supplier;
  final String? notes;
  final int? mileage;
  final String? condition;
  final String? category;
  final List<String>? imageUrls;

  MmtrucksModel({
    this.id,
    this.plateNumber,
    this.code,
    required this.vehicleType,
    this.image,
    this.color,
    this.country,
    this.modelYear,
    this.chassisNumber,
    this.ownBy,
    this.ownById,
    this.createAt,
    this.emptyWeight,
    this.engineCapacity,
    this.manufactureYear,
    this.maxLoad,
    this.passengerCount,
    this.status = 'active',
    // ✅ new fields
    this.vinNumber,
    this.engineNumber,
    this.transmission,
    this.fuelType,
    this.brand,
    this.modelName,
    this.purchasePrice,
    this.sellingPrice,
    this.supplier,
    this.notes,
    this.mileage,
    this.condition,
    this.category,
    this.imageUrls,
    this.addedBy,
  });

  factory MmtrucksModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return MmtrucksModel(
      id: doc.id,
      code: data['code']?.toString(),
      plateNumber: data['plateNumber'],
      vehicleType: data['vehicleType']?.toString() ?? '',
      image: data['image']?.toString(),
      color: data['color']?.toString(),
      country: data['country']?.toString(),
      chassisNumber: data['chassisNumber']?.toString(),
      createAt: data['createAt'] ?? Timestamp.now(),
      emptyWeight: data['emptyWeight'],
      engineCapacity: data['engineCapacity'],
      manufactureYear: data['manufactureYear'],
      maxLoad: data['maxLoad'],
      ownBy: data['ownBy']?.toString(),
      ownById: data['ownById'],
      modelYear: data['modelYear'],
      passengerCount: data['passengerCount'],
      status: data['status'] ?? 'Pending',

      // ✅ new fields
      vinNumber: data['vinNumber']?.toString(),
      engineNumber: data['engineNumber']?.toString(),
      transmission: data['transmission']?.toString(),
      fuelType: data['fuelType']?.toString(),
      brand: data['brand']?.toString(),
      modelName: data['modelName']?.toString(),
      purchasePrice: (data['purchasePrice'] is num)
          ? (data['purchasePrice'] as num).toDouble()
          : null,
      sellingPrice: (data['sellingPrice'] is num)
          ? (data['sellingPrice'] as num).toDouble()
          : null,
      supplier: data['supplier']?.toString(),
      notes: data['notes']?.toString(),
      mileage: data['mileage'],
      condition: data['condition']?.toString(),
      category: data['category']?.toString(),
      addedBy: data['addedBy']?.toString(),
      imageUrls:
          (data['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'code': code,
      'color': color,
      'country': country,
      'status': status,
      'chassisNumber': chassisNumber,
      'modelYear': modelYear,
      'emptyWeight': emptyWeight,
      'engineCapacity': engineCapacity,
      'ownBy': ownBy,
      'ownById': ownById,
      'manufactureYear': manufactureYear,
      'maxLoad': maxLoad,
      'passengerCount': passengerCount,

      // ✅ new fields
      'vinNumber': vinNumber,
      'engineNumber': engineNumber,
      'transmission': transmission,
      'fuelType': fuelType,
      'brand': brand,
      'modelName': modelName,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'supplier': supplier,
      'notes': notes,
      'mileage': mileage,
      'condition': condition,
      'category': category,
      'imageUrls': imageUrls,
      'addedBy': addedBy,
    };
  }
}
