import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _dateController = TextEditingController();

  final List<String> _categories = [
    'Dairy',
    'Fruits & Vegetables',
    'Meat & Fish',
    'Drinks',
    'Pantry',
    'Other',
  ];
  String _selectedCategory = 'Dairy';

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add product')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(
                  label: 'Search with Open Food Facts',
                  icon: Icons.search,
                  isSecondary: true,
                  onPressed: () {}, // connected in J2
                ),
                const SizedBox(height: 24),
                Text('Product information', style: textTheme.titleMedium),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Product name',
                  controller: _nameController,
                  prefixIcon: Icons.shopping_basket_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Brand (optional)',
                  controller: _brandController,
                  prefixIcon: Icons.sell_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Quantity',
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.numbers,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Expiration date',
                  controller: _dateController,
                  readOnly: true,
                  prefixIcon: Icons.calendar_today_outlined,
                  onTap: () {}, // DatePicker in J2
                ),
                const SizedBox(height: 24),
                Text('Category', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      selectedColor: AppColors.lightGreen,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Save product',
                  onPressed: () {}, // validation + result in J2
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
