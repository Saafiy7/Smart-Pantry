import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pantry/core/theme/app_colors.dart';
import 'package:smart_pantry/models/product.dart';
import 'package:smart_pantry/providers/inventory_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _formattedDate(Product p) {
    final d = p.expirationDate;
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';
  }

  int _daysLeft(Product p) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return p.expirationDate.difference(today).inDays;
  }

  String _expiryText(Product p) {
    final days = _daysLeft(p);
    if (days < 0) return 'Expired';
    if (days == 0) return 'Expires today';
    return 'Expires in $days days';
  }

  String _quantityNumber(Product p) {
    return p.quantity % 1 == 0
        ? p.quantity.toInt().toString()
        : p.quantity.toString();
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodySmall),
          Text(value, style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Product live) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product'),
        content: Text('Delete ${live.name} from your pantry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.dangerRed),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final inventory = context.read<InventoryProvider>();
      Navigator.pop(context);
      inventory.deleteProduct(live.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final inventory = context.watch<InventoryProvider>();
    final matches = inventory.products.where((p) => p.id == product.id).toList();
    if (matches.isEmpty) return const Scaffold();
    final live = matches.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket_outlined,
                size: 48,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(live.name, style: textTheme.titleMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            live.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    _infoRow(context, 'Category', live.category),
                    _infoRow(context, 'Brand', live.brand),
                    _infoRow(
                      context,
                      'Quantity',
                      '${_quantityNumber(live)} ${live.unit}',
                    ),
                    _infoRow(context, 'Storage location', live.storageLocation),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expiration Date', style: textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(_formattedDate(live), style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(_expiryText(live), style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity in stock', style: textTheme.bodyMedium),
                    Row(
                      children: [
                        IconButton(
                          onPressed: live.quantity > 1
                              ? () => inventory.updateProduct(
                                    live.copyWith(quantity: live.quantity - 1),
                                  )
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppColors.primaryGreen,
                        ),
                        Text(_quantityNumber(live), style: textTheme.titleMedium),
                        IconButton(
                          onPressed: () => inventory.updateProduct(
                            live.copyWith(quantity: live.quantity + 1),
                          ),
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppColors.primaryGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Product'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _confirmDelete(context, live),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Product'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.dangerRed,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}