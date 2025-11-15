import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/create_maintenance_booking.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/create_maintenance_booking1.dart';

class CreateBookingMainPage extends StatefulWidget {
  final VoidCallback tapped;
  final SaleModel? sale;
  final String? type;
  const CreateBookingMainPage({
    required this.tapped,
    this.sale,
    this.type,
    super.key,
  });

  @override
  State<CreateBookingMainPage> createState() => _CreateBookingMainPageState();
}

class _CreateBookingMainPageState extends State<CreateBookingMainPage> {
  void tappedFunction() {
    widget.tapped();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CreateMaintenanceBooking(
        type: widget.type,
        sale: widget.sale,
        onBack: () async {
          if (widget.type == "edit") {
            Navigator.of(context).pop();
          } else {
            widget.tapped.call();
          }

          //tappedFunction();
        },
      ),
    );
  }
}
