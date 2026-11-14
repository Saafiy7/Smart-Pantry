import 'package:flutter/material.dart';
import 'package:smart_pantry/data/donnees_fictives.dart';
import 'package:smart_pantry/widgets/product_card.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                      child: ProductCard(product: product, onTap: () {}),
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