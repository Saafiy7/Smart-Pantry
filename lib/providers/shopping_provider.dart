import 'package:flutter/foundation.dart';

import '../models/shopping_item.dart';

class ShoppingProvider extends ChangeNotifier {
  // Temporary starting data
  final List<ShoppingItem> _items = [
    ShoppingItem(id: '1', name: 'Milk', quantity: 2),
    ShoppingItem(id: '2', name: 'Eggs', quantity: 12),
    ShoppingItem(id: '3', name: 'Tomatoes', isBought: true),
    ShoppingItem.fromName('Olive oil'),
  ];

  List<ShoppingItem> get items => List.unmodifiable(_items);

  List<ShoppingItem> get toBuyItems =>
      _items.where((item) => !item.isBought).toList();

  List<ShoppingItem> get boughtItems =>
      _items.where((item) => item.isBought).toList();

  int get toBuyCount => toBuyItems.length;

  void addItem(String name) {
    _items.add(ShoppingItem.fromName(name));
    notifyListeners();
  }

  void updateItemName(ShoppingItem item, String newName) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    _items[index] = ShoppingItem(
      id: item.id,
      name: newName,
      quantity: item.quantity,
      isBought: item.isBought,
    );
    notifyListeners();
  }

  void toggleBought(ShoppingItem item, bool value) {
    item.isBought = value;
    notifyListeners();
  }

  void removeItem(ShoppingItem item) {
    _items.removeWhere((i) => i.id == item.id);
    notifyListeners();
  }
}
