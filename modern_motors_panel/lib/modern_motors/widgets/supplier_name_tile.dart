import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/supplier/supplier_model.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class SupplierNameTile extends StatefulWidget {
  final String customerId;
  const SupplierNameTile({required this.customerId, super.key});

  @override
  State<SupplierNameTile> createState() => _SupplierNameTileState();
}

class _SupplierNameTileState extends State<SupplierNameTile> {
  SupplierModel? supplier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() {
    final provider = context.read<MmResourceProvider>();
    supplier = provider.getSupplierByID(widget.customerId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      supplier?.supplierName ?? 'Walk-in Supplier',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1a202c),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
