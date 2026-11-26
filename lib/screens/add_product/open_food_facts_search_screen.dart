import 'package:flutter/material.dart';

import '../../models/food_info.dart';
import '../../services/open_food_facts_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class OpenFoodFactsSearchScreen extends StatefulWidget {
  const OpenFoodFactsSearchScreen({super.key});

  @override
  State<OpenFoodFactsSearchScreen> createState() =>
      _OpenFoodFactsSearchScreenState();
}

class _OpenFoodFactsSearchScreenState extends State<OpenFoodFactsSearchScreen> {
  final _queryController = TextEditingController();
  Future<List<FoodInfo>>? _searchFuture;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _queryController.text.trim();
    if (query.length < 2) return;

    setState(() {
      _searchFuture = OpenFoodFactsService.searchByName(query);
    });
  }

  Widget _buildMessage(IconData icon, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    const placeholder = Icon(Icons.shopping_basket_outlined);
    if (imageUrl == null) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }

  Widget _buildResults() {
    return FutureBuilder<List<FoodInfo>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return _buildMessage(
            Icons.search,
            'Type a product name to search Open Food Facts.',
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildMessage(
            Icons.wifi_off,
            'Could not reach Open Food Facts. Check your connection, '
            'or enter the product manually.',
          );
        }

        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return _buildMessage(
            Icons.search_off,
            'No product found. Try another name, or enter it manually.',
          );
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];
            return Card(
              child: ListTile(
                leading: _buildImage(product.imageUrl),
                title: Text(product.name),
                subtitle: product.brand.isEmpty ? null : Text(product.brand),
                onTap: () => Navigator.pop(context, product),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search a product')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomTextField(
                label: 'Product name',
                controller: _queryController,
                prefixIcon: Icons.search,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildResults()),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Enter manually',
                isSecondary: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
