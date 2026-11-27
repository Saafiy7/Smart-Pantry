import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/shopping_item.dart';

class StorageService {
  static const String _shoppingKey = 'shopping_items';

  Future<void> saveShoppingItems(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(_shoppingKey, text);
  }

  Future<List<ShoppingItem>?> loadShoppingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_shoppingKey);
    if (text == null) return null;

    try {
      final List<dynamic> list = jsonDecode(text);
      return list
          .map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }
}
