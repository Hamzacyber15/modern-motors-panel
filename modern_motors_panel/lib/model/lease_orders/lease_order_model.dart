import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modern_motors_panel/model/invoices/invoice_model.dart';

class LeaseOrderModel {
  String id;
  String businessID;
  String generatedBy;
  DateTime leaseDate;
  DateTime leaseEndDate;
  String orderID;
  String packageID;
  double price;
  String serviceType;
  String status;
  String invoiceId;
  String equipmentId;
  int tenure;
  DateTime? timestamp;
  DateTime? currentStartDate;
  DateTime? currentLastDate;
  String? discountId;
  String? deviceNumber;
  String? equipmentNumber;
  List<InvoiceModel>? transactions;
  LeaseOrderModel({
    required this.id,
    required this.businessID,
    required this.generatedBy,
    required this.leaseDate,
    required this.leaseEndDate,
    required this.orderID,
    required this.packageID,
    required this.price,
    required this.serviceType,
    required this.status,
    required this.tenure,
    required this.invoiceId,
    required this.equipmentId,
    this.timestamp,
    this.currentLastDate,
    this.currentStartDate,
    this.discountId,
    this.deviceNumber,
    this.equipmentNumber,
    this.transactions,
  });
  factory LeaseOrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    Map<String, dynamic>? data = doc.data();
    Duration offset = Duration(hours: 10);
    DateTime leaseDate = (data?['leaseDate'] as Timestamp).toDate().add(offset);
    DateTime leaseEndDate = (data?['leaseEndDate'] as Timestamp)
        .toDate()
        .subtract(offset);
    DateTime? currentLastDate;
    DateTime? currentStartDate;
    if (data?['currentLastDate'] != null) {
      currentLastDate = (data?['currentLastDate'] as Timestamp)
          .toDate()
          .subtract(offset);
    }
    if (data?['currentStartDate'] != null) {
      currentStartDate = (data?['currentStartDate'] as Timestamp).toDate().add(
        offset,
      );
    }
    List<dynamic> leaseTransactionList = data?['transactions'] ?? [];
    List<InvoiceModel> lT = [];
    for (var element in leaseTransactionList) {
      lT.add(
        InvoiceModel(
          ref: element['ref'] ?? "",
          id: doc.id,
          amount: double.tryParse(element!['amount'].toString()) ?? 0,
          businessId: element['businessId'] ?? "",
          invoice: element['invoice'] ?? "",
          orderId: element['orderId'] ?? "",
          timeStamp: element['timeStamp'] ?? Timestamp.now(),
          type: element['type'] ?? "",
          silalInvoice: element['silalInvoice'] ?? "",
          handlingFee: double.tryParse(element['handlingFee'].toString()) ?? 0,
          gateMoney: double.tryParse(element['gateMoney'].toString()) ?? 0,
        ),
      );
    }
    return LeaseOrderModel(
      id: doc.id,
      businessID: data?['businessId'] ?? '',
      generatedBy: data?['generatedBy'] ?? '',
      leaseDate: leaseDate,
      // leaseDate: (data?['leaseDate'] as Timestamp).toDate().toLocal(),
      leaseEndDate: leaseEndDate,
      orderID: data?['orderId'] ?? '',
      packageID: data?['packageId'] ?? '',
      price: double.parse(data?['price'].toString() ?? '0'),
      serviceType: data?['serviceType'] ?? '',
      status: data?['status'] ?? '',
      invoiceId: data?['invoiceId'] ?? "",
      equipmentId: data?['equipmentId'] ?? "",
      tenure: int.parse(data?['tenure'].toString() ?? '0'),
      timestamp: (data?['timestamp'] as Timestamp).toDate(),
      discountId: data?['discountID'] ?? "",
      currentLastDate: currentLastDate,
      currentStartDate: currentStartDate,
      deviceNumber: data?['deviceNumber'] ?? "",
      equipmentNumber: data?['equipmentNumber'] ?? "",
      transactions: lT,
    );
  }
  Map<String, dynamic> toMap(FieldValue createdAt) {
    return {
      'id': id,
      'businessId': businessID,
      'generatedBy': generatedBy,
      'leaseDate': leaseDate,
      'leaseEndDate': leaseEndDate,
      'orderId': orderID,
      'packageId': packageID,
      'price': price,
      'serviceType': serviceType,
      'status': status,
      'tenure': tenure,
      'timestamp': createdAt,
    };
  }
}

class LeaseOption {
  DateTime startDate;
  DateTime endDate;
  double price;
  LeaseOption({
    required this.startDate,
    required this.endDate,
    required this.price,
  });
}
