import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:modern_motors_panel/model/price_model.dart';

class EquipmentModel {
  String id;
  String area;
  String equipmentCapacity;
  String equipmentIcon;
  String equipmentTitle;
  List<PriceModel> price;
  String status;
  Timestamp timestamp;
  EquipmentModel({
    required this.id,
    required this.area,
    required this.equipmentCapacity,
    required this.equipmentIcon,
    required this.equipmentTitle,
    required this.price,
    required this.status,
    required this.timestamp,
  });
  factory EquipmentModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    EquipmentModel em = EquipmentModel(
      id: "",
      area: "",
      equipmentCapacity: "",
      equipmentIcon: "",
      equipmentTitle: "",
      price: [],
      status: "",
      timestamp: Timestamp.now(),
    );
    List<dynamic> pDynamic = data!['price'] ?? [];
    List<Map<String, dynamic>> p = List<Map<String, dynamic>>.from(pDynamic);
    List<PriceModel> prices = [];
    String dataPlan = "";
    for (var element in p) {
      double value = 0;
      double price = 0;
      String basis = "";
      String priceStatus = "";
      bool? discountApplied;
      // if (element.containsKey(== "custom") ) {
      //   prices.add(PriceModel(
      //       id: "",
      //       price: element.values.first,
      //       status: "",
      //       duration: element.keys.first,
      //       // orderBasis: element.values.last,
      //       createdAt: DateTime.now()));
      // } else
      // {
      if (element.containsKey('value')) {
        value = double.tryParse(element['value'].toString()) ?? 0;
      }
      if (element.containsKey('custom')) {
        price = double.tryParse(element['custom'].toString()) ?? 0;
        dataPlan = "custom";
      }
      if (element.containsKey('price')) {
        price = double.tryParse(element['price'].toString()) ?? 0;
      }
      if (element.containsKey('basis')) {
        basis = element['basis'] ?? "";
      }
      if (element.containsKey('discountApplied')) {
        discountApplied = element['discountApplied'] ?? false;
      }
      priceStatus = element['status'] ?? "";
      double p = double.tryParse(price.toString()) ?? 0;
      //int p = int.tryParse(price.toString()) ?? 0;
      if (dataPlan == "custom") {
        prices.add(
          PriceModel(
            id: "",
            price: p,
            status: priceStatus,
            duration: dataPlan,
            createdAt: DateTime.now(),
            orderBasis: basis,
            applyDiscount: discountApplied,
          ),
        );
      } else {
        prices.add(
          PriceModel(
            id: "",
            price: p,
            status: priceStatus,
            duration: value.toString(),
            createdAt: DateTime.now(),
            orderBasis: basis,
            applyDiscount: discountApplied,
          ),
        );
      }

      // prices.add(PriceModel(
      //     id: "",
      //     price: element.values.first,
      //     status: "",
      //     duration: element.keys.first,
      //     // orderBasis: element.values.last,
      //     createdAt: DateTime.now()));
    }
    em = EquipmentModel(
      id: doc.id,
      area: data["area"] ?? "",
      equipmentCapacity: data["equipmentCapacity"] ?? "",
      equipmentIcon: data["equipmentIcon"] ?? "",
      equipmentTitle: data["equipmentTitle"] ?? "",
      price: prices,
      status: data["status"] ?? "",
      timestamp: data["timestamp"] ?? Timestamp.now(),
    );
    return em;
  }
  static EquipmentModel? getBusinessList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return EquipmentModel.fromMap(d);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static EquipmentModel getEmptyModel() {
    return EquipmentModel(
      id: "",
      area: "",
      equipmentCapacity: "",
      equipmentIcon: "",
      equipmentTitle: "",
      price: [],
      status: "",
      timestamp: Timestamp.now(),
    );
  }
}
