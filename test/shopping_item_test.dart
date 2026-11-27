import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pantry/models/shopping_item.dart';

void main() {
  test('ShoppingItem is identical after toJson / fromJson', () {
    final original = ShoppingItem(
      id: '1',
      name: 'Milk',
      quantity: 2,
      isBought: true,
    );

    final text = jsonEncode(original.toJson());
    final restored = ShoppingItem.fromJson(jsonDecode(text));

    expect(restored.id, original.id);
    expect(restored.name, original.name);
    expect(restored.quantity, original.quantity);
    expect(restored.isBought, original.isBought);
  });

  test('fromJson uses default values when fields are missing', () {
    final item = ShoppingItem.fromJson({'id': '2', 'name': 'Eggs'});

    expect(item.quantity, 1);
    expect(item.isBought, false);
  });
}
