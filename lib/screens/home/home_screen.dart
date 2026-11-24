import 'package:flutter/material.dart';
import 'package:smart_pantry/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_pantry/providers/inventory_provider.dart';
import 'package:smart_pantry/models/product.dart';
import 'package:smart_pantry/screens/product_details/product_details_screen.dart';
import 'package:smart_pantry/widgets/product_card.dart';
import 'package:smart_pantry/screens/add_product/add_product_screen.dart';
import 'package:smart_pantry/widgets/section_title.dart';
import 'package:smart_pantry/providers/shopping_provider.dart';
import 'package:smart_pantry/services/preferences_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAllProducts;
  final VoidCallback onOpenShoppingList;

  const HomeScreen({
    super.key,
    required this.onSeeAllProducts,
    required this.onOpenShoppingList,
  });

  int _daysLeft(Product product) {
    final today = DateTime.now();
    final expirationDate = product.expirationDate;
    return DateTime(
      expirationDate.year,
      expirationDate.month,
      expirationDate.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
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
    final shoppingCount = context.watch<ShoppingProvider>().toBuyCount;
    final products = context.watch<InventoryProvider>().products;
    final expiringProducts = products
        .where((product) => _daysLeft(product) <= 3)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, Youssef!', style: textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                "Let's manage your pantry today.",
                style: textTheme.bodySmall,
              ),
              FutureBuilder<String?>(
                future: PreferencesService.getLastViewed(),
                builder: (context, snapshot) {
                  final name = snapshot.data;
                  if (name == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Last viewed: $name', style: textTheme.bodySmall),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statCard(
                    context,
                    icon: Icons.inventory_2_outlined,
                    value: '${products.length}',
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
                    value: '$shoppingCount',
                    label: 'Shopping Items',
                    color: AppColors.white,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: 'Expiring Soon',
                actionLabel: 'See all',
                onAction: () {},
              ),
              const SizedBox(height: 8),
              for (final product in expiringProducts)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProductCard(
                    product: product,
                    onTap: () {
                      PreferencesService.saveLastViewed(product.name);
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
                      onPressed: () async {
                        final newProduct = await Navigator.push<Product>(
                          context,
                          MaterialPageRoute(builder: (context) => const AddProductScreen()),
                        );
                        if (newProduct != null && context.mounted) {
                          context.read<InventoryProvider>().addProduct(newProduct);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Product'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenShoppingList,
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
