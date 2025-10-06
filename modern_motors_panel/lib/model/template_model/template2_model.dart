import 'dart:typed_data';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';

class Template2Model {
  final Uint8List qrBytes;
  final SaleModel salesDetails;
  Template2Model({required this.qrBytes, required this.salesDetails});
}
