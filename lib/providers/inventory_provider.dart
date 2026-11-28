import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_pantry/data/donnees_fictives.dart';
import 'package:smart_pantry/models/product.dart';

class InventoryProvider extends ChangeNotifier {
  static const String _cle = 'inventaire';

  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final textes = prefs.getStringList(_cle);
    if (textes == null) {
      _products.addAll(fakeProducts);
      await _sauvegarder();
    } else {
      for (final t in textes) {
        _products.add(Product.fromJson(jsonDecode(t)));
      }
    }
    notifyListeners();
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _cle,
      _products.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
    _sauvegarder();
  }

  void updateProduct(Product updated) {
    final index = _products.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    _products[index] = updated;
    notifyListeners();
    _sauvegarder();
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
    _sauvegarder();
  }
}