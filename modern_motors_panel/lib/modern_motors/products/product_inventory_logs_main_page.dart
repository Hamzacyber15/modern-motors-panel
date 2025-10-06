import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/products/product_inventory_logs.dart';

class ProductInventoryLogsMainPage extends StatefulWidget {
  final ProductModel product;
  const ProductInventoryLogsMainPage({required this.product, super.key});

  @override
  State<ProductInventoryLogsMainPage> createState() =>
      _ProductInventoryLogsMainPageState();
}

class _ProductInventoryLogsMainPageState
    extends State<ProductInventoryLogsMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Logs - ${widget.product.productName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ProductInventoryLogs(product: widget.product),
    );
  }
}
