import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class CustomerNameTile extends StatefulWidget {
  final String customerId;
  const CustomerNameTile({required this.customerId, super.key});

  @override
  State<CustomerNameTile> createState() => _CustomerNameTileState();
}

class _CustomerNameTileState extends State<CustomerNameTile> {
  CustomerModel? customer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() {
    final provider = context.read<MmResourceProvider>();
    customer = provider.getCustomerByID(widget.customerId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      customer?.customerName ?? 'Walk-in Customer',
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
