import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pantry/providers/inventory_provider.dart';
import 'package:smart_pantry/widgets/product_card.dart';
import 'package:smart_pantry/screens/product_details/product_details_screen.dart';
import 'package:smart_pantry/screens/add_product/add_product_screen.dart';
import 'package:smart_pantry/models/product.dart';
import 'package:smart_pantry/services/preferences_service.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final products = context.watch<InventoryProvider>().products;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newProduct = await Navigator.push<Product>(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );

          if (newProduct == null || !context.mounted) return;

          setState(() {
            products.add(newProduct);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Received: ${newProduct.name}')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Products', style: textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('Manage your food inventory', style: textTheme.bodySmall),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}