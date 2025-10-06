import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modern_motors_panel/model/invoices/invoices_mm_model.dart';
import 'package:modern_motors_panel/model/maintenance_booking_models/maintenance_booking_model.dart';

class EstimationModel {
  String? id;
  double? advancePercentage;
  String? customerNumber;
  String? customerId;
  String? salesPersonId;
  // Lines
  List<ItemsModel>? items;
  List<SelectedServiceWithPrice>? serviceTypes;
  // Dates & status
  Timestamp? visitingDate;
  String? status;
  double? itemsTotal;
  double? servicesTotal;
  double? subtotal;
  double? total;
  // Discount (invoice-like)
  bool? isDiscountApplied;
  String? discountId;
  double? discountPercent;
  double? discountedAmount;
  // Tax (invoice-like)
  bool? isTaxApplied;
  double? taxPercent;
  double? taxAmount;
  Timestamp? createdAt;

  EstimationModel({
    this.id,
    this.customerNumber,
    this.customerId,
    this.items,
    this.serviceTypes,
    this.visitingDate,
    this.status,
    this.salesPersonId,
    this.itemsTotal,
    this.servicesTotal,
    this.advancePercentage,
    this.subtotal,
    this.total,
    this.isDiscountApplied,
    this.discountId,
    this.discountPercent,
    this.discountedAmount,
    this.isTaxApplied,
    this.taxPercent,
    this.taxAmount,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      // identifiers
      'customerNumber': customerNumber,
      'customerId': customerId,
      'advancePercentage': advancePercentage,

      // lines
      'items': items?.map((e) => e.toMap()).toList() ?? [],
      'serviceTypes': serviceTypes?.map((e) => e.toMap()).toList() ?? [],

      // meta
      'visitingDate': visitingDate,
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

  // factory EstimationModel.from(DocumentSnapshot doc) {
  //   final data = (doc.data() as Map<String, dynamic>? ?? {});

  //   // small helpers to coerce number → double safely
  //   double toDouble(dynamic v) {
  //     if (v == null) return 0.0;
  //     if (v is num) return v.toDouble();
  //     return 0.0;
  //   }

  //   return EstimationModel(
  //     id: doc.id,
  //     customerNumber: data['customerNumber'] as String?,
  //     customerId: data['customerId'] as String?,
  //     salesPersonId: data['salesPersonId'] as String?,
  //     // items
  //     items: (data['items'] as List<dynamic>? ?? [])
  //         .whereType<Map<String, dynamic>>()
  //         .map((m) => ItemsModel.fromMap(m))
  //         .toList(),

  //     // services
  //     serviceTypes: (data['serviceTypes'] as List<dynamic>? ?? [])
  //         .whereType<Map<String, dynamic>>()
  //         .map((m) => SelectedServiceWithPrice.fromMap(m))
  //         .toList(),

  //     // meta
  //     visitingDate: data['visitingDate'] is Timestamp
  //         ? data['visitingDate'] as Timestamp
  //         : null,
  //     createdAt: data['createdAt'] is Timestamp
  //         ? data['createdAt'] as Timestamp
  //         : null,
  //     status: (data['status'] as String?) ?? 'inactive',

  //     // totals
  //     itemsTotal: toDouble(data['itemsTotal']),
  //     servicesTotal: toDouble(data['servicesTotal']),
  //     subtotal: toDouble(data['subtotal']),
  //     total: toDouble(data['total']),

  //     // discount
  //     isDiscountApplied: (data['isDiscountApplied'] as bool?) ?? false,
  //     discountId: data['discountId'] as String? ?? '',
  //     advancePercentage: toDouble(data['advancePercentage']),
  //     discountPercent: toDouble(data['discountPercent']),
  //     discountedAmount: toDouble(data['discountedAmount']),

  //     // tax
  //     isTaxApplied: (data['isTaxApplied'] as bool?) ?? false,
  //     taxPercent: toDouble(data['taxPercent']),
  //     taxAmount: toDouble(data['taxAmount']),
  //   );
  // }
  factory EstimationModel.from(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});

    // small helpers to coerce number → double safely
    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return 0.0;
    }

    // Handle serviceTypes safely
    List<SelectedServiceWithPrice> serviceTypesList = [];
    final serviceTypesData = data['serviceTypes'] as List<dynamic>?;
    if (serviceTypesData != null && serviceTypesData.isNotEmpty) {
      serviceTypesList = serviceTypesData
          .whereType<Map<String, dynamic>>()
          .map((m) => SelectedServiceWithPrice.fromMap(m))
          .toList();
    }

    return EstimationModel(
      id: doc.id,
      customerNumber: data['customerNumber'] as String?,
      customerId: data['customerId'] as String?,
      salesPersonId: data['salesPersonId'] as String?,
      // items
      items: (data['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((m) => ItemsModel.fromMap(m))
          .toList(),

      // services - use the safely handled list
      serviceTypes: serviceTypesList,

      // meta
      visitingDate: data['visitingDate'] is Timestamp
          ? data['visitingDate'] as Timestamp
          : null,
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt'] as Timestamp
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
      advancePercentage: toDouble(data['advancePercentage']),
      discountPercent: toDouble(data['discountPercent']),
      discountedAmount: toDouble(data['discountedAmount']),

      // tax
      isTaxApplied: (data['isTaxApplied'] as bool?) ?? false,
      taxPercent: toDouble(data['taxPercent']),
      taxAmount: toDouble(data['taxAmount']),
    );
  }
}
