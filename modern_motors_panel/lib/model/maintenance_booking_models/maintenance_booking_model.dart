import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';

class MaintenanceBookingModel {
  String? id;

  String? bookingNumber;
  String? customerId;
  String? truckId;
  String? salesPersonId;
  List<ItemsModel>? items;
  List<SelectedServiceWithPrice>? serviceTypes;
  Timestamp? bookingDate;
  String? status;
  double? itemsTotal; // sum of items lines
  double? servicesTotal; // sum of services charges
  double? subtotal; // (itemsTotal + servicesTotal) - discountedAmount
  double? total; // subtotal + taxAmount
  bool? isDiscountApplied;
  String? discountId;
  double? discountPercent;
  double? discountedAmount;
  bool? isTaxApplied;
  double? taxPercent;
  double? taxAmount;

  MaintenanceBookingModel({
    this.id,
    this.bookingNumber,
    this.customerId,
    this.truckId,
    this.items,
    this.serviceTypes,
    this.bookingDate,
    this.status,
    this.itemsTotal,
    this.servicesTotal,
    this.subtotal,
    this.total,
    this.isDiscountApplied,
    this.discountId,
    this.discountPercent,
    this.discountedAmount,
    this.isTaxApplied,
    this.taxPercent,
    this.taxAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      // identifiers
      'bookingNumber': bookingNumber,
      'customerId': customerId,
      'truckId': truckId,

      // lines
      'items': items?.map((e) => e.toMap()).toList() ?? [],
      'serviceTypes': serviceTypes?.map((e) => e.toMap()).toList() ?? [],

      // meta
      'bookingDate': bookingDate,
      'status': status,

      // totals
      'itemsTotal': itemsTotal ?? 0.0,
      'servicesTotal': servicesTotal ?? 0.0,
      'subtotal': subtotal ?? 0.0,
      'total': total ?? 0.0,

      // discount
      'isDiscountApplied': isDiscountApplied ?? false,
      'discountId': discountId ?? '',
      'discountPercent': discountPercent ?? 0.0,
      'discountedAmount': discountedAmount ?? 0.0,

      // tax
      'isTaxApplied': isTaxApplied ?? false,
      'taxPercent': taxPercent ?? 0.0,
      'taxAmount': taxAmount ?? 0.0,
      'salesPersonId': FirebaseAuth.instance.currentUser!.uid,
    };
  }

  factory MaintenanceBookingModel.from(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});

    // small helpers to coerce number → double safely
    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return 0.0;
    }

    return MaintenanceBookingModel(
      id: doc.id,
      bookingNumber: data['bookingNumber'] as String?,
      customerId: data['customerId'] as String?,
      truckId: data['truckId'] as String?,

      // items
      items: (data['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((m) => ItemsModel.fromMap(m))
          .toList(),

      // services
      serviceTypes: (data['serviceTypes'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((m) => SelectedServiceWithPrice.fromMap(m))
          .toList(),

      // meta
      bookingDate: data['bookingDate'] is Timestamp
          ? data['bookingDate'] as Timestamp
          : null,
      status: (data['status'] as String?) ?? 'inactive',

      // totals
      itemsTotal: toDouble(data['itemsTotal']),
      servicesTotal: toDouble(data['servicesTotal']),
      subtotal: toDouble(data['subtotal']),
      total: toDouble(data['total']),

      // discount
      isDiscountApplied: (data['isDiscountApplied'] as bool?) ?? false,
      discountId: data['discountId'] as String? ?? '',
      discountPercent: toDouble(data['discountPercent']),
      discountedAmount: toDouble(data['discountedAmount']),

      // tax
      isTaxApplied: (data['isTaxApplied'] as bool?) ?? false,
      taxPercent: toDouble(data['taxPercent']),
      taxAmount: toDouble(data['taxAmount']),
    );
  }
}

class SelectedServiceWithPrice {
  final String serviceId;
  final double serviceCharges;

  SelectedServiceWithPrice({
    required this.serviceId,
    required this.serviceCharges,
  });

  factory SelectedServiceWithPrice.fromMap(Map<String, dynamic> map) {
    final raw = map['serviceCharges'];
    double charges;
    if (raw is int) {
      charges = raw.toDouble();
    } else if (raw is num) {
      charges = raw.toDouble();
    } else {
      charges = 0.0;
    }

    return SelectedServiceWithPrice(
      serviceId: (map['serviceId'] ?? '') as String,
      serviceCharges: charges,
    );
  }

  Map<String, dynamic> toMap() {
    return {'serviceId': serviceId, 'serviceCharges': serviceCharges};
  }

  factory SelectedServiceWithPrice.clone(SelectedServiceWithPrice s) {
    return SelectedServiceWithPrice(
      serviceId: s.serviceId,
      serviceCharges: s.serviceCharges,
    );
  }
}
