import 'package:flutter/material.dart';
import 'package:smart_pantry/core/theme/app_colors.dart';
import 'package:smart_pantry/data/donnees_fictives.dart';
import 'package:smart_pantry/models/product.dart';
import 'package:smart_pantry/screens/product_details/product_details_screen.dart';
import 'package:smart_pantry/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const int _shoppingItemsCount = 5;

  int _daysLeft(Product product) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return product.expirationDate.difference(today).inDays;
  }

  Widget _statCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primaryGreen),
              const SizedBox(height: 8),
              Text(value, style: textTheme.headlineSmall),
              Text(label, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final expiringProducts =
        fakeProducts.where((product) => _daysLeft(product) <= 3).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, Youssef!', style: textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text("Let's manage your pantry today.", style: textTheme.bodySmall),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statCard(
                    context,
                    icon: Icons.inventory_2_outlined,
                    value: '${fakeProducts.length}',
                    label: 'Total Products',
                    color: AppColors.white,
                  ),
                  _statCard(
                    context,
                    icon: Icons.schedule,
                    value: '${expiringProducts.length}',
                    label: 'Expiring Soon',
                    color: AppColors.warningOrange.withValues(alpha: 0.15),
                  ),
                  _statCard(
                    context,
                    icon: Icons.shopping_cart_outlined,
                    value: '$_shoppingItemsCount',
                    label: 'Shopping Items',
                    color: AppColors.white,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Expiring Soon', style: textTheme.titleMedium),
                  TextButton(onPressed: () {}, child: const Text('See all')),
                ],
              ),
              const SizedBox(height: 8),
              for (final product in expiringProducts)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add Product'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.list),
                      label: const Text('Shopping List'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}