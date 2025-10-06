import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/modern_motors/products/product_inventory_batches.dart';

class ProductInventoryBatchesMainPage extends StatefulWidget {
  final ProductModel product;
  const ProductInventoryBatchesMainPage({required this.product, super.key});

  @override
  State<ProductInventoryBatchesMainPage> createState() =>
      _ProductInventoryBatchesMainPageState();
}

class _ProductInventoryBatchesMainPageState
    extends State<ProductInventoryBatchesMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Batches - ${widget.product.productName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ProductInventoryBatches(product: widget.product),
    );
  }
}
