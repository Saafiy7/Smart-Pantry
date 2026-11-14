import 'package:flutter/material.dart';
import 'package:smart_pantry/core/theme/app_colors.dart';
import 'package:smart_pantry/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String get _formattedDate {
    final d = product.expirationDate;
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';
  }

  int get _daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return product.expirationDate.difference(today).inDays;
  }

  String get _expiryText {
    if (_daysLeft < 0) return 'Expired';
    if (_daysLeft == 0) return 'Expires today';
    return 'Expires in $_daysLeft days';
  }

  String get _quantityText {
    final qty = product.quantity % 1 == 0
        ? product.quantity.toInt().toString()
        : product.quantity.toString();
    return '$qty ${product.unit}';
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                        Text(product.name, style: textTheme.titleMedium),
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
                            product.category,
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
                    _infoRow(context, 'Category', product.category),
                    _infoRow(context, 'Brand', product.brand),
                    _infoRow(context, 'Quantity', _quantityText),
                    _infoRow(context, 'Storage location', product.storageLocation),
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
                  Text(_formattedDate, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(_expiryText, style: textTheme.bodySmall),
                ],
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
              onPressed: () {},
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