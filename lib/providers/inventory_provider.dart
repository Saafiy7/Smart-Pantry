import 'package:flutter/material.dart';
import 'package:smart_pantry/data/donnees_fictives.dart';
import 'package:smart_pantry/models/product.dart';

class InventoryProvider extends ChangeNotifier {
  final List<Product> _products = List<Product>.from(fakeProducts);

  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product updated) {
    final index = _products.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    _products[index] = updated;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}