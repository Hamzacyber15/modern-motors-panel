// import 'dart:typed_data';

// import 'package:app/models/invoice/invoice_mm_model.dart';
// import 'package:app/models/maintenance/maintenance_booking_model.dart';
// import 'package:app/modern_motors/models/customer/customer_model.dart';
// import 'package:app/modern_motors/models/estimates/estimates_model.dart';
// import 'package:app/modern_motors/models/inventory/inventory_model.dart';
// import 'package:app/modern_motors/sales/sales_model.dart';

// class Template1Model {
//   final InvoiceMmModel? invoiceModel;
//   final MaintenanceBookingModel? bookingModel;
//   final EstimationModel? estimationModel;
//   final List<InventoryModel>? inventoryModelList;
//   final CustomerModel? customerModel;
//   final Uint8List? qrBytes;
//   final SaleModel? salesDetails;

//   Template1Model({
//     this.invoiceModel,
//     this.qrBytes,
//     this.inventoryModelList,
//     this.bookingModel,
//     this.estimationModel,
//     this.customerModel,
//     this.salesDetails,
//   });
// }

import 'dart:typed_data';

import 'package:modern_motors_panel/model/sales_model/sale_model.dart';

class Template1Model {
  final Uint8List? qrBytes;
  final SaleModel? salesDetails;

  Template1Model({this.qrBytes, this.salesDetails});
}
