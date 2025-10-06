import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModel {
  String? id;
  String vendorName;
  String? imageUrl;
  String? crNumber;
  String? address;
  String? contactNumber;
  String? emailAddress;
  String? whatsappNumber;
  String? status;
  List<Manager>? managers;

  Timestamp? timestamp;

  VendorModel({
    this.id,
    required this.vendorName,
    this.imageUrl,
    this.crNumber,
    this.address,
    this.contactNumber,
    this.whatsappNumber,
    this.emailAddress,
    this.managers,
    this.timestamp,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'vendorName': vendorName,
      'imageUrl': imageUrl,
      'crNumber': crNumber,
      'address': address,
      'contactNumber': contactNumber,
      'email': emailAddress,
      'whatsapp': contactNumber,
      'status': status,
      'managers': managers?.map((m) => m.toMap()).toList() ?? [],
      'timestamp': timestamp != null ? Timestamp.now() : null,
    };
  }

  factory VendorModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return VendorModel(
      id: doc.id,
      vendorName: map['vendorName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      crNumber: map['crNumber'] ?? '',
      address: map['address'] ?? '',
      emailAddress: map['email'] ?? '',
      whatsappNumber: map['whatsapp'] ?? '',
      status: map['status'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      managers: (map['managers'] as List<dynamic>?)
          ?.map((m) => Manager.fromMap(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Manager {
  final String name;
  final String number;
  final String nationality;
  final String? image;

  Manager({
    required this.name,
    required this.number,
    required this.nationality,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'managerName': name,
      'managerNumber': number,
      'managerNationality': nationality,
      'image': image,
    };
  }

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      name: map['managerName'] ?? '',
      number: map['managerNumber'] ?? '',
      nationality: map['managerNationality'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
