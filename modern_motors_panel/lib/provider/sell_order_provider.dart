import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';

class SellOrderProvider extends ChangeNotifier {
  final List<ProductCategoryModel> _selectedProducts = [];

  List<ProductCategoryModel> get selectedProducts =>
      List.unmodifiable(_selectedProducts);

  void addProducts(List<ProductCategoryModel> products) {
    for (var product in products) {
      if (!_selectedProducts.any((p) => p.id == product.id)) {
        _selectedProducts.add(product);
      }
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    _selectedProducts.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void clearOrder() {
    _selectedProducts.clear();
    notifyListeners();
  }
}
