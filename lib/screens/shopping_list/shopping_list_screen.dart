import 'package:flutter/material.dart';

import '../../models/shopping_item.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // Temporary fake data (replaced by a Provider in J2)
  final List<ShoppingItem> _items = [
    ShoppingItem(id: '1', name: 'Milk', quantity: 2),
    ShoppingItem(id: '2', name: 'Eggs', quantity: 12),
    ShoppingItem(id: '3', name: 'Tomatoes', isBought: true),
    ShoppingItem.fromName('Olive oil'),
  ];

  final _itemController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  // Opens a dialog and returns the typed name (or null if cancelled)
  Future<void> _showItemDialog({ShoppingItem? item}) async {
    _itemController.text = item?.name ?? '';

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(item == null ? 'Add item' : 'Edit item'),
          content: TextField(
            controller: _itemController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Item name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(90, 44)),
              onPressed: () =>
                  Navigator.pop(dialogContext, _itemController.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty || !mounted) return;

    setState(() {
      if (item == null) {
        _items.add(ShoppingItem.fromName(result));
      } else {
        final index = _items.indexOf(item);
        _items[index] = ShoppingItem(
          id: item.id,
          name: result,
          quantity: item.quantity,
          isBought: item.isBought,
        );
      }
    });
  }

  Widget _buildItem(ShoppingItem item) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: CheckboxListTile(
        value: item.isBought,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          setState(() {
            item.isBought = value ?? false;
          });
        },
        title: Text(
          item.name,
          style: textTheme.bodyMedium?.copyWith(
            decoration: item.isBought ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Quantity: ${item.quantity}',
          style: textTheme.bodySmall,
        ),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showItemDialog(item: item),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _items.remove(item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final toBuy = _items.where((item) => !item.isBought).toList();
    final bought = _items.where((item) => item.isBought).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping list')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        onPressed: () => _showItemDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: SafeArea(
        child: _items.isEmpty
            ? Center(
                child: Text('Your list is empty', style: textTheme.bodySmall),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                children: [
                  Text(
                    'To buy (${toBuy.length})',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...toBuy.map(_buildItem),
                  const SizedBox(height: 24),
                  Text(
                    'Bought (${bought.length})',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...bought.map(_buildItem),
                ],
              ),
      ),
    );
  }
}
