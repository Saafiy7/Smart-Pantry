import 'package:flutter/material.dart';
import 'package:smart_pantry/data/donnees_fictives.dart';
import 'package:smart_pantry/widgets/product_card.dart';
import 'package:smart_pantry/screens/product_details/product_details_screen.dart';
import 'package:smart_pantry/screens/add_product/add_product_screen.dart';
import 'package:smart_pantry/models/product.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newProduct = await Navigator.push<Product>(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );

          if (newProduct == null || !context.mounted) return;

          setState(() {
            fakeProducts.add(newProduct);
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
                  itemCount: fakeProducts.length,
                  itemBuilder: (context, index) {
                    final product = fakeProducts[index];
                    return Padding(
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