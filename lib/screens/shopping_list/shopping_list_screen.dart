import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/shopping_item.dart';
import '../../providers/shopping_provider.dart';

enum ShoppingFilter { all, toBuy, bought }

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _itemController = TextEditingController();
  ShoppingFilter _filter = ShoppingFilter.all;

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

    final shopping = context.read<ShoppingProvider>();
    if (item == null) {
      shopping.addItem(result);
    } else {
      shopping.updateItemName(item, result);
    }
  }

  Widget _buildItem(ShoppingItem item) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: CheckboxListTile(
        value: item.isBought,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          context.read<ShoppingProvider>().toggleBought(item, value ?? false);
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
                context.read<ShoppingProvider>().removeItem(item);
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
    final shopping = context.watch<ShoppingProvider>();

    final toBuy = shopping.toBuyItems;
    final bought = shopping.boughtItems;

    final showToBuy = _filter != ShoppingFilter.bought;
    final showBought = _filter != ShoppingFilter.toBuy;
    final visibleCount =
        (showToBuy ? toBuy.length : 0) + (showBought ? bought.length : 0);

    Widget content;
    if (!shopping.isLoaded) {
      content = const Center(child: CircularProgressIndicator());
    } else if (shopping.items.isEmpty) {
      content = Center(
        child: Text('Your list is empty', style: textTheme.bodySmall),
      );
    } else {
      content = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<ShoppingFilter>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: ShoppingFilter.all, label: Text('All')),
                  ButtonSegment(
                    value: ShoppingFilter.toBuy,
                    label: Text('To buy'),
                  ),
                  ButtonSegment(
                    value: ShoppingFilter.bought,
                    label: Text('Bought'),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (selection) {
                  setState(() {
                    _filter = selection.first;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: visibleCount == 0
                ? Center(
                    child: Text(
                      'No items in this filter',
                      style: textTheme.bodySmall,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                    children: [
                      if (showToBuy) ...[
                        Text(
                          'To buy (${toBuy.length})',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...toBuy.map(_buildItem),
                      ],
                      if (showToBuy && showBought) const SizedBox(height: 24),
                      if (showBought) ...[
                        Text(
                          'Bought (${bought.length})',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...bought.map(_buildItem),
                      ],
                    ],
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping list')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        onPressed: () => _showItemDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: SafeArea(child: content),
    );
  }
}
