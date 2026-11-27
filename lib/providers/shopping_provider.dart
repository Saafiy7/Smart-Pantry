import 'package:flutter/foundation.dart';

import '../models/shopping_item.dart';
import '../services/storage_service.dart';

class ShoppingProvider extends ChangeNotifier {
  final StorageService _storage;
  final List<ShoppingItem> _items = [];
  bool _isLoaded = false;

  ShoppingProvider({StorageService? storage})
    : _storage = storage ?? StorageService() {
    _load();
  }

  bool get isLoaded => _isLoaded;

  List<ShoppingItem> get items => List.unmodifiable(_items);

  List<ShoppingItem> get toBuyItems =>
      _items.where((item) => !item.isBought).toList();

  List<ShoppingItem> get boughtItems =>
      _items.where((item) => item.isBought).toList();

  int get toBuyCount => toBuyItems.length;

  // Starting data, used only the first time the app runs
  List<ShoppingItem> _starterItems() {
    return [
      ShoppingItem(id: '1', name: 'Milk', quantity: 2),
      ShoppingItem(id: '2', name: 'Eggs', quantity: 12),
      ShoppingItem(id: '3', name: 'Tomatoes', isBought: true),
      ShoppingItem.fromName('Olive oil'),
    ];
  }

  Future<void> _load() async {
    final saved = await _storage.loadShoppingItems();
    _items
      ..clear()
      ..addAll(saved ?? _starterItems());
    _isLoaded = true;
    notifyListeners();
  }

  void _save() {
    _storage.saveShoppingItems(_items);
  }

  void addItem(String name) {
    _items.add(ShoppingItem.fromName(name));
    notifyListeners();
    _save();
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
    _save();
  }

  void toggleBought(ShoppingItem item, bool value) {
    item.isBought = value;
    notifyListeners();
    _save();
  }

  void removeItem(ShoppingItem item) {
    _items.removeWhere((i) => i.id == item.id);
    notifyListeners();
    _save();
  }
}
