import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_pantry/models/shopping_item.dart';
import 'package:smart_pantry/services/storage_service.dart';

void main() {
  test('shopping items survive save and load', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();

    await storage.saveShoppingItems([
      ShoppingItem(id: '1', name: 'Milk', quantity: 2, isBought: true),
    ]);

    final loaded = await storage.loadShoppingItems();
    expect(loaded!.length, 1);
    expect(loaded.first.name, 'Milk');
    expect(loaded.first.isBought, true);
  });

  test('returns null when nothing was saved', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await StorageService().loadShoppingItems(), isNull);
  });
}
