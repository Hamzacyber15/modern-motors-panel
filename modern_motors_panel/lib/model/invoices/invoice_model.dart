import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel {
  String id;
  double amount;
  String businessId;
  String invoice;
  String orderId;
  Timestamp timeStamp;
  String type;
  String? silalInvoice;
  double? gateMoney;
  double? handlingFee;
  String? ref;
  String? description;
  String? businessStatus;
  String? status;
  Timestamp? dueDate;
  List<String>? url;
  String? packageId;
  InvoiceModel({
    required this.id,
    required this.amount,
    required this.businessId,
    required this.invoice,
    required this.orderId,
    required this.timeStamp,
    required this.type,
    this.silalInvoice,
    this.gateMoney,
    this.handlingFee,
    this.ref,
    this.description,
    this.businessStatus,
    this.status,
    this.dueDate,
    this.url,
    this.packageId,
  });
  factory InvoiceModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    List<dynamic> imageList = data!['url'] ?? [];
    List<String> urlList = [];
    for (var element in imageList) {
      urlList.add(element);
    }
    InvoiceModel im = InvoiceModel(
      id: doc.id,
      amount: double.tryParse(data['amount'].toString()) ?? 0,
      businessId: data['businessId'] ?? "",
      invoice: data['invoice'] ?? "",
      orderId: data['orderId'] ?? "",
      timeStamp: data['timeStamp'] ?? Timestamp.now(),
      type: data['type'] ?? "",
      silalInvoice: data['silalInvoice'] ?? "",
      handlingFee: double.tryParse(data['handlingFee'].toString()) ?? 0,
      ref: data['ref'] ?? "",
      gateMoney: double.tryParse(data['gateMoney'].toString()) ?? 0,
      description: data['description'] ?? "",
      status: data['status'] ?? "",
      businessStatus: data['businessStatus'] ?? "",
      dueDate: data['dueDate'],
      url: urlList,
      packageId: data['packageId'] ?? "",
    );
    return im;
  }

  static InvoiceModel? getInvoiceList(
    DocumentSnapshot<Map<String, dynamic>> d,
  ) {
    try {
      return InvoiceModel.fromMap(d);
    } catch (e) {
      return null;
    }
  }
}
